;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLSDDi_TIF_PetFree02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Debug.MessageBox("The Pet's bindings snap open and release her from servitude.")

;_SLSD_PetPlugFree.SetValue(1)
PetSlaveFreeScene.Start()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Scene Property PetSlaveFreeScene  Auto  
GlobalVariable Property _SLSD_PetPlugFree  Auto  
