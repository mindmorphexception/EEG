function measures = ComputeGraphMeasuresCore(matrix)

    nrNodes = length(matrix);
    
    % mean degree

    % clustering coefficient
    measures.clustering = clustering_coef_wu(matrix);
    measures.meanclustering = mean(measures.clustering); % this
    measures.maxclustering = max(measures.clustering);
    measures.stdclustering = std(measures.clustering);

    % global/local efficiency
    measures.globalEfficiency = efficiency_wei(matrix);
    %measures.localEfficiency = efficiency_wei(matrices,1);
    
    % characteristic path length
    measures.pathlen = charpath(distance_wei(weight_conversion(matrix, 'lengths'))); % this

    % betweenness
    measures.betweenness = betweenness_wei(distance_wei(weight_conversion(matrix, 'lengths')))/((nrNodes-1) * (nrNodes-2));
    measures.meanbetweenness = mean(measures.betweenness);
    measures.maxbetweenness = max(measures.betweenness);
    measures.stdbetweenness = std(measures.betweenness);

    % community structure and modularity
    [measures.communityStructure , measures.modularity] = modularity_louvain_und(matrix);

    % participation coefficient
    measures.participation = participation_coef(matrix,measures.communityStructure);
    measures.meanparticipation = mean(measures.participation);
    measures.maxparticipation = max(measures.participation);
    measures.stdparticipation = std(measures.participation);
end

