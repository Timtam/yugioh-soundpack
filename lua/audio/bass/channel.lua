class = require("pl.class")
ffi = require("ffi")
fx = require("audio.bass.fx")

class.Channel()

function Channel:_init(id)

  self.bass = require("audio.bindings.bass")
  self.id = id

end

function Channel:FXReset()

  self.bass.BASS_FXReset(self.id)

  return self.bass.BASS_ErrorGetCode()

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

  assert(type(restart) == 'boolean')

  self.bass.BASS_ChannelPlay(self.id, restart)

  return self.bass.BASS_ErrorGetCode()

end

function Channel:SetAttribute(attrib, value)

  self.bass.BASS_ChannelSetAttribute(self.id, attrib, value)

  return self.bass.BASS_ErrorGetCode()

end

function Channel:SetFX(lfx, priority)

  priority = priority or 0

  local handle = self.bass.BASS_ChannelSetFX(self.id, lfx, priority)

  if handle ~= 0 then
    return fx(handle, self.id, lfx)
  else
    return self.bass.BASS_ErrorGetCode()
  end

end

function Channel:Stop()

  self.bass.BASS_ChannelStop(self.id)

  return self.bass.BASS_ErrorGetCode()

end

return Channel