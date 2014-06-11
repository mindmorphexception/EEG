function freqStruct = AppendPowSpectra(freqStruct, newStruct, validate)

    % append newly calculated pow-spectra to a pow-spectra struct
    
    % if freqStruct is empty, return the new struct
    if (freqStruct.epochIndex == 1)
        freqStruct.label = newStruct.label;
        freqStruct.dimord = newStruct.dimord;
        freqStruct.freq = newStruct.freq;
        freqStruct.elec = newStruct.elec;
        freqStruct.cfg = newStruct.cfg;
        
        freqStruct.powspctrm = zeros(freqStruct.totalEpochs, length(newStruct.label), length(newStruct.freq));
        freqStruct.cumsumcnt = zeros(freqStruct.totalEpochs, 1);
        freqStruct.cumtapcnt = zeros(freqStruct.totalEpochs, 1);    
    elseif (validate) % check structs for equality
        ValidateFieldEquality(freqStruct, newStruct, 'label');
        ValidateFieldEquality(freqStruct, newStruct, 'dimord');
        ValidateFieldEquality(freqStruct, newStruct, 'freq');
        ValidateFieldEquality(freqStruct, newStruct, 'elec');
    end
        
    newEpochIndex = freqStruct.epochIndex + size(newStruct.powspctrm,1);
    
    % append new struct to existing struct
    freqStruct.powspctrm(freqStruct.epochIndex : (newEpochIndex-1),:,:) = newStruct.powspctrm;
    freqStruct.cumsumcnt(freqStruct.epochIndex : (newEpochIndex-1),:) = newStruct.cumsumcnt;
    freqStruct.cumtapcnt(freqStruct.epochIndex : (newEpochIndex-1),:) = newStruct.cumtapcnt;
    
    freqStruct.epochIndex = newEpochIndex;

end