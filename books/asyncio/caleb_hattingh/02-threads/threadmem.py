import os
from time import sleep
from threading import Thread

threads = [Thread(target=lambda: sleep(60)) for _ in range(10_000)]
for t in threads:
    t.start()
print(f"PID = {os.getpid()}")
for t in threads:
    t.join()
