function measures = MakeMeasures(measureName, night, patients)

%   Supported measures:
%   alpha-var (variance of percent contribution from alpha band)
%   theta-var
%   delta-var
%   alpha-theta-ratio-median (median of ratio between percent contribution from alpha and percent contribution from theta)
%   alpha-delta-ratio-median
%   theta-delta-ratio-median
%   alpha-median (median of percent contribution from alpha band)
%   theta-median
%   delta-median
%   alpha-theta-ratio-var (variance of ratio between percent contribution from alpha and percent contribution from theta)
%   alpha-delta-ratio-var
%   theta-delta-ratio-var

    measures = zeros(1,length(patients));
    nrsamples = zeros(1,length(patients));

    switch(measureName)
        case 'alpha-var'
            for p = 1:length(patients)
                percentAlpha = GetPowerContributionAlpha(patients(p),night);
                measures(p) = std(percentAlpha);
                nrsamples(p) = length(percentAlpha);
            end
            
        case 'theta-var'
            for p = 1:length(patients)
                percentTheta = GetPowerContributionTheta(patients(p),night);
                measures(p) = std(percentTheta);
                nrsamples(p) = length(percentTheta);
            end
            
        case 'delta-var'
            for p = 1:length(patients)
                percentDelta = GetPowerContributionDelta(patients(p),night);
                measures(p) = std(percentDelta);
                nrsamples(p) = length(percentDelta);
            end
            
        case 'alpha-median'
            for p = 1:length(patients)
                percentAlpha = GetPowerContributionAlpha(patients(p),night);
                measures(p) = median(percentAlpha);
                nrsamples(p) = length(percentAlpha);
            end
            
        case 'theta-median'
            for p = 1:length(patients)
                percentTheta = GetPowerContributionTheta(patients(p),night);
                measures(p) = median(percentTheta);
                nrsamples(p) = length(percentTheta);
            end
            
        case 'delta-median'
            for p = 1:length(patients)
                percentDelta = GetPowerContributionDelta(patients(p),night);
                measures(p) = median(percentDelta);
                nrsamples(p) = length(percentDelta);
            end
            
          
        case 'alpha-theta-ratio-median'
            for p = 1:length(patients)
                percentTheta = GetPowerContributionTheta(patients(p),night);
                percentAlpha = GetPowerContributionAlpha(patients(p),night);
                ratio = percentAlpha ./ percentTheta;
                measures(p) = median(ratio);
                nrsamples(p) = length(ratio);
            end
            
        case 'alpha-delta-ratio-median'
            for p = 1:length(patients)
                percentDelta = GetPowerContributionDelta(patients(p),night);
                percentAlpha = GetPowerContributionAlpha(patients(p),night);
                ratio = percentAlpha ./ percentDelta;
                measures(p) = median(ratio);
                nrsamples(p) = length(ratio);
            end
            
        case 'theta-delta-ratio-median'
            for p = 1:length(patients)
                percentTheta = GetPowerContributionTheta(patients(p),night);
                percentDelta = GetPowerContributionDelta(patients(p),night);
                ratio = percentTheta ./ percentDelta;
                measures(p) = median(ratio);
                nrsamples(p) = length(ratio);
            end
            
        case 'alpha-theta-ratio-var'
            for p = 1:length(patients)
                percentTheta = GetPowerContributionTheta(patients(p),night);
                percentAlpha = GetPowerContributionAlpha(patients(p),night);
                ratio = percentAlpha ./ percentTheta;
                measures(p) = std(ratio);
                nrsamples(p) = length(ratio);
            end
            
        case 'alpha-delta-ratio-var'
            for p = 1:length(patients)
                percentDelta = GetPowerContributionDelta(patients(p),night);
                percentAlpha = GetPowerContributionAlpha(patients(p),night);
                ratio = percentAlpha ./ percentDelta;
                measures(p) = std(ratio);
                nrsamples(p) = length(ratio);
            end
            
        case 'theta-delta-ratio-var'
            for p = 1:length(patients)
                percentTheta = GetPowerContributionTheta(patients(p),night);
                percentDelta = GetPowerContributionDelta(patients(p),night);
                ratio = percentTheta ./ percentDelta;
                measures(p) = std(ratio);
                nrsamples(p) = length(ratio);
            end
            
        otherwise
            error('Unknown measure name.')
    end

end

