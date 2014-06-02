function matrix = MakeConnectivityMatrix(connectivityStruct, frequency)

    % creates a symmetric matrix from a connectivity struct for the wpli
    % as needed by plotgraph.m
    
    % frequency must be a number or a function: max, min, mean
    frequencyIndex = 0;
    func = [];
    if(isnumeric(frequency))
        frequencyIndex = find(abs(connectivityStruct.freq - frequency) < 0.00001);
        if(isempty(frequencyIndex))
            error('Frequency not found in the connectivity struct.');
        end
    elseif (strcmp(frequency,'max') || strcmp(frequency,'min') || strcmp(frequency,'mean')) 
        func = str2func(frequency);
    else
        error('Frequency must be either a number or max / min / mean.');
    end

    chlabels = connectivityStruct.elec.label;
    
    matrix = zeros(length(chlabels));
    
    for cmb = 1:size(connectivityStruct.labelcmb,1)
        chan1 = find(strcmp(connectivityStruct.labelcmb{cmb,1},chlabels));
        chan2 = find(strcmp(connectivityStruct.labelcmb{cmb,2},chlabels));
        
        if(frequencyIndex~=0)
            matrix(chan1, chan2) = connectivityStruct.wpli_debiasedspctrm(cmb, frequencyIndex);
        else
            matrix(chan1, chan2) = func(connectivityStruct.wpli_debiasedspctrm(cmb, :));
        end
        
        matrix(chan2, chan1) = matrix(chan1, chan2);
    end

end

