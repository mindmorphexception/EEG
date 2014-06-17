function thresholdBadChansPerEpoch = GetThresholdBadChansPerEpoch(patientnr, nightnr)

    LoadFolderNames;
    index = GetPatientIndex(patientnr, nightnr);
    thresholdBadChansPerEpoch = data{index,6};
    
end

