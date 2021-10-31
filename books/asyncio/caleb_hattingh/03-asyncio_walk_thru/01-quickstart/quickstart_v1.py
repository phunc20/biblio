import asyncio, time

async def main():
    print(f"{time.ctime()} Hello!")
    await asyncio.sleep(1.0)
    print(f"{time.ctime()} Goodbye!")

print(f"type(main) = {type(main)}")
print(f"type(main()) = {type(main())}")
print("asyncio.run(main())")
asyncio.run(main())
