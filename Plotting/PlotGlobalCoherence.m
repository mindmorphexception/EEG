function PlotGlobalCoherence(patientnr, nightnr, savefigure)

    LoadFolderNames;
    
    load([folderGlobalCoherence 'glo_coh_p' int2str(patientnr) '_night' int2str(nightnr) '.mat']);
    
    h = figure; 
   
    imagesc(GC.time, GC.freq, GC.globalCoherence');
    
    set(gca, 'YDir', 'normal');
    title('Global coherence');
    xlabel('Time (h)');
    ylabel('Frequency (Hz)');
    caxis([0 1]);
    colorbar;
    
    if(savefigure)
        print(h, '-djpeg', '-r350', [folderFiguresGlobalCoherence 'global_coh_p' num2str(patientnr) '_overnight' num2str(nightnr) '.jpg']);
    end
    
end