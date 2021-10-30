import threading
from queue import Queue

class ThreadBot(threading.Thread):
    def __init__(self):
        super().__init__(target=self.manage_table)
        self.cutlery = Cutlery()
        self.tasks = Queue()

    def manage_table(self):
        while True:
            task = self.tasks.get()
            if task == "prepare table":
                kitchen.give(to=self.cutlery, knives=4, forks=4)
            elif task == "clear table":
                self.cutlery.give(to=kitchen, knives=4, forks=4)
            elif task == "shutdown":
                return


from attr import attrs, attrib

@attrs
class Cutlery:
    knives = attrib(default=0)
    forks = attrib(default=0)
    lock = attrib(default=threading.Lock())

    def give(self, to: "Cutlery", knives=0, forks=0):
        self.change(-knives, -forks)
        to.change(knives, forks)

    def change(self, knives, forks):
        with self.lock:
            self.knives += knives
            self.forks += forks


if __name__ == "__main__":
    kitchen = Cutlery()
    
    import argparse
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--n_tasks",
        help="n_tasks = (real_n_tasks - 1) // 2",
        nargs="?",
        const=100,
        type=int,
        default=100,
    )
    parser.add_argument(
        "--n_bots",
        help="(# ThreadBots) to be created",
        nargs="?",
        const=10,
        type=int,
        default=10,
    )
    args = parser.parse_args()
    print(f"args.n_bots = {args.n_bots}")
    print(f"args.n_tasks = {args.n_tasks}")
    bots = [ThreadBot() for _ in range(args.n_bots)]
    for bot in bots:
        for _ in range(args.n_tasks):
            bot.tasks.put("prepare table")
            bot.tasks.put("clear table")
        bot.tasks.put("shutdown")
    
    print("Kitchen inventory before service:", kitchen)
    for bot in bots:
        bot.start()
    
    for bot in bots:
        bot.join()
    print("Kitchen inventory after service :", kitchen)
