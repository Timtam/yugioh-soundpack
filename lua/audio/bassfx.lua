local addon = require("audio.bass.addon")
local class = require("pl.class")
local const = require("audio.bassfx.constants")
local fx = require("audio.bass.fx")

local _fx_parameters = {
  [const.fx.bfx_rotate] = 'BASS_BFX_ROTATE',
  [const.fx.bfx_volume] = 'BASS_BFX_VOLUME',
  [const.fx.bfx_peakeq] = 'BASS_BFX_PEAKEQ',
  [const.fx.bfx_mix] = 'BASS_BFX_MIX',
  [const.fx.bfx_autowah] = 'BASS_BFX_AUTOWAH',
  [const.fx.bfx_damp] = 'BASS_BFX_DAMP',
  [const.fx.bfx_phaser] = 'BASS_BFX_PHASER',
  [const.fx.bfx_chorus] = 'BASS_BFX_CHORUS',
  [const.fx.bfx_distortion] = 'BASS_BFX_DISTORTION',
  [const.fx.bfx_compressor2] = 'BASS_BFX_COMPRESSOR2',
  [const.fx.bfx_volume_env] = 'BASS_BFX_VOLUME_ENV',
  [const.fx.bfx_bqf] = 'BASS_BFX_BQF',
  [const.fx.bfx_echo4] = 'BASS_BFX_ECHO4',
  [const.fx.bfx_pitchshift] = 'BASS_BFX_PITCHSHIFT',
  [const.fx.bfx_freeverb] = 'BASS_BFX_FREEVERB'
}

class.BASSFX(addon)

function BASSFX:_init()

  self.bassfx = require("audio.bindings.bassfx")

  self:super()

end

function BASSFX:_load()

  self._base._load(self)

  self:_inject_table(package.loaded['audio.bass.constants'], const)
  self:_inject_table(fx._parameters, _fx_parameters)

end

function BASSFX:GetVersion()

  return self.bassfx.BASS_FX_GetVersion()

end

return BASSFX