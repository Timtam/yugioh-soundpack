Config = {}
Config.settings = {}
Config.settings.SoundsMuted = 0
Config.settings.SoundVolume=50
Audio = nil
Ini = require("ini")
Path = require('pl.path')
PPI = require("ppi")

function OnWorldOpen()

  -- loading and parsing the configuration file
  local ctbl = Ini.read('config.dat')

  if ctbl then
    for name, section in pairs(ctbl) do
      for optionname, optionvalue in pairs(section) do
        config = tonumber(optionvalue)
        if config == nil then
          config = optionvalue
        end
        if Config[name] == nil then
          Config[name] = {}
        end
        Config[name][optionname] = config
      end
    end
  end

  -- connecting to the LuaAudio plugin via PPI
  Audio = PPI.Load("aedf0cb0be5bf045860d54b7")
  if not Audio then
    error('Unable to initialize audio package.')
  end


  -- defining all world accelerators
  world.Accelerator('F9', 'volume_down')
  world.Accelerator('F10', 'volume_up')
  world.Accelerator('F11', 'volume_mute')
end

function OnWorldClose()
  Ini.write('config.dat', Config)
end

function PlaySound(file, pan)
  pan = pan or 0
  if (Config.settings.SoundsMuted == 1) then
    return
  end
  if(not Path.isabs(file)) then
    file=Path.join(GetInfo(74), file)
  end
  file = file..'.ogg'
  return Audio.play(file, 0, pan, Config.settings.SoundVolume)
end

function Volume(value)

  if Config.settings.SoundsMuted == 1 then
    return
  end

  local tmp = Config.settings.SoundVolume + value

  if tmp < 0 or tmp > 100 then
    return
  end

  Config.settings.SoundVolume = tmp

  PlaySound('Beep')

  world.Note('Volume: '..tostring(tmp)..'%')
end

function VolumeMute()

  if Config.settings.SoundsMuted == 1 then
    Config.settings.SoundsMuted = 0
    world.Note('Sounds unmuted')
  else
    Config.settings.SoundsMuted = 1
    world.Note('Sounds muted')
  end
end
