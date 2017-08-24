bass = require("audio.bindings.bass")
bit = require("bit")
class = require("pl.class")
tablex = require("pl.tablex")

class.Addon()

function Addon:_init()

  -- performing version checks
  if self.GetVersion ~= nil and bit.rshift(bass.BASS_GetVersion(), 16) ~= bit.rshift(self:GetVersion(), 16) then
    error(self._name.." dll version incompatible with bass dll version.")
  end

  self:_load()

end

-- executes all functions to make those functions and stuff available for bass
-- e.g. injects all add-on related constants into global const table
-- needs to be derived by actual add-ons

function Addon:_load()
end

-- tablex offers an identical function, but
-- that function isn't recursive
-- it overwrites nested tables

function Addon:_inject_table(dest, src)

  for key, value in pairs(src) do

    if dest[key] ~= nil and type(dest[key]) ~= type(value) then
      error(self._name.." add-on table injection failed: type "..type(dest[key]).." in destination table doesn't match type "..type(value).." in source table for key "..key)
    end

    if dest[key] ~= nil and type(dest[key]) == "table" then
      self:_inject_table(dest[key], value)
    elseif dest[key] == nil then
      dest[key] = value
    end

  end

end

return Addon