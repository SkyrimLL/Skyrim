;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_dream_02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Debug.Notification("Sanguine pulls you to him")
; _SDKP_sex.SendStoryEvent(akRef1 = akSpeaker, akRef2 = akSpeaker.GetDialogueTarget(), aiValue1 = 0, aiValue2 = Utility.RandomInt( 0, 4 ) )
akSpeaker.SendModEvent("PCSubSex")
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Keyword Property _SDKP_sex  Auto  

GlobalVariable Property _SDGVP_positions  Auto  

GlobalVariable Property _SDGV_SanguineBlessing  Auto  
