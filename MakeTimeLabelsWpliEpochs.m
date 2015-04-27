function timelabel = MakeTimeLabelsWpliEpochs(nrEpochs)
% get a list of times (in hour fractions) for every epoch used in calculating the wpli 
% i.e. 10 minutes

    timelabel = zeros(1,nrEpochs);
    timelabel(1) = 10*60/3600;
    for t = 2:nrEpochs
        timelabel(t) = timelabel(t-1) + 10*10/3600;
    end

%     LoadParams;
%     timelabel = zeros(1,nrEpochs);
%     timelabel(1) = epochSizeSeconds*wpliProcessingWindow/3600;
%     for t = 2:nrEpochs
%         timelabel(t) = timelabel(t-1) + epochSizeSeconds*wpliWindowOverlap/3600;
%     end
end

