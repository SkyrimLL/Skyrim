;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SIP_TIF_FishermanDest01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
ObjectReference PlayerRef = Game.GetPlayer()

Game.FadeOutGame(true, true, 0.1, 15)

PlayerRef.moveTo(  FishermanDestMarker )
		
Game.FadeOutGame(false, true, 0.01, 10)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ObjectReference Property FishermanDestMarker  Auto  
