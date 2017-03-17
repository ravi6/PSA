model plant
/*
Author: Ravi Saripalli
Date  : 16th Oct. 2015

*/

//  import ThermoS.Types.*;
//  import Modelica.Media.Interfaces.Types.* ;
  import ThermoS.Uops.Valves.RealValve;
  import ThermoS.Uops.Valves.Vchar;

  import ThermoS.Uops.Reservoir;
  import Medium = ThermoS.Media.MyAir;
  constant Medium.MassFraction Xstart[Medium.nXi] 
                     = Medium.reference_X[1:Medium.nXi]  ;


  Reservoir     src	(redeclare  package Medium = Medium,
                               p = 3e5, T = 300, Xi = Xstart); // Reservoir 1
  Reservoir     sink	(redeclare  package Medium = Medium,
                               p = 2e5, T = 300,  Xi = Xstart); // Reservoir 2
  Reservoir     atm	(redeclare  package Medium = Medium,
                               p = 1e5, T = 300,  Xi = Xstart); // Reservoir 3
  RealValve vin (redeclare  package Medium = Medium, 
                      vchar = Vchar.Linear,  tau = 100e-3) ;
  RealValve vout (redeclare  package Medium = Medium, 
                      vchar = Vchar.Linear,  tau = 100e-3) ;
  RealValve vbed (redeclare  package Medium = Medium, 
                      vchar = Vchar.Linear,  tau = 100e-3) ;
  RealValve vpurge (redeclare  package Medium = Medium, 
                      vchar = Vchar.Linear,  tau = 100e-3) ;

equation
       connect (src.port,     vin.inlet) ;
       connect (vin.outlet, vbed.inlet);
       connect (vbed.outlet, vout.inlet);
       connect (sink.port,    vout.outlet) ;

       connect (vpurge.outlet, atm.port);
       connect (vpurge.inlet,  vbed.inlet);

       vin.spo = 99.9 * ( 1 - exp(-time/10))  ;
       vout.spo = 99.9 * ( 1 - exp(-time/5));
       vpurge.spo = 50.0 * ( 1 - exp(-time/20)) ;
       vbed.spo = 70.0 ;

initial equation
end plant;
