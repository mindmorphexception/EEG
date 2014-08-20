function PlotForPatient(patientnr, nightnr)

    LoadFolderNames;  
    
    %[patientnr, nightnr] = GetPatientNightNr(index);
    
%     h = figure;
%     set(gca,'FontSize',28);
%     PlotMeasuresStd(patientnr,nights,{'delta','theta','alpha'});
%     set(gcf, 'PaperType', 'E', 'PaperPosition', [0 0 10 40]); 
%     print(h, '-djpeg', '-r350', [folderFigures 'measures-sd_p' num2str(patientnr) '.jpg']);
    
    h = figure;
    PlotMeasures(patientnr,nightnr,'alpha')
    print(h, '-djpeg', '-r350', [folderFigures 'measures-alpha_p' num2str(patientnr) '_overnight' num2str(nightnr) '.jpg']);

    h = figure;
    PlotMeasures(patientnr,nightnr,'theta')
    print(h, '-djpeg', '-r350', [folderFigures 'measures-theta_p' num2str(patientnr) ' _overnight' num2str(nightnr) '.jpg']);

    h = figure;
    PlotMeasures(patientnr,nightnr,'delta')
    print(h, '-djpeg', '-r350', [folderFigures 'measures-delta_p' num2str(patientnr) ' _overnight' num2str(nightnr) '.jpg']);

end