## YouTube Video Recommendations
### Raymond Hettinger and Threading
related
https://www.youtube.com/watch?v=Bv25Dwe84g0&t=3s
https://www.youtube.com/watch?v=9zinZmE3Ogk&t=496s

unrelated
https://www.youtube.com/watch?v=EiOglTERPEo
https://www.youtube.com/watch?v=S_ipdVNSFlo


## Per-Thread Stack Space
To observe the Python process running `threadmem.py` using the command `top`,
remember to use the `-p` option:

```bash
top -p <pid>
```

Note that the code in `threadmem.py` considerately prints out the PID for us.

```bash
(oft) ~/.../asyncio/caleb_hattingh/02-threads ❯❯❯ python threadmem.py
PID = 115113
```

At the same time, copy the above PID, open another terminal and run:

```
~ ❯❯❯ top -p 115113
top - 15:16:20 up 39 min,  7 users,  load average: 0.42, 0.21, 0.27
Tasks:   1 total,   0 running,   1 sleeping,   0 stopped,   0 zombie
%Cpu(s):  1.0 us,  0.4 sy,  0.0 ni, 98.3 id,  0.0 wa,  0.2 hi,  0.1 si,  0.0 st
MiB Mem :   7746.5 total,   5982.2 free,    778.9 used,    985.4 buff/cache
MiB Swap:  12288.0 total,  12288.0 free,      0.0 used.   6663.6 avail Mem

    PID USER      PR  NI    VIRT    RES    SHR S  %CPU  %MEM     TIME+ COMMAND
 115113 phunc20   20   0   80.2g 118976   4860 S   0.0   1.5   0:01.39 python
```

**_Rmk._** It is possible that, when your computer is busy running too many other processes, running
`threadmem.py` will complain

```
Traceback (most recent call last):
  File "threadmem.py", line 7, in <module>
    t.start()
  File "/usr/lib/python3.7/threading.py", line 847, in start
    _start_new_thread(self._bootstrap, ())
RuntimeError: can't start new thread
```
This happened to my Thinkpad X61s when running brave browser with around 20 tabs and tmux with 6 tabs (not doing anything heavy).


## Bots
The major diff btw `cutlery_test_v00.py` and `cutlery_test_v01.py` is at

```python
def change(self, knives, forks):
    with self.lock:
        self.knives += knives
        self.forks += forks
```

where `self.lock` was defined in `__init__()` as a `threading.Lock()` instance to avoid race condition.

Here is a few examle runs conducted on my Thinkpad X61s.

```bash
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v00.py 1986
Kitchen inventory before service: Cutlery(knives=100, forks=100)
Kitchen inventory after service: Cutlery(knives=108, forks=100)
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v00.py 1986
Kitchen inventory before service: Cutlery(knives=100, forks=100)
Kitchen inventory after service: Cutlery(knives=100, forks=92)
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v00.py 1986
Kitchen inventory before service: Cutlery(knives=100, forks=100)
Kitchen inventory after service: Cutlery(knives=104, forks=100)
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v00.py 1986
Kitchen inventory before service: Cutlery(knives=100, forks=100)
Kitchen inventory after service: Cutlery(knives=96, forks=100)

(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v01.py --n_tasks 1986
args.n_bots = 10
args.n_tasks = 1986
Kitchen inventory before service: Cutlery(knives=100, forks=100, lock=<unlocked _thread.lock object at 0x7f69c77c0080>)
Kitchen inventory after service : Cutlery(knives=100, forks=100, lock=<unlocked _thread.lock object at 0x7f69c77c0080>)
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v01.py --n_tasks 1986
args.n_bots = 10
args.n_tasks = 1986
Kitchen inventory before service: Cutlery(knives=100, forks=100, lock=<unlocked _thread.lock object at 0x7f9f80189080>)
Kitchen inventory after service : Cutlery(knives=100, forks=100, lock=<unlocked _thread.lock object at 0x7f9f80189080>)
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v01.py --n_tasks 1986 --n_bots=20
args.n_bots = 20
args.n_tasks = 1986
Kitchen inventory before service: Cutlery(knives=100, forks=100, lock=<unlocked _thread.lock object at 0x7f4ba998c080>)
Kitchen inventory after service : Cutlery(knives=100, forks=100, lock=<unlocked _thread.lock object at 0x7f4ba998c080>)
(async) ~/.../asyncio/caleb_hattingh/02-threads$
```

Note that the code w/o lock could have worked, provided that there is only one bot:

```bash
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v02.py
args.n_bots = 10
args.n_tasks = 100
Kitchen inventory before service: Cutlery(knives=100, forks=100)
Kitchen inventory after service : Cutlery(knives=100, forks=100)
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v02.py
args.n_bots = 10
args.n_tasks = 100
Kitchen inventory before service: Cutlery(knives=100, forks=100)
Kitchen inventory after service : Cutlery(knives=100, forks=100)
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v02.py --n_tasks 1986
args.n_bots = 10
args.n_tasks = 1986
Kitchen inventory before service: Cutlery(knives=100, forks=100)
Kitchen inventory after service : Cutlery(knives=96, forks=100)
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v02.py --n_tasks 1986
args.n_bots = 10
args.n_tasks = 1986
Kitchen inventory before service: Cutlery(knives=100, forks=100)
Kitchen inventory after service : Cutlery(knives=88, forks=100)
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v02.py --n_tasks 1986 --n_bots 1
args.n_bots = 1
args.n_tasks = 1986
Kitchen inventory before service: Cutlery(knives=100, forks=100)
Kitchen inventory after service : Cutlery(knives=100, forks=100)
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v02.py --n_tasks 1986 --n_bots 1
args.n_bots = 1
args.n_tasks = 1986
Kitchen inventory before service: Cutlery(knives=100, forks=100)
Kitchen inventory after service : Cutlery(knives=100, forks=100)
(async) ~/.../asyncio/caleb_hattingh/02-threads$ python cutlery_test_v02.py --n_tasks 1986 --n_bots 1
args.n_bots = 1
args.n_tasks = 1986
Kitchen inventory before service: Cutlery(knives=100, forks=100)
Kitchen inventory after service : Cutlery(knives=100, forks=100)
```


