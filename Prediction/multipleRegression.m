clc
folder = '/imaging/sc03/Iulia/Overnight/graph-measures/';

fr = {'delta','theta','alpha','allfreq'};
%ms = {'mean','std','stdseq','mutualinfo'};
ms = {'smallworldness', 'modspan', 'meanclustering', 'globalEfficiency', 'meanbetweenness', 'stdbetweenness', 'modularity', 'meanparticipation', 'stdparticipation'};
%ms = {'smallworldness', 'modspan','stdbetweenness', 'globalEfficiency', 'meanclustering', 'stdclustering','modularity'};'pathlen', 
index = 1;
%tstr = cell(1,4*3);

for i = 2:2
    for j = 1:length(ms)
        filename = [ms{j} '-' fr{i}];

        load([folder '' filename '.mat'])
        
        % make data
        [allpatients, allscores] = LoadScores('outcome');
        for p = 1:length(m.patients2)
            patientnr = m.patients2(p);
            measure1(p) = m.measures(m.patients == patientnr);
            measure2(p) = m.measures2(p);
            outcome(p) = allscores(allpatients == patientnr);
        end

        xvals1(index,:) = measure2./measure1-1;
        yvals1 = outcome;

% ------------------

        load([folder 'sd-' filename '.mat'])
        
        % make data
        for p = 1:length(m.patients2)
            patientnr = m.patients2(p);
            measure1(p) = m.measures(m.patients == patientnr);
            measure2(p) = m.measures2(p);
            outcome(p) = allscores(allpatients == patientnr);
        end

        xvals2(index,:) = measure2./measure1-1;
        yvals2 = outcome;


        index = index + 1;

    end
end

clc
[b,bint,r,rint,stats] = regress(yvals1', [ones(size(xvals1,2),1) xvals1']);
stats %r^2, f statistic, p value, error estimate
[b,bint,r,rint,stats] = regress(yvals2', [ones(size(xvals2,2),1) xvals2']);
stats

xvals = [xvals1;xvals2];
yvals = yvals1;
[b,bint,r,rint,stats] = regress(yvals', [ones(size(xvals,2),1) xvals']);
stats
%[b,se,pval,inmodel,stats] = stepwisefit(xvals',yvals');
%stats
