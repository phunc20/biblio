### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# ╔═╡ f03b74e6-6df4-4403-bc90-64413c1a03f2
begin
  using LinearAlgebra
  using PlutoUI
end

# ╔═╡ e60686d0-2f08-11ec-3013-6d58c09efb0b
md"""
## Adjacency Matrix
On p.2, Mr. Butler mentioned that relabeling the vertice indices changes the adjacency matrix but the eigenvalues remain the same. Let's explain this in clearer details by ourselves.

Let ``A`` be an adjacency matrix of some graph ``G``. This means that we have decided a labeling of the vertices, i.e. we have decided IDs ``1, 2, 3, \ldots, n`` to the ``n`` vertices of ``G``. A relabeling of the vertices means choosing a permutation ``\xi: \{1, 2, 3, \ldots, n\} \to \{1, 2, 3, \ldots, n\}``. This gives a corresponding adjacency matrix ``B``. And we would naturally like to know the relationship btw ``A`` and ``B``, which might help us explain why their eigenvalues should be the same. Below is an example where ``n = 3``.

$$\begin{array}{ |c|c|c|c| } \hline & \xi(1) & \xi(2) & \xi{}(3) \\ \hline \xi(1) & & & \\ \hline \xi(2) & & & \\ \hline \xi(3) & & & \\ \hline \end{array}$$

If we sit down and think, then this is actually not too hard
> - Permuting columns of ``A`` corresponds to permuting the their columns IDs
> - Similarly, the same goes for permuting rows
> - ``B`` can be obtained from ``A`` by first permuting the columns then permuting the rows, i.e. ``\exists \;\text{permutation matrix}\; P\; \text{s.t.}\; B = PAP^{T}``

Now, let ``Ax = \lambda x``, where ``x \ne 0``. Since ``P^{T} = P^{-1}``, we have
```math
B(Px) = (PAP^{T})(Px) = \lambda (Px).
```
That is, ``\lambda`` is an eigenvalue of both ``A`` and ``B`` (with eigenvectors ``x`` and ``Px``, resp.)
"""

# ╔═╡ 2515412a-04ec-44e1-95ea-74eea0cb731e
md"""
## Saltire Pair
The Saltire pair is an example of two non isomorphic graphs with the same set of eigenvalues. The following matrices are their adjacency matrices.

"""

# ╔═╡ 15eef2f1-5d89-4bd0-b7bf-6991df806318
saltire_pair = (
  [0 0 0 0 0
   0 0 1 0 1
   0 1 0 1 0
   0 0 1 0 1
   0 1 0 1 0],
  [0 1 1 1 1
   1 0 0 0 0
   1 0 0 0 0
   1 0 0 0 0
   1 0 0 0 0])

# ╔═╡ d4de616b-3e18-47db-8759-086f96998590
eigvals(saltire_pair[1])

# ╔═╡ cbd806be-9a4e-4315-8c69-993a394624b3
eigvals(saltire_pair[2])

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
PlutoUI = "~0.7.16"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[HypertextLiteral]]
git-tree-sha1 = "f6532909bf3d40b308a0f360b6a0e626c0e263a8"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.1"

[[IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[Parsers]]
deps = ["Dates"]
git-tree-sha1 = "98f59ff3639b3d9485a03a72f3ab35bab9465720"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.6"

[[PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "4c8a7d080daca18545c56f1cac28710c362478f3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.16"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═f03b74e6-6df4-4403-bc90-64413c1a03f2
# ╟─e60686d0-2f08-11ec-3013-6d58c09efb0b
# ╟─2515412a-04ec-44e1-95ea-74eea0cb731e
# ╠═15eef2f1-5d89-4bd0-b7bf-6991df806318
# ╠═d4de616b-3e18-47db-8759-086f96998590
# ╠═cbd806be-9a4e-4315-8c69-993a394624b3
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
