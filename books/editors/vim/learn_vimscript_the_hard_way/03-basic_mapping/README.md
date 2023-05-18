## Tricks
- `-` moves cursor to prev line, the first non-blank char or
  right after `^` in case the line is empty
    - Of course, one could add a number before it, e.g. `10-` jumps
      10 lines up
- `+` the converse of `-`
- `viw` in normal mode selects a word
    - Note that this is diff from `vw` in normal mode, which selects up until
      the first character of the next word
    - Besides, `viw` can be used from any character inside a word. It will
      always select the whole word. For example, the word `posthumous`,
      if your cursor is on the character `t` and you typt `viw` in normal
      mode, then the whole word of `posthumous` will get selected (in visual
      mode).


## Q&A
1. How do we have vim memorize `-`'s default effect so that we could
   switch back to default after mapping `:map - x`?
    - No need to memorize; just `:unmap -`


## Exercises
1. The mappings I found out to move a line downward and upward are
   ```vim
   :map - ddp
   :map _ ddkP
   ```
