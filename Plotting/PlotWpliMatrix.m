function PlotWpliMatrix()
    
    bandname = 'alpha';
    bandwidth = [8:0.1:13];

    % load folder names
    LoadFolderNames;
    
    % load chanlocs
    LoadChanLocs;
    
    % load scores
    [patients, scores] = LoadScores('outcome');
    [patients2, scores2] = LoadScores('crs-2');
    
    for i = 5:length(patients)
        patientnr = patients(i);
        hasSecondNight = (sum(patients2 == patientnr)>0) && scores2(patients2 == patientnr) ~= 0;
        
        % night 1
        matrices = AggregateMaxFreqMatrix(patientnr, 1, bandwidth);
        matrices = matrices(cellfun(@length, matrices)>1); % remove NaNs
        
        if(length(matrices) >= 10)
            concatMatrices = cat(3, matrices{:});    
            matrix = std(concatMatrices,0,3);
            h = imagesc(matrix); colorbar; caxis([0 0.3]);
            print(imgcf, '-djpeg', '-r80', ['/imaging/sc03/Iulia/Overnight/figures-wpli-matrices/' bandname '_P' num2str(patientnr) '_1-stddev.jpg']);
        end
        
        % night 2
        if(~hasSecondNight)
            continue;
        end
        
        matrices = AggregateMaxFreqMatrix(patientnr, 2, bandwidth);
        matrices = matrices(cellfun(@length, matrices)>1);
        
        if(length(matrices) >= 10)
            concatMatrices = cat(3, matrices{:});    
            matrix = std(concatMatrices,0,3);
            h = imagesc(matrix); colorbar; caxis([0 0.3]);
            print(imgcf, '-djpeg', '-r80', ['/imaging/sc03/Iulia/Overnight/figures-wpli-matrices/' bandname '_P' num2str(patientnr) '_2-stddev.jpg']);
        end
    end

    
    %title(['WPLI mean in ' bandname ' band']);
    %set(gcf,'PaperPosition',[0 0 500 250]);
    %print(h, '-djpeg', '-r10', ['/imaging/sc03/Iulia/Overnight/figures-wpli-topo/all-mean-' bandname '.jpg']);
    
end