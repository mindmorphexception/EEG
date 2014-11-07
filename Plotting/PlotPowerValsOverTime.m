function PlotPowerValsOverTime(patientnr, nightnr)
    
    figure;
    
     % input folder
    LoadFolderNames;
    
    % filename
    filename = ['power_spectra_clean_p' int2str(patientnr) '_overnight' int2str(nightnr)];
    
    % load freq struct
    load([folderPowspecClean filename '.mat']);
    
    % set up indices
    chanIndex = (ismember(freqStruct.label,'E11'));
    freqIndicesAlpha = (freqStruct.freq <= 12 & freqStruct.freq >= 8);
    freqIndicesAll = (freqStruct.freq <= 12 & freqStruct.freq >= 1);
    
    % get power values
    alphaPowerOverTimeFreqs = freqStruct.powspctrm(:,chanIndex,freqIndicesAlpha);
    totalPowerOverTimeFreqs = freqStruct.powspctrm(:,chanIndex,freqIndicesAll);
    
    % sum power values at all frequencies
    alphaPowerOverTime = mean(alphaPowerOverTimeFreqs,3);
    allPower = sum(totalPowerOverTimeFreqs,3);
    meanAlphaPow = mean(alphaPowerOverTime);
    meanAllPow = mean(allPower);
    
    
    % plot them
    bar((alphaPowerOverTime - meanAlphaPow) / meanAlphaPow * 100);
    title('Alpha power over time at chan Fz (E11)');
    ylim([-250 250]);

end