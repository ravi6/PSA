## usage: csv2mat(file)
## Convert csv result file to mat format
##
## Note:
##   mat file contains structure s containing
##   all model file variables as fields
##   Variable Names containing vector notation symbols
##   are replaced with an under score 
##   for example   bedA.X[1,2] -->   bedA_X_1_2
##
## Author: Ravi Sankar Saripalli

%================================
function csv2mat(file) ;
%================================
%  Convert Crappy OpenModelica CSV file to MAT file
%   using strucures

csvfile=sprintf("%s.csv",file);

%Breakup Variable Names to make them fieldable
fid=fopen(csvfile); str=fgetl(fid); fclose(fid);
str=strrep(str,""",""","^"); str=strrep(str,",","_");
str=strrep(str,"[","_"); str=strrep(str,"]","");
str=strrep(str,"^",","); str=strrep(str,"""","");
str=strrep(str,".","_"); str=strrep(str,"der($","der_");
str=strrep(str,"der(","der_");
str=strrep(str,")",""); str=strsplit(str,",");

s=struct();
data=csvread(csvfile,1,0); % skip the header that gives headache
disp(sprintf("Data Points = %d , Variables = %d",size(data,1), length(str)));
for i=1:length(str)
   s=setfield(s,str{i},data(:,i));
end
matfile=sprintf("%s.mat",file)
save("-binary", matfile, "s") 
end
