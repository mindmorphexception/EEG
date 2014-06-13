function ComputePowSpectra()
    clc;
    eeglab;
    clear all;
    
    %free = java.lang.Runtime.getRuntime.maxMemory / (2^30)   

    % process each file
    for i = 16:16
        tic
        ProcessFile(i);
        toc
    end

    fprintf('Done.\n');
end
    
function ProcessFile(i)

    LoadFolderNames;    
    LoadParams;   
    
    % construct the first and last samples to read from file
    filename = data{i,1};
    fileFirstSample = data{i,2};
    fileLastSample = 100000; %data{i,3}; %2000000 + 3600 * data{i,4} - 1;
    
    if(fileLastSample > data{i,3})
        return;
    end

    actualSrate = data{i,4};
    fprintf('Reading %f hours of file %s\n', (fileLastSample - fileFirstSample + 1) / (actualSrate * 60 * 60), [folderData filename]);

    % read file chunks 
    sampleIndices = fileFirstSample : fileChunkSamples : fileLastSample;
    
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
        %fprintf('*** Rereferencing...\n');
        %eeglabSet = rereference(eeglabSet,1);

        % filter data between 1 and 35 Hz
        % eeglabSet = pop_eegfilt(eeglabSet,0,35);
        % eeglabSet = pop_eegfilt(eeglabSet,1,0);
        
        nrEpochs = floor ( length(eeglabSet.times) / epochSizeSamples );
        if nrEpochs < 1
            fprintf('*** Skipping this part - less than 1 epoch possible\n');
            continue;
        end
        
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
               
        % convert to fieltrip format
%         fprintf('*** Creating fieldtrip set...\n');
%         fieldtripSet = eeglab2fieldtrip(eeglabSet, 'preprocessing', 'none');
% 
%         % manually make sampleinfo to deflect warnings
%         fieldtripSet.sampleinfo = zeros(length(fieldtripSet.trial), 2);
%         for epoch = 1:length(fieldtripSet.trial)
%             fieldtripSet.sampleinfo(epoch,:) = [epochSizeSamples*(epoch-1)+1 epochSizeSamples*epoch];
%         end
% 
%         % freq analysis => pow-spectrum
%         fprintf('*** Performing freqanalysis...\n');
%         freq0{sampleIndex} = ft_freqanalysis(freqCfg, fieldtripSet);
% 
%         % free up some memory
%         clear eeglabSet fieldtripSet;
        toc
    end
    
    

    % set up freqStruct for the whole file
%     clear freqStruct;
%     
%     freqStruct.totalEpochs = floor((fileLastSample - fileFirstSample + 1) / (epochSizeSamples * (actualSrate / srate)) );
%     freqStruct.epochIndex = 1;
%     ft_progress('init', 'text', '*** Appending all pow-spectra...');
%     for sampleIndex = 1:length(freq0)
%         % append pow-spectra to the freqStruct of this file
%         freqStruct = AppendPowSpectra(freqStruct, freq0{sampleIndex}, 1);
%         ft_progress(sampleIndex/length(freq0));
%     end
%     ft_progress('close');
    %fprintf('*** Saving pow-spectra...\n');
    newfilename = filename(1:length(filename)-14);
    %save([folderPowspec 'pow_spectra1_' newfilename '.mat'], 'freqStruct'); 
    
    fprintf('*** Saving std devs...\n');
    save([folderStdDev 'stddev_' newfilename '.mat'], 'stddevs'); 

end