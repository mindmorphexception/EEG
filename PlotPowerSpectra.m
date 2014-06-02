function PlotPowerSpectra(patientnr, nightnr, channelStr)

    % channel string example: 'E61'
    
    LoadFolderNames;
    
    % filename
    filename = ['power_spectra_p' int2str(patientnr) '_overnight' int2str(nightnr) '_1'];
    
    % load freq struct
    load([folderPowspec filename '.mat']);
    
    % find channel index
    channelnr = find(ismember(freqStruct.label,channelStr));
    
    % generate time labels in hours
    nrEpochs = size(freqStruct.powspctrm,1);
    timelabel = MakeTimeLabelsCrossSpectraEpochs(nrEpochs);
    
    % heatplot frequency x time
    imagesc(timelabel, freqStruct.freq, (squeeze(freqStruct.powspctrm(:,channelnr,:)))');
    caxis([0 1]);
    %xlabel('Time (hours)','FontSize',20);
    %ylabel('Frequency (Hz)','FontSize',20);
    title(['Power spectra for patient ' int2str(patientnr) ' (night ' int2str(nightnr) ') at channel ' channelStr]);
    colorbar
    set(gca,'FontSize',20)
    set(gca,'YDir','normal');
    
end