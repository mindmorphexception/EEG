clc;
nicecolor1 = [0.5 0.1 0.9];
nicecolor2 = [0.4 0.7 1];
[patients, outcomes] = LoadScores('outcome');

patientnr = 2;
outcome = outcomes(patients == patientnr);
bandname = 'theta';
bandfreq = 4:0.1:8;
measure = 'std-wpli-theta';
filenamestr = ['P' num2str(patientnr) ', outcome ' num2str(outcome) '.  - ' bandname '.'];
titlestr = ['P' num2str(patientnr)];

m1 = GetStdWpli(patientnr, 1, bandfreq);
m2 = GetStdWpli(patientnr, 2, bandfreq);

% %std-seq:
% t1 = MakeTimeLabelsWpliEpochs(size(m1,1));
% t2 = MakeTimeLabelsWpliEpochs(size(m2,1));
% 
% % computing...
% t1x = repmat(t1,size(m1,2),1); 
% t2x = repmat(t2,size(m2,2),1); 
% t1x = t1x(:);
% t2x = t2x(:);
% m1 = m1';m1=m1(:);
% m2 = m2';m2=m2(:);
% 
% 
% % magic happening here
% median1 = nanmedian(m1)
% median2 = nanmedian(m2)
% min1 = min(abs(m1-median1));
% min2 = min(abs(m2-median2));
% timeofmedian1 = find(abs(m1-median1) == min1); timeofmedian1 = timeofmedian1(1);
% timeofmedian2 = find(abs(m2-median2) == min2); timeofmedian2 = timeofmedian2(1);
% matrices1 = AggregateMaxFreqMatrix(patientnr, 1, bandfreq);
% matrices2 = AggregateMaxFreqMatrix(patientnr, 2, bandfreq);
% matrix1 = matrices1{timeofmedian1};
% matrix2 = matrices2{timeofmedian2};


% std only
LoadChanLocs;
mycolormap = [nicecolor1; nicecolor2];
matrix1 = threshold_proportional(m1,0.1); 
matrix2 = threshold_proportional(m2,0.1);
[modules1, mx1] = modularity_louvain_und(matrix1);
[modules2, mx2] = modularity_louvain_und(matrix2);
modules2 = ReassignModules(modules2, modules1, [], [], [], 1);
 
% plotting
PlotGraphModules(matrix1, ones(size(modules1)), chanlocs91, mycolormap, [titlestr '\_1']);
%figure; imagesc(matrix1); caxis([0 1]); xlabel('Channel'); ylabel('Channel');
title([titlestr '\_1']);
myStyle = hgexport('factorystyle');
myStyle.Format = 'png';
myStyle.Resolution = 100;
myStyle.FontSizeMin = 100;
myStyle.Height = 10;
%myStyle.Width = 10;
hgexport(gcf, ['/imaging/sc03/Iulia/Overnight/p2/' titlestr '_1-wplimat.png'], myStyle);

PlotGraphModules(matrix2, ones(size(modules2))+1, chanlocs91, mycolormap, [titlestr '\_2']);
%figure; imagesc(matrix2); caxis([0 1]); xlabel('Channel'); ylabel('Channel');
title([titlestr '\_2']);
myStyle = hgexport('factorystyle');
myStyle.Format = 'png';
myStyle.Resolution = 100;
myStyle.FontSizeMin = 100;
myStyle.Height = 10;
%myStyle.Width = 10;
hgexport(gcf, ['/imaging/sc03/Iulia/Overnight/p2/' titlestr '_2-wplimat.png'], myStyle);



