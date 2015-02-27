function ComputeModuleStability(patientnr, nightnr, aux)

    LoadFolderNames;
    LoadChanLocs;

    % load modules 
    load([folderMeasures 'communitystruct_p' int2str(patientnr) '_overnight' int2str(nightnr) '_' aux '.mat']);
    
    % init
    nrEpochs = length(modules);
    config0 = config1 = [];
    
    % loop through all epochs
    for t = 1:nrEpochs
        
        if(isempty(modules{t})) 
            config0 = config1 = []; % if epoch is too noisy, reset
        else
            if (isempty(config0))
                config0 = modules{t};   % if no history, initialize
            else
                config1 = modules{t};   % if there is history, do computation
                
                config0 = config1;      % finally, store current config as history
            end
        end
        
        
    end

end