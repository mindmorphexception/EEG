function newModules = ReassignModules(crtModules, compModules, sortFields, crtNodeWeights, compNodeWeights)
    % Reassigns the module numbers in crtModules attempting to overlap the modules from oldModules.
    % sortFields is a cell of arrays. If empty, it will be {'similarityProportional', 'proportionCommonNodes'}
    
    
    if isempty(sortFields)
        sortFields = {'similarityProportional', 'proportionCommonNodes'};
    end
    
    % check
    if(length(crtModules) ~= length(compModules))
        error('crtModules and compModules must have the same nr of elems.');
    end
    
    modules = unique(crtModules);
    nrNodes = length(crtModules);
    
    % for each current module, compute similarity to every other module in compModules
    S = [];
    for i = 1:length(modules)
        
        S = [S ; ComputeModuleSimilarities(modules(i), crtModules, compModules, crtNodeWeights, compNodeWeights)];
        
    end
    
    % sort similarities 
    S = nestedSortStruct(S, sortFields, [-1,-1]);

    % reassign modules:
    map = zeros(1, nrNodes);
    used = zeros(1, nrNodes);
    
    for i = 1:length(S)
        if (S(i).(sortFields{1}) <= 0)
            break;
        end
        
        prev = S(i).crtModuleNr;
        new = S(i).compModuleNr;
        
        if(used(new) == 0 && map(prev) == 0)
            map(prev) = new;
            used(new) = 1;
        end
    end
    
    for i = 1:nrNodes
        if ( map(i) == 0 )
            j = 1;
            while ( used(j) == 1 )
                j= j + 1;
            end
            map(i) = j;
            used(j) = 1;
        end
    end
    
    newModules = zeros(1, nrNodes);
    for i = 1:nrNodes
        newModules(i) = map( crtModules(i) );
    end

end


