function DoStuffWithSedationDataset(e)
    ShowConsecutiveTRSPs(e)
end

function ShowEventList(e)
    clc
    for i = 1:length(e.event)
        fprintf('%s ', e.event(i).type);
        if (mod(i, 50) == 0)
            fprintf('\n');
        end
    end
end

function ShowConsecutiveTRSPs(e)
    clc
    rtimes = [];
    nrtimes = 0;
    for i = 1:length(e.event)-1
        e1 = e.event(i);
        e2 = e.event(i+1);

        if (strcmp(e1.type, 'TRSP') == 1 && strcmp(e2.type, 'TRSP') == 1) 
               % && strcmp(e.event(i-1).type, 'word') 
               %&& strcmp(e.event(i-1).type, 'resp') ...
               %&& strcmp(e.event(i-2).type, 'resp')
            %&& 
            
            
             if(e1.codes{4,2} == 1 && e2.codes{4,2} == 0)
                 fprintf('%d %d %d %d \t%d %d<>%d %s\n', e1.codes{4,2}, e2.codes{4,2}, e1.codes{5,2}, e2.codes{5,2}, e1.codes{3,2}, e2.codes{3,2}, e2.codes{8,2}, e2.codes{7,2});
             elseif(e1.codes{4,2} == 0 && e2.codes{4,2} == 1)
                 fprintf('%d %d %d %d \t%d %d<>%d %s\n', e2.codes{4,2}, e1.codes{4,2}, e2.codes{5,2}, e1.codes{5,2}, e2.codes{3,2}, e1.codes{3,2}, e2.codes{8,2}, e2.codes{7,2});
             end
            
            nrtimes = nrtimes+1;
            if(e2.codes{5,2} == 0)
                rtimes(nrtimes) = e1.codes{5,2};
            else
                rtimes(nrtimes) = e2.codes{5,2};
            end
            
            %fprintf('=============================');
             
        end
    end
    
   
end

function ShowGoNoGo(e)
    clc
    i = 1;
    while (i <= length(e.event))
       if (isTone(e.event(i)))
           found = 0;
           isgo = 0;
           type = str2num(e.event(i).type(4));
           while (~found)
               i = i+1;
               isgo = isGo(e.event(i));
               found = (isgo || isNoGo(e.event(i)));
           end
           found = 0;
           while (~found)
               i = i+1;
               found = isTRSP(e.event(i));
           end
           str = '';
           if(isgo)
               str = 'go';
           else
               str = 'nogo';
           end
           fprintf('%d <> %d (%s)\n',type,e.event(i).codes{3,2}, str);
           
       end
       i = i+1;
    end
    
end

function x = isTone(event)
    x = isequal(strfind(event.type, 'Ton'), 1);
end

function x = isGo(event)
    x = isequal(strfind(event.type, 'go'), 1);
end

function x = isNoGo(event)
    x = isequal(strfind(event.type, 'ngo'), 1);
end

function x = isTRSP(event)
    x = isequal(strcmp(event.type, 'TRSP'), 1);
end
