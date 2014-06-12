function med = GetStdDevMedianThreshold(patientnr, nightnr)
    
    LoadFolderNames;
    filename = ['stddev_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'];
    load([folderStdDev filename]);
    med = median(stddevs(:)) + 200;
    
    med = 500;
    
end

