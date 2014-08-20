function percentTheta = GetPowerContributionTheta(patientnr, nightnr)

    LoadFolderNames;
    percentTheta = [];
    
    % load power contributions
    load([folderPowContributions 'percentTheta_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat']);
    
end