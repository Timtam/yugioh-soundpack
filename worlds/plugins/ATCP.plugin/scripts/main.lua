local codes = {
  IAC_DO_ATCP = "\255\253\200", -- enables ATCP communication
  IAC_SB_ATCP = "\255\250\200", -- begins an ATCP packet
  IAC_SE      = "\255\240",     -- ends an ATCP packet
  ATCP        = 200,            -- ATCP protocol number
}

local listeners = {}
local full_listeners = {[0] = {}}

local client_data = "MUSHclient " .. Version()
local hello_msg = "hello " .. client_data .. "\n" ..
                  "auth 1\n" ..
                  "char_name 1\n" ..
                  "char_vitals 1\n" ..
                  "room_brief 1\n" ..
                  "room_exits 1\n" ..
                  "map_display 1\n" ..
                  "composer 1\n" ..
                  "keepalive 1\n" ..
                  "topvote 1\n" ..
                  "ping 1\n"


-- Linked list iterator
do
  local function iter(list, curr)
    return (curr and curr.next or nil), curr
  end
  
  function links(list)
    return iter, list, list[0]
  end
end

-- ATCP authenticator
function atcp_auth(seed)
  local a,i = 17, 0
  local n
  
  for letter in string.gmatch(seed, ".") do
    n = string.byte(letter) - 96
    
    if math.fmod(i, 2) == 0 then
      a = a + n * (bit.bor(i, 13))
    else
      a = a - n * (bit.bor(i, 11))
    end
    
    i = i + 1
  end
  
  return a
end

OnPluginTelnetRequest = function(type, data)
  if type == codes.ATCP then
    -- do not authenticate if we're connected to Vadi's System
    if GetInfo(61) == "127.0.0.1" then
      return
    end
    
    if data == "DO" then
      return true
    elseif data == "WILL" then
      return true
    elseif data == "SENT_DO" then
      SendPkt(codes.IAC_SB_ATCP .. hello_msg .. codes.IAC_SE)
      return true
    end
  end
  
  return false
end

-- Contains current content
local current_messages = {}
-- Contains last received content for all messages
local atcp_state = {}

-- Ships the ATCP messages to listening plugins
OnPluginTelnetSubnegotiation = function(type, data)
  if type ~= codes.ATCP then
    return
  end

  local s, e, message = string.find(data, "^(%w+%.%w+)")
  if not message then
    return nil
  end
  
  local content = string.sub(data, e+2)
  atcp_state[message] = content
  current_messages[message] = true
  
  if debugging then Note(message .. ' ' .. content) end
  
  if message == "Auth.Request" and content:sub(1,2) == "CH" then
    SendPkt(codes.IAC_SB_ATCP .. "auth " .. atcp_auth(content:sub(4)) .. " " .. client_data .. "\n" .. codes.IAC_SE)
    return
  end
  
  local callbacks = listeners[message]
  if callbacks then
    -- Iterate over the linked list of callbacks
    for curr, prev in links(callbacks) do
      -- If it blows up, remove this callback from the list.
      if not pcall(curr.callback, message, content) then
        prev.next = curr.next
        callbacks[curr.callback] = nil
      end
    end
  end
end

OnPlugin_IAC_GA = function()
  for curr, prev in links(full_listeners) do
    -- If it blows up, remove this callback from the list.
    if not pcall(curr.callback, current_messages) then
      prev.next = curr.next
      full_listeners[curr.callback] = nil
    end
  end
  
  current_messages = {}
end


toggle_debug = function()
  debugging = not debugging
  Note("ATCP DEBUG: " .. (debugging and "true" or "false"))
end


local PPI = require("libraries.ppi")
PPI.Expose("Send",
  function(message)
    message = tostring(message)
    SendPkt(codes.IAC_SB_ATCP .. message .. codes.IAC_SE)
  end
)
PPI.Expose("Listen",
  function(message, callback)
    if type(message) ~= "string" or type(callback) ~= "function" then
      return
    end
    
    local callbacks = listeners[message]
    if not callbacks then
      callbacks = {[0] = {}} -- linked list
      listeners[message] = callbacks
    elseif callbacks[callback] then
      return -- it's already listening
    end
    
    local node = {
      callback = callback,
      next = nil,
    }
    
    -- Insert the callback into the list
    table.insert(callbacks, node)
    callbacks[#callbacks - 1].next = node
    callbacks[callback] = true
  end
)
PPI.Expose("Unlisten",
  function(message, callback)
    if type(message) ~= "string" or type(callback) ~= "function" then
      return
    end
    
    local callbacks = listeners[message]
    if not callbacks then
      return
    end
    
    -- Iterate over the linked list of callbacks
    for curr, prev in links(callbacks) do
      if curr.callback == callback then
        prev.next = curr.next
        break
      end
    end
    
    callbacks[callback] = nil
  end
)
PPI.Expose("ListenFull",
  function(callback)
    if type(callback) ~= "function" then
      return
    end
    
    local callbacks = full_listeners
    if callbacks[callback] then
      return -- it's already listening
    end
    
    local node = {
      callback = callback,
      next = nil,
    }
    
    -- Insert the callback into the list
    table.insert(callbacks, node)
    callbacks[#callbacks - 1].next = node
    callbacks[callback] = true
  end
)
PPI.Expose("UnlistenFull",
  function(callback)
    if type(callback) ~= "function" then
      return
    end
    
    local callbacks = full_listeners
    
    -- Iterate over the linked list of callbacks
    for curr, prev in links(callbacks) do
      if curr.callback == callback then
        prev.next = curr.next
        break
      end
    end
    
    callbacks[callback] = nil
  end
)
PPI.Expose("GetContent",
  function(message)
    if type(message) ~= "string" then
      return nil
    end
    
    return atcp_state[message] or nil
  end
)


-- reflexes
require("reflexes.aliases")