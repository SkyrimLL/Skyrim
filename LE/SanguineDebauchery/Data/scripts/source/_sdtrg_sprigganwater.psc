Scriptname _sdtrg_sprigganwater extends ObjectReference  

Event OnActivate(ObjectReference akActivator)
    Actor Player = Game.GetPlayer() as Actor
    ActorBase PlayerBase = Player.GetActorBase()

    if (PlayerBase.GetRace() == PolymorphRace)
        Player.AddItem(ReturnItem, 1 , True)
    else
; 		Debug.Trace("T01: Registering for IdleFurnitureExit.")
		RegisterForAnimationEvent(Player, "IdleFurnitureExit")
		Utility.Wait(10)
        Player.ResetHealthAndLimbs()
		UnregisterForAnimationEvent(Player, "IdleFurnitureExit")

		fctOutfit.clearDeviceByString( sDeviceString = "ParasiteAnal" , sOutfitString = "" )
		fctOutfit.clearDeviceByString( sDeviceString = "ParasiteVaginal" , sOutfitString = "" )

        ; If (StorageUtil.GetIntValue(Player, "_SD_iSprigganInfected") == 0) && (fctOutfit.countDeviousSlotsByKeyword (  Player,   "_SD_DeviousSpriggan" ) > 0)
        ;     Debug.Messagebox("The spring waters wash away the residual roots clinging to your body.")

            fctOutfit.clearNonGenericDeviceByString ( "Gloves", "Spriggan" )
            fctOutfit.clearNonGenericDeviceByString ( "Boots", "Spriggan" )
            fctOutfit.clearNonGenericDeviceByString ( "Harness", "Spriggan" )
            fctOutfit.clearNonGenericDeviceByString ( "Gag", "Spriggan" )

        ; ElseIf (StorageUtil.GetIntValue(Player, "_SD_iSprigganInfected") == 1) && (fctOutfit.countDeviousSlotsByKeyword (  Player,   "_SD_DeviousSpriggan" ) > 0)
        ;     Debug.Messagebox("The spriggan sap flowing in your veins is still too powerful to be washed away so easily. Try dinking at the spring later.")
            ; SendModEvent("SDSprigganFree")
            if (utility.RandomInt(0,100)>90)
                Player.SendModEvent("SLPCureSprigganRoot", "All")
                Debug.Messagebox("The fresh water clears away of your curse.")
            else
                Player.SendModEvent("SLPCureSprigganRoot")
                Debug.Messagebox("The fresh water feels soothing and disolves some of the spriggan husks on your skin.")
            endif

        ; Else 
        ;    Debug.Messagebox("The water feels rejuvinating.")

       ; Endif
	endif
EndEvent


Event OnAnimationEvent(ObjectReference akSource, string asEventName)
    Actor Player = Game.GetPlayer() as Actor
    ActorBase PlayerBase = Player.GetActorBase()

    if (PlayerBase.GetRace() != PolymorphRace)

	    if (asEventName == "IdleFurnitureExit" && akSource == Player)
    		UnregisterForAnimationEvent(Player, "IdleFurnitureExit")
	 
   	 endif
    Endif
EndEvent

Race Property PolymorphRace auto
Weapon Property ReturnItem Auto
_SDQS_fcts_outfit Property fctOutfit  Auto