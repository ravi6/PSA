function isotherm(pbar, qsO2, qsN2, k)
colors=["r" "g" "b" "c"];

kO2=4.7;
kN2=14.8;

R = 8.314e3 ;
P = pbar * 1e5 ;
T = 300 ;

bN2 = kN2/qsN2;
bO2 = kO2/qsO2;

  P = pbar * 1e5 
  C = P/(R*T) 

for i = 1 : 11
  yO2 = (i-1) * 0.1 ;
  yN2 = 1 - yO2 ;

%  qN2(i) = qsN2 * ( bN2 *  C * yN2 ) / (1 + bN2 * C * yN2 + bO2 * C * yO2);
%  qO2(i)=  qsO2 * ( bO2 *  C * yO2 ) / (1 + bN2 * C * yN2 + bO2 * C * yO2);
  qN2(i) = qsN2 * ( C * yN2 ) / (1/bN2 +  C * yN2 + (kO2/kN2) * C * yO2);
  qO2(i)=  qsO2 * ( C * yO2 ) / (1/bO2 + (kN2/kO2) * C * yN2 +  C * yO2);
  x(i) = yO2 ;
  y(i) = qO2(i)/(qO2(i) + qN2(i));
  alpha(i) = (x(i) * (1-y(i))) / (y(i) * (1-x(i)) ) ;  % separation factor
  qt(i) = ((qN2(i) + qO2(i)) / (2350*0.8)) * (1e6/1e3); % mmol/gm  ... totoal molar loading (assume density of 2350 kg/m3)
end
plot(y,x,colors(k)); hold on ;

for i = 1 : 11
  yO2 = (i-1) * 0.1 ;
  yN2 = 1 - yO2 ;

%  qN2(i) = qsN2 * ( bN2 *  C * yN2 ) / (1 + bN2 * C * yN2 + bO2 * C * yO2);
%  qO2(i)=  qsO2 * ( bO2 *  C * yO2 ) / (1 + bN2 * C * yN2 + bO2 * C * yO2);
  qN2(i) = qsN2 * ( C * yN2 ) / (1/bN2 +  C * yN2 );
  qO2(i)=  qsO2 * ( C * yO2 ) / (1/bO2 +  C * yO2);
  x(i) = yO2 ;
  y(i) = qO2(i)/(qO2(i) + qN2(i));
  alpha(i) = (x(i) * (1-y(i))) / (y(i) * (1-x(i)) ) ;  % separation factor
  qt(i) = ((qN2(i) + qO2(i)) / (2350*0.8)) * (1e6/1e3); % mmol/gm  ... totoal molar loading (assume density of 2350 kg/m3)
end
plot(y,x,colors(k+1)); hold on ;


xlabel("xO2");
ylabel("Qt(mmol/gm)");
grid on ;
end 
