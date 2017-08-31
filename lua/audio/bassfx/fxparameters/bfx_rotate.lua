local class = require("pl.class")
local fxparameters = require("audio.bass.fxparameters")

class.BFX_ROTATE(fxparameters)

function BFX_ROTATE:_init()

  self:LinkParameter('fRate', 'rate')
  self:LinkParameter('lChannel', 'channel')

  self:super('BASS_BFX_ROTATE')

end

return BFX_ROTATE