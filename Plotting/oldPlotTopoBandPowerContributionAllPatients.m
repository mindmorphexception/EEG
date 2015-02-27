function PlotTopoBandPowerContributionAllPatients

    % load folder names
    LoadFolderNames;
    
    % load scores
    [patients, scores] = LoadScores('outcome');
    [patients2, scores2] = LoadScores('crs-2');
    
    % topo struct which will be usedto plot
    topoStruct = [];
    
    % set up figure
    h = figure;
    ha = tight_subplot(3,1,0.01,0.01,0.01);
    
    counter = 1;
    
    for p = 1:length(patients)
        
        patientnr = patients(p);
        
        outcome = scores(find(patients == patientnr));
        
        % set up nights
        hasSecondNight = (sum(patients2 == patientnr)>0) && scores2(patients2 == patientnr) ~= 0;
        if(hasSecondNight)
            nights = [1 2];
        else
            nights = 1;
        end

       
        for nightnr = 1:length(nights)

            % filename
            filename = ['power_spectra_clean_p' int2str(patientnr) '_overnight' int2str(nightnr)];

            % load freq struct
            clear freqStruct
            load([folderPowspecClean filename '.mat']);

            % init
            nrEpochs = size(freqStruct.powspctrm,1);
            nrChans = size(freqStruct.powspctrm,2);
            freqs = freqStruct.freq;
            [patients, outcomes] = LoadScores('outcome');
            outcome = outcomes(patients == patientnr);

            % make a new freq struct
            if(isempty(topoStruct))
                topoStruct.label = freqStruct.label;
                topoStruct.dimord = 'chan_freq';
                topoStruct.freq = 1;
                
                % compute channel contribution in each band
                indicesDelta = (freqs >= 1 & freqs <= 4);
                indicesTheta = (freqs >= 4 & freqs <= 8);
                indicesAlpha = (freqs >= 8 & freqs <= 12);
            end
            
            topoStruct.alphaContrib = zeros(nrChans,nrEpochs);
            topoStruct.thetaContrib = zeros(nrChans,nrEpochs);
            topoStruct.deltaContrib = zeros(nrChans,nrEpochs);

            totalDeltaPerChan = sum(freqStruct.powspctrm(:,:,indicesDelta),3);
            totalThetaPerChan = sum(freqStruct.powspctrm(:,:,indicesTheta),3);
            totalAlphaPerChan = sum(freqStruct.powspctrm(:,:,indicesAlpha),3);

            totalDelta = sum(totalDeltaPerChan,2);
            totalTheta = sum(totalThetaPerChan,2);
            totalAlpha = sum(totalAlphaPerChan,2);

            for c = 1:nrChans
                topoStruct.deltaContrib(c,:) = (totalDeltaPerChan(:,c) ./ totalDelta);
                topoStruct.thetaContrib(c,:) = (totalThetaPerChan(:,c) ./ totalTheta);
                topoStruct.alphaContrib(c,:) = (totalAlphaPerChan(:,c) ./ totalAlpha);
            end
            
            % calculate mean contribution from each chan during all epochs
            topoStruct.alphaContribMean{counter} = mean(topoStruct.alphaContrib,2);
            topoStruct.thetaContribMean{counter} = mean(topoStruct.thetaContrib,2);
            topoStruct.deltaContribMean{counter} = mean(topoStruct.deltaContrib,2);
            counter = counter + 1;
        end
    end
    
    % compute mean over contrbution means
    alphaContribMeanSum = zeros(nrChans,1);
    thetaContribMeanSum = zeros(nrChans,1);
    deltaContribMeanSum = zeros(nrChans,1);
    nrElems = length(topoStruct.alphaContribMean);
    for i = 1:nrElems
        alphaContribMeanSum = alphaContribMeanSum + topoStruct.alphaContribMean{i};
        thetaContribMeanSum = thetaContribMeanSum + topoStruct.thetaContribMean{i};
        deltaContribMeanSum = deltaContribMeanSum + topoStruct.deltaContribMean{i};
    end
    
    topoStruct.alphaContrib = [];
    topoStruct.thetaContrib = [];
    topoStruct.deltaContrib = [];
    
    topoStruct.alphaContrib = alphaContribMeanSum ./ nrElems;
    topoStruct.thetaContrib = thetaContribMeanSum ./ nrElems;
    topoStruct.deltaContrib = deltaContribMeanSum ./ nrElems;

    % plotting channel layout:
    cfg = [];
    cfg.rotate = 90;
    data = [];
    data.elec = freqStruct.elec;
    %ft_layoutplot(cfg,data)

    % preparing a layout
    layout = ft_prepare_layout(cfg,data);

    % plot multi channel topo
    cfg = [];
    cfg.layout = layout;
    cfg.colorbar = 'yes';
    %cfg.zlim = [0 0.05];
    cfg.commentpos = 'lefttop';
    %cfg.scalinggridsize = 200;
    cfg.fontsize = 16;

    %cfg.interactive = 'no';
    %cfg.showlabels = 'yes';
    %cfg.box = 'yes';
    %cfg.hotkeys = 'yes';
    %cfg.baseline = [0 10];
    %cfg.baselinetype = 'db';


    axes(ha(1));
    cfg.parameter = 'deltaContrib';
    cfg.comment = ['Delta band power contribution'];

    ft_topoplotER(cfg,topoStruct);

    axes(ha(2));
    cfg.parameter = 'thetaContrib';
    cfg.comment = ['Theta band power contribution'];
    ft_topoplotER(cfg,topoStruct);

    axes(ha(3));
    cfg.parameter = 'alphaContrib';
    cfg.comment = ['Alpha band power contribution'];
    ft_topoplotER(cfg,topoStruct);

    set(h, 'Position', [200 200 1000 1200]);
    options.Format = 'jpeg';
    %hgexport(h,  ['/imaging/sc03/Iulia/Overnight/power-topo/' num2str(patientnr) '.jpg'], options);

end