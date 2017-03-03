//  Sets up Adsorber bed with associated valves
//          (internal model to reduce clutter)
//  when modelling PSA units with multiple beds

model bed  

  package Medium = ThermoS.Media.MyAir(MassFlowRate(start=0, nominal=1e-5, min=-2e-3, max=2e-3));
  import ThermoS.Uops.Valves.RealValve;
  import ThermoS.Uops.Valves.Vchar;
  import ThermoS.Uops.PSA.Adsorber ;
  import ThermoS.Uops.PSA.sequencer;
  import ThermoS.Uops.Tanks.portMixer;

  constant Integer NN = 6 ;
  constant Real ZEROS[:] = zeros(NN-1) ;
  constant Real CQ1[:] = cat(1,{11.2}, ZEROS) ;
  constant Real CQ2[:] = cat(1,{00.7}, ZEROS) ;
  constant Real CY[:] = cat(1,{0.79}, ZEROS) ;
  constant Real QStart[:,:] =  transpose({11.2*ones(NN), 00.7*ones(NN)});
  constant Real yStart[:,:] =  transpose({0.79*ones(NN), 0.21*ones(NN)});

  Adsorber  adsbr (redeclare package Medium = Medium, N=NN,
                        bedParams(Uref = 0.35, L = 0.35, dia = 0.035, voidage = 0.4,
                                  Diff = 0.5 * 6.0e-5, dp = 0.7e-3),
                                     Coef_p(start=cat(1,{1},ZEROS)),
                                     Coef_Q(start=transpose({CQ1,CQ2})),
                                     Coef_y(start=transpose({CY})),
                                     Qeq(start=QStart), Q(start=QStart),
                                     y(start=yStart),
                                     yin_in(start={0.79, 0.21}), yin_out(start={0.79, 0.21})
                       );
                                  

//  import Modelica.Media.Interfaces.Types.* ;
  constant Medium.MassFraction Xstart[Medium.nXi] 
                     = Medium.reference_X[1:Medium.nXi]  ;
  constant Real ON = 100;
  constant Real OFF = 100 - ON;

  RealValve vin (redeclare  package Medium = Medium, 
                      cv = 44.72e-8, vchar = Vchar.Linear,  tau = 2, dpTol=0.02) ;
  RealValve vout (redeclare  package Medium = Medium, 
                     cv =  1.32e-8,  vchar = Vchar.Linear,  tau = 2, dpTol=0.02) ;
  RealValve vblow (redeclare  package Medium = Medium, 
                     cv = 17.89e-8,  vchar = Vchar.Linear,  tau = 2, dpTol=0.02) ;

  constant Integer CycleTime = 100 ; // Cycle time in sec

  seqSkarstrom seq (  pTime=0.3*CycleTime,   fTime=0.2*CycleTime,
                      bTime=0.3*CycleTime,  puTime=0.2*CycleTime) ;

  portMixer  inNode(redeclare package Medium = Medium, vol=5e-6, N=3) ; // Isothermal Mixer
  portMixer  outNode(redeclare package Medium = Medium, vol=5e-6, N=3) ; // Isothermal Mixer
    
equation
       connect (adsbr.inlet, inNode.port[1]);
       connect (vin.outlet, inNode.port[2]);
       connect (vblow.inlet, inNode.port[3]);


       connect (adsbr.outlet, outNode.port[1]) ;
       connect (vout.inlet, outNode.port[2]) ;
      

// Set valve positons as per sequence
       vin.spo = if(seq.purging or seq.blowing) then  OFF else ON ; 
       vout.spo = if(seq.feeding) then  ON else OFF ; 
       vblow.spo = if(seq.purging or seq.blowing) then  ON else OFF ; 

initial equation

  for n in 1:adsbr.Nc-1 loop             // Gas Composition in interior 
     for m in 1:adsbr.N-2 loop
       adsbr.y[m, n]  = Medium.reference_Xm[n]   ;
     end for ;
  end for ;

   for m in 1:adsbr.N loop
    adsbr.Q[m,1] =  11.173*0.5 ; //11.173        ;    // Adsorbate concentrations
    adsbr.Q[m,2] =  0.7266*0.5; //0.7266   ;
   end for ;

   for m in 1:adsbr.N-2 loop
    adsbr.p[m] = 1 ;
   end for ;

   inNode.T = 300 ;  inNode.p = 1e5 ;  inNode.Xi = Medium.reference_X[1:Medium.nXi];
   outNode.T = 300 ; outNode.p = 1e5 ; outNode.Xi = Medium.reference_X[1:Medium.nXi]; 
//    adsbr.p_in = 1.0 ;
//    adsbr.p_out = 1.0 ;
   
end bed ;   // end of bed model
