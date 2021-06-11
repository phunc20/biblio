### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ ffe1050f-57ed-4836-8bef-155a2ed17fbd
begin
  using Pkg
  Pkg.activate(Base.Filesystem.homedir() * "/.config/julia/projects/oft")
  using Plots
  using PlutoUI
  using TikzPictures
  using LaTeXStrings
end

# ╔═╡ 843498a2-c9c8-11eb-31a4-fb7bd7be2a89
md"""
Dans ce chapitre, on se concentre sur la résolution d'une EDO qui a forme

```math
-(a(t)u'(t))' - c(t)u(t) = f(t),\; t \in (0, 1),\; \text{où}
```

les fonction $a, c, f: [0,1] \to \mathbb{R}$ sont connue et que l'on veut
résoudre $u: [0,1] \to \mathbb{R}$ avec $u(0) = u(1) = 0\,.$

En plus, on suppose qu'il existe une constante $\,a_0 > 0\,$ telle que $\,a(t) > a_0\,$ et que $\,c(t) \ge 0\,$
pour tout $\,t \in [0,1]\,.$

"""

# ╔═╡ 3fb86eda-11a9-46e0-b4fc-cf9660f5765c
md"""
**(?)** How to type the two diff $a$'s in $LaTeX$?
"""

# ╔═╡ 5c17ad87-dc9f-4cb4-80f5-8717626cfcb3
let
  morceaux = TikzPicture(
    L"""
    \def\d{0.8}
    \def\L{10}
    \draw[orange, ultra thick] (0,0) -- (\L,0);
    \draw[purple, ultra thick] (0,-0.2) -- (0,0.2) node [anchor=south] {$\frac{0}{M-1}$};
    \draw[purple, ultra thick] (\d,-0.2) -- (\d,0.2) node [anchor=south] {$\frac{1}{M-1}$};
    \draw[purple, ultra thick] (2*\d,-0.2) -- (2*\d,0.2) node [anchor=south] {$\frac{2}{M-1}$};
    \draw[purple, ultra thick] (\L/2,-0.2) -- (\L/2,0.2) node [anchor=south] {$\cdots$};
    %node (\L/2,0.2) [anchor=south] {$\cdots$};
    \draw[purple, ultra thick] (\L,-0.2) -- (\L,0.2) node [anchor=south] {$\frac{M-1}{M-1}$};
    \draw[purple, ultra thick] (\L-\d,-0.2) -- (\L-\d,0.2) node [anchor=south] {$\frac{M-2}{M-1}$};
    """,
    options="scale=1.5",
    preamble="",
  )
  md"""
  ## Différence Finie
  Nous avons les approximations suivantes
  
  ```math
  \begin{align}
    u'(t) &= \frac{u(t) - u(t-h)}{h} + o(h)\,, \\
    u''(t) &= \frac{u(t-h) - 2u(t) + u(t+h)}{h^2} + o(h^2)\,.
  \end{align}
  ```
  
  Et on introduit quelques notations.
  
  - D'abord, on va diviser l'intervalle $[0,1]$ en $M-1$ morceaux, comme dans la figure ci-dessous. La longueur de chaque morceau est égale à $\;h = \frac{1}{M-1}\,.$ $(morceaux)
  - Puis on pose
    - ``t_j = jh\;`` où ``\;j = 0, 1, 2, \ldots, M-1``
    - ``u_j = u(t_j)``
    - ``f_j = f(t_j)\,,`` etc.
  """
end

# ╔═╡ c8275327-f599-4252-beb1-7227f5c5f7ba
md"""
### CHALLENGE 23.1.
Déduisez une équation la plus simple possible que vous arrivez à la rendre, à partir de
```math
M = 6,\, a(t) = 1,\, c(t) = 0\,.
```
"""

# ╔═╡ 091202a8-9921-49ba-8877-d5e9c9593356
md"""
**(?)** How to convert the whole markdown string to some, say, red, color?
"""

