% peclet(CycleT, Ph, Qin)
%==========================
function peclet(CycleT, Ph, Qin)
Voidage = 0.4
ptimeF = 0.5
q = (1/Ph) * Qin/ptimeF  # volumetric flow
L = 0.35  
dia = 0.035
v = q / (pi * dia * dia * 0.25 )  % superficial velocity
Pe = 500
Diff = L * v / (Voidage * Pe)

Area = pi * dia * dia * 0.25
VolFill = Area * Voidage * L
R = 8.314e3
Mw = 32*0.21 + 28 * 0.79 
Pbar = 4
Mfill = Mw * VolFill * 1e5 * (Pbar -  1) / (R * 300 )
qin =  (Mfill / CycleT)/1.1
Ratio = qin/q
Recovery =0.2
ProdO2 = 0.93
prodRate = Recovery * qin * mfrac(ProdO2) / mfrac(ProdO2)
end

function ans = mfrac(molfrac)
ans = molfrac * 21 / (molfrac * 21 + (1-molfrac) * 79);
end

function ans = rho(yO2)
mw = yO2*32 + (1-yO2)*28 ;
ans = 1.013e5 / (mw *  8.314e3 * (275 + 25));
end
