function [alphaP, thetaP, deltaP, label, elec] = PlotTopoChannelPowerProportion(patientnr)

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
    
    %h = figure;
    %ha = tight_subplot(3,length(nights),0.01,0.01,0.01);
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
        topoStruct.dimord = 'chan';
        topoStruct.freq = 1;
        topoStruct.alphaProportion = zeros(nrChans,1);
        topoStruct.thetaProportion = zeros(nrChans,1);
        topoStruct.deltaProportion = zeros(nrChans,1);

        % compute channel contribution in each band
        indicesDelta = (freqs >= 1 & freqs <= 4);
        indicesTheta = (freqs >= 4 & freqs <= 8);
        indicesAlpha = (freqs >= 8 & freqs <= 12);
        indicesAllThreeBands = (freqs >= 1 & freqs <= 12);

        % sum total power in each band (including all bands) at every channel
        totalDeltaPerChan = sum(sum(freqStruct.powspctrm(:,:,indicesDelta),3),1)';
        totalThetaPerChan = sum(sum(freqStruct.powspctrm(:,:,indicesTheta),3),1)';
        totalAlphaPerChan = sum(sum(freqStruct.powspctrm(:,:,indicesAlpha),3),1)';
        totalPowerPerChan = sum(sum(freqStruct.powspctrm(:,:,indicesAllThreeBands),3),1)';

        % divide power in each band at each channel by total power in all bands at each channel
        topoStruct.deltaProportion = totalDeltaPerChan ./ totalPowerPerChan;
        topoStruct.thetaProportion = totalThetaPerChan ./ totalPowerPerChan;
        topoStruct.alphaProportion = totalAlphaPerChan ./ totalPowerPerChan;

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


        %axes(ha(1*length(nights) - (length(nights)-nightnr)));
        cfg.parameter = 'deltaProportion';
        cfg.comment = ['Outcome ' num2str(outcome) ', night ' num2str(nightnr) ', channelwise delta band power proportion'];
        %ft_topoplotER(cfg,topoStruct);

        %axes(ha(2*length(nights) - (length(nights)-nightnr))); 
        cfg.parameter = 'thetaProportion';
        cfg.comment = ['Outcome ' num2str(outcome) ', night ' num2str(nightnr) ', channelwise theta band power proportion'];
        %ft_topoplotER(cfg,topoStruct);

        %axes(ha(3*length(nights) - (length(nights)-nightnr)));
        cfg.parameter = 'alphaProportion';
        
        cfg.comment = ['Outcome ' num2str(outcome) ', night ' num2str(nightnr) ', channelwise alpha band power proportion'];
        %ft_topoplotER(cfg,topoStruct);
        
        alphaP{nightnr} = topoStruct.alphaProportion;
        thetaP{nightnr} = topoStruct.thetaProportion;
        deltaP{nightnr} = topoStruct.deltaProportion;
    end
    %set(h, 'Position', [200 200 1000 1200]);
    options.Format = 'jpeg';
    %hgexport(h,  ['/imaging/sc03/Iulia/Overnight/figures-channelpower-topo/' num2str(patientnr) '.jpg'], options);

    label = topoStruct.label;
    elec = data.elec;
end