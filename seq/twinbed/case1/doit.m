function doit
f1 = "res0to40.mat" ;
f2 = "work/plant_res.mat" ;
load(f1) ; d1 = data_2'; 
load(f2); d2 = data_2';
mmm=name';
  i=randi(1000); disp(i);
  plot(d1(:,1),d1(:,i),'-',d2(:,1),d2(:,i),'-')
  grid on;ylabel(mmm(i,:)); xlabel("time(s)");
  legend(f1,f2);
end
