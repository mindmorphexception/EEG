function thresholdBadEpochsPerGlobalCoherence = GetThresholdBadEpochsPerGlobalCoherence(patientnr, nightnr)

    LoadFolderNames;
    index = GetPatientIndex(patientnr, nightnr);
    thresholdBadEpochsPerGlobalCoherence = data{index,8};
    
    thresholdBadEpochsPerGlobalCoherence = 0.4;
    
end