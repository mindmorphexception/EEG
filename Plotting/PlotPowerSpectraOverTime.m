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
    freqs = mag2db(freqs);
    freqs(isnan(freqs)) = min(min(freqs)) - 1;
    h = figure;
    hi = imagesc(timelabel, freqStruct.freq, freqs);
    %caxis([0 10]);
    colormap([0 0 0; colormap]);
    xlabel('Time (hours)','FontSize',20);
    ylabel('Frequency (Hz)','FontSize',20);
    title(['P' int2str(patientnr) '\_' int2str(nightnr)]);
    colorbar
    set(gca,'FontSize',20)
    set(gca,'YDir','normal');
    if isempty(channelStr)
        channelStr = 'all chans mean';
    end
    %[lim1 lim2] = caxis;
    %set(gca,'XTick', lim1:3:lim2); 
    
    
    myStyle = hgexport('factorystyle');
    myStyle.Format = 'png';
    myStyle.Resolution = 150;
    myStyle.FontSizeMin = 30;

    hgexport(gcf, ['/imaging/sc03/Iulia/Overnight/figures-power-spectra/pow_p' num2str(patientnr) '_overnight' num2str(nightnr) '_' channelStr '.png'], myStyle);

    %print(h, '-djpeg', '-r350', ['/imaging/sc03/Iulia/Overnight/figures-power-spectra/pow_p' num2str(patientnr) '_overnight' num2str(nightnr) '_' channelStr '.jpg']);
    
end