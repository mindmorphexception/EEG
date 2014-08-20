function [connectivityStruct, mymatrix] = ComputeWpli(freqStruct, basename, patientnr, nightnr, varargin)

% Computes the WPLI using the fieldtrip toolbox.
% If freqStruct is empty, it will be loaded from 'basename' file.

    LoadFolderNames;
    LoadParams;

    % if the struct is empty, load it from file
    if(isempty(freqStruct))
        fprintf('Loading freqStruct...');
        load([folderCrossSpectra 'cross_spectra_' basename],'freqStruct');
        fprintf('Done.\n');
    end
    
    [~, noisiness] = MarkNoisyData(patientnr, nightnr);
    

    % initialize things
    nrEpochs = size(freqStruct.crsspctrm, 1); % total nr of epochs
    nrWindows = floor((nrEpochs - processingWindow)/windowOverlap)+1;
    connectivityStruct = cell(1, nrWindows);
    mymatrix = cell(length(freqStruct.freq), nrWindows);
    fprintf('Expecting %d windows\n', length(connectivityStruct));
    nr_freq = length(freqStruct.freq);
    thresholdBadChansPerEpoch = GetThresholdBadChansPerEpoch(patientnr, nightnr) * size(noisiness,1);
    thresholdBadEpochsPerWpli = GetThresholdBadEpochsPerWpli(patientnr, nightnr) * processingWindow;
    
    % make a new freq struct as a template for wpli function calls
    crtFreqStruct.label = freqStruct.label;
    crtFreqStruct.dimord = freqStruct.dimord;
    crtFreqStruct.freq = freqStruct.freq;
    crtFreqStruct.labelcmb = freqStruct.labelcmb;
    crtFreqStruct.elec = freqStruct.elec;
    crtFreqStruct.cfg = freqStruct.cfg;
    
    % validate nr of windows
    fprintf('*** Computing number of windows...\n');
    endOfIndex = 0;
    for firstEpoch = 1 : windowOverlap : nrEpochs-processingWindow+1
        endOfIndex = endOfIndex+1;
    end
    if(endOfIndex ~= nrWindows)
        error('something is not right with the nr of windows');
    end
    
    % calculate wpli for every group (window) of epochs
    fprintf('*** Calculating WPLI for every epoch...\n');   
    warning('off','MATLAB:colon:nonIntegerIndex');
    for index = 1 : endOfIndex
        
        firstEpoch = 1 + windowOverlap * (index-1);
        lastEpoch = firstEpoch + processingWindow - 1;
        fprintf('*** Epochs %d to %d...\n',firstEpoch,lastEpoch);
        
        % update the fields of the struct for this group (window) of epochs
        crtFreqStruct2 = crtFreqStruct;
        crtFreqStruct2.powspctrm = freqStruct.powspctrm(firstEpoch:lastEpoch,:,:);
        crtFreqStruct2.crsspctrm = freqStruct.crsspctrm(firstEpoch:lastEpoch,:,:);
        crtFreqStruct2.cumsumcnt = freqStruct.cumsumcnt(firstEpoch:lastEpoch,:);
        crtFreqStruct2.cumtapcnt = freqStruct.cumtapcnt(firstEpoch:lastEpoch,:);
        
        % skip bad epochs from the calculation
        nrBadEpochs = 0;
        for e = firstEpoch:lastEpoch
            if sum(noisiness(:,e)) > thresholdBadChansPerEpoch
                crtFreqStruct2.powspctrm(e - nrBadEpochs - firstEpoch + 1,:,:) = [];
                crtFreqStruct2.crsspctrm(e - nrBadEpochs - firstEpoch + 1,:,:) = [];
                crtFreqStruct2.cumsumcnt(e - nrBadEpochs - firstEpoch + 1,:) = [];
                crtFreqStruct2.cumtapcnt(e - nrBadEpochs - firstEpoch + 1,:) = [];
                nrBadEpochs = nrBadEpochs + 1;
            end
        end
        
        % skip calculating the current wpli if too many epochs are bad
        calcWpli = 1;
        if nrBadEpochs > thresholdBadEpochsPerWpli
            calcWpli = 0;
        else
            % do connectivity analysis => debiased phase lag index
            connectivityStruct{index} = ft_connectivityanalysis(connectivityCfg, crtFreqStruct2);
        end
        
        % add to connectivity matrix
        fprintf('*** Making connectivity matrices...\n');
        for freqIndex = 1:nr_freq
            freq = freqStruct.freq(freqIndex); 
            mymatrix{freqIndex,index} = NaN;
            if calcWpli
                mymatrix{freqIndex,index} = MakeConnectivityMatrix(connectivityStruct{index}, freq);
            end
        end
    end

    ft_progress('init', 'text', '*** Saving matrix...');
    for freqIndex = 1:nr_freq
        freq = freqStruct.freq(freqIndex);
        matrix = mymatrix(freqIndex,:);
        save([folderMatrix 'matrix_p' num2str(patientnr) '_overnight' num2str(nightnr) '_' num2str(freq) 'hz.mat'], 'matrix');
        ft_progress(freqIndex/nr_freq);
    end 
    ft_progress('close');

    fprintf('Done.\n');

end

