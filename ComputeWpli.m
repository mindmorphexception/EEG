function [connectivityStruct, mymatrix] = ComputeWpli(freqStruct, basename, varargin)

% Computes the WPLI using the fieldtrip toolbox.
% If freqStruct is the filename where the struct is stored, loadStructFromFile is one.
% See main function for more details.

%     paramcheck = finputcheck(varargin, ...
%        {
%        'save' 'integer' [0 1] 1;
%        'frequencyParam' 'string' {'max', 'min', 'mean'} 'max'
%        });
%     
%     if(isstr(paramcheck))
%         error(paramcheck);
%     end


    LoadFolderNames;
    
%     try
%     matlabpool close
%     catch
%     end
%     matlabpool
    
    % we need to declare the vars defined in different files
    % in order to see them on parallel workers
    %  %%%
            processingWindow = 1; % calculate wpli for groups of 60 epochs (60*10 seconds = 10 minutes)
            windowOverlap = 1; % 1 epochs (10 seconds) forward step between wpli groups
            
            % connectivity analysis configuration
            connectivityCfg = [];
    %  %%%
    
    LoadParams;

    % if the struct is empty, load it from file
    if(isempty(freqStruct))
        fprintf('Loading freqStruct...');
        load([folderCrossSpectra 'cross_spectra_' basename],'freqStruct');
        fprintf('Done.\n');
    end
    

    % initialize things
    nrEpochs = size(freqStruct.crsspctrm, 1); % total nr of epochs
    %index = 1; % group (window) index
    nrWindows = floor((nrEpochs - processingWindow)/windowOverlap)+1;
    connectivityStruct = cell(1, nrWindows);
    mymatrix = cell(length(freqStruct.freq), nrWindows);
    fprintf('Expecting %d windows\n', length(connectivityStruct));
    %low_freq = freqStruct.freq(1);
    %high_freq = freqStruct.freq(length(freqStruct.freq));
    nr_freq = length(freqStruct.freq);
    
    % make a new freq struct as a template for wpli function calls
    crtFreqStruct.label = freqStruct.label;
    crtFreqStruct.dimord = freqStruct.dimord;
    crtFreqStruct.freq = freqStruct.freq;
    crtFreqStruct.labelcmb = freqStruct.labelcmb;
    crtFreqStruct.elec = freqStruct.elec;
    crtFreqStruct.cfg = freqStruct.cfg;
    
    % calculate wpli for every group (window) of epochs
    
    fprintf('*** Computing number of windows (uhh)...\n');
    endOfIndex = 0;
    for firstEpoch = 1 : windowOverlap : nrEpochs-processingWindow+1
        endOfIndex = endOfIndex+1;
    end
    if(endOfIndex ~= nrWindows)
        error('something is not right with the nr of windows');
    end
    
    fprintf('*** Calculating WPLI for every epoch in parallel...\n');   
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
        
        % do connectivity analysis => debiased phase lag index
        connectivityStruct{index} = ft_connectivityanalysis(connectivityCfg, crtFreqStruct2);
        
        % add to connectivity matrix
        fprintf('*** Making connectivity matrices...\n');
        for freqIndex = 1:nr_freq
            freq = freqStruct.freq(freqIndex); %low_freq + (freqIndex-1) * 0.1;
            mymatrix{freqIndex,index} = MakeConnectivityMatrix(connectivityStruct{index}, freq);
        end
    end

    ft_progress('init', 'text', '*** Saving matrix...');
    for freqIndex = 1:nr_freq
        freq = freqStruct.freq(freqIndex);
        matrix = mymatrix(freqIndex,:);
        save([folderMatrix 'matrix_' basename '_' num2str(freq) 'hz.mat'], 'matrix');
        ft_progress(freqIndex/nr_freq);
    end 
    ft_progress('close');

    fprintf('Done.\n');

end

