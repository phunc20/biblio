### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# ╔═╡ 2406025a-e210-11eb-17a7-c5f958f87b5d
begin
  using Pkg
  Pkg.activate("../../../../.julia_env/oft")
  using PlutoUI
  #using Plots
  #using LinearAlgebra
  #using TikzPictures
  #using LaTeXStrings
  #using SparseArrays
  #using Profile
  #using BenchmarkTools
  #using QuadGK
  #using Flux
  #using Zygote: @adjoint
end

# ╔═╡ da4cb1b0-e210-11eb-1404-9b2567aba05a
md"""
### 2.2.1 Points and Lines
A line in ``\mathbb{R}^2`` can be expressed algebraically as
```math
\newcommand{\k}{\begin{pmatrix} 0 \\ 0 \\ 1 \end{pmatrix}}
ax + by + c = 0
```

An idea is to identify the lines in ``\mathbb{R}^2`` to points
$\begin{pmatrix}
  a \\
  b \\
  c
\end{pmatrix} \in \mathbb{R}^3\,.$

The following observations may aid us towards forming this identification.

- The equation ``kax + kby + kc = 0`` represents the same line as
  ``ax + by + c = 0`` for all ``k \ne 0\,.``
- We don't have a line with ``a = b = c = 0``

This leads us to define a new space ``\mathbb{P}^2`` as the set of equivalence classes on
$\mathbb{R}^3 -
\left\{
\begin{pmatrix}
  0 \\
  0 \\
  0
\end{pmatrix}
\right\}\,,$ with the equivalence relation

```math
\begin{pmatrix}
  a \\
  b \\
  c
\end{pmatrix} \sim
\begin{pmatrix}
  a' \\
  b' \\
  c'
\end{pmatrix} \iff \exists\; k \ne 0 \in \mathbb{R}\; \text{s.t.}
\begin{pmatrix}
  a \\
  b \\
  c
\end{pmatrix} = k
\begin{pmatrix}
  a' \\
  b' \\
  c'
\end{pmatrix} \in \mathbb{R}^3\,.
```

> We shall identify lines in ``\mathbb{R}^2`` to elements in ``\mathbb{P}^2\,.``

"""

# ╔═╡ 960abece-e211-11eb-0e15-3178f1f63634
md"""
**Rmk.** $(HTML("<br>"))

In fact, we have lied when saying that lines in ``\mathbb{R}^2`` map one-to-one
to elements in ``\mathbb{P}^2\,.``
Indeed, the element
$\overline{\k} \in \mathbb{P}^2$
does not correspond to any line in ``\mathbb{R}^2\,.`` (From now on, we will omit the equivalence class symbol for elements in ``\mathbb{P}^2`` and simply use any member to mean its equivalence class.)

We have not defined ``\mathbb{P}^2`` wrongly. For the moment, just bare with it. We
will come back to this again soon, to explain why we include ``\k`` in ``\mathbb{P}^2\,.``
"""

# ╔═╡ bd252a86-e221-11eb-264a-3d84f2bb2ae3
md"""
From the general equation for lines in ``\mathbb{R}^2``
```math
ax + by + c = 0\,,
```
we see that

```math
\begin{pmatrix}
  a & b & c
\end{pmatrix}
\begin{pmatrix}
  x \\
  y \\
  1
\end{pmatrix} = 0\,.
```

Someone conceived the idea to identify points in ``\mathbb{R}^2`` to elements of ``\mathbb{P}^2`` as well. We observe that
```math
\begin{pmatrix}
  a & b & c
\end{pmatrix}
\begin{pmatrix}
  x \\
  y \\
  1
\end{pmatrix} = 0 \iff

\begin{pmatrix}
  a & b & c
\end{pmatrix}
\begin{pmatrix}
  kx \\
  ky \\
  k
\end{pmatrix} = 0 \quad\forall\; k \ne 0\,.
```

> So it's natural to identify the points in ``\mathbb{R}^2`` to the subset of
> ``\mathbb{P}^2``:
> ```math
> \left\{\left.\begin{pmatrix}
> x \\ y \\ z
> \end{pmatrix} \in \mathbb{P}^2\, \right|\, z \ne 0 \right\}
> ```

"""

