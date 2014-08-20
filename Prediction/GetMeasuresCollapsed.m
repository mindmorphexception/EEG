function [values, measureNames] = GetMeasuresCollapsed(patientnr, nightnrs, aux, collapser, measureNames)
    % collapser can be 'stddevs', 'kurtosis'

    if(isempty(measureNames))
        measureNames = {'meanclustering', 'maxclustering', 'stdclustering', ...
            'modularity', 'globalEfficiency', 'pathlen',...
            'meanbetweenness', 'maxbetweenness', 'stdbetweenness', ...
            'meanparticipation', 'maxparticipation', 'stdparticipation'};
    end
    
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
                    try
                        measurevals(j) = measures{j}.(measureNames{i});
                    catch
                        measurevals(j) = NaN;
                    end
                end 
                
                % compute collapser
                if (isequal(collapser,'kurtosis'))
                    values{i}(f,n) = kurtosis(measurevals);
                elseif (isequal(collapser, 'stddevs'))
                    values{i}(f,n) = nanstd(measurevals);
                else
                    error('Unknown collapser');
                end
            end
        end
    end
end