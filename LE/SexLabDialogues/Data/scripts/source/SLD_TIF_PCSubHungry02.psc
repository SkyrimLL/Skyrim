;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_PCSubHungry02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kSlave = game.GetPlayer()

	Debug.Notification( "Your mouth is held open as you are forced to swallow..." )
	int randomVar = Utility.RandomInt( 0, 10 ) 

	If (Utility.RandomInt(0,100)>60) 
		akSpeaker.AddItem( Beef, Utility.RandomInt(1,3), True )
	Endif
	If (Utility.RandomInt(0,100)>40) 
		akSpeaker.AddItem( Potato, Utility.RandomInt(1,3), True )
	Endif

	If (randomVar >= 9  ) && (StorageUtil.GetIntValue( akSpeaker , "_SD_iDisposition") < 0 )
		Debug.Notification( "..some Skooma!" )
		kSlave.AddItem( Skooma, 1, True )
		kSlave.EquipItem( Skooma  )
		SendModEvent("SDModMasterTrust", 2)

		Utility.Wait(3.0)
	 	DruggedEffect.Cast( kSlave, kSlave)

		If (Utility.RandomInt( 0, 100 ) > 30)
			Debug.Notification( "In a stupor you start dancing for no reason..." )
			; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", akSpeaker)
 			akSpeaker.SendModEvent("PCSubEntertain") ; Dance
 		EndIf

	Else 
		_SLD_Player.GiftFromNPC(akSpeaker, "Hungry")


	EndIf

;	While ( Utility.IsInMenuMode() )
;	EndWhile
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SPELL Property DruggedEffect  Auto  
SPELL Property DrunkEffect  Auto  

Potion Property Potato Auto  

Potion Property Skooma  Auto  

Potion Property Beef  Auto  
SLD_PlayerAlias Property _SLD_Player Auto
