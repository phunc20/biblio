### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ 505a7c6a-7ffc-11eb-1595-253ec142d349
begin
  import Pkg
  Pkg.activate(mktempdir())
  Pkg.add([
    #Pkg.PackageSpec(name="PlutoUI", version="0.6.8-0.6"),
    "Distributions",
    "RCall"
  ])
  using Distributions
  using RCall
end

# ╔═╡ fc5101d8-8001-11eb-3f18-3572043ced9c
md"""
En `R`, la valeur $u_{\alpha}$ t.q. $P(\lVert U \rVert > u_{\alpha}) = \alpha\,$ peut etre obtenue par la commande
`qnorm(1-alpha/2)`, où
- `q` veut dire **quantile**
- et `norm` **standard normal distribution**.

En `julia`, on pourrait atteindre le même but, comme par exemple, avec les packages suivant:
- [`Distributions` package](https://juliastats.org/Distributions.jl/stable/starting/#)
- [`RCall` package](https://juliainterop.github.io/RCall.jl/latest/gettingstarted.html)

"""

# ╔═╡ 38c59c74-8001-11eb-2e06-47c52baffa39
begin
  alpha = 0.05
  R"""
  u_alpha_r = qnorm(1-$alpha/2)
  """
  R"u_alpha_r"
end

# ╔═╡ 38c54102-8001-11eb-0825-cf80cd3d9399
quantile(Normal(), 1-alpha/2)

# ╔═╡ 387cea6a-8001-11eb-0cc9-e9d5be264c58


# ╔═╡ Cell order:
# ╟─fc5101d8-8001-11eb-3f18-3572043ced9c
# ╠═505a7c6a-7ffc-11eb-1595-253ec142d349
# ╠═38c59c74-8001-11eb-2e06-47c52baffa39
# ╠═38c54102-8001-11eb-0825-cf80cd3d9399
# ╠═387cea6a-8001-11eb-0cc9-e9d5be264c58
