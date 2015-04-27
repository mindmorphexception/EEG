function [h, minEdge, maxEdge] = PlotGraphModules3D(matrix, modules, chanlocs, mycolormap, ...
        strtitle)

    h = figure('Color','black');
    hold all
    
    % init
    pointRange = [100 5000];
    
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
     
    [~,chanlocs3d] = headplot_old(ones(size(nodeSize)), 'splinefile.spl', 'electrodes', 'off',...
        'labels', 0, 'view', 'frontright', 'maplimits', [-1 1], 'colormap', [0.8 0.6 0.8; 0.7 0.5 0.7]);
    
    % draw intra-module edges
    for n1 = 1:length(modules)
        for n2 = 1:length(modules)
            if( n1 ~= n2 && matrix(n1,n2) > 0 )
                if (modules(n1) == modules(n2))
                    hLine = plotarc3d(chanlocs3d([n1,n2],:), lineSize(n1,n2), mycolormap(modules(n1),:), 1);
                end
            end
        end
    end
%    
%     % draw inter-module edges
%    for n1 = 1:length(modules)
%        for n2 = 1:length(modules)
%            if( n1 ~= n2 && matrix(n1,n2) > 0 )
%                if (modules(n1) ~= modules(n2))
%                    [hLine, r] = plotarc3d(chanlocs3d([n1,n2],:), lineSize(n1,n2), [0 0 0], 0.1);
%                     if lineSize(n1,n2) == max(nonzeros(lineSize)) 
%                         %set(hLine,'DisplayName',sprintf('%.02f',lineSize(n1,n2)));
%                     elseif lineSize(n1,n2) == min(nonzeros(lineSize))
%                         %set(hLine,'DisplayName',sprintf('%.02f',lineSize(n1,n2)));
%                     else
%                         %hAnnotation = get(hLine,'Annotation');
%                         %hLegendEntry = get(hAnnotation,'LegendInformation');
%                         %set(hLegendEntry,'IconDisplayStyle','off')
%                     end
%                end
%            end
%        end
%    end

    figpos = get(gcf,'Position'); 
    set(gcf,'Position',[figpos(1) figpos(2) 800 1000]);  
    
    
    xlim([-150 200]); ylim([-300 150]); zlim([-150 200]);
    strtitle2 = [' [range: ' num2str(minEdge) ' - ' num2str(maxEdge) ']'];
    title([strtitle strtitle2], 'Color', 'white');
    
    
    % text attributes
%     fontname = 'Gill Sans';
%     fontsize = 16;
%     fontweight = 'bold';
%     for c = 1:length(chanlocs)
%         text(chanlocs(c).X,chanlocs(c).Y,chanlocs(c).Z+0.5,chanlocs(c).labels,...
%         'FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
%     end
end