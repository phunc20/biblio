### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 1883c163-d36b-4277-958c-0f74c6bbfd67
md"""
## 2. Multiresolution Analysis
> Xuất phát điểm của multiresolution analysis là một chuối vector spaces
> ```math
> V_{0} \subset V_{1} \subset V_{2} \subset \cdots
> ```
> Khi ``j`` tăng dần, mức resolution của hàm trong ``V_{j}`` cũng tăng dần theo.
> Các hàm basis cho không gian ``V_{j}`` được gọi là _scaling functions_.
>
> Bước kế tiếp của multiresolutoin analysis là định nghĩa _wavelet spaces_ như sau:
> ```math
> W_{j} \oplus V_{j} = V_{j+1} \quad\forall\; j = 0, 1, 2, \cdots
> ```
> Tức là, ``W_{j}`` là _orthogonal complement_ của ``V_{j}`` trong không gian
> ``V_{j+1}``. Nếu mình chọn cho ``W_{j}`` một basis (tùy ý), thì các hàm trong
> basis đó được gọi là _wavelets_.


"""

# ╔═╡ ac5ef290-081c-11ec-0aac-d1cfd76aa1b0
md"""
### 3.1 B-spline scaling functions
``\underbrace{x_{0} \le \cdots \le x_{k+d+1}}_{k+d+2\;\text{cái}} \in \mathbb{R}``
"""

# ╔═╡ Cell order:
# ╠═1883c163-d36b-4277-958c-0f74c6bbfd67
# ╠═ac5ef290-081c-11ec-0aac-d1cfd76aa1b0
