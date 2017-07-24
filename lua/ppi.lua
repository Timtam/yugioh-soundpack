-- Semantic versioning: http://semver.org/
local __V_MAJOR, __V_MINOR, __V_PATCH = 1, 3, 0
local __VERSION = string.format("%d.%d.%d", __V_MAJOR, __V_MINOR, __V_PATCH)

-- The module table's variable
local PPI = {
  -- Version identifiers
  __V = __VERSION,
  __V_MAJOR = __V_MAJOR,
  __V_MINOR = __V_MINOR,
  __V_PATCH = __V_PATCH,
  
  -- More added later in the file
}

-- Contains a list of PPI proxies to other plugins.
-- Also contains private data for each PPI.
local PPI_list = {}

-- Loader callbacks (added in v1.3.0)
local loaders = {}

-- Local data for this plugin's PPI
local myID = GetPluginID()
local myPPI = {}
local func_list = {}

-- Variable names
local params_id = "PPIparams"

-- Message IDs
local invoke_msg  = "PPI_INVOKE"
local access_msg = "PPI_ACCESS"
local cleanup_msg  = "PPI_CLEANUP"

-- Forward decl of new_thunk. Defined later in the file
-- so it can access send_invoke(), but declared here
-- so deserialize() can access it.
local new_thunk = nil


-- Serializes a Lua table into a list of serialized strings.
-- Each string is a single serialized table. [1] is the original table.
-- [2] and beyond are tables contained by [1].
--
-- The second and third params should not be used externally.
local function serialize(params, params_list, state)
  -- External entry point.
  if not params_list or not state then
    local params_list = {}
    serialize(params, params_list, {})
    return params_list
  end
  
  -- If this table was already serialized, return its ID.
  if state[params] then
    return state[params]
  end
  
  -- Register the table in the state list, and reserve its spot
  -- in the serialized list
  local index = #params_list + 1
  state[params] = index
  params_list[index] = true
  
  -- Serialize every argument in the table, and add it to this array.
  local ary_id = "PPIarray_" .. index
  ArrayCreate(ary_id)
  
  for k,v in pairs(params) do
    -- Only support string or number keys.
    local key = nil
    if type(k) == "string" then
      key = "s:" .. k
    elseif type(k) == "number" then
      key = "n:" .. k
    end
    
    if key then
      local value = "z:~"
      
      if type(v) == "string" then
        value = "s:" .. v
      elseif type(v) == "number" then
        value = "n:" .. tostring(v)
      elseif type(v) == "boolean" then
        value = "b:" .. (v and "1" or "0")
      elseif type(v) == "table" then
        value = "t:" .. serialize(v, params_list, state)
      elseif type(v) == "function" then
        value = func_list[v]
        if not value then
          table.insert(func_list, v)
          func_list[v] = #func_list
          value = #func_list
        end
        value = "f:" .. tostring(value)
      end
      
      ArraySet(ary_id, key, value)
    end
  end
  
  -- Add the serialized string to the list.
  params_list[index] = ArrayExport(ary_id, "|")

  -- Delete the array so we clean up our mess
  ArrayDelete(ary_id)
  
  -- Let the calling code know what this table's ID is.
  return index
end

-- Deserializes a Lua table from a list of serialized strings.
-- The ID is used to deserialize and store function thunks.
--
-- The third and fourth params should not be used externally.
local function deserialize(id, data_list, index, state)
  -- External entry point.
  if not index or not state then
    return deserialize(id, data_list, 1, {})
  end
  
  -- If this string was already deserialized, return its table.
  if state[index] then
    return state[index]
  end
  
  -- Create a new table to store the deserialized data in.
  -- Set it in the state table in case it's referred to multiple times.
  local tbl = {}
  state[index] = tbl
  
  -- Create an array and load the serialized string into it.
  local ary_id = "PPIarray_" .. index
  ArrayCreate(ary_id)
  ArrayImport(ary_id, data_list[index] or "", "|")
  
  -- Go over each key/value pair in the array, deserialize it,
  -- and add it to the table.
  for k,v in pairs(ArrayList(ary_id)) do
    local key_type = k:sub(1,1)
    local key = k:sub(3)
    
    -- only allow string or number keys
    if key_type == "s" then
      -- key is already deserialized
    elseif key_type == "n" then
      key = tonumber(key)
    else
      key = nil
    end
    
    if key then
      local item_type = v:sub(1,1)
      local item = v:sub(3)
      
      if item_type == "s" then
        -- item is already deserialized
      elseif item_type == "n" then
        item = tonumber(item)
      elseif item_type == "b" then
        item = ((item == "1") and true or false)
      elseif item_type == "t" then
        item = deserialize(id, data_list, tonumber(item), state)
      elseif item_type == "f" then
        local thunks = PPI_list[id].thunks
        local thunk = thunks[tonumber(item)]
        
        if not thunk then
          thunk = new_thunk(id, tonumber(item))
          thunks[tonumber(item)] = thunk
        end
        
        item = thunk
      else
        item = nil
      end
      
      tbl[key] = item
    end
  end
  
  -- Delete the array so we clean up our mess
  ArrayDelete(ary_id)
  
  -- Return the deserialized table
  return tbl
end

-- Serializes and pushes the table of parameters
-- to MUSHclient variables.
local function send_params(params)
  for k,v in ipairs(serialize(params)) do
    SetVariable(params_id .. "_" .. k, v)
  end
end

