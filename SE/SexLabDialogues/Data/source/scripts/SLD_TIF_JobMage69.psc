;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_JobMage69 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer()

; kPlayer.RemoveItem(HealthPotion, 10)

Self.GetOwningQuest().SetStage(69)

if (Self.GetOwningQuest().GetStageDone(79))
Self.GetOwningQuest().SetStage(81)
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Potion Property HealthPotion  Auto  
