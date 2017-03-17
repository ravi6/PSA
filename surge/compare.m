function compare(varname,file1,file2);
tx=getvar("time",file1); ty=getvar("time",file2);
y1=getvar(varname,file1); y2=getvar(varname,file2);
plot(tx,y1,ty,y2);
xlabel("time(s)") ;
ylabel(varname) ;
legend(file1,file2);
grid on ;
pause ;
end
