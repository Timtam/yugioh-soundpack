local class = require("pl.class")
local fxparameters = require("audio.bass.fxparameters")

class.DX8_COMPRESSOR(fxparameters)

function DX8_COMPRESSOR:_init()

  self:LinkParameter('fGain', 'gain')
  self:LinkParameter('fAttack', 'attack')
  self:LinkParameter('fRelease', 'release')
  self:LinkParameter('fThreshold', 'threshold')
  self:LinkParameter('fRatio', 'ratio')
  self:LinkParameter('fPredelay', 'predelay')

  self:super('BASS_DX8_COMPRESSOR')

end

return DX8_COMPRESSOR