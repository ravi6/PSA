//  Sets up Adsorber bed with associated valves
//          (internal model to reduce clutter)
//  when modelling PSA units with multiple beds

model bed  

  package Medium = ThermoS.Media.MyAir; //(MassFlowRate(nominal=1e-3));
  import ThermoS.Uops.Valves.RealValve;
  import ThermoS.Uops.Valves.Vchar;
  import ThermoS.Uops.PSA.Adsorber ;
  import ThermoS.Uops.PSA.sequencer;

  Adsorber  adsbr (redeclare package Medium = Medium, N=6);
                         //   y(each start=0.5), u(each start=0)) ;

//  import Modelica.Media.Interfaces.Types.* ;
  constant Medium.MassFraction Xstart[Medium.nXi] 
                     = Medium.reference_X[1:Medium.nXi]  ;
  constant Real ON = 99;
  constant Real OFF = 100 - ON;


  RealValve vin (redeclare  package Medium = Medium, 
                      cv = 0.004/sqrt(0.5e5), vchar = Vchar.Linear,  tau = 100e-3, dpTol=100) ;
  RealValve vout (redeclare  package Medium = Medium, 
                     cv = 0.004/sqrt(0.5e5),  vchar = Vchar.Linear,  tau = 100e-3, dpTol=100) ;
  RealValve vpurge (redeclare  package Medium = Medium, 
                     cv = 0.004/sqrt(0.5e5),  vchar = Vchar.Linear,  tau = 100e-3, dpTol=100) ;
   sequencer seq ;

equation
       connect (vin.outlet, adsbr.inlet);
       connect (vin.outlet, vpurge.inlet);
       connect (adsbr.outlet, vout.inlet) ;
      

// Set valve positons as per sequence
       vin.spo = if(seq.purging) then  OFF else ON ; 
       vout.spo = if(seq.feeding) then  ON else OFF ; 
       vpurge.spo = if(seq.purging) then  ON else OFF ; 

initial equation

  for n in 1:adsbr.Nc-1 loop             // Gas Composition in interior 
     for m in 1:adsbr.N-2 loop
       adsbr.y[m, n]  = Medium.reference_Xm[n]   ;
     end for ;
  end for ;

   for m in 1:adsbr.N loop
    adsbr.Q[m,1] = 11.2 ;    // Adsorbate concentrations
    adsbr.Q[m,2] = 0.7 ;
   end for ;

   for m in 1:adsbr.N-2 loop
    adsbr.p[m] = 1.0 ;
   end for ;

   
end bed ;   // end of bed model
