clear
j = 0;
jobnrs = [GetPatientIndex(2,2) GetPatientIndex(3,1) GetPatientIndex(5,1)];

LoadFolderNames;
for i = 1:length(jobnrs)
    if(~isnan(data{jobnrs(i),5}))
        j = j+1;
        jobs(j).task=str2func('MarkNoisyData'); % create a function handle for the current task
        jobs(j).n_return_values=0;
        [patientnr, nightnr] = GetPatientNightNr(jobnrs(i));
        jobs(j).input_args = {patientnr, nightnr};
    end
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
scheduler=cbu_scheduler('custom',{'compute',1,32,3600});

cbu_qsub(jobs,scheduler,mypaths);



