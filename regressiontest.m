clear
clc

% initialize
measureNames = {'modularity'};
frequencyNames = {'delta', 'theta','alpha','all'};
patients = [2  3  5  7 10 11 13 15 16];
outcome =  [20 5  17 6 7  11 5  9  16]';
nrMeasures = length(measureNames);
nrPatients = length(patients);
features = zeros(1, nrPatients);
vals = cell(1, nrPatients);

% compute measures
for i = 1:length(patients)
    p = patients(i);
    [vals{i}, measureNames] = GetMeasuresStdDevs(p, [1 2], frequencyNames, []);
end
%features = horzcat(features,ones(size(features,1),1));


 % try regression for each feature / frequency / night
for m = 1:nrMeasures
    for freq = 1:length(frequencyNames)
        for night = 1:2
            for i = 1:nrPatients
                features(i) = vals{i}{m}(freq,night);
                lm = LinearModel.fit(features, outcome, 'linear');
                if sum(lm.Coefficients.pValue<=0.1) == 2
                    fprintf('OMG %s in %s band for night %d!!!\n\n',...
                        measureNames{m}, frequencyNames{freq}, night);
                    lm
                    plotregression(features, outcome);
                end
            end
        end
    end
end

