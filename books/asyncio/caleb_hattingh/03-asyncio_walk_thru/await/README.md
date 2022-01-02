## `send(None)` and `StopIteration` Error
The following is an IPython session run with Python 3.7.3.

```python
In [15]: import asyncio
    ...: async def less():
    ...:     return 123
    ...:
    ...: async def more():
    ...:     await asyncio.sleep(1)
    ...:     return 123
    ...:

In [16]: coro = less()

In [17]: coro.send()
---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
<ipython-input-17-cb2a4d67e2d2> in <module>
----> 1 coro.send()

TypeError: send() takes exactly one argument (0 given)

In [18]: coro.send(None)
---------------------------------------------------------------------------
StopIteration                             Traceback (most recent call last)
<ipython-input-18-9cc02a983a52> in <module>
----> 1 coro.send(None)

StopIteration: 123

In [19]: coro = more()

In [20]: coro.send(None)
Out[20]: <Future pending>

In [21]: coro.send(None)
---------------------------------------------------------------------------
RuntimeError                              Traceback (most recent call last)
<ipython-input-21-9cc02a983a52> in <module>
----> 1 coro.send(None)

<ipython-input-15-a1929c4df930> in more()
     12
     13 async def more():
---> 14     await asyncio.sleep(1)
     15     return 123

/usr/lib/python3.7/asyncio/tasks.py in sleep(delay, result, loop)
    566                         future, result)
    567     try:
--> 568         return await future
    569     finally:
    570         h.cancel()

RuntimeError: await wasn't used with future
```

I thought we could have `send(None)` as many times as we want as long as there is an `await asyncio.sleep()`.

```python
In [1]: import asyncio
   ...: async def f():
   ...:     try:
   ...:         while True: await asyncio.sleep(0)
   ...:     except asyncio.CancelledError:
   ...:         print("I was cancelled!")
   ...:     else:
   ...:         return 111
   ...:
   ...:
   ...:

In [2]: coro = f()

In [3]: coro.send(None)

In [4]: coro.send(None)

In [5]: coro.send(None)

In [6]: coro.send(None)
^[[A
In [7]: coro.send(None)

In [8]: coro.throw(asyncio.CancelledError)
I was cancelled!
---------------------------------------------------------------------------
StopIteration                             Traceback (most recent call last)
<ipython-input-8-13d4d12447ff> in <module>
----> 1 coro.throw(asyncio.CancelledError)

StopIteration:

In [9]: coro = f()  # try to throw() before ever doing send(None)

In [10]: coro.throw(asyncio.CancelledError, 999)
---------------------------------------------------------------------------
CancelledError                            Traceback (most recent call last)
<ipython-input-10-1e8ecc421f15> in <module>
----> 1 coro.throw(asyncio.CancelledError, 999)

<ipython-input-1-21d48a204994> in f()
      1 import asyncio
----> 2 async def f():
      3     try:
      4         while True: await asyncio.sleep(0)
      5     except asyncio.CancelledError:

CancelledError: 999

In [11]: coro = f()

In [12]: coro.send(None)

In [13]: coro.throw(asyncio.CancelledError, 999)
I was cancelled!
---------------------------------------------------------------------------
StopIteration                             Traceback (most recent call last)
<ipython-input-13-1e8ecc421f15> in <module>
----> 1 coro.throw(asyncio.CancelledError, 999)

StopIteration:

In [14]:
```

Note that the catched error is not limited to `asyncio.CancelledError`.

```python
In [44]: async def f():
    ...:     try:
    ...:         while True: await asyncio.sleep(0)
    ...:     except TypeError as e:
    ...:         print(f"I was cancelled (by {e.__class__.__name__})!")
    ...:     else:
    ...:         return 111
    ...:

In [45]: coro = f()

In [46]: coro.send(None)

In [47]: coro.throw(TypeError)
I was cancelled (by TypeError)!
---------------------------------------------------------------------------
StopIteration                             Traceback (most recent call last)
<ipython-input-47-2e951f39704f> in <module>
----> 1 coro.throw(TypeError)

StopIteration:
```

The `throw()` method:

