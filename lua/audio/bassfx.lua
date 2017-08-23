bit = require("bit")
class = require("pl.class")

class.BASSFX()

function BASSFX:_init()

  self.bass = require("audio.bindings.bass")
  self.bassfx = require("audio.bindings.bassfx")

  if bit.rshift(self.bass.BASS_GetVersion(), 16) ~= bit.rshift(self:GetVersion(), 16) then
    error("bass_fx.dll version is not compatible to current bass.dll version.")
  end

end

function BASSFX:GetVersion()

  return self.bassfx.BASS_FX_GetVersion()

end

return BASSFX