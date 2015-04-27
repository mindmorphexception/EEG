function modspan = GetModularSpan(patientnr, nightnr, freqname)

    LoadFolderNames;
    
    load([folderMeasures 'modspanmean_p' num2str(patientnr) '_overnight' num2str(nightnr) '_' freqname '.mat']);

end

