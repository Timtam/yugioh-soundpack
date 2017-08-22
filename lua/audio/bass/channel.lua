class = require("pl.class")
ffi = require("ffi")

class.Channel()

function Channel:_init(id)

  self.bass = require("audio.bindings.bass")
  self.id = id

end

function Channel:GetAttribute(attrib)

  local f = ffi.new("float[1]")

  local success = self.bass.BASS_ChannelGetAttribute(self.id, attrib, f)

  if success == 0 then
    return self.bass.BASS_ErrorGetCode()
  else
    return f[0]
  end

end

function Channel:IsActive()

  return self.bass.BASS_ChannelIsActive(self.id)
end

function Channel:Pause()

  self.bass.BASS_ChannelPause(self.id)

  return self.bass.BASS_ErrorGetCode()

end

function Channel:Play(restart)

  restart = restart or false

  if restart ~= 0 and restart ~= false then
    restart = true
  else
    restart = false
  end

  self.bass.BASS_ChannelPlay(self.id, restart)

  return self.bass.BASS_ErrorGetCode()

end

function Channel:SetAttribute(attrib, value)

  self.bass.BASS_ChannelSetAttribute(self.id, attrib, value)

  return self.bass.BASS_ErrorGetCode()

end

function Channel:Stop()

  self.bass.BASS_ChannelStop(self.id)

  return self.bass.BASS_ErrorGetCode()

end

return Channel