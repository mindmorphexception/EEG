function PlotWpliMatrix()
    
    bandname = 'delta';
    bandwidth = [1:0.1:4];

    % load folder names
    LoadFolderNames;
    
    % load chanlocs
    LoadChanLocs;
    
    % load scores
    [patients, scores] = LoadScores('outcome');
    [patients2, scores2] = LoadScores('crs-2');
    
    for i = 1:length(patients)
        patientnr = patients(i);
        hasSecondNight = (sum(patients2 == patientnr)>0) && scores2(patients2 == patientnr) ~= 0;
        
        % night 1
        matrices = AggregateMaxFreqMatrix(patientnr, 1, bandwidth);
        matrices = matrices(cellfun(@length, matrices)>1); % remove NaNs
        
        if(length(matrices) >= 10)
            concatMatrices = cat(3, matrices{:});    
            matrix = mean(concatMatrices,3);
            h = imagesc(matrix); colorbar; caxis([0 0.8]);
            print(imgcf, '-djpeg', '-r80', ['/imaging/sc03/Iulia/Overnight/figures-wpli-matrices/' bandname '_P' num2str(patientnr) '_1-mean.jpg']);
        end
        
        % night 2
        if(~hasSecondNight)
            continue;
        end
        
        matrices = AggregateMaxFreqMatrix(patientnr, 2, bandwidth);
        matrices = matrices(cellfun(@length, matrices)>1);
        
        if(length(matrices) >= 10)
            concatMatrices = cat(3, matrices{:});    
            matrix = mean(concatMatrices,3);
            h = imagesc(matrix); colorbar; caxis([0 0.8]);
            print(imgcf, '-djpeg', '-r80', ['/imaging/sc03/Iulia/Overnight/figures-wpli-matrices/' bandname '_P' num2str(patientnr) '_2-mean.jpg']);
        end
    end

    
    %title(['WPLI mean in ' bandname ' band']);
    %set(gcf,'PaperPosition',[0 0 500 250]);
    %print(h, '-djpeg', '-r10', ['/imaging/sc03/Iulia/Overnight/figures-wpli-topo/all-mean-' bandname '.jpg']);
    
end