function stdwpli = GetStdWpli(patientnr, nightnr, freq)
    % Returns a matrix of (the std devs for (each channel pair throughout time)).
    % Note parantheses mark word precedence for clearer understanding.
    % Iuli-grammar (c) 2015 ;-)

    wplimatrices = AggregateMaxFreqMatrix(patientnr, nightnr, freq); 
    nrEpochs = length(wplimatrices);
    
    % just in case first matrices are [NaN]
    indexStart = 1;
    while (length(wplimatrices{indexStart}) < 2)
        indexStart = indexStart+1;
    end
    
    stdwpli = zeros(size(wplimatrices{indexStart}));
    
    % convert wpli matrices cells to 3d array
    wpli3d = zeros(length(1:nrEpochs),size(stdwpli,1),size(stdwpli,1));
    t = 1;
    for t1 = 1:nrEpochs
        if (length(wplimatrices{t1}) > 1)
            wpli3d(t,:,:) = wplimatrices{t1};
        else
            wpli3d(t,:,:) = wpli3d(t,:,:) * NaN;
        end
        t = t+1;
    end
    
    stdwpli = squeeze(nanstd(wpli3d,0,1));
    
end