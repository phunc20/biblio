### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 80c1a74e-0c78-11ec-0b9b-f538bd808b54
md"""
### Base58
Base58 is like Base16, a way to denote numbers. Base58 is monero's way to efficiently denote big numbers by
alphanumeric characters, both uppercase and lowercase. So there are `26*2 = 52` English characters and `10`
arabic numbers (`0,1,2,...,9`), which should give a total of `62`. Why named Base58?

> Because several visually ambiguous characters are removed. More precisely,
> they are `0` (zero) and `O` (uppercase Oh), `I` (uppercase i) and `l` (lowercase L).
> This gives a total of `62 - 4 = 58` characters.

"""

# ╔═╡ Cell order:
# ╟─80c1a74e-0c78-11ec-0b9b-f538bd808b54
