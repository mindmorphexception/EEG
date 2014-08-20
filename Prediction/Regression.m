clc
clear

measure = 'theta-delta-ratio';
score = 'outcome';
night = 2;

% make scores
[patients, outcomes] = LoadScores(score);

% remove if night == 2 and looking at final outcome
if (night == 2 && strcmp(score,'outcome'))
    [paux, scoreaux] = LoadScores('crs-2');
    paux(scoreaux == 0) = [];
    [~, i] = intersect(patients,paux);
    patients = patients(i);
    outcomes = outcomes(i);
end

% make measures
features = MakeMeasures('alpha-var',night,patients);

% perform regression
lm = LinearModel.fit(features, outcomes, 'linear')

% plot it
figure;
scatter(features, outcomes);
title(['Linear regression - ' measure ' for ' score]);
xlabel(measure);
ylabel(score);
