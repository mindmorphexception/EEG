function PlotPowerTopo(patientnr, nightnr)
    
    % input folder
    LoadFolderNames;
    
    % filename
    filename = ['power_spectra_p' int2str(patientnr) '_overnight' int2str(nightnr)];
    
    % load freq struct
    load([folderPowspec filename '.mat']);
    
    % add time dimention to freq struct required by ft
    if ~isfield(freqStruct, 'time')
        freqStruct = ConvertFTfreqStruct(freqStruct);
    end

    % plotting channel layout:
    cfg = [];
    cfg.rotate = 90;
    data = [];
    data.elec = freqStruct.elec;
    
    % preparing a layout
    layout = ft_prepare_layout(cfg,data);

    % plot multi channel topo
    cfg = [];
    cfg.parameter = 'powspctrm';
    cfg.layout = layout;
    cfg.channelname = 'Cz';
    cfg.zlim = [0 1];
    cfg.interactive = 'no';
    cfg.showlabels = 'yes';
    cfg.box = 'no';
    cfg.colorbar = 'yes';
    cfg.hotkeys = 'yes';
    %cfg.baseline = [0 10];
    %cfg.baselinetype = 'db';
    ft_multiplotTFR(cfg, freqStruct);

end

