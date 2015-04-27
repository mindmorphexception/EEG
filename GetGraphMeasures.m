function thisMeasure = GetGraphMeasures(patientnr, nightnr, aux, measureName)

    LoadFolderNames;

    % load measures
    load([folderMeasures 'measures_p' num2str(patientnr) '_overnight' num2str(nightnr) '_' aux '.mat']);
    
    % init
    nrEpochs = length(measures);

    % find out measure length
    i = 1;
    while ~isstruct(measures{i})
        i = i+1;
    end
    L = length(measures{i}.(measureName));

    % init
    thisMeasure = zeros(nrEpochs,L);
    
    for t = 1:nrEpochs
        if (isstruct(measures{t}))
            thisMeasure(t,:) = measures{t}.(measureName);
        else
            thisMeasure(t,:) = NaN * ones(1,L);
        end
    end
    
end