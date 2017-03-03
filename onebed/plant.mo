model plant 
/*
  Test the effect of reversing flows with reservoirs
   connected to the bed. Localized Reservoir model with ability
   to dynamically change its pressure, compostion etc.

*/

  import Modelica.Media.Interfaces.Types.* ;
  import ThermoS.Uops.Valves.RealValve;
//  import ThermoS.Uops.Reservoir;
  import ThermoS.Uops.PSA.Adsorber;
  import ThermoS.Uops.PSA.bedParamsRec;
  import ThermoS.Uops.PSA.massToMole    ;
  package Medium = ThermoS.Media.MyAir  ;

  constant Medium.MolarMass Mw[Medium.nS]  = Medium.fluidConstants[:].molarMass * 1000;
  constant Medium.MassFraction Xstart[Medium.nXi] = Medium.reference_X[1:Medium.nXi]  ;

//****************************************
  constant Boolean withValves = false ;
//****************************************


  Reservoir    res1   (redeclare package Medium = Medium,  T = 300, Xi = Xstart); // Reservoir 1
  Reservoir    res2   (redeclare package Medium = Medium,  T = 300, Xi = Xstart); // Reservoir 2

  RealValve    v1 (redeclare package Medium = Medium, cv=0.04/sqrt(0.5e5)
                          )  if withValves ;
  RealValve    v2 (redeclare package Medium = Medium, cv=0.04/sqrt(0.5e5)
                          )  if withValves ;

  constant Integer NN = 6 ;
  constant Integer ZEROS[:] = zeros(NN-1) ;
  Adsorber  adsorber (redeclare package Medium = Medium, N=NN,
                        bedParams(L = 0.35, dia = 0.035, voidage = 0.4,
                                  Uref = 0.35, Diff = 1e-3, dp = 0.7e-3),
                                     Coef_p(start=cat(1,{1},ZEROS)),
                                     Coef_Q(start=transpose({
                                                             cat(1,{11.2},ZEROS),
                                                             cat(1,{00.7},ZEROS)
                                                            })),
                                     Coef_y(start=transpose({cat(1,{0.79},ZEROS)}))
                       );
                                  

/*
  Adsorber    adsorber(redeclare package Medium = Medium, N=12, 
                        bedParams.voidage=0.4,
                        Coef_p(start={1,0,0,0,0,0,0,0,0,0,0,0}),
                        Coef_u(start={1,0,0,0,0,0,0,0,0,0,0,0}),
                        Coef_y(start=transpose([0.5,0,0,0,0,0,0,0,0,0,0,0])),
                        Coef_Q(start=(transpose({{0.5,0,0,0,0,0,0,0,0,0,0,0}, 
                                               {0.5,0,0,0,0,0,0,0,0,0,0,0}})))
                      );
*/
  Real eps, voidage ;                       
equation

   if withValves then
    connect (res1.port, v1.inlet);
    connect (v1.outlet, adsorber.inlet);
    connect (adsorber.outlet, v2.inlet);
    connect (v2.outlet, res2.port);
    v1.spo = 99.9 * (1 - exp(-time/0.1))  ;
    v2.spo = 5 * (1 - exp(-time/0.1))  ;
   else
    connect (res1.port, adsorber.inlet);
    connect (res2.port, adsorber.outlet);
   end if;
   

    res1.p =  1.3e5 ; // +0.25e5 * cos(2*3.14*time/20) ;
    res2.p =  1.3e5 ; // 2.0e5 +0.25e5 * sin(2*3.14*time/20) ;

    voidage = adsorber.bedParams.voidage ;
    eps = adsorber.bedParams.Epsilon ;
   
initial equation


   if withValves then
      v1.po = 1.00 ;
      v2.po = 1.00 ;
   end if;

  for n in 1:adsorber.Nc-1 loop             // Gas Composition in interior 
     for m in 1:adsorber.N-2 loop
       adsorber.y[m, n]  = Medium.reference_Xm[n]   ;
     end for ;
  end for ;

   for m in 1:adsorber.N loop
    adsorber.Q[m,1] = 11.2 ;    // Adsorbate concentrations
    adsorber.Q[m,2] = 0.7 ;
   end for ;

   for m in 1:adsorber.N-2 loop
    adsorber.p[m] = 1.0 ;
   end for ;

end plant;
/*
(MassFlowRate(min=-1, max=1, nominal=1e-3, start=1e-4),
                                        ThermodynamicState(p(start=1.0e5), T(start=300), X(start=ThermoS.Media.MyAir.reference_X)),
                                        MassFraction(each start=0.1)
                                        ) ;
    // v1.po = 50 +  25 * sin(2*3.14*time/2.0); //(1 - exp(-time/10)) ;
                           //  y(each start=0.1), u(each start=0)) ;
*/

