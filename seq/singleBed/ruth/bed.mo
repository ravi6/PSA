//  Sets up Adsorber bed with associated valves
//          (internal model to reduce clutter)
//  when modelling PSA units with multiple beds

model bed  

  import Medium = ThermoS.Media.MyAir;
  import ThermoS.Uops.Valves.RealValve;
  import ThermoS.Uops.Valves.Vchar;
  import ThermoS.Uops.PSA.Adsorber ;
  import ThermoS.Uops.PSA.sequencer;
  import ThermoS.Uops.PSA.bedParamsRec;

  Adsorber  adsbr (redeclare package Medium = Medium, N=12,
                      bedParams(voidage = 0.4, dia = 0.035, L = 0.35,
                                             dp = 0.707e-3,  Diff = 2.0e-5));

                         //   y(each start=0.5), u(each start=0)) ;

//  import Modelica.Media.Interfaces.Types.* ;
  constant Medium.MassFraction Xstart[Medium.nXi] 
                     = Medium.reference_X[1:Medium.nXi]  ;
  constant Real ON = 99.9;
  constant Real OFF = 100 - ON;


  RealValve vin (redeclare  package Medium = Medium, 
                      cv = 0.00004/sqrt(0.5e5), vchar = Vchar.Linear,  tau = 100e-3) ;
  RealValve vout (redeclare  package Medium = Medium, 
                     cv = 4*0.000004/sqrt(0.5e5),  vchar = Vchar.Linear,  tau = 100e-3) ;
  RealValve vpurge (redeclare  package Medium = Medium, 
                     cv = 0.00004/sqrt(0.5e5),  vchar = Vchar.Linear,  tau = 100e-3) ;

  constant Integer CycleTime = 100 ;
  sequencer seq(pTime=0.3*CycleTime,  fTime=0.2*CycleTime, puTime=0.5*CycleTime) ;

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
    adsbr.Q[m,1] = 11.2*0.01 ;    // Adsorbate concentrations
    adsbr.Q[m,2] = 0.7 *0.01;
   end for ;

   for m in 1:adsbr.N-2 loop
    adsbr.p[m] = 1.0 ;
   end for ;

//    adsbr.p_in = 1.0 ;
//    adsbr.p_out = 1.0 ;
   
end bed ;   // end of bed model
