class = require("pl.class")

class.FX()

function FX:_init(fx, channel)

  self.bass = require("audio.bindings.bass")
  self.id = fx
  self.channel = channel

end

function FX:Remove()

  self.bass.BASS_ChannelRemoveFX(self.channel, self.id)

  return self.bass.BASS_ErrorGetCode()

end

function FX:Reset()

  self.bass.BASS_FXReset(self.id)

  return self.bass.BASS_ErrorGetCode()

end

return FX