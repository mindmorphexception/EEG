function PlotStdDevs_vs_Wpli(patientnr, nightnr)
    
    LoadParams;
    factor = 30000;
    
    % load and plot stddevs
    [stddevs, ~] = MarkNoisyData(patientnr, nightnr);
    t1 = MakeTimeLabelsCrossSpectraEpochs(size(stddevs,2));
    nrEpochs = length(t1);
    plot(t1, stddevs, 'Color', 'r');
    
    % load and plot all median wplis
    matrices = AggregateMaxFreqMatrix(patientnr, nightnr, 1:0.1:12, 0);
    t2 = MakeTimeLabelsWpliEpochs(length(matrices));
    nrEpochs = length(t2);
    for t = 1:nrEpochs
        medwpli(t) = median(matrices{t}(:));
    end
    hold all 
    plot(t2, medwpli*factor, 'k--');
    
    [~, noisinessMatrix] = MarkNoisyData(patientnr, nightnr);
    matrices = CleanMatrices(matrices, noisinessMatrix);
    for t = 1:nrEpochs
        medwpli(t) = median(matrices{t}(:));
    end
    t2 = MakeTimeLabelsWpliEpochs(length(medwpli));
    hold all 
    plot(t2, medwpli*factor, 'b');
     
end
