bass = require("audio.bindings.bass")
bit = require("bit")
class = require("pl.class")

class.Addon()

function Addon:_init()

  -- performing version checks
  if self.GetVersion ~= nil and bit.rshift(bass.BASS_GetVersion(), 16) ~= bit.rshift(self:GetVersion(), 16) then
    error(self._name.." dll version incompatible with bass dll version.")
  end

end

return Addon