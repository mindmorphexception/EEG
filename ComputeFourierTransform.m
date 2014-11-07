
function ComputeFourierTransform(i)

    AddPaths;
    eeglab;
    clearvars -except i;

    LoadFolderNames;
    LoadParams;    
    
    % get filename and extract patient and night nr
    filename = data{i,1};
    [patientnr, nightnr] = GetPatientNightNr(i);
    
    % construct the first and last samples to read from file
    fileFirstSample = data{i,2};
    fileLastSample = data{i,3};
    
    % store srate and thresholds
    actualSrate = data{i,4};
    
    fprintf('Reading %f hours of file %s\n', (fileLastSample - fileFirstSample + 1) / (actualSrate * 60 * 60), filename);

    % load an eeglab set
    eeglabSet = pop_readegimff([folderData filename], 'firstsample', fileFirstSample, 'lastsample', fileLastSample);

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

    % freq analysis => pow-spectrum
    fprintf('*** Performing freqanalysis...\n');

    crtFreqCfg = freqCfg;
    crtFreqCfg.output = 'fourier';

    freqStruct = ft_freqanalysis(crtFreqCfg, fieldtripSet);
    save([folderFourier 'fourier_p' int2str(patientnr) '_overnight' int2str(nightnr)], 'freqStruct');

end