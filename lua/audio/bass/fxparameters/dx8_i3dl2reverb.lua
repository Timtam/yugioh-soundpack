local class = require("pl.class")
local fxparameters = require("audio.bass.fxparameters")

class.DX8_I3DL2REVERB(fxparameters)

function DX8_I3DL2REVERB:_init()

  self:LinkParameter('lRoom', 'room')
  self:LinkParameter('lRoomHF', 'room_hf')
  self:LinkParameter('flRoomRolloffFactor', 'room_rolloff_factor')
  self:LinkParameter('flDecayTime', 'decay_time')
  self:LinkParameter('flDecayHFRatio', 'decay_hf_ratio')
  self:LinkParameter('lReflections', 'reflections')
  self:LinkParameter('flReflectionsDelay', 'reflections_delay')
  self:LinkParameter('lReverb', 'reverb')
  self:LinkParameter('flReverbDelay', 'reverb_delay')
  self:LinkParameter('flDiffusion', 'diffusion')
  self:LinkParameter('flDensity', 'density')
  self:LinkParameter('flHFReference', 'hf_reference')

  self:super('BASS_DX8_I3DL2REVERB')

end

return DX8_I3DL2REVERB