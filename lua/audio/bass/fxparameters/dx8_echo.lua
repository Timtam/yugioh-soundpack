local class = require("pl.class")
local fxparameters = require("audio.bass.fxparameters")

class.DX8_ECHO(fxparameters)

function DX8_ECHO:_init()

  self:LinkParameter('fWetDryMix', 'wet_dry_mix')
  self:LinkParameter('fFeedback', 'feedback')
  self:LinkParameter('fLeftDelay', 'left_delay')
  self:LinkParameter('fRightDelay', 'right_delay')
  self:LinkParameter('lPanDelay', 'pan_delay')

  self:super('BASS_DX8_ECHO')

end

return DX8_ECHO