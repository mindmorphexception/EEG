function PlotPowerContribution(patientnr, nightnr)
    
    LoadFolderNames;
    
    % load power contributions
    percentAlpha = GetPowerContributionAlpha(patientnr, nightnr);
    percentTheta = GetPowerContributionTheta(patientnr, nightnr);
    percentDelta = GetPowerContributionDelta(patientnr, nightnr);
    
    % init
    nrEpochs = length(percentAlpha);

    % plot percents overnight
    t = MakeTimeLabelsCrossSpectraEpochs(nrEpochs);
    figure;
    plot(t,percentDelta,t,percentTheta,t,percentAlpha);
    legend('delta','theta','alpha');
    
end