local class = require("pl.class")
local fxparameters = require("audio.bass.fxparameters")

class.BFX_VOLUME(fxparameters)

function BFX_VOLUME:_init()

  self:LinkParameter('fVolume', 'volume')
  self:LinkParameter('lChannel', 'channel')

  self:super('BASS_BFX_VOLUME')

end

return BFX_VOLUME