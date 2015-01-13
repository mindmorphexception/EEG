
function ComputeGlobalCoherence(index)
% computes global coherence (from Observed Brain Dynamics)
% saves global coherence, eigenvectors and eigenvals

    [patientnr, nightnr] = GetPatientNightNr(index);

    LoadChanLocs;
    LoadFolderNames;
    LoadParams;
    
    clearvars -except folderFourier folderGlobalCoherence patientnr nightnr chanlocs91 globalCoherenceWindow;
    
    % load noisiness params
    [~, noisiness] = MarkNoisyData(patientnr, nightnr);
    thresholdBadChansPerEpoch = GetThresholdBadChansPerEpoch(patientnr, nightnr) * size(noisiness,1);
    thresholdBadEpochsPerGloCoh = GetThresholdBadEpochsPerGlobalCoherence(patientnr, nightnr) * globalCoherenceWindow;

    % load fourier transforms (X) from freq struct
    load([folderFourier 'fourier_p' int2str(patientnr) '_overnight' int2str(nightnr) '.mat']);
    X = freqStruct.fourierspctrm;
    nrEpochs = size(X, 1);
    nrChans = size(X, 2);
    nrFreqs = size(X, 3);
    
    % compute SVD for windows
    windowSize = globalCoherenceWindow;
    nrWindows = length(1:windowSize:(nrEpochs - windowSize));
    %nrEigenvals = min(nrChans, windowSize - thresholdBadEpochsPerGloCoh);
    windowedEigenvectors = zeros(nrChans, nrChans, nrWindows, nrFreqs); 
    windowedEigenvals = cell(nrWindows, nrFreqs);

    % The Math:
    % [u,s,v] = svd(x)
    % x*v == u*s
    %
    % in x, columns are chans and rows are time frames
    % in v, columns are eigenvectors of CX (I think - see refs)
    %
    % s is diagonal and contains singular values (square them to actually get CX eigenvalues)
    % sum of squared abs eigenvectors should be 1 (it is indeed)
    % i.e. sum(abs(windowedEigenvectors(:,1,18,94)).^2) == 1 (as per Cimenser  2011)
    %
    % + cleaning code
    for f = 1:nrFreqs
        indexWindow = 0;
        for w = 1:windowSize:(nrEpochs - windowSize)
            indexWindow = indexWindow + 1;
            crtX = X(w : w+windowSize-1, :, f);
            
            % skip bad epochs from the calculation
            nrBadEpochs = 0;
            for e = w : (w+windowSize-1)
                if sum(noisiness(:,e)) > thresholdBadChansPerEpoch
                    crtX(e - nrBadEpochs - w + 1,:) = [];
                    nrBadEpochs = nrBadEpochs + 1;
                end
            end
            
            % skip calculating the current wpli if too many epochs are bad
            if nrBadEpochs > thresholdBadEpochsPerGloCoh
                windowedEigenvals{indexWindow,f} = NaN;
                windowedEigenvectors(:,:,indexWindow,f) = NaN * ones(nrChans,nrChans);
            else
                [~,s,v] = svd(crtX); 
                windowedEigenvals{indexWindow,f} = diag(s).^2;
                windowedEigenvectors(:,:,indexWindow,f) = abs(v).^2;
            end
        end
    end

    % compute global coherence on windows
    windowedGlobalCoherence = zeros(nrWindows, nrFreqs);
    for f = 1:nrFreqs
        for t = 1:nrWindows
            if isnan(windowedEigenvals{t,f})
                windowedGlobalCoherence(t,f) = NaN;
            else
                windowedGlobalCoherence(t,f) = max(windowedEigenvals{t,f}) / sum(windowedEigenvals{t,f});
            end
        end
    end
    
    % save
    GC = [];
    GC.globalCoherence = windowedGlobalCoherence;
    GC.patientnr = patientnr;
    GC.nightnr = nightnr;
    GC.eigenvals = windowedEigenvals;
    GC.firstEigenvector = windowedEigenvectors(:,1,:,:);
    GC.time = MakeTimeLabelsCrossSpectraEpochs(nrWindows)*windowSize;
    GC.freq = freqStruct.freq;
    GC.chanlocs = chanlocs91;
    GC.globalCoherence
    save([folderGlobalCoherence 'glo_coh_p' int2str(patientnr) '_night' int2str(nightnr) '.mat'], 'GC');

    % BONUS STUFF:

    % compute spectrum (S)
    %S = X .* conj(X);

    % compute cross-spectra (CX)
    %CX = zeros(nrChans, nrChans, nrEpochs, nrFreqs);
    %for i = 1:nrChans
    %    for j = 1:nrChans
    %        CX(i,j,:,:) = squeeze(X(:,i,:)) .* squeeze(conj(X(:,j,:)));
    %    end
    %end

    % compute the eigenvals and eigenvectors of CX
    %eigenvectors = zeros(nrChans, nrChans, nrEpochs, nrFreqs);
    % eigenvals = zeros(nrChans, nrEpochs, nrFreqs);
    % for f = 1:nrFreqs
    %     for t = 1:nrEpochs
    %         [~,eigenvalmatr] = eig(CX(:,:,t,f));
    %         eigenvals(:,t,f) = diag(eigenvalmatr);
    %     end
    % end
    % 
    % % compute global coherence
    % globalCoherence = zeros(nrEpochs, nrFreqs);
    % for f = 1:nrFreqs
    %     for t = 1:nrEpochs
    %         globalCoherence(t,f) = max(eigenvals(:,t,f)) / sum(eigenvals(:,t,f));
    %     end
    % end
    % 
    % % plot max eigenvals
    % figure;imagesc(freqStruct.freq, MakeTimeLabelsCrossSpectraEpochs(nrEpochs), squeeze(eigenvals(end,:,:))');
    % title('Maximum eigenvals');
    % xlabel('Time (h)');
    % ylabel('Frequency (Hz)');
    % 
    % % retrieve chans in the eigenvectors corresponding to the largest eigenval
    % LoadChanLocs;
    % labels = {chanlocs91.labels};
    % %figure; topoplot(abs(eigenvectors(:,end,end,94)),chanlocs91);
    % 



    
    % % do upgraded Karhunen-Loeve transform THAT WILL WORK YAY - l.e. not really
    % Y = zeros(nrEpochs, nrChans, nrFreqs);
    % windowSize = 16;
    % for f = 1:nrFreqs
    %     for w = 1:windowSize:64
    %         
    %         % reference Jain's book pg. 34
    %         
    %         % obtain autocorrelation matrix of the vector of chans at this time x freq
    %         % !!! IF THIS DOESN'T WORK RECHECK THAT THIS IS INDEED THE AUTOCORRELATION
    %         [~,r] = corrmtx(X(t,:,f),nrChans-1);
    %         
    %         % obtain eigenvectors of autocorrelation matrix (check r*v == v*d)
    %         [v,d] = eig(r);
    %         
    %         % obtain u such that u*r*v == d (it's the conjugate transpose)
    %         u = ctranspose(v);
    %         
    %         % this should work
    %         Y(t,:,f) = u * X(t,:,f)';
    %     end
    % end
    % 
    % % recompute cross-spectra (CY) in new basis
    % CY = zeros(nrChans, nrChans, nrEpochs, nrFreqs);
    % for i = 1:nrChans
    %     for j = 1:nrChans
    %         CY(i,j,:,:) = squeeze(Y(:,i,:)) .* squeeze(conj(Y(:,j,:)));
    %     end
    % end
    
end
