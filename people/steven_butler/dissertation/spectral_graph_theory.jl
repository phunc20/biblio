### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ e60686d0-2f08-11ec-3013-6d58c09efb0b
md"""
## Adjacency Matrix
On p.2, Mr. Butler mentioned that relabeling the vertice indices changes the adjacency matrix but the eigenvalues remain the same. Let's explain this in clearer details by ourselves.

Let ``A`` be an adjacency matrix of some graph ``G``. This means that we have decided a labeling of the vertices, i.e. we have decided IDs ``1, 2, 3, \ldots, n`` to the ``n`` vertices of ``G``. A relabeling of the vertices means choosing a permutation ``\xi: \{1, 2, 3, \ldots, n\} \to \{1, 2, 3, \ldots, n\}``. This gives a corresponding adjacency matrix ``B``. And we would naturally like to know the relationship btw ``A`` and ``B``, which might help us explain why their eigenvalues should be the same. Below is an example where ``n = 3``.

$$\begin{array}{ |c|c|c|c| } \hline & \xi(1) & \xi(2) & \xi{}(3) \\ \hline \xi(1) & & & \\ \hline \xi(2) & & & \\ \hline \xi(3) & & & \\ \hline \end{array}$$

If we sit down and think, then this is actually not too hard
> - Permuting columns of ``A`` corresponds to permuting the their columns IDs
> - Similarly, the same goes for permuting rows
> - ``B`` can be obtained from ``A`` by first permuting the columns then permuting the rows, i.e. ``\exists \;\text{permutation matrix}\; P\; \text{s.t.}\; B = PAP^{T}``

Now, let ``Ax = \lambda x``, where ``x \ne 0``. Since ``P^{T} = P^{-1}``, we have
```math
B(Px) = (PAP^{T})(Px) = \lambda (Px).
```
That is, ``\lambda`` is an eigenvalue of both ``A`` and ``B`` (with eigenvectors ``x`` and ``Px``, resp.)
"""

# ╔═╡ Cell order:
# ╟─e60686d0-2f08-11ec-3013-6d58c09efb0b
