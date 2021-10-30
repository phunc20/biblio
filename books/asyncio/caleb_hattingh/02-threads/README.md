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



