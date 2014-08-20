function [patientnr, nightnr] = GetPatientNightNr(index)
    
    LoadFolderNames;
    filename = data{index,1};
    
    if (environment ~= 4)
        loc1 = strfind(filename,'_');
        loc2 = strfind(filename,' ');
        patientnr = str2num(filename(2:loc1(1)-1));
        nightnr = str2num(filename(loc2-1:loc2));
    else
        patientnr = str2num(filename(1:2));
        nightnr = 0;
    end

end

