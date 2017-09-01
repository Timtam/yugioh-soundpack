local channel = require("audio.bass.channel")
local class = require("pl.class")
local ffi = require("ffi")

class.Stream(channel)

function Stream:Free()

  self.bass.BASS_StreamFree(self.id)

  return self.bass.BASS_ErrorGetCode()

end

-- getters

function Stream:get_filename()

  return ffi.string(self._channelinfo[0].filename)

end

return Stream