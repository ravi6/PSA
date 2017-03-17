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

  import Medium = ThermoS.Media.MyAir; // (MassFlowRate(nominal=1e-3)) ;
  import ThermoS.Uops.Reservoir;
  constant Medium.MassFraction Xstart[Medium.nXi] 
                     = Medium.reference_X[1:Medium.nXi]  ;

  constant Real ON = 99.99;
  constant Real OFF = 100 - ON;

  Reservoir     src	(redeclare  package Medium = Medium,
                               p = 3e5, T = 300, Xi = Xstart); // Reservoir 1
  Reservoir     sink	(redeclare  package Medium = Medium,
                               p = 1e5, T = 300,  Xi = Xstart); // Reservoir 2
  Reservoir     atm	(redeclare  package Medium = Medium,
                               p = 1e5, T = 300,  Xi = Xstart); // Reservoir 3
  Reservoir     srcB	(redeclare  package Medium = Medium,
                               p = 3e5, T = 300, Xi = Xstart); // Reservoir 1
  Reservoir     sinkB	(redeclare  package Medium = Medium,
                               p = 1e5, T = 300,  Xi = Xstart); // Reservoir 2
  Reservoir     atmB	(redeclare  package Medium = Medium,
                               p = 1e5, T = 300,  Xi = Xstart); // Reservoir 3
  bed           bedA, bedB   ;

equation
       connect (src.port,     bedA.vin.inlet) ;
       connect (sink.port,    bedA.vout.outlet) ;
       connect (srcB.port,     bedB.vin.inlet) ;
       connect (sinkB.port,    bedB.vout.outlet) ;
       connect (bedA.vpurge.outlet, atm.port);
       connect (bedB.vpurge.outlet, atmB.port);

initial equation
  // From some odd reason the problem gets into a knot with json file if I set bedA.vin.po = ON
  //    and that is the consistent initial condition ... but why it works with inconsistency as below.
     bedA.vin.po = OFF ; bedA.vout.po = ON ; bedA.vpurge.po = OFF ;     // feeding
     bedA.seq.pressurizing = false ; bedA.seq.feeding = true  ;  bedA.seq.purging = false;

     bedB.vin.po = OFF   ; bedB.vout.po = OFF   ; bedB.vpurge.po = ON ;  //  purging
     bedB.seq.pressurizing = false ; bedB.seq.feeding = false ;  bedB.seq.purging = true;

end plant;
