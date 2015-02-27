function ComputeCrossSpectra(index)
    clc;
    
    AddPaths;
    eeglab;
    clearvars -except index;
    
    fprintf('*** Java memory is %f\n', java.lang.Runtime.getRuntime.maxMemory / (2^30));   

    % process file
    ProcessFile(index);

    fprintf('Done.\n');
end
    
function ProcessFile(i)

    LoadFolderNames;
    LoadParams;    
    
    % get filename and extract patient and night nr
    filename = data{i,1};
    [patientnr, nightnr] = GetPatientNightNr(i);
    
    % construct the first and last samples to read from file
    fileFirstSample = data{i,2};
    fileLastSample = data{i,3};
    
    % don't process if cleaning thresholds not set
    if isnan(data{i,5})
        return;
    end
    
    % store srate and thresholds
    actualSrate = data{i,4};
    thresholdChannelStdDev = data{i,5};
    thresholdBadChansPerEpochs = data{i,6};
    
    % load stddevs and noisiness
    [~, noisiness] = MarkNoisyData(patientnr, nightnr);
    
    fprintf('Reading %f hours of file %s\n', (fileLastSample - fileFirstSample + 1) / (actualSrate * 60 * 60), filename);

    % read file chunks 
    sampleIndices = fileFirstSample : fileChunkSamples : fileLastSample;

    for sampleIndex = 1 : length(sampleIndices)
        fprintf('*** This is worker %d out of %d starting!\n',sampleIndex, length(sampleIndices));
        
        chunkFirstSample = sampleIndices(sampleIndex);

        % load an eeglab set
        chunkLastSample = min(chunkFirstSample + fileChunkSamples - 1, fileLastSample);
        eeglabSet = pop_readegimff([folderData filename], 'firstsample', chunkFirstSample, 'lastsample', chunkLastSample);

        % remove channels we don't want to see
        fprintf('*** Selecting channels...\n');
        eeglabSet = pop_select(eeglabSet, 'nochannel', chanExcluded);

        % make sure the sampling rate is the one we want
        if(actualSrate ~= eeglabSet.srate)
            error('unexpected sampling rate');
        elseif(eeglabSet.srate > srate)
            eeglabSet = pop_resample(eeglabSet, 250);
        elseif(eeglabSet.srate < srate)
            error('too small sampling rate');
        end

        % filter data between 0.05 and 21 Hz
        % eeglabSet = pop_eegfilt(eeglabSet,0,21);
        % eeglabSet = pop_eegfilt(eeglabSet,1,0);
        
        % create events for epoching
        nrEpochs = floor ( length(eeglabSet.times) / epochSizeSamples );
        ft_progress('init', 'text', '*** Creating events...');
        events = cell(nrEpochs,2);
        for epochIndex = 1 : nrEpochs
            newlatency = (epochIndex-1) * epochSizeSeconds;
            events{epochIndex,2} = newlatency;
            events{epochIndex,1} = EPOCH_EVENT_NAME;
            ft_progress(epochIndex/nrEpochs);
        end
        ft_progress('close');
        eeglabSet = pop_importevent(eeglabSet, 'event', events, 'fields', {'type','latency'}, 'append', 'no');

        % epoch the data 
        fprintf('*** Epoching...\n');
        eeglabSet = pop_epoch(eeglabSet, {EPOCH_EVENT_NAME}, [0 epochSizeSeconds]);
        
        
        
        % rereference
        %fprintf('*** Rereferencing...\n');
        %eeglabSet = rereference(eeglabSet,1);
        
        pop_saveset(eeglabSet,'filepath','/home/sc03/Iulia/Iulia/Stein_pow','filename',int2str(i));
       
    end
  

end