function finitediff1(M::Number, a::Function, c::Function, f::Function)
  """
  `a, c, f` are functions whose input is a vector and output is a vector.
  Accurately speaking, `a` returns two vectors, the first one `a` itself,
  the second one its derivative.


  TODO:
  01. Use @view

  """
  t = 0:1/(M-1):1  # This cuts [0, 1] into `M-1` pieces
  h = t[2]         # same as h = 1 / (M-1) but save the work to recompute
  #h2inv = 1 / h^2
  #n = M - 2
  tmesh = t[2:end-1]
  a0_and_a1 = a(tmesh)  # a0: 0th derivative, a1: 1st derivative
  a0 = @view a0_and_a1[1:end, 1]
  a1 = @view a0_and_a1[1:end, 2]
  a1_over_h = a1 ./ h
  a0_over_h² = a0 ./ h^2
  c0 = c.(tmesh)
  #g = f0 = f(tmesh)
  g = f.(tmesh)
  diag = -a1_over_h + 2*a0_over_h² + c0
  ldiag = (a1_over_h - a0_over_h²)[2:end]
  udiag = - @view a0_over_h²[1:end-1]
  A = spdiagm(-1 => ldiag, 0 => diag, 1 => udiag)
  # A * ucomp = g
  ucomp = A \ g
end
