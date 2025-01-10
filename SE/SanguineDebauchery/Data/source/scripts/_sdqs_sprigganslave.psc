Scriptname _SDQS_sprigganslave extends Quest Conditional

Import Utility

_SDQS_snp Property snp Auto
_SDQS_functions Property funct  Auto
_SDQS_fcts_inventory Property fctInventory  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto
_SDQS_fcts_factions Property fctFactions  Auto

GlobalVariable Property _SDGVP_positions  Auto  
GlobalVariable Property _SDGVP_poses  Auto  
GlobalVariable Property GameDaysPassed Auto
GlobalVariable Property _SDGVP_spriggan_comment Auto
GlobalVariable Property _SDGVP_spriggan_secret  Auto  
GlobalVariable[] Property _SDGVP_config  Auto 
GlobalVariable Property _SDGVP_config_safeword  Auto  

Spell Property _SDSP_cum  Auto
Sound Property _SDSMP_spriggananger  Auto  

ReferenceAlias Property _SDRAP_spriggan  Auto  
ReferenceAlias Property _SDRAP_host  Auto  
ReferenceAlias Property _SDRAP_marker  Auto  
ReferenceAlias Property _SDRAP_sprigganbook  Auto  

ActorBase Property _SDABP_sprigganhost  Auto
FormList Property _SDFLP_allied  Auto
FormList Property _SDFLP_slaver  Auto
Keyword Property _SDKP_sex  Auto  

Spell Property _SDSP_host_flare  Auto
Spell Property _SDSP_heal  Auto
Cell Property _SDLP_dream  Auto  

Bool Property bQuestActive = False Auto Conditional
Float Property fSprigganPower = 0.0625 Auto Conditional
VisualEffect Property SprigganFX  Auto  

SexLabFramework Property SexLab  Auto  
Float fDaysEnslaved
; when the player reaches the spriggan grove
Float fDaysUpdate
Float fTimeElapsed
Float fSprigganPunish
ObjectReference kMaster
ObjectReference kSlave
Bool bAllyToActor
int randomVar
float playersHealth 
float fNext = 0.0
float fNextAllowed = 0.02

Function Commented()
	fNext = GameDaysPassed.GetValue() + fNextAllowed + Utility.RandomFloat( 0.125, 0.25 )
	_SDGVP_spriggan_comment.SetValue( fNext )
EndFunction

Function CommentTrigger()
	If ( Self.GetStage() == 10 && _SDGVP_spriggan_secret.GetValue() == 0 )
		( _SDRAP_sprigganbook.GetReference() as ObjectReference ).EnableNoWait()
		 Self.SetStage( 20 )
		 Self.SetObjectiveDisplayed( 20 )
	EndIf
EndFunction


