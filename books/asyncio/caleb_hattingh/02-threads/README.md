## Raymond Hettinger and Threading
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
This happened to my Thinkpad X61s when running brave browser with around 20 tabs and tmux with 6 tabs.


## Bots
The major diff btw `cutlery_test.py` and `cutlery_test_adapt.py` is at
```python
def change(self, knives, forks):
    with self.lock:
        self.knives += knives
        self.forks += forks
```
where `self.lock` was defined in `__init__()` as a `threading.Lock()` instance to avoid race condition.



```bash
(oft) ~/.../asyncio/caleb_hattingh/02-threads ❯❯❯ python cutlery_test.py 100
Kitchen inventory before service: Cutlery(knives=0, forks=0)
Kitchen inventory after service: Cutlery(knives=0, forks=0)
(oft) ~/.../asyncio/caleb_hattingh/02-threads ❯❯❯ python cutlery_test.py 100
Kitchen inventory before service: Cutlery(knives=0, forks=0)
Kitchen inventory after service: Cutlery(knives=0, forks=0)
(oft) ~/.../asyncio/caleb_hattingh/02-threads ❯❯❯ python cutlery_test.py 5000
Kitchen inventory before service: Cutlery(knives=0, forks=0)
Kitchen inventory after service: Cutlery(knives=-4, forks=-8)
(oft) ~/.../asyncio/caleb_hattingh/02-threads ❯❯❯ python cutlery_test.py 5000
Kitchen inventory before service: Cutlery(knives=0, forks=0)
Kitchen inventory after service: Cutlery(knives=-4, forks=0)
(oft) ~/.../asyncio/caleb_hattingh/02-threads ❯❯❯ python cutlery_test_adapt.py
args.n_bots = 10
args.n_tasks = 100
Kitchen inventory before service: Cutlery(knives=0, forks=0, lock=<unlocked _thread.lock object at 0x7ff94336df30>)
Kitchen inventory after service : Cutlery(knives=0, forks=0, lock=<unlocked _thread.lock object at 0x7ff94336df30>)
(oft) ~/.../asyncio/caleb_hattingh/02-threads ❯❯❯ python cutlery_test_adapt.py
args.n_bots = 10
args.n_tasks = 100
Kitchen inventory before service: Cutlery(knives=0, forks=0, lock=<unlocked _thread.lock object at 0x7fd823d3bf30>)
Kitchen inventory after service : Cutlery(knives=0, forks=0, lock=<unlocked _thread.lock object at 0x7fd823d3bf30>)
(oft) ~/.../asyncio/caleb_hattingh/02-threads ❯❯❯ python cutlery_test_adapt.py --n_tasks=5000
args.n_bots = 10
args.n_tasks = 5000
Kitchen inventory before service: Cutlery(knives=0, forks=0, lock=<unlocked _thread.lock object at 0x7f174bf57f30>)
Kitchen inventory after service : Cutlery(knives=0, forks=0, lock=<unlocked _thread.lock object at 0x7f174bf57f30>)
(oft) ~/.../asyncio/caleb_hattingh/02-threads ❯❯❯ python cutlery_test_adapt.py --n_tasks=5000
args.n_bots = 10
args.n_tasks = 5000
Kitchen inventory before service: Cutlery(knives=0, forks=0, lock=<unlocked _thread.lock object at 0x7fece1df4f30>)
Kitchen inventory after service : Cutlery(knives=0, forks=0, lock=<unlocked _thread.lock object at 0x7fece1df4f30>)
(oft) ~/.../asyncio/caleb_hattingh/02-threads ❯❯❯
```



