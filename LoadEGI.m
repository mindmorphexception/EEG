function eeglabSet = LoadEGI(patientnr, nightnr, hour1, hour2)
    % hour1 is the time in hours where to start reading
    % hour2 is the time in hours where to end reading
    
    LoadFolderNames;
    LoadParams;
    
    % get file index in the data array
    index = GetFileIndex(patientnr, nightnr);   
    
    % get filename
    filename = data{index,1};
    
    % get sampling rate
    samplingRate = data{index,4};
    
    % make first and last samples to read
    firstsample = samplingRate * 3600 * hour1 + 1;
    lastsample = samplingRate * 3600 * hour2;
    
    % check
    if hour2 > data{index,3}
        error('hour2 is more than the number of hours available');
    end
    
    fprintf('*** Reading samples %d to %d...\n', firstsample, lastsample);
    
    % read samples
    eeglabSet = pop_readegimff([folderData filename], 'firstsample', firstsample, 'lastsample', lastsample);

    % remove channels we don't want to see
    eeglabSet = pop_select(eeglabSet, 'nochannel', chanExcluded);
    
    % filter data between 1 and 35 Hz
    eeglabSet = pop_eegfilt(eeglabSet,0,40);
    eeglabSet = pop_eegfilt(eeglabSet,1,0);
    
    % rereference
    eeglabSet = rereference(eeglabSet,1);

end

