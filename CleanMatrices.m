function matrices = CleanMatrices(matrices, noisinessMatrix, patientnr, nightnr)
% cleans a cell of matrices according to their noisiness matrix
    LoadParams;

    epochIndex = 1;
    nrChans = size(noisinessMatrix,1);
    nrMatricesCleaned = 0;
    thresholdBadEpochsPerWpli = GetThresholdBadEpochsPerWpli(patientnr, nightnr);
    
    % for each epoch in the matrices
    for wpliIndex = 1:length(matrices)
        nrBadEpochs = 0;
        
        % for each small epoch
        for i = 1:processingWindow
            % increase the number of bad epochs if epoch is marked as bad
            if (sum(noisinessMatrix(:,epochIndex+i-1)) == nrChans)
               nrBadEpochs = nrBadEpochs + 1;
            end
        end
        
        % set current matrix to NaN if there are too many bad epochs
        if(nrBadEpochs > thresholdBadEpochsPerWpli * processingWindow)
            matrices{wpliIndex} = NaN;
            nrMatricesCleaned = nrMatricesCleaned + 1;
        end
        
        % advance epoch index considering the epoch overlap
        epochIndex = epochIndex + windowOverlap;
    end
    
    fprintf('*** Cleaned %d matrices out of %d (%f%%).\n', nrMatricesCleaned, length(matrices), nrMatricesCleaned/length(matrices));
end
