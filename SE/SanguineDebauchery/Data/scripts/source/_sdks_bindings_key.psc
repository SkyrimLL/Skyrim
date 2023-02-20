Scriptname _SDKS_bindings_key extends ObjectReference  

_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto
Spell Property _SDSP_freedom  Auto  

Keyword Property _SDKP_collar  Auto 
Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	If ( akOldContainer == Game.GetPlayer() )
		Self.DeleteWhenAble()
	EndIf
	
	If (  akNewContainer == Game.GetPlayer() )
		Actor kContainer = akNewContainer as Actor
;		funct.removeItemsInList( kContainer, _SDFLP_sex_items )
;		funct.removeItemsInList( kContainer, _SDFLP_punish_items )

		Debug.Trace("[_sdks_bindings_key] Master key in Slave - Stop enslavement")
		Debug.MessageBox("You manage to get hold of your owner's key and break free of your chains.")
		StorageUtil.SetIntValue(kContainer, "_SD_iHandsFree", 1)


		If fctOutfit.isArmsEquipped( kContainer ) && !fctOutfit.isDeviceEquippedKeyword( kContainer,  "_SD_DeviousSpriggan", "ArmCuffs"  ) && !fctOutfit.isDeviceEquippedKeyword( kContainer,  "_SD_DeviousSanguine", "Armbinder"  )
			fctOutfit.clearDeviceByString ( sDeviceString = "ArmCuffs", sOutfitString= "" )
			fctOutfit.clearDeviceByString ( sDeviceString = "Armbinder", sOutfitString= "" )
		EndIf

		If fctOutfit.isLegsEquipped( kContainer ) && !fctOutfit.isDeviceEquippedKeyword( kContainer,  "_SD_DeviousSpriggan" , "LegCuffs" ) && !fctOutfit.isDeviceEquippedKeyword( kContainer,  "_SD_DeviousSanguine", "LegCuffs"  )
			fctOutfit.clearDeviceByString ( sDeviceString = "LegCuffs" , sOutfitString= "" )
		EndIf

		If fctOutfit.isBlindfoldEquipped( kContainer ) && !fctOutfit.isDeviceEquippedKeyword( kContainer,  "_SD_DeviousSpriggan", "Blindfold"  ) && !fctOutfit.isDeviceEquippedKeyword( kContainer,  "_SD_DeviousSanguine", "Blindfold" )
			fctOutfit.clearDeviceByString ( sDeviceString = "Blindfold" , sOutfitString= "" )
		endif

		If fctOutfit.isGagEquipped( kContainer ) && !fctOutfit.isDeviceEquippedKeyword( kContainer,  "_SD_DeviousSpriggan" , "Gag" ) && !fctOutfit.isDeviceEquippedKeyword( kContainer,  "_SD_DeviousSanguine" , "Gag" )
			fctOutfit.clearDeviceByString ( sDeviceString = "Gag" , sOutfitString= "" )
		EndIf


		If fctOutfit.isCollarEquipped( kContainer  )
			fctOutfit.unLockDeviceByString( kContainer,  "Collar")
			if (Utility.RandomInt(0,100) < 77)
				fctOutfit.clearDeviceByString ( sDeviceString = "Collar" , sOutfitString= "" )
				Debug.Messagebox("Your Master's Key helps you break free of your chains and immediately crumbles into dust.")
			Else
				Debug.MessageBox("Your Master's Key helps you break free of your chains but the key crumbles into dust before you can try to force your collar open.")
			EndIf

		Else
			Debug.MessageBox("The key works on bindings but without an enchanted enslavement collar bound to a master, it is useless on your collar and immediately crumbles into dust.")
		EndIf

		If (StorageUtil.GetIntValue(kContainer, "_SD_iEnslaved") == 1)
			SendModEvent("PCSubFree")		

			_SDSP_freedom.RemoteCast( akNewContainer, kContainer, kContainer )
		EndIf

		Int keyCount = Game.GetPlayer().GetItemCount( _SD_MasterKey as Form )
		Game.GetPlayer().RemoveItem(_SD_MasterKey, keyCount)

	EndIf	
EndEvent

Key Property _SD_MasterKey  Auto  
