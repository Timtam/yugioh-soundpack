local class = require("pl.class")
local fxparameters = require("audio.bass.fxparameters")

class.BFX_PEAKEQ(fxparameters)

function BFX_PEAKEQ:_init()

  self:LinkParameter('lBand', 'band')
  self:LinkParameter('fBandwidth', 'bandwidth')
  self:LinkParameter('fQ', 'q')
  self:LinkParameter('fCenter', 'center')
  self:LinkParameter('fGain', 'gain')
  self:LinkParameter('lChannel', 'channel')

  self:super('BASS_BFX_PEAKEQ')

end

return BFX_PEAKEQ