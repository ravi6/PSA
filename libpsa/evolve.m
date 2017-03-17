## Usage: ##  evolve(Bed="A", N=6, delatyT=12, NStart = 1, resfile="work/plant_res.mat")
##      Animated O2 profile evolution in Adsorber bed with time
## Note:
##     N - Collocation Points
##     The mat file should have been created using csv2mat file
##     It is not the native mat file that omc produces
##
## Author: Ravi Sankar Saripalli
##
function  evolve(Bed="A", N=6, delayT=12, NStart=1, resfile="work/plant_res.mat")

load(resfile);



hpic = figure('position',[189    185   1350   1065]);
imshow("libpsa/anim/press.jpg"); 

h_u = figure('position',[28 318 560 420]);
ylabel("u"); grid on ;
xlim([0 1]) ; ylim([-5 5]); xlabel("z"); 

h_y = figure('position',[1036 56 560 420]);
ylabel("%o2"); grid on ;
xlim([0 1]) ; ylim([0 100]); xlabel("z"); 



colors=['r' 'g' 'b' 'm' 'c'] ;
xp = [0:0.02:1] ;

   purginig=eval(sprintf("s.bed%s_seq_purging",Bed));
   blowing=eval(sprintf("s.bed%s_seq_blowing",Bed));
   pressurizing=eval(sprintf("s.bed%s_seq_pressurizing",Bed));
   feeding=eval(sprintf("s.bed%s_seq_feeding",Bed));

NP = size(s.time,1);

for j = NStart:NP

time=s.time(j);

for i=1:N   %Store data of each coef or collocation point value  column wise
   tyCoef(:,i)=eval(sprintf("s.bed%s_adsbr_Coef_y_%d_1",Bed,i));
   tuCoef(:,i)=eval(sprintf("s.bed%s_adsbr_Coef_u_%d",Bed,i));
end
 
  if (feeding(j)) 
      c = 'g' ;
      str = "feeding"; pic = "libpsa/anim/feed.jpg";
  elseif (pressurizing(j))
      c = 'r' ; pic = "libpsa/anim/press.jpg";
      str = "pressurizing" ;
  elseif (blowing(j))
      str = "venting" ; pic = "libpsa/anim/vent.jpg";
      c = 'b' ;
  else
      c = 'm' ;
      str = "purging" ; pic = "libpsa/anim/purge.jpg";
  end 

  figure(h_y);
  legend=sprintf("-%s;%d sec - %s;",c,time, str);
  yp = polyfunc(tyCoef(j,:),xp); 
  hold on;  plot(xp,(1.-yp)*100,legend); grid on ;

  figure(h_u);
  legend=sprintf("-%s;%d sec - %s;",c,time, str);
  yp = polyfunc(tuCoef(j,:),xp); 
  hold on;  plot(xp,yp,legend); grid on ;

  figure(hpic) ; imshow(pic) ; 
  usleep(delayT*16e3);

  figure(h_y) ;delete(findobj("type","line"));
  figure(h_u) ;delete(findobj("type","line"));
end  %  all times

end

%===============================
function ans = polyfunc(coefs,x)
%===============================
% evaluate collacation function at some sample points
  

   Nc = size(coefs,2) ; Np = size(x,2) ;
   for m = 1:Np
       yc(m) = 0 ;
       for j = 1 : Nc
         %  yc(m) = yc(m) + coefs(j) * chebyshevpoly(1,j-1,2*x(m)-1) ;
           yc(m) = yc(m) + coefs(j) * sCheby(j-1,x(m)) ;
       end
          % yc(m) =  sum(coefs .* sT(Nc,x(m))) ;
   end
   ans = yc ;
end

%===============================
function ans = sCheby(n, x)
%===============================
    ans = cos(n * acos(2*x-1)) ;
end

%===============================
function ans = asort(a)
%===============================
 ans =  [ a(end) a(1:end-2) a(end-1) ];
end

%===============================
function y = T(n,x)
%===============================
% Retruns a vector of Chebychev polynomial value from
%    degree 0 to n-1 a given x    -1<x<1

           y(1) = 1;   y(2) =  x;

           for k = 2:n-1 
              y(k+1) = 2 * x * y(k) - y(k-1);
           end 
end 

%===============================
function  y = sT(n,x)
%===============================
% Retruns a vector of shifted Chebychev polynomial value from
%    degree 0 to n-1 a given x    0<x<1
%
           y = T(n, (2 * x - 1)) ;     % Reuse of unshifted function
end 
