function globalCoherence = ComputeGlobalCoherence(crossSpecMatrix)

    % initialize
    nrFreq = size(crossSpecMatrix,3);
    coeff = cell(nrFreq);
    latent = cell(nrFreq);
    explained = cell(nrFreq);
    globalCoherence = zeros(1,nrFreq);

    % get eigenvalues at every frequency
    for f = 1:nrFreq
        [coeff{f}, latent{f}, explained{f}] = pcacov(crossSpecMatrix(:,:,f));
    end
    
    % global coherence at every frequency
    for f = 1:nrFreq
        latent{f} = sort(latent{f},'descend');
        globalCoherence(f) = latent{f}(1) / sum(latent{f});
    end

end