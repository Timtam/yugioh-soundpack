ffi = require("ffi")

ffi.cdef[[
  typedef short BOOL;
  typedef uint32_t DWORD;
  typedef uint64_t QWORD;
  typedef DWORD HCHANNEL;
  typedef DWORD HFX;
  typedef DWORD HPLUGIN;
  typedef DWORD HSAMPLE;
  typedef DWORD HSTREAM;

  typedef struct {
    float fWetDryMix;
    float fDepth;
    float fFeedback;
    float fFrequency;
    DWORD lWaveform;
    float fDelay;
    DWORD lPhase;
  } BASS_DX8_CHORUS;

  typedef struct {
    float fGain;
    float fAttack;
    float fRelease;
    float fThreshold;
    float fRatio;
    float fPredelay;
  } BASS_DX8_COMPRESSOR;

  typedef struct {
    float fGain;
    float fEdge;
    float fPostEQCenterFrequency;
    float fPostEQBandwidth;
    float fPreLowpassCutoff;
  } BASS_DX8_DISTORTION;

  typedef struct {
    float fWetDryMix;
    float fFeedback;
    float fLeftDelay;
    float fRightDelay;
    BOOL lPanDelay;
  } BASS_DX8_ECHO;

  typedef struct {
    float fWetDryMix;
    float fDepth;
    float fFeedback;
    float fFrequency;
    DWORD lWaveform;
    float fDelay;
    DWORD lPhase;
  } BASS_DX8_FLANGER;

  typedef struct {
    DWORD dwRateHz;
    DWORD dwWaveShape;
  } BASS_DX8_GARGLE;

  typedef struct {
    int lRoom;
    int lRoomHF;
    float flRoomRolloffFactor;
    float flDecayTime;
    float flDecayHFRatio;
    int lReflections;
    float flReflectionsDelay;
    int lReverb;
    float flReverbDelay;
    float flDiffusion;
    float flDensity;
    float flHFReference;
  } BASS_DX8_I3DL2REVERB;

  typedef struct {
    float fCenter;
    float fBandwidth;
    float fGain;
  } BASS_DX8_PARAMEQ;

  typedef struct {
    float fInGain;
    float fReverbMix;
    float fReverbTime;
    float fHighFreqRTRatio;
  } BASS_DX8_REVERB;

  typedef struct {
    DWORD freq;
    DWORD chans;
    DWORD flags;
    DWORD ctype;
    DWORD origres;
    HPLUGIN plugin;
    HSAMPLE sample;
    char *filename;
  } BASS_CHANNELINFO;

  BOOL BASS_ChannelGetAttribute(HCHANNEL handle, DWORD attrib, float *value);
  BOOL BASS_ChannelGetInfo(HCHANNEL handle, BASS_CHANNELINFO * info);
  DWORD BASS_ChannelIsActive(HCHANNEL handle);
  BOOL BASS_ChannelPause(HCHANNEL handle);
  BOOL BASS_ChannelPlay(HCHANNEL handle, BOOL restart);
  BOOL BASS_ChannelRemoveFX(HCHANNEL handle, HFX fx);
  BOOL BASS_ChannelSetAttribute(HCHANNEL handle, DWORD attrib, float value);
  HFX BASS_ChannelSetFX(HCHANNEL handle, DWORD fx, int priority);
  BOOL BASS_ChannelStop(HCHANNEL handle);
  int BASS_ErrorGetCode();
  BOOL BASS_Free();
  BOOL BASS_FXGetParameters(HFX handle, void *params);
  BOOL BASS_FXReset(HCHANNEL handle);
  BOOL BASS_FXSetParameters(HFX handle, void * parameters);
  DWORD BASS_GetConfig(DWORD option);
  DWORD BASS_GetVersion();
  BOOL BASS_Init(int device, DWORD frequency, DWORD flags, void *win, const void *dsguid);
  BOOL BASS_SetConfig(DWORD option, DWORD value);
  HSTREAM BASS_StreamCreateFile(BOOL mem, const char *file, QWORD offset, QWORD length, DWORD flags);
  BOOL BASS_StreamFree(HSTREAM handle);
]]

return ffi.load("bass")