
      
    fprintf('*** Java memory is %f\n', java.lang.Runtime.getRuntime.maxMemory / (2^30));   

    %LoadFolderNames;
    LoadParams;
    folderData = '/imaging/sc03/Iulia/Sedation/datasets_restingstate/';
    folderDataSets = '/imaging/sc03/Iulia/Sedation/sets/';
    folderStdDev = '/imaging/sc03/Iulia/Sedation/stddev/';
   
    stddevs = [];
        
    fprintf('*** Generating std dev matrix.\n');

    % get file index 
    patientnr = 6;
    nightnr = 1;

    % construct the first and last samples to read from file, cleaning throsholds
    filename = '06-2010-anest 20100224 0939.mff_rs1.set';
    
    actualSrate = 250
    thresholdChannelStdDev = 0.1;
    thresholdBadChansPerEpochs = 0.1;


    % load an eeglab set
    eeglabSet = pop_loadset('filename',filename,'filepath',folderData);

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

    % filter data 
    eeglabSet = pop_eegfiltnew(eeglabSet, 0.5, 25);
    
    % save set
    eeglabSet = pop_saveset(eeglabSet, 'filename', [filename '_precleanwithevents.set'], 'filepath', folderDataSets);

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

    % remove baseline
    eeglabSet  = pop_rmbase(eeglabSet, []);

    % save set
    eeglabSet = pop_saveset(eeglabSet, 'filename', [filename '_preclean.set'], 'filepath', folderDataSets);

    % calculate stddev for channels/epochs
    fprintf('*** Calculating std devs...\n');
    for i = 1:size(eeglabSet.data,3)
        stddevs = [stddevs std(eeglabSet.data(:,:,i),0,2)];
    end

    % save stddevs
    stddevfilename = [folderStdDev 'stddev_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'];
    save(stddevfilename,'stddevs');
    
    % load noisiness matrix
    [~, noisinessMatrix] = MarkNoisyData(patientnr, nightnr);

    % interpolate noisy channels in each epoch
    fprintf('*** Interpolating... (field ordering error is not important)\n');
    for e = 1:eeglabSet.trials

        if (sum(noisinessMatrix(:,e)) > 0 && ... % if there are any bad channels
            sum(noisinessMatrix(:,e)) <= thresholdBadChansPerEpochs * eeglabSet.nbchan) % and not all chans are bad

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
            epochSet = pop_interp(epochSet, find(noisinessMatrix(:,e) > 0), 'spherical');
            eeglabSet.data(:,:,e) = epochSet.data;
        end
    end

    % rereference
    fprintf('*** Rereferencing...\n');
    eeglabSet = rereference(eeglabSet,1);

    % save set
    eeglabSet = pop_saveset(eeglabSet, 'filename', [filename '_postclean.set'], 'filepath', folderDataSets);

    eeglabSet = pop_loadset('filename', [filename '_postclean.set'], 'filepath', folderDataSets);

    % convert to fieltrip format
    fprintf('*** Creating fieldtrip set...\n');
    fieldtripSet = eeglab2fieldtrip(eeglabSet, 'preprocessing', 'none');

    % manually make sampleinfo to deflect warnings
    fieldtripSet.sampleinfo = zeros(length(fieldtripSet.trial), 2);
    for epoch = 1:length(fieldtripSet.trial)
        fieldtripSet.sampleinfo(epoch,:) = [epochSizeSamples*(epoch-1)+1 epochSizeSamples*epoch];
    end

    save([folderDataSets filename '_fieldtrip.mat'], 'fieldtripSet', '-v7.3');

    
    fprintf('Done.\n');




