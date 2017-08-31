local class = require("pl.class")
local fxparameters = require("audio.bass.fxparameters")

class.DX8_CHORUS(fxparameters)

function DX8_CHORUS:_init()

  self:LinkParameter('fWetDryMix', 'wet_dry_mix')
  self:LinkParameter('fDepth', 'depth')
  self:LinkParameter('fFeedback', 'feedback')
  self:LinkParameter('fFrequency', 'frequency')
  self:LinkParameter('lWaveform', 'waveform')
  self:LinkParameter('fDelay', 'delay')
  self:LinkParameter('lPhase', 'phase')

  self:super('BASS_DX8_CHORUS')

end

return DX8_CHORUS