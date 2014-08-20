function percentAlpha = GetPowerContributionAlpha(patientnr, nightnr)

    LoadFolderNames;
    percentAlpha = [];
    
    % load power contributions
    load([folderPowContributions 'percentAlpha_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat']);    
end

