function profile;
file1 = "res0to40.mat";
t=getvar("time",file1) ;

for j = 1:12
varname=sprintf("bedA.adsbr.y[%d,1]",j)
y(:,j)=getvar(varname,file1); 
varname=sprintf("bedA.adsbr.zs[%d]",j)
z(:,j)=getvar(varname,file1); 
end

z



plot(z',y','-'); 
grid on ;
pause ;
end
