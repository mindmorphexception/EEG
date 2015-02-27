function smallworldness = GetSmallWorldness(patientnr, nightnr, aux) 
% Relative - not compared to a null network.

    LoadFolderNames;
    
    % load measures
    load([folderMeasures 'measures_p' num2str(patientnr) '_overnight' num2str(nightnr) '_' aux '.mat']);

    % init
    nrEpochs = length(measures);
    smallworldness = zeros(1, nrEpochs);

    % make small worldness
    for t = 1:nrEpochs
        if (isstruct(measures{t}))
            smallworldness(t) = measures{t}.meanclustering / measures{t}.pathlen;
        else
            smallworldness(t) = NaN;
        end
    end
    
end