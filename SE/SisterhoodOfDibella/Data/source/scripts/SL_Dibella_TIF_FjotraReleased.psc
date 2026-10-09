;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SL_Dibella_TIF_FjotraReleased Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
ObjectReference SybilREF= akspeaker as ObjectReference

akspeaker.UnequipAll()
utility.wait(0.5)
SybilREF.additem(MinerOutfit )
akspeaker.equipitem(MinerOutfit ,False,False)
utility.wait(0.5)

akspeaker.OpenInventory(true)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Armor Property MinerOutfit  Auto  

 
