local class = require("pl.class")
local ppi = require("ppi")

class.SoundStack()

function SoundStack:_init(audio)

  self.audio = audio
  self.bass = audio.BASS()
  self.config = ppi.Load(world.GetVariable('Configuration'))
  self.sounds = {}
  self.overlap_time = 0.1 -- 10% of file length

end

-- adds a sound and plays it as soon as possible
function SoundStack:Add(sound)

  if type(sound) == 'string' then
    -- we got the filename only, so we need to create a new sound object
    sound = self.bass:StreamCreateFile(false, sound)
  end

  sound:SetAttribute(self.audio.CONST.attribute.volume, self.config.Get('settings', 'SoundVolume')/100)

  self:Cleanup()

  local time = self:GetRemainingTime()

  self.sounds[#(self.sounds)+1] = sound

  if time == 0 then
    sound:Play()
  else
    world.DoAfterSpecial(time, 'SoundStack:PlayNext()', sendto.script)
  end

end

function SoundStack:GetRemainingTime()

  local time = 0

  for i, snd in pairs(self.sounds) do

    time = time + math.max(0, (self.overlap_time * snd.length) - snd.position)

  end

  return time

end

function SoundStack:Cleanup(all)

  all = all or false

  while #(self.sounds) > 0 do

    if self.sounds[1]:IsActive() == Audio.CONST.active.stopped or all == true then
      self.sounds[1]:Stop()
      self.sounds[1]:Free()
      table.remove(self.sounds, 1)
    else
      break
    end

  end

end

-- will automatically play the next sound to be played
function SoundStack:PlayNext()

  self:Cleanup()

  for i, snd in pairs(self.sounds) do
    if snd:IsActive() == self.audio.CONST.active.stopped then
      snd:Play()
      if #(self.sounds) > i then
        world.DoAfterSpecial(self:GetRemainingTime(), 'SoundStack:PlayNext()', sendto.script)
      end
      break
    end
  end

end

return SoundStack