function ans = sCheby(n, x)
    ans = cos(n * acos(2*x-1)) ;
end

function ans = sTi(n)
# Calculate Integral of a shifted Legendre Polynomial
# of degree n

if (mod(n,2) ~= 0 ) 
   ans = 0 ;
else
   ans = 1.0 / (1 - n^2) ;
end
end

for n = 0 : 6
dx = 0.001 ;
x = [0:dx:1];
y = sCheby(n, x) ;

z = 0 ;
for i = 2 : size(x,2)
 z = z + 0.5 * dx * (y(i-1) + y(i));  
end

q(n+1,:) = [n z sTi(n)];
end
q
