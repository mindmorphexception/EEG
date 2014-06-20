function [stddevs, noisinessMatrix] = MarkNoisyData(patientnr, nightnr)
 
    LoadFolderNames;
    LoadParams;
   
    % load or generate std dev matrix
    stddevfilename = [folderStdDev 'stddev_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'];
    
    if (exist(stddevfilename, 'file'))
       
        fprintf('*** Loading std dev matrix.\n');
        load(stddevfilename);
        
    else
        
        fprintf('*** Generating std dev matrix.\n');
        
        % get file index 
        i = GetPatientIndex(patientnr, nightnr); 

        % construct the first and last samples to read from file
        filename = data{i,1};
        fileFirstSample = data{i,2};
        fileLastSample = data{i,3};
        actualSrate = data{i,4};

        fprintf('Reading %f hours of file %s\n', (fileLastSample - fileFirstSample + 1) / (actualSrate * 60 * 60), filename);

        % read file chunks 
        sampleIndices = fileFirstSample : fileChunkSamples : fileLastSample;

        % stddevs will keep the channel variance per epoch
        stddevs = [];

        for sampleIndex = 1 : length(sampleIndices)

            fprintf('*** This is pass %d out of %d starting!\n', sampleIndex, length(sampleIndices));

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
        end
        save(stddevfilename,'stddevs');
    end
    
    noisinessMatrixFilename = [folderStdDev 'noisiness_matrix_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'];
    
    % load thresholds and nrchans
    thresholdChanStdDev = GetThresholdChannelStdDev(patientnr, nightnr);
    thresholdBadChansPerEpoch = GetThresholdBadChansPerEpoch(patientnr, nightnr);
    nrChans = size(stddevs,1);
    
    fprintf('*** Generating noisiness matrix.\n');
    noisinessMatrix = zeros(size(stddevs));
    
    % mark bad channels
    fprintf('*** Channel threshold is %f.\n', thresholdChanStdDev);
    badChanIndices = stddevs >= thresholdChanStdDev;
    noisinessMatrix(badChanIndices) = 1;
    
    % mark bad epochs
    %badEpochIndices = sum(noisinessMatrix,1) > thresholdBadChansPerEpoch * nrChans;
    %fprintf('*** Marking %d (%f%%) epochs as bad.\n',sum(badEpochIndices), sum(badEpochIndices)/length(badEpochIndices));
    %noisinessMatrix(:, badEpochIndices) = 1;
    %save(noisinessMatrixFilename,'noisinessMatrix');
    
    fprintf('Done.\n');
end