-- Retreives and deserializes a table of parameters
-- from another plugin's MUSHclient variables.
local function receive_params(id)
  -- Deserialize parameters
  local params = {}
  local i = 1
  while GetPluginVariable(id, params_id .. "_" .. i) do
    params[i] = GetPluginVariable(id, params_id .. "_" .. i)
    i = i + 1
  end
  return deserialize(id, params)
end

-- Called to have the other plugin clean up
local function send_cleanup(id)
  CallPlugin(id, cleanup_msg, myID)
end

-- Called to access and return a value from the service.
local function send_access(id, name)
  if PluginSupports(id, access_msg) ~= 0 then
    return nil
  end
  
  -- Prepare the arguments
  send_params({name})
  
  -- Call the plugin
  CallPlugin(id, access_msg, myID)
  
  -- Deserialize parameters
  local returns = receive_params(id)
  
  -- Have the other plugin clean up its return values
  send_cleanup(id)
  
  -- Return the received values
  return unpack(returns)
end

-- Called by a thunk to call a remote method.
local function send_invoke(id, func_id, ...)
  if PluginSupports(id, invoke_msg) ~= 0 then
    error("The service does not support PPI INVOKE messages.")
  end
  
  -- Prepare the arguments
  send_params({func_id, ...})
  
  -- Call the plugin
  local curr_caller = PPI.CallerID
  CallPlugin(id, invoke_msg, myID)
  PPI.CallerID = curr_caller
  
  -- Gather the return values
  local returns = receive_params(id)
  
  -- Have the other plugin clean up its return values
  send_cleanup(id)
  
  -- Return the received values.
  return unpack(returns)
end

-- Declared earlier in the file as local, see note there.
-- Creates a new resolver thunk.
function new_thunk(id, func_name)
  local current_nonce = PPI_list[id].nonce
  return function(...)
    -- Make sure it's still a valid function by checking the nonce
    if GetPluginInfo(id, 22) ~= current_nonce then
      error("The remote plugin has been reinstalled since the last time this method was accessed.")
    end
    
    return send_invoke(id, func_name, ...)
  end
end

local PPI_meta = {
  -- Retrieves the given value by key at the service.
  __index = function(tbl, idx)
    return send_access(PPI_list[tbl], idx)
  end,
  
  __newindex = function(tbl, idx, val)
    error("The client PPI is READ-ONLY! Do not write to this table!")
  end,
}


-- Given a value during execution of callbacks
PPI.CallerID = nil
  
-- Used to retreive a PPI for a specified plugin.
PPI.Load = function(id)
  -- Is the plugin installed?
  if not IsPluginInstalled(id) then
    return nil, "not_installed"
  -- Is the plugin enabled?
  elseif not GetPluginInfo(id, 17) then
    return nil, "not_enabled"
  -- Does the plugin support PPI invocations?
  elseif PluginSupports(id, invoke_msg) ~= 0 then
    return nil, "no_ppi"
  end
  
  -- Get the PPI record
  local tbl = PPI_list[id]
  local reloaded = true
 
  -- Create one if there isn't one yet
  if not tbl then
    tbl = {
      ppi = setmetatable({}, PPI_meta),
      id = id,
      thunks = {},
      nonce = GetPluginInfo(id, 22),
    }
    
    PPI_list[id] = tbl
    PPI_list[tbl.ppi] = id
  -- If there is one, reload it if the plugin's nonce has changed.
  elseif tbl.nonce ~= GetPluginInfo(id, 22) then
    tbl.nonce = GetPluginInfo(id, 22)
    tbl.thunks = {}
  else
    reloaded = false
  end
  
  return tbl.ppi, reloaded
end
  
-- Used by a plugin to expose methods to other plugins
-- through its own PPI.
PPI.Expose = function(name, data)
  -- Add the data to the exposed PPI
  myPPI[name] = data or _G[name]
end

PPI.OnLoad = function(id, on_success, on_failure)
  loaders[id] = {
    success=on_success,
    failure=on_failure,
  }
end

PPI.Refresh = function()
  for id, callbacks in pairs(loaders) do
    local iface, is_reloaded = PPI.Load(id)
    if not iface then
      if callbacks.failure then
        callbacks.failure(is_reloaded)
      end
    elseif is_reloaded then
      if callbacks.success then
        callbacks.success(iface)
      end
    end
  end
end


-- PPI invocation resolver
_G[invoke_msg] = function(id)
  -- Ensure that a PPI record exists for the client
  PPI.Load(id)
  
  -- Deserialize parameters
  local params = receive_params(id)
  local func = func_list[table.remove(params, 1)]
  
  -- Tell other plugin to clean up
  send_cleanup(id)
  
  if not func then
    return
  end
  
  -- Call method, get return values
  PPI.CallerID = id
  local returns = {func(unpack(params))}
  PPI.CallerID = nil
  
  -- Send returns
  send_params(returns)
end

-- When an exposed value is accessed
_G[access_msg] = function(id)
  -- Ensure that a PPI record exists for the client
  PPI.Load(id)
  
  -- Deserialize parameters
  local params = receive_params(id)
  local item = myPPI[unpack(params)]
  
  -- Tell other plugin to clean up
  send_cleanup(id)
  
  -- Set the return values
  send_params({item})
end

-- params/returns cleaner
_G[cleanup_msg] = function(id)
  -- clean up all params
  local i = 1
  while GetVariable(params_id .. "_" .. i) do
    DeleteVariable(params_id .. "_" .. i)
    i = i + 1
  end
end


-- Return the module table
return PPI
