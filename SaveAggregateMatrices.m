function SaveAggregateMatrices(patientnr, nightnr)

    LoadFolderNames;
    
    res = [];
    [res.matrices, res.maxFrequencies] = AggregateMaxFreqMatrix(patientnr, nightnr, 1:0.1:4);
    save([folderMatrix 'p' num2str(patientnr) '_overnight' num2str(nightnr) '_delta.mat'],'res');

    res = [];
    [res.matrices, res.maxFrequencies] = AggregateMaxFreqMatrix(patientnr, nightnr, 4:0.1:8);
    save([folderMatrix 'p' num2str(patientnr) '_overnight' num2str(nightnr) '_theta.mat'],'res');

    res = [];
    [res.matrices, res.maxFrequencies] = AggregateMaxFreqMatrix(patientnr, nightnr, 8:0.1:13);
    save([folderMatrix 'p' num2str(patientnr) '_overnight' num2str(nightnr) '_alpha.mat'],'res');


end

