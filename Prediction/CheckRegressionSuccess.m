function CheckRegressionSuccess(night,collapser)

    % night can be 1 / 2 / [1 2] (this will regress for the difference between the nights)
    % collapser can be 'stddevs' or 'kurtosis'

    % initialize
    measureNames = {'meanclustering', 'maxclustering', 'stdclustering', ...
                'modularity', 'globalEfficiency', 'pathlen',...
                'meanbetweenness', 'maxbetweenness', 'stdbetweenness', ...
                'meanparticipation', 'maxparticipation', 'stdparticipation'};
    frequencyNames = {'delta', 'theta','alpha'};
    patients = [ 1  2  3  4  5  6  7  8 10 11 12 13 14 15 16 17 99];
    outcome =  [ 0 20  5  0 17  7  6  4  7 11  6  5 14  9 16  6  0]';
    if(night == 2)
        patients = [  2  3    5  6  7 10 11 13 15 16 17 ];
        outcome = [  20  5   17  7  6  7 11  5  9 16 17  ]';
    elseif (isequal(night, [1 2]))
        patients = [1  2  3 4   5  6  7 10 11 13 15 16 17 99];
        outcome = [0  20  5 0  17  7  6  7 11  5  9 16 17 0 ]';
    end
    nrMeasures = length(measureNames);
    nrPatients = length(patients);
    features = zeros(1, nrPatients);
    
    if(length(night) == 1)
        vals = cell(1, nrPatients);
    else
        vals1 = cell(1, nrPatients);
        vals2 = cell(1, nrPatients);
    end

    % compute measures
    for i = 1:length(patients)
        p = patients(i);
        % if computing the diff
        if (isequal(night, [1 2]))
            [vals1{i}, measureNames] = GetMeasuresCollapsed(p, [1], frequencyNames, collapser, measureNames);
            if (outcome(i) ~= 0)
                [vals2{i}, measureNames] = GetMeasuresCollapsed(p, [2], frequencyNames, collapser, measureNames);
            end   
        elseif (isequal(night, 1) || ~isequal(outcome(i),0))
            [vals{i}, measureNames] = GetMeasuresCollapsed(p, [night], frequencyNames, collapser, measureNames);
        end
        
    end
    %features = horzcat(features,ones(size(features,1),1));


    % try regression for each feature / frequency
    for m = 1:nrMeasures
        for freq = 1:length(frequencyNames)
            for i = 1:nrPatients
                if (length(night) == 1)
                    features(i) = vals{i}{m}(freq);
                elseif (outcome(i) ~= 0)
                    features(i) = vals2{i}{m}(freq) - vals1{i}{m}(freq);
                else
                    features(i) = -vals1{i}{m}(freq);
                end
            end
            lm = LinearModel.fit(features, outcome, 'linear');
            if sum(lm.Coefficients.pValue<=0.05) == 2
                fprintf('\n________________________________');
                fprintf('%s in %s band\n',measureNames{m}, frequencyNames{freq});
                lm
                figure;
                scatter(features, outcome);
                titlestr = ['Linear regression in ' frequencyNames{freq} ' band'];
                if (length(night == 1))
                    titlestr = [titlestr ' night ' num2str(night)];
                else
                    titlestr = [titlestr ' night2 - night1'];
                end
                title(titlestr);
                xlabel([collapser ' ' measureNames{m}]);
                ylabel('outcome');
            end
        end
    end
    
end

