import asyncio

async def diem_danh(i):
    print(i)

async def f():
    loop = asyncio.get_event_loop()
    for i in range(10):
        loop.create_task(diem_danh(i))
    print(f"Exiting coroutine: f()")

asyncio.run(f())
