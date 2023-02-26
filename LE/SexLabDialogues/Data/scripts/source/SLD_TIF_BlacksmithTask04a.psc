;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_BlacksmithTask04a Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer() as Actor
ObjectReference kPlayerRef = Game.GetPlayer()

kPlayerRef.AddItem(BalimundKey  ,1)
kPlayer.AddToFaction( BalimundFaction )
HomeLockList.AddForm(kPlayer as Form)

Self.GetOwningQuest().SetStage(310)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Key Property BalimundKey  Auto  

Faction Property BalimundFaction  Auto  
FormList Property HomeLockList Auto
