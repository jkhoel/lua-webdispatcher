-- ************** !!!! READ THIS OR BE FOREVER FRUSTRATED!!!! *****************
--  In order to get the below requires() to work:
--    1. Add "mint={require=require}" to the top of your MissionScripting.lua file
--    2. Make folders so that you can navigate to "C:\DCS World Open Beta\bin\lua\socket" folder
--    3. Copy ALL files from "C:\DCS World Open Beta\LuaSocket" into the "socket" folder in step 2
--    4. Move the files "socket.lua", "mime.lua" and "ltn12.lua" to "C:\DCS World Open Beta\bin\lua\"

package.path = package.path .. ";.\\LuaSocket\\?.lua"
package.cpath = package.cpath .. ";.\\LuaSocket\\?.dll"

-- Required for doing HTTP requests, see http://w3.impa.br/~diego/software/luasocket/http.html
require = mint.require
local http = require("socket.http")
local ltn12 = require("ltn12")
require = nil

---
-- WebDispatcher, wrapper class for communications with REST API's
-- @author 132nd.Dex

--- @module Class

---
-- A template for creating WebDispatcher objects.
-- @type Class
-- @field #string url
-- @field #number eventID
WebDispatcher = {
  url = "http://localhost:5000/api/v1",
  eventID = 0
}

---
-- Creates a new class.
-- @param #Class self
-- @return #Class
function WebDispatcher:create()
  return setmetatable({}, {__index = WebDispatcher})
end

---
-- Creates a subclass of this class.
-- @param #Class self
-- @return #Class
function WebDispatcher:extend()
  local class = WebDispatcher:create()
  setmetatable(class, {__index = self})
  return class
end

---
-- Tests that the module is loaded
function WebDispatcher:test()
  local res, code = WebDispatcher:get(self.url .. "/ato/test")

  env.info(" WebDispatcher:test() URL: " .. self.url .. "\n")
  env.info(" WebDispatcher:test() CODE: " .. code .. "\n")
  env.info(" WebDispatcher:test() BODY: " .. table.concat(res) .. "\n")
end

---
-- Create a new WebDispatcher object connected to a certain endpoint
-- @param #Class self
-- @return #Class
function WebDispatcher:new(url, eventID)
  local conn = setmetatable({}, {__index = self})
  conn.url = url or self.url
  conn.eventID = eventID or self.eventID

  return conn
end

---
-- POSTS a payload to the provided endpoint
-- @param #table payload
function WebDispatcher:post(path, payload)
  path = path or self.url
  payload = payload or {}

  local response_body = {}
  local res, code, response_headers, status =
    http.request {
    url = path,
    method = "POST",
    headers = {
      -- ["Authorization"] = "Maybe you need an Authorization header?",
      ["Content-Type"] = "application/x-www-form-urlencoded",
      ["Content-Length"] = payload:len()
    },
    source = ltn12.source.string(payload),
    sink = ltn12.sink.table(response_body)
  }

  print(path, payload)
  return code
end

function WebDispatcher:get(path)
  path = path or self.url
  local response_body = {}

  env.info(" WebDispatcher:test() Path = " .. path .. "\n")

  local res, code, response_headers, status =
    http.request {
    url = path,
    sink = ltn12.sink.table(response_body)
  }

  return response_body, code
end

---
-- Add a new tasking
-- @param #string type
-- @param #string desc
-- @param #Vec3 coord
function WebDispatcher:addTask(type, desc, coord)
  type = type or "TR"
  desc = type or "No Description" -- These needs to be local?
  coord = coord or {x = 0, y = 0, z = 0}

  local path = self.url .. "/taskings/" .. self.eventID -- localhost:5000/api/v1/taskings/:eventID
  local payload = {type, desc, coord}

  WebDispatcher:post(path, payload)
end

env.info(" WebDispatcher: Endpoint @" .. WebDispatcher.url .. "\n")

-- WD = WebDispatcher:new()
-- WD2 = WebDispatcher:new("someURL", 99)

-- print(WD.url, WD.eventID)
-- print(WD2.url, WD2.eventID)

-- WD:addTask("AI", "someDesc", {x = 1, y = 2, z = 3})

-- WD:test()

-- WD:post('http://client.tnc.today/api/v1/warehouse/2', { foo = 'test'} )