# ╔═╡ b9fac562-a00c-489d-91a6-f25ad4348940
md"""
### Solution 23.1.
L'équation se simplifie comme
```math
- u''(t) = f(t) \,\text{ sur }\, (0, 1)\,.
```

Si l'on substitue l'approximation par différences finies aux dérivées ci-dessus, on aura
```math
- \frac{u(t-h) - 2u(t) + u(t+h)}{h^2} \approx f(t) \,\text{ sur }\, (0, 1)\,.
```

En réécrivant cette équation pour chacun entre $t_{1}, t_{2}, t_{3}, \ldots, t_{M-2}\,,$ on obtient
```math
\begin{align}
  - (u_{0} - 2u_{1} + u_{2}) &= h^2 f_{1}            \\
  - (u_{1} - 2u_{2} + u_{3}) &= h^2 f_{2}            \\
                             &\cdots                 \\
  - (u_{M-1} - 2u_{M-2} + u_{M-1}) &= h^2 f_{M-2}\,. \\
\end{align}
```

En écriture matricielle, cela donne
```math
- \underbrace{\begin{pmatrix}
  1 & -2 &  1 &  0 & 0 & 0 & \cdots & 0 \\
  0 &  1 & -2 &  1 & 0 & 0 & \cdots & 0 \\
  0 &  0 &  1 & -2 & 1 & 0 & \cdots & 0 \\
  \vdots &&   & \ddots  &   &   &        & \vdots \\
  0 &    & \cdots& & 0 & 1 &   -2   & 1 \\
\end{pmatrix}}_{\text{de taille } (M-2,\, M)}
\begin{pmatrix}
  u_{0} \\
  u_{1} \\
  u_{2} \\
  \vdots \\
  u_{M-1} \\
\end{pmatrix} = h^2
\begin{pmatrix}
  f_{1} \\
  f_{2} \\
  \vdots \\
  f_{M-2} \\
\end{pmatrix}\,.
```

Comme nous savons
```math
\begin{align}
  u_{0}   &= u(0) = 0 \\
  u_{M-1} &= u(1) = 0\,,
\end{align}
```
le produit matrice-vecteur ci-dessus peut encore se simplifier comme
```math
\underbrace{\begin{pmatrix}
     2 & -1 &  0 &  0 & 0 & \cdots & 0 \\
    -1 &  2 & -1 &  0 & 0 & \cdots & 0 \\
     0 & -1 &  2 & -1 & 0 & \cdots & 0 \\
    \vdots &&   & \ddots  &   &    & \vdots \\
     0  & \cdots& & 0 & -1 &  2 & -1    \\
     0  & \cdots& & 0 &  0 & -1 &  2    \\
\end{pmatrix}}_{\text{de taille } (M-2,\, M-2)}
\begin{pmatrix}
  u_{1} \\
  u_{2} \\
  \vdots \\
  u_{M-2} \\
\end{pmatrix} = h^2
\begin{pmatrix}
  f_{1} \\
  f_{2} \\
  \vdots \\
  f_{M-2} \\
\end{pmatrix}\,.
```

On remarque que cela a forme ``Au = g\,,`` où ``A`` est une matrice **tridiagonale**.

Au cas particulier où ``M=6\,,`` on a

```math
\begin{pmatrix}
     2 & -1 &  0 &  0 \\
    -1 &  2 & -1 &  0 \\
     0 & -1 &  2 & -1 \\
     0 &  0 & -1 &  2 \\
\end{pmatrix}
\begin{pmatrix}
  u_{1} \\
  u_{2} \\
  u_{3} \\
  u_{4} \\
\end{pmatrix} = \frac{1}{25}
\begin{pmatrix}
  f_{1} \\
  f_{2} \\
  f_{3} \\
  f_{4} \\
\end{pmatrix}\,.
```

"""

# ╔═╡ e97de2ac-1085-4b6c-ac91-2bafc3f3f3b4


