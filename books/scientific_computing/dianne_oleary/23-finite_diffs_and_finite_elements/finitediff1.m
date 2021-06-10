function [A,g,xmesh,ucomp] = finitediff1(M,a,c,f)

x = linspace(0,1,M);
h = x(2);

h2inv = 1/h^2;
n = M - 2;

xmesh = x(2:n+1)';

[a0,ap] = feval(a,xmesh);
adiff = a0*h2inv;
bdiff = ap/h;
cdiff = feval(c,xmesh);
rhs   = feval(f,xmesh);

adiffu = [0;adiff(1:n-1)];
bdiffl = [bdiff(2:n);0];
adiffl = [adiff(2:n);0];
A = spdiags([-adiffl+bdiffl,2*adiff - bdiff + cdiff,-adiffu],-1:1,n,n);
g = rhs;

ucomp = A \ g;
