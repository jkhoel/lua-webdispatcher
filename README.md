# lua-webdispatcher
Allows a DCS mission to send data to a REST API

### Installation
Making this happen within the DCS API is a pain. As such there are a few requirements to get this working:

1. Add "mint={require=require}" to the top of your MissionScripting.lua file
2. Make folders so that you can navigate to "C:\<dcs install folder>\bin\lua\socket" folder
3. Copy ALL files from "C:\<dcs install folder>\LuaSocket" into the "socket" folder in step 2
4. Move the files "socket.lua", "mime.lua" and "ltn12.lua" to "C:\<dcs install folder>\bin\lua\"

### Example

```LUA
WD = WebDispatcher:new()
WD:post('https://api.someurl.com/api/v1/warehouse/2', { foo = 'test'} )
```
