# lua-webdispatcher
Allows a DCS mission to send data to a REST API

### Installation
Making this happen within the DCS API is a pain. As such there are a few requirements to get this working:

1. Add "mint={require=require}" to the top of your MissionScripting.lua file
2. Make folders so that you can navigate to "C:\<dcs install folder>\bin\lua\socket" folder
3. Copy ALL files from "C:\<dcs install folder>\LuaSocket" into the "socket" folder in step 2
4. Move the files "socket.lua", "mime.lua" and "ltn12.lua" to "C:\<dcs install folder>\bin\lua\"

## Functions

### WebDispatcher:new()
Creates a new webdispatcher
```LUA
WD = WebDispatcher:new()
```

### WebDispatcher:post(path: string, payload: table)
Parses the `payload` into a JSON string and sends it to the URL supplied in `path`.

Returns the status code of the request that was made.

```LUA
local code = WD:post('https://api.someurl.com/api/v1/', { foo = 'bar'} )
print(code) -- 200
```

### WebDispatcher:get(path: string)
Retrieves the data from the endpoint provided in `path` and returns it as a LUA table, along with the request's status code.

```LUA
local res, code = WD:get('https://api.someurl.com/api/v1/')
print(table.concat(res)) -- {"msg":"hello world!"}
print(code) -- 200
```