# ╔═╡ c6fb7676-e226-11eb-22ac-f51e4745916d
md"""
An immediate result from the above discussion is

**Result 2.1** ``\quad`` A point $\begin{pmatrix} x_{0} \\ y_{0} \end{pmatrix} \in \mathbb{R}^2$ lies on a line
of equation ``ax + by + c = 0`` if and only if
```math
\newcommand{\inner}[2]{\langle{#1},{#2}\rangle}
\inner{\mathbf{x}}{\mathbf{l}} = \mathbf{x}^T \mathbf{l} = 0\,,
```
where ``\mathbf{x}`` and ``\mathbf{l}`` denote the point and the line in ``\mathbb{P}^2\,,`` respectively.
"""

# ╔═╡ 5ce11c40-e227-11eb-15a4-f52a9641c8fa
md"""
**Proof.**

``(\hskip -0.5em\implies\hskip -0.5em)`` Write
```math
\mathbf{x} = \begin{pmatrix}
  p x_{0} \\
  p y_{0} \\
  p
\end{pmatrix},\quad

\mathbf{l} = \begin{pmatrix}
  q a \\
  q b \\
  q c
\end{pmatrix}\,,
```
where ``\; p, q \ne 0\;`` in ``\;\mathbb{R}\,.``

Then
```math
\mathbf{x}^{T} \mathbf{l} = pq(ax_{0} + by_{0} + c) = 0\,.
```


``(\hskip -0.15em\Longleftarrow\hskip -0.15em)`` Let
```math
\mathbf{x} = \begin{pmatrix}
  x_{0} \\
  y_{0} \\
  1
\end{pmatrix},\quad

\mathbf{l} = \begin{pmatrix}
  a' \\
  b' \\
  c'
\end{pmatrix}
```
be elements of ``\mathbb{P}^2`` s.t.
```math
  \mathbf{x}^{T} \mathbf{l} = a' x_{0} + b' y_{0} + c' = 0\,.
```
We see that the 2D point ``\begin{pmatrix}x_{0} \\ y_{0}\end{pmatrix}`` corresponding
to ``\mathbf{x}`` indeed lies on the line ``a' x + b' y + c' = 0``
corresponding to ``\mathbf{l}\,.``
"""


# ╔═╡ 6ab16524-e22b-11eb-19a5-8fd99cd45861
md"""
If one remembers that
> the cross product of two vectors in ``\mathbb{R}^3`` is
> a third vector perpendicular to both of the first two vectors,
then the following result appears natural.

**Result 2.2** ``\quad``The intersection of two lines ``\mathbf{l}`` and ``\mathbf{l}'`` is the point
``\mathbf{x} = \mathbf{l} \times \mathbf{l}'``
"""


# ╔═╡ 924462ac-e22c-11eb-3f6a-238e34decf23
md"""
**Proof.**

Define ``\mathbf{x} = \mathbf{l} \times \mathbf{l}'.`` If luckily
``\mathbf{x} \in \mathbb{R}^3`` has a **non-zero** third component
(in particular, ``\mathbf{x} \ne \mathbf{0} \in \mathbb{R}^3\,``),
then, by **Result 2.1**, we see that
``\begin{pmatrix} x_{0}\\ y_{0}\end{pmatrix}``
lies on the lines ``\mathbf{l}, \mathbf{l}'``, where
```math
\begin{pmatrix} x_{0}\\ y_{0} \\ 1\end{pmatrix} = \mathbf{x} \in \mathbb{P}^2\,.
```

So we turn to show that$(HTML("<br>"))
> the representations of ``\mathbf{l}`` and of ``\mathbf{l}'`` in ``\mathbb{R}^2`` are non parallel ``\iff`` ``\mathbf{l} \times \mathbf{l}'`` does not have a vanishing third component.

Write
```math
\mathbf{l} = \begin{pmatrix}
  pa \\
  pb \\
  pc
\end{pmatrix},\quad

\mathbf{l}' = \begin{pmatrix}
  qa' \\
  qb' \\
  qc'
\end{pmatrix}, \quad p, q \ne 0 \in \mathbb{R}\,.
```
The third component of ``\mathbf{l} \times \mathbf{l}'`` equals
```math
\det \begin{pmatrix}
  pa & pb \\
  qa' & qb'
\end{pmatrix} =
pq\det \begin{pmatrix}
  a & b \\
  a' & b'
\end{pmatrix}.
```

Recall that the equations for the two lines in ``\mathbb{R}^2`` are
```math
\begin{align}
  \mathbf{l}&: \quad ax + by + c = 0 \,,\\
  \mathbf{l}'&: \quad a'x + b'y + c' = 0\,.
\end{align}
```

``\mathbf{l}, \mathbf{l}'`` being non parallel
``\iff \begin{pmatrix} a \\ b \end{pmatrix}`` and
``\begin{pmatrix} a' \\ b' \end{pmatrix}`` linearly independant
$\iff \det \begin{pmatrix}
  a & b \\
  a' & b'
\end{pmatrix} \ne 0\,.$

"""

