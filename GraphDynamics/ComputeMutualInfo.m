function vi = ComputeMutualInfo(patientnr, nightnr,aux)

    % load community structure
    load(['/imaging/sc03/Iulia/Overnight/measures/communitystruct_p' int2str(patientnr) '_overnight' int2str(nightnr) '_' aux '.mat']);
    
    % init
    nrEpochs = length(modules);
    config0 = [];
    config1 = [];
    vi = NaN * zeros(1, nrEpochs);
    mi = NaN * zeros(1, nrEpochs);
    
    % loop through all epochs
    for t = 1:nrEpochs
        
        if(isempty(modules{t})) 
            config0 = [];
            config1 = []; % if epoch is too noisy, reset
        else
            if (isempty(config0))
                config0 = modules{t};   % if no history, initialize
            else
                config1 = modules{t};   % if there is history, do computation
                
                [vi(t), mi(t)] = partition_distance(config0, config1);
                
                config0 = config1;      % finally, store current config as history
            end
        end
        
        
    end
    
    % plot vi and mi
%     timesteps = MakeTimeLabelsWpliEpochs(nrEpochs);
%     plot(timesteps,vi,timesteps,mi,'LineWidth',2);
%     legend('Normalized variation of information', 'Normalized mutual information');
%     title(['Mutual info for patient ' num2str(patientnr) ' night ' num2str(nightnr)]);
     

end