function eeglabSet = LoadEGI(patientnr, nightnr, hour1, hour2, filter_and_rereference)
    % hour1 is the time in hours where to start reading
    % hour2 is the time in hours where to end reading
    % pass hour2 as 0 to read the whole file

    LoadFolderNames;
    LoadParams;
    
    % get file index in the data array
    index = GetPatientIndex(patientnr, nightnr);   
    
    % get filename
    filename = data{index,1};
    
    % get sampling rate
    samplingRate = data{index,4};
    
    % make first and last samples to read
    if (hour2 ~= 0)
        firstsample = samplingRate * 3600 * hour1 + 1;
        lastsample = samplingRate * 3600 * hour2;
    else
        firstsample = data{index,2};
        lastsample = data{index,3};
    end
    
    % check
    if hour2 > data{index,3}
        error('hour2 is more than the number of hours available');
    end
    
    fprintf('*** Reading samples %d to %d...\n', firstsample, lastsample);
    
    % read samples
    eeglabSet = pop_readegimff([folderData filename], 'firstsample', firstsample, 'lastsample', lastsample);

    % remove channels we don't want to see
    eeglabSet = pop_select(eeglabSet, 'nochannel', chanExcluded);
    
    if(filter_and_rereference)
        % filter data between 1 and 40 Hz
        eeglabSet = pop_eegfilt(eeglabSet,0,40);
        eeglabSet = pop_eegfilt(eeglabSet,1,0);
        
        % rereference
        eeglabSet = rereference(eeglabSet,1);
    end
    
    

end

