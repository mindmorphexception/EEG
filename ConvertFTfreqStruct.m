function freqStructTFR = ConvertFTfreqStruct(freqStruct)

    % makes a freq struct smarter
    % so it can be plotted with fieldtrip TFR functions
    % by adding a time component in the struct

    freqStructTFR = freqStruct;
    freqStructTFR.dimord = 'chan_freq_time';
    freqStructTFR.time = MakeTimeLabelsCrossSpectraEpochs(size(freqStruct.powspctrm,1));
    freqStructTFR.powspctrm = permute(freqStructTFR.powspctrm, [2 3 1]);
    
end

