;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_JobMage79 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer()

kPlayer.RemoveItem(Dagger, 1) 
Self.GetOwningQuest().SetStage(79)

if (Self.GetOwningQuest().GetStageDone(69))
Self.GetOwningQuest().SetStage(81)
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

WEAPON Property Dagger  Auto  

SoulGem Property FilledSoulGem  Auto  
