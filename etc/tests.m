function tests
    clear;
    clc;

    fprintf('Starting...\n');

    filename = '/Users/iulia/Documents/MATLAB/Data/p2_overnight1 20120525 1549';
    chunksize = 200000;

    javaaddpath(which('MFF-1.0.d0004.jar'));
    javaaddpath(which('MatlabGarbageCollector.jar'));

    evt = read_mff_event(filename);
    header = read_mff_header(filename, 0);
    info = read_mff_info(filename);
    subj = read_mff_subj(filename);

    for i = 1 : chunksize : 1 %header.nSamples
       % clearvars -except i filename chunksize header;
       % jheapcl;

       % f = i;
       % l = min(i + chunksize - 1, header.nSamples);
        
        x = 5000000;
        firstsample = 1+x;
        lastsample = 100000+x;
            
        fprintf('testread %s %d %d\n', filename, firstsample, lastsample);
        
        pop_readegimff(filename, ...
                                'firstsample', firstsample, ...
                                'lastsample', lastsample);
                
    end
    
    fprintf('Done.\n');
end