addon = require("audio.bass.addon")
class = require("pl.class")

class.BASSFX(addon)

function BASSFX:_init()

  self.bassfx = require("audio.bindings.bassfx")

  self:super()

end

function BASSFX:GetVersion()

  return self.bassfx.BASS_FX_GetVersion()

end

return BASSFX