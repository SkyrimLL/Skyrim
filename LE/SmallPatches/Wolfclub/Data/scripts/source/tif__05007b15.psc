;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname TIF__05007B15 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; WDoor.Lock(false)

Utility.Wait(8.0)

Game.GetPlayer().RemoveFromFaction(BanditAllyFaction)

Int iButton = OptionsMESG.Show()


If iButton == 0  ; Enslaved
	akSpeaker.SendModEvent("PCSubEnslave")
	Debug.MessageBox("You decide to help Darren. You notice his heart stopped beating, so you decide to give him a heart massage and mouth to mouth breathing. After while, he coughes and gets back to life. He does not seem happy, though. He slaps your face, striking you on the bed. 'You tried to kill me, bitch? I'll teach you manners!' He tightens your cuffs and says: 'You are my slave now, cunt!'")
ElseIf iButton == 1 ; Free
	akSpeaker.Kill()
	Debug.MessageBox("You stay put and watch Darren struggle. After while, all signs of life seem to fade. Your captor was probably killed by a heartstroke. All the bad luck you had, now the card has turned. Instead of personal servitude to an old pervert guy, you are now free. Your old equipment is still in possesion of the Wolfclub bandits, so you are in aN unknown place, bare naked..")
EndIf
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
WolfclubStage.SetValueInt(0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
ObjectReference Property WDoor Auto
Faction Property BanditAllyFaction Auto
GlobalVariable Property WolfclubStage Auto
Message Property OptionsMESG Auto
