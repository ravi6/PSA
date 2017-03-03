function sumsq = zeoliteX5(voidage)
%Date: 22nd Dec. 2016

% Optimization showed that if I use voidage =0.2 the difference between two data sets
% is the least


colors=["r" "g" "b" "c"];


% Adsorption loading at [1 to 7 bar pressures] {Q expressed as mmol/gm}
% Ruthven page 30
QO2_ruth1= [ 0.12206192938434768, 0.2228967909800521 ,0.318726455380256 ,0.40956151559489695 ...
          0.4966413537866702, 0.578731884297849, 0.6570618962811917 ];
QN2_ruth1=[0.3445628066179831, 0.5479009288745591, 0.7224790291506393, 0.8583078990750981, ...
           0.974142462742398, 1.0699774236475708, 1.149562707308515 ];


rhoS = 2350 ; % Adsorbent density (kg/m3 without porosity)
%voidage = 0.2 ; % reverse engineer to see where it lies   
rhoX = rhoS * (1 - voidage) ; % Adsorbent density including porosity

% Ruth2 data from the same text book but form page 186 ... different source and method
qsO2 = 5.6 ; qsN2 = qsO2 ;
kO2=4.7;
kN2=14.8;


for i = 1 : 7

pbar = i ;
R = 8.314e3 ;
T = 300 ;

bN2 = kN2/qsN2;
bO2 = kO2/qsO2;

  P = pbar * 1e5 ;
  C = P/(R*T) ;

  yO2 = 0.0 ; yN2 = 1 - yO2 ; 
  qN2 = qsN2 * ( C * yN2 ) / (1/bN2 +  C * yN2 + (kO2/kN2) * C * yO2);
  QN2_ruth2(i) = (qN2 / rhoX) * (1e6/1e3); % mmol/gm  ... totoal molar loading (assume density of 2350 kg/m3)

  yO2 = 1.0 ; yN2 = 1 - yO2 ; 
  qO2=  qsO2 * ( C * yO2 ) / (1/bO2 + (kN2/kO2) * C * yN2 +  C * yO2);
  QO2_ruth2(i) = (qO2 / rhoX) * (1e6/1e3); % mmol/gm  ... totoal molar loading (assume density of 2350 kg/m3)

err2(i) = (QO2_ruth2(i) - QO2_ruth1(i) )^2 + (QN2_ruth2(i) - QN2_ruth1(i))^2 ;
% err2(i) = (QO2_ruth2(i) - QO2_ruth1(i) )^2 ;
end

 sumsq = sum(err2) ;

pbar = [1:7];
 hold off; plot(pbar,QN2_ruth1, ";N2_ruth1;", pbar,  QN2_ruth2, ";N2_ruth2;");
 hold on ; plot(pbar,QO2_ruth1, ";O2_ruth1;", pbar,  QO2_ruth2, ";O2_ruth2;");
ylabel("Q-mmol/gm") ; xlabel("pressure (bar)");
grid on ;
end 
