function PlotMeasuresStd(patientnr, nightnrs, aux)
% Plots the std dev of graph measures

    
    [values, measureNames] = GetMeasuresStdDevs(patientnr, nightnrs, aux, []);
    
    % pad if lss than 3 nights
    for n = (length(nightnrs)+1):3
        for i = 1:length(values)
            values{i}(:,n) = 0;
        end
    end

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

