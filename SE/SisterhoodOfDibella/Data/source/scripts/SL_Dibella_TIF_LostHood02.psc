;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SL_Dibella_TIF_LostHood02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer()

; kPlayer.RemoveItem(SisterHood, 1)
; kPlayer.AddItem(Gold, 50)

Self.GetOwningQuest().SetStage(3)
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment


LeveledItem Property DibellaDonationGift  Auto  

MiscObject Property Gold  Auto 
ReferenceAlias Property _SLSD_SisterSatchelRef Auto

ObjectReference Property TempleDonationsChest  Auto  

GlobalVariable Property TempleDonations  Auto  
GlobalVariable Property SatchelItemsCount  Auto  

Armor Property SisterHood  Auto  
