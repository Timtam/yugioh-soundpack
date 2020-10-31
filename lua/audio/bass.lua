local class = require("pl.class")
local const = require("audio.bass.constants")
local ffi = require("ffi")
local stream = require("audio.bass.stream")

class.BASS()

function BASS:_init()

  self.bass = require("audio.bindings.bass")

end

function BASS:Free()

  self.bass.BASS_Free()

  return self.bass.BASS_ErrorGetCode()

end

function BASS:GetConfig(option)

  return self.bass.BASS_GetConfig(option)

end

function BASS:GetVersion()

  return self.bass.BASS_GetVersion()
end

function BASS:Init(device, frequency, flags)

  device = device or -1

  frequency = frequency or 44100

  flags = flags or 0

  self.bass.BASS_Init(device, frequency, flags, nil, nil)

  return self.bass.BASS_ErrorGetCode()
end

function BASS:SetConfig(option, value)

  self.bass.BASS_SetConfig(option, value)

  return self.bass.BASS_ErrorGetCode()

end

function BASS:StreamCreate(freq, chans, flags)

  local handle = self.bass.BASS_StreamCreate(freq, chans, flags, -1, nil)

  if self.bass.BASS_ErrorGetCode() ~= const.error.ok then
    return self.bass.BASS_ErrorGetCode()
  else
    return stream(handle)
  end
end

function BASS:StreamCreateFile(mem, file, offset, length, flags)

  offset = offset or 0
  length = length or 0
  flags = flags or 0

  assert(type(mem) == 'boolean')

  local sfile = ffi.new("char[?]", #file+1)
  ffi.copy(sfile, file)

  local handle = self.bass.BASS_StreamCreateFile(mem, sfile, offset, length, flags)

  if handle == 0 then
    return self.bass.BASS_ErrorGetCode()
  else
    return stream(handle)
  end

end

return BASS