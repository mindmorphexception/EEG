function [stddevs,t,noisinessMatrix] = PlotStdDevs(patientnr, nightnr)
    
    LoadParams;
    
    
    
        [stddevs, noisinessMatrix] = MarkNoisyData(patientnr, nightnr);

        t = MakeTimeLabelsCrossSpectraEpochs(size(stddevs,2));

        nrChans = size(stddevs,2);
        nrEpochs = size(t);

        % channels over time
%         hold all;
%        colorSet = [0 0 0];
%        colorSet(nightnr) = 1;
%        h = plot(t,stddevs', 'Color', colorSet);
%         
    %     % scatter plot of bad channels
    %     hold on;
    %     x = []; y = [];
    %     for i = 1:size(stddevs,1) 
    %         for j = 1:size(stddevs,2)
    %             if(noisinessMatrix(i,j)) 
    %                 x = [x stddevs(i,j)]; y = [y t(j)];
    %             end
    %         end
    %     end
        % scatter(y,x);

        % plot the threshold line
        %hold on
        %plot(xlim, [thresholdChanStdDev thresholdChanStdDev], 'Color', [0 0 0]);

        % plot how many channels are marked as bad per epoch
        % hold all;
         %sums = sum(noisinessMatrix,1);
         %bar(nightnr,:) = sums(1:160);
         
         bar(t,sum(noisinessMatrix,1));

        % 2d stddevs
    %     figure;
    %     imagesc(stddevs);
    %     caxis([0 5000]);
    %     
        % 2d noisiness
    %     figure;
    %     imagesc(noisinessMatrix);
    %     
        % cut off channels
    %     figure;
    %     stddevs2 = stddevs;
    %     stddevs2(noisinessMatrix==1) = 0;
    %     plot(t,stddevs2');
    %     ylim([0 10000]);
    
    
    
end