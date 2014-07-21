function [measures,maxFrequencies] = ComputeGraphMeasures(patientnr, nightnr, freq, thresh, aux)

    % Computes graph theoretical measures for all nights for a patient
    % freq = array of hz vals like [8 8.1 8.2 8.3 ... 9.8]
    % wpli will be taken as the max in this range of frequencies
    % aux is a string that will be appended at the end of the output filename
    
    LoadFolderNames;

    [matrices, maxFrequencies] = AggregateMaxFreqMatrix(patientnr, nightnr, freq);
    nrEpochs = length(matrices);

    measures = cell(1,nrEpochs);
    ft_progress('init','text','Epochs done:');
    % for every epoch
    for t = 1:nrEpochs
        
        if ~isempty(find(isnan(matrices{t})))
            measures{t} = NaN;
            continue;
        end
        
        thrMeasures = cell(1,length(thresh));
        
        % for every threshold
        for thr = 1:length(thresh)
            % apply threshold
            matrix = threshold_proportional(matrices{t},thresh(thr));
            
            % compute measures
            thrMeasures{thr} = ComputeGraphMeasuresCore(matrix);
        end           
        ft_progress(t/nrEpochs);
        measures{t} = AverageStructFields(thrMeasures);
    end
    ft_progress('close');
    
    info.freq = freq;
    info.thresh = thresh;
    save([folderMeasures 'measures_p' int2str(patientnr) '_overnight' int2str(nightnr) '_' aux '.mat'], 'measures');
    save([folderMeasures 'info_p' int2str(patientnr) '_overnight' int2str(nightnr) '_' aux '.mat'], 'info');
end