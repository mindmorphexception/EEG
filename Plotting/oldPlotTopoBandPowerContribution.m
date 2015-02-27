function PlotTopoBandPowerContribution(patientnr)

    % load folder names
    LoadFolderNames;
    
    % load scores
    [patients, scores] = LoadScores('outcome');
    [patients2, scores2] = LoadScores('crs-2');
    outcome = scores(find(patients == patientnr));
    
    % set up nights
    hasSecondNight = (sum(patients2 == patientnr)>0) && scores2(patients2 == patientnr) ~= 0;
    if(hasSecondNight)
        nights = [1 2];
    else
        nights = 1;
    end
    
    h = figure;
    ha = tight_subplot(3,length(nights),0.01,0.01,0.01);
    for nightnr = 1:length(nights)
        
        % filename
        filename = ['power_spectra_clean_p' int2str(patientnr) '_overnight' int2str(nightnr)];

        % load freq struct
        load([folderPowspecClean filename '.mat']);

        % init
        nrEpochs = size(freqStruct.powspctrm,1);
        nrChans = size(freqStruct.powspctrm,2);
        freqs = freqStruct.freq;
        [patients, outcomes] = LoadScores('outcome');
        outcome = outcomes(patients == patientnr);

        % make a new freq struct
        topoStruct = [];
        topoStruct.label = freqStruct.label;
        topoStruct.dimord = 'chan_freq';
        topoStruct.freq = 1;
        topoStruct.alphaContrib = zeros(nrChans,nrEpochs);
        topoStruct.thetaContrib = zeros(nrChans,nrEpochs);
        topoStruct.deltaContrib = zeros(nrChans,nrEpochs);

        % compute channel contribution in each band
        indicesDelta = (freqs >= 1 & freqs <= 4);
        indicesTheta = (freqs >= 4 & freqs <= 8);
        indicesAlpha = (freqs >= 8 & freqs <= 12);

        totalDeltaPerChan = sum(freqStruct.powspctrm(:,:,indicesDelta),3);
        totalThetaPerChan = sum(freqStruct.powspctrm(:,:,indicesTheta),3);
        totalAlphaPerChan = sum(freqStruct.powspctrm(:,:,indicesAlpha),3);

        totalDelta = sum(totalDeltaPerChan,2);
        totalTheta = sum(totalThetaPerChan,2);
        totalAlpha = sum(totalAlphaPerChan,2);

        for c = 1:nrChans
            topoStruct.deltaContrib(c,:) = totalDeltaPerChan(:,c) ./ totalDelta;
            topoStruct.thetaContrib(c,:) = totalThetaPerChan(:,c) ./ totalTheta;
            topoStruct.alphaContrib(c,:) = totalAlphaPerChan(:,c) ./ totalAlpha;
        end

        % calculate mean contribution from each chan during all epochs
        topoStruct.alphaContribMean = mean(topoStruct.alphaContrib,2);
        topoStruct.thetaContribMean = mean(topoStruct.thetaContrib,2);
        topoStruct.deltaContribMean = mean(topoStruct.deltaContrib,2);

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


        axes(ha(1*length(nights) - (length(nights)-nightnr)));
        cfg.parameter = 'deltaContribMean';
        cfg.comment = ['Outcome ' num2str(outcome) ', night ' num2str(nightnr) ', delta band power contribution'];

        ft_topoplotER(cfg,topoStruct);

        axes(ha(2*length(nights) - (length(nights)-nightnr))); 
        cfg.parameter = 'thetaContribMean';
        cfg.comment = ['Outcome ' num2str(outcome) ', night ' num2str(nightnr) ', theta band power contribution'];
        ft_topoplotER(cfg,topoStruct);

        axes(ha(3*length(nights) - (length(nights)-nightnr)));
        cfg.parameter = 'alphaContribMean';
        
        cfg.comment = ['Outcome ' num2str(outcome) ', night ' num2str(nightnr) ', alpha band power contribution'];
        ft_topoplotER(cfg,topoStruct);
    end
    set(h, 'Position', [200 200 1000 1200]);
    options.Format = 'jpeg';
    %hgexport(h,  ['/imaging/sc03/Iulia/Overnight/power-topo/' num2str(patientnr) '.jpg'], options);
end