; ObjectReference akRef1 = master
; ObjectReference akRef2 = slave
Event OnStoryScript(Keyword akKeyword, Location akLocation, ObjectReference akRef1, ObjectReference akRef2, int aiValue1, int aiValue2)
	; bAllyToActor = fctFactions.allyToActor( akRef1 as Actor, akRef2 as Actor, _SDFLP_slaver, _SDFLP_allied )
	; Debug.Notification("[SD] Receiving spriggan story...")		

	If ( !bQuestActive ) ; && bAllyToActor )
		; Debug.Notification("[SD] Starting spriggan story...")		
		bQuestActive = True
		If ( _SDGVP_config[0].GetValue() )
		;	( akRef2 as Actor ).GetActorBase().SetEssential( False )
		EndIf
		
		kSlave = akRef2 ; player
		Actor akSlave = kSlave as Actor
		
		_SDGVP_sprigganEnslaved.SetValue(1)
		StorageUtil.SetIntValue(Game.GetPlayer(), "_SD_iSprigganInfected", 1)

		If StorageUtil.HasIntValue(kSlave, "_SD_iSprigganEnslavedCount")
			StorageUtil.SetIntValue(kSlave, "_SD_iSprigganEnslavedCount", StorageUtil.GetIntValue(kSlave, "_SD_iSprigganEnslavedCount") + 1)
			_SD_sprigganEnslavedCount.SetValue(StorageUtil.GetIntValue(kSlave, "_SD_iSprigganEnslavedCount"))
		Else
			StorageUtil.SetIntValue(kSlave, "_SD_iSprigganEnslavedCount", 1)
			_SD_sprigganEnslavedCount.SetValue(StorageUtil.GetIntValue(akSlave, "_SD_iSprigganEnslavedCount"))
		EndIf

		; Drop current weapon 
		if(akSlave.IsWeaponDrawn())
			akSlave.SheatheWeapon()
			Utility.Wait(2.0)
		endif

		fctOutfit.toggleActorClothing (  akSlave,  bStrip = True,  bDrop = False )
 
		If ( akSlave.IsSneaking() )
			akSlave.StartSneaking()
		EndIf

		Utility.Wait(1.0)

		; Debug.SendAnimationEvent(Game.GetPlayer(), "Unequip")
		; Debug.SendAnimationEvent(Game.GetPlayer(), "ZazAPC231")
		akSlave.StopCombatAlarm()
		akSlave.StopCombat()

		fDaysEnslaved = GetCurrentGameTime()
		fSprigganPunish = -1.0

		If ( _SDGVP_config[3].GetValue() as Bool )
			; fctInventory.limitedRemoveAllItems ( kSlave, _SD_sprigganHusk, True, _SDFLP_ignore_items )
		Else 
			; kSlave.RemoveAllItems(akTransferTo = _SD_sprigganHusk, abKeepOwnership = True)

			; Testing use of limitedRemove for all cases to allow for detection of Devious Devices, SoS underwear and other exceptions
			; funct.limitedRemoveAllItems ( kSlave, kMaster, True )

		EndIf

		akRef1.Disable()
		kMaster = akRef1.placeAtMe( _SDABP_sprigganhost )
		akRef1.RemoveAllItems(akTransferTo = kMaster)
		akRef1.Delete()

		_SDRAP_spriggan.ForceRefTo( kMaster )
				
		( kMaster as Actor ).RestoreAV("health", ( kMaster as Actor ).GetBaseAV("health") )
		( kSlave as Actor ).RestoreAV("health", ( kSlave as Actor ).GetBaseAV("health") )

		if (!fctOutfit.isArmsEquipped(kSlave as Actor))
			Debug.MessageBox("Roots swarm around you.")	
			fctOutfit.equipNonGenericDeviceByString ( "Gloves", "Spriggan" )
		EndIf
		if (!fctOutfit.isLegsEquipped(kSlave as Actor))
			fctOutfit.equipNonGenericDeviceByString ( "Boots", "Spriggan" )
		EndIf	

		Utility.Wait(1.0)

		; For SexLab Hormones compatibiltiy... should not have any effect if it isn't installed
		Int iSprigganSkinColor = Math.LeftShift(255, 24) + Math.LeftShift(196, 16) + Math.LeftShift(238, 8) + 218
		StorageUtil.SetIntValue(akSlave, "_SLH_iSkinColor", iSprigganSkinColor ) 
		StorageUtil.SetFloatValue(akSlave, "_SLH_fBreast", 0.8 ) 
		StorageUtil.SetFloatValue(akSlave, "_SLH_fWeight", 20.0 ) 
		StorageUtil.SetIntValue(akSlave, "_SLH_iForcedHairLoss", 1)
		akSlave.SendModEvent("SLHShaveHead")
		akSlave.SendModEvent("SLHRefresh")
		akSlave.SendModEvent("SLHRefreshColors")

		SendModEvent("SLHModHormone", "SexDrive", 1.0)
		SendModEvent("SLHModHormone", "Metabolism", 2.0)
		SendModEvent("SLHModHormone", "Lactation", -2.0)
		SendModEvent("SLHModHormone", "Pigmentation", -2.0)
		SendModEvent("SLHModHormone", "Male", -2.0)
		SendModEvent("SLHModHormone", "Female", -2.0)
		SendModEvent("SLHModHormone", "Growth", -2.0)

		Debug.MessageBox("The roots start feeding on your flesh and alter your body.")
		
		; Debug.SendAnimationEvent(kSlave, "IdleForceDefaultState")
	     _SD_sprigganHusk.MoveTo( _SDRAP_grovemarker.GetReference() )
	     ; _SD_sprigganHusk.Disable()

		; _SDKP_sex.SendStoryEvent( akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 2, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )
		_SDKP_sex.SendStoryEvent( akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 2, aiValue2 = 0 )

		If ( Self )
			RegisterForSingleUpdateGameTime( 0.125 )
			RegisterForSingleUpdate( 0.1 )
		EndIf
	Else
		Debug.Trace("_SD:: Spriggan slave fail to start: bQuestActive=" + bQuestActive + " bAllyToActor=" + bAllyToActor)
	EndIf
EndEvent

