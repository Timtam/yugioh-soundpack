ffi = require("ffi")

ffi.cdef[[
  typedef uint32_t DWORD;
  DWORD BASS_FX_GetVersion();
]]

return ffi.load("bass_fx")