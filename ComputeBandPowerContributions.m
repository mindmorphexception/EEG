function [percentAlpha, percentTheta, percentDelta] = ComputeBandPowerContributions(patientnr, nightnr)

    % input folder
    LoadFolderNames;
    
    % filename
    filename = ['power_spectra_p' int2str(patientnr) '_overnight' int2str(nightnr)];
    
    % load freq struct
    load([folderPowspec filename '.mat']);
    
    % init
    %freqStruct.powspctrm = mag2db(freqStruct.powspctrm);
    nrEpochs = size(freqStruct.powspctrm,1);
    nrChans = size(freqStruct.powspctrm,2);
    freqs = freqStruct.freq;
    
    % clean
    [~, noisinessMatrix] = MarkNoisyData(patientnr, nightnr);
    thresholdBadChansPerEpochs = GetThresholdBadChansPerEpoch(patientnr, nightnr);
    
    badEpochs = [];
    for e = 1:nrEpochs
        if sum(noisinessMatrix(:,e)) > thresholdBadChansPerEpochs * size(noisinessMatrix, 1)
            badEpochs = [badEpochs e];
        end
    end
    freqStruct.powspctrm(badEpochs,:,:) = [];
    nrEpochs = size(freqStruct.powspctrm,1);
    
    % store frequency indices for bands
    freqIndicesDelta = (freqs >= 1 & freqs < 4);
    freqIndicesTheta = (freqs >= 4 & freqs < 8);
    freqIndicesAlpha = (freqs >= 8 & freqs <= 13);
    freqIndicesAllThreeBands = (freqs >= 1 & freqs <= 13);
    
    % store channel indices to use for each band
    [chanIndicesAlpha, chanIndicesTheta, chanIndicesDelta] = GetChannelBandIndices(freqStruct.label);
                   
    % compute percent in each band at every epoch
    totalPowerAlpha = sum(sum(freqStruct.powspctrm(:,chanIndicesAlpha,freqIndicesAllThreeBands),3),2);
    totalPowerTheta = sum(sum(freqStruct.powspctrm(:,chanIndicesTheta,freqIndicesAllThreeBands),3),2);
    totalPowerDelta = sum(sum(freqStruct.powspctrm(:,chanIndicesDelta,freqIndicesAllThreeBands),3),2);

    percentDelta = sum(sum(freqStruct.powspctrm(:,chanIndicesDelta,freqIndicesDelta),3),2) ./ totalPowerDelta;
    percentTheta = sum(sum(freqStruct.powspctrm(:,chanIndicesTheta,freqIndicesTheta),3),2) ./ totalPowerTheta;
    percentAlpha = sum(sum(freqStruct.powspctrm(:,chanIndicesAlpha,freqIndicesAlpha),3),2) ./ totalPowerAlpha; 
    
    save([folderPowContributions 'percentDelta_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'], 'percentDelta');
    save([folderPowContributions 'percentTheta_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'], 'percentTheta');
    save([folderPowContributions 'percentAlpha_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'], 'percentAlpha');
end

