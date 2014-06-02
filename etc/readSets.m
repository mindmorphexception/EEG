clc
clear
folder = '/scratch/imc31/Overnight/Data/';
files = dir(folder);

javaaddpath(which('MFF-1.0.d0004.jar'));

fid = fopen('events.txt', 'w+');
if(fid == -1 || fid == 1 || fid == 2)
    error('error at opening file');
end


for i = length(files):-1:1

    if (length(files(i).name) > 10)
        
        eventsStruct = read_mff_event([folder files(i).name]);
        eventsCell = struct2cell(eventsStruct);
        
        header{i} = read_mff_header([folder files(i).name], 0);
        srate(i) = header{i}.Fs;
        nrSamples(i) = header{i}.nSamples;
        
        fprintf(fid, '\n====== %s ======\n', files(i).name);
        for event = 1:length(eventsStruct)
            
            if (strcmp(eventsStruct(event).type, 'sync') == 1 || ...
                strcmp(eventsStruct(event).type, 'break cnt') == 1 || ...
                strcmp(eventsStruct(event).type, 'BGIN') == 1 || ...
                strcmp(eventsStruct(event).type, 'BEND') == 1 )
                fprintf(fid, '\n%s [%d]', eventsStruct(event).type, eventsStruct(event).sample);
            else
                fprintf(fid, ' %s', eventsStruct(event).type);
            end
        end
        fprintf(fid, '\nEND[%d]\n',nrSamples(i));
        
    else
        srate(i) = NaN;
        nrSamples(i) = NaN;
    end
end

fclose(fid);

% onehour = 250 * 60 * 60;
% step = onehour/2;
% lastLatency = 0; 
% for latency = 1 : step : 16 * onehour
%     stepEvents =  eventsStruct([eventsStruct.sample] >= latency & [eventsStruct.sample] < latency+step);
%         
%     %fprintf('at 1/2hour %d, found %d events:', (latency-1) / step, length(stepEvents));
%     
%     stepEventTypes = ({stepEvents.type});
%     stepLatencies = ({stepEvents.sample});
%     for e = 1 : length(stepEvents)
%         fprintf(' %s', stepEventTypes{e});
%         if(strcmp(stepEventTypes{e}, 'sync') == 1 || ...
%             strcmp(stepEventTypes{e}, 'break cnt') == 1 || ...
%             strcmp(stepEventTypes{e}, 'BGIN') == 1 || ...
%             strcmp(stepEventTypes{e}, 'BEND') == 1 )
%             fprintf('[%d]', stepLatencies{e});
%         end
%     end 
%     fprintf('\n');
% end
