function timelabel = MakeTimeLabelsCrossSpectraEpochs(nrEpochs)
% get a list of time (in hour fractions) for every epoch used in calculating cross spectra 
% i.e. 10 seconds
    LoadParams;
    timelabel = zeros(1,nrEpochs);
    timelabel(1) = epochSizeSeconds/3600;
    for t = 2:nrEpochs
        timelabel(t) = timelabel(t-1) + epochSizeSeconds/3600;
    end
end

