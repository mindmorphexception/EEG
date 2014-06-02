% 1 = windows
% 2 = wbic0
environment = 1;
    
if(environment == 1) % ============== Windows ============== %
    % add java path
    javaaddpath(which('F:\matlab\fieldtrip\external\egi_mff\java\MFF-1.2.jar'));
    % data folder
    folderData = 'F:\Overnight\Data\';
    % power spectra folder
    folderPowspec = 'F:\Overnight\power-spectra\';
    % cross spectra folder
    folderCrossSpectra = 'F:\Overnight\cross-spectra\';
    % chanlocs filepath
    chanlocsPath = 'F:\matlab\Iulia\chanlocs.mat';
    %matrixFolder
    folderMatrix = 'F:\Overnight\matrix\';
    % measures folder
    folderMeasures = 'F:\Overnight\measures\';
    % figures folder
    folderFigures = 'F:\Overnight\figures\';

elseif(environment == 2) % ============== WBIC ============== %
    % add java path
    javaaddpath(which('MFF-1.0.d0004.jar'));
    % data folder
    folderData = '/data0/imc31/Overnight/Data/';
    % power spectra folder
    folderPowspec = '/data0/imc31/Overnight/power-spectra/';
    % cross spectra folder
    folderCrossSpectra = '/data0/imc31/Overnight/cross-spectra/';
    % chanlocs filepath
    chanlocsPath = '/Volumes/home/imc31/matlab/Iulia/chanlocs.mat';
    %matrixFolder
    folderMatrix = '/data0/imc31/Overnight/matrix/';
    % measures folder
    folderMeasures = '/data0/imc31/Overnight/measures/';
    % figures folder
    folderFigures = '/data0/imc31/Overnight/figures/';
end