function ComputeCrossSpectra()
    clc;
    
    %free = java.lang.Runtime.getRuntime.maxMemory / (2^30)   

    % process each file
    for i = 1:30
        tic
        ProcessFile(i);
        toc
    end

    fprintf('Done.\n');
end
    
function ProcessFile(i)

    % output
    LoadFolderNames;
    
    % we need to declare the vars defined in different files
    % in order to see them on parallel workers
    %  %%%
            % data params
            srate = 0;
            epochSizeSeconds = 0; % split data into epochs of 10 seconds
            epochSizeSamples = 0; % the number of samples per epoch
            fileChunkSamples = 0; % how many samples to read from file at one time
            chanExcluded = []; % excluded chans            
            freqCfg = []; % freq analysis configuration
    %  %%%
    
    LoadParams;   

    % {filename firstsample lastsample} mark data where there are no events
    % besides 'sync' and 'break cnt'
    
    
    % constants
    EPOCH_EVENT_NAME = 'NEW_EPOCH_EVENT'; 
    
    % construct the first and last samples to read from file
    filename = data{i,1};
    fileFirstSample = data{i,2};
    fileLastSample = data{i,3}; %2000000 + 3600 * data{i,4} - 1;
    
    if(fileLastSample > data{i,3})
        return;
    end

    actualSrate = data{i,4};
    fprintf('Reading %f hours of file %s\n', (fileLastSample - fileFirstSample + 1) / (actualSrate * 60 * 60), filename);

    % read file chunks 
    sampleIndices = fileFirstSample : fileChunkSamples : fileLastSample;
    
    % stddevs will keep the channel variance per epoch
    stddevs = [];

    for sampleIndex = 1 : length(sampleIndices)
        tic
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

        % rereference
        fprintf('*** Rereferencing...\n');
        eeglabSet = rereference(eeglabSet,1);

        % filter data between 1 and 35 Hz
        % eeglabSet = pop_eegfilt(eeglabSet,0,35);
        % eeglabSet = pop_eegfilt(eeglabSet,1,0);
        
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
        
        fprintf('*** Calculating std devs...\n');
        % calculate stddev for channels/epochs
        for i = 1:size(eeglabSet.data,3)
            stddevs = [stddevs std(eeglabSet.data(:,:,i),0,2)];
        end
               
        % TODO: FIX REJECTION
        % reject (includes rereferencing to common)
        % eeglabSet = rejartifacts3(eeglabSet,3,1);

        % convert to fieltrip format
        fprintf('*** Creating fieldtrip set...\n');
        fieldtripSet = eeglab2fieldtrip(eeglabSet, 'preprocessing', 'none');

        % manually make sampleinfo to deflect warnings
        fieldtripSet.sampleinfo = zeros(length(fieldtripSet.trial), 2);
        for epoch = 1:length(fieldtripSet.trial)
            fieldtripSet.sampleinfo(epoch,:) = [epochSizeSamples*(epoch-1)+1 epochSizeSamples*epoch];
        end

        % freq analysis => cross-spectrum
        fprintf('*** Performing freqanalysis...\n');
       
        crtFreqCfg = freqCfg;

        freq0{sampleIndex} = ft_freqanalysis(crtFreqCfg, fieldtripSet);

        %freqStruct.totalEpochs = floor((fileLastSample - fileFirstSample + 1) / (epochSizeSamples * (actualSrate / srate)) );
        %freqStruct.epochIndex = 1;
        %clear freqStruct;
        %freqStruct = ft_freqanalysis(crtFreqCfg, fieldtripSet);

        %ComputeWpli(freqStruct, filename(1:length(filename)-14));

        %fprintf('*** Saving pow-spectra...\n');  
        %newfilename = [filename(1:length(filename)-14) '_' num2str(sampleIndex)];
        %save([folderPowspec 'pow_spectra_' newfilename '.mat'], 'freqStruct'); 

        % free up some memory
        clear eeglabSet fieldtripSet;
        toc
    end
    
    fprintf('*** Appending all pow-spectra...\n');

    % set up freqStruct for the whole file
    clear freqStruct;
    freqStruct.totalEpochs = floor((fileLastSample - fileFirstSample + 1) / (epochSizeSamples * (actualSrate / srate)) );
    freqStruct.epochIndex = 1;
    ft_progress('init', 'text', 'Please wait...');
    for sampleIndex = 1:length(sampleIndices)
        % append cross-spectra to the freqStruct of this file
        freqStruct = AppendCrossSpectra(freqStruct, freq0{sampleIndex}, 1);
        
        ft_progress(sampleIndex/length(sampleIndices));
    end
    ft_progress('close');
    fprintf('*** Saving pow-spectra...\n');
    save([crsspctrFolder 'cross_spectra_' newfilename '.mat'], 'freqStruct', '-v7.3'); 
      
    clear freqStruct freq0;

    fprintf('*** Saving std devs...\n');
    stddevfilename = filename(1:length(filename)-14);
    save([stddevFolder 'stddev_' stddevfilename '.mat'], 'stddevs'); 

end