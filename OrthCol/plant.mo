model plant

import Chebychev.* ;

/* My first stab at implementing Orthogonal Collocation
       in OpenModelica Language ...
    Using shifted domain  0<x<1   

   This code should serve as a guide to implement this 
     method to solve more complex P.D.E's
                  Author: R. Saripalli
                  Date:   151515151515151515151515151515th March 2015 
*/

constant Integer N = 10 ;
constant Integer M = 50 ;   // sample size for post processing

// Chebychev package functions used to get all the data needed for collocation
//    We now work in shifted domain 0<x<1 

constant Real [:] xi =  sTnots(N-2)     ;  // Interior Collocation Points

constant Real [:] x  = cat(1, xi, {0, 1}) ;  // Including boundaries
constant Real [:,:] vT  =  sT(N, x)    ;  // Cheby values (index j) at x (index i)
constant Real [:,:] vTx  = sTx(N, x)   ;  // first deriv Cheby values (index j) at x (index i)
constant Real [:,:] vTxx = sTxx(N, x)   ;  // second deriv Cheby values (index j) at x (index i)

Real [M] xs ;       // Solution point vector
Real [M] u ;       // Solution Vector at Collocation points
Real [M] v ;       // Exact Solution Vector at Collocation points
Real [N] Coef ;    // Coeffs. of collocation

equation

 // eqn.    uxx - 4 * ((2x-1)^6 + 3(2x-1)^2) u = 0 ; with  b.c u(0)=u(1)=0
//         Exact Solution  exp(((2x-1)^4-1)/4)
 //       let   u =  sum(Coef[i].T[i])   be the trial solution

     for i in 1:N-2 loop
          Coef * ( vTxx[i, 1:N]  - vT[i, 1:N]  * (  4 *  (2 * x[i] - 1)^6 + 
                                                    12 *  (2 * x[i] - 1)^2 
                                                 )) = 0   ;
     end for;
         Coef * vT[N-1, 1:N]  = 1 ;  //  b.c 's
         Coef * vT[N, 1:N]  = 1 ;
 
    algorithm  // this recovers u from the Coef's determined earlier
     xs := linspace(0, 1.0, M) ;
     u  := sT(N, xs) * Coef   ;  // be careful order of multiplication is important
     v  := exp( ( (2 * xs .- 1).^4 .- 1 ) ./ 4 );  // Analytic Solution solution
end plant;
