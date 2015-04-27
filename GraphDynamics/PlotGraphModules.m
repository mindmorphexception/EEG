function h = PlotGraphModules(matrix, modules, chanlocs, mycolormap, strtitle)

    h = figure('Color','white','Name',mfilename);

    
    % init
    pointRange = [100 5000];
    lineRange = [0.5 2];
    
    % compute line size
    lineSize = lineRange(1) + matrix * (lineRange(2) - lineRange(1));
    
    % compute node size
    nodeSize = zeros(1,length(chanlocs));
    for c = 1:length(chanlocs)
        nodeSize(c) = length(nonzeros(matrix(c,:)));
    end
    nodeSize = nodeSize / (length(chanlocs)-1);
    nodeSize = pointRange(1) + nodeSize * (pointRange(2) - pointRange(1));
    
    % plot nodes in grey if they are lonely
    %lonelyNodes = find(nodeSize == pointRange(1));
    %mycolormap(modules(lonelyNodes), :) = 0.5 * ones(length(lonelyNodes),3);
     
    
    % draw nodes on scatter plot
    hScatterPlot = scatter3(cell2mat({chanlocs.X}), cell2mat({chanlocs.Y}), cell2mat({chanlocs.Z}),...
        nodeSize, mycolormap(modules,:),'filled',...
        'MarkerEdgeColor', [0 0 0]);
    axis off;
    view(-90,90);
    
    % draw edges h
    for n1 = 1:length(modules)
        for n2 = 1:length(modules)
            if( n1 ~= n2 && matrix(n1,n2) > 0 )
                if (modules(n1) == modules(n2))
                    hLine = line([chanlocs(n1).X chanlocs(n2).X],[chanlocs(n1).Y chanlocs(n2).Y],[chanlocs(n1).Z chanlocs(n2).Z],...
                     'Color',mycolormap(modules(n1),:),'LineWidth',lineSize(n1,n2),'LineStyle','-');
                end
            end
        end
    end

    % draw edges between different modules
%     for n1 = 1:length(modules)
%         for n2 = 1:length(modules)
%             if( n1 ~= n2 && matrix(n1,n2) > 0 )
%                 if (modules(n1) ~= modules(n2))
%                     hLine = line([chanlocs(n1).X chanlocs(n2).X],[chanlocs(n1).Y chanlocs(n2).Y],[chanlocs(n1).Z chanlocs(n2).Z],...
%                      'Color',[0 0 0],'LineWidth',lineSize(n1,n2),'LineStyle','-');
%                 end
%             end
%         end
%     end
   
    figpos = get(gcf,'Position'); 
    set(gcf,'Position',[figpos(1) figpos(2) 800 1000]);  
    
    title(strtitle);
    
    
    % text attributes
%     fontname = 'Gill Sans';
%     fontsize = 16;
%     fontweight = 'bold';
%     for c = 1:length(chanlocs)
%         text(chanlocs(c).X,chanlocs(c).Y,chanlocs(c).Z+0.5,chanlocs(c).labels,...
%         'FontName',fontname,'FontWeight',fontweight,'FontSize',fontsize);
%     end
end