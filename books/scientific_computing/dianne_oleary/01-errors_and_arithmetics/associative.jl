### A Pluto.jl notebook ###
# v0.12.21

using Markdown
using InteractiveUtils

# ╔═╡ c3bb4004-047c-11ec-1205-2bffc4a86391
begin
  using PlutoUI
  using Printf
end

# ╔═╡ 5ac19c02-0494-11ec-222a-5f33fd1872c9
md"""
### Associative laws holds for floating-point numbers?

"""

# ╔═╡ e01dd560-0477-11ec-35ce-2bbc7ad49362
let
  n_samples = 1_000
  with_terminal() do
    #for (a, b, c) in rand(Float32, (3, n_samples))
    for (a, b, c) in [rand(Float64, (3,)) for _ in 1:n_samples]
      if (a + b) + c != a + (b + c)
        println("($a + $b) + $c != $a + ($b + $c)")
      end
    end
  end
end

# ╔═╡ 86fabafe-047d-11ec-0ca2-5922e45771dc
let
  n_samples = 1_000
  with_terminal() do
    for (a, b, c) in [rand(Float64, (3,)) for _ in 1:n_samples]
      if (a * b) * c != a * (b * c)
        #println("($(@sprintf "%.2f" a) * $b) * $c != $a * ($b * $c)")
        println("($(@sprintf "%.2f" a) * $b) * $c != $a * ($b * $c)\n")
      end
    end
  end
end

# ╔═╡ Cell order:
# ╠═c3bb4004-047c-11ec-1205-2bffc4a86391
# ╟─5ac19c02-0494-11ec-222a-5f33fd1872c9
# ╠═e01dd560-0477-11ec-35ce-2bbc7ad49362
# ╠═86fabafe-047d-11ec-0ca2-5922e45771dc
