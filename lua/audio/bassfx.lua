addon = require("audio.bass.addon")
class = require("pl.class")
constants = require("audio.bassfx.constants")

class.BASSFX(addon)

function BASSFX:_init()

  self.bassfx = require("audio.bindings.bassfx")

  self:super()

end

function BASSFX:_load()

  self._base._load(self)

  self:_inject_table(package.loaded['audio.bass.constants'], constants)

end

function BASSFX:GetVersion()

  return self.bassfx.BASS_FX_GetVersion()

end

return BASSFX