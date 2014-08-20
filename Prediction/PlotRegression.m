function lm = PlotRegression(night, collapser, measureName, frequencyName)

    % night can be 1 / 2 / [1 2] (this will regress for the difference between the nights)
    % collapser can be 'stddevs' or 'kurtosis'


    % initialize
    patients = [ 1  2  3  4  5  6  7  8 10 11 12 13 14 15 16 17 99];
    outcome =  [ 0 20  5  0 17  7  6  4  7 11  6  5 14  9 16  6  0]';
    if(night == 2)
        patients = [  2  3    5  6  7 10 11 13 15 16 17 ];
        outcome = [  20  5   17  7  6  7 11  5  9 16 17  ]'; 
    elseif (isequal(night, [1 2]))
        patients = [1  2  3 4   5  6  7 10 11 13 15 16 17 99];
        outcome = [0  20  5 0  17  7  6  7 11  5  9 16 17 0 ]'; 
    end
    nrPatients = length(patients);
    
    % compute measures for each patient
    features = zeros(1, nrPatients);
    for i = 1:length(patients)
        p = patients(i);
        % if computing the diff
        if (isequal(night, [1 2]))
            [vals1, ~] = GetMeasuresCollapsed(p, [1], {frequencyName}, collapser, {measureName});
            if (outcome(i) ~= 0)
                [vals2, ~] = GetMeasuresCollapsed(p, [2], {frequencyName}, collapser, {measureName});
            end   
        elseif (isequal(night, 1) || ~isequal(outcome(i),0))
            [vals, ~] = GetMeasuresCollapsed(p, [night], {frequencyName}, collapser, {measureName});
        end
        
        
        if (length(night) == 1)
            features(i) = vals{1};
        elseif (outcome(i) ~= 0)
            features(i) = vals2{1} - vals1{1};
        else
            features(i) = -vals1{1};
        end
    end
    
    % plot linear regression
    lm = LinearModel.fit(features, outcome, 'linear')
    figure;
    scatter(features, outcome);    
    titlestr = ['Linear regression in ' frequencyName ' band'];
    if (length(night == 1))
        titlestr = [titlestr ' night ' num2str(night)];
    else
        titlestr = [titlestr ' night2 - night1'];
    end
    title(titlestr);
    xlabel([collapser ' ' measureName]);
    ylabel('outcome');
end