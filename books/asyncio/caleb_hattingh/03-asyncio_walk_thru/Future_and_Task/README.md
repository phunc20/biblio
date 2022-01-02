

```
In [80]: from asyncio import Future

In [81]: f = Future()

In [82]: f.done()
Out[82]: False

In [83]: f.result()
---------------------------------------------------------------------------
InvalidStateError                         Traceback (most recent call last)
<ipython-input-83-007d59320aa9> in <module>
----> 1 f.result()

InvalidStateError: Result is not set.

In [84]: f.set_result(30)

In [85]: f.result()
Out[85]: 30

In [86]: f.done()
Out[86]: True

In [87]: f.set_result("Welcome")
---------------------------------------------------------------------------
InvalidStateError                         Traceback (most recent call last)
<ipython-input-87-fd28b4c74480> in <module>
----> 1 f.set_result("Welcome")

InvalidStateError: invalid state

In [88]: f.result()
Out[88]: 30

In [89]: f.set_result(3.14)
---------------------------------------------------------------------------
InvalidStateError                         Traceback (most recent call last)
<ipython-input-89-a6b25a9edcfe> in <module>
----> 1 f.set_result(3.14)

InvalidStateError: invalid state

In [90]: f.cancelled()
Out[90]: False

In [91]: f.cancel()
Out[91]: False

In [92]: f.cancelled()
Out[92]: False
```
