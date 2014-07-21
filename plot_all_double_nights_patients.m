patients = [2 3 5 7 10 11 13 15 16];
LoadFolderNames;

for p = 1:length(patients)
    %PlotMeasuresStd(patients(p),[1 2],{'delta', 'theta', 'alpha', 'all'});
   
    for nightnr = 1:2
        h = figure;

        PlotPowerSpectra(patients(p),nightnr,'');

        %set(gcf, 'PaperType', 'E', 'PaperPosition', [0 0 10 40]);
        set(gcf, 'Visible', 'off');
        print(h, '-djpeg', '-r350', [folderFigures 'powerspectra_p' num2str(patients(p)) ' _overnight' num2str(nightnr) '.jpg']);
        set(gcf, 'Visible', 'on'); 
    end
end