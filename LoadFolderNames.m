% 1 = windows - overnight
% 2 = wbic0 - overnight
% 3 = CBU - overnight
% 4 = CBU - sedation
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
    javaaddpath(which('MFF-1.2.jar'));
    %javaaddpath(which('/Volumes/home/imc31/matlab/fieldtrip/external/egi_mff/java/MFF-1.2.jar'));
    % data folder
    folderData = '/imaging/sc03/Overnight/';
    % processed datasets folder
    folderDataSets = '/imaging/sc03/Iulia/Overnight/sets/'; 
    % Fourier transforms folder
    folderFourier = '/imaging/sc03/Iulia/Overnight/fourier/';
    % power spectra folder
    folderPowspec = '/imaging/sc03/Iulia/Overnight/power-spectra/';
    % folder for power spectra with unclean epochs removed
    folderPowspecClean = '/imaging/sc03/Iulia/Overnight/power-spectra-clean/';
    % cross spectra folder
    folderCrossSpectra = '/imaging/sc03/Iulia/Overnight/cross-spectra/';
    % chanlocs filepath
    chanlocsPath = '/home/sc03/Iulia/Iulia/chanlocs';
    % matrix folder
    folderMatrix = '/imaging/sc03/Iulia/Overnight/matrix/';
    % measures folder
    folderMeasures = '/imaging/sc03/Iulia/Overnight/measures/';
    % figures folder
    folderFigures = '/imaging/sc03/Iulia/Overnight/figures/';
    %std dev folder
    folderStdDev = '/imaging/sc03/Iulia/Overnight/stddev/';
    % pow contributions folder
    folderPowContributions = '/imaging/sc03/Iulia/Overnight/power-contributions-selected-band-chans/';
    % figures for band power folder
    folderFiguresPower = '/imaging/sc03/Iulia/Overnight/figures-power/';
    % folder where global coherence is saved
    folderFiguresGlobalCoherence = '/imaging/sc03/Iulia/Overnight/figures-global-coherence/';
    % folder where global coherence figures are saved
    folderGlobalCoherence = '/imaging/sc03/Iulia/Overnight/global-coherence/';
    
    
elseif(environment == 4)  % ============== Sedation / MRC-CBU (Srivas) ============== %
    % add java path
    javaaddpath(which('MFF-1.2.jar'));
    % data folder
    folderData = '/imaging/sc03/Iulia/Sedation/Data/';
    % power spectra folder
    folderPowspec = '/imaging/sc03/Iulia/Sedation/power-spectra/';
    % folder for pow spectra from interpolated data
    folderPowspecClean = '/imaging/sc03/Iulia/Sedation/power-spectra-clean/';
    % power spectra folder
    folderFourier = '/imaging/sc03/Iulia/Sedation/fourier/';
    % cross spectra folder
    folderCrossSpectra = '/imaging/sc03/Iulia/Sedation/cross-spectra/';
    % chanlocs filepath
    chanlocsPath = '/home/sc03/Iulia/Iulia/chanlocs_sedation_';
    %matrixFolder
    folderMatrix = '/imaging/sc03/Iulia/Sedation/matrix/';
    % measures folder
    folderMeasures = '/imaging/sc03/Iulia/Sedation/measures/';
    % figures folder
    folderFigures = '/imaging/sc03/Iulia/Sedation/figures/';
    %std dev folder
    folderStdDev = '/imaging/sc03/Iulia/Sedation/stddev/';
    % pow contributions folder
    folderPowContributions = '/imaging/sc03/Iulia/Sedation/power-contributions-selected-band-chans/';
    % figures for band power folder
    folderFiguresPower = '/imaging/sc03/Iulia/Sedation/figures-power/';
    % folder where global coherence is saved
    folderFiguresGlobalCoherence = '/imaging/sc03/Iulia/Sedation/figures-global-coherence/';
    % folder where global coherence figures are saved
    folderGlobalCoherence = '/imaging/sc03/Iulia/Sedation/global-coherence/';
    
