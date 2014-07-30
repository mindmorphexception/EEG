function [matrices, maxFrequencies] = AggregateMaxFreqMatrix(patientnr, nightnr, freq)
    % Get a matrix of the max values for a patient in a range of frequencies
    % freq = array of hz vals like [8 8.1 8.2 8.3 ... 9.8]

    % input folder
    LoadFolderNames;

    % load matrices
    allfreq_matrix = cell(1,length(freq));
    nrEpochs = 0;
    ft_progress('init', 'text', 'Loading wpli matrices...');
    for i = 1:length(freq)
        filename = ['matrix_p' int2str(patientnr) '_overnight' int2str(nightnr) '_' num2str(freq(i)) 'hz.mat'];
        myvar = load([folderMatrix filename]);
        allfreq_matrix{i} = myvar.matrix;
        if nrEpochs == 0
            nrEpochs = length(myvar.matrix);
        elseif nrEpochs ~= length(myvar.matrix)
            error('wrong nr of epochs!');
        end
        ft_progress(i/length(freq));
    end
    ft_progress('close');
    
    % array of max wpli for freq range
    matrices = cell(1,nrEpochs);
    
    % array of frequencies where the max wpli was
    maxFrequencies = cell(1,nrEpochs);
    
    ft_progress('init', 'text', 'Computing max wpli matrix...');
    for t = 1:nrEpochs
        % init matrix of maximum values with the matrix for the first freq
        % and freq matrix with the first frequency
        crtMatrix = allfreq_matrix{1}{t};
        maxFreq = freq(1) * ones(size(crtMatrix));

        % calculate maximum matrix for the different freqs
        for f = 2:length(freq)
            crtMatrix = max(crtMatrix, allfreq_matrix{f}{t});
            maxFreq(crtMatrix == allfreq_matrix{f}{t}) = freq(f);
        end

        matrices{t} = crtMatrix;
        maxFreq(logical(eye(length(crtMatrix)))) = 0; % sets diagonal to 0
        maxFrequencies{t} = maxFreq;
        ft_progress(t/nrEpochs);
    end
    ft_progress('close');
    
end

