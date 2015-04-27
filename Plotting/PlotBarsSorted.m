function PlotBarsSorted(otherparams)

    LoadFolderNames;

    score = 'outcome';
    measure = 'sd-alpha-contrib';
    titlestr = ['SD Alpha contribution']; %- ' otherparams.bandName];
    filename = [measure]; %'-' otherparams.bandName];

    % night 1
    night = 1;

    [patients, scores] = LoadScores(score);
    [measures, stddevs] = MakeMeasures(measure, night, patients, otherparams);
    m.patients = patients;
    m.measures = measures;
    m.stddevs = stddevs;
    y(:,1) = measures'; 
    y(:,2) = zeros(length(measures),1);
    e = zeros(length(measures),2,2);
    e(:,1,2) = stddevs';
    
    % night 2
    night = 2;
    if (strcmp(score,'outcome'))
        [paux, scoreaux] = LoadScores('crs-2');
        paux(scoreaux == 0) = [];
        [~, i] = intersect(patients,paux);
        patients2 = patients(i);
    end
    [measures, stddevs] = MakeMeasures(measure, night, patients2, otherparams);
    m.patients2 = patients2;
    m.measures2 = measures;
    m.stddevs2 = stddevs;
    save(['/imaging/sc03/Iulia/Overnight/power-measures/' filename '.mat'],'m');
    y(i,2) = measures;
    e(i,2,2) = stddevs';
    
    % sort by outcome
    [scores, order] = sort(scores,2,'descend');
    y = y(order,:);
    e = e(order,:,:);
    patients = patients(order);

    h = figure;
%         ha = tight_subplot(2,1,0.05,[0.2 0.05],0.05);
%         axes(ha(2));
    [bh, eh] = barwitherr(e,y);
    set(gca,'XTick',1:length(scores));
    set(eh, 'LineWidth', 1);
    set(bh, 'BarWidth', 1);
    set(gca,'XTickLabel',cellfun(@num2str, num2cell(scores), 'UniformOutput', false));
    set(gca, 'TickLength', [0 0]);
    xlabel('Outcome','FontSize',25);
    xlim([0 length(scores)+1]);
        %ylim([0 0.5]);
    set(gca, 'FontSize', 25);
    
%         axes(ha(1));
%         [bh, eh] = barwitherr(e,y);
%         set(gca,'XTick',1:length(scores));
%         set(gca,'XTickLabel',[]);
%         set(eh, 'LineWidth', 1);
%         set(bh, 'BarWidth', 1);
%         set(gca, 'TickLength', [0 0]);
%         xlim([0 length(scores)+1]);
%         %ylim([0.5 5]);
%         set(gca, 'FontSize', 18);
    
    title(titlestr);
    legend('Night 1','Night 2');
    set(h, 'Position', [200 200 1200 800]);
    options.Format = 'jpeg';
    %hgexport(h,  ['/imaging/sc03/Iulia/Overnight/figures-power' num2str(patientnr) '.jpg'], options);
    print(h, '-djpeg', '-r350', ['/imaging/sc03/Iulia/Overnight/power-measures/' filename '.jpg']);

