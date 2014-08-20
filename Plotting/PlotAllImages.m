function maxFrequencies = PlotAllImages(patientnr, nightnr, freq, description)
    % plots all jpg figures given a connectivity struct, chanlocs and frequency
    % in the patient's folder
    % freq = array of hz vals like [8 8.1 8.2 8.3 ... 9.8]
    
    [matrices, maxFrequencies] = AggregateMaxFreqMatrix(patientnr, nightnr, freq);
    LoadFolderNames;
    
    % output folder
    folder_figures = [folderFigures 'wplitopo_' 'p' int2str(patientnr) '_overnight' int2str(nightnr) '_' description '/'];
    if(~exist(folder_figures,'dir'))
        mkdir(folder_figures);
    end
    
    LoadParams;

    % load chanlocs
    load([chanlocsPath '91.mat']);
    
    % progress bar
    ft_progress('init', 'text', '');
    for t = 12:12%length(matrices)
        
        ft_progress(t/length(matrices), 'Drawing figure %d/%d', t, length(matrices));
        
        if(isnan(matrices{t}))
            figure;
            showaxes('off');
            box('off');
            axis('off');
        else
            % plot but not visible
            plotgraph(matrices{t},chanlocs91,'plotqt',0.9,'visible',0);
            set(get(gca, 'Title'), 'visible', 'on');
        end
        
        % display time limits in title
        t1 = (windowOverlap*(t-1))*epochSizeSeconds;
        t2 = t1 + epochSizeSeconds*processingWindow;
        title(['P' int2str(patientnr) ' overnight' int2str(nightnr) ' seconds ' int2str(t1) ' to ' int2str(t2) ' ' description 'band']);
        
        % save figure
        saveas(gcf,[folder_figures int2str(t) '.jpg']);
        close;
    end
    ft_progress('close');
    
end