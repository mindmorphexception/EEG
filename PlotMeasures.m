function PlotMeasures(patientnr, nightnrs, aux, measureNames)

    % Plots the measures for the given patient and night and filename ending.
    % Example measures: {'meanclustering', 'maxclustering', 'modularity'}
    
    LoadFolderNames;
    
    % initialize
    timelabel = cell(1,length(nightnrs));
    y = cell(length(nightnrs), length(measureNames));
    
    for night = 1:length(nightnrs)
        % patient name
        patientName = ['p' int2str(patientnr) '_overnight' int2str(nightnrs(night)) '_' aux];

        % load measures & info
        load([measuresFolder 'measures_' patientName]);
        load([measuresFolder 'info_' patientName]);

        % initialize
        nrEpochs = length(measures);

        % generate time labels in hours
        timelabel{night} = MakeTimeLabelsWpliEpochs(nrEpochs);

        % save in y the measure for the night/measurenr
        for i = 1:length(measureNames)
            y{night,i} = zeros(1,nrEpochs);
            for j = 1:nrEpochs
                y{night,i}(j) = measures{j}.(measureNames{i});
            end
        end
        
    end
    
    % plot each measure value over time
    
    %suptitle(['Patient ' int2str(patientnr) ' - ' aux ' band']);
    h = figure;
    set(h, 'Position', [0 0 300 800]);
    
    for i = 1:length(measureNames)
        subplot(length(measureNames),1,i);        
        set(gca,'FontSize',10)
        hold all
        
        for night = 1:length(nightnrs)
            plot(timelabel{night},y{night,i}, 'LineWidth', 2);
        end
        
        if(i == 1)
            ylim([0 0.3]);
        end
        if(i == 3)
            ylim([40 90]);
        end
        if(i == 4)
            ylim([0 0.25]);
        end
        %ylabel(measureNames{i});
        hold off
    end
    
    %xlabel('Time (hours)');
    
    
    % make legend
    legendstr = cell(1,length(nightnrs));
    for night = 1:length(nightnrs)
        legendstr{night} = ['Night ' int2str(night)];
    end
    %legend(legendstr);
  
end

