function matrix = GetAllInOneMatrix(patientnr, nightnr, freq)

    % load all matrices
    matrices = AggregateMaxFreqMatrix(patientnr, nightnr, freq);
    matrices = matrices(cellfun(@length, matrices)>1); % remove NaNs
    
    % compute average matrix
    concatMatrices = cat(3, matrices{:});    
    matrix = mean(concatMatrices,3); % one matrix to rule them all (?)
    
    % threshold and make modules
    matr1x = threshold_proportional(matrix, 0.2);
    modules = modularity_louvain_und(matr1x);
    
    % load things
    LoadColorMap;
    LoadChanLocs;
    
    PlotGraphModules(matr1x, modules, chanlocs91, mycolormap, ['Avg P' num2str(patientnr) ' night ' num2str(nightnr)]);
    
end