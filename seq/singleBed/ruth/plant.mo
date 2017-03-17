model plant
/*
Author: Ravi Saripalli
Date  : 16th Oct. 2015

A double bed Pressure Swing Adsoption Unit

*/

  import ThermoS.Uops.Reservoir;
  import Medium = ThermoS.Media.MyAir;
  constant Medium.MassFraction Xstart[Medium.nXi] 
                     = Medium.reference_X[1:Medium.nXi]  ;

  constant Real ON = 99.9;
  constant Real OFF = 100 - ON;

  Reservoir     src	(redeclare  package Medium = Medium,
                               p = 3e5, T = 300, Xi = Xstart); // Reservoir 1
  Reservoir     sink	(redeclare  package Medium = Medium,
                               p = 1e5, T = 300,  Xi = Xstart); // Reservoir 2
  Reservoir     atm	(redeclare  package Medium = Medium,
                               p = 1e5, T = 300,  Xi = Xstart); // Reservoir 3
  bed           bedA   ;

equation
       connect (src.port,     bedA.vin.inlet) ;
       connect (sink.port,    bedA.vout.outlet) ;
       connect (bedA.vpurge.outlet, atm.port);

initial equation
     bedA.vin.po = OFF ; bedA.vout.po = OFF ; bedA.vpurge.po = ON ;     // purging
     bedA.seq.pressurizing = false ; bedA.seq.feeding = false  ;  bedA.seq.purging = true;

end plant;
