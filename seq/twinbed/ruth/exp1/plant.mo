model plant
/*
Author: Ravi Saripalli
Date  : 16th Oct. 2015

A double bed Pressure Swing Adsoption Unit

*/

//  import ThermoS.Types.*;
//  import Modelica.Media.Interfaces.Types.* ;
//  import ThermoS.Uops.Valves.RealValve;
//  import ThermoS.Uops.Valves.Vchar;

  import ThermoS.Uops.Reservoir;
  package Medium = ThermoS.Media.MyAir(MassFlowRate(start=0, nominal=1e-5, min=-2e-3, max=2e-3));
  import ThermoS.Uops.Valves.RealValve;
  import ThermoS.Uops.Valves.Vchar;
  constant Medium.MassFraction Xstart[Medium.nXi] 
                     = Medium.reference_X[1:Medium.nXi]  ;

  constant Real ON =100 ;
  constant Real OFF = 100 - ON;

  Reservoir     src	(redeclare  package Medium = Medium,
                               p = 1.5e5, T = 300, Xi = Xstart); // Reservoir 1
  Reservoir     sink	(redeclare  package Medium = Medium,
                               p = 1e5, T = 300,  Xi = Xstart); // Reservoir 2
  Reservoir     atm	(redeclare  package Medium = Medium,
                               p = 1e5, T = 300,  Xi = Xstart); // Reservoir 3
  bed           bedA, bedB   ;

   RealValve vpurge (redeclare  package Medium = Medium, 
                      cv = 2 * 0.933 * 0.5 * 10 * 2.5e-6/sqrt(0.5e5),  vchar = Vchar.Linear,  tau = 2, dpTol=0.02) ;

equation
       connect (src.port,     bedA.vin.inlet) ;
       connect (sink.port,    bedA.vout.outlet) ;

       connect (src.port,     bedB.vin.inlet) ;
       connect (sink.port,    bedB.vout.outlet) ;

       connect (bedA.vblow.outlet, atm.port);
       connect (bedB.vblow.outlet, atm.port);

// Product purge line connections
       connect (bedA.outNode.port[3], vpurge.inlet) ;
       connect (bedB.outNode.port[3], vpurge.outlet) ;

//   Disconnect the common purge line
//       connect (bedA.adsbr.outlet, vpurge.inlet) ;
//       connect (vpurge.outlet, sink.port);

   vpurge.spo = if (bedA.seq.purging or bedB.seq.purging) then ON else OFF ;
       
initial equation
     bedA.vin.po = OFF ; bedA.vout.po = ON ;  bedA.vblow.po = OFF;     // feeding
     bedA.seq.pressurizing = false ; bedA.seq.feeding = true  ;  bedA.seq.purging = false; bedA.seq.blowing = false;

     bedB.vin.po = OFF   ; bedB.vout.po = OFF  ; bedB.vblow.po = ON;  //  purging
     bedB.seq.pressurizing = false ; bedB.seq.feeding = false ;  bedB.seq.purging = true; bedB.seq.blowing = false;

    vpurge.po = ON ;
end plant;
