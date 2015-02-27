function [patientDelta, patientTheta, patientAlpha] = ComputeBandPowerContributionPerChannel(patientnr, nightnr)

        LoadFolderNames;
        
        % load power struct
        filename = ['power_spectra_p' int2str(patientnr) '_overnight' int2str(nightnr)];
        load([folderPowspec filename '.mat']);
        nrEpochs = size(freqStruct.powspctrm,1);

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

        % compute channel contribution in each band
        indicesDelta = (freqStruct.freq >= 1 & freqStruct.freq < 4);
        indicesTheta = (freqStruct.freq >= 4 & freqStruct.freq < 8);
        indicesAlpha = (freqStruct.freq >= 8 & freqStruct.freq <= 13);
        indicesAllThreeBands = (freqStruct.freq >= 1 & freqStruct.freq <= 13);

        % sum total power in each band (including all bands) at every channel
        totalDeltaPerChan = sum(sum(freqStruct.powspctrm(:,:,indicesDelta),3),1)';
        totalThetaPerChan = sum(sum(freqStruct.powspctrm(:,:,indicesTheta),3),1)';
        totalAlphaPerChan = sum(sum(freqStruct.powspctrm(:,:,indicesAlpha),3),1)';
        totalPowerPerChan = sum(sum(freqStruct.powspctrm(:,:,indicesAllThreeBands),3),1)';

        % divide power in each band at each channel by total power in all bands at each channel
        patientDelta = totalDeltaPerChan ./ totalPowerPerChan;
        patientTheta = totalThetaPerChan ./ totalPowerPerChan;
        patientAlpha = totalAlphaPerChan ./ totalPowerPerChan;

end

