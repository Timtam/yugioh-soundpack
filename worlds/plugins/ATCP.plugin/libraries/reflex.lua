-- Package table
local Reflex = {}

-- Caches
local caches = {}

-- Pluralize wordS: "alias" -> "aliases", "trigger" -> "triggers"
local plural = function(word)
  if word:sub(#word) == "s" then
    return word .. "es"
  elseif word:sub(#word) == "y" then
    return word:sub(1, #word-1) .. "ies"
  else
    return word .. "s"
  end
end

-- Proper-case: "fOoObaR" -> "Foobar", "trigger" -> "Trigger"
local proper = function(word)
  return word:sub(1,1):upper() .. word:sub(2):lower()
end

-- Converts certain characters into XML entities
local xml_escape ={
  ["<"] = "&lt;",
  [">"] = "&gt;",
  ["&"] = "&amp;",
  ['"'] = "&quot;",
  
  __call = function(tbl, line)
    return (string.gsub(line, '[<>&"]', tbl))
  end,
}
setmetatable(xml_escape, xml_escape)

-- Converts a table of details into importable XML
local table_to_xml = function(tag, details)
  local xml = {}
  table.insert(xml, "<" .. plural(tag) .. ">")
  
  -- store and remove send from the list
  local send = "<send>" .. (details.send or "") .. "</send>"
  details.send = nil
  
  table.insert(xml, "<" .. tag)
  for k,v in pairs(details) do
    table.insert(xml, ([[ %s="%s"]]):format(k, xml_escape(v)))
  end
  table.insert(xml, ">")
  
  table.insert(xml, send)
  table.insert(xml, "</" .. tag .. "></" .. plural(tag) .. ">")
  
  return table.concat(xml, "")
end


local new_reflex_proxy = function(item_type, opts)
  -- Dynamically obtain these functions.
  local GetXList   = _G["Get" .. proper(item_type) .. "List"]
  local GetXOption = _G["Get" .. proper(item_type) .. "Option"]
  local SetXOption = _G["Set" .. proper(item_type) .. "Option"]
  local DeleteX    = _G["Delete" .. proper(item_type)]
  local IsX        = _G["Is" .. proper(item_type)]

  -- Stores previously-created reflex proxies
  local cache = {}
  caches[item_type] = cache
  
  -- built-in default/required checking for options
  local opt_meta = {
    __metatable = false,
    __call = function(tbl, item, arg, mode)
      if arg == nil then
        assert(not tbl.required, "'" .. tbl.name .. "' must be supplied.")
        arg = tbl.default
      end
      return tbl[1](item, arg, mode)
    end,
  }
  
  -- copy the options and give each a metatable
  do
    local _opts = opts
    opts = {}
    for k,v in pairs(_opts) do
      if type(v) == "function" then
        opts[k] = setmetatable({v, name=k}, opt_meta)
      elseif type(v) == "table" then
        v = {
          [1] = v[1],
          default = v.default,
          required = v.required,
          name = k,
        }
        opts[k] = setmetatable(v, opt_meta)
      end
    end
  end
  
  local item_meta = {
    __metatable = false,
    
    __index = function(tbl, idx)
      assert(IsX(cache[tbl].name) == 0, proper(item_type) .. " does not exist")
      
      idx = string.lower(idx)
      
      -- retrieve the name now if requested
      if idx == "name" then
        return cache[tbl].name
      end
      
      -- check if it's a valid option
      assert(opts[idx], "Option type is invalid")
      
      -- get the value and translate it
      local val = GetXOption(cache[tbl].name, idx)
      return opts[idx](cache[tbl], val, "get")
    end,
    
    __newindex = function(tbl, idx, val)
      assert(IsX(cache[tbl].name) == 0, proper(item_type) .. " does not exist")
      
      -- check if it's a valid option
      idx = string.lower(idx)
      assert(opts[idx], "Option type is invalid")
      
      -- translate the value and set it
      val = opts[idx](cache[tbl], val, "set")
      check(SetXOption(cache[tbl].name, idx, val))
    end,
    
    __call = function(tbl, val)
      assert(type(val) == "table", item_type .. " details must be a table")
      
      -- copy the details
      local details = {}
      for k,v in pairs(val) do
        details[k] = v
      end
      details.name = cache[tbl].name
      
      -- translate the details
      for k,v in pairs(opts) do
        details[k] = opts[k](cache[tbl], details[k], "xml") or nil
      end
      
      -- convert the details to XML
      val = table_to_xml(item_type, details)
      
      -- If the reflex is unnamed, get a list of all current objects
      local names
      if cache[tbl].name == "" then
        names = GetXList() or {}
        if names then
          for _,v in ipairs(names) do
            names[v] = true
          end
        end
      else
        -- delete the previous one of this name
        DeleteX(cache[tbl].name)
      end
      
      -- import!
      ImportXML(val)
      
      -- Now compare the previous list to the new one to
      -- discover an unnamed reflex's name.
      if names then
        local name
        local reflexes = GetXList()
        if reflexes then
          for _,v in ipairs(reflexes) do
            if not names[v] then
              name = v
              break
            end
          end
        end
        
        -- use a new proxy instead of the unnamed one
        tbl = (name and Reflex[item_type][name] or nil)
      end
      
      -- Force script resolution
      tbl.script = tbl.script
      
      return tbl
    end,
  }
  
  Reflex[item_type] = setmetatable({}, {
    __metatable = false,
    
    __index = function(tbl, idx)
      assert(type(idx) == "string", item_type .. " name must be a string")
      
      local item = rawget(cache, string.lower(idx))
      if not item then
        item = {setmetatable({}, item_meta), name=idx}
        cache[string.lower(idx)] = item
        cache[item[1]] = item
      end
      
      return item[1]
    end,
    
    __newindex = function(tbl, idx, val)
      assert(type(idx) == "string", item_type .. " name must be a string")
      assert(type(val) == "nil", "Cannot assign  directly to the " .. item_type .. " object.")
      
      DeleteX(idx)
    end,
    
    __call = function(tbl, ...)
      return tbl[""](...)
    end,
  })
  
  return 
end


-- Option translation methods
local no_change = function(record, arg, mode)
  return arg
end

local translate_bool = function(record, arg, mode)
  if mode == "set" then
    return (arg == true) and "1" or "0"
  elseif mode == "get" then
    return (arg == 1) and true or false
  elseif mode == "xml" then
    return (arg == true) and "y" or "n"
  else
    return ""
  end
end

new_reflex_proxy("trigger", {
  clipboard_arg      =  no_change,
  colour_change_type =  no_change,
  custom_colour      =  no_change,
  enabled            = {translate_bool, default=true},
  expand_variables   = {translate_bool, default=false},
  group              =  no_change,
  ignore_case        = {translate_bool, default=false},
  inverse            = {translate_bool, default=false},
  italic             = {translate_bool, default=false},
  keep_evaluating    = {translate_bool, default=true},
  lines_to_match     =  no_change,
  lowercase_wildcard = {translate_bool, default=false},
  match              = {no_change,      required=true},
  match_style        =  no_change,
  multi_line         = {translate_bool, default=false},
  new_style          =  no_change,
  omit_from_log      = {translate_bool, default=false},
  omit_from_output   = {translate_bool, default=false},
  one_shot           = {translate_bool, default=false},
  other_back_color   =  no_change,
  other_text_color   =  no_change,
  regexp             = {translate_bool, default=false},
  ["repeat"]         = {translate_bool, default=false},
  script             =  no_change,
  send               =  no_change,
  send_to            = {no_change,      default="0"},
  sequence           = {no_change,      default="100"},
  sound              =  no_change,
  sound_if_inactive  = {translate_bool, default="false"},
  user               =  no_change,
  variable           =  no_change,
})

new_reflex_proxy("alias", {
  echo_alias                = {translate_bool, default=false},
  enabled                   = {translate_bool, default=true},
  expand_variables          = {translate_bool, default=false},
  group                     =  no_change,
  ignore_case               = {translate_bool, default=true},
  keep_evaluating           = {translate_bool, default=false},
  match                     = {no_change,      required=true},
  menu                      = {translate_bool, default=false},
  omit_from_command_history = {translate_bool, default=false},
  omit_from_log             = {translate_bool, default=false},
  omit_from_output          = {translate_bool, default=false},
  one_shot                  = {translate_bool, default=false},
  regexp                    = {translate_bool, default=false},
  script                    =  no_change,
  send                      =  no_change,
  send_to                   = {no_change,      default="0"},
  sequence                  = {no_change,      default="100"},
  user                      =  no_change,
  variable                  =  no_change,
})

new_reflex_proxy("timer", {
  active_closed    = {translate_bool, default=false},
  at_time          = {translate_bool, default=false},
  enabled          = {translate_bool, default=true},
  group            =  no_change,
  hour             = {no_change,      default="0"},
  minute           = {no_change,      default="0"},
  offset_hour      = {no_change,      default="0"},
  offset_minute    = {no_change,      default="0"},
  offset_second    = {no_change,      default="0.00"},
  omit_from_log    = {translate_bool, default=false},
  omit_from_output = {translate_bool, default=false},
  one_shot         = {translate_bool, default=false},
  script           =  no_change,
  second           = {no_change,      required=true},
  send             =  no_change,
  send_to          = {no_change,      default="0"},
  user             =  no_change,
  variable         =  no_change,
})

-- return Reflex
return Reflex