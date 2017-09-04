local channel = require("audio.bass.channel")
local class = require("pl.class")
local ffi = require("ffi")

class.Stream(channel)

function Stream:Free()

  self.bass.BASS_StreamFree(self.id)

  return self.bass.BASS_ErrorGetCode()

end

function Stream:PutData(data)

  -- if no data is given, we will retrieve the amount of data buffered
  if data == nil then
    return self.bass.BASS_StreamPutData(self.id, nil, 0)
  end

  local buf = ffi.C.malloc(#data)

  ffi.copy(buf, data, #data)

  self.bass.BASS_StreamPutData(self.id, buf, #data)

  return self.bass.BASS_ErrorGetCode()
end

-- getters

function Stream:get_filename()

  return ffi.string(self._channelinfo[0].filename)

end

return Stream