model plant
/*
Author: Ravi Saripalli
Date  : 16th Oct. 2015

A double bed Pressure Swing Adsoption Unit

*/


  import Medium = ThermoS.Media.MyAir; 
  import ThermoS.Uops.Reservoir;
  constant Medium.MassFraction Xstart[Medium.nXi] 
                     = Medium.reference_X[1:Medium.nXi]  ;

  constant Real ON = 99;
  constant Real OFF = 100 - ON;

  Reservoir     src	(redeclare  package Medium = Medium, p = 3e5, T = 300, Xi = Xstart);
  Reservoir     sink	(redeclare  package Medium = Medium, p = 2e5, T = 300,  Xi = Xstart); 
  Reservoir     atm	(redeclare  package Medium = Medium, p = 1e5, T = 300,  Xi = Xstart);
  bed           bedA, bedB   ;

equation
       connect (src.port,     bedA.vin.inlet);
       connect (sink.port,    bedA.vout.outlet);
       connect (atm.port,     bedA.vpurge.outlet);

       connect (src.port,     bedB.vin.inlet);
       connect (sink.port,    bedB.vout.outlet);
       connect (atm.port,     bedB.vpurge.outlet);

initial equation
     bedA.vin.po = ON ; bedA.vout.po = ON ; bedA.vpurge.po = OFF ;     // feeding
     bedA.seq.pressurizing = false ; bedA.seq.feeding = true  ;  bedA.seq.purging = false;

     bedB.vin.po = OFF   ; bedB.vout.po = OFF   ; bedB.vpurge.po = ON ;  //  purging
     bedB.seq.pressurizing = false ; bedB.seq.feeding = false ;  bedB.seq.purging = true;

end plant;
