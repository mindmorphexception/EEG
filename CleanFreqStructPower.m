function freqStruct = CleanFreqStructPower(freqStruct, patientnr, nightnr)

    % remove noisy epochs from power freq struct
    
    [~, noisiness] = MarkNoisyData(patientnr, nightnr);
    thresholdBadChansPerEpoch = GetThresholdBadChansPerEpoch(patientnr, nightnr) * size(noisiness,1);
    cleanEpochs = sum(noisiness,1) <= thresholdBadChansPerEpoch;
    freqStruct.powspctrm = freqStruct.powspctrm(cleanEpochs,:,:);
    freqStruct.cumsumcnt = freqStruct.cumsumcnt(cleanEpochs);
    freqStruct.cumtapcnt = freqStruct.cumtapcnt(cleanEpochs);

end

