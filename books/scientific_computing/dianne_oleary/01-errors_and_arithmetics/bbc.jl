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
## 1.7$(HTML("&ensp;")) Conditioning and Stability
"""

# ╔═╡ 7896a3ef-ff1f-4840-86c4-8ec2938936ed
[(10.)^k for k=-9:-1]

# ╔═╡ ec6cddd4-e060-49c1-9080-cd254e0f3582
md"""
`δ` = $(@bind δ Slider(1e-5:1e-5:1e-3, show_value=true, default=1e-5))
"""

# ╔═╡ 724c0e7a-8ec2-4f69-9142-5ecb4cb045b9
δrange = range(δ,1,step=δ)

# ╔═╡ d9ce9c5d-cd96-478f-8efd-b0cf4cc0aca0
let
  #δrange = range(1e-6, 1e-2; length=100)
  #δrange = [10.0^(i) for i in range(-6,0,step=δ)]
  δrange = range(δ,1,step=δ)
  #δrange = range(δ, 1;length=10)
  range_ = -1:.01:2

  md"""

  ```math
  Ax = b
  ```

  ``A =``

  ``(``
  $(@bind a11 Scrubbable(δrange; format=".7f", default=δ))
  $(@bind a12 Scrubbable(range_; format=".2f", default=1.0))
  ``)``

  ``(``
  $(@bind a21 Scrubbable(range_; format=".2f", default=1.0))
  $(@bind a22 Scrubbable(range_; format=".2f", default=1.0))
  ``)``

  ``b =``
  ``(``
  $(@bind b1 Scrubbable(range_; format=".2f", default=1.0))
  $(@bind b2 Scrubbable(range_; format=".2f", default=0.0))
  ``)^T``
  """
end

# ╔═╡ 87915587-8625-4081-8178-2a5f22689088
md"""
**Rmk.** 值得注意的是, 即便我們將 `a,b,c,d` 定義在以 `let` 起始的 cell 裏, 我們依然可以在其他 cells 裏使用同一個 `a,b,c,d`. 這是因爲 `@bind` 的緣故.
"""

# ╔═╡ c25b185b-76c7-4cd2-a62b-e326fd4bc2fd


# ╔═╡ 32bb6296-2171-4680-9823-1a4d479d0328


# ╔═╡ 0ecf5691-270e-407e-ad06-a01d6b68a52a


# ╔═╡ 6a523141-94ae-461d-afbe-d6f951a15ad8
let
  range_ = -0:.001:1.5
  md"""
  ```math
  \hat{A}x = \hat{b}
  ```

  ``\hat{A} =``

  ``(``
  $(@bind â11 Scrubbable(range_; format=".3f", default=0.661))
  $(@bind â12 Scrubbable(range_; format=".3f", default=0.991))
  ``)``

  ``(``
  $(@bind â21 Scrubbable(range_; format=".3f", default=0.500))
  $(@bind â22 Scrubbable(range_; format=".3f", default=0.750))
  ``)``

  ``\hat{b} =``
  ``(``
  $(@bind b̂1 Scrubbable(range_; format=".3f", default=0.330))
  $(@bind b̂2 Scrubbable(range_; format=".3f", default=0.250))
  ``)^T``
  """
end


# ╔═╡ 7b85f06c-6ef5-4341-9880-3e905379f3bb
md"""
試着調整 ``\hat{A}`` 或 ``\hat{b}`` 的值玩玩看. 有些組合會使得交點有大幅度的跳動, 
這就是所謂的 $(HTML("<br>"))
**ill-condtioned** problem/matrix.

"""

# ╔═╡ 57843777-7dd2-4360-8acb-acfe4e83b870
function y(a,b,c)
  # a*x + b*y = c
  return x -> (c - a*x) / b
end

# ╔═╡ 700b7e6c-ba99-4d83-9d43-5e8f6c9d4593
let
  x = range(-2,0;step=0.2)
  lw = 3
  A = [a11 a12
	   a21 a22]
  b = [b1
	   b2]
  sol = A \ b
  plot(
    x,
    y(a11,a12,b1).(x),
    #linealpha=alpha,
    linewidth=lw,
    xlim=(-2, 0),
    ylim=(0, 2),
    #xticks=range(0,1;length=M),
    #yticks=range(0,1;length=M),
    aspect_ratio=:equal,
    label="$(a11)x + $(a12)y = $(b1)",
    #legend=:topleft,
    background_color=:black,
    title="well-conditioned",
  )
  plot!(
    x,
    y(a21,a22,b2).(x),
    linewidth=lw,
    label="$(a21)x + $(a22)y = $(b2)",
  )
  plot!(
    sol[1:1],
    sol[2:2],
    marker=:o,
    label="intersection",
  )
end

# ╔═╡ c8840cd1-0ef6-40de-887e-49b2d1d5fd3c
let
  l = 10
  x = range(-l,l;step=0.2)
  lw = 3
  Â = [â11 â12
	   â21 â22]
  b̂ = [b̂1
	   b̂2]
  sol = Â \ b̂
  plot(
    x,
    y(â11,â12,b̂1).(x),
    #linealpha=alpha,
    linewidth=lw,
    xlim=(-l, l),
    ylim=(-l, l),
    #xticks=range(0,1;length=M),
    #yticks=range(0,1;length=M),
    aspect_ratio=:equal,
    label="$(â11)x + $(â12)y = $(b̂1)",
    #legend=:topleft,
    background_color=:black,
    title="ill-conditioned",
  )
  plot!(
    x,
    y(â21,â22,b̂2).(x),
    linewidth=lw,
    label="$(â21)x + $(â22)y = $(b̂2)",
  )
  plot!(
    sol[1:1],
    sol[2:2],
    marker=:o,
    label="intersection",
  )
end

# ╔═╡ Cell order:
# ╠═26bd4dbe-b692-427a-acba-8e89544eeea6
# ╠═ce66f0b6-d4ca-11eb-3d3a-79e2988c7492
# ╠═7896a3ef-ff1f-4840-86c4-8ec2938936ed
# ╠═ec6cddd4-e060-49c1-9080-cd254e0f3582
# ╠═724c0e7a-8ec2-4f69-9142-5ecb4cb045b9
# ╟─d9ce9c5d-cd96-478f-8efd-b0cf4cc0aca0
# ╟─700b7e6c-ba99-4d83-9d43-5e8f6c9d4593
# ╟─87915587-8625-4081-8178-2a5f22689088
# ╠═c25b185b-76c7-4cd2-a62b-e326fd4bc2fd
# ╠═32bb6296-2171-4680-9823-1a4d479d0328
# ╠═0ecf5691-270e-407e-ad06-a01d6b68a52a
# ╟─6a523141-94ae-461d-afbe-d6f951a15ad8
# ╟─c8840cd1-0ef6-40de-887e-49b2d1d5fd3c
# ╟─7b85f06c-6ef5-4341-9880-3e905379f3bb
# ╠═57843777-7dd2-4360-8acb-acfe4e83b870
