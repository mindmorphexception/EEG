function percentDelta = GetPowerContributionDelta(patientnr, nightnr)

    LoadFolderNames;
    percentDelta = [];
    
    % load power contributions
    load([folderPowContributions 'percentDelta_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat']);
    
end