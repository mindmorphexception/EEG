function thresholdChanStdDev = GetThresholdChannelStdDev(patientnr, nightnr)

    LoadFolderNames;
    index = GetPatientIndex(patientnr, nightnr);
    thresholdChanStdDev = data{index,5};
    
    
%     LoadFolderNames;
%     filename = ['stddev_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'];
%     load([folderStdDev filename]);
%     med = median(stddevs(:)) + 200;
%     
%     med = 500;
    
end

