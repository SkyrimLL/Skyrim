;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _sdtif_submit_05 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor akPlayer = Game.GetPlayer()

; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
StorageUtil.SetIntValue(akSpeaker, "_SD_iForcedSlavery", 0)

akSpeaker.SendModEvent("PCSubEnslave")
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
pFDS.Persuade(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

GlobalVariable Property _SDGVP_enslaved Auto
GlobalVariable Property _SDGV_leash_length Auto
Keyword Property _SDKP_bound Auto
Keyword Property _SDKP_enslave Auto
FormList Property _SDFLP_sex_items Auto
FormList Property _SDFLP_punish_items Auto
FormList Property _SDFLP_master_items Auto
_SDQS_functions Property funct Auto

SexLabFramework Property SexLab  Auto  
favordialoguescript Property pFDS  Auto  
