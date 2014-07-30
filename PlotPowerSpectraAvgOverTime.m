function PlotPowerSpectraAvgOverTime(patientnr, nightnr, channelStr)
    
    % channel string example: 'E61'
    % if channel string is '', the mean is calculated
    
    % input folder
    LoadFolderNames;
    
    % filename
    filename = ['power_spectra_p' int2str(patientnr) '_overnight' int2str(nightnr)];
    
    % load freq struct
    load([folderPowspec filename '.mat']);
    
    % find channel index
    channelnr = find(ismember(freqStruct.label,channelStr));
    
    % plot for all channels if not exactly one channel is specified
    if isempty(channelnr)
        channelStr = 'all channels';
        nrChans = size(freqStruct.powspctrm,2);
        
        % average over all channels mean power at every frequency over time
        power = (squeeze(mean(freqStruct.powspctrm(:,1,:),1)));
        for c = 2:nrChans
            power = power + (squeeze(mean(freqStruct.powspctrm(:,c,:),1)));
        end
        power = power/nrChans;
        
    else
        channelStr = ['channel ' channelStr];
        
        % calculate mean power at every frequency over time
        power = (squeeze(mean(freqStruct.powspctrm(:,channelnr,:),1)));
    end
    
    
    plot(freqStruct.freq, power, 'LineWidth', 3);
    xlabel('Frequency (Hz)','FontSize',20);
    ylabel('Power','FontSize',20);
    title(['Mean power spectra for patient ' int2str(patientnr) ' (night ' int2str(nightnr) ') at ' channelStr ' over whole night']);
    set(gca,'FontSize',20)
end