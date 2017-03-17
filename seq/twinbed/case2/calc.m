cv=0.004/sqrt(0.5e5) 
rho=1 
dp=2e5 
mdot = cv * sqrt(rho) * sqrt(dp) 
dia=0.2
area=pi()*dia*dia*0.25
umax=mdot/(rho*area)
Threshold.u=umax/100;
Threshold.dp=dp/100;
Threshold.mflow=mdot/100;
Threshold
