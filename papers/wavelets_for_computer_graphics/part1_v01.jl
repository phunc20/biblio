### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 91fb6596-f2b1-11eb-1498-093e78301b1f
begin
  using Pkg
  Pkg.activate("../../.julia_env/oft")
  # Pkg.add([
  #   "Plotly",
  #   "PyPlot",
  #   "PyCall",
  # ])
  # using PyCall
  # using PyPlot
end

# ╔═╡ 6427478f-6f81-4311-8a50-6a3f56c2c7b3
md"""
The following two functions `decomp_step0` and `decomp0` are ephemere in the sense
that, although they seem to give the correct numerical results, unlike in the paper
they are _not_ inplace.

We shall try to have an inplace version of them: `decomp_step0!` and `decomp0!`.
"""

# ╔═╡ ae93f54b-b363-4630-b040-3ae4441f7356
function decomp_step0(c)
  h = length(c)
  c′ = zeros(h)
  half_h = h÷2
  for i in 1:half_h
    c′[i] = (c[2i-1] + c[2i]) / √2
    c′[half_h + i] = (c[2i-1] - c[2i]) / √2
  end
  return c′
end

# ╔═╡ 126d9209-12d6-4de6-ab31-783b5eb28d43
function decomp0(c)
  h = length(c)
  c /=  √h
  while h > 1
    c[1:h] = decomp_step0(c[1:h])
    h ÷= 2
  end
  return c
end

# ╔═╡ b9ddb9a5-9460-42eb-a273-3079977abefa
typeof([1;
	2;
	3;
	4;])

# ╔═╡ 070a04b8-f7b9-4ee5-ab1e-f384c91eca60
1:4

# ╔═╡ 302f6825-4cba-4283-ae9d-a668b40f7f6e
typeof(1:4)

# ╔═╡ 7d997632-bfea-4a82-8346-08119b443ec8
typeof(Array(1:4))

# ╔═╡ f69d1431-0cd3-46dc-8979-cf698fb2f266
size([1,2,3,4]), (4,)

# ╔═╡ 8da15376-abb5-4e1c-9bf0-a0a0d4cb53f1
[1 2 3 4], [1,2,3,4], [1;2;3;4]

# ╔═╡ fc356833-4760-4183-8782-ce44411fa535
typeof([1 2 3 4]), typeof([1,2,3,4]), typeof([1;2;3;4])

# ╔═╡ 2a775497-2415-4d9d-87a9-794c3022e0c7
let
  c = [9 7 3 5]
  c = decomp0(c), [6, 2, 1/√2, -1/√2]
end

# ╔═╡ 2ac27421-041d-4f57-bba9-fb654a22035f
let
  c = [9, 7, 3, 5]
  c = decomp0(c), [6, 2, 1/√2, -1/√2]
end

# ╔═╡ 3110e677-40e2-4473-ac6d-bdb8914c9528
function decomp_step0!(c)
  h = length(c)
  c′ = zeros(h)
  half_h = h÷2
  for i in 1:half_h
    c′[i] = (c[2i-1] + c[2i]) / √2
    c′[half_h + i] = (c[2i-1] - c[2i]) / √2
  end
  #c = c′
  #return c
  #c[:] = c′[:]
  c[:] = c′
end

# ╔═╡ d027e92c-b195-4faf-acc1-6737ea94ba71
let
  c = [1. 2. 3. 4.]
  decomp_step0!(c)
  c
end

# ╔═╡ cbc6185f-a5a1-40fb-a943-bcf023b5074d
function decomp0!(c)
  h = length(c)
  #c /=  √h
  c[:] ./=  √2
  while h > 1
    #c[1:h] = decomp_step0!(c[1:h])
    decomp_step0!(@view c[1:h])
    h ÷= 2
  end
  #return c
end

# ╔═╡ 314837c1-c5c1-4c48-9145-58e1feeb891d
let
  c = [9.,7.,3.,5.]
  decomp0!(c)
  c, [6, 2, 1/√2, -1/√2]
end

# ╔═╡ 9819e5c3-2e76-423a-a6ce-9bc5e77f6d70
typeof([9.,7.,3.,5.]), typeof([9. 7. 3. 5.])

# ╔═╡ b54278c6-f31d-47a2-9090-635e34b4f491
function right_fill!(v, k=2)
  v[:] = [k for i in 1:length(v)]
end

