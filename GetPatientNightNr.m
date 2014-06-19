function [patientnr, nightnr] = GetPatientNightNr(index)
    
    LoadFolderNames;
    filename = data{index,1};
    loc1 = strfind(filename,'_');
    loc2 = strfind(filename,' ');
    patientnr = str2num(filename(2:loc1(1)-1));
    nightnr = str2num(filename(loc2-1:loc2));

end

