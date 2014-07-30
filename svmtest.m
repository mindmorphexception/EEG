
frequencyNames = {'delta', 'theta','alpha','all'};
patients = [2 3 5 7 10 11 13 15 16];
outcome =  [1 0 1 0 0  1  0  0  1 ]';
nrMeasures = 12;
nrPatients = length(patients);

for freq = 1:4
    for night = 1:2
        features = zeros(nrPatients, nrMeasures);

        for i = 1:length(patients)
            p = patients(i);
            [vals, measureNames] = GetMeasuresStdDevs(p, [1 2], frequencyNames);

            for m = 1:nrMeasures
                features(i,m) = vals{m}(freq,night);
            end
        end

        correct = 0;
        total = nrPatients;
        for i = 1:nrPatients
            f1 = features;
            f1(i,:) = [];
            o1 = outcome;
            o1(i,:) = [];
            svmstruct = svmtrain(f1,o1,'kernel_function','quadratic');
            o = svmclassify(svmstruct, features(i,:));
            if(isequal(o, outcome(i)))
                correct = correct+1;
            end
        end

        fprintf('Accuracy in %s band, night %d: %f\n', frequencyNames{freq}, night, correct/total);
    end
end

