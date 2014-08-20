SmartFreqStruct = ConvertFTfreqStruct(freqStruct);

% plotting channel layout:
cfg = [];
cfg.rotate = 90;
data = [];
data.elec = freqStruct.elec;
ft_layoutplot(cfg,data)

% preparing a layout
layout = ft_prepare_layout(cfg,data);

% baseline dB


% plot multi channel topo
cfg = [];
cfg.parameter = 'powspctrm';
cfg.layout = layout;
cfg.channelname = 'Cz';
cfg.zlim = [0 1];
cfg.interactive = 'no';
cfg.showlabels = 'yes';
cfg.box = 'yes';
cfg.colorbar = 'yes';
cfg.hotkeys = 'yes';
cfg.baseline = [0 10];
cfg.baselinetype = 'db';
ft_multiplotTFR(cfg,SmartFreqStruct);
