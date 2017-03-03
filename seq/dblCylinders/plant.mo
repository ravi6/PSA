model plant
/*
  Author: Ravi Saripalli
*/

  import ThermoS.Uops.Reservoir;
  import ThermoS.Uops.Valves.RealValve;
  import ThermoS.Uops.Valves.Vchar;
  import ThermoS.Uops.Tanks.GasTank;
  import ThermoS.Types.*;

// This is the cleanest way of have start values for the medium calculations
  package Gas = ThermoS.Media.MyGas;

  constant Real AirComp[2] = {0.767,0.230};

  Reservoir     src	(redeclare  package Medium = Gas,
                               p = 3e5, T = 300, Xi = AirComp); // Reservoir 1

  Reservoir     sink	(redeclare  package Medium = Gas,
                               p = 2e5, T = 300,  Xi = AirComp); // Reservoir 2

  Reservoir     atm	(redeclare  package Medium = Gas,
                               p = 1e5, T = 300,  Xi = AirComp); // Reservoir 3

  GasTank  TankA (redeclare package Medium = Gas, vol = 1.0);
  GasTank  TankB (redeclare package Medium = Gas, vol = 1.0);

  RealValve vA[3] (redeclare each package Medium = Gas, 
                     each vchar = Vchar.Linear, each tau = 10e-3) ;

  RealValve vB[3] (redeclare each package Medium = Gas, 
                     each vchar = Vchar.Linear, each tau = 10e-3) ;

   sequencer seqA, seqB ;
   constant Real zero = 0.1 ;
   constant Real century = 99.9 ;
equation

// Bed-A  Valve paths
       connect (src.port,     vA[1].inlet) ;
       connect (vA[1].outlet, TankA.inlet) ;
       connect (TankA.outlet, vA[2].inlet) ;
       connect (vA[2].outlet, sink.port) ;

       connect (vA[1].outlet, vA[3].inlet);
       connect (vA[3].outlet, atm.port) ;     // purge line

// Bed-B  Valve paths
       connect (src.port,     vB[1].inlet) ;
       connect (vB[1].outlet, TankB.inlet) ;
       connect (TankB.outlet, vB[2].inlet) ;
       connect (vB[2].outlet, sink.port) ;

       connect (vB[1].outlet, vB[3].inlet);
       connect (vB[3].outlet, atm.port) ;     // purge line

// Set valve positons as per sequence

       vA[1].spo = if(seqA.purging) then  zero else century ; 
       vA[2].spo = if(seqA.feeding) then  century else zero ; 
       vA[3].spo = if(seqA.purging) then  century else zero ; 

       vB[1].spo = if(seqB.purging) then  zero else century ; 
       vB[2].spo = if(seqB.feeding) then  century else zero ; 
       vB[3].spo = if(seqB.purging) then  century else zero ; 
    
initial equation
     vA[1].po = century ; vA[2].po = century ; vA[3].po = zero ;     // feeding
     vB[1].po = zero ; vB[2].po = zero   ; vB[3].po = century ;  //  purging

     TankA.p = 1e5 ; TankA.T = 300  ; TankA.Xi = AirComp ;
     TankB.p = 1e5 ; TankB.T = 300  ; TankB.Xi = AirComp ;

     seqA.pressurizing = false ;    seqA.feeding = true ;    seqA.purging = false;
     seqB.pressurizing = false ;    seqB.feeding = false ;   seqB.purging = true;

end plant;
/*
                          (Temperature(start=300), AbsolutePressure(start=1e5), 
                                      MassFraction(start=1/ThermoS.Media.MyGas.nS),
                                    ThermodynamicState(p(start=1e5), T(start=300), X(start=AirComp)));
*/
