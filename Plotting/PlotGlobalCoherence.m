function PlotGlobalCoherence(patientnr, nightnr, savefigure)

    LoadFolderNames;
    
    load([folderGlobalCoherence 'glo_coh_p' int2str(patientnr) '_night' int2str(nightnr) '.mat']);
    
    h = figure; 
    
    
%     plot(GC.freq, GC.globalCoherence,'LineWidth',3);
%     set(gca,'FontSize',20);
%     title(['Overnight global coherence p' num2str(patientnr) ' night' num2str(nightnr)]);
%     xlabel('Frequency');
%     ylim([0 1]);
    

   
    imagesc(GC.time, GC.freq, GC.globalCoherence');
    
    set(gca, 'YDir', 'normal');
    title('Global coherence');
    xlabel('Time (h)');
    ylabel('Frequency (Hz)');
    caxis([0 1]);
    colorbar;
    
    if(savefigure)
        print(h, '-djpeg', '-r350', ['/imaging/sc03/Iulia/Overnight/figures-global-coherence/' 'global_coh_p' num2str(patientnr) '_overnight' num2str(nightnr) '.jpg']);
    end
    
end