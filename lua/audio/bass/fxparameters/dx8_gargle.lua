local class = require("pl.class")
local fxparameters = require("audio.bass.fxparameters")

class.DX8_GARGLE(fxparameters)

function DX8_GARGLE:_init()

  self:LinkParameter('dwRateHz', 'rate_hz')
  self:LinkParameter('dwWaveShape', 'wave_shape')

  self:super('BASS_DX8_GARGLE')

end

return DX8_GARGLE