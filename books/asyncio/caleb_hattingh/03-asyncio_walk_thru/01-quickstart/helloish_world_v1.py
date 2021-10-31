import asyncio
import time

async def main():
    print(f"{time.ctime()} Hello!")
    await asyncio.sleep(1.0)
    print(f"{time.ctime()} Goodbye!")

loop = asyncio.get_event_loop()
print(f"type(loop) = {type(loop)}")
task = loop.create_task(main())
print(f"type(task) = {type(task)}")
loop.run_until_complete(task)
pending = asyncio.all_tasks(loop=loop)
print(f"type(pending) = {type(pending)}")
if pending:
    print(f"type(pending[0]) = {type(pending[0])}")
for task in pending:
    task.cancel()
group = asyncio.gather(*pending, return_exceptions=True)
print(f"type(group) = {type(group)}")
print(f"dir(group) = {dir(group)}")
if group:
    try:
        print(f"type(group[0]) = {type(group[0])}")
    except Exception as e:
        print(f"{e.__class__}: group[0] {e}")
loop.run_until_complete(group)
loop.close()
