ffi = require("ffi")

ffi.cdef[[
  typedef short BOOL;
  typedef uint32_t DWORD;
  typedef uint64_t QWORD;
  BOOL BASS_ChannelGetAttribute(DWORD handle, DWORD attrib, float *value);
  DWORD BASS_ChannelIsActive(DWORD handle);
  BOOL BASS_ChannelPause(DWORD handle);
  BOOL BASS_ChannelPlay(DWORD handle, BOOL restart);
  BOOL BASS_ChannelSetAttribute(DWORD handle, DWORD attrib, float value);
  BOOL BASS_ChannelStop(DWORD handle);
  int BASS_ErrorGetCode();
  BOOL BASS_Free();
  DWORD BASS_GetVersion();
  BOOL BASS_Init(int device, DWORD frequency, DWORD flags, void *win, const void *dsguid);
  DWORD BASS_StreamCreateFile(BOOL mem, const char *file, QWORD offset, QWORD length, DWORD flags);
]]

return ffi.load("bass")