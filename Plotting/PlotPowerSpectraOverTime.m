function PlotPowerSpectraOverTime(patientnr, nightnr, channelStr)

    % channel string example: 'E61'
    % if channel string is '', the mean is calculated
    
    LoadFolderNames;
    
    % filename
    filename = ['power_spectra_p' int2str(patientnr) '_overnight' int2str(nightnr)];
    
    % load freq struct
    load([folderPowspec filename '.mat']);
    
    % find channel index
    channelnr = find(ismember(freqStruct.label,channelStr));
    
    % generate time labels in hours
    nrEpochs = size(freqStruct.powspctrm,1);
    timelabel = MakeTimeLabelsCrossSpectraEpochs(nrEpochs);
    
    % plot for all channels if not exactly one channel is specified
    if isempty(channelnr)
        % store frequency x time
        channelStr = 'all channels';
        nrChans = size(freqStruct.powspctrm,2);
        
        % average over all channels mean power at every frequency over time
        freqs = (squeeze(freqStruct.powspctrm(:,1,:)))';
        for c = 2:nrChans
            freqs = freqs + (squeeze(freqStruct.powspctrm(:,c,:)))';
        end
        freqs = freqs/nrChans;
        
    else
        channelStr = ['channel' channelStr];
        freqs = (squeeze(freqStruct.powspctrm(:,channelnr,:)))';
    end
    
    %  clean
    [~, noisiness] = MarkNoisyData(patientnr, nightnr);
    nrChans = size(noisiness,1);
    thresholdBadChansPerEpochs = GetThresholdBadChansPerEpoch(patientnr, nightnr) * nrChans;
    for e = 1:nrEpochs
        if (sum(noisiness(:,e)) >= thresholdBadChansPerEpochs)
            freqs(:,e) = NaN;
        end
    end
    
    % heatplot frequency x time
    imagesc(timelabel, freqStruct.freq, freqs);
    caxis([0 10]);
    xlabel('Time (hours)','FontSize',20);
    ylabel('Frequency (Hz)','FontSize',20);
    title(['Power spectra for patient ' int2str(patientnr) ' (night ' int2str(nightnr) ') at ' channelStr]);
    colorbar
    set(gca,'FontSize',20)
    set(gca,'YDir','normal');
    
end