Class = require('pl.class')
PPI = require('ppi')

Class.Interface()

function Interface:_init(sound_callback, lifepoints_callback, musicmode_callback)
  self.config = PPI.Load(world.GetVariable('Configuration'))
  self.lifepoints = lifepoints_callback
  self.musicmode = musicmode_callback
  self.sound = sound_callback
end

function Interface:PlayLogin()
  self.sound('login')
end

function Interface:PlayLogout()
  self.sound('logout')
end

function Interface:PlayError()
  self.sound('error')
end

function Interface:PlayDeckChange()
  self.sound('deck/change')
end

function Interface:PlayDeckQuit()
  self.sound('deck/quit')
end

function Interface:PlayDeckLoad()
  self.sound('deck/load')
end

function Interface:PlayDeckImport()
  self.sound('deck/import')
end

function Interface:PlayDeckDelete()
  self.sound('deck/delete')
end

function Interface:PlayDeckClear()
  self.sound('deck/clear')
end

function Interface:PlayChatMessage(text)
  world.Execute('history_add chat='..text)
  self.sound('chat/message')
end

function Interface:PlayChatOn()
  self.sound('chat/on')
end

function Interface:PlayChatOff()
  self.sound('chat/off')
end

function Interface:PlayChatSay(text)
  world.Execute('history_add say='..text)
  self.sound('chat/say')
end

function Interface:PlayChatAnouncement(text)
  self.sound('chat/announcement')
  world.Execute('history_add announcement='..text)
end

function Interface:PlayWho()
  self.sound('who')
end

function Interface:PlayDuelEmpty()
  self.sound('duel/empty')
end

function Interface:PlayDuelWait()
  self.sound('duel/wait')
end

function Interface:PlayDuelScore()
  self.sound('duel/score')
end

function Interface:PlayDuelTable()
  self.sound('duel/score')
end

function Interface:PlayDuelWin()
  self.sound('duel/win')
  self.musicmode(1)
end

function Interface:PlayDuelLose()
  self.sound('duel/lose')
  self.musicmode(1)
end

function Interface:PlayPrompt()
  self.sound('prompt')
end

function Interface:PlayDuelRequest()
  self.sound('duel/request')
end

function Interface:PlayDuelStart()
  self.sound('duel/start')
  self.musicmode(2)
end

function Interface:PlayDuelActivate()
  self.sound('duel/activate')
end

function Interface:PlayDuelStandby()
  self.sound('duel/standby')
end

function Interface:PlayDuelEnd()
  self.sound('duel/end')
end

function Interface:PlayDuelEffect()
  self.sound('duel/effect')
end

function Interface:PlayDuelMain()
  self.sound('duel/main')
end

function Interface:PlayDuelDraw()
  self.sound('duel/draw')
end

function Interface:PlayDuelFacedown()
  self.sound('duel/facedown')
end

function Interface:PlayDuelBattle()
  self.sound('duel/battle')
end

function Interface:PlayDuelAttention()
  self.sound('duel/attention')
end

function Interface:PlayDuelInvalid()
  self.sound('duel/invalid')
end

function Interface:PlayDuelChain()
  self.sound('duel/chain')
  if self.config.Get('settings', 'AutoChaining') ~= 0 then
    world.Execute('c')
  end
end

function Interface:PlayDuelSpecial()
  self.sound('duel/special')
end

function Interface:PlayDuelDefense()
  self.sound('duel/defense')
end

function Interface:PlayDuelDestroy()
  self.sound('duel/destroy')
end

function Interface:PlayDuelAttack()
  self.sound('duel/attack')
end

function Interface:PlayDuelDamage()
  self.sound('duel/damage')
end

function Interface:PlayDuelNormal()
  self.sound('duel/normal')
end

function Interface:PlayDuelFlip()
  self.sound('duel/flip')
end

function Interface:PlayDuelDefend()
  self.sound('duel/defend')
end

function Interface:PlayDuelDamageEnd()
  self.sound('duel/damageend')
end

function Interface:PlayDuelAim()
  self.sound('duel/aim')
end

function Interface:PlayDuelTribute()
  self.sound('duel/tribute')
end

function Interface:PlayEarnLifepoints(lp_lost, lp_now)
  self.sound('duel/earn')
  self.lifepoints(lp_lost, lp_now)
end

function Interface:PlayLoseLifepoints(lp_lost, lp_now)
  self.lifepoints(lp_lost, lp_now)
end

function Interface:PlayChatReceive(text)
  self.sound('chat/receive')
  world.Execute('history_add tell='..text)
end

function Interface:PlayChatSend(text)
  self.sound('chat/send')
  world.Execute('history_add tell='..text)
end

function Interface:PlayDuelEquip()
  self.sound('duel/equip')
end

function Interface:PlayDuelShow()
  self.sound('duel/show')
end

return Interface