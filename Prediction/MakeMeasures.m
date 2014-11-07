function [means, stddevs] = MakeMeasures(measureName, night, patients)

%   Supported measures:
%   alpha-contrib (mean and variance of percent contribution from alpha band)
%   theta-contrib
%   delta-contrib
%   alpha-theta-ratio (mean of ratio between percent contribution from alpha and percent contribution from theta)
%   alpha-delta-ratio
%   theta-delta-ratio

    means = zeros(1,length(patients));
    stddevs = zeros(1,length(patients));
    nrsamples = zeros(1,length(patients));

    switch(measureName)
        case 'alpha-contrib'
            for p = 1:length(patients)
                percentAlpha = GetPowerContributionAlpha(patients(p),night);
                stddevs(p) = std(percentAlpha);
                means(p) = mean(percentAlpha);
                nrsamples(p) = length(percentAlpha);
            end
            
        case 'theta-contrib'
            for p = 1:length(patients)
                percentTheta = GetPowerContributionTheta(patients(p),night);
                stddevs(p) = std(percentTheta);
                means(p) = mean(percentTheta);
                nrsamples(p) = length(percentTheta);
            end
            
        case 'delta-contrib'
            for p = 1:length(patients)
                percentDelta = GetPowerContributionDelta(patients(p),night);
                stddevs(p) = std(percentDelta);
                means(p) = mean(percentDelta);
                nrsamples(p) = length(percentDelta);
            end
          
        case 'alpha-theta-ratio'
            for p = 1:length(patients)
                percentTheta = GetPowerContributionTheta(patients(p),night);
                percentAlpha = GetPowerContributionAlpha(patients(p),night);
                ratio = percentAlpha ./ percentTheta;
                stddevs(p) = std(ratio);
                means(p) = mean(ratio);
                nrsamples(p) = length(ratio);
            end
            
        case 'alpha-delta-ratio'
            for p = 1:length(patients)
                percentDelta = GetPowerContributionDelta(patients(p),night);
                percentAlpha = GetPowerContributionAlpha(patients(p),night);
                ratio = percentAlpha ./ percentDelta;
                stddevs(p) = std(ratio);
                means(p) = mean(ratio);
                nrsamples(p) = length(ratio);
            end
            
        case 'theta-delta-ratio'
            for p = 1:length(patients)
                percentTheta = GetPowerContributionTheta(patients(p),night);
                percentDelta = GetPowerContributionDelta(patients(p),night);
                ratio = percentTheta ./ percentDelta;
                stddevs(p) = std(ratio);
                means(p) = mean(ratio);
                nrsamples(p) = length(ratio);
            end
            
      
            
        otherwise
            error('Unknown measure name.')
    end

end

