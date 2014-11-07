% x = [1 2 4; 2 3 10; 6 7 9; 4 5 7; 1 3 8];
% 
% [V,D] = eig(cov(x));
% V
% D
% 
% klt = x * V;


%% vvvvvv nu merge

function MyCrossSpectra(power) % input is time x chan x freq

    nrEpochs = size(power, 1);    
    nrChans = size(power, 2);
    nrFreqs = size(power, 3);
    
    % base change - Karhunen Loeve transform
    KLT = cell(1, nrFreqs);
    % rows are observations (time); cols are variables (chans)
    for f = 1:nrFreqs
        [V,D] = eig(cov( power(:,:,f) ));
        KLT{f} = power(:,:,f) * V;
    end
    
    
    % compute cross-spectra in old basis and new basis
    crossSpectra = zeros(nrChans, nrChans, nrEpochs, nrFreqs);
    crossSpectra_newbasis = zeros(nrChans, nrChans, nrEpochs, nrFreqs);

    for i = 1:nrChans
        for j = i:nrChans
            for f = 1:nrFreqs
                for t = 1:nrEpochs
            
                    crossSpectra(i,j,t,f) = MethodOfMoments(power(t,i,f), power(t,j,f));
                    crossSpectra_newbasis(i,j,t,f) = MethodOfMoments(KLT{f}(t,i), KLT{f}(t,j));
                   
                end
            end
        end
    end
    
    save('/home/sc03/Iulia/Iulia/etc/crsspc', 'crossSpectra');
    save('/home/sc03/Iulia/Iulia/etc/crsspc_newbasis', 'crossSpectra_newbasis');
    
end

function Cij = MethodOfMoments(Xi, Xj)

    Cij = 0;
    for k = 1:10000
        Cij = Cij + Xi^k * conj(Xj^k);
    end

end