### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ 193762d1-ace4-4840-bba9-dce670d6c3d3


# ╔═╡ dbdf1772-041e-11ec-1e97-3fbdf705f1e9
read(`ls`, String)

# ╔═╡ a17eee3f-98df-4fd9-be83-0a86b750c2ea
readchomp(`ls`)

# ╔═╡ 0957cb93-644c-4ebb-bad9-d31aac317f99
read(`tr -sc "a-zA-Z" "\n" "<" shakespeare.txt`, String)

# ╔═╡ efaca7fa-7461-431a-9e51-f9aa9c601460
md"""
The general syntax for the `tr` command is **`tr [OPTION]... SET1 [SET2]`**. It is used to
> Translate, squeeze, and/or delete characters from standard input, writing to standard output.

In the example in the book,

- `SET1` represents `'a-zA-Z'`
- `SET2` represents `'\n'`

Note that

- The `-c`, `--complement` means complement, similar to the inverse regex `[^a-zA-Z]`
- It seems that the double quotes `"` and the single quote `'` can be used interchangebly; in certain cases, we can
  even omit quotes:
  ```bash
  $ tr -sc A-Za-z '\n' < shakespeare.txt | head -n 3
  First
  Citizen
  Before
  $ tr -sc 'A-Za-z' '\n' < shakespeare.txt | head -n 3
  First
  Citizen
  Before
  $ tr -sc "A-Za-z" '\n' < shakespeare.txt | head -n 3
  First
  Citizen
  Before
  $ tr -sc A-Za-z "\n" < shakespeare.txt | head -n 3
  First
  Citizen
  Before
  $ tr -sc A-Za-z \n < shakespeare.txt | head -c 10
  FirstnCiti$ tr -sc A-Za-z "\n" < shakespeare.txt | head -c 10
  First
  Citi$
  ```
- The `-s` or `--squeeze-repeats` simply **squeezes** any of **multiple neighboring occurrences** to **one** occurrence
  ```bash
  $ echo bbc | tr -s a-z A-Z
  BC
  $ echo cnn | tr -s a-z A-Z
  CN
  $ echo "(a(bc))" | tr -s "()" "[]"
  [a[bc]
  $ tr -c A-Za-z '\n' < shakespeare.txt | head -10
  First
  Citizen
  
  Before
  we
  proceed
  any
  further
  
  hear
  $ tr -sc A-Za-z '\n' < shakespeare.txt | head -10
  First
  Citizen
  Before
  we
  proceed
  any
  further
  hear
  me
  speak
  $ tr -c A-Za-z ' ' < shakespeare.txt | tail -c 100; printf "\n"
  TONIO  Noble Sebastian  Thou let st thy fortune sleep  die  rather  wink st Whiles thou art waking
  ```
- complete usage
  ```bash
  $ tr -sc A-Za-z '\n' < shakespeare.txt | tr A-Z a-z | sort | uniq -c | sort -n -r | wc -l
  11455
  $ tr -sc A-Za-z '\n' < shakespeare.txt | tr A-Z a-z | sort | uniq -c | sort -nr | head -10
     6287 the
     5690 and
     5111 i
     4934 to
     3760 of
     3211 you
     3120 my
     3018 a
     2664 that
     2403 in
  
  ```
"""

# ╔═╡ 0e0ae3c8-24a5-4d64-aa43-1e94652e5bad
md"""
## Minimum Edit Distance
我們想要定義兩個字串 (strings) 之間的距離. 有人就這麼定義: _從字串 `X` 變到字串 `Y` 所需要的操作總共多少步_. 其中一組普遍的操作爲

- 刪除 (delete) 一個字母, 花費爲 ``1``
    - 例: 從 `拖鞋` 到 `鞋`, 我們得刪除一個字, 所以 距離/花費 ``= 1``
- 新增 (insert) 一個字母, 花費爲 ``1``
    - 例: 從 `電腦` 到 `筆記型電腦`, 我們得新增三個字, 所以 距離/花費 ``= 3``
- 替代 (substitute) 一個字母, 花費爲 `2`
    - 例: 從 `戶愚呂` 到 `戶愚弟`, 我們得把 ``兄`` 替代成 ``弟``, 所以 距離/花費 ``= 2``
    - 其實 (替代) 可以由 ``(``一個刪除 ``+`` 一個新增``)`` 來完成, 所以花費爲 ``2`` 很合理


I would like to show the following things

01. The formula is correct:
    ```math
    \newcommand{\abs}[1]{\lvert{#1}\rvert}
    D[i, j] = \min \begin{cases}
        D[i-1, j] + \texttt{del}(X[i]) \\
        D[i, j-1] + \texttt{ins}(Y[j]) \\
        D[i-1, j-1] + \texttt{sub}(X[i], Y[j])
    \end{cases}
    ```
    In particular,
    - If ``X[i] \ne Y[j]``, then ``D[i, j] \gneq D[i-1, j-1]``.
    - For all ``i, j \ge 1``,
      ```math
      \begin{align}
          0 \lneq \abs{D[i-1, j] - D[i-1, j-1]} \le 1 \\
          0 \lneq \abs{D[i, j-1] - D[i-1, j-1]} \le 1
      \end{align}
      ```
      That is, going downward or going rightward will only encounter a number either greater by ``1`` or smaller by ``1``.
02. ``d(X, Y) = d(Y, X)`` for any strings ``X, Y``


"""

# ╔═╡ Cell order:
# ╠═193762d1-ace4-4840-bba9-dce670d6c3d3
# ╠═dbdf1772-041e-11ec-1e97-3fbdf705f1e9
# ╠═a17eee3f-98df-4fd9-be83-0a86b750c2ea
# ╠═0957cb93-644c-4ebb-bad9-d31aac317f99
# ╟─efaca7fa-7461-431a-9e51-f9aa9c601460
# ╠═0e0ae3c8-24a5-4d64-aa43-1e94652e5bad
