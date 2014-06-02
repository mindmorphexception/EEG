%
% Loops through all overnight data files.
%
function processFiles()

    clc;
    
    javaaddpath(which('MFF-1.0.d0004.jar'));
    folder = '/Users/iulia/Documents/MATLAB/Data/';
    
    files = dir(folder);
    
    for i = 1:size(files);
        filename = files(i).name;
        if (strfind (filename, 'overnight'))
%            processFile([folder filename]);
            readSets;
%             header = read_mff_header([folder filename], 0);
%             fprintf('%s %d\n', filename, header.nSamples);
        end
    end 
end

%
% Processes one file.
%
function processFile(filename)
    fprintf('Reading %s\n',filename);
    
    pause on
    
    % initialization
    chunksize = 1000000;
    seconds = 10;
    srate = 250;
    samples = seconds * srate;
    if(mod(chunksize, samples) ~= 0)
        error('@Chunksize should be a multiple of @samples');
    end
    samplesPerChunk = chunksize / samples;
    channels = 1:128;
    
    % read header
    header = read_mff_header(filename, 0);
    
    % read current set
    rawset = pop_readegimff(filename, 'firstsample', i, 'lastsample', i+chunksize-1);
    
    % save set
    %pop_saveset(rawset, 'filename', [filename '.set']);
       
    fprintf('Done.\n');
    
end