# ╔═╡ 7c145dc6-e235-11eb-0b38-6faeb1806857
md"""
**Example 2.3 (modified)** ``\quad``Use **Result 2.2** to find the intersection of
the lines ``2x = 1`` and ``3y = 1\,.``

The corresponding lines in ``\mathbb{P}^2`` are
```math
\mathbf{l} = \begin{pmatrix}
  2 \\
  0 \\
  -1
\end{pmatrix},\,
\mathbf{l}' = \begin{pmatrix}
  0 \\
  3 \\
  -1
\end{pmatrix}.
```

```math
\mathbf{x} = \mathbf{l} \times \mathbf{l}' = \begin{vmatrix}
  \mathbf{i} & \mathbf{j} & \mathbf{k} \\
  2          & 0          & -1         \\
  0          & 3          & -1
\end{vmatrix} =
\begin{pmatrix}
  3 \\
  2 \\
  6
\end{pmatrix} \overset{\mathbb{P}^2}{=}
\begin{pmatrix}
  \frac{1}{2} \\
  \frac{1}{3} \\
  1
\end{pmatrix}.
```
"""

# ╔═╡ 5c13802c-e237-11eb-2bc6-a597fa592642
md"""
We have the following analogous result

**Result 2.4** ``\quad``The line through two points ``\mathbf{x}`` and ``\mathbf{x}'``
is ``\mathbf{l} = \mathbf{x} \times \mathbf{x}'\,.``

"""

# ╔═╡ cbd32d68-e237-11eb-1c6c-4db6c0024807
md"""
**Proof.**

Let's first see what happens when ``\mathbf{x}' = \mathbf{x}\,.``
In this case, ``\mathbf{l} = \mathbf{0} \in \mathbb{R}^3\,,`` which is
not a valid line in ``\mathbb{P}^2\,.`` Therefore, this result cannot apply to
the case when ``\mathbf{x}' = \mathbf{x}\,.``

Next, we explore the case ``\mathbf{x}' \ne \mathbf{x}\,.``
We must show that ``\mathbf{l}`` in this case is a valid line in ``\mathbb{P}^2\,.``

Note that since ``\mathbf{x}`` and ``\mathbf{x}'`` are points in ``\mathbb{P}^2\,,``
they have representations
```math
\mathbf{x} = \begin{pmatrix}
  x_{1} \\
  y_{1} \\
  1
\end{pmatrix},\;
\mathbf{x}' = \begin{pmatrix}
  x_{2} \\
  y_{2} \\
  1
\end{pmatrix}.
```
``\mathbf{x}' \ne \mathbf{x}`` simply means that the above two vectors are linearly independant.

Now,
```math
\mathbf{l} = \mathbf{x} \times \mathbf{x}' =
\begin{vmatrix}
  \mathbf{i} & \mathbf{j} & \mathbf{k} \\
  x_{1} & y_{1} & 1 \\
  x_{2} & y_{2} & 1 \\
\end{vmatrix} =
\begin{pmatrix}
  y_{1} - y_{2} \\
  x_{2} - x_{1} \\
  x_{1}y_{2} - x_{2}y_{1}
\end{pmatrix}.
```

One thing we can be sure of

> One of the first and the second components is non-zero (because otherwise the two vectors would have been linearly dependant).

So we see that ``\mathbf{l}`` is a valid line of ``\mathbb{P}^2`` and it goes through
both ``\mathbf{x}`` and ``\mathbf{x}'\,.``

"""

