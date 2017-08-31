local class = require("pl.class")
local fxparameters = require("audio.bass.fxparameters")

class.DX8_PARAMEQ(fxparameters)

function DX8_PARAMEQ:_init()

  self:LinkParameter('fCenter', 'center')
  self:LinkParameter('fBandwidth', 'bandwidth')
  self:LinkParameter('fGain', 'gain')

  self:super('BASS_DX8_PARAMEQ')

end

return DX8_PARAMEQ