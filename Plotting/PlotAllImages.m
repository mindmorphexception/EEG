function PlotAllImages(patientnr, nightnr, freq, description)
    % plots all jpg figures given a connectivity struct, chanlocs and frequency
    % in the patient's folder
    % freq = array of hz vals like [8 8.1 8.2 8.3 ... 9.8]
    
    

    % load chanlocs
    LoadChanLocs;
    LoadFolderNames;
    LoadParams;
    nrChans = 91;
    
    % load color scheme
    load('/imaging/sc03/Iulia/Overnight/mycolormap.mat');
    
    % load matrices
    [matrices, maxFrequencies] = AggregateMaxFreqMatrix(patientnr, nightnr, freq);
    
    % load community structs
    %load([folderMeasures 'communitystruct_p' int2str(patientnr) '_overnight' int2str(nightnr) '_' description '.mat']);
    
    % output folder
    folder_figures = ['/imaging/sc03/Iulia/Overnight/filmfig/thr01' 'p' int2str(patientnr) '_overnight' int2str(nightnr) '_' description '/'];
    if(~exist(folder_figures,'dir'))
        mkdir(folder_figures);
    end
    
    % image config
    myStyle = hgexport('factorystyle');
    myStyle.Format = 'png';
    myStyle.Resolution = 300;
    myStyle.FontSizeMin = 20;
    myStyle.Width = 10;
    myStyle.Height = 10;
    myStyle.Background = 'k';
    
    fprintf('Number of time frames is %d\n', length(matrices));

    prevModules = [];
    moduleSeed = 1;
    
    ft_progress('init', 'text', 'Drawing figures...');
    for t = 1:1000%length(matrices)
        ft_progress(t/length(matrices));
        
        % construct figure title
        t1 = (wpliWindowOverlap*(t-1))*epochSizeSeconds / 86400;
        t2 = t1 + epochSizeSeconds*wpliProcessingWindow / 86400;
        strtitle = ({['P' int2str(patientnr) ' night ' num2str(nightnr) ' ' description], ['Time: ' datestr(t1,'HH:MM:ss') ' - ' datestr(t2,'HH:MM:ss')]});
        
        % plot greys if bad window
        if( length(matrices{t}) < 2 )
            
            h = PlotGraphModules3D(zeros(91,91),ones(1,91),chanlocs91,mycolormap, strtitle);
         
        else
            
                
            % threshold matrix
            matrix = threshold_proportional(matrices{t},0.1);
            crtModules = modularity_louvain_und(matrix);
            crtNodeWeights = sum(matrix > 0,2) / nrChans;
            
            if ( ~isempty(prevModules) )
                [crtModules, moduleSeed] = ReassignModules(crtModules, prevModules, {'nrCommonNodes', 'similarityProportional'}, crtNodeWeights, prevNodeWeights, moduleSeed);    
            end
            
            h = PlotGraphModules3D(matrix,mod(crtModules,91)+1,chanlocs91,mycolormap, strtitle);
            
            prevModules = crtModules;
            prevNodeWeights = crtNodeWeights;

        end
        
        
        
        % save figure
        set(gcf, 'PaperPosition', [0 0 10 10]);
        set(gcf, 'InvertHardCopy', 'off');
        %print(h, '-djpeg', '-r350', [folder_figures int2str(t) '.jpg']);
        %saveas(gcf,[folder_figures int2str(t) '.jpg']);
        hgexport(gcf, [folder_figures int2str(t) '.png'], myStyle);
        close;
    end
    ft_progress('close');
    fprintf('Done.\n');
end