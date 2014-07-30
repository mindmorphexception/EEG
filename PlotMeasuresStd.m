function PlotMeasuresStd(patientnr, nightnrs, aux)
% Plots the std dev of graph measures

    
    [values, measureNames] = GetMeasuresStdDevs(patientnr, nightnrs, aux);

    % make bar plots for each measure
    set(gca,'FontSize',20);
    suptitle(['Patient ' num2str(patientnr) ' - Standard deviations of connectivity measures']);
    for i = 1:length(measureNames)
        subplot(length(measureNames),1,i);
        bar(values{i});
        ylabel(measureNames{i});

        % label the bar groups
        set(gca,'xticklabel', aux);
    end
    
    
    % make legend
    legendstr = cell(1,length(nightnrs));
    for night = 1:length(nightnrs)
        legendstr{night} = ['Night ' int2str(night)];
    end    
    %legend(legendstr, 'Location', 'SouthEast');

end

