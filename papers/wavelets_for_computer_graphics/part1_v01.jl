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
  using PlutoUI
end

# ╔═╡ 6427478f-6f81-4311-8a50-6a3f56c2c7b3
md"""
The following two functions `decomp_step0` and `decomp0` are ephemere in the sense
that, although they seem to give the correct numerical results,
they are _not_ inplace (unlike in the paper).

Later on, we shall try to have an inplace version of them: `decomp_step0!` and `decomp0!`.
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

# ╔═╡ 2a775497-2415-4d9d-87a9-794c3022e0c7
let
  c = [9 7 3 5]
  c = decomp0(c), [6 2 1/√2 -1/√2]
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

# ╔═╡ 8e2fd3cd-e89a-481a-92aa-2f56b9c62787
md"""
Because this is error-prone, let's devise a test for our implementation of `decomp_test0!`
"""

# ╔═╡ d027e92c-b195-4faf-acc1-6737ea94ba71
let
  c = [1. 2. 3. 4.]
  decomp_step0!(c)
  c, [(1.0+2.0)/√2 (3.0+4.0)/√2 (1.0-2.0)/√2 (3.0-4.0)/√2]
end

# ╔═╡ 0db9da60-8158-4d16-9a8d-f1941d5bc208
md"""
Great. Our implementation seems to be correct.
"""

# ╔═╡ cbc6185f-a5a1-40fb-a943-bcf023b5074d
function decomp0!(c)
  h = length(c)
  #c /=  √h  # It's bad to write this way, because it's no longer inplace.
  c[:] /=  √h
  while h > 1
    #decomp_step0!(c[1:h])  # Similarly, this is not an inplace implementation.
    decomp_step0!(@view c[1:h])
    h ÷= 2
  end
end

# ╔═╡ 316f8b1f-dc83-416f-812d-ffa90d1ad6e6
md"""
Note that

- instead of `c /=  √h`
- we wrote  `c[:] /=  √h`

and

- instead of `decomp_step0!(c[1:h])`
- we wrote  `decomp_step0!(@view c[1:h])`

These are implementation details when we implement inplace/bang functions.

**Rmk.**$(HTML("<br>"))
I named this bang functions with a `0` at the end, because we might come up with even better implementations.
"""

# ╔═╡ a6f1deb3-d15c-47e2-a931-1065c9f2c267
let
  with_terminal() do
    c = [1.,2.,3.,4.]
    println("(Before)")
    println("objectid(c) = $(objectid(c))")
    println("c = $c\n")

    c[:] *= 2
    println("(After)")
    println("objectid(c) = $(objectid(c))")
    println("c = $c")
  end
end

# ╔═╡ b8d01a36-76c8-4df3-aa04-3a68801aa789
let
  with_terminal() do
    c = [1.,2.,3.,4.]
    println("(Before)")
    println("objectid(c) = $(objectid(c))")
    println("c = $c\n")

    c *= 2
    println("(After)")
    println("objectid(c) = $(objectid(c))")
    println("c = $c")
  end
end

# ╔═╡ 57367524-9778-44ea-a7cb-7f8fab678256
let
  with_terminal() do
    c = [1.,2.,3.,4.]
    println("(Before)")
    println("objectid(c) = $(objectid(c))")
    println("c = $c\n")

    c[:] .= 2
    println("(After)")
    println("objectid(c) = $(objectid(c))")
    println("c = $c")
  end
end

# ╔═╡ 8ed2ce7e-b78a-4e91-a934-b2b82a1111c8
let
  with_terminal() do
    c = [1.,2.,3.,4.]
    println("(Before)")
    println("objectid(c) = $(objectid(c))")
    println("c = $c\n")

    c .= 2
    println("(After)")
    println("objectid(c) = $(objectid(c))")
    println("c = $c")
  end
end

# ╔═╡ 4a1952ec-e796-4f58-ad54-62bd49d79dbd
let
  with_terminal() do
    c = [1.,2.,3.,4.]
    println("(Before)")
    println("objectid(c) = $(objectid(c))")
    println("c = $c\n")

    c[:] = fill(2, (4,))
    println("(After)")
    println("objectid(c) = $(objectid(c))")
    println("c = $c")
  end
end

# ╔═╡ 89ac02a7-6751-4c13-b15b-aa9d851b442b
let
  with_terminal() do
    c = [1.,2.,3.,4.]
    println("(Before)")
    println("objectid(c) = $(objectid(c))")
    println("c = $c\n")

    c = fill(2, (4,))
    println("(After)")
    println("objectid(c) = $(objectid(c))")
    println("c = $c")
  end
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


# ╔═╡ Cell order:
# ╠═91fb6596-f2b1-11eb-1498-093e78301b1f
# ╟─6427478f-6f81-4311-8a50-6a3f56c2c7b3
# ╠═ae93f54b-b363-4630-b040-3ae4441f7356
# ╠═126d9209-12d6-4de6-ab31-783b5eb28d43
# ╠═2a775497-2415-4d9d-87a9-794c3022e0c7
# ╠═2ac27421-041d-4f57-bba9-fb654a22035f
# ╠═3110e677-40e2-4473-ac6d-bdb8914c9528
# ╟─8e2fd3cd-e89a-481a-92aa-2f56b9c62787
# ╠═d027e92c-b195-4faf-acc1-6737ea94ba71
# ╟─0db9da60-8158-4d16-9a8d-f1941d5bc208
# ╠═cbc6185f-a5a1-40fb-a943-bcf023b5074d
# ╟─316f8b1f-dc83-416f-812d-ffa90d1ad6e6
# ╠═a6f1deb3-d15c-47e2-a931-1065c9f2c267
# ╠═b8d01a36-76c8-4df3-aa04-3a68801aa789
# ╠═57367524-9778-44ea-a7cb-7f8fab678256
# ╠═8ed2ce7e-b78a-4e91-a934-b2b82a1111c8
# ╠═4a1952ec-e796-4f58-ad54-62bd49d79dbd
# ╠═89ac02a7-6751-4c13-b15b-aa9d851b442b
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
