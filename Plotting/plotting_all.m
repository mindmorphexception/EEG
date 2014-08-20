colors = {'blue','cyan','red','black','magenta'};
m = measures_10hz_thresh;
measures = m;

figure

subplot(3,3,1);
hold on
for p = 1:length(measures)
    plot([mean(abs(m{p}.night1.meanclustering)) mean(abs(m{p}.night2.meanclustering))], colors{p});
end
title('Mean of absolute value of mean clustering coefficient for one hour of data')


subplot(3,3,2);
hold on
for p = 1:length(measures)
    plot([mean(abs(m{p}.night1.maxclustering)) mean(abs(m{p}.night2.maxclustering))], colors{p});
end
title('Mean of absolute value of max clustering coefficient for one hour of data')

subplot(3,3,3);
hold on
for p = 1:length(measures)
    plot([mean(abs(m{p}.night1.globalEfficiency)) mean(abs(m{p}.night2.globalEfficiency))], colors{p});
end
title('Mean of global efficiency for one hour of data')


subplot(3,3,4);
hold on
for p = 1:length(measures)
    plot([mean(abs(m{p}.night1.meanbetweenness)) mean(abs(m{p}.night2.meanbetweenness))], colors{p});
end
title('Mean of mean betweenness for one hour of data')


subplot(3,3,5);
hold on
for p = 1:length(measures)
    plot([mean(abs(m{p}.night1.maxbetweenness)) mean(abs(m{p}.night2.maxbetweenness))], colors{p});
end
title('Mean of max betweenness for one hour of data')


subplot(3,3,6);
hold on
for p = 1:length(measures)
    plot([mean(abs(m{p}.night1.density_dir)) mean(abs(m{p}.night2.density_dir))], colors{p});
end
title('Mean of density for one hour of data')



subplot(3,3,7);
hold on
for p = 1:length(measures)
    plot([mean(abs(m{p}.night1.modularity)) mean(abs(m{p}.night2.modularity))], colors{p});
end
title('Mean of modularity for one hour of data')

subplot(3,3,8);
hold on
for p = 1:length(measures)
    plot([mean(abs(m{p}.night1.meanparticipation)) mean(abs(m{p}.night2.meanparticipation))], colors{p});
end
title('Mean of mean participation for one hour of data')


subplot(3,3,9);
hold on
for p = 1:length(measures)
    plot([mean(abs(m{p}.night1.maxparticipation)) mean(abs(m{p}.night2.maxparticipation))], colors{p});
end
title('Mean of max participation for one hour of data')

legend('p2','p3','p5','p10','p16');

