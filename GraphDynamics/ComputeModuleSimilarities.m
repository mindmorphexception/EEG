function moduleSimilarity = ComputeModuleSimilarities(module, crtModules, compModules, crtNodeWeights, compNodeWeights)
% Returns an array of structs containing a module number and a similarity score.
% The module number is from compModules.
% The similarity score is a measure of overlapping nodes (nrOverlapping^2 /(nrNodesInModule1 * nrNodesInModule2)).
% The 'module' parameter is the module number from crtModules.
% crtModules and compModules are the same length.
% crtModules(i) = n means node i belongs to module n.
% nodeWeights is a vector of 0 to 1 weights for the nodes (can be emptyfor equal weights)

    
    if isempty(crtNodeWeights)
        crtNodeWeights = ones(1,length(crtModules));
    end
    if isempty(compNodeWeights)
        compNodeWeights = ones(1,length(crtModules));
    end

    % check
    if(length(crtModules) ~= length(compModules) || length(crtNodeWeights) ~= length(crtModules) || length(compNodeWeights) ~= length(crtModules) )
        error('crtModules, compModules and nodeWeigths must have the same nr of elems.');
    end

    % find the nodes belonging to the module parameter
    nodes = find(crtModules == module);
    
    % for each module in compModules, compute similarity
    compModuleList = unique(compModules);
    moduleSimilarity = repmat(struct('crtModuleNr', -1, ...
                                    'compModuleNr', -1, ...
                                    'totalNodes', -1, ...
                                    'nrCommonNodes', -1, ...
                                    'proportionCommonNodes', -1, ...
                                    'similarityProportional', -1, ...
                                    'similarityWeighted', -1 ...
                                    ), length(unique(compModules)), 1);
    for i = 1:length(compModuleList)
        
        % find nodes in current module
        compNodes = find(compModules == compModuleList(i));
        
        moduleSimilarity(i).crtModuleNr = module;
        moduleSimilarity(i).compModuleNr = compModuleList(i);
        commonNodes = intersect(nodes, compNodes);
        nrCommonNodes = length(commonNodes);
        
                
        % store total number of nodes in the two modules
        moduleSimilarity(i).totalNodes = length(nodes) + length(compNodes);
        
        % measure1: number of common nodes
        moduleSimilarity(i).nrCommonNodes = nrCommonNodes;
        
        % measure2: proportion of common nodes out of all nodes
        moduleSimilarity(i).proportionCommonNodes = 2 * nrCommonNodes / (length(nodes) + length(compNodes));
        
        % measure3: proportion product (% common nodes out of the total nodes in each set of modules)
        moduleSimilarity(i).similarityProportional = (nrCommonNodes / length(nodes)) * (nrCommonNodes / length(compNodes));
        
        % measure4: weighted product 
        moduleSimilarity(i).similarityWeighted = 2 * sum(crtNodeWeights(commonNodes).*(compNodeWeights(commonNodes))) / (sum(compNodeWeights(compNodes))+sum(crtNodeWeights(nodes)));

    end
    
    
end