Event OnUpdateGameTime()
	; Debug.Notification( "[Spriggan slave loop] kSlave = " + kSlave)
	Actor kPlayer = Game.getPlayer()

	If (!kSlave)
		Return
	EndIf
	
	; While ( !kSlave.Is3DLoaded() )
	; EndWhile

	; Workaround to fix issue with player stuck in place after sex with spriggan armor on - remove once real solution is found
	; Issue is triggered a little after sex ends... 

  	If (!Game.IsMovementControlsEnabled() ) &&  (SexLab.ValidateActor(kPlayer) > 0) 
  		; Debug.Notification( "[Spriggan slave loop] Player stuck - restoring controls")  
		Game.SetPlayerAIDriven(false)
		Game.EnablePlayerControls( abMovement = True )
	Endif

	; Debug.Notification( "[Spriggan slave loop] kSlave = Loaded " )

	fTimeElapsed = GetCurrentGameTime() - fDaysEnslaved
	fSprigganPunish = funct.floatWithinRange( fTimeElapsed * 5.0, 2.5, 40.0 ) ; original settings - 2.5, 80.0
	
	If ( fTimeElapsed < 120.0 )
		fSprigganPower = funct.floatLinearInterpolation( 0.0625, 1.0, 0.0, fTimeElapsed, 120.0 )
	Else
		fSprigganPower = 1.0
	EndIf

	; Debug.Notification( "[Spriggan slave loop] fTimeElapsed = " + fTimeElapsed)       ; 4
	; Debug.Notification( "[Spriggan slave loop] fSprigganPunish = " + fSprigganPunish) ; 4
	; Debug.Notification( "[Spriggan slave loop] fSprigganPower = " + fSprigganPower)   ; 0.09

    randomVar = RandomInt( 0, 100 ) 

	playersHealth = kPlayer.GetActorValuePercentage("health")
	if ((playersHealth < 0.8) && kPlayer.IsSwimming())
	  	; Debug.Trace("The player has over half their health left")
		_SDSP_heal.RemoteCast(kPlayer, kPlayer, kPlayer)
	endIf

	If (_SDGVP_config_safeword.GetValue() as bool)
		; Safeword - abort enslavement

		Debug.Trace("[_sdras_sprigganslave] Safeword - Stop enslavement")
		Debug.MessageBox( "Safeword: You are released from enslavement.")
		_SDGVP_config_safeword.SetValue(0)

		Self.Setstage(70)

	ElseIf !kPlayer.IsInCombat() && !kPlayer.IsOnMount() &&  (SexLab.ValidateActor(kPlayer) > 0) 
    	; !( kSlave as Actor ).GetCurrentScene() 
    	; && !kPlayer.GetDialogueTarget()  ; always false when used on player - http://www.creationkit.com/Talk:GetDialogueTarget_-_Actor

        ; Debug.Notification( randomVar ) 
		If (randomVar >= 98 )
			_SDSP_host_flare.RemoteCast(kPlayer, kPlayer, kPlayer)
			Debug.Notification( "Tendrils are digging deeper under your skin..." )

			SprigganFX.Play( kSlave, 60 )
			Utility.Wait(1.0)
			
			; HACK: select rough sexlab animations 
			; sslBaseAnimation[] animations = SexLab.GetAnimationsByTags(1,  "Masturbation,Female","Estrus,Dwemer")

			; HACK: get actors for sexlab
			; actor[] sexActors = new actor[1]
			; sexActors[0] = kSlave as Actor

			; HACK: start sexlab animation
			; SexLab.StartSex(sexActors, animations)

			sslThreadModel Thread = SexLab.NewThread()
			Thread.AddActor(SexLab.PlayerRef, true) ; // IsVictim = true
			Thread.SetAnimations(SexLab.GetAnimationsByTags(1, "Solo,F","Estrus,Dwemer"))
			Thread.StartThread()

		ElseIf (randomVar >= 90 )
			; _SDSP_host_flare.RemoteCast(kSlave as Actor, kSlave as Actor, kSlave as Actor)
			Debug.Notification( "Sap is slowly pumping into your veins.." )

			SprigganFX.Play( kSlave, 30 )
		ElseIf (randomVar >= 80 )
			Debug.Notification( "Sweet sap runs down your legs..." )

			SexLab.ApplyCum(kSlave as Actor, 1)
		EndIf

	Else
		; Debug.Notification( "[SD] Issue with Spriggan root validation." )
		Debug.Trace( "[Spriggan slave loop] Player is busy: SexLab.ValidateActor code: " + SexLab.ValidateActor(kPlayer) + " - Combat: " + !kPlayer.IsInCombat()  + " - Dialogue: " +  !kPlayer.GetDialogueTarget()   + " - Mount: " +  !kPlayer.IsOnMount() )       
	EndIf

	; Add housekeeping for parts of the armor
	; If fctOutfit.isDeviceEquippedKeyword( kPlayer,  "_SD_DeviousSpriggan", "Belt"  ) && !kPlayer.IsInFaction(SprigganFaction)
	;		Debug.Notification( "[SD] Adding player to: " + SprigganFaction )
	;		Debug.Trace( "[SD] Adding player to: " + SprigganFaction )
	;		kPlayer.AddToFaction(SprigganFaction)
	;		kPlayer.AddToFaction(GiantFaction)
			; GiantFaction.SetReaction(PlayerFaction, 3)
			; SprigganFaction.SetReaction(PlayerFaction, 3)
	; EndIf

	; random punishment events
	If(  (RandomFloat(0.0, 100.0) < fSprigganPunish) && (GetStage() < 70) && !kPlayer.GetCurrentScene() && !kPlayer.IsInCombat()  && !kPlayer.IsOnMount() ) &&  (SexLab.ValidateActor(kPlayer) > 0) ;  && !kPlayer.GetDialogueTarget() )
		; _SDSP_host_flare.RemoteCast(kSlave as Actor, kSlave as Actor, kSlave as Actor)
		; Game.ForceThirdPerson()
		; Debug.SendAnimationEvent(kSlave as ObjectReference, "bleedOutStart")
		Debug.Trace( "[SD] Spriggan roots growing" )
		Debug.Notification( "The roots throb deeply in and out of you..." )

		SendModEvent("SDSprigganTransform")

		_SD_spriggan_punishment.Mod(1)
		Debug.Trace( "[SD] Spriggan punishment: " + _SD_spriggan_punishment.GetValue() )

		If (_SD_spriggan_punishment.GetValue() >= 1 ) && (!fctOutfit.isCuffsEquipped (  kSlave as Actor ))
			fctOutfit.equipNonGenericDeviceByString ( "Gloves", "Spriggan" )
 
		ElseIf (_SD_spriggan_punishment.GetValue() >= 1 )
			Debug.Trace("[SD] Skipping spriggan hands - slot in use")
		EndIf
		If (_SD_spriggan_punishment.GetValue() >= 1 ) && (!fctOutfit.isShacklesEquipped (  kSlave as Actor ))
			fctOutfit.equipNonGenericDeviceByString ( "Boots", "Spriggan" )
	
		ElseIf (_SD_spriggan_punishment.GetValue() >= 1)
			Debug.Trace("[SD] Skipping spriggan feet - slot in use")
		EndIf

		If (_SD_spriggan_punishment.GetValue() >= 2 ) && (!fctOutfit.isBeltEquipped (  kSlave as Actor ))
			Debug.MessageBox("The roots spread relentlessly through the rest of your body, leaving you gasping for air.")
			fctOutfit.equipNonGenericDeviceByString ( "Harness", "Spriggan" )

			; kPlayer.AddToFaction(SprigganFaction)
			; kPlayer.AddToFaction(GiantFaction)
			; GiantFaction.SetReaction(PlayerFaction, 3)
			; SprigganFaction.SetReaction(PlayerFaction, 3)

		ElseIf (_SD_spriggan_punishment.GetValue() >= 2 )
			Debug.Trace("[SD] Skipping spriggan body - slot in use")
		EndIf
		
		If (_SD_spriggan_punishment.GetValue() >= 3 ) && (!fctOutfit.isGagEquipped (  kSlave as Actor))
			Debug.MessageBox("The roots cover your face, numbing your mind and filling your mouth with a flow of bitter-sweet nectar.")
			fctOutfit.equipNonGenericDeviceByString ( "Gag", "Spriggan" )

		ElseIf (_SD_spriggan_punishment.GetValue() >= 3 )
			Debug.Trace("[SD] Skipping spriggan mask - slot in use")
		EndIf

		If (StorageUtil.GetIntValue(none, "_SLH_iHormones")==1)

			Int iSprigganSkinColor = Math.LeftShift(255, 24) + Math.LeftShift(133, 16) + Math.LeftShift(184, 8) + 160
			StorageUtil.SetIntValue(kPlayer, "_SLH_iSkinColor", iSprigganSkinColor ) 
			StorageUtil.SetFloatValue(kPlayer, "_SLH_fBreast", Utility.RandomFloat(0.8, 1.4) ) 
			StorageUtil.SetFloatValue(kPlayer, "_SLH_fBelly", Utility.RandomFloat(0.8, 2.0) ) 
			StorageUtil.SetFloatValue(kPlayer, "_SLH_fWeight", Utility.RandomFloat(0.0, 50.0) ) 
			StorageUtil.SetIntValue(kPlayer, "_SLH_iForcedHairLoss", 1)
			kPlayer.SendModEvent("SLHShaveHead")
			kPlayer.SendModEvent("SLHRefresh")
			kPlayer.SendModEvent("SLHRefreshColors")

			SendModEvent("SLHModHormone", "SexDrive", 1.0)
			SendModEvent("SLHModHormone", "Metabolism", 2.0)
			SendModEvent("SLHModHormone", "Lactation", -2.0)
			SendModEvent("SLHModHormone", "Pigmentation", -2.0)
			SendModEvent("SLHModHormone", "Male", -2.0)
			SendModEvent("SLHModHormone", "Female", -2.0)
			SendModEvent("SLHModHormone", "Growth", -2.0)

			Debug.MessageBox("The roots are taking their toll on your appearance.")
		
		EndIf

		SprigganFX.Play( kSlave, 30 )
		_SDSMP_spriggananger.play( kSlave )
		; _SDKP_sex.SendStoryEvent( akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 8, aiValue2 = RandomInt( 0, _SDGVP_poses.GetValueInt() ) )

		kMaster.SendModEvent("SDSprigganPunish")
	Else
		; Debug.Notification("[SD] Spriggan roots grow - failed") 
    EndIf
	; Initial stage
	If (GetStage() == 0)
		self.SetStage( 10 )
	EndIf
	
	; ends the punishment period after arriving at the grove
	If ( (GetCurrentGameTime() - fDaysUpdate > fSprigganPower) && ( (GetStageDone(70) == 1) || (GetStageDone(75) == 1)) )
		; While ( kMaster.GetCurrentScene() || kSlave.GetCurrentScene() )
		; EndWhile
		fDaysUpdate = GetCurrentGameTime()

		If (StorageUtil.GetIntValue(kSlave, "_SD_iSprigganEnslavedCount") >= 1) && (!(kSlave as Actor).HasSpell( CallSpriggan ))
			Debug.Messagebox("Your experience taking a spriggan essence back to its source gives you a unique bond with Kyne herself. Once a day, you will be able to call on nearby creatures for help.")
			(kSlave as Actor).AddSpell( CallSpriggan )
		Endif
		If (StorageUtil.GetIntValue(kSlave, "_SD_iSprigganEnslavedCount") >= 2) && (!(kSlave as Actor).AddSpell( PolymorphSpriggan ))
			Debug.Messagebox("You have helped two spriggans complete their life cycle and for that, Kyne's waters grant you a gift. Once a day, you will be able to turn yourself into a spriggan.")
			(kSlave as Actor).AddSpell( PolymorphSpriggan )
		EndIf

		SetStage( 80 )
	EndIf
	
	; keep spriggans friendly for a while to let the player move away
	If ( (GetCurrentGameTime() - fDaysUpdate > 0.25) && ( GetStageDone(80) == 1) )
		; While ( kMaster.GetCurrentScene() || kSlave.GetCurrentScene() )
		; EndWhile
		Debug.Messagebox("The power of the sap begins to fade inside you.")
		SetStage( 90 )
	EndIf	

	If ( ( Self ) && ( GetStageDone(90) == 0) )
		RegisterForSingleUpdateGameTime( 0.25 )
	EndIf
