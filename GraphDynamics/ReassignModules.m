function [newModules, newModulesSeed] = ReassignModules(crtModules, compModules, sortFields, crtNodeWeights, compNodeWeights, newModulesSeed)
    % Reassigns the module numbers in crtModules attempting to overlap the modules from oldModules.
    % sortFields is a cell of arrays. If empty, it will be {'similarityProportional', 'proportionCommonNodes'}
    % Node weights can be empty for equal weights.
    % Modules in crt found in comp will be assigned the number in comp;
    % new modules will be assigned a number starting from newModulesSeed.
    % input modules must contain a consecutive numbering.
    %
    % Other input values: 'totalNodes','nrCommonNodes','proportionCommonNodes',
    % 'similarityProportional','similarityWeighted'
    
    
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
    map = zeros(1, length(modules));
    used = [];
    
    for i = 1:length(S)
        if (S(i).(sortFields{1}) <= 0)
            break;
        end
        
        prev = S(i).crtModuleNr;
        new = S(i).compModuleNr;
        
        if( isempty(find(used==new)) && map(prev) == 0)
            map(prev) = new;
            used = [used; new];
        end
    end
    
    for i = 1:nrNodes
        if ( map( crtModules(i) ) == 0 )
            while (~isempty(find(used == newModulesSeed)))
                newModulesSeed = newModulesSeed + 1;
            end
            map( crtModules(i) ) = newModulesSeed;
            used = [used; newModulesSeed];
        end
    end
    newModulesSeed = newModulesSeed+1;
    
    newModules = zeros(1, nrNodes);
    for i = 1:nrNodes
        newModules(i) = map( crtModules(i) );
    end

end


