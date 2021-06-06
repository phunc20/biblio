function mesh = generateproblem(myproblem,nrefine,kappa)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function mesh = generateproblem(myproblem,nrefine,kappa)
%
% This function generates a series of matrix problems
% from a finite element model.
%
% If myproblem==1, the domain is a square [-1,1] x [-1,1] 
%                  and the mesh is regular.
% If myproblem==2, the domain is the square with a hole, and
%                  the mesh is refined at the hole.
%
% The parameter nrefine determines the number of problems
% to be generated.  The finite element mesh is a set of 
% triangles, and each successive problem has 4 times the 
% number of triangles as the previous one.
% The basis functions are piecewise linear.
%
% The partial differential equation that we model is 
%   -u_{xx} - u_{yy} + kappa u = f in the domain
% with u=0 on the boundary of the square and 
% Neumann boundary conditions on the hole (if myproblem=2).
%
% The function returns a structure called mesh.  
%
% For k=1:nrefine,
%
% mesh(k).A
%          npts x npts sparse matrix.  The linear system 
%          to be solved is  A u = b.
% mesh(k).b
%          npts x 1 vector
% mesh(k).u
%          npts x 1 vector, initialized to 0.
% mesh(k).tol
%          square of length of longest edge among the triangles 
%          in the mesh.
% mesh(k).p 
%          npts x 2, where npts is the number of triangle 
%          vertices.  Each row contains the two coordinates 
%          of a vertex of a triangle in t.
% mesh(k).nip 
%          number of interior vertices in the mesh.
%          (The other vertices are on the boundary of the
%          square.)
% mesh(k).t
%          ntriangles x 3, where ntriangles is the number 
%          of triangles in the mesh.  Each row contains the 
%          indices of its three vertices.
% mesh(k).e
%          nedges x 2, where nedges is the number of edges 
%          in the mesh.  Row i has the indices of the rows 
%          in p containing the two endpoints of edge i.
% mesh(k).te
%          ntriangles x 3.
%          Each row contains the indices of its three edges.
% mesh(k).Prolong
%          (npts for mesh(k)) x (npts for mesh(k-1))
%          This matrix defines the interpolation between 
%          the two sets of vertices.
%
% Dianne P. O'Leary 03/2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k=1:nrefine,

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Data for the first mesh (k=1) are given here.
%  Problem 2 comes from squarehole.mat, generated
%  by the distmesh package of Per-Olof Persson and 
%  Gilbert Strang: SIAM Review 46, 329-345, 2004
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  if (k==1)
     if (myproblem==2)   
        load squarehole  
        mesh(1).tol = .2271^2;
     else                % Problem 1 is specified here.
%              1     2     3     4     5      6     7      8      9
        p = [ 0  0; 1 -1; 1  0; 1 1;  0 -1;  0 1; -1 -1; -1  0; -1 1];
        nip = 1;
        t = [1 2 5; 1 2 3; 1 3 6; 3 4 6; 5 7 8; 1 5 8; 1 8 9; 1 6 9];
        mesh(1).tol = 2;
     end

     [e,te] = findedge(t);
     mesh(1).p = p;
     mesh(1).nip = nip;
     mesh(1).e = e;
     mesh(1).t = t;
     mesh(1).te = te;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Data for later meshes are generated here.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  else
     [mesh(k).p, mesh(k).nip, mesh(k).t, mesh(k).e, ...
      mesh(k).te, mesh(k).Prolong] = ...
       refine(mesh(k-1).p,mesh(k-1).nip,...
              mesh(k-1).t,mesh(k-1).e,mesh(k-1).te);
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Generate the matrix A and right-hand side b from the
%  mesh data. 
%  Set u=0 and tol = squared length of longest edge.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  [mesh(k).A,mesh(k).b] = ...
         formAb(mesh(k).p,mesh(k).t,mesh(k).nip,kappa);
  mesh(k).u = zeros(size(mesh(k).b));
  if (k>1)
     mesh(k).tol = mesh(k-1).tol/4;
  end

end

