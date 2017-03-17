function var = getvar(varname, resfile)

% load work/plant_res.mat ;
load(resfile) ;
names = name';
dat   = data_2' ;
%size(dat)
%size(names)

indx = -1 ;
for i = 1 : size(names,1)
    if (names(i, 1:length(varname)) == varname)
        indx = i;
    end

if (indx != -1) 
    var =  dat(:, indx);
else
    var = [] ;
end

end 
