### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ ffe1050f-57ed-4836-8bef-155a2ed17fbd
begin
  using Pkg
  #Pkg.activate(Base.Filesystem.homedir() * "/.config/julia/projects/oft")
  Pkg.activate("../../../../.julia_env/oft")
  using Plots
  using PlutoUI
  using LinearAlgebra
  using TikzPictures
  using LaTeXStrings
  using SparseArrays
  #using Profile
  using BenchmarkTools
  using QuadGK
  using Flux
  using Zygote: @adjoint
end

# ╔═╡ 843498a2-c9c8-11eb-31a4-fb7bd7be2a89
md"""
Dans ce chapitre, on se concentre sur la résolution d'une EDO qui a forme

```math
-(a(t)u'(t))' + c(t)u(t) = f(t),\; t \in (0, 1),\; \text{où}
```

les fonction $a, c, f: [0,1] \to \mathbb{R}$ sont connue et que l'on veut
résoudre $u: [0,1] \to \mathbb{R}$ avec $u(0) = u(1) = 0\,.$

En plus, on suppose qu'il existe une constante $\,a_0 > 0\,$ telle que $\,a(t) > a_0\,$ et que $\,c(t) \ge 0\,$
pour tout $\,t \in [0,1]\,.$

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
Déduisez l'équation la plus simple possible que vous arrivez à la rendre, à partir de
```math
M = 6,\, a(t) = 1,\, c(t) = 0\,.
```
"""

# ╔═╡ b9fac562-a00c-489d-91a6-f25ad4348940
md"""
### Solution 23.1.
L'équation se simplifie comme
```math
- u''(t) = f(t) \,\text{ sur }\, (0, 1)\,.
```

Si l'on substitue les approximations par différences finies aux dérivées ci-dessus, on aura
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
    \ldiag{2} &  \diag{2} & \udiag{2} &  \bullet  &        &             &             &             \\
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

# ╔═╡ 3c99b108-aadd-4b6b-8e04-a351e09d7487
md"""
#### `finitediff1.jl`
Ensuite, on va coder `finitediff1.m` en Julia. $(HTML("<br>"))
En Julia, il n'y a pas de `linspace`. Par contre, on a le remplacement `range(0,1;length=M)`.
"""

# ╔═╡ 4728cfab-d857-4890-9b1e-68941224ee11
md"""
Pour construire une matrice tridiagonale, on a le choix parmi

