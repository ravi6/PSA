function rho = rhomix(xO2)
%Mass density of N2 O2 mixture at 25C, and 1 atm
 T = 25 + 273 ;
 P = 1.013e5 ;
 R = 8.314e3 ;
 Mw = 32*xO2 + 28 * (1-xO2) ;
 rho = Mw * P / (R * T) ;
end
