Class = require('pl.class')
File = require('pl.file')
JSON = require('json')
Path = require('pl.path')

Class.TriggerHandler()

function TriggerHandler:_init()
  self.folder = Path.join(world.GetInfo(67), 'triggers')
  self.triggers = {}
end

function TriggerHandler:Load(language)

  self:Unload()

  if not Path.exists(Path.join(self.folder, language..'.json')) then
    return
  end
  local triggers = JSON.decode(File.read(Path.join(self.folder, language..'.json')))

  for i, trigger in pairs(triggers) do

    -- we will compose the table entries first
    self.triggers[i] = {}
    self.triggers[i].text = trigger.trigger
    self.triggers[i].sequence = 100
    if trigger.sequence ~= nil then
      self.triggers[i].sequence = tonumber(trigger.sequence)
    end
    self.triggers[i].name = 't_'..utils.hash(trigger.trigger)
    self.triggers[i].script = 'Interface:'..trigger.action
    self.triggers[i].flags = trigger_flag.Enabled+trigger_flag.IgnoreCase+trigger_flag.Temporary
    if trigger.omit ~= nil then
      self.triggers[i].flags = self.triggers[i].flags+trigger_flag.OmitFromOutput
    end

    -- the trigger can be injected at the end
    local success = world.AddTriggerEx(self.triggers[i].name, self.triggers[i].text, self.triggers[i].script, self.triggers[i].flags, custom_colour.NoChange, 0, '', '', sendto.script, self.triggers[i].sequence)

    if success ~= error_code.eOK then
      error('Error when creating trigger for text \''..self.triggers[i].text..'\': error code '..tostring(success))
    end
  end
end

function TriggerHandler:Unload()

  for i = 1, #self.triggers, 1 do
    world.DeleteTrigger(self.triggers[i].name)
  end

  self.triggers = {}

end

return TriggerHandler