;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 3
Scriptname SLS_TIF_RedWavePlayerGoods01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
pFDS.Persuade(akSpeaker)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_2
Function Fragment_2(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer()
Int randomNum = Utility.RandomInt(150, 300)

StorageUtil.SetIntValue( akSpeaker, "_SD_iDisposition", StorageUtil.GetIntValue( akSpeaker, "_SD_iDisposition"  ) + 1  )


kPlayer.RemoveItem(skooma, 1)
kPlayer.AddItem(Gold, (randomNum/10) * (akSpeaker.GetRelationshipRank(kPlayer)+1)  + 10)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

favordialoguescript Property pFDS  Auto  
GlobalVariable Property RedWaveDebt  Auto  

MiscObject Property Gold  Auto  
Potion Property Goods Auto

Potion Property Skooma  Auto  
