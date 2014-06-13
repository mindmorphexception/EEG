job.task=str2func('ComputePowSpectra'); % create a function handle for the current task
job.n_return_values=0;
job.input_args={};

clear scheduler;
scheduler=cbu_scheduler('custom',{'compute',1,6,1800});

cbu_qsub(job,scheduler);