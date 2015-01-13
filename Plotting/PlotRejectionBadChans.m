function PlotRejectionBadChans(patientnr, nightnr)
    
    % load stddevs & noisiness
    [stddevs, noise] = MarkNoisyData(patientnr, nightnr);
    
    % plot nr of bad channels at every epoch
    thresholdChanStdDev = GetThresholdChannelStdDev(patientnr, nightnr);
    t1 = MakeTimeLabelsCrossSpectraEpochs(size(stddevs,2));
    hold on;
    bar(t1,sum(stddevs>thresholdChanStdDev));
    xlabel('Time');
    ylabel('Nr. bad chans');
    ylim([0 90]);
    set(gca,'ytick',[10:10:90]);
    set(gca,'yticklabel',[10:10:90]);
end
    
    