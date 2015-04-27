function PlotRegression(xvals, yvals, a, b, lm, lmrobust, pearson, spearman, mytitle)

    x1 = min(xvals);
    x2 = max(xvals);
    y1 = a * x1 + b;
    y2 = a * x2 + b;
    
    [yvals,ind] = sort(yvals);
    xvals = xvals(ind);
    
    figure; hold on;
    
    plot([x1 x2]',[y1 y2]','--', 'Color', [0.2 0.7 0.9], 'LineWidth', 3);
    cmp = [0.5 0.1 1];
    for p = 1:length(xvals)
        scatter(xvals(p), yvals(p), 'Marker', 'o', 'MarkerFaceColor', cmp(1,:), 'MarkerEdgeColor', [0.5 0.1 1], 'SizeData', 70);
    end
    
    
    xlabel('Proportion change');
    ylabel('Outcome');
    grid on;
    title({mytitle
        %['R^2 = ' num2str(lm.coef,2) ' P = ' num2str(lm.pval,2)]
        %['Linear regression R^2 = ' num2str(lm.coef,2) ' P = ' num2str(lm.pval,2)], ... 
        %['Robust linear regression R^2 = ' num2str(lmrobust.coef,2) ' P = ' num2str(lmrobust.pval,2)], ...
        %['Pearson''s coefficient = ' num2str(pearson.coef,2) ' P = ' num2str(pearson.pval,2)], ...
        %['Spearman''s rho = ' num2str(spearman.coef,2) ' P = ' num2str(spearman.pval,2)] ...
    });
    
    ylim([0 25]);
    
    %set(gca, 'FontName', 'Times', 'FontSize', 50);
    %set(findall(gcf,'type','text'),'FontSize',50, 'FontName', 'Times');

end

