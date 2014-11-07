clear
clc
j = 0;
jobnrs = [1:23];
LoadFolderNames;
for i = 24:28
    [patientnr, nightnr] = GetPatientNightNr(i);

    j = j+1;
    jobs(j).task=str2func('PlotGlobalCoherence'); % create a function handle for the current task
    jobs(j).n_return_values=0;
    jobs(j).input_args = {patientnr, nightnr, 1};

    
%      j = j+1;
%      jobs(j).task=str2func('bandpower'); % create a function handle for the current task
%      jobs(j).n_return_values=0;
%      jobs(j).input_args = {'16', 'E11', [8 12]};%{patientnr, nightnr, [1:0.1:4], [0.3:0.05:0.5], 'delta'};
%  
%     j = j+1;
%     jobs(j).task=str2func('calcspec'); % create a function handle for the current task
%     jobs(j).n_return_values=0;
%     jobs(j).input_args = {'16'};%{patientnr, nightnr, [1:0.1:4], [0.3:0.05:0.5], 'delta'};
%     
      
%     j = j+1;
%     jobs(j).task=str2func('SteinversionComputeCrossSpectra'); % create a function handle for the current task
%     jobs(j).n_return_values=0;
%     jobs(j).input_args = {16};%{patientnr, nightnr, [1:0.1:4], [0.3:0.05:0.5], 'delta'};
%     

    
end

mypaths = { '/home/sc03/Iulia/Iulia', ...
     '/home/sc03/Iulia/Srivas', ...
     '/home/sc03/Iulia/Srivas/Overnight', ...
     '/home/sc03/Iulia/Srivas/connectivity', ...
     '/home/sc03/Iulia/Srivas/preprocessing', ...
     '/home/sc03/Iulia/fieldtrip/external/egi_mff/java', ...
     '/home/sc03/Iulia/fieldtrip/utilities', ...
     '/home/sc03/Iulia/fieldtrip', ...
     '/home/sc03/Iulia/BCT', ...
     '/home/sc03/Iulia/eeglab/plugins/MFFimport1.00', ...
     '/home/sc03/Iulia/eeglab',...
     };

clear scheduler;
scheduler=cbu_scheduler('custom',{'compute',2,8,6400,'/imaging/sc03/Iulia/_cbu-cluster-outputs'});

cbu_qsub(jobs,scheduler,mypaths);



