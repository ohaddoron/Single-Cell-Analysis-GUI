newPar = cell(size(par));
for i = 1 : size(par,1)
    for j = 2 : size(par,2)
        if sum(strcmp(par(:,j),par{i,1}))
            newPar(i,j) = par(i,1);
        else
            newPar(i,j) = {''};
            
        end
    end
end