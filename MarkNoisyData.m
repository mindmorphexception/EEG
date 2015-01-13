function [stddevs, noisinessMatrix] = MarkNoisyData(patientnr, nightnr)
      
    LoadFolderNames;

    % load or generate std dev matrix
    stddevfilename = [folderStdDev 'stddev_p' num2str(patientnr) '_overnight' num2str(nightnr) '.mat'];
    
    stddevs = [];
    
    if (exist(stddevfilename, 'file'))
       fprintf('*** Loading std dev matrix.\n');
       load(stddevfilename);
    else
        error('no noisiness file');
    end

    % load thresholds and nrchans
    thresholdChanStdDev = GetThresholdChannelStdDev(patientnr, nightnr);
    
    % mark bad channels
    noisinessMatrix = zeros(size(stddevs));
    fprintf('*** Channel threshold is %f.\n', thresholdChanStdDev);
    badChanIndices = stddevs >= thresholdChanStdDev;
    noisinessMatrix(badChanIndices) = 1;
end