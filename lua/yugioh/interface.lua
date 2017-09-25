Class = require('pl.class')
PPI = require('ppi')

Class.Interface()

function Interface:_init(sound_callback, soundstack_callback, lifepoints_callback, musicmode_callback)
  self.config = PPI.Load(world.GetVariable('Configuration'))
  self.lifepoints = lifepoints_callback
  self.musicmode = musicmode_callback
  self.sound = sound_callback
  self.soundstack = soundstack_callback
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

function Interface:PlayChatAnnouncement(text)
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
  self.soundstack('duel/win')
  self.musicmode(1)
end

function Interface:PlayDuelLose()
  self.soundstack('duel/lose')
  self.musicmode(1)
end

function Interface:PlayPrompt()
  self.soundstack('prompt')
end

function Interface:PlayDuelRequest()
  self.sound('duel/request')
end

function Interface:PlayDuelStart()
  self.soundstack('duel/start')
  self.musicmode(2)
end

function Interface:PlayDuelActivate()
  self.soundstack('duel/activate')
end

function Interface:PlayDuelStandby()
  self.soundstack('duel/standby')
end

function Interface:PlayDuelEnd()
  self.soundstack('duel/end')
end

function Interface:PlayDuelEffect()
  self.soundstack('duel/effect')
end

function Interface:PlayDuelMain()
  self.soundstack('duel/main')
end

function Interface:PlayDuelDraw()
  self.soundstack('duel/draw')
end

function Interface:PlayDuelFacedown()
  self.soundstack('duel/facedown')
end

function Interface:PlayDuelBattle()
  self.soundstack('duel/battle')
end

function Interface:PlayDuelAttention()
  self.soundstack('duel/attention')
end

function Interface:PlayDuelInvalid()
  self.sound('duel/invalid')
end

function Interface:PlayDuelChain()
  self.soundstack('duel/chain')
  if self.config.Get('settings', 'AutoChaining') ~= 0 then
    world.Execute('c')
  end
end

function Interface:PlayDuelSpecial()
  self.soundstack('duel/special')
end

function Interface:PlayDuelDefense()
  self.soundstack('duel/defense')
end

function Interface:PlayDuelDestroy()
  self.soundstack('duel/destroy')
end

function Interface:PlayDuelAttack()
  self.soundstack('duel/attack')
end

function Interface:PlayDuelDamage()
  self.soundstack('duel/damage')
end

function Interface:PlayDuelNormal()
  self.soundstack('duel/normal')
end

function Interface:PlayDuelFlip()
  self.soundstack('duel/flip')
end

function Interface:PlayDuelSwitchDefense()
  self.soundstack('duel/switch_defense')
end

function Interface:PlayDuelSwitchAttack()
  self.soundstack('duel/switch_attack')
end

function Interface:PlayDuelSwitchFlip()
  self.soundstack('duel/switch_flip')
end

function Interface:PlayDuelDamageEnd()
  self.soundstack('duel/damageend')
end

function Interface:PlayDuelAim()
  self.soundstack('duel/aim')
end

function Interface:PlayDuelTribute()
  self.soundstack('duel/tribute')
end

function Interface:PlayEarnLifepoints(lp_lost, lp_now)
  self.soundstack('duel/earn')
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
  self.soundstack('duel/equip')
end

function Interface:PlayDuelShow()
  self.soundstack('duel/show')
end

function Interface:PlayWelcome()

  if self.config.Get('settings', 'LogonSound') ~= 0 then
    self.sound('welcome')
  end

end

function Interface:PlayDuelReplay()

  self.soundstack('duel/replay')

end

function Interface:PlayDuelReturn()

  self.soundstack('duel/return')

end

function Interface:PlayChallengeVictory(text)
  self.sound("challenge/victory")
  world.Execute('history_add challenge='..text)

end

function Interface:PlayChallengeStart(text)

  self.sound('challenge/start')
  world.Execute('history_add challenge='..text)

end

function Interface:PlayChallengeSubmit(text)

  self.sound('challenge/submit')
  world.Execute('history_add challenge='..text)

end

function Interface:PlayDuelDice()

  self.soundstack('duel/dice')

end

function Interface:PlayDuelCoin()

  self.soundstack('duel/coin')

end

function Interface:PlayDuelWatch()

  self.soundstack('duel/watch')
  self.musicmode(2)

end

function Interface:PlayDuelUnwatch()

  self.soundstack('duel/unwatch')
  self.musicmode(1)

end

function Interface:PlayDuelXYZDetach()
  self.soundstack('duel/detach')

end

function Interface:PlayDuelSendToGrave()
  self.soundstack('duel/sendtograve')
end

function Interface:PlayDuelDiscard()

  self.soundstack("duel/discard")

end

function Interface:PlayDuelShuffle()

  self.soundstack('duel/shuffle')

end

function Interface:PlayDuelBanish()
  self.soundstack('duel/banish')
end

function Interface:PlayDuelSendToDeck()
  self.soundstack('duel/sendtodeck')
end

function Interface:PlayDuelSendToExtraDeck()
  self.soundstack('duel/sendtoextradeck')
end

function Interface:PlayDuelSwitchFacedown()
  self.soundstack('duel/switch_facedown')
end

return Interface