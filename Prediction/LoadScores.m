function [patients, outcomes] = LoadScores(name)

%     Supported parameters: 
%     'crs-1'
%     'crs-2'
%     'four-1'
%     'four-2'
%     'gcs-1'
%     'gcs-2'
%     'outcome'

    patients = [1:8 10:17];
    switch (name)
        case 'crs-1'
            outcomes = [3	2	3	1	2	2	3	2	3	3	3	1	2	3	3	2];
        case 'crs-2'
            outcomes = [0	2	3	0	3	2	4	NaN	2	3	NaN	2	NaN	3	3	4];
        case 'four-1'
            outcomes = [7	5	7	1	4	3	5	4	6	5	6	2	6	6	7	6];
        case 'four-2'
            outcomes = [0	7	7	0	5	4	6	NaN	7	7	NaN	3	NaN	7	8	6];
        case 'gcs-1'
            outcomes = [7	5	6	4	5	5	6	5	6	5	6	4	5	6	6	5];
        case 'gcs-2'
            outcomes = [0	4	6	0	6	5	7	NaN	6	6	NaN	4	NaN	6	7	6];
        case 'outcome'
            outcomes = [0	20	5	0	17	7	6	4	7	11	6	5	14	9	16	6];
        otherwise
            error('unknown parameter for patients outcome');
    end
    
    patients(isnan(outcomes)) = [];
    outcomes(isnan(outcomes)) = [];

end