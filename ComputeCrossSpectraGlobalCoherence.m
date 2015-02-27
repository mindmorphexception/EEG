function ComputeCrossSpectraGlobalCoherence(patientnr, nightnr, freqStruct)

    nrFreq = length(freqStruct.freq);
    nrEpochs = size(freqStruct.crsspctrm,1);
    nrWindows = length(1:10:nrEpochs-10+1);
    gc = zeros(nrWindows,nrFreq);
    fe = cell(1,nrFreq);
    
    cleanedCrsSpctrm = sign(imag(freqStruct.crsspctrm)); %((imag(freqStruct.crsspctrm).*sign(imag(freqStruct.crsspctrm))));
   
    for f = 1:nrFreq
        f
        [gc(:,f),fe{f}] = ComputeGlobalCoherence(cleanedCrsSpctrm(:,:,f),10);
    end
    save(['/imaging/sc03/Iulia/Sedation/cross-spectra-global-coherence/p' num2str(patientnr) '_night' num2str(nightnr) '_gc.mat'], 'gc');
    save(['/imaging/sc03/Iulia/Sedation/cross-spectra-global-coherence/p' num2str(patientnr) '_night' num2str(nightnr) '_fe.mat'], 'fe');

end