- [`spdigm` (**sparse diagonal matrix**)](https://docs.julialang.org/en/v1/stdlib/SparseArrays/#SparseArrays.spdiagm)
- [`LinearAlgebra.Tridiagonal`](https://docs.julialang.org/en/v1/stdlib/LinearAlgebra/#LinearAlgebra.Tridiagonal)
"""

# ╔═╡ 5f3ee67a-7404-4873-8c07-a4dc8858d073
md"""
L'EDO dans sa forme la plus générale compte la dérivée de ``a(t)``. On utilise la method `gradient` dans le package `Flux` pour cela.

**N.B.** `gradient` donne `missing` quand on lui demande la dérivée d'une fonction constante. Par conséquent, j'ai écrit une method `derivative` wrap around `gradient` qui nous convient plus.
"""

# ╔═╡ bb6b8859-c566-4648-9ed4-b0744eb55b0a
md"""
Prenons un exemple quelconque pour tester notre implémentation de `finitediff1`.
Disons,
```math
\begin{align}
  u(t) &= \sin t  \\
  a(t) &= 1       \\
  c(t) &= 0\,     \\
\end{align}
```
ce qui entraîne
```math
f(t) = -\frac{d^2 u}{dt^2} = \sin t\,.
```
"""

# ╔═╡ 5f089dfb-2ab6-404b-9f26-501a7b981690
# Vérifions la solutions ci-dessus
[sin(t) for t = range(0,1;length=6)[2:end-1]]

# ╔═╡ 1d35c2ea-1960-47c9-b6cf-5ecc713f7f52
md"""
**(?)** Les résultats des deux cellules ci-dessus ne coïncident pas. Vous vous rendez compte d'où votre **"bug"** est?

**(R)** Votre solution ``u`` ne satisfait pas les _boundary conditions_ (i.e. conditions aux bords).
En effet, ``u(t) = \sin t \implies u(0) = 0 \text{ et } u(1) =`` $(sin(1))

Changeons la en
```math
u(t) = \sin(\pi t)\,.
```

Ceci implique
```math
f(t) = \pi^2 \sin(\pi t)\,.
```
"""

# ╔═╡ 01212e15-ef86-4c8d-ab79-46d8db111191
[sin(π*t) for t = range(0,1;length=6)[2:end-1]]

# ╔═╡ 1fe6e455-b092-4afe-b443-1c4de154d3c8
md"""
C'est bien, maintenant la solution fournie par la méthode de différence finie a l'air proche de la vraie solution.
"""

# ╔═╡ 2affebef-e5f4-4973-85ce-6ec1acd9909d


# ╔═╡ ef73a872-c40c-4b67-94dc-d80db984cfa8
md"""
## The Finite Element Method
Je ne sais pas pourquoi j'ai rédigé la première partie (sur "_Différence Finie_") en
français. Maintenant, comme on va ouvrir une nouvelle page, permettez-moi de choisir
une autre langue, le vietnamien, ce qui, j'espère, bénéficie un plus grand public.

Phương pháp sắp sữa được giới thiệu sau đây được gọi là **Galerkin method**.
Đại loại đối với một phương trình ODE hoặc PDE, mình hay nhân nó bằng một hàm, sau đó tích phân.
Thay vì giải trực tiếp phương trình ban đầu, mình sẽ gải phương trình thứ hai này.
Lấy ví dụ phương trình ở đầu chương:
```math
\newcommand{\afAlign}[1]{\int_{0}^{1} \left( a(t)u_{#1}'(t) v_{#1}'(t) + c(t)u_{#1}(t)v_{#1}(t) \right) dt &= \int_{0}^{1} f(t)v_{#1}(t) dt}

\begin{align}
  -(a(t)u'(t))' - c(t)u(t) &= f(t),\; t \in (0, 1) \\
  \int_{0}^{1} (-(a(t)u'(t))' - c(t)u(t))v(t) dt &= \int_{0}^{1} f(t)v(t) dt \\
  \afAlign{} \quad (\text{integration by parts})
\end{align}
```

Đối với những bạn từng học về

- _théorie des distributions_ (trong tiếng Anh môn này hình như được gọi là generalized function theory.)
  - Chú ý _distribution_ ở đây là khái niệm về hàm số do ông người Pháp Laurent Schwartz introduced, không phải cái distribution mình hay sử dụng để miêu tả xác suất.
- Không gian Sobolev với ứng dụng của nó trong PDE

Galerkin method sẽ có vẻ giống kỹ thuật quen thuộc hay được sử dụng ttrong hai lĩnh vực ở trên.

Đối với những bạn đọc muốn tìm hiểu thêm về hai lĩnh vực ở trên, mình giới thiệu mấy cuốn sách sau đây.

- [_Théories des distributions_, Laurent Schwartz](https://archive.org/details/LaurentSchwartzThorieDesDistributionsBook4You1/mode/2up)
- [_Cours d'analyse: Théorie des distributions et analyse de Fourier_, Jean-Michel Bony](https://www.amazon.com/Cours-danalyse-Th%C3%A9orie-distributions-analyse/dp/2730207759)
- [_Functional analysis, Sobolev spaces and partial differential equations_, Haïm Brézis](http://www.math.utoronto.ca/almut/Brezis.pdf)

Cái hàm ``v`` với cái nghiệm ``u``, mình sẽ lấy/tìm từ không gian ``H_{0}^{1}((0, 1))``. Khi ngữ cảnh rõ rằng, thĩnh thoảng mình cũng bỏ cái khoảng (``I = (0,1)`` ở đây) và viết tắt thành ``H_0^1\,.``
Nói một cách đơn giản, không gian ``H_{0}^{1}((0,1))`` thu tập những hàm ``w \in L^2((0,1))`` sao cho

- w' cũng nằm ở trong ``L^2((0,1))`` luôn. (``w'`` ở đây với đạo hàm "_weak sense_")
- ``w(0) = 0`` và ``w(1) = 0\,.``

"""

# ╔═╡ 0fe7d3a9-2166-41bf-9b15-f997ba1171aa
md"""
#### Mấy cái này giúp được gì vào việc giải quyết phương trình?
Việc kế tiếp mình sẽ lấy một không gian ``S_h``, không gian con của ``H_0^1\,,``
trong đó những hàm từ ``S_h`` có thể tạo nên xấp xỉ tốt với những hàm từ ``H_0^1\,.``

Sau đó, thay vì tìm ``u \in H_0^1`` thoả mãn
```math
\newcommand{\auv}[1]{\int_{0}^{1} \left( a(t)u_{#1}'(t) v_{#1}'(t) + c(t)u_{#1}(t)v_{#1}(t) \right) dt}
\newcommand{\fv}[1]{\int_{0}^{1} f(t)v_{#1}(t) dt}

\auv{} = \fv{} \quad \forall\; v \in H_0^1\,,
```
mình sẽ tìm ``u_h \in S_h`` thỏa mãn
```math
\auv{h} = \fv{h}  \quad \forall\; v \in S_h\,.
```

Nhắc lại (Recall that) mình vẫn giữ cái partition của khoảng ``[0,1]`` như cũ:
```math
\begin{align}
  h &= \frac{1}{M-1} \\
  t_j &= jh \quad\forall\; j = 0, 1, 2, \ldots, M-1 \\
  [0, 1] &= [t_0, t_1] \cup [t_1, t_2] \cup \cdots \cup [t_{M-2}, t_{M-1}]\,.
\end{align}
```

Một lựa chọn thông thường cho ``S_h`` là tập của các hàm **_piece-wise linear_** và continuous trên partition ``[t_0, t_1] \cup [t_1, t_2] \cup \cdots \cup [t_{M-2}, t_{M-1}]\,.``

Tương ứng với lựa chọn ``S_h`` piece-wise linear có một basis đơn giản, đó là hàm **_hat functions_** ``\phi_j, \;j=1,2,\ldots,M-2\,`` như sau
```math
\phi_j(t) = \begin{cases}
  \frac{t - t_{j-1}}{t_j - t_{j-1}}, \quad &t \in [t_{j-1}, t_j] \\
  \frac{t - t_{j+1}}{t_j - t_{j+1}}, \quad &t \in [t_j, t_{j+1}] \\
  \quad 0 &\text{otherwise}
\end{cases}\quad.
```
"""

# ╔═╡ 5c77c1d4-c1c6-4245-a1d8-5de69afb140c
begin
  function ϕ(M::Int, j::Int, t::Number)
  #function ϕ(M, j, t)
    if M <= 0
      error("M must be a positive integer")
    end
    if j < 1 || j > M - 2
      error("j must be a positive integer in [1 .. M-2]")
    end
    tmesh = range(0,1;length=M)
    h = tmesh[2]
    tⱼ₋₁ = tmesh[j]
    tⱼ   = tmesh[j+1]
    tⱼ₊₁ = tmesh[j+2]
  
    if t > tⱼ₊₁
      return 0
    elseif t >= tⱼ
      return (tⱼ₊₁ - t) / h
    elseif t >= tⱼ₋₁
      return (t - tⱼ₋₁) / h
    else
      return 0
    end
  end
  function ϕ_adjoint(M, j, t, l)
    tmesh = range(0,1;length=M)
    h = tmesh[2]
    tⱼ₋₁ = tmesh[j]
    tⱼ   = tmesh[j+1]
    tⱼ₊₁ = tmesh[j+2]
    if t > tⱼ₊₁
      return (l*0,)
    elseif t >= tⱼ
      return (-l/h,)
    elseif t >= tⱼ₋₁
      return (l/h,)
    else
      return (l*0,)
    end
  end
  @adjoint ϕ(M,j,t) = ϕ(M,j,t), l -> (nothing, nothing, ϕ_adjoint(M,j,t,l))
end

# ╔═╡ f06412aa-9aca-4805-b75b-93a19070da32
# begin
#   function ϕ(M::Int, j::Int)
#     if M <= 0
#       error("M must be a positive integer")
#     end
#     if j < 1 || j > M - 2
#       error("j must be a positive integer in [1 .. M-2]")
#     end
#     function ϕⱼ(t::Number)
#       # h = 1 / (M-1)
#       # tⱼ₋₁ = (j-1)*h
#       # tⱼ = j*h
#       # tⱼ₊₁ = (j+1)*h

#       tmesh = range(0,1;length=M)
#       h = tmesh[2]
#       tⱼ₋₁ = tmesh[j]
#       tⱼ   = tmesh[j+1]
#       tⱼ₊₁ = tmesh[j+2]

#       ## Need or no need of `return` in the following conditions?
#       if t > tⱼ₊₁
#         return 0
#       elseif t >= tⱼ
#         return (tⱼ₊₁ - t) / h
#       elseif t >= tⱼ₋₁
#         return (t - tⱼ₋₁) / h
#       else
#         return 0
#       end
#     end
#     return ϕⱼ
#   end
# end

# ╔═╡ 800f2f97-5e6b-4dd4-955d-e9ef5662fe60
md"""
#### Vẽ hat functions
"""

# ╔═╡ 4e82b334-308b-4f56-b25e-adcc498a4673
let
  M = 5
  #the_ϕs = [ϕ(M, j) for j in 1:M-2]
  alpha = 0.7
  lw = 2
  ts = range(0,1;length=700)
  plot(ts,
       (t->ϕ(M,1,t)).(ts),
       linealpha=alpha,
       linewidth=lw,
       xlim=(0,1.1),
       xticks=range(0,1;length=M),
       yticks=range(0,1;length=M),
       aspect_ratio=:equal,
       label="ϕ1",
       legend=:topleft,
       background_color=:black,
       title="M = $M",
  )
  for j in 2:M-2
    plot!(ts,
          (t->ϕ(M,j,t)).(ts),
          linewidth=lw,
          linealpha=alpha,
          label="ϕ$(j)")
  end
  plot!()
end

# ╔═╡ 48d3dee7-5a02-4fc4-bdc3-057d61c2c825
md"""
Nếu mình định nghĩa
```math
\begin{align}
  \mathrm{a}(u, v) &= \auv{} \\
  (f, v) &= \fv{}
\end{align}
```
thì solution ``u`` thoả mãn
```math
\mathrm{a}(u,v) = (f,v) \quad\forall\; v \in H_0^1\,.
```

Hơn nữa,

- ``\mathrm{a}(\cdot, \cdot)`` là một **_bilinear form_**
- và ``(f, \cdot)`` một **_linear form_**.
"""

# ╔═╡ fbcd6e7b-5b17-41b2-973e-d575d506cb2c
md"""
### CHALLENGE 23.4.
- (a) Mình sẽ đi tìm ``u_h \in S_h`` sao cho
  ```math
  \mathrm{a}(u_h, v_h) = (f, v_h) \quad\forall\; v_h \in S_h\,.
  ```
- (b) Từ những thảo luận này hãy suy luận ra một phương trình ``Au = g`` tương từ với finite difference ở đầu chương cho finite element ở đây. Rồi lặp lại những ví dụ mình từng làm và so sảnh kết quả của hai phương pháp (finite difference và finite element).
"""


# ╔═╡ 26c20232-6353-4439-87a5-e7ccee13a63c
md"""
Bởi vì ``a(\cdot, \cdot)`` và ``(f, \cdot)`` là bilinear và linear và bởi vì, theo định nghĩa,
``S_h = \text{span}\left(\{\phi_j \,|\, j = 1, 2, \ldots, M-2\}\right)``, một khi chúng ta tìm được ``u_h \in S_h`` sao cho
```math
\mathrm{a}(u_h, \phi_j) = (f, \phi_j) \quad\forall\; j=1,2,\ldots, M-2 \,,
```
thì chúng ta sẽ có
```math
  \mathrm{a}(u_h, v_h) = (f, v_h) \quad\forall\; v_h \in S_h
```
liền.

Vì ``u_h \in S_h``, mình có thể viết như sau
```math
u_h = \sum_{j=1}^{M-2} u_j \phi_j\,,
```
trong đó

- ``u_j \in \mathbb{R}`` là hằng số (chưa được xác định giả trị)
- Ký hiệu ``u_j`` ở đây consistent với cùng một ký hiệu ``u_j := u(t_j)`` được sử dụng lúc trước khi nói về finite difference
  - Thật vậy, ``\left( \sum_{k=1}^{M-2} u_k \phi_k \right)(t_j) = u_j \quad\forall\; j = 1, 2, \ldots, M-2``
"""

# ╔═╡ 699892d7-19be-4522-b961-af97bf7f4cc4
md"""
Ok, giờ chúng ta thay
```math
u_h = \sum_{k=1}^{M-2} u_k \phi_k
```
vào trong
```math
\mathrm{a}(u_h, \phi_j) = (f, \phi_j) \quad\forall\; j = 1, \ldots, M-2
```
và xem những hằng số ``u_1, u_2, \ldots, u_{M-2}`` nên thoả mãn điều kiện như thế nào:

```math
\begin{align}
  \mathrm{a}\left(\sum_{k=1}^{M-2} u_k \phi_k,\; \phi_j\right) &= (f, \phi_j) \quad\forall\; j = 1,\ldots,M-2 \\
  \sum_{k=1}^{M-2} u_k\; \mathrm{a}\left(\phi_k, \phi_j\right) &= (f, \phi_j) \quad\forall\; j = 1,\ldots,M-2 \\
\end{align}
```
```math
\newcommand{\aphis}[2]{\mathrm{a}\left(\phi_{#1}, \phi_{#2}\right)}
\newcommand{\fphi}[1]{\left(f, \phi_{#1}\right)}

\begin{pmatrix}
  \aphis{1}{1}   & \aphis{2}{1}   & \cdots & \aphis{M-2}{1} \\
  \aphis{1}{2}   & \aphis{2}{2}   & \cdots & \aphis{M-2}{2} \\
  \vdots         & \vdots         & \ddots & \vdots         \\
  \aphis{1}{M-2} & \aphis{2}{M-2} & \cdots & \aphis{M-2}{M-2} \\
\end{pmatrix}
\begin{pmatrix}
  u_{1} \\
  u_{2} \\
  \vdots \\
  u_{M-2} \\
\end{pmatrix} =
\begin{pmatrix}
  \fphi{1} \\
  \fphi{2} \\
  \vdots \\
  \fphi{M-2} \\
\end{pmatrix}
```
Cái phương trình cuối cùng chính là điều khiện mà ``u_1, \ldots, u_{M-2}`` nên thỏa mãn, i.e. ``\left( u_1, \ldots, u_{M-2} \right)`` nên là nghiệm của ``Au = g\,.``
"""

# ╔═╡ 86863ec1-18d8-4215-a8f9-ac64cce03608
md"""
Thật ra, cái ma trận ở trên mình chưa có đưa nó về hình dạng đơn giản nhất:
```math
\newcommand{\aa}[2]{\int_0^1 \left( a(t){#1}'(t){#2}'(t) + c(t){#1}(t){#2}(t) \right) \,dt}
\begin{align}
  \mathrm{a}(\phi_k, \phi_j) &= \aa{\phi_k}{\phi_j} \\
  &= \begin{cases}
    0, &\lvert k - j \rvert > 1 \\
    \int_{t_j}^{t_{j+1}} \left( -\frac{a(t)}{h^2} + c(t)\frac{(t-t_j)(t-t_{j+1})}{h^2} \right)\,dt , &k = j+1 \\
    \int_{t_{j-1}}^{t_{j+1}} \left( \frac{a(t)}{h^2} + c(t)\phi_j^2(t) \right)\,dt , &k = j
  \end{cases}
\end{align}
```

**Rmk.**
- Nhận xét quan trọng ở đây là ma trận ``A`` luôn là **_tridiagonal_**. ``(``Chú ý rằng không cần ``a(t) = 1, c(t) = 0\,).\;`` Cái kết quả này giống kết quả với finite difference -- Tức là trong cả finite difference lẫn finite element, ma trận ``A`` liên quan với EDO đầu chương đều là tridiagonal.
- Một điều quan trọng khác: ``A`` symmetric.
"""

# ╔═╡ c985f320-ebb3-42c8-a195-a0e08befcd0a
md"""
Với ví dụ ``M=6, a(t)=1, c(t)=0``, chúng ta có
```math
\aphis{k}{j} = \int_0^1 \phi_k'(t) \phi_j'(t) dt =
\begin{cases}
  \frac{2}{h}    &\text{nếu}\;\;   k = j                   \\
  -\frac{1}{h}   &\text{nếu}\;\;   \lvert k -j \rvert = 1  \\
  0              &\text{otherwise}
\end{cases}\quad,
```
bởi vì
```math
\phi_j'(t) =
\begin{cases}
  \frac{1}{h},  &t \in [t_{j-1}, t_j] \\
  -\frac{1}{h}, &t \in [t_{j-1}, t_j] \\
  0             &\text{otherwise}
\end{cases}\quad.
```
Điền cái kết quả này vô ma trận ``A`` ở trên, mình sẽ được một phương trình rất giống hồi mình ở finite difference:
```math
\begin{pmatrix}
     2 & -1 &  0 &  0 & 0 & \cdots & 0 \\
    -1 &  2 & -1 &  0 & 0 & \cdots & 0 \\
     0 & -1 &  2 & -1 & 0 & \cdots & 0 \\
    \vdots &&   & \ddots  &   &    & \vdots \\
     0  & \cdots& & 0 & -1 &  2 & -1    \\
     0  & \cdots& & 0 &  0 & -1 &  2    \\
\end{pmatrix}
\begin{pmatrix}
  u_{1} \\
  u_{2} \\
  \vdots \\
  u_{M-2} \\
\end{pmatrix} = h
\begin{pmatrix}
  \fphi{1} \\
  \fphi{2} \\
  \vdots \\
  \fphi{M-2} \\
\end{pmatrix}\,.
```
Để ý rằng sự thay đổ nằm ở bên tay phải của phương trình

- ``h^2 f_j``
- ``h\, (f, \phi_j)``

**Rmk.** Xét vào khía cảnh dimension, hai quantity ở trên có cùng một dimension.

On remarque que cela a forme ``Au = g\,,`` où ``A`` est une matrice **tridiagonale**.

Với ``M=6\,,`` chúng ta có

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
\end{pmatrix} = \frac{1}{5}
\begin{pmatrix}
  \fphi{1} \\
  \fphi{2} \\
  \fphi{3} \\
  \fphi{4} \\
\end{pmatrix}\,.
```



"""


# ╔═╡ 5e7ab74c-1473-4c8e-9d93-13dd9c108af2
md"""
**Rmk.** Việc tính ``(f, \phi_j)`` tạm thời mình chưa có nghĩ ra cách nào tốt hơn numerical integration.

#### Numerical integration with `QuadGK`
Mình sẽ thử với package `QuadGK` và một vài ví dụ

- ``f(t) = 1``
- ``f(t) = \phi_j(t)``
- ``f(t) = \sin t``
"""

# ╔═╡ ef18414a-ad2e-4847-9054-fe5b7051f0b9
let
  M = 6
  j = 3
  # f(t) = 1 => expected_ans = 1/h = 1/5
  integral, err = quadgk(t -> ϕ(M, j, t), 0, 1, rtol=1e-8)
end

# ╔═╡ 37a597d5-f7f4-475c-bcf7-bfe42a2b1155
let
  M = 6
  j = 3
  integral, err = quadgk(t -> ϕ(M, j, t) * ϕ(M, j, t), 0, 1, rtol=1e-8)
end

# ╔═╡ 0a99bb14-5676-4d0b-b03a-5e846dd5577e
md"""
The above integral equals ``2\int_0^{h} \frac{(t-h)^2}{h^2} dt = 2\int_{-h}^0 \frac{s^2}{h^2} ds = 2\frac{s^3}{3h^2} \lvert_{y=-h}^{0} = 2\frac{h^3}{3h^2} = 2\frac{h}{3}``
"""

# ╔═╡ 98acce2b-d7ab-494d-9589-2b9e7a845847
let
  M = 6
  h = 1 / (M-1)
  (h / 3) * 2
end

# ╔═╡ 5a7ae6ff-5adc-4941-9ee0-7c1a7a4c8c20
let
  # sin(t) is tedious to verify, so let's skip its verification here.
  M = 6
  j = 3
  f(t) = sin(t)
  integral, err = quadgk(t -> f(t) * ϕ(M, j, t), 0, 1, rtol=1e-8)
end

# ╔═╡ 44e71cee-fa27-434c-a7ad-a14d8f2026c8
md"""
### CHALLENGE 23.5.
Write a function (or a script) `fe_linear` which mimics the `finitediff1` but which uses finite element method.
"""

# ╔═╡ 2a0bf1bd-9bce-4ccd-b01f-7c476fd4fe8a
function integrate_product(u::Function, v::Function, a::Number=0, b::Number=1; rtol=1e-8)
  integral, err = quadgk(t -> u(t)*v(t), a, b, rtol=rtol)
  return integral
end

# ╔═╡ cf7d12f6-628e-4e97-95e4-72b25207744b
function integrate_product(u::Function, v::Function, w::Function, a::Number=0, b::Number=1; rtol=1e-8)
  integral, err = quadgk(t -> u(t)*v(t)*w(t), a, b, rtol=rtol)
  return integral
end

# ╔═╡ 7feaac8f-1b1f-40c6-a5e0-dc2c7b6b4eff
begin
  function fe_linear(M::Number, a::Function, c::Function, f::Function)
    """
    `a, c, f` are functions whose input is a vector and output is a vector.
    Accurately speaking, `a` returns two vectors, the first one `a` itself,
    the second one its derivative.

    TODO:
    01. Use @view
    """
    rtol = 1e-4
    h = 1 / (M-1)
    function aphiphi(k::Int, j::Int)
      # if abs(k - j) > 1
      #   return 0
      # end
      # if k == j
      #   return 2 / h
      # else
      #   return -1.0 / h
      # end
      integral, err = quadgk(t -> a(t)*ϕ′(M,k)(t)*ϕ′(M,j)(t) + c(t)*ϕ(M,k)(t)*ϕ(M,j)(t), 0, 1, rtol=rtol)
      return integral
    end
    function fphi(j::Int)
      integral, err = quadgk(t -> f(t)*ϕ(M,j)(t), 0, 1, rtol=rtol)
      return integral
    end
    #t = range(0, 1; length=M)
    #h = t[2]
    #tmesh = t[2:end-1]
    #a0_and_a1 = a(tmesh)  # a0: 0th derivative, a1: 1st derivative
    #a0 = @view a0_and_a1[1:end, 1]
    #a1 = @view a0_and_a1[1:end, 2]
    #a1_over_h = a1 ./ h
    #a0_over_h² = a0 ./ h^2
    #c0 = c.(tmesh)
    #g = f0 = f(tmesh)
    g = [fphi(j) for j in 1:M-2]
    #g = Array(fphi(j) for j in 1:M-2)
    diag = [aphiphi(j, j) for j in 1:M-2]
    ldiag = [aphiphi(j+1, j) for j in 1:M-3]
    udiag = ldiag
    #udiag = [aphiphi(j, j-1) for j in 2:M-2]
    A = spdiagm(-1 => ldiag, 0 => diag, 1 => udiag)
    ## A * ucomp = g
    ucomp = A \ g
  end
end

# ╔═╡ d34648db-18df-4713-b548-4b56cba31bab
g = [linear_phi(t->sin(t), 6, j) for j in 1:4]

# ╔═╡ 8f14cb22-b2cc-4379-927b-90689f3e868c
function derivative(f::Function)::Function
  f′(t) = gradient(f, t)[1]
  function g(t)
    if f′(t) === nothing
      0.
    else
      f′(t)
    end
  end
  g
end

# ╔═╡ 2e8b74ed-85e9-4b39-82e4-59819c71353b
function finitediff1(M::Number, a::Function, c::Function, f::Function)
  t = range(0, 1; length=M)
  ## This ensures that 
  ## 1) length(t) equals 10
  ## 2) t[1] equals 0 and t[end] = 1

  h = t[2]              # same as h = 1 / (M-1) but save the work to recompute
  tmesh = t[2:end-1]    # i.e. all endpoints except for t₀ = 0 and t₁ = 1
  a0 = a.(tmesh)
  #a1 = (t -> gradient(a, t)[1]).(tmesh) # ceci ne marche pas pour fonctions constante
  a1 = derivative(a).(tmesh)
  a1_over_h = a1 ./ h
  a0_over_h² = a0 ./ h^2
  c0 = c.(tmesh)
  g = f.(tmesh)
  diag = -a1_over_h + 2 .* a0_over_h² + c0
  ldiag = (a1_over_h - a0_over_h²)[2:end]
  udiag = -a0_over_h²[1:end-1]
  #A = spdiagm(-1 => ldiag, 0 => diag, 1 => udiag)
  A = Tridiagonal(ldiag, diag, udiag)
  ## A * ucomp = g
  ucomp = A \ g
end

# ╔═╡ 3c845ed7-0a2a-4ff9-9573-a9ef9cf79ca9
let
  M = 6
  a(t) = 1
  c(t) = 0
  f(t) = sin(t)
  # Posons u(t) = sin(t) ⟹  f(t) = -sin(t).
  # Tous les deux lignes suivantes marchent.
  finitediff1(M, t -> 1, t -> 0, t -> sin(t))
  #finitediff1(M, a, c, f)
end

# ╔═╡ 47967b6a-e045-41ec-9c64-8101ee06b5c8
let
  M = 6
  finitediff1(M, t -> 1, t -> 0, t -> π^2 * sin(π*t))
end

# ╔═╡ a61f14a5-2edc-4691-9501-bed30b30e766
md"""
#### `notes_v04.jl`
After finishing writing the function `fe_linear`, I realized that
the previous implementation of `finitediff1` was not good. I would
like to go back and carry the same spirit from `fe_linear` to `finitediff1`.
In particular, the `a` input arg, it should not be user-specified; user
should only need to know `a(t)`, and only need to specify that.
"""

# ╔═╡ e89ad2cc-af62-4730-8bb9-4dcaa745b91e
# let
#   M = 6
#   a(t) = 1
#   c(t) = 0
#   f(t) = π^2 * sin(π*t)
#   fe_linear(M, a, c, f)
# end

# ╔═╡ 6c080408-8fb8-4a03-b8a8-66582070763d
[sin(π*t) for t = 1/5:1/5:4/5]

# ╔═╡ c294df42-bb15-4f3d-aef9-e19b409faa64
let
  diag = [2 for _ in 1:5]
  ldiag = [-1.0 for _ in 1:4]
  udiag = ldiag
  udiag = @view ldiag[1:end]
  A = spdiagm(-1 => ldiag, 0 => diag, 1 => udiag)
  g = randn(5)
  A\g
end

# ╔═╡ 0a3b6d61-b63a-4d28-93c6-b136f3456c9e
# function derivative(f::Function)::Function
#   #f′(t) = gradient(f, t)[1]
#   function g(t)
#     #global f′
#     x = gradient(f,t)[1]
#     #if f′(t) === nothing
#     if x === nothing
#       return 0.
#     else
#       #return f′(t)
#       return x
#     end
#   end
#   # if f′(0) === nothing
#   #   return t -> 0
#   # else
#   #   return f′
#   # end
#   return g
# end

# ╔═╡ d37a1d63-4171-43c1-ae40-c9c71bfb8e09
function naive_derivative(f::Function)::Function
  #f′(t) = gradient(f, t)[1]
  return t -> gradient(f, t)[1]
end

# ╔═╡ 13ca663c-e8bb-42b9-80fe-10bf2d384bb7
let
  function f(t)
    if t > 0
      t
    else
      0
    end
  end
  f(π), f(-π), derivative(f)(π), derivative(f)(-π), naive_derivative(f)(π), naive_derivative(f)(-π)
end

# ╔═╡ a79042bc-a2d2-4a62-abd8-6995bc135a24
let
  function f(t)
    if t > 0
      t
    else
      0
    end
  end
  a = 1/5
  f(a), f(-a), derivative(f)(a), derivative(f)(-a), naive_derivative(f)(a), naive_derivative(f)(-a)
end

# ╔═╡ fe1e7ad9-b7fe-488b-bcfd-01c4723395e1
#nothing * 3.0  # MethodError: no such method as *(::Nothing, ::Number)

# ╔═╡ 3f5270aa-885f-478b-aab2-21dc3851caa6
let
  function f(t)::Number
    if t > 0
      t
    else
      0
    end
  end
  gradient(f,π), gradient(f,-π)
end

# ╔═╡ 3b8eb881-afe9-4401-828a-c03fb0c4a8fe
gradient(t->t, π), gradient(t->0, -π)

# ╔═╡ e065f6e4-543b-465e-9b0f-959b6a8975af
md"""
#### Improvement?
It seems that there exists this `Tridiagonal` thing in `LinearAlgebra` package, which we can use in place of `spdigm` in `SparseArrays`.
"""

# ╔═╡ cf9b2c80-d670-4d14-b716-ed3292fe1fa6
let
  function f(t)
      t
  end
  gradient(f, π), gradient(f, -π), gradient(f, 3.14159)
end

# ╔═╡ 58ddaa61-9e63-4e93-865e-105fa442714a
typeof(π), typeof(-π)

# ╔═╡ 9584f9b1-2bf7-43bb-8a05-ae966a786eac
Irrational <: Real

# ╔═╡ 1ccf50a9-5490-410d-be9a-b800ad9bac09
Irrational <: AbstractFloat, Rational <: AbstractFloat

# ╔═╡ 31ee9fc2-88c2-43fc-b42f-766d60d6e1d8
Unsigned <: Number, Unsigned <: Integer

# ╔═╡ 9d9b5f27-1839-4c41-9a71-a77f3673efa3
derivative(sin).([j*π/2 for j = 0:4])

# ╔═╡ cdc53410-6e4d-4df9-86a2-0adebcb6d122
derivative(t->1).(range(0,1;length=10))

# ╔═╡ 4dae4a2a-b9ae-4c13-9b3d-97720399e44b
let
  M = 6
  j = 3
  derivative(ϕ(M,j))(3/(M-1))
  #ϕ(M,j).(range(0,1;length=M))
end

# ╔═╡ fdb4d773-543d-40eb-8bea-d07dc8444f9f
let
  function un(t::Number)
    return 1
  end
  derivative(un)(π)
end

# ╔═╡ 7d5f6add-d9dc-4e4a-9058-8380dfbac69b
gradient(t->1, π)

# ╔═╡ 09e3d594-6496-4458-8cd7-934840e1ccb8
function rma_integrand(a::Function, c::Function, u::Function, v::Function)::Function
  return t -> a(t) * derivative(u)(t) * derivative(v)(t) + c(t) * u(t) * v(t)
end

# ╔═╡ 1be5d29c-0be3-4ed5-84c6-cb7eafa44ffd
let
  M = 6
  j = 2
  integral, err = quadgk(rma_integrand(t->1, t->0, ϕ(M,j), ϕ(M,j)), 0, 1; rtol=1e-5)
end

# ╔═╡ bacca6c4-edbe-4eef-a9f9-d472b8360ff6
derivative(ϕ(6,3)).(range(0,1;length=6))

# ╔═╡ e3041732-73eb-44a3-b7ca-92fd4557422e
derivative(sin)(3/5)

# ╔═╡ Cell order:
# ╠═ffe1050f-57ed-4836-8bef-155a2ed17fbd
# ╟─843498a2-c9c8-11eb-31a4-fb7bd7be2a89
# ╟─5c17ad87-dc9f-4cb4-80f5-8717626cfcb3
# ╟─c8275327-f599-4252-beb1-7227f5c5f7ba
# ╟─b9fac562-a00c-489d-91a6-f25ad4348940
# ╟─b529132e-2c1d-4d58-90ca-238fee4f8a93
# ╟─12fd4e40-5406-40e8-98af-9ba089bf37e7
# ╟─3c99b108-aadd-4b6b-8e04-a351e09d7487
# ╟─4728cfab-d857-4890-9b1e-68941224ee11
# ╟─5f3ee67a-7404-4873-8c07-a4dc8858d073
# ╟─8f14cb22-b2cc-4379-927b-90689f3e868c
# ╠═2e8b74ed-85e9-4b39-82e4-59819c71353b
# ╟─bb6b8859-c566-4648-9ed4-b0744eb55b0a
# ╠═3c845ed7-0a2a-4ff9-9573-a9ef9cf79ca9
# ╠═5f089dfb-2ab6-404b-9f26-501a7b981690
# ╟─1d35c2ea-1960-47c9-b6cf-5ecc713f7f52
# ╠═47967b6a-e045-41ec-9c64-8101ee06b5c8
# ╠═01212e15-ef86-4c8d-ab79-46d8db111191
# ╟─1fe6e455-b092-4afe-b443-1c4de154d3c8
# ╠═2affebef-e5f4-4973-85ce-6ec1acd9909d
# ╟─ef73a872-c40c-4b67-94dc-d80db984cfa8
# ╟─0fe7d3a9-2166-41bf-9b15-f997ba1171aa
# ╠═5c77c1d4-c1c6-4245-a1d8-5de69afb140c
# ╠═f06412aa-9aca-4805-b75b-93a19070da32
# ╟─800f2f97-5e6b-4dd4-955d-e9ef5662fe60
# ╟─4e82b334-308b-4f56-b25e-adcc498a4673
# ╟─48d3dee7-5a02-4fc4-bdc3-057d61c2c825
# ╟─fbcd6e7b-5b17-41b2-973e-d575d506cb2c
# ╟─26c20232-6353-4439-87a5-e7ccee13a63c
# ╟─699892d7-19be-4522-b961-af97bf7f4cc4
# ╟─86863ec1-18d8-4215-a8f9-ac64cce03608
# ╟─c985f320-ebb3-42c8-a195-a0e08befcd0a
# ╟─5e7ab74c-1473-4c8e-9d93-13dd9c108af2
# ╠═ef18414a-ad2e-4847-9054-fe5b7051f0b9
# ╠═37a597d5-f7f4-475c-bcf7-bfe42a2b1155
# ╟─0a99bb14-5676-4d0b-b03a-5e846dd5577e
# ╠═98acce2b-d7ab-494d-9589-2b9e7a845847
# ╠═5a7ae6ff-5adc-4941-9ee0-7c1a7a4c8c20
# ╟─44e71cee-fa27-434c-a7ad-a14d8f2026c8
# ╠═2a0bf1bd-9bce-4ccd-b01f-7c476fd4fe8a
# ╠═cf7d12f6-628e-4e97-95e4-72b25207744b
# ╠═7feaac8f-1b1f-40c6-a5e0-dc2c7b6b4eff
# ╠═d34648db-18df-4713-b548-4b56cba31bab
# ╟─a61f14a5-2edc-4691-9501-bed30b30e766
# ╠═e89ad2cc-af62-4730-8bb9-4dcaa745b91e
# ╠═6c080408-8fb8-4a03-b8a8-66582070763d
# ╠═c294df42-bb15-4f3d-aef9-e19b409faa64
# ╠═0a3b6d61-b63a-4d28-93c6-b136f3456c9e
# ╠═d37a1d63-4171-43c1-ae40-c9c71bfb8e09
# ╠═13ca663c-e8bb-42b9-80fe-10bf2d384bb7
# ╠═a79042bc-a2d2-4a62-abd8-6995bc135a24
# ╠═fe1e7ad9-b7fe-488b-bcfd-01c4723395e1
# ╠═3f5270aa-885f-478b-aab2-21dc3851caa6
# ╠═3b8eb881-afe9-4401-828a-c03fb0c4a8fe
# ╟─e065f6e4-543b-465e-9b0f-959b6a8975af
# ╠═cf9b2c80-d670-4d14-b716-ed3292fe1fa6
# ╠═58ddaa61-9e63-4e93-865e-105fa442714a
# ╠═9584f9b1-2bf7-43bb-8a05-ae966a786eac
# ╠═1ccf50a9-5490-410d-be9a-b800ad9bac09
# ╠═31ee9fc2-88c2-43fc-b42f-766d60d6e1d8
# ╠═9d9b5f27-1839-4c41-9a71-a77f3673efa3
# ╠═cdc53410-6e4d-4df9-86a2-0adebcb6d122
# ╠═4dae4a2a-b9ae-4c13-9b3d-97720399e44b
# ╠═fdb4d773-543d-40eb-8bea-d07dc8444f9f
# ╠═7d5f6add-d9dc-4e4a-9058-8380dfbac69b
# ╠═09e3d594-6496-4458-8cd7-934840e1ccb8
# ╠═1be5d29c-0be3-4ed5-84c6-cb7eafa44ffd
# ╠═bacca6c4-edbe-4eef-a9f9-d472b8360ff6
# ╠═e3041732-73eb-44a3-b7ca-92fd4557422e
