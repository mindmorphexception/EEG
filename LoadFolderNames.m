% 1 = windows
% 2 = wbic0
environment = 3;
    
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
    chanlocsPath = 'F:\matlab\Iulia\chanlocs';
    %matrixFolder
    folderMatrix = 'F:\Overnight\matrix\';
    % measures folder
    folderMeasures = 'F:\Overnight\measures\';
    % figures folder
    folderFigures = 'F:\Overnight\figures\';
    %std dev folder
    folderStdDev = 'F:\Overnight\stddev\';

elseif(environment == 2) % ============== WBIC ============== %
    % add java path
    javaaddpath(which('MFF-1.0.d0004.jar'));
    %javaaddpath(which('/Volumes/home/imc31/matlab/fieldtrip/external/egi_mff/java/MFF-1.2.jar'));
    % data folder
    folderData = '/data0/imc31/Overnight/Data/';
    % power spectra folder
    folderPowspec = '/scratch/imc31/Overnight/power-spectra/';
    % cross spectra folder
    folderCrossSpectra = '/data0/imc31/Overnight/cross-spectra/';
    % chanlocs filepath
    chanlocsPath = '/Volumes/home/imc31/matlab/Iulia/chanlocs';
    %matrixFolder
    folderMatrix = '/scratch/imc31/Overnight/matrix/';
    % measures folder
    folderMeasures = '/data0/imc31/Overnight/measures/';
    % figures folder
    folderFigures = '/data0/imc31/Overnight/figures/';
    %std dev folder
    folderStdDev = '/scratch/imc31/Overnight/stddev/';
    
elseif(environment == 3) % ============== MRC-CBU (Srivas) ============== %
    % add java path
    javaaddpath(which('MFF-1.0.d0004.jar'));
    %javaaddpath(which('/Volumes/home/imc31/matlab/fieldtrip/external/egi_mff/java/MFF-1.2.jar'));
    % data folder
    folderData = '/imaging/sc03/Overnight';
    % power spectra folder
    folderPowspec = '/imaging/sc03/Iulia/power-spectra/';
    % cross spectra folder
    folderCrossSpectra = '/data0/imc31/Overnight/cross-spectra/';
    % chanlocs filepath
    chanlocsPath = '/Volumes/home/imc31/matlab/Iulia/chanlocs';
    %matrixFolder
    folderMatrix = '/scratch/imc31/Overnight/matrix/';
    % measures folder
    folderMeasures = '/data0/imc31/Overnight/measures/';
    % figures folder
    folderFigures = '/data0/imc31/Overnight/figures/';
    %std dev folder
    folderStdDev = '/scratch/imc31/Overnight/stddev/';
end

% {filename firstsample lastsample} mark data where there are no events
    % besides 'sync' and 'break cnt'
    
    data = [
        
    {'p10_overnight1 20120910 1813'}, 1, 12585377, 250;
{'p10_overnight2 20120912 1812'}, 1, 5798676, 250;
{'p11_overnight1 20121009 1845'}, 1, 10943039, 250;
{'p11_overnight2 20121012 1813'}, 1, 12413599, 250;
{'p12_overnight1 20121022 1813'}, 1, 12565973, 250;
{'p13_overnight1 20121023 1829'}, 1, 1380914, 250;
{'p13_overnight2 20121025 1951'}, 1, 11434241, 250;
{'p14_overnight1 20121105 1835'}, 1, 12576836, 250;
{'p15_overnight1 20121119 1812'}, 1, 12577933, 250;
{'p15_overnight2 20121126 1901'}, 1, 1138596, 250;
{'p16_overnight1 20121121 1807'}, 1, 12025874, 250;
{'p16_overnight2 20121129 2019'}, 1, 10998327, 250;
{'p17_overnight1 20130221 1816'}, 1, 10855403, 250;
{'p17_overnight2 20130225 1841'}, 1, 1529856, 250;
{'p1_overnight1 20120502 1710'}, 1, 8549219, 250;
{'p2_overnight1 20120525 1549'}, 1, 25001068, 500;
{'p2_overnight2 20120529 1754'}, 1, 24705890, 500;
{'p2_overnight3 20120613 1752'}, 1, 23565161, 500;
{'p3_overnight1 20120627 2003'}, 1, 25092897, 500;
{'p3_overnight2 20120702 1142'}, 1, 5214937, 500;
{'p4_overnight1 20120703 2345'}, 1, 13989813, 500;
{'p4_overnight_1_short 20120703 1645'}, 1, 6915828, 500;
{'p5_overnight1 20120705 1814'}, 1, 23016851, 500;
{'p5_overnight2 20120711 1703'}, 1, 12584885, 250;
{'p6_overnight1 20120709 1926'}, 1, 24654984, 500;
{'p6_overnight2 20120716 1942'}, 1, 5252471, 250;
{'p7_overnight1 20120723 1823'}, 1, 12032156, 250;
{'p7_overnight2 20120730 1741'}, 1, 12594817, 250;
{'p8_overnight1 20120806 1859'}, 1, 12131768, 250;
{'p9_overnight1 20120904 1756'}, 1, 735555, 250;
%      {'p2_overnight1 20120525 1549'}, 2000000, 2000000 + 3600*500 + cooldown - 1, 500;   % 1 hour of data at 500 sampl rate
        ];