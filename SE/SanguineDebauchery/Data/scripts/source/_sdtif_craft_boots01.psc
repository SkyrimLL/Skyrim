;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_craft_boots01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor PlayerActor = Game.GetPlayer()
 
PlayerActor.RemoveItem(Gold001, 100 )

PlayerActor.SendModEvent("SDGetDevice",   "Boots")


Utility.Wait(2.0)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
_SDQS_fcts_outfit Property fctOutfit  Auto

MiscObject Property Gold001  Auto  
