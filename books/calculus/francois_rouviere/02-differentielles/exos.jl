### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 48bf7ffe-e0ab-11eb-23a3-df29894d8b57
begin
  using Pkg
  # .julia_env/ is in the root dir of this repo
  Pkg.activate("../../../../.julia_env/oft")
  using Plots
  #using TikzPictures
end

# ╔═╡ db9bfada-e0b2-11eb-18ec-db938f856e19
md"""
Pour toute matrice ``X \in M_{n,n}(\mathbb{R}),\;``
on définit sa norme
```math
\newcommand{\norm}[1]{\lVert{#1}\rVert}
\norm{X} = \norm{\mathsf{L}_{X}} = \sup_{\norm{u}_{l_{2}} = 1} \norm{Xu}_{l_{2}}\,.
```

Comme on a ``\norm{f \circ g} \le \norm{f} \norm{g}\quad \forall\; f \in \mathscr{L}(E, F),\, g \in \mathscr{L}(F, G)`` où ``E, F, G`` sont des espaces vectoriels normés. Ceci implique
```math
\norm{XY} \le \norm{X} \norm{Y} \quad\forall\; X, Y \in M_{n,n}(\mathbb{R})
```

Pour une révision sur la norme d'une application linéaire continue, voir
<https://github.com/phunc20/maths/blob/master/definitions/functions/linear/norm.jl>
"""


# ╔═╡ Cell order:
# ╠═48bf7ffe-e0ab-11eb-23a3-df29894d8b57
# ╠═db9bfada-e0b2-11eb-18ec-db938f856e19
