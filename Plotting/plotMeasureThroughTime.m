clc;
nicecolor1 = [0.5 0.1 0.9];
nicecolor2 = [0.4 0.7 1];
[patients, outcomes] = LoadScores('outcome');

patientnr = 2;
outcome = outcomes(patients == patientnr);
bandname = 'delta';
bandfreq = 1:0.1:4;
measure = 'clustering';
filenamestr = ['P' num2str(patientnr) ', outcome ' num2str(outcome) '.  - ' bandname '.'];
titlestr = ['P' num2str(patientnr)];

m1 = GetGraphMeasures(patientnr, 1, bandname, measure);
m2 = GetGraphMeasures(patientnr, 2, bandname, measure);
    
t1 = MakeTimeLabelsWpliEpochs(size(m1,1));
t2 = MakeTimeLabelsWpliEpochs(size(m2,1));

% scattering...
t1x = repmat(t1,size(m1,2),1); 
t2x = repmat(t2,size(m2,2),1); 
%t1x(isnan(m1(:,1))) = [];
%t2x(isnan(m2(:,1))) = [];
t1x = t1x(:);
t2x = t2x(:);
m1 = m1';m1=m1(:);
m2 = m2';m2=m2(:);
%m1(isnan(m1(:,1))) = [];
%m2(isnan(m2(:,1))) = [];

% scatter plot
close all;
figure;
hold all;

sc1 = scatter(t1x,(m1(:)),'o','MarkerEdgeColor',nicecolor1,'LineWidth',1,'MarkerFaceColor',nicecolor1);
sc2 = scatter(t2x, (m2(:)),'o','MarkerEdgeColor', nicecolor2,'LineWidth',1,'MarkerFaceColor',nicecolor2);

%ylim([0 0.5]);
letter = 'a';


% magic happening here
% median1 = nanmedian(m1);
% median2 = nanmedian(m2);
% min1 = min(abs(m1-median1));
% min2 = min(abs(m2-median2));
% timeofmedian1 = find(abs(m1-median1) == min1); timeofmedian1 = timeofmedian1(1);
% timeofmedian2 = find(abs(m2-median2) == min2); timeofmedian2 = timeofmedian2(1);
% LoadChanLocs;
% LoadColorMap; mycolormap = mycolormap(15:end,:); mycolormap(4,:) = [];
% matrices1 = AggregateMaxFreqMatrix(patientnr, 1, bandfreq);
% matrices2 = AggregateMaxFreqMatrix(patientnr, 2, bandfreq);
% matrix1 = matrices1{timeofmedian1};
% matrix2 = matrices2{timeofmedian2};
% matrix1 = threshold_proportional(matrix1, 0.1);
% matrix2 = threshold_proportional(matrix2, 0.1);
% [modules1, mx1] = modularity_louvain_und(matrix1);
% [modules2, mx2] = modularity_louvain_und(matrix2);
%modules2 = ReassignModules(modules2, modules1, [], [], [], 1);
% 
% PlotGraphModules3D(matrix1, modules1, chanlocs91, mycolormap, [titlestr '\_1']);
% myStyle = hgexport('factorystyle');
% myStyle.Format = 'png';
% myStyle.Resolution = 100;
% myStyle.FontSizeMin = 100;
% myStyle.Width = 10;
% myStyle.Height = 10;
% hgexport(gcf, ['/imaging/sc03/Iulia/Overnight/p2/' titlestr '_1a.png'], myStyle);
%  
%  
% PlotGraphModules3D(matrix2, modules2, chanlocs91, mycolormap, [titlestr '\_2']);
% myStyle = hgexport('factorystyle');
% myStyle.Format = 'png';
% myStyle.Resolution = 100;
% myStyle.FontSizeMin = 100;
% myStyle.Width = 10;
% myStyle.Height = 10;
% hgexport(gcf, ['/imaging/sc03/Iulia/Overnight/p2/' titlestr '_2a.png'], myStyle);



% figure; hold all;
% plot(t1, m1, 'Color', nicecolor1, 'LineWidth', 3);
% plot(t2, m2, 'Color', nicecolor2, 'LineWidth', 2);
 
% make legend
legendstr = {'Night 1','Night 2'};
legend(legendstr,'Orientation','horizontal');
 
% title
title(titlestr);
xlabel ('Time (h)');
ylabel('Node clustering');
%ylim([2 5.5]);

% export figure
myStyle = hgexport('factorystyle');
myStyle.Format = 'png';
myStyle.Resolution = 150;
myStyle.FontSizeMin = 30;

hgexport(gcf, ['/imaging/sc03/Iulia/Overnight/p2/' titlestr '-' measure '.png'], myStyle);

