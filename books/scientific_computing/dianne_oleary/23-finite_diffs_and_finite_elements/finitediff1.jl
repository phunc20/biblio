function finitediff1(M, a, c, f)
  """
  `a, c, f` are functions whose input is a vector and output is a vector.
  Accurately speaking, `a` returns two vectors, the first one `a` itself,
  the second one its derivative.

  """
  t = 0:1/(M-1):1  # This cuts [0, 1] into `M-1` pieces
  h = t[2]         # same as h = 1 / (M-1) but save the work to recompute
  h2inv = 1 / h^2
  n = M - 2
  tmesh = t[1:end-1]
  a0, a1 = a(tmesh)

end








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
% N.B. It seems that Matlab/Octave requires the sub/sup-diagnol vector input
% be of the same length as the diagonal vector (by padding a correct number of zeros)
A = spdiags([-adiffl+bdiffl,2*adiff - bdiff + cdiff,-adiffu],-1:1,n,n);
g = rhs;

ucomp = A \ g;             % `ucomp` means the computed solution `u`
