function maxMedianWpliEpochNr = PlotMedianWpli(patientnr, nightnr, freq, description)
    % plot max wpli for a patient / night / freq band
    
    LoadFolderNames;
    
    wplimatrices = AggregateMaxFreqMatrix(patientnr, nightnr, freq); 
    nrEpochs = length(wplimatrices);
    medwpli = zeros(1,nrEpochs);
    timelabel = MakeTimeLabelsWpliEpochs(nrEpochs);

    for t = 1:nrEpochs
        medwpli(t) = median(wplimatrices{t}(:));
    end
    
    [~,maxMedianWpliEpochNr] = max(medwpli);

    plot(timelabel,medwpli, 'LineWidth', 3);
    set(gca,'FontSize',20)
    axis auto
    ylim([0 1]);
    %xlabel('Time (hours)');
    %ylabel('Median wpli');
    %title(['Patient ' num2str(patientnr) ' (night ' num2str(nightnr) ') - ' description]);

    %saveas(gcf,[folderFigures 'median wpli - p' num2str(patientnr) '_overnight' num2str(nightnr) ' - ' description], 'fig');
end

