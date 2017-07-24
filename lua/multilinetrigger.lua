class=require('pl.class')
class.MultilineTrigger()

function MultilineTrigger:_init(script,group,sequence)
  self.lines={}
  self.text=''
  self.script=script or ''
  self.group=group or ''
  self.sequence=sequence or 100
end

function MultilineTrigger:Line(text,regexp,omit)
  regexp=regexp or false
  omit=omit or false
  self.text=self.text..text..'\r\n'
  line={}
  line.text=text
  line.omit=omit
  line.regexp=regexp
  self.lines[#self.lines+1]=line
end

function MultilineTrigger:Inject()
  groupname=utils.hash(tostring(string.len(self.text))..'\r\n'..self.text)
  for i = 1, #self.lines, 1 do
    flags=0
    if self.lines[i].regexp then
      flags=flags+trigger_flag.RegularExpression
    end
    if self.lines[i].omit then
      flags=flags+trigger_flag.OmitFromOutput
    end
    tgroupname='t_'..groupname..'_'..tostring(i)
    if i==1 then
      if self.group=='' then
        flags=flags+trigger_flag.Enabled
      end
      world.AddTriggerEx(tgroupname,self.lines[i].text,'world.EnableGroup("'..groupname..'",1)',flags,NOCHANGE,0,'','',sendto.script,self.sequence)
      world.SetTriggerOption(tgroupname,'group',self.group)
    elseif i==#self.lines then
      world.AddTriggerEx(tgroupname,self.lines[i].text,'world.EnableGroup("'..groupname..'",0)\r\n'..self.script,flags,NOCHANGE,0,'','',sendto.script,self.sequence)
      world.SetTriggerOption(tgroupname,'group',groupname)
    else
      world.AddTriggerEx(tgroupname,self.lines[i].text,'',flags,NOCHANGE,0,'','',sendto.script,self.sequence)
      world.SetTriggerOption(tgroupname,'group',groupname)
    end
  end
end
