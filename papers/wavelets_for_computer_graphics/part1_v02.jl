### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ b4831962-0a77-11ec-3e5b-ed31918b069d
md"""
## One-Dimensional Haar Wavelet Basis
Hình ảnh một chiều (1D images) có thể được coi như là piecewise constant function
trên half-open interval ``[0, 1)``. Chẳng hạn như,

- một ảnh cồm duy nhất một pixel
  được coi như là một hàm constant trên cả ``[0, 1)``;
  tập của tất cả những hàm này mình sẽ ghi là ``V_{0}``
- một ảnh cồm 2 pixel thì được coi như là một hàm constant
  trên ``[0, \frac{1}{2})`` và (có thể là một constant khác)
  trên ``[\frac{1}{2}, 1)``; tập của những hàm như vậy được ghi là ``V_{1}``
- Bạn chắc đã nắm được nguyên tắc ở đây rồi: Mình sẽ ghi bằng ``V_{j}``, tập
  của tất cả các hàm constant trên mỗi subinterval
  ``[\frac{i}{2^j}, \frac{i+1}{2^j})``, ``i = 0, 1, 2, \ldots, 2^j - 1``.$(HTML("<br>"))
  Tức là một ảnh cồm ``2^j`` pixels.

> Có thể sẽ có bạn như mình muốn hỏi về lý do vì sao ban đầu chọn _half-open_ interval
> ``[0, 1)``? Trả lời của mình là lựa chọn này khiến cho các subinterval đối xứng hơn,
> công bằng hơn, vì như vậy subinterval nào cũng sẽ theo dạng _bên trái đóng, bên phải mở_.
> Với, để đặc được nested vector spaces
> ```math
> V_0 < V_1 < V_2 < \cdots 
> ```
> mình cũng đã cố tình chọn số lượng của subinterval luôn là mũ của ``2``.
"""

# ╔═╡ Cell order:
# ╟─b4831962-0a77-11ec-3e5b-ed31918b069d
