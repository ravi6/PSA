## Usage: ##  prof(Bed="A", js=20, N=6, resfile="work/plant_res.mat")
##      Plots Adsborber bed profiles at specified sample points "js"
## Note:
##     N - Collocation Points
##     The mat file should have been created using csv2mat file
##     It is not the native mat file that omc produces
##
## Author: Ravi Sankar Saripalli
##
function  prof(Bed="A", js=20, N=6, resfile="work/plant_res.mat")

load(resfile);

h3=figure ; h2=figure ; h4=figure;
h1 = figure ; 
colors=['r' 'g' 'b' 'm' 'c'] ;c=0;


for j = js(1:end)
c = c + 1 ;

time=s.time(j);

for i=1:N
  zs(i)=eval(sprintf("s.bed%s_adsbr_zs_%d",Bed,i))(3);
end

for i=1:N   %Store data of each coef or collocation point value  column wise
   tyCoef(:,i)=eval(sprintf("s.bed%s_adsbr_Coef_y_%d_1",Bed,i));
   tQCoef(:,i)=eval(sprintf("s.bed%s_adsbr_Coef_Q_%d_1",Bed,i));
   tuCoef(:,i)=eval(sprintf("s.bed%s_adsbr_Coef_u_%d",Bed,i));
   tpCoef(:,i)=eval(sprintf("s.bed%s_adsbr_Coef_p_%d",Bed,i));

   tu(:,i)=eval(sprintf("s.bed%s_adsbr_u_%d",Bed,i));
   tp(:,i)=eval(sprintf("s.bed%s_adsbr_p_%d",Bed,i));
   ty(:,i)=eval(sprintf("s.bed%s_adsbr_y_%d_1",Bed,i));
   tQ(:,i)=eval(sprintf("s.bed%s_adsbr_Q_%d_1",Bed,i));
end

  xp = [0:0.02:1] ;

  legend=sprintf("-%s;t=%i;",colors(c),time);
  figure(h3) ; yp = polyfunc(tpCoef(j,:),xp); hold on;
               plot(xp,yp,legend); ylabel("p");xlabel("z"); grid on;
	       plot(zs,tp(j,:),'o');

  figure(h4) ; yp = polyfunc(tQCoef(j,:),xp); hold on;
               plot(xp,yp,legend); ylabel("Q_N2");xlabel("z"); grid on;
	       plot(zs,tQ(j,:),'o');

  figure(h2) ; yp = polyfunc(tuCoef(j,:),xp); hold on; 
               plot(xp,yp,legend); ylabel("u");xlabel("z"); grid on;
	       plot(zs,tu(j,:),'o');

  figure(h1) ; yp = polyfunc(tyCoef(j,:),xp); hold on;  
               plot(xp,(1.-yp)*100,legend);ylabel("%o2");xlabel("z"); grid on;
	       plot(zs,(1-ty(j,:))*100,'o');

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
