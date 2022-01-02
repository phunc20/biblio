import asyncio

async def diem_danh(i):
    print(i)

async def f():
    for i in range(10):
        asyncio.create_task(diem_danh(i))
    print(f"Exiting coroutine: f()")

loop = asyncio.get_event_loop()
loop.run_until_complete(f())
