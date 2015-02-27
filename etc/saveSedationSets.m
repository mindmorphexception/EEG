function saveSedationSets()


    data = [
    {'02-2010-anest 20100210 1354.mff'}, 1, 1958131, 250,	 250, 0.1, 0.1, 0.1;
    {'03-2010-anest 20100211 1421.mff'}, 1, 2021269, 250,	 250, 0.1, 0.1, 0.1;
    {'05-2010-anest 20100223 0950.mff'}, 1, 1961879, 250,	 250, 0.1, 0.1, 0.1;
    {'06-2010-anest 20100224 0939.mff'}, 1, 2008692, 250,	 250, 0.1, 0.1, 0.1;
    {'07-2010-anest 20100226 1333.mff'}, 1, 2079646, 250,	 250, 0.1, 0.1, 0.1;
    {'08-2010-anest 20100301 0957.mff'}, 1, 1978186, 250,	 250, 0.1, 0.1, 0.1;
    {'09-2010-anest 20100301 1351.mff'}, 1, 1940664, 250,	 250, 0.1, 0.1, 0.1;
    {'10-2010-anest 20100305 1307.mff'}, 1, 2074283, 250,	 250, 0.1, 0.1, 0.1;
    {'11-2010-anest 20100318 1226.mff'}, 1, 975740, 250,	 250, 0.1, 0.1, 0.1;
    {'13-2010-anest 20100322 1320.mff'}, 1, 1957646, 250,	 250, 0.1, 0.1, 0.1;
    {'14-2010-anest 20100324 1259.mff'}, 1, 1934803, 250,	 250, 0.1, 0.1, 0.1;
    {'15-2010-anest 20100329 0941.mff'}, 1, 1936800, 250,	 250, 0.1, 0.1, 0.1;
    {'16-2010-anest 20100329 1338.mff'}, 1, 1981660, 250,	 250, 0.1, 0.1, 0.1;
    {'17-2010-anest 20100331 0952.mff'}, 1, 1952065, 250,	 250, 0.1, 0.1, 0.1;
    {'18-2010-anest 20100331 1403.mff'}, 1, 1932860, 250,	 250, 0.1, 0.1, 0.1;
    {'19-2010-anest 20100406 1315.mff'}, 1, 260691, 250,	 250, 0.1, 0.1, 0.1;
    {'20-2010-anest 20100414 1318.mff'}, 1, 1977788, 250,	 250, 0.1, 0.1, 0.1;
    {'22-2010-anest 20100415 1323.mff'}, 1, 1915697, 250,	 250, 0.1, 0.1, 0.1;
    {'23-2010-anest 20100420 0942.mff'}, 1, 1997575, 250,	 250, 0.1, 0.1, 0.1;
    {'24-2010-anest 20100420 1340.mff'}, 1, 1917943, 250,	 250, 0.1, 0.1, 0.1;
    {'25-2010-anest 20100422 1336.mff'}, 1, 1917040, 250,	 250, 0.1, 0.1, 0.1;
    {'26-2010-anest 20100507 1328.mff'}, 1, 1932003, 250,	 250, 0.1, 0.1, 0.1;
    {'27-2010-anest 20100823 1043.mff'}, 1, 1978587, 250,	 250, 0.1, 0.1, 0.1;
    {'28-2010-anest 20100824 0928.mff'}, 1, 1974775, 250,	 250, 0.1, 0.1, 0.1;
    {'29-2010-anest 20100921 1420.mff'}, 1, 2009256, 250,	 250, 0.1, 0.1, 0.1;
    ];

    LoadParams;   

    for index = 1:25

        % get filename
        filename = data{index,1};

        % get sampling rate
        samplingRate = data{index,4};

        % make first and last samples to read
        firstsample = data{index,2};
        lastsample = data{index,3};

        % read samples
        eeglabSet = pop_readegimff(['/imaging/sc03/Iulia/Sedation/Data/' filename], 'firstsample', firstsample, 'lastsample', lastsample);

        % remove channels we don't want to see
        eeglabSet = pop_select(eeglabSet, 'nochannel', chanExcluded);
        
        % filter data between 1 and 45 Hz
        eeglabSet = pop_eegfiltnew(eeglabSet,0.5,45);

        % rereference
        eeglabSet = rereference(eeglabSet,1);

        pop_saveset(eeglabSet, 'filename', [filename '.set'], 'filepath', '/imaging/sc03/Iulia/Sedation/datasets/');
    end

end

