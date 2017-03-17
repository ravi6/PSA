figure('Position',[10,10,2000,1600]);
set(gcf,'Position',[10,10,2000,1600]);
set(gcf,"Name","bedB");

xp = [0:0.02:1];

subplot(3,2,1); hold on ;
ylabel("N2 Mole fraction in gas");
for i = 1:Ns
   #x = asort(D(i).bedB.adsbr.zs) ;  y = asort(D(i).y(:,1)')' ;
   #plot(x,y,'LineWidth',1,'color',colors(i),'Marker', 'o', '.'); 
   yp = polyfunc(D(i).bedB.adsbr.Coef_y(:,1)', xp)  ;
   plot(xp, yp, 'LineWidth', 1,'color',colors(i), '-'); 
   ltxt{i} =  sprintf("t=%.1f",D(i).time);
end
legend(ltxt);
xlabel("Length (dimensionless)");
grid on ;


subplot(3,2,2); hold on ;
ylabel("N2 Mole fraction in Solid");
for i = 1:Ns
  # x = asort(D(i).bedB.adsbr.zs) ;  y = asort(D(i).Q(:,1)')' ;
  # plot(x,y,'LineWidth',1,'color',colors(i),'Marker', 'o', '.'); 
   yp1 = polyfunc(D(i).bedB.adsbr.Coef_Q(:,1)', xp);  yp2 = polyfunc(D(i).bedB.adsbr.Coef_Q(:,2)', xp);  yp=yp1./(yp1+yp2);
   plot(xp, yp, 'LineWidth', 1,'color',colors(i), '-'); 
   ltxt{i} =  sprintf("t=%.1f",D(i).time);
end
legend(ltxt);
xlabel("Length (dimensionless)");
grid on ;


subplot(3,2,3); hold on ;
ylabel("Gas Velocity");
for i = 1:Ns
#   x = asort(D(i).zs) ;  y = asort(D(i).u) ;
#   plot(x,y,'LineWidth',1,'color',colors(i),'Marker', 'o', '.'); 
   yp = polyfunc(D(i).bedB.adsbr.Coef_u, xp);  
   plot(xp, yp, 'LineWidth', 1,'color',colors(i), '-'); 
   ltxt{i} =  sprintf("t=%.1f",D(i).time);
end
legend(ltxt);
xlabel("Length (dimensionless)");
grid on ;


subplot(3,2,4); hold on ;
ylabel("Adsorption Rate (N2)");
for i = 1:Ns
   x = asort(D(i).bedB.adsbr.zs) ;  y = asort(D(i).bedB.adsbr.S(:,1)')' ;
   #plot(x,y,'LineWidth',1,'color',colors(i),'Marker', 'o', '.'); 
   plot(x,y,'LineWidth',1,'color',colors(i)); 
   ltxt{i} =  sprintf("t=%.1f",D(i).time);
end
legend(ltxt);
xlabel("Length (dimensionless)");
grid on ;

subplot(3,2,5); hold on ;
ylabel("Pressure (bar)");
for i = 1:Ns
   yp = polyfunc(D(i).bedB.adsbr.Coef_p, xp);  
   plot(xp, yp, 'LineWidth', 1,'color',colors(i), '-'); 
   ltxt{i} =  sprintf("t=%.1f",D(i).time);
end
legend(ltxt);
xlabel("Length (dimensionless)");
grid on ;

subplot(3,2,6); hold on ;
ylabel("Inlet Pressure (bar)");
for i = 1:Ns
yn(i) =  D(i).bedB.adsbr.p_in;  
xn(i) =  D(i).time;
end
   plot(xn, yn, 'LineWidth', 1,'color',colors(1), '-'); 
xlabel("time");
grid on ;

figure ; set(gcf,"Name","bedB");
ylabel("Mass Flow Rate (kg/s)");
for i = 1:Ns
yn1(i) =  D(i).bedB.adsbr.inlet.m_flow;  
yn2(i) =  -D(i).bedB.adsbr.outlet.m_flow;  
xn(i) =  D(i).time;
end
   hold on ;
   plot(xn, yn1,  'LineWidth', 2,'color',colors(1), '-o'); 
   plot(xn, yn2,  'LineWidth', 2,'color',colors(2), '-x'); 
   hold off ;
xlabel("time"); legend("in_flow", "out_flow");
grid on ;


#title("Time Evolution of profiles in Adsorber at 1bar and 2bar")

#saveas(1,"plot.jpg");
pause
#pkg unload miscellaneous
#   yp = polyfunc(D(i).bedB.adsbr.Coef_u, xp)  
#   plot(xp, yp, 'LineWidth', 1,'color',colors(i), '-'); 
#legend("t=0.1", "t=0.2", "t=0.3", "t=0.4", "t=0.5", "t=0.6", "location", "west");
