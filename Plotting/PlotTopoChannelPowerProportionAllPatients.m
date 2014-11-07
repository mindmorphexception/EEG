function PlotTopoChannelPowerProportionAllPatients
    % load folder names
    LoadFolderNames;
    
    % load scores
    [patients, scores] = LoadScores('outcome');
    [patients2, scores2] = LoadScores('crs-2');
    
    alphaP = [];
    thetaP = [];
    deltaP = [];
    
    index = 0;
    
    for p = 1:length(patients)
        
        patientnr = patients(p)
        
        [alphaP_n, thetaP_n, deltaP_n, label, elec] = PlotTopoChannelPowerProportion(patientnr);
        
        for i = 1:length(alphaP_n)
            index = index + 1;
            
            alphaP(index,:) = alphaP_n{i};
            thetaP(index,:) = thetaP_n{i};
            deltaP(index,:) = deltaP_n{i};
        end
    end
    
    
    h = figure;
    ha = tight_subplot(3,1,0.01,0.01,0.01);
    
    topoStruct = [];
    topoStruct.label = label;
    topoStruct.dimord = 'chan';
    topoStruct.freq = 1;
    topoStruct.alphaProportion = mean(alphaP,1)';
    topoStruct.thetaProportion = mean(thetaP,1)';
    topoStruct.deltaProportion = mean(deltaP,1)';
    
    % plotting channel layout:
    cfg = [];
    cfg.rotate = 90;
    data = [];
    data.elec = elec;
    %ft_layoutplot(cfg,data)

    % preparing a layout
    layout = ft_prepare_layout(cfg,data);

    % plot multi channel topo
    cfg = [];
    cfg.layout = layout;
    cfg.colorbar = 'yes';
    cfg.commentpos = 'lefttop';
    cfg.fontsize = 16;

    axes(ha(1));
    cfg.parameter = 'deltaProportion';
    cfg.comment = ['Channelwise delta band power proportion'];
    ft_topoplotER(cfg,topoStruct);

    axes(ha(2)); 
    cfg.parameter = 'thetaProportion';
    cfg.comment = ['Channelwise theta band power proportion'];
    ft_topoplotER(cfg,topoStruct);

    axes(ha(3));
    cfg.parameter = 'alphaProportion';
    cfg.comment = ['Channelwise alpha band power proportion'];
    ft_topoplotER(cfg,topoStruct);
    
    set(h, 'Position', [200 200 1000 1200]);
end