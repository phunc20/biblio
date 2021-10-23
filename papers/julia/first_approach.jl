### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ 2df19294-33ed-11ec-37b3-7b581a408483
begin
  add(x::Int, y::Int) = x + y
  vaddsd(x::Float64, y::Float64) = x + y
  vcvtsi2sd(x::Int) = float(x)
end

# ╔═╡ 1b20fde0-cd41-44d4-b7e7-f5fedf493a89
begin
  ⊕(x::Int, y::Int) = add(x, y)
  ⊕(x::Float64, y::Float64) = vaddsd(x, y)
  ⊕(x::Int, y::Float64) = vaddsd(vcvtsi2sd(x), y)
  ⊕(x::Float64, y::Int) = y ⊕ x
end

# ╔═╡ 5e05a424-6d93-44ad-a2a9-1f9703f250d2
methods(⊕)

# ╔═╡ 2bd6874a-b455-4270-b155-8365e8cfa7b7
3 ⊕ 4

# ╔═╡ b465e81d-5c5b-4022-8037-9bf85a5b9274
2.7 ⊕ 1

# ╔═╡ 9229a29f-fa68-454a-a914-11fa7227987d
@code_native 3 ⊕ 4

# ╔═╡ bcece6c0-cbe9-4884-9466-bc76a849274d
f(a, b) = a + b

# ╔═╡ aa994435-fa67-4948-a9e2-c5739dedc7cb
@code_native f(2, 3)

# ╔═╡ Cell order:
# ╠═2df19294-33ed-11ec-37b3-7b581a408483
# ╠═1b20fde0-cd41-44d4-b7e7-f5fedf493a89
# ╠═5e05a424-6d93-44ad-a2a9-1f9703f250d2
# ╠═2bd6874a-b455-4270-b155-8365e8cfa7b7
# ╠═b465e81d-5c5b-4022-8037-9bf85a5b9274
# ╠═9229a29f-fa68-454a-a914-11fa7227987d
# ╠═bcece6c0-cbe9-4884-9466-bc76a849274d
# ╠═aa994435-fa67-4948-a9e2-c5739dedc7cb
