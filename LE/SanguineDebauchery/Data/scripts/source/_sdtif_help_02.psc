;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname _sdtif_help_02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
While ( Utility.IsInMenuMode() )
EndWhile

; _SDKP_sex.SendStoryEvent(akLoc = akSpeaker.GetCurrentLocation(), akRef1 = akSpeaker, akRef2 = akSpeaker.GetDialogueTarget(), aiValue1 = 5, aiValue2 = Utility.RandomInt( 0, _SDGVP_positions.GetValueInt() ) )

; funct.SanguineRape( akSpeaker, akSpeaker.GetDialogueTarget() , "Aggressive")

Int randomNum = Utility.RandomInt(0, 100)
; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
StorageUtil.SetIntValue( Game.GetPlayer() , "_SD_iDom", StorageUtil.GetIntValue( Game.GetPlayer(), "_SD_iDom") + 1)

If (randomNum > 60)
	akSpeaker.SendModEvent("PCSubPunish") ; Punishment
ElseIf (randomNum > 20)
	akSpeaker.SendModEvent("PCSubWhip") ; Whipping
Else
	akSpeaker.SendModEvent("PCSubSex") ; Sex
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Keyword Property _SDKP_sex  Auto  

GlobalVariable Property _SDGVP_positions  Auto  

SexLabFramework Property SexLab  Auto  
_SDQS_functions Property funct  Auto