EndEvent

Event OnUpdate()
	if (kSlave)
		; While ( !kSlave.Is3DLoaded() )
		; EndWhile

		ObjectReference marker = _SDRAP_marker.GetReference() as ObjectReference
		If ( marker && ( kSlave.GetDistance( marker ) < 500.0) && (GetStage() == 60) )
			fDaysUpdate = GetCurrentGameTime()
			SetObjectiveCompleted( 60 )
			self.SetStage( 70 )

		ElseIf ( !kMaster.GetCurrentScene() && !kSlave.GetCurrentScene() && ( (GetStage() == 70) || (GetStage() == 75)) )
			While ( kMaster.GetCurrentScene() || kSlave.GetCurrentScene() )
			EndWhile
			Wait( 5.0 )
			; _SDKP_sex.SendStoryEvent( akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )
		EndIf
	EndIf

	If ( Self )
		RegisterForSingleUpdate( 1.0 )
	EndIf
EndEvent

GlobalVariable Property _SDGVP_sprigganEnslaved  Auto  
GlobalVariable Property _SD_spriggan_punishment  Auto  
GlobalVariable Property _SD_sprigganEnslavedCount  Auto  

ObjectReference Property _SD_sprigganHusk  Auto  
FormList Property _SDFLP_ignore_items  Auto

ReferenceAlias Property _SDRAP_grovemarker  Auto

Faction Property GiantFaction  Auto  
Faction Property SprigganFaction  Auto  
Faction Property PlayerFaction  Auto  

Spell Property CallSpriggan Auto
Spell Property PolymorphSpriggan Auto
