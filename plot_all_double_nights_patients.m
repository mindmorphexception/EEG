function PlotForPatient()
    patients = [2 3 5 7 10 11 13 15 16];
    LoadFolderNames;
    %PlotMeasuresStd(patients(p),[1 2],{'delta', 'theta', 'alpha', 'all'});
    %set(gcf, 'PaperType', 'E', 'PaperPosition', [0 0 10 40]);   
        
    for i = 1:length(patients)
        
        p = patients(i);
    
        for nightnr = 1:2
            h = figure; 
            PlotMedianWpli(p,nightnr,[0.1:0.1:4],'delta');
            print(h, '-djpeg', '-r350', [folderFigures 'wpli-median-delta_p' num2str(p) ' _overnight' num2str(nightnr) '.jpg']);
            
            h = figure; 
            PlotMedianWpli(p,nightnr,[4:0.1:8],'theta');
            print(h, '-djpeg', '-r350', [folderFigures 'wpli-median-theta_p' num2str(p) ' _overnight' num2str(nightnr) '.jpg']);
            
            h = figure; 
            PlotMedianWpli(p,nightnr,[8:0.1:12],'alpha');
            print(h, '-djpeg', '-r350', [folderFigures 'wpli-median-alpha_p' num2str(p) ' _overnight' num2str(nightnr) '.jpg']);
            
            h = figure; 
            PlotMedianWpli(p,nightnr,[0.1:0.1:20],'all');
            print(h, '-djpeg', '-r350', [folderFigures 'wpli-median-all_p' num2str(p) ' _overnight' num2str(nightnr) '.jpg']);
        end
end