function [A,g,xmesh,ucomp] = finitediff1(M,a,c,f)
% I kind of forget the syntax of Matlab/Octave, but
% [A,g,xmesh,ucomp] seems to be their way of returning multiple outputs.

% `a, c, f` are functions whose input is a vector and output is a vector.
% Accurately speaking, `a` returns two vectors, the first one `a` itself,
% the second one its derivative.
x = linspace(0,1,M);       % This cuts [0, 1] into `M-1` pieces
h = x(2);                  % x(2) equals 1 / (M-1)

h2inv = 1/h^2;             % `h` squared inverse
n = M - 2;

xmesh = x(2:n+1)';         % O'Leary: `tmesh`

[a0,ap] = feval(a,xmesh);  % `feval(a, xmesh)` is the same as `a(xmesh)`
adiff = a0*h2inv;
bdiff = ap/h;
cdiff = feval(c,xmesh);
rhs   = feval(f,xmesh);    % `rhs` stands for "right-hand side"

% Principle:
% ending w/ `diff`:  To be put in the main diagonal
% ending w/ `diffl`: To be put in the lower diagonal
% ending w/ `diffu`: To be put in the upper diagonal
adiffu = [0;adiff(1:n-1)];
bdiffl = [bdiff(2:n);0];
adiffl = [adiff(2:n);0];
A = spdiags([-adiffl+bdiffl,2*adiff - bdiff + cdiff,-adiffu],-1:1,n,n);
g = rhs;

ucomp = A \ g;             % `ucomp` means the computed solution `u`
