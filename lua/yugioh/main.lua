Audio = nil
Config = nil
Dir = require('pl.dir')
Interface = nil
Music = nil
MusicFile = ''
MusicMode = 0 -- 0 = not set, 1 = lounge, 2 = duel
Path = require('pl.path')
PPI = require('ppi')
TriggerHandler = require('yugioh.triggerhandler')()
VolumeControl = 1 -- 1 = sounds, 2 = music

function OnWorldOpen()

  -- connecting to several plugins via PPI
  Audio = PPI.Load("aedf0cb0be5bf045860d54b7")
  if not Audio then
    error('Unable to initialize audio package.')
  end

  Config = PPI.Load(world.GetVariable('Configuration'))

  Config.Set('settings', 'AutoChaining', 0)
  Config.Set('settings', 'MusicMuted', 0)
  Config.Set('settings', 'MusicVolume', 10)
  Config.Set('settings', 'Omitting', 1)
  Config.Set('settings', 'SoundsMuted', 0)
  Config.Set('settings', 'SoundVolume', 50)
  Config.Load()

  -- defining all world accelerators
  world.Accelerator('F9', 'volume_down')
  world.Accelerator('F10', 'volume_up')
  world.Accelerator('F11', 'volume_toggle')
  world.Accelerator('F12', 'volume_mute')
  Interface = require('yugioh.interface')(PlaySound, PlayLifepoints, SetMusicMode)
end

function OnWorldDisconnect()
  TriggerHandler:Unload()
  SetMusicMode(0)
end

-- seems like the disconnect callback doesn't get called when closing the world
-- we will do this here manually
function OnWorldClose()
  OnWorldDisconnect()
end

function PlaySound(file, pan)
  pan = pan or 0
  if Config.Get('settings', 'SoundsMuted') == 1 then
    return
  end
  if(not Path.isabs(file)) then
    file=Path.join(GetInfo(74), file)
  end
  file = file..'.ogg'
  return Audio.play(file, 0, pan, Config.Get('settings', 'SoundVolume'))
end

function PlayMusic(file)

  if Config.Get('settings', 'MusicMuted') == 1 then
    return
  end
  if(not Path.isabs(file)) then
    file=Path.join(GetInfo(74), "Music", file)
  end
  if Music ~= nil and Audio.isPlaying(Music) == 1 then
    Audio.fadeout(Music, 1.0)
    Music = nil
    world.EnableTimer('MusicLooper', false)
    world.DoAfterSpecial(0.5, 'PlayMusic(\''..Path.relpath(file, Path.join(GetInfo(74), 'music')):gsub('\\', '\\\\')..'\')', sendto.script)
  else
    Music = Audio.play(file, 0, 0, Config.Get('settings', 'MusicVolume'))
    MusicFile = file
    world.EnableTimer('MusicLooper', true)
  end
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
    if Music ~= nil and Audio.isPlaying(Music) == 1 then
      Audio.setVol(tmp, Music)
    end
    world.Note('Music Volume: '..tostring(tmp)..'%')
  end

end

function VolumeMute()

  if VolumeControl == 1 and Config.Get('settings', 'SoundsMuted') == 1 then
    Config.Set('settings', 'SoundsMuted', 0)
    world.Note('Sounds unmuted')
  elseif VolumeControl == 1 and Config.Get('settings', 'SoundsMuted') == 0 then
    Config.Set('settings', 'SoundsMuted', 1)
    world.Note('Sounds muted')
  elseif VolumeControl == 2 and Config.Get('settings', 'MusicMuted') == 1 then
    Config.Set('settings', 'MusicMuted', 0)
    world.Note('Music unmuted')
    SetMusicMode(MusicMode)
  elseif VolumeControl == 2 and Config.Get('settings', 'MusicMuted') == 0 then
    Config.Set('settings', 'MusicMuted', 1)
    world.Note('Music muted')
    if Music ~= nil and Audio.isPlaying(Music) == 1 then
      Audio.fadeout(Music, 1.0)
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
  interval=100
  plays=lp_lost / 100
  delay=0
  while plays > 0 do
    Audio.playDelay(Path.join(GetInfo(74), 'duel', 'lp.ogg'),delay,0,Config.Get('settings', 'SoundVolume'))
    delay=delay + interval
    plays=plays - 1
  end

  local tmp

  if lp_now <= 0 then
    tmp = 'lpzero.ogg'
  else
    tmp = 'lpend.ogg'
  end
  Audio.playDelay(Path.join(GetInfo(74), 'duel', tmp), delay, 0, Config.Get('settings', 'SoundVolume'))
end

function SetMusicMode(mode)

  if Music ~= nil and Audio.isPlaying(Music) == 1 and MusicMode == mode then
    return
  end

  if mode == 0 then
    if Music ~= nil and Audio.isPlaying(Music) == 1 then
      Audio.fadeout(Music, 1.0)
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

    until file ~= MusicFile

    PlayMusic(file)

  end

  MusicMode = mode

end

function MusicLooper()

  if MusicMode > 0 and Music ~= nil and Audio.isPlaying(Music) == 0 and Config.Get('settings', 'MusicMuted') == 0 then
    SetMusicMode(MusicMode)
  end

end
