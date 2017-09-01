local class = require("pl.class")
local ffi = require("ffi")
local fx = require("audio.bass.fx")
local tablex = require("pl.tablex")

class.Channel()

function Channel:_init(id)

  local meta = tablex.copy(getmetatable(self))

  self.__old_index = meta.__index

  self._channelinfo = ffi.new("BASS_CHANNELINFO[1]")
  self.bass = require("audio.bindings.bass")
  self.id = id

  meta.__index = function(self, key)

    -- the problem is that we need to support both cases, direct instanciation
    -- and derived classes

    for i,obj in pairs({self, rawget(self, '__old_index')}) do

      local tmp = rawget(obj, key)

      if tmp ~= nil then
        return tmp
      end

      tmp = rawget(obj, 'get_'..key)

      if tmp ~= nil then
        return tmp(self)
      end

    end

    return nil

  end

  setmetatable(self, meta)

  self:GetInfo()

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

function Channel:GetInfo()

  self.bass.BASS_ChannelGetInfo(self.id, self._channelinfo)

  return self.bass.BASS_ErrorGetCode()

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

-- all getters follow

function Channel:get_frequency()

  return self._channelinfo[0].freq

end

function Channel:get_channels()

  return self._channelinfo[0].chans

end

function Channel:get_flags()

  return self._channelinfo[0].flags

end

function Channel:get_channel_type()

  return self._channelinfo[0].ctype

end

function Channel:get_original_resolution()

  return self._channelinfo[0].origres

end

return Channel