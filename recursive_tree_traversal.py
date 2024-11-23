import asyncio

async def search_value(tree, res):
    for key, value in tree.items():
        if isinstance(value, dict):
            await search_value(value, res)
    res.append(tree.get('value'))
    return res
    
async def main(tree):
    res = []
    task = asyncio.create_task(search_value(tree, res))
    res = await task
    return sum(res)
    

asyncio.run(main(tree))