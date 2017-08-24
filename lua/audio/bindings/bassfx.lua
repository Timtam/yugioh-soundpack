ffi = require("ffi")

ffi.cdef[[
  typedef uint32_t DWORD;
  typedef int BOOL;

  typedef struct {
    float fRate;
    int lChannel;
  } BASS_BFX_ROTATE;

  typedef struct {
    int lChannel;
    float fVolume;
  } BASS_BFX_VOLUME;

  typedef struct {
    int lBand;
    float fBandwidth;
    float fQ;
    float fCenter;
    float fGain;
    int lChannel;
  } BASS_BFX_PEAKEQ;

  typedef struct {
    const int *lChannel;
  } BASS_BFX_MIX;

  typedef struct {
    float fTarget;
    float fQuiet;
    float fRate;
    float fGain;
    float fDelay;
    int lChannel;
  } BASS_BFX_DAMP;

  typedef struct {
    float fDryMix;
    float fWetMix;
    float fFeedback;
    float fRate;
    float fRange;
    float fFreq;
    int lChannel;
  } BASS_BFX_AUTOWAH;

  typedef struct {
    float fDryMix;
    float fWetMix;
    float fFeedback;
    float fRate;
    float fRange;
    float fFreq;
    int lChannel;
  } BASS_BFX_PHASER;

  typedef struct {
    float fDryMix;
    float fWetMix;
    float fFeedback;
    float fMinSweep;
    float fMaxSweep;
    float fRate;
    int lChannel;
  } BASS_BFX_CHORUS;

  typedef struct {
    float fDrive;
    float fDryMix;
    float fWetMix;
    float fFeedback;
    float fVolume;
    int lChannel;
  } BASS_BFX_DISTORTION;

  typedef struct {
    float fGain;
    float fThreshold;
    float fRatio;
    float fAttack;
    float fRelease;
    int lChannel;
  } BASS_BFX_COMPRESSOR2;

  typedef struct {
    int lChannel;
    int lNodeCount;
    const struct BASS_BFX_ENV_NODE *pNodes;
    BOOL bFollow;
  } BASS_BFX_VOLUME_ENV;

  typedef struct BASS_BFX_ENV_NODE {
    double pos;
    float val;
  } BASS_BFX_ENV_NODE;

  typedef struct {
    int lFilter;
    float fCenter;
    float fGain;
    float fBandwidth;
    float fQ;
    float fS;
    int lChannel;
  } BASS_BFX_BQF;

  typedef struct {
    float fDryMix;
    float fWetMix;
    float fFeedback;
    float fDelay;
    BOOL bStereo;
    int lChannel;
  } BASS_BFX_ECHO4;

  typedef struct {
    float fPitchShift;
    float fSemitones;
    long lFFTsize;
    long lOsamp;
    int lChannel;
  } BASS_BFX_PITCHSHIFT;

  typedef struct {
    float fDryMix;
    float fWetMix;
    float fRoomSize;
    float fDamp;
    float fWidth;
    DWORD lMode;
    int lChannel;
  } BASS_BFX_FREEVERB;

  DWORD BASS_FX_GetVersion();
]]

return ffi.load("bass_fx")