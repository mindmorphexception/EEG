function ComputeCrossSpectra()
    clc;
    
    %free = java.lang.Runtime.getRuntime.maxMemory / (2^30)   

    % process each file
    for i = 16:18
        tic
        ProcessFile(i);
        toc
    end

    fprintf('Done.\n');
end
    
function ProcessFile(i)

    % input
    
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

            % excluded chans
            chanExcluded = [];

            % freq analysis configuration
            freqCfg = [];
    %  %%%
    
    LoadParams;   

    % {filename firstsample lastsample} mark data where there are no events
    % besides 'sync' and 'break cnt'
    
    data = [
        
    {'p10_overnight1 20120910 1813'}, 1, 12585377, 250;
{'p10_overnight2 20120912 1812'}, 1, 5798676, 250;
{'p11_overnight1 20121009 1845'}, 1, 10943039, 250;
{'p11_overnight2 20121012 1813'}, 1, 12413599, 250;
{'p12_overnight1 20121022 1813'}, 1, 12565973, 250;
{'p13_overnight1 20121023 1829'}, 1, 1380914, 250;
{'p13_overnight2 20121025 1951'}, 1, 11434241, 250;
{'p14_overnight1 20121105 1835'}, 1, 12576836, 250;
{'p15_overnight1 20121119 1812'}, 1, 12577933, 250;
{'p15_overnight2 20121126 1901'}, 1, 1138596, 250;
{'p16_overnight1 20121121 1807'}, 1, 12025874, 250;
{'p16_overnight2 20121129 2019'}, 1, 10998327, 250;
{'p17_overnight1 20130221 1816'}, 1, 10855403, 250;
{'p17_overnight2 20130225 1841'}, 1, 1529856, 250;
{'p1_overnight1 20120502 1710'}, 1, 8549219, 250;
{'p2_overnight1 20120525 1549'}, 1, 25001068, 500;
{'p2_overnight2 20120529 1754'}, 1, 24705890, 500;
{'p2_overnight3 20120613 1752'}, 1, 23565161, 500;
{'p3_overnight1 20120627 2003'}, 1, 25092897, 500;
{'p3_overnight2 20120702 1142'}, 1, 5214937, 500;
{'p4_overnight1 20120703 2345'}, 1, 13989813, 500;
{'p4_overnight_1_short 20120703 1645'}, 1, 6915828, 500;
{'p5_overnight1 20120705 1814'}, 1, 23016851, 500;
{'p5_overnight2 20120711 1703'}, 1, 12584885, 250;
{'p6_overnight1 20120709 1926'}, 1, 24654984, 500;
{'p6_overnight2 20120716 1942'}, 1, 5252471, 250;
{'p7_overnight1 20120723 1823'}, 1, 12032156, 250;
{'p7_overnight2 20120730 1741'}, 1, 12594817, 250;
{'p8_overnight1 20120806 1859'}, 1, 12131768, 250;
{'p9_overnight1 20120904 1756'}, 1, 735555, 250;
%      {'p2_overnight1 20120525 1549'}, 2000000, 2000000 + 3600*500 + cooldown - 1, 500;   % 1 hour of data at 500 sampl rate
        ];
    
    % constants
    EPOCH_EVENT_NAME = 'NEW_EPOCH_EVENT'; 
    
    % construct the first and last samples to read from file
    filename = data{i,1};
    fileFirstSample = data{i,2};
    fileLastSample = 600000; %data{i,3}; %2000000 + 3600 * data{i,4} - 1;
    
    if(fileLastSample > data{i,3})
        return;
    end

    actualSrate = data{i,4};
    fprintf('Reading %f hours of file %s\n', (fileLastSample - fileFirstSample + 1) / (actualSrate * 60 * 60), filename);

    % read file chunks 
    sampleIndices = fileFirstSample : fileChunkSamples : fileLastSample;

    for sampleIndex = 1 : length(sampleIndices)
        
        fprintf('*** This is worker %d out of %d starting!\n',sampleIndex, length(sampleIndices));
        
        chunkFirstSample = sampleIndices(sampleIndex);

        % load an eeglab set
        chunkLastSample = min(chunkFirstSample + fileChunkSamples - 1, fileLastSample);
        eeglabSet = pop_readegimff([folderCrossSpectra filename], 'firstsample', chunkFirstSample, 'lastsample', chunkLastSample);

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


        % TODO: FIX REJECTION
        % reject (includes rereferencing to common)
        % eeglabSet = rejartifacts3(eeglabSet,3,1);

        % save chanlocs
        %  chanlocs = eeglabSet.chanlocs;
        %  save chanlocs chanlocs;

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
        %for lowfreq = 1:19
            %fprintf('Frequency %d...\n', lowfreq);
            crtFreqCfg = freqCfg;
            %crtFreqCfg.foi = lowfreq:0.1:lowfreq+0.9;
            %freq0{sampleIndex} = ft_freqanalysis(crtFreqCfg, fieldtripSet);
            
            freqStruct.totalEpochs = floor((fileLastSample - fileFirstSample + 1) / (epochSizeSamples * (actualSrate / srate)) );
            freqStruct.epochIndex = 1;
            clear freqStruct;
            freqStruct = ft_freqanalysis(crtFreqCfg, fieldtripSet);
            
            ComputeWpli(freqStruct, filename(1:length(filename)-14));
            
            %fprintf('*** Saving pow-spectra...\n');
            %newfilename = [num2str(lowfreq) 'hz_' filename(1:length(filename)-14) '_' num2str(sampleIndex)];
            %newfilename = [filename(1:length(filename)-14) '_' num2str(sampleIndex)];
            %save([crsspctrFolder 'cross_spectra1_' newfilename '.mat'], 'freqStruct'); 
        %end

        % free up some memory
        clear eeglabSet fieldtripSet;
    end
    
%    fprintf('*** Appending all cross-spectra...\n');
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
%     fprintf('*** Saving cross-spectra...\n');
%     save([crsspctrFolder 'cross_spectra_' newfilename '.mat'], 'freqStruct', '-v7.3'); 
%       
%     clear freqStruct freq0;
end