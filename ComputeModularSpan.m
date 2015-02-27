function ComputeModularSpan(patientnr, nightnr, freqname)

    thresholds = 0.1 : 0.025 : 0.5;
    
    freq = 0;
    if strcmp(freqname, 'delta')
        freq = 1:0.1:4;
    elseif strcmp(freqname, 'theta')
        freq = 4:0.1:8;
    elseif strcmp(freqname, 'alpha')
        freq = 8:0.1:13;
    end

    % load matrix
    matrices = AggregateMaxFreqMatrix(patientnr, nightnr, freq);
    nrEpochs = length(matrices);
    
    % channels
    LoadChanLocs;
    chandist = ichandist(chanlocs91);
    chandist = chandist / max(chandist(:));
    nrChans = length(chanlocs91);
    
    % for each epochs
    modspan = zeros(1,nrEpochs);
    ft_progress('init', 'text', 'Computing modspan!');
    for e = 1:nrEpochs
        
        matrix = matrices{e};
        
        % discard if noisy epoch
        if(length(matrices{e}) == 1)
            modspan(e) = NaN;
        else
            index = 0;
            thrModspan = zeros(1,length(thresholds));
            for thr = 1:length(thresholds)
                
                index = index + 1;
            
                % compute modules
                matrix = threshold_proportional(matrix, thresholds(thr));
                modules = modularity_louvain_und(matrix);
                nrModules = length(unique(modules));
        
                % compute modspan for each module
                crtModspan = zeros(1, nrModules);
                for m = 1:nrModules
                    if sum(modules == m) > 1
                        distmat = chandist(modules == m, modules == m) .* matrix(modules == m, modules == m);
                        distmat = nonzeros(triu(distmat,1));
                        crtModspan(m) = sum(distmat) / sum(modules == m);
                    end
                end
                
                thrModspan(index) = max(nonzeros(crtModspan));
            end
            
            modspan(e) = median(thrModspan);
        end
        ft_progress(e/nrEpochs);
    end
    ft_progress('close');
    
    LoadFolderNames;
    save([folderMeasures 'modspan_p' num2str(patientnr) '_overnight' num2str(nightnr) '_' freqname '.mat'], 'modspan');
end
    
    
    
    