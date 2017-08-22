bit = require("bit")
class = require("pl.class")
stream = require("audio.bass.stream")

class.BASS()

function BASS:_init()

  self.bass = require("audio.bindings.bass")

end

function BASS:Free()

  self.bass.BASS_Free()

  return self.bass.BASS_ErrorGetCode()

end

function BASS:GetVersion()

  version = self.bass.BASS_GetVersion()

  return version

end

function BASS:Init(device, frequency, flags)

  device = device or -1

  frequency = frequency or 44100

  flags = flags or 0

  self.bass.BASS_Init(device, frequency, flags, nil, nil)

  return self.bass.BASS_ErrorGetCode()
end

function BASS:StreamCreateFile(mem, file, offset, length, flags)

  offset = offset or 0
  length = length or 0
  flags = flags or 0

  if mem ~= 0 and mem ~= false then
    mem = true
  else
    mem = false
  end

  local handle = self.bass.BASS_StreamCreateFile(mem, file, offset, length, flags)

  if handle == 0 then
    return self.bass.BASS_ErrorGetCode()
  else
    return stream(handle)
  end

end

return BASS