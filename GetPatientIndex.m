function index = GetPatientIndex(patientnr, nightnr)
% gets the index of the entry in the 'data' struct 
% returns -1 if entry not found

    LoadFolderNames;
    index = -1;
    if(environment ~= 4)
        str = ['p' num2str(patientnr) '_overnight' num2str(nightnr)];
    else
        str = [ sprintf('%02d',patientnr) '-2010-anest'];
    end
    
    for i = 1:length(data)
        if(strfind(data{i},str) == 1)
            index = i;
            return;
        end
    end
end
