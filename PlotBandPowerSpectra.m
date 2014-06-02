function PlotBandPowerSpectra(patientnr, nightnr, channelStr)

    % input folder
    LoadFolderNames;
    
    % filename
    filename = ['power_spectra_p' int2str(patientnr) '_overnight' int2str(nightnr) '_1'];
    
    % load freq struct
    load([powspecFolder filename '.mat']);
    
    % find channel index
    channelnr = find(ismember(freqStruct.label,channelStr));
    
    % calculate mean power at every frequency over time
    power = (squeeze(mean(freqStruct.powspctrm(:,channelnr,:),1)));
    plot(freqStruct.freq, power, 'LineWidth', 3);
    xlabel('Frequency (Hz)','FontSize',20);
    %ylabel('Power','FontSize',20);
    %title(['Mean power spectra for patient ' int2str(patientnr) ' (night ' int2str(nightnr) ') at channel ' channelStr ' over whole night']);
    set(gca,'FontSize',20)
end