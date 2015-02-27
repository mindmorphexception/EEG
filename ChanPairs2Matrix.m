function matrix = ChanPairs2Matrix(values, chlabels, labelcmb)
% Converts a vector of values for pairs of channels into a matrix of chan x chan.

    nrChans = length(chlabels);
    matrix = zeros(nrChans, nrChans);
    
     for cmb = 1:length(labelcmb)
        chan1 = find(strcmp(labelcmb{cmb,1},chlabels));
        chan2 = find(strcmp(labelcmb{cmb,2},chlabels));
        
        matrix(chan2, chan1) = values(cmb);
     end

end

