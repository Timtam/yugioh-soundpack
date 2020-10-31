local bit = require("bit")
local class = require("pl.class")
local const = require("audio.bass.constants")

class.Sync()

function Sync:_init(handle, channel)

  self.bass = require("audio.bindings.bass")
  self.id = handle
  self.channel = channel

end

function Sync:GetChannel()

  -- we may not require the below classes above
  -- that would cause cyclic imports
  -- we will access package.loaded instead
  -- since root bass module requires all relevant modules
  -- seems a bit hackish though

  local c = package.loaded["audio.bass.channel"](self.channel)

  local t = c.channel_type

  if bit.band(t, const.ctype.stream) == const.ctype.stream or bit.band(t, const.ctype.stream_wav) == const.ctype.stream_wav then
    return package.loaded["audio.bass.stream"](self.channel)
  -- todo: other types like records and music
  else
    return c
  end

end

function Sync:Remove()

  self.bass.BASS_ChannelRemoveSync(self.channel, self.id)

  return self.bass.BASS_ErrorGetCode()

end

return Sync