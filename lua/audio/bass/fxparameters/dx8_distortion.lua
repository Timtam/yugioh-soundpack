local class = require("pl.class")
local fxparameters = require("audio.bass.fxparameters")

class.DX8_DISTORTION(fxparameters)

function DX8_DISTORTION:_init()

  self:LinkParameter('fGain', 'gain')
  self:LinkParameter('fEdge', 'edge')
  self:LinkParameter('fPostEQCenterFrequency', 'post_eq_center_frequency')
  self:LinkParameter('fPostEQBandwidth', 'post_eq_bandwidth')
  self:LinkParameter('fPreLowpassCutoff', 'pre_lowpass_cutoff')

  self:super('BASS_DX8_DISTORTION')

end

return DX8_DISTORTION