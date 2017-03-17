model Reservoir
  // A large Reservoir with constant (p, T, & Xi)
  // Permits reverse flow through its port
   import Modelica.Media.Interfaces.PartialMixtureMedium;
   import Modelica.Fluid.Interfaces.FluidPort;

  replaceable package Medium = PartialMixtureMedium ;
  FluidPort port (redeclare package Medium = Medium)  ; 
	// Specify that our Medium is used in outlet

  Medium.AbsolutePressure     p               ;
  parameter Medium.Temperature          T               ;
  parameter Medium.MassFraction         Xi[Medium.nXi]  ;

  Medium.ThermodynamicState state ;

  equation
    state 		= Medium.setState_pTX( p, T, Xi ); 
    port.h_outflow 	= Medium.specificEnthalpy(state) ;
    port.Xi_outflow 	= Xi;
    port.p		= p ;
end Reservoir;
