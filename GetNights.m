function nights = GetNights(patientnr)
    % gets and array like [1 2] if we know this patient has nights 1 and 2
    
    if (environment ~= 4)
        nights = [1 2];
    
        if(ismember(jobnrs(patientnr),[1 4 8 12 14 99]))
            nights = 1;
        end

        if(jobnrs(patientnr) == 2)
            nights = [1 2 3];
        end
    else
        nights = 0;
    end
end

