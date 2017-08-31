local class = require("pl.class")
local fxparameters = require("audio.bass.fxparameters")

class.DX8_REVERB(fxparameters)

function DX8_REVERB:_init()

  self:LinkParameter('fInGain', 'in_gain')
  self:LinkParameter('fReverbMix', 'reverb_mix')
  self:LinkParameter('fReverbTime', 'reverb_time')
  self:LinkParameter('fHighFreqRTRatio', 'high_frequency_rt_ratio')

  self:super('BASS_DX8_REVERB')

end

return DX8_REVERB