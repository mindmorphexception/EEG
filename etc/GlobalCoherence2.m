
LoadFolderNames;
clearvars -except folderCrossSpectra;

index = 6;
[patientnr, nightnr] = GetPatientNightNr(index);

% load fourier transforms (X) from freq struct
load([folderCrossSpectra 'cross_spectra_p' int2str(patientnr) '_overnight' int2str(nightnr) '.mat']);
nrEpochs = size(freqStruct.crsspctrm, 1);
nrChans = size(freqStruct.powspctrm, 2);
nrFreqs = size(freqStruct.crsspctrm, 3);

% make cross-spectra matrices (CX)
CX = zeros(nrChans, nrChans, nrEpochs, nrFreqs);
for k = 1:size(freqStruct.crsspctrm,1)
    istr = freqStruct.labelcmb{k,1};
    jstr = freqStruct.labelcmb{k,2};
    
    i = find(ismember(freqStruct.label, istr));
    j = find(ismember(freqStruct.label, jstr));
    
    CX(i,j,:,:) = squeeze(freqStruct.crsspctrm(:,k,:));
    CX(j,i,:,:) = CX(i,j,:,:);
end


% compute the eigenvals and eigenvectors of CX
eigenvectors = zeros(nrChans, nrChans, nrEpochs, nrFreqs);
eigenvals = zeros(nrChans, nrEpochs, nrFreqs);
for f = 1:nrFreqs
    for t = 1:nrEpochs
        [eigenvectors(:,:,t,f),eigenvalmatr] = eig(CX(:,:,t,f));
        eigenvals(:,t,f) = diag(eigenvalmatr);
    end
end

% compute global coherence
globalCoherence = zeros(nrEpochs, nrFreqs);
for f = 1:nrFreqs
    for t = 1:nrEpochs
        globalCoherence(t,f) = max(eigenvals(:,t,f)) / sum(eigenvals(:,t,f));
    end
end

% plot global coherence
imagesc(MakeTimeLabelsCrossSpectraEpochs(nrEpochs), freqStruct.freq, globalCoherence);
xlabel('Time (h)');
ylabel('Frequency (Hz)');


% retrieve chans in the eigenvectors corresponding to the largest eigenval
LoadChanLocs;
labels = {chanlocs91.labels};
f = find(freqStruct.freq == 10);
t = 50;
[maxval, index] = max(eigenvals(:,t,f));
maxeigenvec = eigenvectors(index,:,t,f);
testlabels = [labels(maxeigenvec ~= 0)]
testpowvals = X(t,:,f); % power vals at all chans at epoch t=50 and frequency 10h
bar(testpowvals);
set(gca,'XTick',[0:1:length(labels)])
set(gca,'XTickLabel',labels)

% for f = 1:nrFreqs
%     for t = 1:nrEpochs
%         [maxval, index] = max(eigenvals(:,t,f));
%         maxeigenvec = eigenvectors(index,:,t,f);
%         labels(maxeigenvec ~= 0)
%         pause
%     end
% end






% the part below doesn't work as expected

% % do Karhunen-Loeve transform
% Y = zeros(nrEpochs, nrChans, nrFreqs);
% for f = 1:nrFreqs
%     [V,D] = eig(cov(X(:,:,f)));
%     Y(:,:,f) = X(:,:,f) * V;
% end
% 
% % recompute cross-spectra (CY) in new basis
% CY = zeros(nrChans, nrChans, nrEpochs, nrFreqs);
% for i = 1:nrChans
%     for j = 1:nrChans
%         CY(i,j,:,:) = squeeze(Y(:,i,:)) .* squeeze(conj(Y(:,j,:)));
%     end
% end