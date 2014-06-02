function ValidateFieldEquality(struct1, struct2, fieldname)

    % throws an error if the given field is not equal in the two given structs
    
    if(~isequal(getfield(struct1, fieldname), getfield(struct2, fieldname)))
        error('%s is not equal in the two structs.',fieldname);
    end
    
end

