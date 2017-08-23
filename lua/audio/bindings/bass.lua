ffi = require("ffi")

ffi.cdef[[
  typedef short BOOL;
  typedef uint32_t DWORD;
  typedef uint64_t QWORD;
  typedef DWORD HCHANNEL;
  typedef DWORD HFX;
  typedef DWORD HSTREAM;
  BOOL BASS_ChannelGetAttribute(HCHANNEL handle, DWORD attrib, float *value);
  DWORD BASS_ChannelIsActive(HCHANNEL handle);
  BOOL BASS_ChannelPause(HCHANNEL handle);
  BOOL BASS_ChannelPlay(HCHANNEL handle, BOOL restart);
  BOOL BASS_ChannelRemoveFX(HCHANNEL handle, HFX fx);
  BOOL BASS_ChannelSetAttribute(HCHANNEL handle, DWORD attrib, float value);
  HFX BASS_ChannelSetFX(HCHANNEL handle, DWORD fx, int priority);
  BOOL BASS_ChannelStop(HCHANNEL handle);
  int BASS_ErrorGetCode();
  BOOL BASS_Free();
  DWORD BASS_GetVersion();
  BOOL BASS_Init(int device, DWORD frequency, DWORD flags, void *win, const void *dsguid);
  HSTREAM BASS_StreamCreateFile(BOOL mem, const char *file, QWORD offset, QWORD length, DWORD flags);
  BOOL BASS_StreamFree(HSTREAM handle);
]]

return ffi.load("bass")