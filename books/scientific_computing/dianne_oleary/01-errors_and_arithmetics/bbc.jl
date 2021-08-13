### A Pluto.jl notebook ###
# v0.15.1

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
  Pkg.add("PyCall")
  using Plots
  using PlutoUI
  #using LinearAlgebra
  using TikzPictures
  using LaTeXStrings
  using PyCall
  #using SparseArrays
  #using Profile
  using BenchmarkTools
  #using QuadGK
  #using Flux
  #using Zygote: @adjoint
end

# ╔═╡ 1c82aec2-a0c2-474f-92b4-08d3c3e1426c
md"""
## 1.3$(HTML("&ensp;")) Computer Arithmetic
"""

# ╔═╡ 199c0271-c75a-4dc4-b8e8-737f50adcf88
md"""
**(?)** Reason why numbers like ``\frac{1}{10}``, ``\frac{1}{100}``, etc. cannot be expressed as a finite sum of powers of ``2``.

```math
\frac{1}{10} = \sum_{j=-k}^{k} a_{k} 2^{k} \iff
\frac{1}{10} \cdot 2^{k} \cdot 10 = \left(\sum_{j=-k}^{k} a_{k} 2^{k}\right) \cdot 2^{k} \cdot 10 \iff
2^{k} = 10 \cdot \text{sth}

```

"""

# ╔═╡ 63b91e01-d3a8-4f57-ac8c-1c1760a62f49
md"""
- 提到 **fixed-point numbers** ``\implies`` 想到 **整數**
- **computer word** ``\implies`` `4` bytes, i.e. `32` bits of `0`'s and `1`'s
- ``x = \pm z \cdot 2^{p}``
  - ``z``: **mantissa** / **significand**
  - ``p``: **exponent**
  - Normally, we **normalize** so that ``1 \le z \lt 2``.
- **single-precision** numbers 的 single 指的是 single word, i.e. 用一個 word 來儲存一個 實數. 這對應到 Julia 的 `Float32`
  - `24` bits 給 mantissa 揮動
  - `8` bits 給 exponent: ``-126 \le p \le 127``.$(HTML("<br>"))
    **(?)** Why the lower bound is ``-126`` instead of ``-128\,``? ``-127, -128`` 拿去作 ``\pm`` 正負號了?
  - single-precision 所能表示的 **最小正數** 為 ``2^{-126} \approx 2^{-6}\cdot 10^{-36} \approx 0.0156 \cdot 10^{-36} = 1.56 \cdot 10^{-38}``
  - single-precision 所能表示的 **最大正數** 接近 ``2^{128} \approx 2^{-6}\cdot 10^{-36} \approx 0.0156 \cdot 10^{-36} = 1.56 \cdot 10^{-38}``
- 類似地, **double-precision** numbers 是由 兩個 words 組成, 理論上可以排列出 ``2^{64}`` 個不同的實數. Julia's `Float64`
  - `53`-bit mantissa
  - `11`-bit exponent: ``-1022 \le p \le 1023``
  - **最小正數** ``\quad 2^{-1022}``
  - **最大正數** ``\quad 2^{-1024}``

"""

# ╔═╡ 032d32fd-f0d7-4220-9381-38c55be70dda
2^(-126)

# ╔═╡ e0c7d733-2dd8-4b52-a798-ae484bca4988
md"""
**(?)** The ratio of numbers of bits distributed to mantissa and exponent are quite diff btw `Float32` and `Float64`. Any particular reasons?
"""

# ╔═╡ 674d5428-ffe6-4a3c-9ab2-be6a0288e377
7 / 32, 10 / 64

# ╔═╡ e59872f9-315e-4691-bcfb-09131a85b808
0 / 0

# ╔═╡ edf92f48-b728-41ef-9502-3e28a01e7a5b
py"""
0 / 0
"""

# ╔═╡ b82422a7-b28a-4fcf-998e-582e6c59bd86
Float32

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
  \newcommand{\qqquad}{\qquad\qquad\qquad\qquad\qquad\qquad\qquad}
  Ax = b
  ```

  ``\qqquad A = (``
  $(@bind a11 Scrubbable(δrange; format=".7f", default=δ))
  $(@bind a12 Scrubbable(range_; format=".2f", default=1.0))
  ``)``

  ``\phantom{\qqquad A =}(``
  $(@bind a21 Scrubbable(range_; format=".2f", default=1.0))
  $(@bind a22 Scrubbable(range_; format=".2f", default=1.0))
  ``)``

  ``\qqquad b = (``
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

  ``\qqquad\hat{A} = (``
  $(@bind â11 Scrubbable(range_; format=".3f", default=0.661))
  $(@bind â12 Scrubbable(range_; format=".3f", default=0.991))
  ``)``

  ``\phantom{\qqquad\hat{A} =}(``
  $(@bind â21 Scrubbable(range_; format=".3f", default=0.500))
  $(@bind â22 Scrubbable(range_; format=".3f", default=0.750))
  ``)``

  ``\qqquad\hat{b} = (``
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
# ╠═1c82aec2-a0c2-474f-92b4-08d3c3e1426c
# ╟─199c0271-c75a-4dc4-b8e8-737f50adcf88
# ╟─63b91e01-d3a8-4f57-ac8c-1c1760a62f49
# ╠═032d32fd-f0d7-4220-9381-38c55be70dda
# ╟─e0c7d733-2dd8-4b52-a798-ae484bca4988
# ╠═674d5428-ffe6-4a3c-9ab2-be6a0288e377
# ╠═e59872f9-315e-4691-bcfb-09131a85b808
# ╠═edf92f48-b728-41ef-9502-3e28a01e7a5b
# ╠═b82422a7-b28a-4fcf-998e-582e6c59bd86
# ╠═ce66f0b6-d4ca-11eb-3d3a-79e2988c7492
# ╠═7896a3ef-ff1f-4840-86c4-8ec2938936ed
# ╠═ec6cddd4-e060-49c1-9080-cd254e0f3582
# ╠═724c0e7a-8ec2-4f69-9142-5ecb4cb045b9
# ╠═d9ce9c5d-cd96-478f-8efd-b0cf4cc0aca0
# ╟─700b7e6c-ba99-4d83-9d43-5e8f6c9d4593
# ╟─87915587-8625-4081-8178-2a5f22689088
# ╠═c25b185b-76c7-4cd2-a62b-e326fd4bc2fd
# ╠═32bb6296-2171-4680-9823-1a4d479d0328
# ╠═0ecf5691-270e-407e-ad06-a01d6b68a52a
# ╟─6a523141-94ae-461d-afbe-d6f951a15ad8
# ╟─c8840cd1-0ef6-40de-887e-49b2d1d5fd3c
# ╟─7b85f06c-6ef5-4341-9880-3e905379f3bb
# ╠═57843777-7dd2-4360-8acb-acfe4e83b870
