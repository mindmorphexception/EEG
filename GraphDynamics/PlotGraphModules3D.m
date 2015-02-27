function h = PlotGraphModules3D(matrix, modules, chanlocs, mycolormap, strtitle)

    h = figure('Color','black');
    hold all
    
    % init
    pointRange = [100 5000];
    lineRange = [0 2];
 
    
    % compute node size
    nodeSize = zeros(1,length(chanlocs));
    for c = 1:length(chanlocs)
        nodeSize(c) = length(nonzeros(matrix(c,:)));
    end
    nodeSize = nodeSize / (length(chanlocs)-1);
    minNodeSize = min(nodeSize);
    maxNodeSize = max(nodeSize);
    nodeSize = (nodeSize - minNodeSize) / (maxNodeSize - minNodeSize);

            
    % compute line size
    minEdge = min(matrix(logical(triu(matrix,1))));
    maxEdge = max(matrix(logical(triu(matrix,1))));
    if(maxEdge ~= minEdge)
        matrix = (matrix - minEdge) / (maxEdge - minEdge);
    end
    matrix(matrix < 0) = 0;
    lineSize = 1 + matrix * 2; 
    
    % plot nodes in grey if they are lonely
    lonelyNodes = find(nodeSize == pointRange(1));
    mycolormap(modules(lonelyNodes), :) = 0.5 * ones(length(lonelyNodes),3);
     
    [~,chanlocs3d] = headplot_old(nodeSize, 'splinefile.spl', 'electrodes', 'off', 'labels', 0, 'view', 'frontleft', 'maplimits', [-0.4 1]);
    
    % draw edges h
    for n1 = 1:length(modules)
        for n2 = 1:length(modules)
            if( n1 ~= n2 && matrix(n1,n2) > 0 )
                if (modules(n1) == modules(n2))
                    hLine = plotarc3d(chanlocs3d([n1,n2],:), lineSize(n1,n2), mycolormap(modules(n1),:), 1);
                    %hLine = line([chanlocs(n1).X chanlocs(n2).X],[chanlocs(n1).Y chanlocs(n2).Y],[chanlocs(n1).Z chanlocs(n2).Z],...
                    % 'Color',mycolormap(modules(n1),:),'LineWidth',lineSize(n1,n2),'LineStyle','-');
                end
            end
        end
    end
   
    figpos = get(gcf,'Position'); 
    set(gcf,'Position',[figpos(1) figpos(2) 800 1000]);  
    
    
    xlim([-150 200]); ylim([-300 150]); zlim([-150 200]);
    title(strtitle, 'Color', 'white');
    
    
    % text attributes
%     fontname = 'Gill Sans';
%     fontsize = 16;
%     fontweight = 'bold';
%     for c = 1:length(chanlocs)
%         text(chanlocs(c).X,chanlocs(c).Y,chanlocs(c).Z+0.5,chanlocs(c).labels,...
%         'FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
%     end
end