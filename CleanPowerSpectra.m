function CleanPowerSpectra(patientnr, nightnr)

    % input folder
    LoadFolderNames;
    
    % filename
    filename = ['power_spectra_p' int2str(patientnr) '_overnight' int2str(nightnr)];
    
    % load freq struct
    load([folderPowspec filename '.mat']);
    
    % clean struct
    freqStruct = CleanFreqStructPower(freqStruct, patientnr, nightnr);
    
    % new filename
    filename = ['power_spectra_clean_p' int2str(patientnr) '_overnight' int2str(nightnr)];
    
    % save clean freq struct
    save([folderPowspecClean filename '.mat'], 'freqStruct');

end

