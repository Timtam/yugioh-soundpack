class = require("pl.class")
const = require("audio.bass.constants")
ffi = require("ffi")

class.FX()

function FX:_init(handle, channel, fx)

  self.bass = require("audio.bindings.bass")
  self.id = handle
  self.channel = channel

  if self._parameters[fx] == nil then
    error("no parameter type found for fx "..tostring(fx))
  end

  self.Parameters = ffi.new(self._parameters[fx])

end

function FX:Remove()

  self.bass.BASS_ChannelRemoveFX(self.channel, self.id)

  return self.bass.BASS_ErrorGetCode()

end

function FX:Reset()

  self.bass.BASS_FXReset(self.id)

  return self.bass.BASS_ErrorGetCode()

end

FX._parameters = {
  [const.fx.dx8_chorus] = 'BASS_DX8_CHORUS',
  [const.fx.dx8_compressor] = 'BASS_DX8_COMPRESSOR',
  [const.fx.dx8_distortion] = 'BASS_DX8_DISTORTION',
  [const.fx.dx8_echo] = 'BASS_DX8_ECHO',
  [const.fx.dx8_flanger] = 'BASS_DX8_FLANGER',
  [const.fx.dx8_gargle] = 'BASS_DX8_GARGLE',
  [const.fx.dx8_i3dl2reverb] = 'BASS_DX8_I3DL2REVERB',
  [const.fx.dx8_parameq] = 'BASS_DX8_PARAMEQ',
  [const.fx.dx8_reverb] = 'BASS_DX8_REVERB'
}

return FX