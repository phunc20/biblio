## Order for Reading The Scripts
01. `quickstart.py`
  ```bash
  (oft) ~/.../asyncio/caleb_hattingh/03-asyncio_walk_thru ❯❯❯ python quickstart.py
  Sun Oct 31 12:52:15 2021 Hello!
  Sun Oct 31 12:52:16 2021 Goodbye!
  ```
01. `quickstart_v1.py`
01. `helloish_world.py`
01. `helloish_world_v1.py`
01. `quickstart_exe.py`
  ```bash
  (oft) ~/.../caleb_hattingh/03-asyncio_walk_thru/01-quickstart ❯❯❯ python quickstart_exe.py
  Sun Oct 31 13:35:11 2021 Hello!
  Sun Oct 31 13:35:11 2021 Hello from a thread!
  Sun Oct 31 13:35:12 2021 Goodbye!
  (oft) ~/.../caleb_hattingh/03-asyncio_walk_thru/01-quickstart ❯❯❯ python quickstart_exe.py
  Sun Oct 31 13:35:14 2021 Hello!
  Sun Oct 31 13:35:14 2021 Hello from a thread!
  Sun Oct 31 13:35:15 2021 Goodbye!
  (oft) ~/.../caleb_hattingh/03-asyncio_walk_thru/01-quickstart ❯❯❯ python quickstart_exe.py
  Sun Oct 31 13:35:16 2021 Hello!
  Sun Oct 31 13:35:16 2021 Hello from a thread!
  Sun Oct 31 13:35:17 2021 Goodbye!
  (oft) ~/.../caleb_hattingh/03-asyncio_walk_thru/01-quickstart ❯❯❯ python quickstart_exe.py
  Sun Oct 31 13:35:18 2021 Hello!
  Sun Oct 31 13:35:18 2021 Hello from a thread!
  Sun Oct 31 13:35:19 2021 Goodbye!
  ```
01. `quickstart_exe_v1.py`: change from `loop.run_in_executor(None, blocking)` to `blocking()`
  ```bash
  (oft) ~/.../caleb_hattingh/03-asyncio_walk_thru/01-quickstart ❯❯❯ diff quickstart_exe.py quickstart_exe_v1.py
  16c16
  < loop.run_in_executor(None, blocking)
  ---
  > blocking()
  (oft) ~/.../caleb_hattingh/03-asyncio_walk_thru/01-quickstart ❯❯❯ python quickstart_exe_v1.py
  Sun Oct 31 13:37:00 2021 Hello from a thread!
  Sun Oct 31 13:37:00 2021 Hello!
  Sun Oct 31 13:37:01 2021 Goodbye!
  (oft) ~/.../caleb_hattingh/03-asyncio_walk_thru/01-quickstart ❯❯❯ python quickstart_exe_v1.py
  Sun Oct 31 13:37:03 2021 Hello from a thread!
  Sun Oct 31 13:37:03 2021 Hello!
  Sun Oct 31 13:37:04 2021 Goodbye!
  (oft) ~/.../caleb_hattingh/03-asyncio_walk_thru/01-quickstart ❯❯❯ python quickstart_exe_v1.py
  Sun Oct 31 13:37:06 2021 Hello from a thread!
  Sun Oct 31 13:37:06 2021 Hello!
  Sun Oct 31 13:37:07 2021 Goodbye!
  (oft) ~/.../caleb_hattingh/03-asyncio_walk_thru/01-quickstart ❯❯❯ python quickstart_exe_v1.py
  Sun Oct 31 13:37:18 2021 Hello from a thread!
  Sun Oct 31 13:37:18 2021 Hello!
  Sun Oct 31 13:37:19 2021 Goodbye!
  ```
01. `quickstart_exe_v2.py`
  ```
  (oft) ~/.../caleb_hattingh/03-asyncio_walk_thru/01-quickstart ❯❯❯ python quickstart_exe_v2.py
  /home/phunc20/git-repos/phunc20/biblio/books/asyncio/caleb_hattingh/03-asyncio_walk_thru/01-quickstart/quickstart_exe_v2.py:17: RuntimeWarning: coroutine 'blocking' was never awaited
    blocking()
  RuntimeWarning: Enable tracemalloc to get the object allocation traceback
  Sun Oct 31 13:43:35 2021 Hello!
  Sun Oct 31 13:43:36 2021 Goodbye!
  ```
01. `quickstart_exe_v3.py`
  ```
  (oft) ~/.../caleb_hattingh/03-asyncio_walk_thru/01-quickstart ❯❯❯ python quickstart_exe_v3.py
  Sun Oct 31 13:43:38 2021 Hello!
  /usr/lib/python3.9/asyncio/base_events.py:1891: RuntimeWarning: coroutine 'blocking' was never awaited
    handle = None  # Needed to break cycles when an exception occurs.
  RuntimeWarning: Enable tracemalloc to get the object allocation traceback
  Sun Oct 31 13:43:39 2021 Goodbye!
  ```
01. `quickstart_exe_v4.py`
  ```bash
  (oft) ~/.../caleb_hattingh/03-asyncio_walk_thru/01-quickstart ❯❯❯ python quickstart_exe_v4.py
  Traceback (most recent call last):
    File "/home/phunc20/git-repos/phunc20/biblio/books/asyncio/caleb_hattingh/03-asyncio_walk_thru/01-quickstart/quickstart_exe_v4.py", line 16, in <module>
      loop.run_until_complete(blocking)
    File "/usr/lib/python3.9/asyncio/base_events.py", line 621, in run_until_complete
      future = tasks.ensure_future(future, loop=self)
    File "/usr/lib/python3.9/asyncio/tasks.py", line 680, in ensure_future
      raise TypeError('An asyncio.Future, a coroutine or an awaitable is '
  TypeError: An asyncio.Future, a coroutine or an awaitable is required
  ```
