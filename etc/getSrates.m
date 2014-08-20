clc
clear

try
matlabpool close
catch
end
%matlabpool

LoadFolderNames;
files = dir(folderData);


srate = zeros(1,length(files));
nrSamples = zeros(1,length(files));
header = cell(1, length(files));

for i = 1:length(files)
    javaaddpath(which('MFF-1.0.d0004.jar'));
    fprintf('====== %s ======', files(i).name);
    if (length(files(i).name) > 10 && ~strcmp(files(i).name,'p10_overnight3 20120917 1930'))
        header{i} = read_mff_header([folderData files(i).name], 0);
        srate(i) = header{i}.Fs;
        nrSamples(i) = header{i}.nSamples;
    else
        srate(i) = NaN;
        nrSamples(i) = NaN;
    end
end

fprintf('Sampling rates:\n');
for i = 1:length(files)
    fprintf('{''%s''}, 1, %d, %d,\t 250, 0.1, 0.1;\n', files(i).name, nrSamples(i), srate(i));
end