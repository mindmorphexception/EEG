function [modules Q]=modularity_und(connectionMatrix,gamma)
%MODULARITY_UND     Optimal community structure and modularity
%
%   Ci = modularity_und(W);
%   [Ci Q] = modularity_und(W,gamma);
%
%   The optimal community structure is a subdivision of the network into
%   nonoverlapping groups of nodes in a way that maximizes the number of
%   within-group edges, and minimizes the number of between-group edges.
%   The modularity is a statistic that quantifies the degree to which the
%   network may be subdivided into such clearly delineated groups.
%
%   Input:      W       undirected (weighted or binary) connection matrix.
%               gamma,  modularity resolution parameter (optional)
%                           gamma>1     detects smaller modules
%                           0<=gamma<1  detects larger modules
%                           gamma=1     (default) leads to the 'classic' modularity function
%
%   Outputs:    Ci,     optimal community structure
%               Q,      maximized modularity
%
%   Note: Ci and Q may vary from run to run, due to heuristics in the
%   algorithm. Consequently, it may be worth to compare multiple runs.
%   Also see Good et al. (2010) Phys. Rev. E 81:046106.
%
%   Reference: Newman (2006) -- Phys Rev E 74:036104, PNAS 23:8577-8582.
%              Reichardt and Bornholdt (2006) Phys Rev E 74:016110.
%
%   2008-2013
%   Mika Rubinov, UNSW
%   Jonathan Power, WUSTL
%   Alexandros Goulas, Maastricht University
%   Dani Bassett, UCSB

%   Modification History:
%   Jul 2008: Original (Mika Rubinov)
%   Oct 2008: Positive eigenvalues made insufficient for division (Jonathan Power)
%   Dec 2008: Fine-tuning made consistent with Newman's description (Jonathan Power)
%   Dec 2008: Fine-tuning vectorized (Mika Rubinov)
%   Sep 2010: Node identities permuted (Dani Bassett)
%   Dec 2013: Gamma resolution parameter included (Mika Rubinov)
%   Dec 2013: Detection of maximum real part of eigenvalues enforced (Mika Rubinov)
%               Thanks to Mason Porter and Jack Setford, University of Oxford

if ~exist('gamma','var')
    gamma = 1;
end

nrNodes = length(connectionMatrix);                            %number of vertices
n_perm = randperm(nrNodes);                   %DB: randomly permute order of nodes
connectionMatrix = connectionMatrix(n_perm,n_perm);    %DB: use permuted matrix for subsequent analysis
degrees = sum(connectionMatrix);                       %degree
nrEdges = sum(degrees);                                %number of edges (each undirected edge is counted twice)
modularityMatrix = connectionMatrix-gamma*(degrees.'*degrees)/nrEdges;                    %modularity matrix
modules = ones(nrNodes,1);                         %community indices
nrModules = 1;                                     %number of communities
unexaminedCommunities = [1 0];                     %array of unexamined communites

communityIndices = 1:nrNodes;
crtModularityMatrix = modularityMatrix;               %modularity matrix for U(1)
crtNrNodes = nrNodes;                             %number of vertices in U(1)

while unexaminedCommunities(1)                    %examine community U(1)
    [eigenvectors, eigenvals] = eig(crtModularityMatrix);
    [~, i1] = max(real(diag(eigenvals)));         %maximal positive (real part of) eigenvalue of Bg
    maxEigenvector = eigenvectors(:,i1);          %corresponding eigenvector

    S = ones(crtNrNodes,1);
    S(maxEigenvector<0) = -1;
    modularityContribution = S.'*crtModularityMatrix*S;                %contribution to modularity

    if modularityContribution > 1e-10                       	%contribution positive: U(1) is divisible
        maxModularityContribution = modularityContribution;                       %maximal contribution to modularity
        crtModularityMatrix(logical(eye(crtNrNodes)))=0;      	%Bg is modified, to enable fine-tuning
        indUnmoved = ones(crtNrNodes,1);      %array of unmoved indices
        Sit = S;
        while any(indUnmoved);                %iterative fine-tuning
            Qit = maxModularityContribution-4*Sit.*(crtModularityMatrix*Sit); 	%this line is equivalent to:
            maxModularityContribution = max(Qit.*indUnmoved);        %for i=1:Ng
            imax = (Qit==maxModularityContribution);           %	Sit(i)=-Sit(i);
            Sit(imax) = -Sit(imax);       %	Qit(i)=Sit.'*Bg*Sit;
            indUnmoved(imax) = nan;             %	Sit(i)=-Sit(i);
            if maxModularityContribution > modularityContribution;                  %end
                modularityContribution = maxModularityContribution;
                S = Sit;
            end
        end

        if abs(sum(S))==crtNrNodes              %unsuccessful splitting of U(1)
            unexaminedCommunities(1) = [];
        else
            nrModules = nrModules+1;
            modules(communityIndices(S==1)) = unexaminedCommunities(1);         %split old U(1) into new U(1) and into cn
            modules(communityIndices(S==-1)) = nrModules;
            unexaminedCommunities = [nrModules unexaminedCommunities];
        end
    else                                %contribution nonpositive: U(1) is indivisible
        unexaminedCommunities(1) = [];
    end

    communityIndices = find(modules==unexaminedCommunities(1));         %indices of unexamined community U(1)
    bg = modularityMatrix(communityIndices,communityIndices);
    crtModularityMatrix = bg-diag(sum(bg));                %modularity matrix for U(1)
    crtNrNodes = length(communityIndices);                 %number of vertices in U(1)
end

modularity = modules(:,ones(1,nrNodes));                      %compute modularity
Q = ~(modularity-modularity.').*modularityMatrix/nrEdges;
Q = sum(Q(:));
Ci_corrected = zeros(nrNodes,1);             % DB: initialize Ci_corrected
Ci_corrected(n_perm) = modules;              % DB: return order of nodes to the order used at the input stage.
modules = Ci_corrected;                      % DB: output corrected community assignments
