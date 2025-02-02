;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLS_TIF_RedWaveBouncer Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer()
Int randomNum = Utility.RandomInt(0, 100)
; StorageUtil.SetFormValue( kPlayer , "_SD_TempAggressor", akSpeaker)
StorageUtil.SetIntValue( kPlayer , "_SD_iSub", StorageUtil.GetIntValue( kPlayer, "_SD_iSub") + 1)
StorageUtil.SetIntValue( akSpeaker, "_SD_iDisposition", StorageUtil.GetIntValue( akSpeaker, "_SD_iDisposition"  ) + 1  )

RedWaveDoorRef.Lock(false, true)
if(Quest.GetQuest("_SD_controller"))
	If (randomNum > 95)
		akSpeaker.SendModEvent("PCSubEntertain", "Dance")
	ElseIf (randomNum > 90)
		akSpeaker.SendModEvent("PCSubEntertain", "Gangbang")
	ElseIf (randomNum > 80)
		akSpeaker.SendModEvent("PCSubSex", "Aggressive,Anal") 
	ElseIf (randomNum > 70)
		akSpeaker.SendModEvent("PCSubSex", "Dirty") 
	Else
		akSpeaker.SendModEvent("PCSubSex") ; Sex
	EndIf
;	kPlayer.AddItem(Gold, (randomNum/10) * (akSpeaker.GetRelationshipRank(kPlayer)+1)  + 10) 
else
	If (randomNum > 95)
		akSpeaker.SendModEvent("RedWaveEntertain", "Dance")
	ElseIf (randomNum > 90)
		akSpeaker.SendModEvent("RedWaveEntertain", "Soloshow")
	ElseIf (randomNum > 80)
		akSpeaker.SendModEvent("RedWaveSex", "Aggressive,Anal") 
	ElseIf (randomNum > 70)
		akSpeaker.SendModEvent("RedWaveSex", "Dirty") 
	Else
		akSpeaker.SendModEvent("RedWaveSex") ; Sex
	EndIf
endif
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ObjectReference Property RedWaveDoorRef  Auto  
SLS_QST_RedWaveController Property RedWaveController Auto
