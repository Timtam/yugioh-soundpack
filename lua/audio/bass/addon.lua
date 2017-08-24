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

    if dest[key] ~= nil and type(dest[key]) ~= "table" then
      error(self._name.." add-on table injection failed: key "..key.." already exists in destination table and isn't a table")
    end

    if dest[key] ~= nil and type(dest[key]) == "table" and type(value) ~= "table" then
      error(self._name.." add-on table injection failed: key "..key.." already exists in destination table. it's a table, but the source contains something different here.")
    end

    if dest[key] ~= nil and type(dest[key]) == "table" then
      self:_inject_table(dest[key], value)
    else
      dest[key] = value
    end

  end

end

return Addon