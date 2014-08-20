function [percentAlpha, percentTheta, percentDelta] = ComputeBandPowerContributions(patientnr, nightnr)

    % input folder
    LoadFolderNames;
    
    % filename
    filename = ['power_spectra_p' int2str(patientnr) '_overnight' int2str(nightnr)];
    
    % load freq struct
    load([folderPowspec filename '.mat']);
    
    % init
    nrEpochs = size(freqStruct.powspctrm,1);
    nrChans = size(freqStruct.powspctrm,2);
    freqs = freqStruct.freq;
    %freqStruct.powspctrm = 10*log10(freqStruct.powspctrm);
    
    % compute percent in each band at every epoch
    indicesDelta = (freqs <= 4);
    indicesTheta = (freqs >= 4 & freqs <= 8);
    indicesAlpha = (freqs >= 8 & freqs <= 12);
    indicesAllThreeBands = freqs <= 12;
    
    totalPower = sum(sum(freqStruct.powspctrm(:,:,indicesAllThreeBands),3),2);

    percentDelta = sum(sum(freqStruct.powspctrm(:,:,indicesDelta),3),2) ./ totalPower;
    percentTheta = sum(sum(freqStruct.powspctrm(:,:,indicesTheta),3),2) ./ totalPower;
    percentAlpha = sum(sum(freqStruct.powspctrm(:,:,indicesAlpha),3),2) ./ totalPower; 
    
    save([folderPowContributions 'percentDelta_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'], 'percentDelta');
    save([folderPowContributions 'percentTheta_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'], 'percentTheta');
    save([folderPowContributions 'percentAlpha_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'], 'percentAlpha');
end

