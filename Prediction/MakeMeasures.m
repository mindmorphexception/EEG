function [means, stddevs] = MakeMeasures(measureName, night, patients, otherparams)

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
        case 'custom'
            for p = 1:length(patients)
                stdWpli = GetStdSeqWpli(patients(p),night,1:0.1:4);
                stddevs(p) = nanstd(stdWpli(:));
                means(p) = nanmedian(stdWpli(:));
            end
            
            
        % modular span median =========================
        case 'modspan'
            for p = 1:length(patients)
                measures = GetModularSpan(patients(p),night,otherparams.bandName);
                stddevs(p) = nanstd(measures);
                means(p) = nanmedian(measures);
            end
            
        % modular span SD =========================
        case 'sd-modspan'
            for p = 1:length(patients)
                measures = GetModularSpan(patients(p),night,otherparams.bandName);
                stddevs(p) = 0;
                means(p) = nanstd(measures);
            end
        
        % small worldness median ======================
        case 'smallworldness'
            for p = 1:length(patients)
                measures = GetSmallWorldness(patients(p),night,otherparams.bandName);
                stddevs(p) = nanstd(measures);
                means(p) = nanmedian(measures);
            end
            
        % small worldness SD ======================
        case 'sd-smallworldness'
            for p = 1:length(patients)
                measures = GetSmallWorldness(patients(p),night,otherparams.bandName);
                means(p) = nanstd(measures);
                stddevs(p) = 0;
            end
            
        % graph measures =======================
        case 'graph'
            for p = 1:length(patients)
                measures = GetGraphMeasures(patients(p),night, otherparams.bandName, otherparams.measureName);
                stddevs(p) = nanstd(measures);
                means(p) = nanmedian(measures);
            end
            
        % graph measures =======================
        case 'sd-graph'
            for p = 1:length(patients)
                measures = GetGraphMeasures(patients(p),night, otherparams.bandName, otherparams.measureName);
                means(p) = nanstd(measures);
                stddevs(p) = 0;
            end
            
        % mean wpli ============================
        case 'mean-wpli-allfreq'
            for p = 1:length(patients)
                medianWpli = GetMeanWpli(patients(p),night,1:0.1:13);
                stddevs(p) = nanstd(medianWpli);
                means(p) = nanmedian(medianWpli);
            end
        case 'mean-wpli-delta'
            for p = 1:length(patients)
                medianWpli = GetMeanWpli(patients(p),night,1:0.1:4);
                stddevs(p) = nanstd(medianWpli);
                means(p) = nanmedian(medianWpli);
            end
        case 'mean-wpli-theta'
            for p = 1:length(patients)
                medianWpli = GetMeanWpli(patients(p),night,4:0.1:8);
                stddevs(p) = nanstd(medianWpli);
                means(p) = nanmedian(medianWpli);
            end
        case 'mean-wpli-alpha'
            for p = 1:length(patients)
                medianWpli = GetMeanWpli(patients(p),night,8:0.1:13);
                stddevs(p) = nanstd(medianWpli);
                means(p) = nanmedian(medianWpli);
            end
            
        % std dev of mean wpli ============================
        case 'stdmean-wpli-allfreq'
            for p = 1:length(patients)
                medianWpli = GetMeanWpli(patients(p),night,1:0.1:13);
                stddevs(p) = 0 * nanstd(medianWpli);
                means(p) = nanstd(medianWpli);
            end
        case 'stdmean-wpli-delta'
            for p = 1:length(patients)
                medianWpli = GetMeanWpli(patients(p),night,1:0.1:4);
                stddevs(p) = 0;
                means(p) = nanstd(medianWpli);
            end
        case 'stdmean-wpli-theta'
            for p = 1:length(patients)
                medianWpli = GetMeanWpli(patients(p),night,4:0.1:8);
                stddevs(p) = 0;
                means(p) = nanstd(medianWpli);
            end
        case 'stdmean-wpli-alpha'
            for p = 1:length(patients)
                medianWpli = GetMeanWpli(patients(p),night,8:0.1:13);
                stddevs(p) = 0;
                means(p) = nanstd(medianWpli);
            end
            
        % std-wpli ==============================
        case 'std-wpli-allfreq'
            for p = 1:length(patients)
                stdWpli = GetStdWpli(patients(p),night,1:0.1:13);
                stddevs(p) = std(triu2(stdWpli));
                means(p) = median(triu2(stdWpli));
            end
        case 'std-wpli-delta'
            for p = 1:length(patients)
                stdWpli = GetStdWpli(patients(p),night,1:0.1:4);
                stddevs(p) = std(triu2(stdWpli));
                means(p) = median(triu2(stdWpli));
            end
        case 'std-wpli-theta'
            for p = 1:length(patients)
                stdWpli = GetStdWpli(patients(p),night,4:0.1:8);
                stddevs(p) = std(triu2(stdWpli));
                means(p) = median(triu2(stdWpli));
            end
        case 'std-wpli-alpha'
            for p = 1:length(patients)
                stdWpli = GetStdWpli(patients(p),night,8:0.1:13);
                stddevs(p) = std(triu2(stdWpli));
                means(p) = median(triu2(stdWpli));
            end
            
        % std-wpli ==============================
        case 'stdseq-wpli-allfreq'
            for p = 1:length(patients)
                stdWpli = GetStdSeqWpli(patients(p),night,1:0.1:13);
                stddevs(p) = nanstd(stdWpli(:));
                means(p) = nanmedian(stdWpli(:));
            end
        case 'stdseq-wpli-delta'
            for p = 1:length(patients)
                stdWpli = GetStdSeqWpli(patients(p),night,1:0.1:4);
                stddevs(p) = nanstd(stdWpli(:));
                means(p) = nanmedian(stdWpli(:));
            end
        case 'stdseq-wpli-theta'
            for p = 1:length(patients)
                stdWpli = GetStdSeqWpli(patients(p),night,4:0.1:8);
                stddevs(p) = nanstd(stdWpli(:));
                means(p) = nanmedian(stdWpli(:));
            end
        case 'stdseq-wpli-alpha'
            for p = 1:length(patients)
                stdWpli = GetStdSeqWpli(patients(p),night,8:0.1:13);
                stddevs(p) = nanstd(stdWpli(:));
                means(p) = nanmedian(stdWpli(:));
            end
            
        % mutualinfo ==============================
        case 'mutualinfo-allfreq'
            for p = 1:length(patients)
                mi = ComputeMutualInfo(patients(p),night,'allfreq');
                stddevs(p) = nanstd(mi(:));
                means(p) = nanmedian(mi(:));
            end
        case 'mutualinfo-delta'
            for p = 1:length(patients)
                mi = ComputeMutualInfo(patients(p),night,'delta');
                stddevs(p) = nanstd(mi(:));
                means(p) = nanmedian(mi(:));
            end
        case 'mutualinfo-theta'
            for p = 1:length(patients)
                mi = ComputeMutualInfo(patients(p),night,'theta');
                stddevs(p) = nanstd(mi(:));
                means(p) = nanmedian(mi(:));
            end
        case 'mutualinfo-alpha'
            for p = 1:length(patients)
                mi = ComputeMutualInfo(patients(p),night,'alpha');
                stddevs(p) = nanstd(mi(:));
                means(p) = nanmedian(mi(:));
            end
            
        % band contrib ============================  
        case 'alpha-contrib'
            for p = 1:length(patients)
                percentAlpha = GetPowerContributionAlpha(patients(p),night);
                stddevs(p) = std(percentAlpha);
                means(p) = median(percentAlpha);
                nrsamples(p) = length(percentAlpha);
            end
            
        case 'theta-contrib'
            for p = 1:length(patients)
                percentTheta = GetPowerContributionTheta(patients(p),night);
                stddevs(p) = std(percentTheta);
                means(p) = median(percentTheta);
                nrsamples(p) = length(percentTheta);
            end
            
        case 'delta-contrib'
            for p = 1:length(patients)
                percentDelta = GetPowerContributionDelta(patients(p),night);
                stddevs(p) = std(percentDelta);
                means(p) = median(percentDelta);
                nrsamples(p) = length(percentDelta);
            end
            
        % band contrib ============================  
        case 'sd-alpha-contrib'
            for p = 1:length(patients)
                percentAlpha = GetPowerContributionAlpha(patients(p),night);
                stddevs(p) = 0;
                means(p) = std(percentAlpha);
                nrsamples(p) = length(percentAlpha);
            end
            
        case 'sd-theta-contrib'
            for p = 1:length(patients)
                percentTheta = GetPowerContributionTheta(patients(p),night);
                stddevs(p) = 0;
                means(p) = std(percentTheta);
                nrsamples(p) = length(percentTheta);
            end
            
        case 'sd-delta-contrib'
            for p = 1:length(patients)
                percentDelta = GetPowerContributionDelta(patients(p),night);
                stddevs(p) = 0;
                means(p) = std(percentDelta);
                nrsamples(p) = length(percentDelta);
            end
        
        % band contrib ration =============================
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

