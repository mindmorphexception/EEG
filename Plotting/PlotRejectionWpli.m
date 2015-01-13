function PlotRejectionWpli(patientnr, nightnr)
    
    LoadParams;
    LoadFolderNames;
    
    [~, noisiness] = MarkNoisyData(patientnr, nightnr);
    nrEpochs = size(noisiness, 2);
    nrWindows = floor((nrEpochs - wpliProcessingWindow)/wpliWindowOverlap)+1;
    
    badEpochs = zeros(1,nrWindows);
    removedEpochs = zeros(1,nrWindows);
    thresholdBadChansPerEpoch = GetThresholdBadChansPerEpoch(patientnr, nightnr) * size(noisiness,1);
    thresholdBadEpochsPerWpli = GetThresholdBadEpochsPerWpli(patientnr, nightnr) * wpliProcessingWindow;
    
    for index = 1:nrWindows
        
        firstEpoch = 1 + wpliWindowOverlap * (index-1);
        lastEpoch = firstEpoch + wpliProcessingWindow - 1;
        fprintf('*** Epochs %d to %d...\n',firstEpoch,lastEpoch);
        
        % skip bad epochs from the calculation
        nrBadEpochs = 0;

        for e = firstEpoch:lastEpoch
            if sum(noisiness(:,e)) > thresholdBadChansPerEpoch
                nrBadEpochs = nrBadEpochs + 1;
            end
        end
        
       badEpochs(index) = nrBadEpochs;
       
       if nrBadEpochs > thresholdBadEpochsPerWpli
            removedEpochs(index) = nrBadEpochs;
       end
       
    end
    
    hold on;
    bar(badEpochs);
    hold on;
    bar(removedEpochs,'red');
    xlabel('Wpli windows');
    ylabel('Nr. bad windows');
    ylim([0 12]);
    set(gca,'ytick',[0:12]);
    set(gca,'yticklabel',[0:12]);
end

