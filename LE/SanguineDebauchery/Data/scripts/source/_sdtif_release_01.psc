;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 5
Scriptname _sdtif_release_01 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_4
Function Fragment_4(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer(); _SDRAP_player.GetReference() as Actor
; funct.removeItemsInList( kPlayer, _SDFLP_sex_items )
; funct.removeItemsInList( kPlayer, _SDFLP_punish_items )
_SDSP_freedom.RemoteCast( kPlayer, kPlayer, kPlayer )

kPlayer.RemoveItem(Gold, 100 )

fctOutfit.clearDeviceByString( sDeviceString = "WristRestraint", sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "ArmCuffs", sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "LegCuffs", sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Blindfold", sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Hood" , sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Gag", sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Yoke", sOutfitString = "" )
fctOutfit.clearDeviceByString( sDeviceString = "Gloves" , sOutfitString = "" )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

_SDQS_functions Property funct  Auto

FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
Spell Property _SDSP_freedom  Auto  
ReferenceAlias Property _SDRAP_player  Auto  

_sdqs_fcts_outfit Property fctOutfit  Auto  

MiscObject Property Gold  Auto  
