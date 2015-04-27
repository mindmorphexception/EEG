function [modules, modularities] = modularity_louvain_und_explicit(connectionMatrix,gamma)
%MODULARITY_LOUVAIN_UND     Optimal community structure and modularity
%
%   Ci = modularity_louvain_und(W);
%   [Ci Q] = modularity_louvain_und(W);
%   [Ci_h Q_h] = modularity_louvain_und(W,gamma);
%
%   The optimal community structure is a subdivision of the network into
%   nonoverlapping groups of nodes in a way that maximizes the number of
%   within-group edges, and minimizes the number of between-group edges.
%   The modularity is a statistic that quantifies the degree to which the
%   network may be subdivided into such clearly delineated groups.
%
%   The Louvain algorithm is a fast and accurate community detection
%   algorithm (as of writing). The algorithm may also be used to detect
%   hierarchical community structure.
%
%   Input:      W (connectionMatrix)     undirected (weighted or binary) connection matrix.
%               gamma,  modularity resolution parameter (optional)
%                           gamma>1     detects smaller modules
%                           0<=gamma<1  detects larger modules
%                           gamma=1     (default) leads to the 'classic' modularity function
%
%   Outputs:    Ci (modules),     community structure
%               Q (modularities),      modularity
%
%   Note: Ci and Q may vary from run to run, due to heuristics in the
%   algorithm. Consequently, it may be worth to compare multiple runs.
%
%   Reference: Blondel et al. (2008)  J. Stat. Mech. P10008.
%              Reichardt and Bornholdt (2006) Phys Rev E 74:016110.
%
%   Mika Rubinov, UNSW, 2010

%   Modification History:
%   Feb 2010: Original
%   Jun 2010: Fix infinite loops: replace >/< 0 with >/< 1e-10
%   May 2013: Include gamma resolution parameter

if ~exist('gamma','var')
    gamma = 1;
end

connectionMatrix = double(connectionMatrix);                 %convert from logical
nrNodes = length(connectionMatrix);                          %number of nodes
sumOfEdges = sum(connectionMatrix(:));                       %weight of edges

hierarchyIndex = 2;                                          %hierarchy index
nrNodesInHierarchychy = nrNodes;                             %number of nodes in hierarchy
modules = {[],1:nrNodesInHierarchychy};                      %hierarchical module assignments
modularities = {-1,0};                                       %hierarchical modularity values

while modularities{hierarchyIndex}-modularities{hierarchyIndex-1}>1e-10
    nodeDegrees = sum(connectionMatrix);                     %node degree
    moduleDegrees = nodeDegrees;                             %module degree
    nodeToModuleDegree = connectionMatrix;                   %node-to-module degree
    
    moduleAssignment = 1:nrNodesInHierarchychy;              %initial module assignments
    
    flag=true;                                               %flag for within-hierarchy search
    while flag; 
        flag=false;
        
        for u=randperm(nrNodesInHierarchy)      %loop over all nodes in random order
            ma = moduleAssignment(u);           %current module of u
            dQ = (nodeToModuleDegree(u,:)-nodeToModuleDegree(u,ma)+connectionMatrix(u,u)) - gamma*nodeDegrees(u).*(moduleDegrees-moduleDegrees(ma)+nodeDegrees(u))/sumOfEdges;
            dQ(ma)=0;                           %(line above) algorithm condition
            
            [max_dQ, mb] = max(dQ);             %maximal increase in modularity and corresponding module
            if max_dQ>1e-10;                    %if maximal increase is positive
                flag = true;
                moduleAssignment(u) = mb;       %reassign module
                
                nodeToModuleDegree(:,mb) = nodeToModuleDegree(:,mb)+connectionMatrix(:,u);     %change node-to-module degrees
                nodeToModuleDegree(:,ma) = nodeToModuleDegree(:,ma)-connectionMatrix(:,u);
                moduleDegrees(mb) = moduleDegrees(mb)+nodeDegrees(u);             %change module degrees
                moduleDegrees(ma) = moduleDegrees(ma)-nodeDegrees(u);
            end
        end
    end
    
    hierarchyIndex = hierarchyIndex+1;
    modules{hierarchyIndex} = zeros(1,nrNodes);
    [~,~,moduleAssignment] = unique(moduleAssignment);             %new module assignments
    for u = 1:nrNodesInHierarchy                                   %loop through initial module assignments
        modules{hierarchyIndex}(modules{hierarchyIndex-1}==u) = moduleAssignment(u);  %assign new modules
    end
    
    nrNodesInHierarchy = max(moduleAssignment);                       %new number of modules
    newConnectionMatrix = zeros(nrNodesInHierarchychy);               %new weighted matrix
    for u = 1:nrNodesInHierarchy
        for v = u:nrNodesInHierarchy
            wm = sum(sum(connectionMatrix(moduleAssignment==u,moduleAssignment==v)));   %pool weights of nodes in same module
            newConnectionMatrix(u,v) = wm;
            newConnectionMatrix(v,u) = wm;
        end
    end
    connectionMatrix = newConnectionMatrix;
    
    modularities{hierarchyIndex}=trace(connectionMatrix)/sumOfEdges-gamma*sum(sum((connectionMatrix/sumOfEdges)^2));  %compute modularity
end

modules=modules{end};
modularities=modularities{end};
