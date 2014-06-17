function thresholdBadEpochsPerWpli = GetThresholdBadEpochsPerWpli(patientnr, nightnr)

    LoadFolderNames;
    index = GetPatientIndex(patientnr, nightnr);
    thresholdBadEpochsPerWpli = data{index,7};
    
end

