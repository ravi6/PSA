function compare
file1 = "./workSlow/plant_res.csv" ;
file2 = "./work/plant_res.csv" ;
%figure ; plotit("bedA.vin.inlet.m_flow",file1,file2) ;
figure ; plotit("vpurge.inlet.m_flow",file1,file2) ;
%figure ; plotit("bedA.adsbr.y[6_1]",file1,file2) ;
%figure ; plotit("bedA.adsbr.u[5]",file1,file2) ;
end

function plotit(varname,file1,file2);
tx=getvarcsv("time",file1); ty=getvarcsv("time",file2);
y1=getvarcsv(varname,file1); y2=getvarcsv(varname,file2);
plot(tx,y1,ty,y2);
xlabel("time(s)") ;
ylabel(varname) ;
legend(file1,file2);
grid on ;
end
