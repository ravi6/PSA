## Usage: getindex(varname, fname)
##
##  Returns variable position in result file fname
##    
##  Note:
##   File is of type csv and fully qualified name be supplied
##   Returns zero if no match found
##
##  Variable name convention for vectors is
##        X[1,2] -->  X[1_2]
##
## Author: Ravi Sankar Saripalli

function var = getindex(varname,fname)

#Sanitize Variable Names that are Two dimensional Vectors
#The sed command we want to execute is
#sed -r '1,1s/(\[[0-9]*),/\1_/g   fname  > /tmp/tmpfile

#Well we need to add some more escapes b'cause we are passing through system
system("rm /tmp/tmpfile");
cmd = cstrcat("sed -r '1,1s/(\\[[0-9]*),/\\1_/g' " ,  fname ,  " > /tmp/tmpfile");

if  system(cmd) == 0   
    cmd="Success";
    data = csvread(fname);
end

#Now parse the variable names
fid = fopen("/tmp/tmpfile");
stNames=fgetl(fid) ;  
fclose(fid);
names=ostrsplit(stNames,',');
nVars=size(names,2);

#Get the index of the variable you are after
j = 0 ;
for i = 1:nVars
   str = cstrcat("\"",varname,"\"");
   if strcmp(str, names(1,i))
      j = i ;
   end
end
  var = j;
end 