end

% {filename firstsample lastsample} mark data where there are no events
    % besides 'sync' and 'break cnt'
   
if (environment ~= 4)
    data = [    
{'p10_overnight1 20120910 1813'}, 1, 12585377, 250,     500, 0.1, 0.1, 0.1;
{'p10_overnight2 20120912 1812'}, 1, 5798676, 250,      500, 0.1, 0.1, 0.1;
{'p11_overnight1 20121009 1845'}, 1, 10943039, 250,     500, 0.1, 0.1, 0.1;
{'p11_overnight2 20121012 1813'}, 1, 12413599, 250,     500, 0.1, 0.1, 0.1;
{'p12_overnight1 20121022 1813'}, 1, 12565973, 250,     250, 0.05, 0.1, 0.1;
{'p13_overnight1 20121023 1829'}, 1, 1380914, 250,      250, 0.1, 0.1, 0.1;
{'p13_overnight2 20121025 1951'}, 1, 11434241, 250,     250, 0.1, 0.1, 0.1;
{'p14_overnight1 20121105 1835'}, 1, 12576836, 250,     500, 0.1, 0.1, 0.1;
{'p15_overnight1 20121119 1812'}, 1, 12577933, 250,     250, 0.1, 0.1, 0.1;
{'p15_overnight2 20121126 1901'}, 1, 1138596, 250,      250, 0.1, 0.1, 0.1;
{'p16_overnight1 20121121 1807'}, 1, 12025874, 250,     500, 0.075, 0.1, 0.1;
{'p16_overnight2 20121129 2019'}, 1, 10998327, 250,     500, 0.075, 0.1, 0.1;
{'p17_overnight1 20130221 1816'}, 1, 10855403, 250,     250, 0.1, 0.1, 0.1;
{'p17_overnight2 20130225 1841'}, 1, 1529856, 250,      500, 0.1, 0.1, 0.1;
{'p1_overnight1 20120502 1710'}, 1, 8549219, 250,       500, 0.1, 0.1, 0.1;
{'p2_overnight1 20120525 1549'}, 1, 25001068, 500,      250, 0.05, 0.1, 0.1;
{'p2_overnight2 20120529 1754'}, 1, 24705890, 500,      250, 0.05, 0.1, 0.1;
{'p2_overnight3 20120613 1752'}, 1, 23565161, 500,      500, 0.1, 0.1, 0.1;
{'p3_overnight1 20120627 2003'}, 1, 25092897, 500,      250, 0.05, 0.1, 0.1;
{'p3_overnight2 20120702 1142'}, 1, 5214937, 500,       250, 0.05, 0.1, 0.1;
{'p4_overnight1 20120703 2345'}, 1, 13989813, 500,      500, 0.05, 0.1, 0.1;
{'p5_overnight1 20120705 1814'}, 1, 23016851, 500,      500, 0.085, 0.1, 0.1;
{'p5_overnight2 20120711 1703'}, 1, 12584885, 250,      250, 0.1, 0.1, 0.1;
{'p6_overnight1 20120709 1926'}, 1, 24654984, 500,      500, 0.1, 0.1, 0.1;
{'p6_overnight2 20120716 1942'}, 1, 5252471, 250,       500, 0.1, 0.1, 0.1;
{'p7_overnight1 20120723 1823'}, 1, 12032156, 250,      250, 0.1, 0.1, 0.1;
{'p7_overnight2 20120730 1741'}, 1, 12594817, 250,      250, 0.1, 0.1, 0.1;
{'p8_overnight1 20120806 1859'}, 1, 12131768, 250,      500, 0.1, 0.1, 0.1;
{'p9_overnight1 20120904 1756'}, 1, 735555, 250,        NaN, NaN, NaN, NaN;
{'p99_overnight1 20120703 1645'}, 1, 6915828, 500,      NaN, NaN, NaN, NaN;
];

    
else
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
end