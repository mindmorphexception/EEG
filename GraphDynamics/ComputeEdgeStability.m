function ComputeEdgeStability(patientnr, nightnr, freq)
    % Individual edge stability is the product of all values for an edge.
    % Overall edge stability is the normalized sum of edge stabilities.

    % load wpli matrices
    matrices = AggregateMaxFreqMatrix(patientnr, nightnr, freq);
    
    % init
    nrChans = 91;
    nrEpochs = length(matrices);
    nrGoodEpochs = 0;
    matrix = ones(nrChans, nrChans);
    
    % compute edge stability
    for t = 1:nrEpochs
        if( ~isnan(matrices{t}) )
            nrGoodEpochs = nrGoodEpochs + 1;
            matrix = matrix .* matrices{t};
        end
    end
    
    % normalize
    
        %hmm
    

end