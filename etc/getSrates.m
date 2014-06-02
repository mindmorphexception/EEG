clc
clear

try
matlabpool close
catch
end
matlabpool

folder = '/data0/imc31/Overnight/Data/';
files = dir(folder);



srate = zeros(1,length(files));
nrSamples = zeros(1,length(files));
header = cell(1, length(files));

parfor i = 1:length(files)
    javaaddpath(which('MFF-1.0.d0004.jar'));
    fprintf('====== %s ======', files(i).name);
    if (length(files(i).name) > 10)
        header{i} = read_mff_header([folder files(i).name], 0);
        srate(i) = header{i}.Fs;
        nrSamples(i) = header{i}.nSamples;
    else
        srate(i) = NaN;
        nrSamples(i) = NaN;
    end
end

fprintf('Sampling rates:\n');
for i = 1:length(files)
    fprintf('{''%s''}, 1, %d, %d;\n', files(i).name, nrSamples(i), srate(i));
end