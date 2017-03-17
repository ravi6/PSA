colors=['r' 'g' 'b' 'y' 'm' 'c' 'r'] ;


subplot(3,1,1); hold on ;
  xp=getvar("time"); yp=getvar("TankA.p") * 1e-5 ;
  plot(xp, yp, 'LineWidth', 2,'color',colors(1), '-'); 
  yp=getvar("TankB.p") * 1e-5; 
  plot(xp, yp, 'LineWidth', 2,'color',colors(2), '-'); 
  legend({"TankA", "TankB"}); xlabel("time(s)"); grid on ;
  ylabel("Tank Pressure (bar)"); 

subplot(3,1,2); hold on ;
  xp=getvar("time"); yp=getvar("TankA.T") -273 ;
  plot(xp, yp, 'LineWidth', 2,'color',colors(1), '-'); 
  yp=getvar("TankB.T") -273 ;
  plot(xp, yp, 'LineWidth', 2,'color',colors(2), '-'); 
  legend({"TankA", "TankB"}); xlabel("time(s)"); grid on ;
  ylabel("Tank Temperature (C)"); 

subplot(3,1,3); hold on ;
  xp=getvar("time"); yp=getvar("src.port.m_flow") ;
  plot(xp, yp, 'LineWidth', 2,'color',colors(1), '-'); 
  yp=getvar("sink.port.m_flow") ;
  plot(xp, yp, 'LineWidth', 2,'color',colors(2), '-'); 
  yp=getvar("atm.port.m_flow") ;
  plot(xp, yp, 'LineWidth', 2,'color',colors(3), '-'); 
  legend({"Feed", "Prod", "Purge"}); xlabel("time(s)"); grid on ;
  ylabel("Flow Rate (kg/s)"); 

  FS = findall(gcf,'-property', 'fontsize') ;
#  set(FS,'fontsize',6) ;

pause ;
#plot(x,y,'LineWidth',2,'color',colors(i),'Marker', 'o', '.'); 
#saveas(1,"plot.jpg");

