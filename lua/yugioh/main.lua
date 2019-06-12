Audio = require("audio")
BASS = Audio.BASS()
BASSSTREAM = require("audio.bass.stream")
Config = nil
Dir = require('pl.dir')
Focused = true
Interface = nil
Music = nil
MusicMode = 0 -- 0 = not set, 1 = lounge, 2 = duel
Path = require('pl.path')
PPI = require('ppi')
SoundStack = require("yugioh.soundstack")(Audio)
TriggerHandler = require('yugioh.triggerhandler')()
VolumeControl = 1 -- 1 = sounds, 2 = music

function OnWorldOpen()

  -- connecting to several plugins via PPI
  Config = PPI.Load(world.GetVariable('Configuration'))

  Config.Set('settings', 'AutoChaining', 0)
  Config.Set('settings', 'LogonSound', 1)
  Config.Set('settings', 'MusicMuted', 0)
  Config.Set('settings', 'MusicVolume', 10)
  Config.Set('settings', 'Omitting', 1)
  Config.Set('settings', 'SoundOverlapTime', 0.4)
  Config.Set('settings', 'SoundsMuted', 0)
  Config.Set('settings', 'SoundVolume', 50)
  Config.Set('settings', 'UnfocusedSounds', 1)
  Config.Load()
  Config.AddConfigurable{section='settings', option='AutoChaining', type='bool', description='always reject chaining questions', key = 'ctrl+alt+c'}
  Config.AddConfigurable{section='settings', option='LogonSound', type='bool', description='play sound when logging in', key='ctrl+alt+l'}
  Config.AddConfigurable{section='settings', option='Omitting', type='bool', description='don\'t show unimportant messages', key='ctrl+alt+o'}
  Config.AddConfigurable{section='settings', option='SoundOverlapTime', type='number', description='overlap time of stacked sounds. Between 1.0 and 0.0, where 1.0 means total overlap and 0.0 means no overlap at all.'}
  Config.AddConfigurable{section='settings', option='UnfocusedSounds', type='bool', description='play unimportant sounds when the soundpack window is currently not focused?', key='ctrl+alt+u'}

  -- defining all world accelerators
  world.Accelerator('F9', 'volume_down')
  world.Accelerator('F10', 'volume_up')
  world.Accelerator('F11', 'volume_toggle')
  world.Accelerator('F12', 'volume_mute')
  Interface = require('yugioh.interface')(PlaySound, PlaySoundStack, PlayLifepoints, SetMusicMode)

  BASS:Init()

end

function OnWorldGetFocus()
  Focused = true
end

function OnWorldLoseFocus()
  Focused = false
end

function OnWorldDisconnect()
  TriggerHandler:Unload()
  SetMusicMode(0)
  SoundStack:Cleanup(true)
end

-- seems like the disconnect callback doesn't get called when closing the world
-- we will do this here manually
function OnWorldClose()
  OnWorldDisconnect()
end

function PlaySound(file, pan, important)

  pan = pan or 0
  important = important or false

  if Config.Get('settings', 'SoundsMuted') == 1 then
    return
  end

  if important == false and Focused == false and Config.Get('settings', 'UnfocusedSounds') == 0 then
    return
  end
  
  if(not Path.isabs(file)) then
    file=Path.join(GetInfo(74), file)
  end
  file = file..'.ogg'
  local stream = BASS:StreamCreateFile(false, file, 0, 0, Audio.CONST.stream.auto_free)
  stream:SetAttribute(Audio.CONST.attribute.volume, Config.Get('settings', 'SoundVolume')/100)
  stream:SetAttribute(Audio.CONST.attribute.pan, pan)
  stream:Play()
  return stream
end

function PlaySoundStack(file, important)

  important = important or false

  if Config.Get('settings', 'SoundsMuted') == 1 then
    return
  end

  if important == false and Focused == false and Config.Get('settings', 'UnfocusedSounds') == 0 then
    return
  end

  if (not Path.isabs(file)) then
    file = Path.join(world.GetInfo(74), file)
  end
  file = file..'.ogg'

  SoundStack:Add(file)

end

function PlayMusic(file)

  if Config.Get('settings', 'MusicMuted') == 1 then
    return
  end
  if(not Path.isabs(file)) then
    file=Path.join(GetInfo(74), "Music", file)
  end
  if Music ~= nil and Music:IsActive() == Audio.CONST.active.playing then
    Music:Stop()
    Music:Free()
    Music = nil
  end
  Music = BASS:StreamCreateFile(false, file)
  Music:SetAttribute(Audio.CONST.attribute.volume, Config.Get('settings', 'MusicVolume')/100)
  Music:Play()
end

