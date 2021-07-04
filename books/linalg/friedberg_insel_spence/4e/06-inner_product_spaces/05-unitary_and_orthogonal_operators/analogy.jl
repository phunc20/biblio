### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ ec64db90-dc99-11eb-34a4-bf1d6e213ed9
md"""
## Analogy btw Complex Numbers and Linear Operators
In previous sections we have observed the analogy btw complex numbers and linear operators.
We are going to extend this observation further in this section.


| ``\mathbb{C}`` | linear operators |
|---|---|
| ``z\bar{z} = 1`` | ``TT^{*} = T^{*}T = I`` |
| ``\lvert{}z\rvert = 1`` | ``\lVert{}T\rVert = 1`` |



Let  ``z \in \mathbb{C}\,.`` Define
```math
\begin{align}
  M_{z}: &\mathbb{C} \to \mathbb{C} \\
         &w \mapsto zw
\end{align}\,.
```
Then

- ``M_{z}`` is a linear operator on ``\mathbb{C}``, which we often identifies with the complex number ``z``
- ``M_{1} = \text{id}_{\mathbb{C}}``
"""

# ╔═╡ Cell order:
# ╟─ec64db90-dc99-11eb-34a4-bf1d6e213ed9
