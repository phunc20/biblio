### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ ccb2f2aa-eba5-11eb-0279-531b30bc8740
begin
  using Pkg
  Pkg.activate("../../../../.julia_env/oft")
  Pkg.add(["Plotly",
          "PyPlot",
			])
  using PyCall
  using PyPlot
end

# ╔═╡ de204fc9-6cdd-43c6-9be9-e91d491aeb74
typeof(Inf)

# ╔═╡ 13af9133-5012-4187-8db8-f3d8801ab8d8
supertypes(Float64)

# ╔═╡ f91369b7-e5d9-4a22-9ffd-e69de2a58c90
#function norm(x::Array{Number, 1}, p::Number)
function norm(x::Array, p::Number)
  if p == Inf
    maximum(abs.(x))
  else
    sum((abs.(x)).^p) ^ (1/p)
  end
end

# ╔═╡ 889e906e-f9e7-48ea-8fcd-31e2cb54cbd3
norm([3,4], Inf)

# ╔═╡ 306b735c-714b-4b56-bbcd-2221ee011995
abs.([1,2,3])

# ╔═╡ e3302f29-9f56-46e1-9bfd-578e53970470


# ╔═╡ c088a2ca-e26e-4b4e-b34b-2333c524df52
repeat(range(0, stop=2, length=50), 2, 50)

# ╔═╡ 07413f59-4394-4c36-a16f-f8159602246c


# ╔═╡ Cell order:
# ╠═ccb2f2aa-eba5-11eb-0279-531b30bc8740
# ╠═de204fc9-6cdd-43c6-9be9-e91d491aeb74
# ╠═13af9133-5012-4187-8db8-f3d8801ab8d8
# ╠═f91369b7-e5d9-4a22-9ffd-e69de2a58c90
# ╠═889e906e-f9e7-48ea-8fcd-31e2cb54cbd3
# ╠═306b735c-714b-4b56-bbcd-2221ee011995
# ╠═e3302f29-9f56-46e1-9bfd-578e53970470
# ╠═c088a2ca-e26e-4b4e-b34b-2333c524df52
# ╠═07413f59-4394-4c36-a16f-f8159602246c
