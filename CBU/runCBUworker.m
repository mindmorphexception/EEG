clear
clc
j = 0;
jobnrs = [2 3 5 7 10 11 13 15 16];
jobnrs = [3];

LoadFolderNames;
for i = 1:1
    %if(~isnan(data{jobnrs(i),5}))
        
        j = j+1;
        jobs(j).task=str2func('ComputePowSpectra'); % create a function handle for the current task
        jobs(j).n_return_values=0;
        jobs(j).input_args = {GetPatientIndex(3,1)};
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
     '/home/sc03/Iulia/eeglab'};

clear scheduler;
scheduler=cbu_scheduler('custom',{'compute',2,92,3600});

cbu_qsub(jobs,scheduler,mypaths);



