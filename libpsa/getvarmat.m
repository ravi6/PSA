function var = getvarmat(varname,fname)

load(fname); 
names = name';
dat   = data_2' ;

indx = -1 ;
for i = 1 : size(names,1)
    if (names(i, 1:length(varname)) == varname)
        indx = i;
    end

if (indx != -1) 
    var = dat(:, indx);
else
    var = [] ;
end

end 
