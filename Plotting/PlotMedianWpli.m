function maxMedianWpliEpochNr = PlotMedianWpli(patientnr, nightnr, freq, description)
    % plot max wpli for a patient / night / freq band
    
    medwpli = GetMeanWpli(patientnr, nightnr, freq);

    [~,maxMedianWpliEpochNr] = max(medwpli);

    nrEpochs = length(medwpli);
    timelabel = MakeTimeLabelsWpliEpochs(nrEpochs);

    plot(timelabel,medwpli, 'LineWidth', 3);
    set(gca,'FontSize',20);
    axis auto
    ylim([0 1]);
    xlabel('Time (hours)');
    ylabel('Median wpli');
    title(['Patient ' num2str(patientnr) ' (night ' num2str(nightnr) ') - ' description]);

    %saveas(gcf,['/imaging/sc03/Iulia/Overnight/figures-wpli-median/' 'median wpli - p' num2str(patientnr) '_overnight' num2str(nightnr) ' - ' description], 'jpg');
    %close;
end

