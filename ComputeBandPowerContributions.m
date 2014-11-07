function [percentAlpha, percentTheta, percentDelta] = ComputeBandPowerContributions(patientnr, nightnr)

    % input folder
    LoadFolderNames;
    
    % filename
    filename = ['power_spectra_clean_p' int2str(patientnr) '_overnight' int2str(nightnr)];
    
    % load freq struct
    load([folderPowspecClean filename '.mat']);
    
    % init
    nrEpochs = size(freqStruct.powspctrm,1);
    nrChans = size(freqStruct.powspctrm,2);
    freqs = freqStruct.freq;
    %freqStruct.powspctrm = 10*log10(freqStruct.powspctrm);
    
    % store frequency indices for bands
    freqIndicesDelta = (freqs >= 1 & freqs <= 4);
    freqIndicesTheta = (freqs >= 4 & freqs <= 8);
    freqIndicesAlpha = (freqs >= 8 & freqs <= 12);
    freqIndicesAllThreeBands = (freqs >= 1 & freqs <= 12);
    
    % store channel indices to use for each band
    [chanIndicesAlpha, chanIndicesTheta, chanIndicesDelta] = GetChannelBandIndices(freqStruct.label);
    chanIndicesAllThreeBands = [chanIndicesDelta chanIndicesTheta chanIndicesAlpha];
                   
    % compute percent in each band at every epoch
    totalPower = sum(sum(freqStruct.powspctrm(:,chanIndicesAllThreeBands,freqIndicesAllThreeBands),3),2);

    percentDelta = sum(sum(freqStruct.powspctrm(:,chanIndicesDelta,freqIndicesDelta),3),2) ./ totalPower;
    percentTheta = sum(sum(freqStruct.powspctrm(:,chanIndicesTheta,freqIndicesTheta),3),2) ./ totalPower;
    percentAlpha = sum(sum(freqStruct.powspctrm(:,chanIndicesAlpha,freqIndicesAlpha),3),2) ./ totalPower; 
    
    save([folderPowContributions 'percentDelta_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'], 'percentDelta');
    save([folderPowContributions 'percentTheta_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'], 'percentTheta');
    save([folderPowContributions 'percentAlpha_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'], 'percentAlpha');
end