# ╔═╡ 28ccccd8-e23b-11eb-2518-dfebd5163334
md"""
### 2.2.2 Points at Infinity and Line at Infinity
Note that so far in our discussion

- the correspondances in ``\mathbb{P}^2`` of all the **_lines_** in ``\mathbb{R}^2`` constitute a **_proper subset_** of ``\mathbb{P}^2``
  - The line ``\begin{pmatrix} 0 \\ 0 \\ 1 \end{pmatrix}`` corresponds to no line in ``\mathbb{R}^2``
- the correspondances in ``\mathbb{P}^2`` of all the **_points_** in ``\mathbb{R}^2`` constitute a **_proper subset_** of ``\mathbb{P}^2``
  - The points ``\begin{pmatrix} x \\ y \\ 0 \end{pmatrix}`` (with ``xy \ne 0``) corresponds to no point in ``\mathbb{R}^2``

> There is actually a unifying viewpoint to remedy this.

Recall that in our discussion of the intersection of two lines
``\mathbf{l}, \mathbf{l}'`` from ``\mathbb{P}^2``,
we excluded the case in which ``\mathbf{l}, \mathbf{l}'`` are parallel _sous prétexte
que_ that was an uninteresting case.

However, note that if we would like to forcifully carry out a similar computation
in the parallel case, we still could.

Indeed, assume that
```math
\mathbf{l} = \begin{pmatrix}
  a \\
  b \\
  c
\end{pmatrix},\;
\mathbf{l}' = \begin{pmatrix}
  a' \\
  b' \\
  c'
\end{pmatrix},

```
where ``ab \ne 0`` and ``a'b' \ne 0\,,`` are two parallel lines.$(HTML("<br>"))
Parallelism here simply means that ``\exists\; k \ne 0`` in ``\mathbb{R}`` s.t.
```math
\begin{pmatrix}
  a' \\
  b' \\
\end{pmatrix} = k
\begin{pmatrix}
  a \\
  b \\
\end{pmatrix}.
```
Now,
```math
\mathbf{l} \times \mathbf{l}' =
\begin{vmatrix}
  \mathbf{i} & \mathbf{j} & \mathbf{k} \\
  a & b & c \\
  a' & b' & c'
\end{vmatrix} =
\begin{pmatrix}
  bc' - b'c \\
  a'c - ac' \\
  0
\end{pmatrix} =
\begin{pmatrix}
  bc' - kbc \\
  kac - ac' \\
  0
\end{pmatrix} = 
\begin{pmatrix}
  b(c' - kc) \\
  a(kc - c') \\
  0
\end{pmatrix}.
```

We see that

- if ``c' = kc`` then ``\mathbf{l} \times \mathbf{l}' = \begin{pmatrix} 0 \\ 0 \\ 0 \end{pmatrix} \notin \mathbb{P}^2``
  (uninteresting case)
- if ``c' \ne kc`` then ``\mathbf{l} \times \mathbf{l}' \in \mathbb{P}^2``
  because one of the first and the second components is non-zero
  (interesting case)

But ``c' = kc \iff \mathbf{l}' = \mathbf{l}\,.`` In other words,
> If ``\mathbf{l}, \mathbf{l}'`` are two parallel, distinct lines
> in ``\mathbb{P}^2``, then ``\mathbf{l} \times \mathbf{l}'`` is an element
> in ``\mathbb{P}^2`` s.t.
>
> - its third component equals zero
> - one of its first and second components is non-zero

We call such points in ``\mathbb{P}^2`` **_points at infinity_** (or **_ideal points_**). That is, the set of points at infinity of ``\mathbb{P}^2`` is
```math
\left\{
\left.
\begin{pmatrix}
  x \\
  y \\
  0
\end{pmatrix} \in \mathbb{P}^2
\;\right|\;
x \ne 0 \;\text{or}\; y \ne 0
\right\}.
```

Note that $\begin{pmatrix}
  x \\
  y \\
  0
\end{pmatrix}$ and $\begin{pmatrix}
  kx \\
  ky \\
  0
\end{pmatrix}$ are identical point (at infinity) for all ``k \ne 0\,.``

"""

# ╔═╡ Cell order:
# ╟─2406025a-e210-11eb-17a7-c5f958f87b5d
# ╟─da4cb1b0-e210-11eb-1404-9b2567aba05a
# ╟─960abece-e211-11eb-0e15-3178f1f63634
# ╟─bd252a86-e221-11eb-264a-3d84f2bb2ae3
# ╟─c6fb7676-e226-11eb-22ac-f51e4745916d
# ╟─5ce11c40-e227-11eb-15a4-f52a9641c8fa
# ╟─6ab16524-e22b-11eb-19a5-8fd99cd45861
# ╟─924462ac-e22c-11eb-3f6a-238e34decf23
# ╟─7c145dc6-e235-11eb-0b38-6faeb1806857
# ╟─5c13802c-e237-11eb-2bc6-a597fa592642
# ╟─cbd32d68-e237-11eb-1c6c-4db6c0024807
# ╟─28ccccd8-e23b-11eb-2518-dfebd5163334
