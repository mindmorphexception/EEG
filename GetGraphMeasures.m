function thisMeasure = GetGraphMeasures(patientnr, nightnr, aux, measureName)

    LoadFolderNames;

    % load measures
    load([folderMeasures 'measures_p' num2str(patientnr) '_overnight' num2str(nightnr) '_' aux '.mat']);
    
    % init
    nrEpochs = length(measures);
    thisMeasure = zeros(1, nrEpochs);
    
    for t = 1:nrEpochs
        if (isstruct(measures{t}))
            thisMeasure(t) = measures{t}.(measureName);
        else
            thisMeasure(t) = NaN;
        end
    end
    
end