# ╔═╡ 871b8217-e4ee-4d54-82e9-d9f34a408d4d
right_fill!([1,2,3])

# ╔═╡ 48e7c4af-9a29-43da-b389-49e380401050
let
  c = [9.,7.,3.,5.]
  right_fill!(c)
  c
end

# ╔═╡ 19874ba6-4c92-4369-ad1a-4954b6b4751a
function wrong_fill!(v, k=2)
  v = [k for i in 1:length(v)]
end

# ╔═╡ 736f18d5-3cbc-4b95-94a4-475e06ddb44b
wrong_fill!([1,2,3])

# ╔═╡ d3964fa2-76dc-4496-946a-55364bebffe4
let
  c = [9.,7.,3.,5.]
  wrong_fill!(c)
  c
end

# ╔═╡ d1d060c7-b45e-4fa7-8dcc-b6397523849b
function half_fill!(v, k=2)
  u = [k for i in 1:length(v)]
  v[1:length(v)÷2] = u[1:length(v)÷2]
end

# ╔═╡ 641a7b4d-f621-47d8-b84e-64e0581699a4
let
  c = [9.,7.,3.,5.]
  half_fill!(c)
  c
end

# ╔═╡ 84b2bba2-99a8-4b19-bac6-c73e295f54df
function wrong_div_sqrt2!(v)
  #v /= √2
  #v = v/√2
  v[:] ./= √2
  #(@view v) ./= √2
end

# ╔═╡ 592fbd25-0ccd-451d-baa0-49ad5adeadb1
wrong_div_sqrt2!([1.,2.,3.])

# ╔═╡ 876a8ff0-3aa4-4d0d-9fae-43a24aabc46e
let
  c = [1.,2.,3.,4.]
  wrong_div_sqrt2!(c)
  c
end

# ╔═╡ 2c6d0915-8bc9-49a5-a87a-f24540c716e3
let
  c = [1.,2.,3.,4.]
  c / 2 == c[:] ./ 2, c / 2 === c[:] ./ 2, c === c[:] ./ 2, c
end

# ╔═╡ Cell order:
# ╠═91fb6596-f2b1-11eb-1498-093e78301b1f
# ╟─6427478f-6f81-4311-8a50-6a3f56c2c7b3
# ╠═ae93f54b-b363-4630-b040-3ae4441f7356
# ╠═126d9209-12d6-4de6-ab31-783b5eb28d43
# ╠═b9ddb9a5-9460-42eb-a273-3079977abefa
# ╠═070a04b8-f7b9-4ee5-ab1e-f384c91eca60
# ╠═302f6825-4cba-4283-ae9d-a668b40f7f6e
# ╠═7d997632-bfea-4a82-8346-08119b443ec8
# ╠═f69d1431-0cd3-46dc-8979-cf698fb2f266
# ╠═8da15376-abb5-4e1c-9bf0-a0a0d4cb53f1
# ╠═fc356833-4760-4183-8782-ce44411fa535
# ╠═2a775497-2415-4d9d-87a9-794c3022e0c7
# ╠═2ac27421-041d-4f57-bba9-fb654a22035f
# ╠═3110e677-40e2-4473-ac6d-bdb8914c9528
# ╠═d027e92c-b195-4faf-acc1-6737ea94ba71
# ╠═cbc6185f-a5a1-40fb-a943-bcf023b5074d
# ╠═314837c1-c5c1-4c48-9145-58e1feeb891d
# ╠═9819e5c3-2e76-423a-a6ce-9bc5e77f6d70
# ╠═b54278c6-f31d-47a2-9090-635e34b4f491
# ╠═871b8217-e4ee-4d54-82e9-d9f34a408d4d
# ╠═48e7c4af-9a29-43da-b389-49e380401050
# ╠═19874ba6-4c92-4369-ad1a-4954b6b4751a
# ╠═736f18d5-3cbc-4b95-94a4-475e06ddb44b
# ╠═d3964fa2-76dc-4496-946a-55364bebffe4
# ╠═d1d060c7-b45e-4fa7-8dcc-b6397523849b
# ╠═641a7b4d-f621-47d8-b84e-64e0581699a4
# ╠═84b2bba2-99a8-4b19-bac6-c73e295f54df
# ╠═592fbd25-0ccd-451d-baa0-49ad5adeadb1
# ╠═876a8ff0-3aa4-4d0d-9fae-43a24aabc46e
# ╠═2c6d0915-8bc9-49a5-a87a-f24540c716e3
