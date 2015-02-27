
folder = '/imaging/sc03/Iulia/Overnight/graph-measures/';
fr = {'delta','theta','alpha','allfreq'};
%ms = {'mean','std','stdseq','mutualinfo'};
%ms = {'meanclustering', 'stdclustering', 'globalEfficiency', 'pathlen', 'meanbetweenness', 'stdbetweenness', 'modularity', 'meanparticipation', 'stdparticipation'};
ms = {'modspan', 'sd-modspan'};
index = 1;
%tstr = cell(1,4*3);

for i = 1:3
    for j = 1:length(ms)
        filename = [ms{j} '-' fr{i}];

%             otherparams.bandName = fr{i};
%             otherparams.measureName = ms{j};
%             PlotBarsSorted(otherparams);

        load([folder filename '.mat'])
        
        % make data
        [allpatients, allscores] = LoadScores('outcome');
        for p = 1:length(m.patients2)
            patientnr = m.patients2(p);
            measure1(p) = m.measures(m.patients == patientnr);
            measure2(p) = m.measures2(p);
            outcome(p) = allscores(allpatients == patientnr);
        end

        xvals = measure2./measure1-1;
        yvals = outcome;
        
        % such statistics, wow
        lrModel = LinearModel.fit(xvals, yvals, 'linear', 'RobustOpts', 'off');
        lrrobustModel = LinearModel.fit(xvals, yvals, 'linear', 'RobustOpts', 'on');
        lm.coef = num2str(lrModel.Rsquared.Ordinary,2); lm.pval = lrModel.Coefficients.pValue(2);
        lmrobust.coef = num2str(lrrobustModel.Rsquared.Ordinary,2); lmrobust.pval = lrrobustModel.Coefficients.pValue(2);
        [pearson.coef, pearson.pval] = corr(xvals', yvals','type','Pearson');
        [spearman.coef, spearman.pval] = corr(xvals', yvals','type','Spearman');
        
        % set line equation as robust linear regression
        b = lrrobustModel.Coefficients.Estimate(1);
        a = lrrobustModel.Coefficients.Estimate(2);
        
        % plot
        PlotRegression(xvals, yvals, a, b, lm, lmrobust, pearson, spearman, filename);
        saveas(gcf, [folder filename '.png']);
        
        % display
        tstr = sprintf('%s ', filename);
        for p = 1:length(xvals)
           tstr = [tstr sprintf('%f ',xvals(p))];
        end
        p1 = lrModel.Coefficients.pValue(2);
        tstr = [tstr '| ' num2str(lm.pval) ' | ' num2str(lm.coef)];
        fprintf('%s\n',tstr);
        index = index+1;
    end
end

