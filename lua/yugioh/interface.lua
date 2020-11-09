Class = require('pl.class')
local const = require("audio.bass.constants")
Dir = require("pl.dir")
Path = require("pl.path")
PPI = require('ppi')

Class.Interface()

function Interface:_init(sound_callback, soundstack_callback, lifepoints_callback, musicmode_callback)
  self.config = PPI.Load(world.GetVariable('Configuration'))
  self.lifepoints = lifepoints_callback
  self.musicmode = musicmode_callback
  self.sound = sound_callback
  self.soundstack = soundstack_callback
end

function Interface:Login()
  self.sound('login')
end

function Interface:Logout()
  self.sound('logout')
end

function Interface:Error()
  self.sound('error')
end

function Interface:DeckChange()
  self.sound('deck/change')
end

function Interface:DeckQuit()
  self.sound('deck/quit')
end

function Interface:DeckLoad()
  self.sound('deck/load')
end

function Interface:DeckImport()
  self.sound('deck/import')
end

function Interface:DeckDelete()
  self.sound('deck/delete')
end

function Interface:DeckClear()
  self.sound('deck/clear')
end

function Interface:ChatMessage(text)
  world.Execute('history_add chat='..text)
  self.sound('chat/message')
end

function Interface:ChatOn()
  self.sound('chat/on')
end

function Interface:ChatOff()
  self.sound('chat/off')
end

function Interface:ChatSay(text)
  world.Execute('history_add say='..text)
  self.sound('chat/say')
end

function Interface:ChatAnnouncement(text)
  self.sound('chat/announcement')
  world.Execute('history_add announcement='..text)
end

function Interface:ChatTalk(text)
  self.sound('chat/talk')
  world.Execute('history_add talk='..text)
end

function Interface:Who()
  self.sound('who')
end

function Interface:DuelEmpty()
  self.sound('duel/empty')
end

function Interface:DuelWait()
  self.sound('duel/wait')
end

function Interface:DuelScore()
  self.sound('duel/score')
end

function Interface:DuelTable()
  self.sound('duel/score')
end

function Interface:DuelWin()
  self.soundstack('duel/win')
  self.musicmode(1)
end

function Interface:DuelLose()
  self.soundstack('duel/lose')
  self.musicmode(1)
end

function Interface:Prompt()
  self.soundstack('prompt')
end

function Interface:DuelRequest()
  self.sound('duel/request')
end

function Interface:DuelStart()
  self.soundstack('duel/start')
  self.musicmode(2)
end

