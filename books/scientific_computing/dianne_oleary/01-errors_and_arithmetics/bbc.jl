### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ 26bd4dbe-b692-427a-acba-8e89544eeea6
begin
  using Pkg
  #Pkg.activate(Base.Filesystem.homedir() * "/.config/julia/projects/oft")
  Pkg.activate("../../../../.julia_env/oft")
  using Plots
  using PlutoUI
  #using LinearAlgebra
  using TikzPictures
  using LaTeXStrings
  #using SparseArrays
  #using Profile
  using BenchmarkTools
  #using QuadGK
  #using Flux
  #using Zygote: @adjoint
end

# ╔═╡ ce66f0b6-d4ca-11eb-3d3a-79e2988c7492
md"""
## 1.7  Conditioning and Stability
"""

# ╔═╡ 7896a3ef-ff1f-4840-86c4-8ec2938936ed
[(10.)^k for k=-9:-1]

# ╔═╡ ec6cddd4-e060-49c1-9080-cd254e0f3582
md"""
`δ` = $(@bind δ Slider(1e-6:1e-6:1e-3, show_value=true, default=1e-6))
"""

# ╔═╡ 89a32942-b10c-4b07-b87a-a2a3cc1c2cdc
range(0,1;length=10)

# ╔═╡ d9ce9c5d-cd96-478f-8efd-b0cf4cc0aca0
let
  #δrange = range(1e-6, 1e-2; length=100)
  δrange = [10.0^(i) for i in -6:-2]
  #δrange = range(δ, 1;length=10)
  range_ = 0:.01:2
  md"""
  This is a "scrubbable" matrix: click on the number and drag to change!

  ``A_{\text{perturbed}} =``

  ``(``
  $(@bind a Scrubbable(δrange; format=".6f", default=10^(-4)))
  $(@bind b Scrubbable(range_; format=".2f", default=1.0))
  ``)``

  ``(``
  $(@bind c Scrubbable(range_; format=".2f", default=1.0))
  $(@bind d Scrubbable(range_; format=".2f", default=1.0))
  ``)``
  """
end

# ╔═╡ 12c59d4c-0c5b-42b6-9192-54e0fa884647
md"""
``A_{0,0} =\,`` $a
"""

# ╔═╡ 87915587-8625-4081-8178-2a5f22689088
md"""
**Rmk.** 值得注意的是, 即便我們將 `a,b,c,d` 定義在以 `let` 起始的 cell 裏, 我們依然可以在其他 cells 裏使用同一個 `a,b,c,d`. 這是因爲 `@bind` 的緣故.
"""

# ╔═╡ 57843777-7dd2-4360-8acb-acfe4e83b870
function y(a,b,c)
  # a*x + b*y = c
  return x -> (c - a*x) / b
end

# ╔═╡ 700b7e6c-ba99-4d83-9d43-5e8f6c9d4593
let
  b1, b2 = 1, 0
  x = range(-2,0;step=0.2)
  plot(
    x,
    y(a,b,b1).(x),
    #linealpha=alpha,
    #linewidth=lw,
    xlim=(-2, 0),
    ylim=(0, 2),
    #xticks=range(0,1;length=M),
    #yticks=range(0,1;length=M),
    aspect_ratio=:equal,
    #label="ϕ1",
    #legend=:topleft,
    background_color=:black,
    #title="M = $M",
  )
  plot!(
    x,
    y(c,d,b2).(x),
  )
end

# ╔═╡ c25b185b-76c7-4cd2-a62b-e326fd4bc2fd
let
  b1, b2 = 1, 0
  x = range(-2,0;step=0.2)
  plot(
    x,
    y(a,b,c).(x),
    #linealpha=alpha,
    #linewidth=lw,
    #xlim=(0,1.1),
    #xticks=range(0,1;length=M),
    #yticks=range(0,1;length=M),
    aspect_ratio=:equal,
    #label="ϕ1",
    label=false,
    #legend=:topleft,
    background_color=:black,
    #title="M = $M",
  )
end

# ╔═╡ Cell order:
# ╠═26bd4dbe-b692-427a-acba-8e89544eeea6
# ╠═ce66f0b6-d4ca-11eb-3d3a-79e2988c7492
# ╠═7896a3ef-ff1f-4840-86c4-8ec2938936ed
# ╟─ec6cddd4-e060-49c1-9080-cd254e0f3582
# ╠═89a32942-b10c-4b07-b87a-a2a3cc1c2cdc
# ╠═d9ce9c5d-cd96-478f-8efd-b0cf4cc0aca0
# ╟─12c59d4c-0c5b-42b6-9192-54e0fa884647
# ╠═700b7e6c-ba99-4d83-9d43-5e8f6c9d4593
# ╟─87915587-8625-4081-8178-2a5f22689088
# ╠═c25b185b-76c7-4cd2-a62b-e326fd4bc2fd
# ╠═57843777-7dd2-4360-8acb-acfe4e83b870
