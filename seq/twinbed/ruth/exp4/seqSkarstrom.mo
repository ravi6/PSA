model seqSkarstrom
/* This implements discrete events
      to simulate Adsorber Valving Sequence
        SKARSTROM CYCLE  ...
*/ 
import  Modelica.SIunits.Time ;

parameter Time pTime = 5 ;    // pressurization Time (sec)
parameter Time fTime = 10 ;    //  feeding  Time (sec)
parameter Time puTime = 5 ;    // purging Time (sec)
parameter Time bTime = 5 ;    // blow donw Time (sec)

parameter Time sTime = 1  ;    // Descrete Clock Sample Time (sec)


Boolean pressurizing, feeding, blowing, purging ;
Boolean pressurize, feed,  purge, bdown;
Integer pcount, fcount, pucount, bcount ;

Integer tics  ;
Boolean clocktic  ;

 equation

// Digital Clock
    clocktic = sample(0,sTime) ;  
    when clocktic then 
       tics = pre(tics) + 1 ;
    end when;
  
 // State Transition Logic     
  when pressurizing then
    pcount = tics ;     // reset pressureization counter
  end when;
  
  when feeding then
    fcount = tics ;
  end when;
  
  when purging then 
    pucount = tics ;
  end when ;

  when blowing then 
    bcount = tics ;
  end when ;
  
 // Time based transitions
    
when clocktic  then
   feed = (pre(pressurizing) and ((tics - pre(pcount)) * sTime >= pTime)) ;
   bdown = (pre(feeding) and ((tics - pre(fcount)) * sTime>= fTime)) ;
   purge = (pre(blowing) and ((tics - pre(bcount)) * sTime>= bTime)) ;
   pressurize = (pre(purging) and ((tics - pre(pucount)) * sTime >= puTime)) ;
end when ;

when {feed, pressurize, bdown, purge} then
   if (pressurize and pre(purging) ) then
     pressurizing = true ; feeding = false ; purging = false ; blowing = false; 
   elseif (feed and pre(pressurizing)) then
     pressurizing = false ; feeding = true ; purging = false ; blowing = false; 
   elseif (bdown and pre(feeding) ) then
     pressurizing = false ; feeding = false ; purging = false ; blowing = true ; 
   elseif (purge and pre(blowing) ) then
     pressurizing = false ; feeding = false ; purging = true ; blowing = false ; 
   else
     pressurizing = pre(pressurizing) ; 
     feeding = pre(feeding) ; purging = pre(purging) ; blowing = pre(blowing) ; 
   end if;
end when;
 
  initial equation
  pcount = 0 ; pucount = 0 ; fcount = 0 ; bcount = 0 ; tics = 0 ;
//  pressurizing = false ; feeding = false ; purging = true;
  pressurize = false ; feed = false ; purge = true ; bdown = false ;
  
end seqSkarstrom;
