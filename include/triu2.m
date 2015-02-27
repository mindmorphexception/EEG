function vector = triu2(matrix)
% Returns the elements of matrix above the diagonal as a vector.
% Author: Iulia

    vector = [];
    for i = 1:size(matrix,1)
        for j = i+1:size(matrix,2)
            vector = [vector matrix(i,j)];
        end
    end

end

