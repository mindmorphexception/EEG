function s = AverageStructFields(structCell)
    % takes a cell array of structs with the same fields
    % returns a struct where fields of the cell array members have been averaged
    
    % get field names
    fields = fieldnames(structCell{1});
    
    % get nr structs to average
    nrStructs = length(structCell);
    
    % for each field
    for i = 1:numel(fields)
        
        fieldLength = length(structCell{1}.(fields{i}));
        
        % initialize
        s.(fields{i}) = zeros(1, fieldLength);
        
        % median
        for j = 1:fieldLength
            values = zeros(1,nrStructs);
            for k = 1:nrStructs
                values(k) = structCell{k}.(fields{i})(j);
            end   
                s.(fields{i})(j) = median(values);
        end
        
    end
end

