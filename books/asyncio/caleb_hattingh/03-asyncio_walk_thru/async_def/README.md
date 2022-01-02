The `inspect` module has some more fine-grained examining functions than the sheer `type()`:

- `inspect.isgenerator()`
- `inspect.isgeneratorfunction()`
- `inspect.iscoroutine()`
- `inspect.iscoroutinefunction()`

```python
In [1]: def f():
   ...:     return 123
   ...:
In [1]: def f():
   ...:     return 123
   ...:

In [2]: def g():
   ...:     yield 123
   ...:

In [3]: async def h():
   ...:     return 123
   ...:

In [4]: type(f), type(f())
Out[4]: (function, int)

In [5]: type(g), type(g())
Out[5]: (function, generator)

In [6]: type(h), type(h())
<ipython-input-6-dcf74314e798>:1: RuntimeWarning: coroutine 'h' was never awaited
  type(h), type(h())
RuntimeWarning: Enable tracemalloc to get the object allocation traceback
Out[6]: (function, coroutine)

In [7]: import inspect

In [10]: inspect.isfunction(f)
Out[10]: True

In [11]: inspect.isfunction(g), inspect.isfunction(g()), inspect.isfunction(h), inspect.isfunction(h())
<ipython-input-11-660558dd3def>:1: RuntimeWarning: coroutine 'h' was never awaited
  inspect.isfunction(g), inspect.isfunction(g()), inspect.isfunction(h), inspect.isfunction(h())
RuntimeWarning: Enable tracemalloc to get the object allocation traceback
Out[11]: (True, False, True, False)

In [12]: inspect.isgenerator(g), inspect.isgeneratorfunction(g)
Out[12]: (False, True)

In [13]: inspect.isgenerator(g()), inspect.isgeneratorfunction(g())
Out[13]: (True, False)

In [14]: inspect.iscoroutine(h), inspect.iscoroutinefunction(h)
Out[14]: (False, True)

In [15]: inspect.iscoroutine(h()), inspect.iscoroutinefunction(h())
<ipython-input-15-b02c3b1dc709>:1: RuntimeWarning: coroutine 'h' was never awaited
  inspect.iscoroutine(h()), inspect.iscoroutinefunction(h())
RuntimeWarning: Enable tracemalloc to get the object allocation traceback
Out[15]: (True, False)
```

**Rmk.** The above `RuntimeWarning` will not appear, had we assign the coroutine to a variable:

```python
In [16]: coro = h()

In [17]: type(coro)
Out[17]: coroutine

In [18]: inspect.iscoroutine(coro)
Out[18]: True
```
