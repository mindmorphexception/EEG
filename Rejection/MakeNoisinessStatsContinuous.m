% 
% 
%     clc
%     LoadFolderNames;
%     LoadParams;
%     
%     stats = cell(1,28);
%     
%     maxEpochs = 0;
%     
%     for i = 1:28
%         [patientnr, nightnr] = GetPatientNightNr(i);
% 
%         % load noisiness matrix
%         [~, noisinessMatrix] = MarkNoisyData(patientnr, nightnr);
%         thresholdBadChansPerEpochs = data{i,6};
%         nrChans = size(noisinessMatrix,1);
%         stats{i}.nrEpochs = size(noisinessMatrix,2);
% 
%         stats{i}.patientnr = patientnr;
%         stats{i}.nightnr = nightnr;
%         stats{i}.maxBadChans = thresholdBadChansPerEpochs * nrChans;
%         stats{i}.noisyChans = zeros(1,stats{i}.nrEpochs);
% 
% 
%         % interpolate noisy channels in each epoch
%         for e = 1:stats{i}.nrEpochs
% 
%             stats{i}.noisyChans(e) = min(sum(noisinessMatrix(:,e)),floor(stats{i}.maxBadChans+1));
% 
%         end
%         
%         maxEpochs = max(maxEpochs, stats{i}.nrEpochs);
%     end
%     
%     
    
    %f = fopen('noisinessperepoch.txt','w');
    
    ts = [];
    for i = 1:28
        tsrt = ['p' num2str(stats{i}.patientnr) '_' num2str(stats{i}.nightnr) ' '];
        patientstrs{i} = tsrt;
        
        for e = 1:stats{i}.nrEpochs
            tsrt = [tsrt ' ' num2str(stats{i}.noisyChans(e)) ];
        end
        
        %fprintf(f, '%s\n', tsrt);
        
        ts = [ts; [stats{i}.noisyChans -1*ones(1,maxEpochs - length(stats{i}.noisyChans))]]; 
        
        
    end
    
    
    imagesc(ts);
    set(gca, 'XTick', 1:500:maxEpochs)
    set(gca, 'XTickLabel', 0:500:maxEpochs)
    xlabel('Time (epochs)')
    set(gca, 'YTickLabel', patientstrs)
    set(gca, 'YTick', 1:length(patientstrs))
    
    
