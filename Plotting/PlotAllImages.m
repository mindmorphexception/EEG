function maxFrequencies = PlotAllImages(patientnr, nightnr, freq, description)
    % plots all jpg figures given a connectivity struct, chanlocs and frequency
    % in the patient's folder
    % freq = array of hz vals like [8 8.1 8.2 8.3 ... 9.8]
    
    

    % load chanlocs
    LoadChanLocs;
    LoadFolderNames;
    
    [matrices, maxFrequencies] = AggregateMaxFreqMatrix(patientnr, nightnr, freq);
    
    % output folder
    folder_figures = [folderFigures 'wplitopo_' 'p' int2str(patientnr) '_overnight' int2str(nightnr) '_' description '/'];
    if(~exist(folder_figures,'dir'))
        mkdir(folder_figures);
    end
    
    fprintf('Number of time frames is %d\n', length(matrices));

    history1 = [];
    history2 = [];
    
    history_vsize1 = [];
    history_vsize2 = [];
    colormap = rand(length(matrices{1}),3);
    
    ft_progress('init', 'text', 'Drawing figures...');
    for t = 1:length(matrices)
        ft_progress(t/length(matrices));
        if(isnan(matrices{t}))
            h = figure;
            showaxes('off');
            box('off');
            axis('off');
        else
            
            % plot
            h = figure;
            
            subplot(1,3,1);
            [~] = plotgraph(matrices{t},chanlocs91, [], [], colormap, {}, 'legend', 'off', 'plotqt', 0.95,'visible',0);
            set(get(gca, 'Title'), 'visible', 'on'); title('Louvain - no history');

            subplot(1,3,2);
            [history1, history_vsize1] = plotgraph(matrices{t},chanlocs91, history1, history_vsize1, colormap, {'similarityProportional', 'proportionCommonNodes'}, 'legend', 'off', 'plotqt', 0.95,'visible',0);
            set(get(gca, 'Title'), 'visible', 'on'); title('Louvain - proportional similarity');

            subplot(1,3,3);
            [history2, history_vsize2] = plotgraph(matrices{t},chanlocs91, history2, history_vsize2, colormap, {'similarityWeighted', 'proportionCommonNodes'}, 'legend', 'off', 'plotqt', 0.95,'visible',0);
            set(get(gca, 'Title'), 'visible', 'on'); title('Louvain - weighted similarity');

            

        end
        
        % display time limits in title
        %t1 = (windowOverlap*(t-1))*epochSizeSeconds;
        %t2 = t1 + epochSizeSeconds*processingWindow;
        suptitle(['P' int2str(patientnr) ' ' description ' band']);

        % save figure
        print(h, '-djpeg', '-r350', [folder_figures int2str(t) '.jpg']);
        %saveas(gcf,[folder_figures int2str(t) '.jpg']);
        close;
    end
    ft_progress('close');
    fprintf('Done.\n');
end