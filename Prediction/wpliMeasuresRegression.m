clear;clc;
folder = '/imaging/sc03/Iulia/Overnight/all-measures/';
fr = {'delta','theta','alpha','allfreq'};

ms = {%'contrib',...
    'mean-wpli','std-wpli','stdseq-wpli','stdmean-wpli',...
    %'smallworldness','modspanmean', 'meanclustering', 'stdclustering', 'globalEfficiency', 'pathlen', 'meanbetweenness', 'stdbetweenness', 'modularity', 'meanparticipation', 'stdparticipation'...
    };
titles = {%'Power contribution',...
    'WPLI^2 overall median', 'WPLI^2 median over SD of channel pairs', 'WPLI^2 median over SD across matrices','WPLI^2 SD of medians',...
    %'Small-world-ness','Modular span', 'Median clustering', 'SD clustering', 'Global efficiency', 'Characteristic path length', 'Median betweenness', 'SD betweenness', 'Modularity', 'Median participation', 'SD participation',...
    };

index = 1;
%tstr = cell(1,4*3);
allLMpvals = [];
allSpearmanPvals = [];
allLMRBpvals = [];

for i = 1:3
    for j = 1:length(ms)
        filename = ['' ms{j} '-' fr{i}];
        nicetitle = ['' titles{j} ' - ' fr{i}];

%             otherparams.bandName = fr{i};
%             otherparams.measureName = ms{j};
%             PlotBarsSorted(otherparams);

        load([folder filename '.mat'])
                
        % exclude patients...
        exclp = 16;
        exclind = -1;
        
        % make data
        [allpatients, allscores] = LoadScores('outcome');
        for p = 1:length(m.patients2)
            patientnr = m.patients2(p);
            
            if(patientnr == exclp)
                exclind = p;
            end
            
            measure1(p) = m.measures(m.patients == patientnr);
            measure2(p) = m.measures2(p);
            outcome(p) = allscores(allpatients == patientnr);
            
        end

        xvals = measure2./measure1-1;
        yvals = outcome;
        
        %xvals(exclind) = [];
        %yvals(exclind) = [];
        
        % such statistics, wow
        lrModel = LinearModel.fit(xvals, yvals, 'linear', 'RobustOpts', 'off');
        lrrobustModel = LinearModel.fit(xvals, yvals, 'linear', 'RobustOpts', 'on');
        lm.coef = num2str(lrModel.Rsquared.Ordinary,2); lm.pval = lrModel.Coefficients.pValue(2);
        lmrobust.coef = num2str(lrrobustModel.Rsquared.Ordinary,2); lmrobust.pval = lrrobustModel.Coefficients.pValue(2);
        [pearson.coef, pearson.pval] = corr(xvals', yvals','type','Pearson');
        [spearman.coef, spearman.pval] = corr(xvals', yvals','type','Spearman');
        
        allLMpvals = [allLMpvals lm.pval];
        allSpearmanPvals = [allSpearmanPvals spearman.pval];
        allLMRBpvals = [allLMRBpvals lmrobust.pval];
        
        % set line equation as robust linear regression
        b = lrModel.Coefficients.Estimate(1);
        a = lrModel.Coefficients.Estimate(2);
        
        %fprintf('%s ', num2str(lm.pval));
        
        %if(lm.pval < 0.5)
            
            % plot
            %PlotRegression(xvals, yvals, a, b, lm, lmrobust, pearson, spearman, nicetitle);
            % export figure
            myStyle = hgexport('factorystyle');
            myStyle.Format = 'png';
            myStyle.Resolution = 150;
            myStyle.FontSizeMin = 30;
            %hgexport(gcf, [folder nicetitle 'excl.png'], myStyle);
            
            % display
            tstr = sprintf('%s ', nicetitle);
            %for p = 1:length(xvals)
            %   tstr = [tstr sprintf('%f ',xvals(p))];
            %end
            p1 = lrModel.Coefficients.pValue(2);
            tstr = [tstr '| ' num2str(lm.pval) ' | ' num2str(lm.coef) '| ' num2str(spearman.pval) ' | ' num2str(spearman.coef)];
            fprintf('%s\n',tstr);
        %end
        

        
    end
    close all;
end