function Interface:DuelActivate()
  self.soundstack('duel/play/'..tostring(math.random(1, #Dir.getfiles(Path.join(GetInfo(74), 'duel', 'play')))))
  self.soundstack('duel/activate')
end

function Interface:DuelStandby()
  self.soundstack('duel/standby')
end

function Interface:DuelEnd()
  self.soundstack('duel/end')
end

function Interface:DuelEffect()
  self.soundstack('duel/effect')
end

function Interface:DuelMain()
  self.soundstack('duel/main')
end

function Interface:DuelDraw()
  self.soundstack('duel/draw/'..tostring(math.random(1, #Dir.getfiles(Path.join(GetInfo(74), 'duel', 'draw')))))
end

function Interface:DuelFacedown()
  self.soundstack('duel/play/'..tostring(math.random(1, #Dir.getfiles(Path.join(GetInfo(74), 'duel', 'play')))))
  self.soundstack('duel/facedown')
end

function Interface:DuelBattle()
  self.soundstack('duel/battle')
end

function Interface:DuelAttention()
  self.soundstack('duel/attention')
end

function Interface:DuelInvalid()
  self.sound('duel/invalid')
end

function Interface:DuelChain()
  self.soundstack('duel/chain')
  if self.config.Get('settings', 'AutoChaining') ~= 0 then
    world.Execute('c')
  end
end

function Interface:DuelSpecial()
  self.soundstack('duel/play/'..tostring(math.random(1, #Dir.getfiles(Path.join(GetInfo(74), 'duel', 'play')))))
  self.soundstack('duel/special')
end

function Interface:DuelDefense()
  self.soundstack('duel/play/'..tostring(math.random(1, #Dir.getfiles(Path.join(GetInfo(74), 'duel', 'play')))))
  self.soundstack('duel/defense')
end

function Interface:DuelDestroy()
  self.soundstack('duel/destroy')
end

function Interface:DuelAttack()
  self.soundstack('duel/attack')
end

function Interface:DuelDamage()
  self.soundstack('duel/damage')
end

function Interface:DuelNormal()
  self.soundstack('duel/play/'..tostring(math.random(1, #Dir.getfiles(Path.join(GetInfo(74), 'duel', 'play')))))
  self.soundstack('duel/normal')
end

function Interface:DuelFlip()
  self.soundstack('duel/play/'..tostring(math.random(1, #Dir.getfiles(Path.join(GetInfo(74), 'duel', 'play')))))
  self.soundstack('duel/flip')
end

function Interface:DuelSwitchDefense()
  self.soundstack('duel/switch_defense')
end

function Interface:DuelSwitchAttack()
  self.soundstack('duel/switch_attack')
end

function Interface:DuelSwitchFlip()
  self.soundstack('duel/switch_flip')
end

function Interface:DuelDamageEnd()
  self.soundstack('duel/damageend')
end

function Interface:DuelAim()
  self.soundstack('duel/aim')
end

function Interface:DuelTribute()
  self.soundstack('duel/tribute')
end

function Interface:EarnLifepoints(lp_lost, lp_now)
  self.soundstack('duel/earn')
  self.lifepoints(lp_lost, lp_now)
end

function Interface:LoseLifepoints(lp_lost, lp_now)
  self.lifepoints(lp_lost, lp_now)
end

function Interface:ChatReceive(text)
  self.sound('chat/receive', 0, true)
  world.Execute('history_add tell='..text)
end

function Interface:ChatSend(text)
  self.sound('chat/send')
  world.Execute('history_add tell='..text)
end

function Interface:DuelEquip()
  self.soundstack('duel/equip')
end

function Interface:DuelShow()
  self.soundstack('duel/show')
end

function Interface:Welcome()

  if self.config.Get('settings', 'LogonSound') ~= 0 then
    self.sound('welcome')
  end

end

function Interface:DuelReplay()

  self.soundstack('duel/replay')

end

function Interface:DuelReturn()

  self.soundstack('duel/draw/'..tostring(math.random(1, #Dir.getfiles(Path.join(GetInfo(74), 'duel', 'draw')))))
  self.soundstack('duel/return')

end

function Interface:ChallengeVictory(text)
  self.sound("challenge/victory")
  world.Execute('history_add challenge='..text)

end

function Interface:ChallengeStart(text)

  self.sound('challenge/start')
  world.Execute('history_add challenge='..text)

end

function Interface:ChallengeSubmit(text)

  self.sound('challenge/submit')
  world.Execute('history_add challenge='..text)

end

function Interface:DuelDice()

  self.soundstack('duel/dice')

end

function Interface:DuelCoin()

  self.soundstack('duel/coin')

end

function Interface:DuelWatch()

  self.soundstack('duel/watch')
  self.musicmode(2)

end

function Interface:DuelUnwatch()

  self.soundstack('duel/unwatch')
  self.musicmode(1)

end

function Interface:DuelXYZDetach()
  self.soundstack('duel/detach')

end

function Interface:DuelSendToGrave()
  self.soundstack('duel/sendtograve')
end

function Interface:DuelDiscard()

  self.soundstack("duel/discard")
  self.soundstack('duel/play/'..tostring(math.random(1, #Dir.getfiles(Path.join(GetInfo(74), 'duel', 'play')))))

end

function Interface:DuelShuffle()

  self.soundstack('duel/shuffle')

end

function Interface:DuelBanish()
  self.soundstack('duel/banish')
end

function Interface:DuelSendToDeck()
  self.soundstack('duel/sendtodeck')
end

function Interface:DuelSendToExtraDeck()
  self.soundstack('duel/sendtoextradeck')
end

function Interface:DuelSwitchFacedown()
  self.soundstack('duel/switch_facedown')
end

function Interface:DuelSwapControl()
  self.soundstack('duel/swapcontrol')
end

function Interface:DuelLoseControl()
  self.soundstack('duel/losecontrol')
end

function Interface:DuelGainControl()
  self.soundstack('duel/gaincontrol')
end

function Interface:DuelAddCounters(amount)
  amount = tonumber(amount)

  local i

  for i = 1, amount, 1 do
    self.soundstack('duel/counteradd')
  end

end

function Interface:DuelRemoveCounters(amount)
  amount = tonumber(amount)

  local i

  for i = 1, amount, 1 do
    self.soundstack('duel/counterremove')
  end

end

function Interface:Reconnect()
  self.sound('reconnect')
end

function Interface:DeckCheck()
  self.sound('deck/check')
end

function Interface:DuelPause()
  self.sound('duel/pause')
end

function Interface:DuelUnpause()
  self.sound('duel/unpause')
end

function Interface:DuelWatchNotification()
  self.sound('duel/watchnotification')
end

function Interface:DuelUnwatchNotification()
  self.sound('duel/unwatchnotification')
end

function Interface:RoomJoin()
  self.sound('room/join')
end

function Interface:RoomJoinNotification()
  self.sound('room/joinnotification')
end

function Interface:RoomLeave()
  self.sound('room/leave')
end

function Interface:RoomLeaveNotification()
  self.sound('room/leavenotification')
end

function Interface:ChallengeDisband()
  self.sound('challenge/disband')
end

function Interface:Linkdead()
  self.sound('linkdead')
end

function Interface:ChallengeCreate()
  self.sound('challenge/create')
end

function Interface:RoomInvite()
  self.sound('room/invite')
end

function Interface:RoomInviteNotification()
  self.sound('room/invitenotification', 0, true)
end

function Interface:DeckLoadNotification()
  self.sound('deck/loadnotification')
end

function Interface:RoomTeam(team)

  team = tonumber(team)

  local tmp

  if team == 0 then
    tmp = 'outofteam'
  else
    tmp = 'team'
  end

  local snd = self.sound('room/'..tmp)

  if team == nil then
    return -- unfocused
  end

  if team == 1 then
    tmp = -0.8
  elseif team == 2 then
    tmp = 0.8
  else
    return
  end

  local time = snd.length * 1000 * 0.8

  snd:SlideAttribute(const.attribute.pan, tmp, time)
end

function Interface:TagMessage(text)
  world.Execute('history_add tag='..text)
  self.sound('chat/tag')
end

return Interface