# ╔═╡ b529132e-2c1d-4d58-90ca-238fee4f8a93
md"""
### CHALLENGE 23.2.
Le fichier `finitediff1.m` peut se télécharger du site web de l'auteur. Le code Matlab dedans
est **sans faute**, même s'il est un peu difficile à confirmer sa justesse, surtout pour ceux
qui n'utilisent pas souvent Matlab/Octave. (Ces notes sont rédigées en 2021 où les langues les
plus populaires pour faire de la Scientific Computing, ce sont Python et Julia.)

Pour faciliter sa lecture, j'ai ajouté des commentaires dans `finitediff1.m`.

De plus, ce code est d'autant plus difficile parce que, même si l'auteur ne le dit pas,
on traite l'EDO dans sa complétude, non pas comme dans CHALLENGE 23.1 où on simplifie
en prenant $M = 6, a(t) = 1, c(t) = 0\,.$

Mais, en fait, ce n'est pas si difficile que ça. L'équation en sa plus grande généralité donne
cela en différences finies :
```math
\newcommand{\aprimeOverh}[1]{\frac{a'_{#1}}{h}}
\newcommand{\aOverhSquare}[1]{\frac{a_{#1}}{h^2}}
\newcommand{\ldiag}[1]{\aprimeOverh{#1} - \aOverhSquare{#1}}
\newcommand{\diag}[1]{-\aprimeOverh{#1} + 2\aOverhSquare{#1} + c_{#1}}
\newcommand{\udiag}[1]{-\aOverhSquare{#1}}

\begin{align}
  - a'_{j} \frac{u_{j} - u_{j-1}}{h} - a_{j} \frac{u_{j-1} - 2u_j + u_{j+1}}{h^2} + c_j u_j &= f_j\,, \quad\forall\; j = 1, 2, \ldots, M-2 \\

  &\iff \\

  \left(\ldiag{j}\right) u_{j-1} + \left(\diag{j}\right) u_j + \left(\udiag{j}\right) u_{j+1} &= f_j\,, \quad\forall\; j = 1, 2, \ldots, M-2 \\

  &\iff \\
\end{align}
```

```math
  \begin{pmatrix}
     \diag{1} & \udiag{1} &  \bullet  &  \bullet  &        &             &             &             \\
    \ldiag{2} &  \diag{2} & \udiag{1} &  \bullet  &        &             &             &             \\
     \bullet  & \ldiag{3} &  \diag{3} & \udiag{3} &        &             &             &             \\
              &           &           &           & \ddots &             &             &             \\
              &           &           &           &        & \ldiag{M-3} &  \diag{M-3} & \udiag{M-3} \\
              &           &           &           &        &    \bullet  & \ldiag{M-2}  &  \diag{M-2}
  \end{pmatrix}

  \begin{pmatrix}
    u_1 \\
    u_2 \\
    \vdots \\
    u_{M-2}
  \end{pmatrix} =
  \begin{pmatrix}
    f_1 \\
    f_2 \\
    \vdots \\
    f_{M-2}
  \end{pmatrix}
```

**Rmq.** J'utilise le `\bullet` (``\,``i.e. ``\bullet\,``) pour représenter $0$ dans la grande matrice ci-dessus.

"""

# ╔═╡ 12fd4e40-5406-40e8-98af-9ba089bf37e7
md"""
**(?)** Allez voir comment la fonction `spdiags` est implémentée en Matlab/Octave. 
C'est un peu curieux que tous les trois diagonales (`input args`) doivent avoir les mêmes longueurs (padded by zeros for sub/sup-diagonl).
"""

# ╔═╡ 3b5f8e3c-236f-47c4-80ab-63328af079eb
md"""
**(?)** Pourquoi parfois `$(HTML("<br>"))` ne fonctionne pas? Que faire?
"""

# ╔═╡ 3c99b108-aadd-4b6b-8e04-a351e09d7487
md"""
#### `finitediff1.jl`
Ensuite, on va coder `finitediff1.m` en Julia.

En Julia, il n'y a pas de `linspace`. Par contre, on a le remplacement suivant.
"""

# ╔═╡ 6baa7a0c-84ff-4252-a914-efa150e1179c
let
  M = 6
  0:1/(M-1):1
end

# ╔═╡ 4728cfab-d857-4890-9b1e-68941224ee11
md"""
- [`spdigm` (**sparse diagonal matrix**)](https://docs.julialang.org/en/v1/stdlib/SparseArrays/#SparseArrays.spdiagm)
"""

# ╔═╡ Cell order:
# ╠═ffe1050f-57ed-4836-8bef-155a2ed17fbd
# ╠═843498a2-c9c8-11eb-31a4-fb7bd7be2a89
# ╟─3fb86eda-11a9-46e0-b4fc-cf9660f5765c
# ╟─5c17ad87-dc9f-4cb4-80f5-8717626cfcb3
# ╟─c8275327-f599-4252-beb1-7227f5c5f7ba
# ╟─091202a8-9921-49ba-8877-d5e9c9593356
# ╟─b9fac562-a00c-489d-91a6-f25ad4348940
# ╠═e97de2ac-1085-4b6c-ac91-2bafc3f3f3b4
# ╟─b529132e-2c1d-4d58-90ca-238fee4f8a93
# ╟─12fd4e40-5406-40e8-98af-9ba089bf37e7
# ╟─3b5f8e3c-236f-47c4-80ab-63328af079eb
# ╟─3c99b108-aadd-4b6b-8e04-a351e09d7487
# ╠═6baa7a0c-84ff-4252-a914-efa150e1179c
# ╟─4728cfab-d857-4890-9b1e-68941224ee11
