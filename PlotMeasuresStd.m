function PlotMeasuresStd(patientnr, nightnrs, aux, measureNames)
% Plots the std dev of graph measures
    
    LoadFolderNames;
    
    % this stores the output for bar
    values = cell(1,length(measureNames));
    for i = 1:length(values)
        % init values for bar for this measure
        values{i} = (-1)*zeros(length(aux),length(nightnrs));
    end

    %for every night
    for n = 1:length(nightnrs)
        % for every freq band
        for f = 1:length(aux)
             % load measures & info
            patientName = ['p' int2str(patientnr) '_overnight' int2str(nightnrs(n)) '_' aux{f}];
            load([folderMeasures 'measures_' patientName]);
            load([folderMeasures 'info_' patientName]);

            nrEpochs = length(measures);

            % for every measure
            for i = 1:length(measureNames)

                % make the array of measure vals
                measurevals = zeros(1,nrEpochs);
                for j = 1:nrEpochs
                    measurevals(j) = measures{j}.(measureNames{i});
                end 
                
                % compute std dev
                values{i}(f,n) = std(measurevals);
            end
        end
    end
    
    % make bar plots for each measure
    figure;
    %suptitle(['Patient ' num2str(patientnr) ' - Standard deviations of connectivity measures']);
    for i = 1:length(measureNames)
        subplot(length(measureNames),1,i);
        bar(values{i});
        %ylabel(measureNames{i});
        set(gca,'xticklabel', {'','',''});
    end
    
    % label the bar groups
    set(gca,'xticklabel', {'','',''});
    
    
    % make legend
    legendstr = cell(1,length(nightnrs));
    for night = 1:length(nightnrs)
        legendstr{night} = ['Night ' int2str(night)];
    end    
    legend(legendstr, 'Location', 'SouthEast');
    set(gca,'FontSize',20)
end

