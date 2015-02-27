function MakeNoisinessStats()



    LoadFolderNames;
    LoadParams;
    
    stats = cell(1,28);
    
    for i = 1:28
        [patientnr, nightnr] = GetPatientNightNr(i);

        % load noisiness matrix
        [~, noisinessMatrix] = MarkNoisyData(patientnr, nightnr);
        thresholdBadChansPerEpochs = data{i,6};
        thresholdBadEpochsPerWpli = GetThresholdBadEpochsPerWpli(patientnr, nightnr) * wpliProcessingWindow;
        nrChans = size(noisinessMatrix,1);
        nrEpochs = size(noisinessMatrix,2);
        nrWindows = floor((nrEpochs - wpliProcessingWindow)/wpliWindowOverlap)+1;

        stats{i}.patientnr = patientnr;
        stats{i}.nightnr = nightnr;
        stats{i}.maxBadChans = thresholdBadChansPerEpochs * nrChans;
        stats{i}.maxBadEpochs = thresholdBadEpochsPerWpli;
        stats{i}.noisyEpochs = zeros(1,stats{i}.maxBadChans);
        stats{i}.goodEpochs = 0;
        stats{i}.badEpochs = 0;
        stats{i}.badWpliWindows = 0;
        stats{i}.goodWpliWindows = 0;
        stats{i}.noisyWpliWindows = zeros(1,stats{i}.maxBadEpochs);


        % interpolate noisy channels in each epoch
        for e = 1:nrEpochs

            noisyChans = sum(noisinessMatrix(:,e));

            if noisyChans == 0
                stats{i}.goodEpochs = stats{i}.goodEpochs + 1;
            elseif noisyChans <= stats{i}.maxBadChans ;
                stats{i}.noisyEpochs(noisyChans) = stats{i}.noisyEpochs(noisyChans) + 1;
            else
                stats{i}.badEpochs = stats{i}.badEpochs + 1;
            end

        end
        
        
        % wpli
        for index = 1 : nrWindows
        
            firstEpoch = 1 + wpliWindowOverlap * (index-1);
            lastEpoch = firstEpoch + wpliProcessingWindow - 1;
           
            % skip bad epochs from the calculation
            nrBadEpochs = 0;
            for e = firstEpoch:lastEpoch
                if sum(noisinessMatrix(:,e)) > stats{i}.maxBadChans 
                    nrBadEpochs = nrBadEpochs + 1;
                end
            end

            % skip calculating the current wpli if too many epochs are bad
            if nrBadEpochs > thresholdBadEpochsPerWpli
                stats{i}.badWpliWindows = stats{i}.badWpliWindows + 1;
            elseif nrBadEpochs == 0
                stats{i}.goodWpliWindows = stats{i}.badWpliWindows + 1;
            else
                stats{i}.noisyWpliWindows(nrBadEpochs) = stats{i}.noisyWpliWindows(nrBadEpochs) + 1;
            end

        end
        
    end
    
    save([folderStdDev 'noisiness_stats.mat'],'stats');
    
    for i = 1:28
        tsrt = ['p' num2str(stats{i}.patientnr) '_' num2str(stats{i}.nightnr) ' '];
        tsrt = [tsrt num2str(stats{i}.goodEpochs)];

        for x = 1:stats{i}.maxBadChans
            tsrt = [tsrt ' ' num2str(stats{i}.noisyEpochs(x))];
        end

        tsrt = [tsrt ' ' num2str(stats{i}.badEpochs)];
        fprintf('%s\n', tsrt);
    end
    
    fprintf('=================\n');
    for i = 1:28
        tsrt = ['p' num2str(stats{i}.patientnr) '_' num2str(stats{i}.nightnr) ' '];
        tsrt = [tsrt num2str(stats{i}.goodWpliWindows)];

        for x = 1:stats{i}.maxBadEpochs
            tsrt = [tsrt ' ' num2str(stats{i}.noisyWpliWindows(x))];
        end

        tsrt = [tsrt ' ' num2str(stats{i}.badWpliWindows)];

        fprintf('%s\n', tsrt);
    end
    
end