function Volume(value)

  if VolumeControl == 1 and Config.Get('settings', 'SoundsMuted') == 1 then
    return
  end

  if VolumeControl == 2 and Config.Get('settings', 'MusicMuted') == 1 then
    return
  end

  local tmp

  if VolumeControl == 1 then
    tmp = Config.Get('settings', 'SoundVolume') + value
  elseif VolumeControl == 2 then
    tmp = Config.Get('settings', 'MusicVolume') + value
  end

  if tmp < 0 or tmp > 100 then
    return
  end

  if VolumeControl == 1 then
    Config.Set('settings', 'SoundVolume', tmp)
    PlaySound('Beep')
    world.Note('Sound Volume: '..tostring(tmp)..'%')
  elseif VolumeControl == 2 then
    Config.Set('settings', 'MusicVolume', tmp)
    if Music ~= nil and Music:IsActive() == Audio.CONST.active.playing then
      Music:SetAttribute(Audio.CONST.attribute.volume, tmp/100)
    end
    world.Note('Music Volume: '..tostring(tmp)..'%')
  end

end

function VolumeMute()

  if VolumeControl == 1 and Config.Get('settings', 'SoundsMuted') == 1 then
    Config.Set('settings', 'SoundsMuted', 0)
    world.Note('Sounds unmuted')
  elseif VolumeControl == 1 and Config.Get('settings', 'SoundsMuted') == 0 then
    SoundStack:Cleanup(true)
    Config.Set('settings', 'SoundsMuted', 1)
    world.Note('Sounds muted')
  elseif VolumeControl == 2 and Config.Get('settings', 'MusicMuted') == 1 then
    Config.Set('settings', 'MusicMuted', 0)
    world.Note('Music unmuted')
    SetMusicMode(MusicMode)
  elseif VolumeControl == 2 and Config.Get('settings', 'MusicMuted') == 0 then
    Config.Set('settings', 'MusicMuted', 1)
    world.Note('Music muted')
    if Music ~= nil and Music:IsActive() == Audio.CONST.active.playing then
      Music:Stop()
      Music:Free()
      Music = nil
    end
  end
end

function VolumeToggle()

  if VolumeControl == 1 then
    VolumeControl = 2
    world.Note('Music')
  elseif VolumeControl == 2 then
    VolumeControl = 1
    world.Note('Sounds')
  end

  PlaySound('beep')

end

-- some helper function to efficiently play lifepoint sounds
-- which will actually differ, depending on the amount of lost lifepoints

function PlayLifepoints(lp_lost, lp_now)

  if Config.Get('settings', 'SoundsMuted') == 1 then
    return
  end
  lp_lost=tonumber(lp_lost)
  lp_now = tonumber(lp_now)
  if lp_lost == nil then
    return
  end

  if lp_lost < 100 then
    lp_lost = 100
  end

  local lp_sound = BASS:StreamCreateFile(false, Path.join(GetInfo(74), 'duel', 'lp.ogg'))

  if lp_lost/100 <= 1 then
    SoundStack:Add(lp_sound)
  else
    lp_sound:Update()
    local lp_sound_data = lp_sound:GetData(0xfffffff)

    local sound = BASS:StreamCreate(lp_sound.frequency, lp_sound.channels, 0)

    for i = 1, lp_lost/100 do
      sound:PutData(lp_sound_data)
    end

    SoundStack:Add(sound, lp_sound.length*(lp_lost/100))

    lp_sound:Free()

  end

  local tmp

  if lp_now <= 0 then
    tmp = 'duel/lpzero'
  else
    tmp = 'duel/lpend'
  end

  tmp = Path.join(world.GetInfo(74), tmp)..'.ogg'

  SoundStack:Add(tmp)
end

function SetMusicMode(mode)

  if Music ~= nil and Music:IsActive() == Audio.CONST.active.playing and MusicMode == mode then
    return
  end

  if mode == 0 then
    if Music ~= nil and Music:IsActive() == Audio.CONST.active.playing then
      Music:Stop()
      Music:Free()
    end
    Music = nil
  else

    local tmp

    if mode == 1 then
      tmp = 'lounge'
    elseif mode == 2 then
      tmp = 'duel'
    end

    local files = Dir.getfiles(Path.join(GetInfo(74), 'music', tmp))

    local file

    repeat

      file = files[math.random(1,#files)]

    until Music == nil or Music.filename ~= file

    PlayMusic(file)

  end

  MusicMode = mode

end

function MusicLooper()

  if MusicMode > 0 and Music ~= nil and Music:IsActive() ~= Audio.CONST.active.playing and Config.Get('settings', 'MusicMuted') == 0 then
    SetMusicMode(MusicMode)
  end

end