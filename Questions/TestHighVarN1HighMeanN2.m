% load folder names
LoadFolderNames;
    
% load chanlocs
LoadChanLocs;
    
% load scores
[patients, scores] = LoadScores('outcome');
[patients2, scores2] = LoadScores('crs-2');

% init
freqs = { [1:0.1:4], [4:0.1:8], [8:0.1:12]};
greqnames = { 'delta', 'theta', 'alpha' };
maxmean = zeros(length(patients),3);
allmean = zeros(length(patients),3);

for i = 1:length(patients)
    
    patientnr = patients(i);
    hasSecondNight = (sum(patients2 == patientnr)>0) && scores2(patients2 == patientnr) ~= 0;
    
    if(~hasSecondNight)
        continue;
    end
    
    for f = 1:3
        % load wpli matrices
        matrices1 = AggregateMaxFreqMatrix(patientnr, 1, freqs{f});
        matrices2 = AggregateMaxFreqMatrix(patientnr, 2, freqs{f});
        
        % remove NaNs
        matrices1 = matrices1(cellfun(@length, matrices1)>1); 
        matrices2 = matrices2(cellfun(@length, matrices2)>1); 
        
        % skip if not enough epochs
        if(length(matrices1) < 10 || length(matrices2) < 10)
            continue;
        end
        
        % compute night 1 variance matrix
        concatMatrices1 = cat(3, matrices1{:});    
        matrix1_var = triu(std(concatMatrices1,0,3));
        
        % compute night 2 mean matrix
        concatMatrices2 = cat(3, matrices2{:});    
        matrix2_mean = triu(mean(concatMatrices2,3));
        
        % get indices of channel pairs with greatest variability in night 1
        [sortedValues,sortIndex] = sort(matrix1_var(:),'descend');  
        maxIndex = sortIndex(1:205);
        
        % get night 2 mean for these pairs
        maxmean(i,f) = mean(matrix2_mean(maxIndex));
        randperm2 = randperm(matrix2_mean(:));
        randmean(i,f) = mean(randperm2(maxIndex));
    end
    
end