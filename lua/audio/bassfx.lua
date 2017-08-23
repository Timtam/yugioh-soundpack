class = require("pl.class")

class.BASSFX()

function BASSFX:_init()

  self.bassfx = require("audio.bindings.bass_fx")

end

function BASSFX:GetVersion()

  return self.bassfx.BASS_FX_GetVersion()

end

return BASSFX