```python
In [26]: coro = more()

In [27]: type(coro)
Out[27]: coroutine

In [28]: coro.send(None)
Out[28]: <Future pending>

In [29]: type(coro)
Out[29]: coroutine

In [30]: coro.throw(TypeError, 3.14159)
---------------------------------------------------------------------------
TypeError                                 Traceback (most recent call last)
<ipython-input-30-9b97c59e1bc8> in <module>
----> 1 coro.throw(TypeError, 3.14159)

<ipython-input-15-a1929c4df930> in more()
     12
     13 async def more():
---> 14     await asyncio.sleep(1)
     15     return 123

/usr/lib/python3.7/asyncio/tasks.py in sleep(delay, result, loop)
    566                         future, result)
    567     try:
--> 568         return await future
    569     finally:
    570         h.cancel()

TypeError: 3.14159

In [31]: coro = more()

In [32]: coro.send(None)
Out[32]: <Future pending>

In [33]: coro.throw(Exception, "blah")
---------------------------------------------------------------------------
Exception                                 Traceback (most recent call last)
<ipython-input-33-830523c72dc6> in <module>
----> 1 coro.throw(Exception, "blah")

<ipython-input-15-a1929c4df930> in more()
     12
     13 async def more():
---> 14     await asyncio.sleep(1)
     15     return 123

/usr/lib/python3.7/asyncio/tasks.py in sleep(delay, result, loop)
    566                         future, result)
    567     try:
--> 568         return await future
    569     finally:
    570         h.cancel()

Exception: blah

In [34]:
```


**Rmk.**<br>
Python 3.8.12 and Python 3.8.1 both exhibit a coherent behaviour which is different from the one shown in the book:
It seems that one can no longer `send(None)` from a coroutine which contains an `asyncio.sleep()` in
its definition.

```python
In [18]: async def more():
    ...:     await asyncio.sleep(1.0)
    ...:     return 123
    ...:

In [19]: coro = more()

In [20]: coro.send(None)
---------------------------------------------------------------------------
RuntimeError                              Traceback (most recent call last)
<ipython-input-20-9cc02a983a52> in <module>
----> 1 coro.send(None)

<ipython-input-18-d84667f11fa9> in more()
      1 async def more():
----> 2     await asyncio.sleep(1.0)
      3     return 123
      4

~/.local/bin/miniconda3/envs/py3.10/lib/python3.10/asyncio/tasks.py in sleep(delay, result)
    601         return result
    602
--> 603     loop = events.get_running_loop()
    604     future = loop.create_future()
    605     h = loop.call_later(delay,

RuntimeError: no running event loop
```






### `time()` same same but Diff

```python
In [3]: type(asyncio.sleep(1))
/home/phunc20/.virtualenvs/huggingface/bin/ipython:1: RuntimeWarning: coroutine 'sleep' was never awaited
  #!/home/phunc20/.virtualenvs/huggingface/bin/python
RuntimeWarning: Enable tracemalloc to get the object allocation traceback
Out[3]: coroutine

In [5]: type(time.sleep(1))
Out[5]: NoneType

In [6]: type(asyncio.sleep)
Out[6]: function

In [7]: type(time.sleep)
Out[7]: builtin_function_or_method
```

## Doesn't mean that one cannot use `time.sleep()` inside a coroutine function
The following code will wait about 5 seconds before outputing the `StopIteration` error.

```python
In [55]: import time
    ...:
    ...: async def blocking_sleep():
    ...:     time.sleep(5)
    ...:     return 123
    ...:
    ...: coro = blocking_sleep()
    ...: coro.send(None)
    ...:
---------------------------------------------------------------------------
StopIteration                             Traceback (most recent call last)
<ipython-input-55-8c34aa035db5> in <module>
      6
      7 coro = blocking_sleep()
----> 8 coro.send(None)

StopIteration: 123
```

The following code will output `<Future pending>` immediately.

```python
In [56]: import asyncio
    ...:
    ...: async def non_blocking_sleep():
    ...:     await asyncio.sleep(5)
    ...:     return 123
    ...:
    ...: coro = non_blocking_sleep()
    ...: coro.send(None)
    ...:
Out[56]: <Future pending>
```

Let's also run these coroutines using an event loop.

```python
In [58]: loop = asyncio.get_event_loop()

In [59]: loop.run_until_complete(non_blocking_sleep())
Out[59]: 123

In [60]: %time loop.run_until_complete(non_blocking_sleep())
CPU times: user 4.07 s, sys: 946 ms, total: 5.01 s
Wall time: 5 s
Out[60]: 123

In [61]: %time loop.run_until_complete(blocking_sleep())
CPU times: user 2.04 ms, sys: 0 ns, total: 2.04 ms
Wall time: 5.01 s
Out[61]: 123

In [62]: %time loop.run_until_complete(non_blocking_sleep())
CPU times: user 4.12 s, sys: 883 ms, total: 5 s
Wall time: 5 s
Out[62]: 123
```

We can observe that the CPU times differences are great.

