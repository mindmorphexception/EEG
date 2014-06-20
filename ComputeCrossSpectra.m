function ComputeCrossSpectra(index)
    clc;
    
    AddPaths;
    eeglab;
    clearvars -except index;
    
    fprintf('*** Java memory is %f\n', java.lang.Runtime.getRuntime.maxMemory / (2^30));   

    % process each file
    ProcessFile(index);

    fprintf('Done.\n');
end
    
function ProcessFile(i)

    LoadFolderNames;
    
    % we need to declare the vars defined in different files
    % in order to see them on parallel workers
            % data params
            srate = 0;
            epochSizeSeconds = 0; % split data into epochs of 10 seconds
            epochSizeSamples = 0; % the number of samples per epoch
            fileChunkSamples = 0; % how many samples to read from file at one time
            chanExcluded = []; % excluded chans            
            freqCfg = []; % freq analysis configuration
    %
    
    LoadParams;    
    
    % construct the first and last samples to read from file
    filename = data{i,1};
    
    [patientnr, nightnr] = GetPatientNightNr(i);
    
    fileFirstSample = data{i,2};
    fileLastSample = data{i,3}; %2000000 + 3600 * data{i,4} - 1;
    
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

        % filter data above 0.09 Hz
        % eeglabSet = pop_eegfilt(eeglabSet,0,35);
        % eeglabSet = pop_eegfilt(eeglabSet,0.09,0);
        
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
        
        % interpolate noisy channels in each epoch
        fprintf('*** Interpolating... (field ordering error is not important)\n');
        for e = 1:eeglabSet.trials
            
            if (sum(noisiness(:,e)) > 0 && ... % if there are any bad channels
                sum(noisiness(:,e)) < thresholdBadChansPerEpochs * eeglabSet.nbchan) % and not all chans are bad
                
                % make a new eeglabset
                epochSet = [];
                epochSet.setname = ['Set for epoch ' num2str(e)];
                epochSet.srate = eeglabSet.srate;
                epochSet.nbchan = eeglabSet.nbchan;
                epochSet.times = eeglabSet.times;
                epochSet.trials = 1;
                epochSet.event = [];
                epochSet.xmin = eeglabSet.xmin;
                epochSet.xmax = eeglabSet.xmax;
                epochSet.chanlocs = eeglabSet.chanlocs;
                epochSet.chaninfo = eeglabSet.chaninfo;
                epochSet.data = eeglabSet.data(:,:,e);
                epochSet.etc = [];
                epochSet.icaact = [];
                epochSet.epoch = [];
                epochSet.specdata = [];
                epochSet.icachansind = [];
                epochSet.icawinv = [];
                epochSet.specicaact = [];
                epochSet.icasphere = [];
                epochSet.specicaact = [];
                epochSet.icaweights = [];
                
                % interpolate
                epochSet = pop_interp(epochSet, find(noisiness(:,e) > 0), 'spherical');
                eeglabSet.data(:,:,e) = epochSet.data;
            end
        end
        
        % rereference
        fprintf('*** Rereferencing...\n');
        eeglabSet = rereference(eeglabSet,1);
        
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

        %freqStruct.totalEpochs = floor((fileLastSample - fileFirstSample + 1) / (epochSizeSamples * (actualSrate / srate)) );
        %freqStruct.epochIndex = 1;
        %clear freqStruct;
        
        freqStruct = ft_freqanalysis(crtFreqCfg, fieldtripSet);

        ComputeWpli(freqStruct, filename(1:length(filename)-14), patientnr, nightnr);

        %fprintf('*** Saving cross-spectra...\n');  
        %newfilename = [filename(1:length(filename)-14) '_' num2str(sampleIndex)];
        %save([folderPowspec 'pow_spectra_' newfilename '.mat'], 'freqStruct'); 

        % free up some memory
        clear eeglabSet fieldtripSet;
    end
    
%     fprintf('*** Appending all pow-spectra...\n');
% 
%     % set up freqStruct for the whole file
%     clear freqStruct;
%     freqStruct.totalEpochs = floor((fileLastSample - fileFirstSample + 1) / (epochSizeSamples * (actualSrate / srate)) );
%     freqStruct.epochIndex = 1;
%     ft_progress('init', 'text', 'Please wait...');
%     for sampleIndex = 1:length(sampleIndices)
%         % append cross-spectra to the freqStruct of this file
%         freqStruct = AppendCrossSpectra(freqStruct, freq0{sampleIndex}, 1);
%         
%         ft_progress(sampleIndex/length(sampleIndices));
%     end
%     ft_progress('close');
%     fprintf('*** Saving pow-spectra...\n');
%     save([crsspctrFolder 'cross_spectra_' newfilename '.mat'], 'freqStruct', '-v7.3'); 
%       
%     clear freqStruct freq0;

end