clear
clc
varname = 'matrix_max';
m1 = ComputeGraphMeasures(varname,'1_p10_overnight1 20120910 1813');
m2 = ComputeGraphMeasures(varname,'2_p10_overnight2 20120912 1812');
%m3 = ComputeGraphMeasures(varname,'3_p2_overnight3 20120613 1752');

figure
hold on
plot(abs(m1.meanclustering),'blue')
plot(abs(m2.meanclustering),'green')
legend('First night','Second night')
title('Absolute value of mean clustering coefficient for one hour of data')
hold off


figure 
hold on
plot(abs(m1.maxclustering),'blue')
plot(abs(m2.maxclustering),'green')
legend('First night','Second night')
title('Absolute value of max clustering coefficient for one hour of data')
hold off


figure
hold on
plot(m1.globalEfficiency,'blue')
%axis([-10 310 -10 10])
plot(m2.globalEfficiency,'green')
legend('First night','Second night','Third night')
title('Global efficiency for one hour of data')
hold off


figure
hold on
plot(m1.meanbetweenness,'blue')
%axis([-10 310 -10 10])
hold on
plot(m2.meanbetweenness,'green')
legend('First night','Second night')
title('Mean betweenness for one hour of data')
hold off


figure
hold on
plot(m1.maxbetweenness,'blue')
plot(m2.maxbetweenness,'green')
legend('First night','Second night')
title('Maximum betweenness for one hour of data')

figure
hold on
plot(m1.density_dir,'blue')
plot(m2.density_dir,'green')
legend('First night','Second night')
title('Density (really) for one hour of data with wpli thresholded at 0.5')
hold off

figure
hold on
plot(m1.modularity,'blue')
plot(m2.modularity,'green')
%axis([-10 310 -50 50])
legend('First night','Second night')
title('Modularity for one hour of data')
hold off


figure
hold on
plot(m1.meanparticipation,'blue')
plot(m2.meanparticipation,'green')
legend('First night','Second night')
title('Mean participation coefficient for one hour of data')
hold off


figure
hold on
plot(m1.maxparticipation,'blue')
plot(m2.maxparticipation,'green')
legend('First night','Second night')
title('Maximum participation coefficient for one hour of data')
hold off

