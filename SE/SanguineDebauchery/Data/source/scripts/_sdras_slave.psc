Scriptname _SDRAS_slave extends ReferenceAlias
{ USED }
Import Utility

_SDQS_snp Property snp Auto
_SDQS_enslavement Property enslavement  Auto
_SDQS_functions Property funct  Auto
_SDQS_fcts_outfit Property fctOutfit  Auto
_SDQS_fcts_slavery Property fctSlavery  Auto
_SDQS_fcts_constraints Property fctConstraints  Auto
_SDQS_fcts_factions Property fctFactions  Auto

MiscObject Property _SDMOP_lockpick  Auto  

Quest Property _SDQP_enslavement_tasks  Auto
Quest Property _SDQP_thug_slave  Auto

Quest Property _SD_dreamQuest  Auto
_sdqs_dream Property dreamQuest Auto

ReferenceAlias Property Alias__SDRA_lust_m  Auto
ReferenceAlias Property Alias__SDRA_lust_f  Auto

Cell[] Property _SDCP_sanguines_realms  Auto  

GlobalVariable Property _SDGVP_gender_restrictions Auto
GlobalVariable Property _SDGVP_config_lust auto
GlobalVariable Property _SDGV_leash_length  Auto
GlobalVariable Property _SDGV_free_time  Auto
GlobalVariable Property _SDGVP_positions  Auto  
GlobalVariable Property _SDGVP_demerits  Auto  
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto
GlobalVariable Property _SDGVP_escape_radius  Auto  
GlobalVariable Property _SDGVP_escape_timer  Auto  
GlobalVariable Property _SDGVP_state_caged  Auto  
GlobalVariable Property _SDGVP_config_safeword  Auto  
GlobalVariable Property _SDKP_trust_hands  Auto  
GlobalVariable Property _SDKP_trust_feet   Auto  
GlobalVariable Property _SDKP_snp_busy   Auto  
GlobalVariable Property _SDGVP_punishments  Auto  
GlobalVariable Property _SDGVP_join_days  Auto  
GlobalVariable Property _SDGVP_can_join  Auto  
GlobalVariable Property _SDGVP_work_start  Auto
GlobalVariable Property _SDGVP_buyout  Auto
GlobalVariable Property _SDGVP_isLeashON  Auto
GlobalVariable Property _SDGVP_state_MasterFollowSlave  Auto  
GlobalVariable Property _SDGVP_config_limited_removal  Auto  
GlobalVariable Property _SDGVP_config_min_days_before_master_travel Auto
GlobalVariable Property _SDGVP_isMasterTraveller  Auto  
GlobalVariable Property _SDGVP_isMasterInTransit  Auto  


ReferenceAlias Property _SDRAP_cage  Auto
ReferenceAlias Property _SDRAP_cage_marker  Auto
ReferenceAlias Property _SDRAP_masters_key  Auto
ReferenceAlias Property _SDRAP_slave  Auto
ReferenceAlias Property _SDRAP_master  Auto
ReferenceAlias Property _SDRAP_slaver  Auto
ReferenceAlias Property _SDRAP_slaver2_m  Auto
ReferenceAlias Property _SDRAP_slaver2_f  Auto
ReferenceAlias Property _SDRAP_bindings  Auto
ReferenceAlias Property _SDRAP_shackles  Auto
Float Property _SDFP_bindings_health = 10.0 Auto

FormList Property _SDFLP_master_items  Auto
FormList Property _SDFLP_sex_items  Auto
FormList Property _SDFLP_punish_items  Auto  
FormList Property _SDFLP_trade_items  Auto
FormList Property _SDFLP_slave_clothing  Auto
FormList Property _SDFLP_banned_locations  Auto  
FormList Property _SDFLP_banned_worldspaces  Auto  

Keyword Property _SDKP_enslave  Auto
Keyword Property _SDKP_sex  Auto
Keyword Property _SDKP_arrest  Auto
Keyword Property _SDKP_gagged  Auto
Keyword Property _SDKP_bound  Auto 
Keyword Property _SDKP_wrists  Auto
Keyword Property _SDKP_ankles  Auto
; these keywords are usually associated with quest items.
; i.e. prevent selling or disenchanting them.
Keyword Property _SDKP_noenchant  Auto  
Keyword Property _SDKP_nosale  Auto  
Keyword Property _SDKP_food  Auto  
Keyword Property _SDKP_food_raw  Auto  
Keyword Property _SDKP_food_vendor  Auto  

Faction Property _SDFP_slaversFaction  Auto  
Spell Property _SDSP_SelfShockShield  Auto  
Spell Property _SDSP_SelfShockEffect  Auto  
Spell Property _SDSP_SelfVibratingEffect  Auto  
Spell Property _SDSP_SelfTinglingEffect  Auto  
Spell Property _SDSP_Weak  Auto  

Faction kCrimeFaction



GlobalVariable Property _SDGVP_config_cage_enable  Auto 
GlobalVariable Property _SDGVP_state_SlaveDominance  Auto  
GlobalVariable Property _SDGVP_state_joined  Auto  
GlobalVariable Property _SDGVP_state_housekeeping  Auto   
GlobalVariable Property _SDGVP_config_disposition_threshold Auto

SexLabFramework Property SexLab  Auto  

Keyword Property _SDKP_collar  Auto  
Keyword Property _SDKP_gag  Auto  

ReferenceAlias Property _SDRAP_collar  Auto  

Armor Property _SDA_gag  Auto  
Armor Property _SDA_collar  Auto  
Armor Property _SDA_bindings  Auto  
Armor Property _SDA_shackles  Auto  

Keyword Property _SDKP_hunt  Auto  
Sound Property _SDSMP_choke  Auto  

ImageSpaceModifier Property _SD_CollarStrangleImod  Auto  

Sound Property _SDSMP_choke_m  Auto  
slaUtilScr Property slaUtil  Auto  

; LOCAL
Int iuType
Float fCalcLeashLength
Float fCalcOOCLimit = 10.0
Float fDamage
Float fDistance
Float fMasterDistance
Float fBlackoutRatio
Float fEscapeTime
Float fEscapeUpdateTime
Float fOutOfCellTime
Float fEscapeLeashLength
Float fEscapeTimer
Float fBuyout
Float fEnslavementDuration
Int iMasterAverageMood

Float fLastIngest
Float fLastEscape

Actor kMaster
Actor kSlave
Cell kMasterCell
Cell kSlaveCell
ObjectReference kSlaverDest
ObjectReference kSlaver
ObjectReference kSlaver2_m
ObjectReference kSlaver2_f
Actor kCombatTarget
Actor kLeashCenter
ObjectReference kCageRef
ObjectReference kBindings
ObjectReference kShackles
ObjectReference kCollar
ObjectReference kGag
int iPlayerGender
Actor kActor
Actor kPlayer

Float fRFSU = 0.5

Int iuIdx
Int iuCount
Form kAtIdx
Float fTime
int daysPassed
float timePassed
int iGameDateLastCheck = -1
int iDaysSinceLastCheck
int iCountSinceLastCheck
int iHoursLastCheck 
float HourlyTickerLastCallTime = 0.0
float property HourlyTickerPeriod = 0.05 autoreadonly ; ingame time (days) for Hourly ticker, about 0.04 is enough
float DailyTickerLastCallTime = 0.0
float property DailyTickerPeriod = 1.0 autoreadonly ; 1.0 autoreadonly ; ingame time (days) for daily ticker, normally 1.0

Bool[] uiSlotDevice
Int iWristsDevice = 0 ;59  Bindings
Int iCollarDevice = 1 ;45  Collar
Int iAnklesDevice = 2 ;53  Ankles
Int iGagDevice = 4 ;44  DD Gag
Form fGagDevice = None

Int iCageRadius = 3500

Function UpdateMasterSlave()
	; kMaster = _SDRAP_master.GetReference() as Actor
	; kSlave = _SDRAP_slave.GetReference() as Actor

	kMaster = StorageUtil.GetFormValue(none, "_SD_CurrentOwner") as Actor 
	kSlave  = StorageUtil.GetFormValue(none, "_SD_CurrentSlave") as Actor 
	; _SDRAP_master.ForceRefTo(kMaster)
	; _SDRAP_slave.ForceRefTo(kSlave)
EndFunction


Function freedomTimer( Float afTime )
	If ( afTime >= 60.0 )
		; Debug.Notification( Math.Floor( afTime / 60.0 ) + " min.," + ( Math.Floor( afTime ) % 60 ) + " sec. and you're free!" )
		Debug.Notification("The collar is vibrating. " + Math.Floor( afTime / 60.0 ) + " min.," + ( Math.Floor( afTime ) % 60 ) + " sec. remaining.")
		_SDSP_SelfVibratingEffect.Cast(kSlave as Actor)
	ElseIf ( afTime >= 0.0 )
		; Debug.Notification( Math.Floor( afTime ) + " sec. and you're free!" )
		Debug.Notification("The collar is tingling. " + Math.Floor( afTime ) + " sec. remaining.")
		_SDSP_SelfTinglingEffect.Cast(kSlave as Actor)
	Else 
		; Debug.Notification( Math.Floor( afTime ) + " sec. and you're free!" )
		; Debug.Notification("The collar is sending shocks." )
		; _SDSP_SelfShockEffect.Cast(kSlave as Actor)
	EndIf
EndFunction


Event OnInit()

  	UpdateMasterSlave()

	_slaveStatusInit()
	
	fctConstraints.CollarEffectStart(kSlave, kMaster)

	If ( Self.GetOwningQuest() )
		RegisterForSingleUpdate( fRFSU )
	EndIf
	GoToState("waiting")
EndEvent


Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	If ( _SDFLP_banned_locations.HasForm( akNewLoc ) )
		debugTrace(" Banned location - Stop enslavement")
		SendModEvent("PCSubFree") ; Self.GetOwningQuest().Stop()
		Wait( fRFSU * 5.0 )
	EndIf
	If ( _SDFLP_banned_worldspaces.HasForm( kSlave.GetWorldSpace() ) )

		debugTrace(" Banned worldspace - Stop enslavement")
		SendModEvent("PCSubFree") ; Self.GetOwningQuest().Stop()
		Wait( fRFSU * 5.0 )
	EndIf
	If !kMaster || !kSlave || kMaster.IsDisabled() || kMaster.IsDead() ; || ( kMaster.IsEssential() && (kMaster.IsBleedingOut()) || (kMaster.IsUnconscious()) ) )
		debugTrace(" OnLocationChange safeguard - Master dead or disabled - Stop enslavement")
		Debug.Notification( "$Your owner is either dead or left you...")

		SendModEvent("PCSubFree")
	Endif

EndEvent
 
Event OnCombatStateChanged(Actor akTarget, int aeCombatState)
	Weapon krHand = kSlave.GetEquippedWeapon()
	Weapon klHand = kSlave.GetEquippedWeapon( True )

	If ( !kMaster )
		UpdateMasterSlave()
	EndIf

	; most likely to happen on a pickpocket failure.
	If ( (aeCombatState != 0) && (fctFactions.isInSlaveFactions( akTarget ) ) )
		; Debug.Messagebox( "Your collar compels you to drop your weapon when attacking your owner's allies." )

		; Drop current weapon 
		; if(kSlave.IsWeaponDrawn())
		; 	kSlave.SheatheWeapon()
		; 	Utility.Wait(2.0)
		; endif

		; If ( krHand )
		;	kSlave.DropObject( krHand )
		; 	kSlave.UnequipItem( krHand )
		; EndIf
		; If ( klHand )
		;	kSlave.DropObject( klHand )
		; 	kSlave.UnequipItem( klHand )
		; EndIf

		; If (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1)
		; 	Debug.Trace( "[_sdras_master] Punishment for hitting master friends - Yoke" )
		; 	enslavement.PunishSlave(kMaster,kSlave,"Armbinder")
		; endif

		; If (fctSlavery.ModMasterTrust( kMaster, -1)<0)
			; add punishment
		; 	Int iRandomNum = Utility.RandomInt(0,100)

		; 	if (iRandomNum > 70) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryWhipSceneOn")==1)
				; Whipping
			 	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
			 	; kMaster.SendModEvent("PCSubWhip") 
		; 		funct.SanguineWhip( kMaster )

		; 	Elseif (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn")==1)
				; Punishment
			 	; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
			 	; kMaster.SendModEvent("PCSubPunish") 
		; 		funct.SanguinePunishment( kMaster )

		; 	Else
		; 	 	kMaster.SendModEvent("PCSubSex","Rough") 

		; 	EndIf
		; Endif
	EndIf
EndEvent

Event OnItemAdded(Form akBaseItem, Int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)

	If ( Self.GetOwningQuest().GetStage() >= 90 ) || ( akBaseItem.HasKeyword(_SDKP_noenchant) || akBaseItem.HasKeyword(_SDKP_nosale) ) || kSlave.GetCurrentScene() || (StorageUtil.GetIntValue(kSlave, "_SD_iEnslavementInitSequenceOn")==1)
		Return
	EndIf

	iuType = akBaseItem.GetType()
	_SDFLP_trade_items.AddForm( akBaseItem )

;		Debug.Notification("[_sdras_slave] Adding item: " + akBaseItem)
;		Debug.Notification("[_sdras_slave] Slave bound status: " + kSlave.WornHasKeyword( _SDKP_bound ) )
;		Debug.Notification("[_sdras_slave] Item type: " + iuType)

	If ( akItemReference == _SDRAP_masters_key.GetReference() ) && (akItemReference == (kSlave as ObjectReference))
		; Slave equips master key - Escape

		; debugTrace(" Master key stolen - Stop enslavement")
		; This should be redundant - already handled by _sdks_bindings_key

		Return

	;  ElseIf (fctOutfit.isCollarEquipped(kSlave))
		; Slave is collared - control item awareness

		; Debug.Notification( "$SD_MESSAGE_MASTER_AWARE" )
		
		; If ( iuType == 41 ) && (!fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableWeaponEquip") )
				; TO DO - Add code here for compatibility with SPERG and other mods relying on equiping invisible weapons

				; Debug.Notification( "$SD_MESSAGE_CAUGHT" )
				; Debug.Notification( "$You are not allowed to hold a weapon.  Your collar compels you to remove it." )

				; kSlave.UnequipItem( akBaseItem, aiItemCount )
				; Weapon krHand = kSlave.GetEquippedWeapon()
				; Weapon klHand = kSlave.GetEquippedWeapon( True )

				; Drop current weapon 
				; if(kSlave.IsWeaponDrawn())
				; 	kSlave.SheatheWeapon()
				; 	Utility.Wait(2.0)
				; endif

				; If ( krHand )
				;	kSlave.DropObject( krHand )
				; 	kSlave.UnequipItem( krHand )
				; EndIf
				; If ( klHand )
				;	kSlave.DropObject( klHand )
				; 	kSlave.UnequipItem( klHand )
				; EndIf

		; ElseIf ( iuType == 26 )  &&  (!fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableArmorEquip") && !fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableClothingEquip"))  &&  !akBaseItem.HasKeywordString("SOS_Underwear") &&  !akBaseItem.HasKeywordString("SOS_Genitals")
			; Armor

				; Debug.MessageBox( "You are not allowed to wear clothing. Your Master won't behappy about that." )

				; kSlave.UnequipItem( akBaseItem, aiItemCount )

		; ElseIf ( kMaster.GetSleepState() != 0 && kMaster.HasLOS( kSlave ) ) &&  !fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableInventory") && ( !akBaseItem.HasKeywordString("SOS_Underwear") &&  !akBaseItem.HasKeywordString("SOS_Genitals"))
			; Not working as intended - revisit later
			
			;	Debug.MessageBox( "You are not allowed to pick something up yet. Your owner takes that away from you." )

			;	kSlave.RemoveItem( akBaseItem, aiItemCount, False, kMaster )

		; EndIf


	EndIf

	if !akSourceContainer
		debugTrace(" Slave receives  " + aiItemCount + "x " + akBaseItem + " from the world")

	elseif akSourceContainer == kMaster
		debugTrace(" Slave receives  " + aiItemCount + "x " + akBaseItem + " from master")

		If (kMaster.IsDead())
			Debug.Trace( "[_sdras_slave] Item received from a dead master." )
		else
			kSlave.EquipItem( akBaseItem, aiItemCount )
		EndIf
	else
		debugTrace(" Slave receives  " + aiItemCount + "x " + akBaseItem + " from another container")

	endIf


EndEvent


State waiting
	Event OnUpdate()
		; Debug.Notification( "[SD] Waiting")
		UpdateMasterSlave()

		If ( Self.GetOwningQuest().IsRunning() ) && (kMaster) ; && ( kMaster.Is3DLoaded() ); && (StorageUtil.GetIntValue(kSlave, "_SD_iEnslavementInitSequenceOn")==0) ; wait for end of enslavement sequence
			debugTrace(" Player is Waiting")
			; fctConstraints.CollarUpdate()
			If (!kMaster.IsDead()) 
				GoToState("monitor")
			Else
				; debugTrace(" waiting:: Master dead or disabled - Stop enslavement")
				; Debug.Notification( "Your owner is either dead or left you...")

				; SendModEvent("PCSubFree")
				GoToState("doNothing")
			EndIf
		EndIf
		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState


State monitor
	Event OnBeginState()
		; debugTrace(" Begin Monitor State")

		UpdateMasterSlave()

		kSlaver = _SDRAP_slaver.GetReference() as ObjectReference
		kSlaver2_m = _SDRAP_slaver2_m.GetReference() as ObjectReference
		kSlaver2_f = _SDRAP_slaver2_f.GetReference() as ObjectReference
;		kBindings = _SDRAP_bindings.GetReference() as ObjectReference
;		kShackles = _SDRAP_shackles.GetReference() as ObjectReference
;		kCollar = _SDRAP_collar.GetReference() as ObjectReference

		fOutOfCellTime = GetCurrentRealTime()
		fLastEscape = GetCurrentRealTime() - 5.0
		fLastIngest = GetCurrentRealTime() - 5.0
		iPlayerGender = Game.GetPlayer().GetLeveledActorBase().GetSex() as Int

		; If ( RegisterForAnimationEvent(kSlave, "weaponDraw") )
		; EndIf
		; debugTrace(" ----> Monitor State")
	EndEvent
	
	Event OnEndState()
		; debugTrace(" End Monitor State")
		; If ( UnregisterForAnimationEvent(kSlave, "weaponDraw") )
		; EndIf
	EndEvent

	Event OnUpdate()
		; While ( !Game.GetPlayer().Is3DLoaded() )  || (StorageUtil.GetIntValue(kSlave, "_SD_iEnslavementInitSequenceOn")==1)
		; EndWhile
		; debugTrace(" Player is Being Monitored")

		; Debug.Notification("[SD] Slave: Monitor")
		; Debug.Notification("[SD] Restraints: "  + fctOutfit.isRestraintEquipped (  kSlave ) )
		; Debug.Notification("[SD] Punishment: " + fctOutfit.isPunishmentEquipped (  kSlave ) )
		UpdateMasterSlave()

		; if (!kMaster) || ( !kMaster.Is3DLoaded() )
		;	GoToState("monitor")
		; endif

		_slaveStatusTicker()

		if (!kMaster) ; || ( !kMaster.Is3DLoaded() )
			GoToState("waiting")
		endif

		; Calculate distance to reference - set to Master for now. 
		; Could be set to a location marker later if needed
		kLeashCenter =  StorageUtil.GetFormValue(kSlave, "_SD_LeashCenter") as Actor
 		kMasterCell = kMaster.GetParentCell()
		kSlaveCell = kSlave.GetParentCell()

		if (kLeashCenter == None)
			fctConstraints.setLeashCenterRef(kMaster as ObjectReference)
			kLeashCenter = kMaster
		EndIf

		fDistance = kSlave.GetDistance( kLeashCenter )

		If ( kSlave.GetDistance( kMaster ) < fDistance)
			; If master is closer than previously set center of leash... could be because of a change of cell
			fctConstraints.setLeashCenterRef(kMaster as ObjectReference)
			kLeashCenter = kMaster
		EndIf

		fMasterDistance = kSlave.GetDistance( kMaster )
		kCombatTarget = kSlave.GetCombatTarget()

		; Debug.Notification("[_sdras_slave] Distance:" + fDistance + " > " + _SDGVP_escape_radius.GetValue())
		; Debug.Notification("[_sdras_slave] DefaultStance:" + StorageUtil.GetStringValue(kSlave, "_SD_sDefaultStance"))
		; Debug.Notification("[_sdras_slave] EnableLeash:" + fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableLeash"))
		; Debug.Notification("[_sdras_slave] MasterFollow:" + StorageUtil.GetIntValue(kMaster, "_SD_iFollowSlave"))
		; Debug.Notification("[_sdras_slave] AutoKneelingOFF:" + StorageUtil.GetIntValue(kSlave, "_SD_iDisablePlayerAutoKneeling"))

		; These constraints are not enforced yet. I need to turn them on one by one and evaluate their impact

		;	If ( kSlave.GetEquippedWeapon() ) && (fctSlavery.CheckSlavePrivilege( kSlave , "_SD_iEnableWeaponEquip") )
		;		kSlave.UnequipItem( kSlave.GetEquippedWeapon(), false, True )
		;		kSlave.RemoveItem( kSlave.GetEquippedWeapon(), 1, True )
		;	EndIf
		;	If ( kSlave.GetEquippedWeapon(True) ) && (fctSlavery.CheckSlavePrivilege( kSlave , "_SD_iEnableWeaponEquip")  )
		;		kSlave.UnequipItem( kSlave.GetEquippedWeapon(True), false, True )
		;		kSlave.RemoveItem( kSlave.GetEquippedWeapon(True), 1, True )
		;	EndIf
		;	If ( kSlave.GetEquippedShield() ) && (fctSlavery.CheckSlavePrivilege( kSlave , "_SD_iEnableWeaponEquip")   )
		;		kSlave.UnequipItem( kSlave.GetEquippedShield(), false, True )
		;		kSlave.RemoveItem( kSlave.GetEquippedShield(), 1, True )
		;	EndIf
		;	If ( kSlave.GetEquippedSpell(0) ) && (fctSlavery.CheckSlavePrivilege( kSlave , "_SD_iEnableSpellEquip")  )
		;		kSlave.UnequipSpell( kSlave.GetEquippedSpell(0), 0 )
		;	EndIf
		;	If ( kSlave.GetEquippedSpell(1) ) && (fctSlavery.CheckSlavePrivilege( kSlave , "_SD_iEnableSpellEquip") )
		;		kSlave.UnequipSpell( kSlave.GetEquippedSpell(1), 1 )
		;	EndIf


		If (_SDGVP_config_safeword.GetValue() as bool)
			; Safeword - abort enslavement

			debugTrace(" Safeword - Stop enslavement")
			Debug.MessageBox( "Safeword: You are released from enslavement.")
			_SDGVP_state_joined.SetValue( 0 )
			_SDGVP_config_safeword.SetValue(0)

			SendModEvent("PCSubFree")
			; Self.GetOwningQuest().Stop()

		ElseIf !kMaster || !kSlave || kMaster.IsDisabled() || kMaster.IsDead() ; || ( kMaster.IsEssential() && (kMaster.IsBleedingOut()) || (kMaster.IsUnconscious()) ) )
			debugTrace(" monitor: Master dead or disabled - Stop enslavement")
			Debug.Notification( "$Your owner is either dead or left you...")

			; SendModEvent("PCSubFree")
			GoToState("doNothing")

		ElseIf ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
			; Park the slave in 'waiting' state while enslavement quest is shutting down

			GoToState("waiting")
 
		ElseIf ((StorageUtil.GetIntValue(kMaster, "_SD_iOverallDisposition") >  (_SDGVP_config_disposition_threshold.GetValue() as Int)) || (fBuyout >= 0)  ) && (StorageUtil.GetFloatValue(kSlave, "_SD_fEnslavementDuration") > _SDGVP_join_days.GetValue() ) && (_SDGVP_can_join.GetValue() == 0) && (_SDGVP_join_days.GetValue() < 100)
			; Slavery positive 'endgame' - player can join master or be cast away
			; If number of days to join is set to maximum (100), slave will never be allowed to join

	 		_SDGVP_can_join.SetValue(1) 

		ElseIf ( Self.GetOwningQuest().GetStage() >= 90 )
			; Grace period if slave declines to join the master at the end of enslavement ('Get out of my sight')

			fOutOfCellTime = GetCurrentRealTime()
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False

		; ElseIf ( _SDCP_sanguines_realms.Find( kSlaveCell ) > -1 )
			; Obsolete - Do not report slave as escaped if teleported to Dreamworld
			; Could be useful later

			;	fOutOfCellTime = GetCurrentRealTime()
			;	enslavement.bEscapedSlave = False
			;	enslavement.bSearchForSlave = False

		ElseIf ( !Game.IsMovementControlsEnabled() ) ; || kSlave.GetCurrentScene() )
			; Slave is busy in a scene or stuck in place 
			; Could be useful later to keep the slave to a pillory or cross for an amount of time as punishment

			fOutOfCellTime = GetCurrentRealTime()
			enslavement.bEscapedSlave = False
			enslavement.bSearchForSlave = False

		; Disabled for now - issues with conditions to triger it
		Elseif (StorageUtil.GetIntValue( none, "_SD_iCageSceneActive" )==1) &&  ( _SDGVP_state_caged.GetValueInt() == 0 ) && (StorageUtil.GetIntValue(none, "_SD_bEnableCageScene") == 1)
			; Debug.Notification( "[SD] Cage state - slave out of cage during scene" )
			debugTrace(" Cage state - slave out of cage during scene" )
			GoToState("escape_choke")

		ElseIf ( _SDGVP_state_caged.GetValueInt() == 1 ) && (StorageUtil.GetIntValue(none, "_SD_bEnableCageScene") == 1)
			; Slave is caged
			; Debug.Notification( "[SD] Cage state - caged detected" )
			debugTrace(" Cage state - caged detected" )

			GoToState("caged")

		ElseIf ( kMaster.IsInCombat() )
			; Master is in combat
			; This used to mark the slave as 'escaped' but that was causing too many issues. 
			; Displaying a reminder for now. Add other consequences later (penalties based on distance of player from master during combat for example)

			; GoToState("escape_shock")

			If (Utility.RandomInt(0,100) > 70)
				Debug.Notification( "$Your owner is in combat. Stay close..." )
				If ( kMaster.GetCurrentScene() )
					kMaster.GetCurrentScene().Stop()
				EndIf
		 		; kMaster.EvaluatePackage()

				If (fMasterDistance >  StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength"))
					StorageUtil.SetIntValue(kMaster, "_SD_iDisposition", 	funct.intWithinRange ( StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") - 1, -10, 10) )

				EndIf
			EndIf

		ElseIf  (kMasterCell.IsInterior()) && (kSlaveCell.IsInterior()) && ( ( kMaster.GetSleepState() != 0 )   || (StorageUtil.GetIntValue(kMaster, "_SD_iFollowSlave") > 0) ) && (kSlaveCell != kMasterCell)  && (fctOutfit.isCollarEquipped ( kSlave ))  && ( (StorageUtil.GetIntValue(kMaster, "_SD_iTrust") + StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") - 3) < 0)  
			; Special handling of interior cells (for large caves with connecting rooms)
			; Slave is free to roam around if both master and slave are in the same indoor cell and slave is 'trusted' or master is asleep or if master is following (prevent collar teleport when changing cells )

			; If (RandomInt( 0, 100 ) > 95 )
			; 	Debug.Notification( "Your collar weighs around your neck..." )
			; EndIf
 
			; GoToState("escape_shock")	

		ElseIf  (kMasterCell.IsInterior()) && (!kSlaveCell.IsInterior()) && ( ( kMaster.GetSleepState() != 0 ) || ( kMaster.HasLOS( kSlave ))) && (kSlaveCell != kMasterCell) && (Utility.RandomInt(0,100) > 70)  && (fctOutfit.isCollarEquipped ( kSlave ))  && (StorageUtil.GetIntValue(kMaster, "_SD_iTrust") < 0)
			; Special handling of of escape from master's cell while master is asleep or not paying attention

			; GoToState("escape_shock")	

		ElseIf ( fDistance > _SDGVP_escape_radius.GetValue() )
			; Distance based leash - decrease field of view for the slave as distance increases until blackout and teleport back to master
			; Enabled if Leash is On and master is not following slave

			If fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableLeash") && (StorageUtil.GetIntValue(kMaster, "_SD_iFollowSlave") == 0) && (StorageUtil.GetIntValue(kMaster, "_SD_iTrust")<0)

				; GoToState("escape_shock")
 
			Else
				; If distance based leash is Off, switch to time buffer leash instead
				if (fctOutfit.isCollarEquipped ( kSlave ))  && (StorageUtil.GetIntValue(kMaster, "_SD_iTrust") < 0)
					; GoToState("escape_shock")
				endif
			EndIf

		ElseIf ( fDistance > (_SDGVP_escape_radius.GetValue() * 0.7) ) && ( fDistance < _SDGVP_escape_radius.GetValue() )
			; Display warning when slave is close to escape radius

			If fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableLeash") && (StorageUtil.GetIntValue(kMaster, "_SD_iFollowSlave") == 0) && (StorageUtil.GetIntValue(kMaster, "_SD_iTrust")<0)
				Debug.Notification( "$You are too far from your owner..." )
				fctSlavery.ModMasterTrustTokens(kMaster, -1)

				; Reset blackout effect if needed
				; _SD_CollarStrangleImod.Remove()
			EndIf

		Else

			; Debug.Notification("[SD] Slave: Master actions")

			; Clean up chocking effect if leash is on
			If fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableLeash") && (StorageUtil.GetIntValue(kMaster, "_SD_iFollowSlave") == 0)
				_SD_CollarStrangleImod.Remove()
			EndIf

			fCalcLeashLength = _SDGV_leash_length.GetValue() * 1.5		

			; Leaving this code in place in case we need to treat slave differently based on location relative to master
			; If (kMaster.GetParentCell().IsInterior()) 
				; Debug.Notification( "Master inside") 
			; Else
				; Debug.Notification( "Master outside")
			; EndIf

			; If (kMaster.GetParentCell() == kSlaveCell) 
				; Debug.Notification( "Slave and master in same cell ") 
			; Else
				; Debug.Notification( "Slave and master in diff cells ") 
			; EndIf

			; Not sure where else fOutOfCellTime is used - leaving it here for now
			fOutOfCellTime = GetCurrentRealTime()

			; Debug.Notification("[SD] Slave: Master LOS: " + kMaster.HasLOS( kSlave ))
			; Debug.Notification("[SD] Slave: Master dist: " + fMasterDistance )
			; Debug.Notification("[SD] Slave: Master leash: " + _SDGV_leash_length.GetValue())
			; Debug.Notification("[SD] Slave: Master asleep: " + kMaster.GetSleepState())

			; 0 - Not sleeping
			; 2 - Not sleeping, wants to sleep
			; 3 - Sleeping
			; 4 - Sleeping, wants to wake
			If ( kMaster.GetSleepState() != 0 ) 
				; Master is asleep

			ElseIf ( kMaster.HasLOS( kSlave )) && (fMasterDistance < (_SDGV_leash_length.GetValue() as Float))
				; Master is watching slave nearby

				Int iTrust = StorageUtil.GetIntValue(kMaster, "_SD_iTrust")   
				Float fKneelingDistance = funct.floatWithinRange( 500.0 - ((iTrust as Float) * 5.0), 100.0, 2000.0 )

				; Debug.Notification("Master is watching. " )

				; Debug.Notification("[SD] Slave: Master LOS")
				; Debug.Notification("[SD] Slave: Master dist: " + fMasterDistance )
				; Debug.Notification("[SD] Slave: Kneeling dist: " + fKneelingDistance )

				; Debug.Notification("[SD] Slave: Armbinder equipped: " + (fctOutfit.isArmbinderEquipped(kSlave)) )
				; Debug.Notification("[SD] Slave: Yoke equipped: " +  fctOutfit.isYokeEquipped( kSlave )   )
				; Debug.Notification("[SD] Slave: SexLab anim: " +  (StorageUtil.GetIntValue( kSlave, "_SL_iPlayerSexAnim") )   )
				; Debug.Notification("[SD] Slave: Hands Free Sex: " +  (StorageUtil.GetIntValue(kSlave, "_SD_iHandsFreeSex"))    )
				; Debug.Notification("[SD] Slave: Hands Free: " +  (StorageUtil.GetIntValue(kSlave, "_SD_iHandsFree")) ) 
				; Debug.Notification("[SD] Slave: Enable action: " +  (StorageUtil.GetIntValue(kSlave, "_SD_iEnableAction"))     )
				; Debug.Notification("[SD] Slave: Allow bindings: " +  (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryBindingsOn")) )

				If (fctOutfit.isDeviceEquippedKeyword( kSlave,  "_SD_DeviousSpriggan" , "Armbinder" )) && ((StorageUtil.GetIntValue(kSlave, "_SD_iHandsFree")==0) || (StorageUtil.GetIntValue(kSlave, "_SD_iEnableAction")==0))
					StorageUtil.SetIntValue(kSlave, "_SD_iEnableArmorEquip", 1)
					StorageUtil.SetIntValue(kSlave, "_SD_iHandsFree", 1)
					StorageUtil.SetIntValue(kSlave, "_SD_iEnableAction", 1)
				Endif


				If (fMasterDistance < fKneelingDistance)  && ( (fctOutfit.isArmorCuirassEquipped(kSlave) &&  (!fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableArmorEquip")) ) || ( fctOutfit.isClothingBodyEquipped(kSlave) && !fctSlavery.CheckSlavePrivilege(kSlave, "_SD_iEnableClothingEquip")) )  && ( fctOutfit.countRemovable ( kSlave ) > 0) && (_SDGVP_config_limited_removal.GetValue() == 0)

					Debug.MessageBox("You are not allowed to wear clothing. Your owner rips it away from you.")
					SexLab.ActorLib.StripActor(kSlave, VictimRef = kSlave, DoAnimate= false)


					If (fctSlavery.ModMasterTrust( kMaster, -1)<0) || (StorageUtil.GetIntValue( kSlave , "_SD_iDom") > StorageUtil.GetIntValue( kSlave, "_SD_iSub") )

						Int iRandomNum = Utility.RandomInt(0,100)

						if (iRandomNum > 90) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn")==1)
							; Punishment
							; 
							If (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1)
								enslavement.PunishSlave(kMaster,kSlave,"Bra")
							endif
							; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
							; kMaster.SendModEvent("PCSubPunish")
							funct.SanguinePunishment( kMaster )

						ElseIf (iRandomNum > 80) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryWhipSceneOn")==1)
							; Whipping
							; 
							If (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1)
								enslavement.PunishSlave(kMaster,kSlave, "Belt")
							endif
							; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
							; kMaster.SendModEvent("PCSubWhip")
							funct.SanguineWhip( kMaster )

						ElseIf (iRandomNum > 70)
							; Sex
							; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 0, aiValue2 = RandomInt( 0, _SDGVP_positions.GetValueInt() ) )
							kMaster.SendModEvent("PCSubSex", "Rough")
						EndIf
 
					EndIf
				EndIf

				If (StorageUtil.GetStringValue(kSlave, "_SD_sDefaultStance") != "Crawling")
					If (fMasterDistance < fKneelingDistance) && (!fctOutfit.isWristRestraintEquipped(kSlave))  && (StorageUtil.GetIntValue( kSlave, "_SL_iPlayerSexAnim") == 0 )  && (StorageUtil.GetIntValue(kSlave, "_SD_iHandsFreeSex") == 0)   && ((StorageUtil.GetIntValue(kSlave, "_SD_iHandsFree") == 0)  || (StorageUtil.GetIntValue(kSlave, "_SD_iEnableAction") == 0)   ) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryBindingsOn")==1)

						; fctOutfit.setMasterGearByRace ( kMaster, kSlave  )
						; fctOutfit.equipDeviceByString ( "Armbinder" )
						; enslavement.PunishSlave(kMaster,kSlave,"Armbinder")

						; StorageUtil.SetIntValue(kSlave, "_SD_iHandsFree", 0)

						; Debug.Notification("Your owner binds your hands again.")

						; Debug.Trace("[SD] _SD_iHandsFreeSex: " + StorageUtil.GetIntValue(kSlave, "_SD_iHandsFreeSex"))
						; Debug.Trace("[SD] _SD_iHandsFree: " + StorageUtil.GetIntValue(kSlave, "_SD_iHandsFree"))
						; Debug.Trace("[SD] _SD_iEnableAction: " + StorageUtil.GetIntValue(kSlave, "_SD_iEnableAction"))

					ElseIf (fMasterDistance < fKneelingDistance)  && (fctOutfit.isWristRestraintEquipped(kSlave)) && (StorageUtil.GetIntValue( kSlave, "_SL_iPlayerSexAnim") == 0 ) && (StorageUtil.GetIntValue(kSlave, "_SD_iHandsFreeSex") == 0)   && ((StorageUtil.GetIntValue(kSlave, "_SD_iHandsFree") == 1)  || (StorageUtil.GetIntValue(kSlave, "_SD_iEnableAction") == 1)   ) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryBindingsOn")==1)

						; fctOutfit.clearDeviceByString ( "Armbinder" )
						; Debug.Notification("Your owner releases your hands.")

					EndIf
				Endif

				Weapon krHand = kSlave.GetEquippedWeapon()
				Weapon klHand = kSlave.GetEquippedWeapon( True )

				If (fMasterDistance < fKneelingDistance)  && (!fctOutfit.isWristRestraintEquipped(kSlave)) && ((StorageUtil.GetIntValue(kSlave, "_SD_iEnableWeaponEquip") == 0)   || (StorageUtil.GetIntValue(kSlave, "_SD_iHandsFree") == 0)  || (StorageUtil.GetIntValue(kSlave, "_SD_iEnableAction") == 0)) && (kSlave.IsWeaponDrawn() || krHand || klHand)

					; Drop current weapon 
					if(kSlave.IsWeaponDrawn())
						kSlave.SheatheWeapon()
						Utility.Wait(2.0)
					endif

					If ( krHand )
					;	kSlave.DropObject( krHand )
						kSlave.UnequipItem( krHand )
					EndIf
					If ( klHand )
					;	kSlave.DropObject( klHand )
						kSlave.UnequipItem( klHand )
					EndIf

					; Debug.Notification("You are not allowed to use a weapon. Your owner rips it away from you.")

					; Debug.Trace("[SD] _SD_iHandsFreeSex: " + StorageUtil.GetIntValue(kSlave, "_SD_iHandsFreeSex"))
					; Debug.Trace("[SD] _SD_iHandsFree: " + StorageUtil.GetIntValue(kSlave, "_SD_iHandsFree"))
					; Debug.Trace("[SD] _SD_iEnableAction: " + StorageUtil.GetIntValue(kSlave, "_SD_iEnableAction"))

					If (fctSlavery.ModMasterTrust( kMaster, -1)<0)

						Int iRandomNum = Utility.RandomInt(0,100)

						if (iRandomNum > 70) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn")==1)
							; Punishment
							; 
							if (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1)
								enslavement.PunishSlave(kMaster,kSlave, "Gag")
							endif
							; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
							; kMaster.SendModEvent("PCSubPunish")
							funct.SanguinePunishment( kMaster )

						ElseIf (iRandomNum > 50) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryWhipSceneOn")==1)
							; Whipping
							; enslavement.PunishSlave(kMaster,kSlave, "Yoke")
							; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
							; kMaster.SendModEvent("PCSubWhip")
							funct.SanguineWhip( kMaster )
						
						else
							kMaster.SendModEvent("PCSubSex","Rough")

						EndIf

					Endif
				EndIf

			ElseIf ( GetCurrentRealTime() - fOutOfCellTime > fCalcOOCLimit )

				fOutOfCellTime = GetCurrentRealTime() + 30

			Else
				; Debug.Notification( "[Master ignores you]" )
			EndIf
 

		EndIf

		If ( Self.GetOwningQuest() )
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent

	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, Bool abPowerAttack, Bool abSneakAttack, Bool abBashAttack, Bool abHitBlocked)
		If (!kMaster)
			Return
		EndIf
		
		If ( akAggressor != kMaster ) && (Self.GetOwningQuest().GetStage() < 90) && kMaster.HasLOS( kSlave )
			; Start combat between master and NPC when the slave is hit by someone other than Master

			kSlave.StopCombatAlarm()
			kSlave.StopCombat()
			If ( ( akAggressor as Actor ).IsHostileToActor( kMaster ) )
				kMaster.StartCombat( akAggressor as Actor )
			EndIf

		EndIf
	EndEvent
	

EndState


State escape_shock
	Event OnBeginState()
		kPlayer = Game.GetPlayer()
		; Debug.Notification( "$SD_MESSAGE_ESCAPE_NOW" )
		Debug.Notification( "$Your collar vibrates as you wander off." )
		debugTrace(" Escape attempt - shock collar" )
		debugTrace(" starting timer" )
		iPlayerGender = kPlayer.GetLeveledActorBase().GetSex() as Int
		
		UpdateMasterSlave()

		; Calculate distance to reference - set to Master for now. 
		; Could be set to a location marker later if needed
		kLeashCenter =  StorageUtil.GetFormValue(kSlave, "_SD_LeashCenter") as Actor

		if (kLeashCenter == None)
			fctConstraints.setLeashCenterRef(kMaster as ObjectReference)
			kLeashCenter = kMaster
		EndIf

		_SDGVP_isMasterInTransit.SetValue(0) 

		fDistance = kSlave.GetDistance( kLeashCenter )
	
		If ( kSlave.GetDistance( kMaster ) < fDistance)
			; If master is closer than previously set center of leash... could be because of a change of cell
			fctConstraints.setLeashCenterRef(kMaster as ObjectReference)
			kLeashCenter = kMaster
		EndIf

		freedomTimer ( 50 ) ; _SDGVP_escape_timer.GetValue() )
		fEscapeTime = GetCurrentRealTime() + 50 ; forced to 1 minute - funct.intMin( StorageUtil.GetIntValue(kSlave, "_SD_iTimeBuffer") as Int, _SDGVP_escape_timer.GetValue() as Int)
		fEscapeUpdateTime = GetCurrentRealTime() + 10 ; update every 20 s


		; SD 3.3 - testing Master searching for slave during collar events
		If (StorageUtil.GetIntValue(kMaster, "_SD_iTrust") < 0)
			enslavement.bSearchForSlave = True
			; fctSlavery.ModMasterTrust( kMaster, -1  ); deduct 1 from trust allowance for the day

			If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
				kCrimeFaction = kMaster.GetCrimeFaction()
				If (kCrimeFaction!=None)
					kCrimeFaction.SetCrimeGold(100)
				Endif
			endif
		Endif

		; kMaster.EvaluatePackage()

	EndEvent
	
	Event OnEndState()
		kPlayer = Game.GetPlayer()

		; Debug.Notification( "$SD_MESSAGE_ESCAPE_GONE" )
		Debug.Notification( "$Your collar stops vibrating." )
		debugTrace(" Escape attempt - end" )

		If (kSlave.GetDistance(kMaster)< (_SDGV_leash_length.GetValue() / 2) ) && (!kMaster.IsDead()) 
			; Slave is close to master and master is not dead, stop escape state

			Debug.Notification("$The collar is sending shocks." )
			if (iPlayerGender==0)
				_SDSMP_choke_m.Play( kPlayer )
			else
				_SDSMP_choke.Play( kPlayer )
			endif

			_SDSP_SelfShockEffect.Cast(kSlave as Actor)

			UpdateSlaveArousal()
			
			kSlave.DispelSpell( _SDSP_Weak )

			SendModEvent("SDEscapeStop") 
			If (!kMaster.IsInCombat()) && (fctSlavery.ModMasterTrust( kMaster, -1)<0) 

				If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
					Debug.Notification( "$Where did you think you were going?" )

					If (kCrimeFaction!=None)
						Int iGold = kCrimeFaction.GetCrimeGold()
						kCrimeFaction.PlayerPayCrimeGold( True, False )	
						_SDGVP_buyout.SetValue( (_SDGVP_buyout.GetValue() as Int)  + iGold )
					Endif

				endIf

				if (Utility.RandomInt(0,100)>90) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentSceneOn")==1)
					; Punishment
					; 
					if (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1)
						enslavement.PunishSlave(kMaster,kSlave,"Blindfold")
					endif
					; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 3, aiValue2 = RandomInt( 0, _SDGVP_punishments.GetValueInt() ) )
					; kMaster.SendModEvent("PCSubPunish")
					funct.SanguinePunishment( kMaster )

				Elseif (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryWhipSceneOn")==1)
					; Whipping
					; _SDKP_sex.SendStoryEvent(akRef1 = kMaster, akRef2 = kSlave, aiValue1 = 5 )
					; kMaster.SendModEvent("PCSubWhip")
					funct.SanguineWhip( kMaster )

				else
					kMaster.SendModEvent("PCSubSex","Rough")
				EndIf
			Else
				kMaster.SendModEvent("PCSubSex")
			EndIf
		EndIf
	EndEvent

	Event OnUpdate()
		kPlayer = Game.GetPlayer()

		; While ( !Game.GetPlayer().Is3DLoaded() )
		; EndWhile
		; debugTrace(" Player is Escaping (shocking collar)")
		UpdateMasterSlave()

		_slaveStatusTicker()

		fMasterDistance = kSlave.GetDistance( kMaster )
 		kMasterCell = kMaster.GetParentCell()
		kSlaveCell = kSlave.GetParentCell()
	
		If (_SDGVP_config_safeword.GetValue() as bool)
			; Safeword detected - End enslavement

			debugTrace(" Safeword on escape - Stop enslavement")
			Debug.MessageBox( "Safeword: You are released from enslavement.")
			_SDGVP_state_joined.SetValue( 0 )
			_SDGVP_config_safeword.SetValue(0)

			SendModEvent("PCSubFree")
			; Self.GetOwningQuest().Stop()

		ElseIf !kMaster || !kSlave || kMaster.IsDisabled() || kMaster.IsDead() ; || ( kMaster.IsEssential() && (kMaster.IsBleedingOut()) || (kMaster.IsUnconscious()) ) )
			debugTrace(" escape_shock: Master dead or disabled - Stop enslavement")
			Debug.Notification( "$Your owner is either dead or left you...")

			; SendModEvent("PCSubFree")
			GoToState("doNothing")

		ElseIf  (kSlaveCell == kMasterCell) ; && (kMaster.GetParentCell().IsInterior()) && (kSlaveCell.IsInterior()) && ( ( kMaster.GetSleepState() == 0 )  || (StorageUtil.GetIntValue(kMaster, "_SD_iTrust") > 0)  || (StorageUtil.GetIntValue(kMAster, "_SD_iFollowSlave") > 0) )   
			; Slave back in same cell as master, turn off escape mode
			; If (RandomInt( 0, 100 ) > 70 )
			;	Debug.Notification( "Your captors are watching. Don't stray too far...")
			; EndIf
 
			GoToState("monitor")
		Else

			If ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
				; Park slave in 'waiting' state while enslavement quest is shuttting down
				GoToState("waiting")

			; ElseIf ( !Game.IsMovementControlsEnabled() )
				; AI controlled - slave marched back to master
				; Keep it for later if needed

				;	kSlave.PathToReference( kMaster, 1.0 )
				;	GoToState("monitor")

			ElseIf ( (fMasterDistance > _SDGVP_escape_radius.GetValue()) && ((kSlaveCell != kMasterCell) || (!kMasterCell.IsInterior())) )
				; Slave is outside escape radius and master is outdoors and in a different cell

				If ( GetCurrentRealTime() > fEscapeUpdateTime )
					; Escape timer is running

					; Debug.Notification( "Run!" )
					fTime = fEscapeTime - GetCurrentRealTime()
					fEscapeUpdateTime = GetCurrentRealTime() + 60
					freedomTimer ( fTime ) ; - Displays "x minutes and you are free...
 
				ElseIf ( GetCurrentRealTime() >= fEscapeTime )
					; Escape timer is exceeded - player has escaped

					; debugTrace(" Escaped from master - collar will send random shocks")
					_SDFP_slaversFaction.ModCrimeGold( 1000 )
					enslavement.bEscapedSlave = True
					enslavement.bSearchForSlave = True

					; Automatic end of enslavement after escape is disabled for now... master is still lurking around
					; TO DO - add expiration code (free slave after enough time outside timed buffer)
					; TO DO - turn on master follow slave / turn off later

					if (StorageUtil.GetIntValue(kMaster,"_SD_iFollowSlave") == 0)
						StorageUtil.SetIntValue(kMaster,"_SD_iFollowSlave", 1)
						_SDGVP_state_MasterFollowSlave.SetValue(1) 
						SendModEvent("SDEscapeStart") 
					EndIf

					; SendModEvent("PCSubFree")  

					If (Utility.RandomInt(0,100)>=90)

						Debug.Notification("$The collar is sending shocks." )
						if (iPlayerGender==0)
							_SDSMP_choke_m.Play( kPlayer )
						else
							_SDSMP_choke.Play( kPlayer )
						endif

						_SDSP_SelfShockEffect.Cast(kSlave as Actor)

						UpdateSlaveArousal()

						If (Utility.RandomInt(0,100)>=95)
							_SDSP_Weak.Cast(kSlave as Actor)
						EndIf
					EndIf

				EndIf
			EndIf
		EndIf

		If ( Self.GetOwningQuest() ) && (!enslavement.bEscapedSlave)
			RegisterForSingleUpdate( fRFSU )
		ElseIf ( Self.GetOwningQuest() ) && (enslavement.bEscapedSlave)
			RegisterForSingleUpdate( fRFSU / 4.0 )
		EndIf
	EndEvent
EndState

State escape_choke
	Event OnBeginState()
		kPlayer = Game.GetPlayer()

		; Debug.Notification( "$SD_MESSAGE_ESCAPE_NOW" )
		Debug.Notification( "$Your collar tightens as you wander off from the cage." )
		debugTrace(" Cage scene - choking collar - start" )
		debugTrace(" starting timer" )
		iPlayerGender = kPlayer.GetLeveledActorBase().GetSex() as Int

		UpdateMasterSlave()

		freedomTimer ( 20 ) ; _SDGVP_escape_timer.GetValue() )
		fEscapeTime = GetCurrentRealTime() + 20 ; forced to 30 s for choking - funct.intMin( StorageUtil.GetIntValue(kSlave, "_SD_iTimeBuffer") as Int, _SDGVP_escape_timer.GetValue() as Int)
		fEscapeUpdateTime = GetCurrentRealTime() + 5 ; update every 10 s 

		; SD 3.3 - testing Master searching for slave during collar events
		enslavement.bSearchForSlave = True

		; kMaster.EvaluatePackage()
	EndEvent
	
	Event OnEndState()
		kPlayer = Game.GetPlayer()
		; Debug.Notification( "$SD_MESSAGE_ESCAPE_GONE" )
		; Debug.Notification( "[SD] Cage scene - choking collar - end" )
		debugTrace(" Cage scene - choking collar - end" )

		SendModEvent("SDEscapeStop") 

		If (!kMaster.IsDead()) 

			Debug.Notification("$The collar is choking you.." )
			if (iPlayerGender==0)
				_SDSMP_choke_m.Play( kSlave )
			else
				_SDSMP_choke.Play( kSlave )
			endif

			; _SDSP_SelfShockEffect.Cast(kSlave as Actor)
			
			kSlave.DispelSpell( _SDSP_Weak )
			_SDGVP_isMasterInTransit.SetValue(0) 

		EndIf
	EndEvent

	Event OnUpdate()
		kPlayer = Game.GetPlayer()
		; While ( !Game.GetPlayer().Is3DLoaded() )
		; EndWhile
		; debugTrace(" Player is Escaping (choking collar)")

		UpdateMasterSlave()

		If !kMaster || !kSlave || kMaster.IsDisabled() || kMaster.IsDead() ; || ( kMaster.IsEssential() && (kMaster.IsBleedingOut()) || (kMaster.IsUnconscious()) ) )
			debugTrace(" escape_choke: Master dead or disabled - Stop enslavement")
			Debug.Notification( "$Your owner is either dead or left you...")

			; SendModEvent("PCSubFree")
			GoToState("doNothing")
		Endif

		_slaveStatusTicker()

		kCageRef =  _SDRAP_cage_marker.GetReference() ; cage location

		if (kCageRef == None)
			; somehow, no cage detected
			debugTrace(" Cage scene - no cage found" )
			GoToState("waiting")
		EndIf

		fDistance = kCageRef.GetDistance( kSlave )
 		kMasterCell = kMaster.GetParentCell()
		kSlaveCell = kSlave.GetParentCell()
		fMasterDistance = kSlave.GetDistance( kMaster )

		If (_SDGVP_config_safeword.GetValue() as bool)
			; Safeword detected - End enslavement

			debugTrace(" Safeword on escape - Stop enslavement")
			Debug.MessageBox( "Safeword: You are released from enslavement.")
			_SDGVP_state_joined.SetValue( 0 )
			_SDGVP_config_safeword.SetValue(0)

			SendModEvent("PCSubFree")
			; Self.GetOwningQuest().Stop()

		Else

			If ( Self.GetOwningQuest().IsStopping() || Self.GetOwningQuest().IsStopped() )
				; Park slave in 'waiting' state while enslavement quest is shuttting down
				GoToState("waiting")

			; ElseIf ( !Game.IsMovementControlsEnabled() )
				; AI controlled - slave marched back to master
				; Keep it for later if needed

				;	kSlave.PathToReference( kLeashCenter, 1.0 )
				;	GoToState("cage")

			elseif (StorageUtil.GetIntValue( none, "_SD_iCageSceneActive" )==1) &&  ( _SDGVP_state_caged.GetValueInt() == 0 )
				; Debug.Notification( "[SD] Cage state - slave out of cage during scene" )
				; debugTrace(" Cage state - slave out of cage during scene" )
				GoToState("monitor")

			elseif ( _SDGVP_state_caged.GetValueInt() == 1 )
				; Debug.Notification( "[SD] Cage state - slave out of cage during scene" )
				; debugTrace(" Cage state - slave out of cage during scene" )
				GoToState("caged")

			ElseIf ( fDistance > iCageRadius ) ; && ((kSlaveCell != kMasterCell) || (!kMasterCell.IsInterior())) )
				; Slave is outside escape radius and master is outdoors or in a different cell

				If ( GetCurrentRealTime() > fEscapeUpdateTime )
					; Escape timer is running

					; Debug.Notification( "Run!" )
					fTime = fEscapeTime - GetCurrentRealTime()
					fEscapeUpdateTime = GetCurrentRealTime() + 60
					freedomTimer ( fTime ) ; - Displays "x minutes and you are free...
 
				ElseIf ( GetCurrentRealTime() >= fEscapeTime )
					; Escape timer is exceeded - player has escaped

					; debugTrace(" Escaped from master - collar will send random shocks")
					; _SDFP_slaversFaction.ModCrimeGold( 1000 )
					enslavement.bEscapedSlave = True
					enslavement.bSearchForSlave = True


					; Automatic end of enslavement after escape is disabled for now... master is still lurking around
					; TO DO - add expiration code (free slave after enough time outside timed buffer)
					; TO DO - turn on master follow slave / turn off later

					if (StorageUtil.GetIntValue(kMaster,"_SD_iFollowSlave") == 0)
						StorageUtil.SetIntValue(kMaster,"_SD_iFollowSlave", 1)
						_SDGVP_state_MasterFollowSlave.SetValue(1) 
						SendModEvent("SDEscapeStart") 
					EndIf

					; SendModEvent("PCSubFree")  

					fBlackoutRatio = ( funct.floatMin( fDistance, iCageRadius * 2.0 ) - iCageRadius ) / iCageRadius
					; Debug.Notification( "[SD] Blackout ratio: "  + fBlackoutRatio )


					If (fBlackoutRatio < 0.3)
						_SD_CollarStrangleImod.Remove()
						_SD_CollarStrangleImod.Apply(fBlackoutRatio)
						if (Utility.RandomInt(0,100)>80)
							Debug.Notification( "$You are too far from the cage." )
							Debug.Notification( "$Your collar tightens around your throat..." )
							if (iPlayerGender==0)
								_SDSMP_choke_m.Play( kSlave )
							else
								_SDSMP_choke.Play( kSlave )
							endif

						EndIf

					ElseIf (fBlackoutRatio < 0.6)
						;_SD_CollarStrangleImod.Remove()
						_SD_CollarStrangleImod.PopTo(_SD_CollarStrangleImod,fBlackoutRatio)
						if (Utility.RandomInt(0,100)>80)
							Debug.Notification( "$You are still far from the cage." )
							Debug.Notification( "$Your breathing is painful..." )
							if (iPlayerGender==0)
								_SDSMP_choke_m.Play( kSlave )
							else
								_SDSMP_choke.Play( kSlave )
							endif

						EndIf

					Else
						;_SD_CollarStrangleImod.Remove()
						_SD_CollarStrangleImod.PopTo(_SD_CollarStrangleImod,fBlackoutRatio)
						if (Utility.RandomInt(0,100)>80)
							Debug.Notification( "$Your collar is choking you..." )
							if (iPlayerGender==0)
								_SDSMP_choke_m.Play( kSlave )
							else
								_SDSMP_choke.Play( kSlave )
							endif

						EndIf

					EndIf


					If (fBlackoutRatio >= 0.95)
					;	Debug.Notification("You should blackout here.")
						_SD_CollarStrangleImod.Remove()
						if (iPlayerGender==0)
							_SDSMP_choke_m.Play( kSlave )
						else
							_SDSMP_choke.Play( kSlave )
						endif

		                Game.FadeOutGame(true, true, 0.5, 5)

		                kSlave.MoveTo( kCageRef )					

						Game.FadeOutGame(false, true, 2.0, 20)

						Utility.Wait( 1.0 )

						Debug.MessageBox( "After being choked by the collar, you wake up next to your owner." )

						If (!kMaster.IsDead()) && (!kMaster.IsInCombat()) && (fctSlavery.ModMasterTrust( kMaster, -1)<0)
 
							If (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryPunishmentOn")==1)
								enslavement.PunishSlave(kMaster,kSlave,"Gag")
								enslavement.PunishSlave(kMaster,kSlave,"Blindfold")
							endif

						EndIf
					EndIf


				EndIf
			EndIf
		EndIf

		If ( Self.GetOwningQuest() ) && (!enslavement.bEscapedSlave)
			RegisterForSingleUpdate( fRFSU )
		ElseIf ( Self.GetOwningQuest() ) && (enslavement.bEscapedSlave)
			RegisterForSingleUpdate( fRFSU / 4.0 )
		EndIf
	EndEvent
EndState

State caged
	Event OnBeginState()
		; Debug.Notification( "[SD] Cage state - start" )
		debugTrace(" Cage state - start" )
		iPlayerGender = Game.GetPlayer().GetLeveledActorBase().GetSex() as Int

		enslavement.bEscapedSlave = False
		enslavement.bSearchForSlave = False
		; _SDGVP_state_caged.SetValue( 1 )

	EndEvent
	
	Event OnEndState()
		; Debug.Notification( "[SD] Cage state - end" )
		debugTrace(" Cage state - end" )

	EndEvent

	Event OnUpdate()
		; While ( !Game.GetPlayer().Is3DLoaded() )
		; EndWhile
		; debugTrace(" Player is Caged")
		ObjectReference cage_door = _SDRAP_cage.GetReference() as ObjectReference

		UpdateMasterSlave()

		If !kMaster || !kSlave || kMaster.IsDisabled() || kMaster.IsDead() ; || ( kMaster.IsEssential() && (kMaster.IsBleedingOut()) || (kMaster.IsUnconscious()) ) )
			debugTrace(" caged: Master dead or disabled - Stop enslavement")
			Debug.Notification( "$Your owner is either dead or left you...")

			; SendModEvent("PCSubFree")
			GoToState("doNothing")
		Endif

		_slaveStatusTicker()
			
		If ( StorageUtil.GetIntValue( none, "_SD_iCagedSlave") == 0)
			; Debug.Notification( "[SD] Cage state - slave is released - stop" )
			debugTrace(" Cage state - slave is released - stop" )

			; If ( cage_door.IsLocked() )
			;	cage_door.Lock( False )
			; EndIf

			; cage_door.SetOpen()

			debugTrace(" Trigger Monitor State")
			GoToState("monitor")

			; debugTrace(" Trigger Waiting State")
			; GoToState("waiting")

		EndIf

		If ( Self.GetOwningQuest() ) 
			RegisterForSingleUpdate( fRFSU )
		EndIf
	EndEvent
EndState


State doNothing
	Event OnBeginState()
	EndEvent
	
	Event OnEndState()
	EndEvent

	Event OnUpdate()
		debugTrace(" doNothing state - Master dead or disabled - Stop enslavement")
		Debug.Notification( "$Your owner is either dead or left you...")

		SendModEvent("PCSubFree")	
	EndEvent
EndState

Function _slaveStatusInit()
	StorageUtil.SetIntValue(kMaster, "_SD_iDispositionThreshold", _SDGVP_config_disposition_threshold.GetValue() as Int) 
	StorageUtil.SetFloatValue(kMaster, "_SD_iMinJoinDays", _SDGVP_join_days.GetValue() as Int) 
	fBuyout = (StorageUtil.GetIntValue(kMaster, "_SD_iGoldCountTotal") as Float) - _SDGVP_buyout.GetValue() 
	StorageUtil.SetFloatValue(kMaster, "_SD_iMasterBuyOut", fBuyout ) 
EndFunction

Function _slaveStatusTicker()
	; Update slave status if needed
	Float fSlaveLevel = StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryLevel") as Float
	Int iPunishmentCheck = 0 

	;	Debug.Notification( "[SD] Tick")

 	daysPassed = Game.QueryStat("Days Passed")
 	timePassed = Utility.GetCurrentGameTime()
	kMasterCell = kMaster.GetParentCell()
	kSlaveCell = kSlave.GetParentCell()

 	if (iGameDateLastCheck == -1)
 		iGameDateLastCheck = daysPassed
 		HourlyTickerLastCallTime = timePassed
 	EndIf

 	iDaysSinceLastCheck = (daysPassed - iGameDateLastCheck ) as Int

	fBuyout = (StorageUtil.GetIntValue(kMaster, "_SD_iGoldCountTotal") as Float) - _SDGVP_buyout.GetValue() 
	StorageUtil.SetFloatValue(kMaster, "_SD_iMasterBuyOut", fBuyout ) 

 	if (iDaysSinceLastCheck==0)
		if ((timePassed-HourlyTickerLastCallTime)>= (HourlyTickerPeriod ) ) ; same day - incremental updates
			debugTrace( " Slavery status - hourly update")
			; Disabled for now - daily update makes more sense
			; fctSlavery.UpdateStatusHourly( kMaster, kSlave)
			iHoursLastCheck = ((timePassed-HourlyTickerLastCallTime)/ (HourlyTickerPeriod ) ) as Int
			if (iHoursLastCheck<1)
				iHoursLastCheck = 1
			EndIf

			; if (StorageUtil.GetIntValue( none, "_SD_iCagedSlave")==0)
			;	enslavement.ResetCage( kSlave)
			; endIf

			; Debug.Notification( "[SD] Hours passed: " + iHoursLastCheck)

			;/ Removed decrease of allowance with every hour... to be replaced by move granular point system based on actions
			If (_SDGVP_state_caged.GetValue()==1)
				fctSlavery.ModMasterTrust( kMaster, 1 )
			Else
				If (StorageUtil.GetIntValue(kSlave, "_SD_iEnslavedSleepToken") == 1)
					StorageUtil.SetIntValue(kSlave, "_SD_iEnslavedSleepToken", 0)
				elseif  funct.sexlabIsActive( kSlave )
				Else
					fctSlavery.ModMasterTrust( kMaster, -1 * iHoursLastCheck ); deduct 1 from trust allowance for the day
				Endif
			EndIf
			/;


			HourlyTickerLastCallTime = timePassed

			if (iHoursLastCheck>1)
				fctSlavery.EvaluateSlaveryTaskList(kSlave) ; evaluate tasks after wait or sleep

				; Count how many actions add to distrust. For every 5 actions, drecrease 1 allowace point
				If (StorageUtil.GetIntValue(kMaster, "_SD_iEnslavedTrustToken") >=5)
					Debug.Notification( "[SD] Cash in trust tokens: " + StorageUtil.GetIntValue(kMaster, "_SD_iEnslavedTrustToken"))
					fctSlavery.ModMasterTrust( kMaster, -1 - (StorageUtil.GetIntValue(kMaster, "_SD_iEnslavedTrustToken") / 5) )
					StorageUtil.SetIntValue(kMaster, "_SD_iEnslavedTrustToken", 0) ; cash tokens in
				endif

			endIf

			; Check punishment status every 4 hours
			iPunishmentCheck = iPunishmentCheck + 1

			if (iPunishmentCheck==4)
				fctSlavery.EvaluateSlaveryTaskList(kSlave) 

				enslavement.UpdateSlaveState( kMaster, kSlave )
				enslavement.UpdateSlaveFollowerState(kSlave)
				iPunishmentCheck = 0
			Endif

			; Trigger only after an hour has passed from enslavement
			If (!fctOutfit.isCollarEquipped(kSlave)) && (StorageUtil.GetIntValue(kSlave, "_SD_iSlaveryCollarOn") == 1) && (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature") == 0)
				If (kSlave.GetDistance( kMaster )<1500)
					Debug.Notification("$Your master is disappointed to find you without a collar.")
					fctOutfit.equipDeviceByString ( sDeviceString = "Collar", sOutfitString= "", sDeviceTags = "" )
					fctOutfit.lockDeviceByString( kSlave,  "Collar")
					fctSlavery.ModMasterTrust(kMaster, -5)
				Else
					Debug.Notification("$Your master is too far to collar you again.")
				Endif
			EndIf
		endif
	Else ; day change - full update
		debugTrace(" Slavery status - daily update")
		iGameDateLastCheck = daysPassed
		iCountSinceLastCheck = 0 
		kMaster.SendModEvent("PCSubStatus")
		fctSlavery.ResetDailyCounts(  kMaster,  kSlave)

		kMaster.SendModEvent("SLDRefreshNPCDialogues")

		if (StorageUtil.GetIntValue( none, "_SD_iCagedSlave")==0)
			enslavement.ResetCage( kSlave)
		endIf

		StorageUtil.SetFloatValue(kSlave, "_SD_iEnslavementDays", 	StorageUtil.GetFloatValue(kSlave, "_SD_iEnslavementDays") + 1)
		StorageUtil.SetFloatValue(kSlave, "_SD_fPunishmentDuration", 0.0)

		StorageUtil.SetIntValue(kMaster, "_SD_iDispositionThreshold", _SDGVP_config_disposition_threshold.GetValue() as Int) 
		StorageUtil.SetFloatValue(kMaster, "_SD_iMinJoinDays", _SDGVP_join_days.GetValue() as Int) 

		_SDGVP_config_min_days_before_master_travel.SetValue(StorageUtil.GetIntValue(kSlave, "_SD_iMasterTravelDelay"))
		; _SDGVP_config_cage_enable.SetValue( StorageUtil.GetIntValue(none, "_SD_bEnableCageScene")  ) 
		_SDGVP_config_cage_enable.SetValue( 0 ) 
		StorageUtil.SetIntValue(none, "_SD_bEnableCageScene", 0) 

		if (StorageUtil.GetIntValue(kMaster, "_SD_iForcedSlavery") == 1)
			If (_SDGVP_config_min_days_before_master_travel.GetValue()>=0) && ( (daysPassed - StorageUtil.GetIntValue(kMaster, "_SD_iDaysPassedOutside")) >= _SDGVP_config_min_days_before_master_travel.GetValue()) && (_SDGVP_isMasterTraveller.GetValue() == 0) && (!kMasterCell.IsInterior()) && (!kSlaveCell.IsInterior()) 
				debugTrace(" Master is bored - starting travel package")
				_SDGVP_isMasterTraveller.SetValue(1)
			endif
		Endif

		; Cooldown at end of day
		; If ( StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") >= 2 ) || ( StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") <= -2 )
		;	StorageUtil.SetIntValue(kMaster, "_SD_iDisposition", StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") * 9 / 10 )
		; EndIf

		; If ( StorageUtil.GetIntValue(kMaster, "_SD_iTrust") >= 2 ) || ( StorageUtil.GetIntValue(kMaster, "_SD_iTrust") <= -2 )
		;	StorageUtil.SetIntValue(kMaster, "_SD_iTrust", StorageUtil.GetIntValue(kMaster, "_SD_iTrust") * 9 / 10 )
		; EndIf

		; If ( StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") >= 2 ) || ( StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") <= -2 )
		;	StorageUtil.SetIntValue(kSlave, "_SD_iTrustPoints", StorageUtil.GetIntValue(kSlave, "_SD_iTrustPoints") * 9 / 10 )
		; EndIf

		; If (StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") < 0) && (StorageUtil.GetIntValue(kMaster, "_SD_iTrust") < 0)
		;	enslavement.PunishSlave( kMaster,  kSlave, "Gag")
		; EndIf

		; Safety - removal of punishments after one day
		enslavement.UpdateSlaveState( kMaster, kSlave )
		enslavement.UpdateSlaveFollowerState(kSlave)

		If (StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") >= 0) 
			enslavement.RewardSlave(kMaster,kSlave,"Gag")
			enslavement.RewardSlave(kMaster,kSlave,"Yoke")
		endIf

		If (StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") >= 2) 
			enslavement.RewardSlave(kMaster,kSlave,"Belt")
			enslavement.RewardSlave(kMaster,kSlave,"Bra")
		endIf

		If (StorageUtil.GetIntValue(kMaster, "_SD_iTrust") >= 0)
			enslavement.RewardSlave(kMaster,kSlave,"Blindfold")
			enslavement.RewardSlave(kMaster,kSlave,"Armbinder")
		endif

		If (StorageUtil.GetIntValue( kSlave  , "_SD_iHandsFree") == 0) && (StorageUtil.GetIntValue( kSlave  , "_SD_iEnableAction") == 1) 
			StorageUtil.SetIntValue( kSlave  , "_SD_iHandsFree", 1 )
			StorageUtil.SetIntValue( kSlave  , "_SD_iEnableAction", 1 )			
		Endif

		If (StorageUtil.GetIntValue(kMaster, "_SD_iOverallDisposition") < (-1 * (_SDGVP_config_disposition_threshold.GetValue() as Int)) ) && (StorageUtil.GetFloatValue(kSlave, "_SD_fEnslavementDuration") > _SDGVP_join_days.GetValue() ) && (!kSlave.GetCurrentScene())  && (Utility.RandomInt(0,100)>(60 - ((StorageUtil.GetFloatValue(kSlave, "_SD_fEnslavementDuration") as Int) * 5 )) )     
			If (_SDGVP_join_days.GetValue() < 100) || ((_SDGVP_join_days.GetValue() == 100) && (Utility.RandomInt(0,100)>(95 - ((StorageUtil.GetFloatValue(kSlave, "_SD_fEnslavementDuration") as Int) )) ) ) 
				; 5% chance of end game if master is unhappy with long term slavery option
				_slaveEndGame()
			Else
				debugTrace(" END GAME - No luck")
				; _slaveEndGame()

			Endif
		Else
			debugTrace(" END GAME - Not yet")
				; _slaveEndGame()
		Endif

		fctSlavery.EvaluateSlaveryTaskList(kSlave) ; First evaluate current task in case it can be completed 

		debugTrace(" Slavery status - END daily update")




	EndIf


	; enslavement.UpdateSlaveState(kMaster ,kSlave)
	; enslavement.UpdateSlaveFollowerState(kSlave)

	; Update GlobalVariables based on storageUtil values
	if (( kMaster.GetSleepState() != 0 ) && (StorageUtil.GetIntValue(kMaster, "_SD_iDisposition") < 0))
		; Reduce leash length and escape time buffer by half if master is awake and angry
		fEscapeLeashLength = funct.floatMin( _SDGV_leash_length.GetValue(), (StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength") / 2) as Float )
		fEscapeLeashLength = funct.floatMin( _SDGVP_escape_timer.GetValue(), (StorageUtil.GetIntValue(kSlave, "_SD_iTimeBuffer" ) / 2) as Float )
	Else
		fEscapeLeashLength = funct.floatMin( _SDGV_leash_length.GetValue(), (StorageUtil.GetIntValue(kSlave, "_SD_iLeashLength") ) as Float )
		fEscapeLeashLength = funct.floatMin( _SDGVP_escape_timer.GetValue(), (StorageUtil.GetIntValue(kSlave, "_SD_iTimeBuffer" ) ) as Float )
	EndIf

	fEnslavementDuration = fctSlavery.GetEnslavementDuration( kSlave)
	StorageUtil.SetFloatValue(kSlave, "_SD_fEnslavementDuration", fEnslavementDuration ) 
	_SDGVP_isLeashON.SetValue( StorageUtil.GetIntValue(kSlave, "_SD_iEnableLeash") as Int )
	_SDGVP_state_SlaveDominance.SetValue( StorageUtil.GetIntValue(kSlave, "_SD_iDominance") as Int )

	if (StorageUtil.GetIntValue(kSlave, "_SD_iEnslavementInitSequenceOn")==0)
		fctConstraints.CollarUpdate()
	endIf

EndFunction


Function _slaveEndGame()
	; Slavery negative 'endgame' - sell player to another NPC / left for dead somewhere / teleport to Dreamworld

	; Debug.Notification("[SD] Endgame: " + kSlaver )
	; Debug.Notification("[SD] Buyout: " + fBuyout)
	fBuyout = (StorageUtil.GetIntValue(kMaster, "_SD_iGoldCountTotal") as Float) - _SDGVP_buyout.GetValue() 
	StorageUtil.SetFloatValue(kMaster, "_SD_iMasterBuyOut", fBuyout ) 

	If (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature")== 1)
		; Endgame for creatures
		If (Utility.RandomInt(0,100)>80)
			debugTrace(" END GAME - Master fights slave" )
			Debug.MessageBox( "Your owner is fed up with your resistance and turns against you." )
			kMaster.StartCombat(kSlave)
			SendModEvent("PCSubFree")
		Else
			debugTrace(" END GAME - Master ignore slave" )
			Debug.MessageBox( "Your owner is fed up with you and turns away from you." )
			SendModEvent("PCSubFree")

		Endif
	Else
		; genderRestrictions = 0 - any / 1 - same / 2 - opposite

		if (Utility.RandomInt(0,100)>50)
			kSlaverDest = kSlaver
		else
			kSlaverDest = kSlaver2_m
		Endif
	
		Int    genderRestrictions = _SDGVP_gender_restrictions.GetValue() as Int

		If (iPlayerGender  == 0)
			; iPlayerGender = 0 - male
			if (genderRestrictions == 2)
				kSlaverDest = kSlaver2_f
			endif
				
		Else
			; iPlayerGender = 1 - female
			if (genderRestrictions == 1)
				kSlaverDest = kSlaver2_f
			endif
			
		EndIf

		; Debug.MessageBox("[SD] PlayerGender: " + iPlayerGender + "\n Restrictions: " + genderRestrictions)

		If (_SD_dreamQuest.GetStage() != 0) && ( (Utility.RandomInt(0,100)>90)  ||  (!kSlaverDest) || (kMaster == kSlaverDest) )
			; Player saved by Sanguine
			debugTrace(" END GAME - Player saved by Sanguine" )
			Debug.MessageBox( "Sanguine takes pity on you and spirits you away." )
			_SD_dreamQuest.SetStage(20)
		
		ElseIf (_SD_dreamQuest.GetStage() == 0) && (!kSlaverDest)
			; Player saved by Sanguine
			; Debug.MessageBox( "Sanguine takes pity on you and spirits you away." )
			debugTrace(" END GAME - Player pulled by Sanguine for first time" )
			Debug.MessageBox( "You find yourself transported to a strange garden..." )
			_SD_dreamQuest.SetStage(10)

		ElseIf kSlaverDest && (kMaster != kSlaverDest)  && (fBuyout <= 0) && (!fctFactions.checkIfFalmer(kSlaverDest as Actor)) && (StorageUtil.GetIntValue(kMaster, "_SD_iMasterIsCreature")==0)
			; Master lost money - slave to be sold
			debugTrace(" END GAME - Master lost money - slave to be sold" )

			if (iPlayerGender==0)
				_SDSMP_choke_m.Play( Game.GetPlayer() )
			else
				_SDSMP_choke.Play( Game.GetPlayer() )
			endif

			; Reset to 0 to avoid loop with endgame situations
			StorageUtil.SetIntValue(kMaster, "_SD_iOverallDisposition", 0)
			fctSlavery.UpdateSlavePrivilege(kSlave, "_SD_iEnableLeash", False)

			; StorageUtil.SetFormValue( Game.getPlayer() , "_SD_TempAggressor", kSlaverDest as Actor)
			; Bool bMariaEden = False

			; If (Utility.RandomInt(0,100) > 70) 
			; 	bMariaEden = MariaEdenEnslave() 
			; EndIf

			; If (!bMariaEden)
			; Endif


            ; Game.FadeOutGame(true, true, 0.5, 5)
			; (kSlave as ObjectReference).MoveTo( kSlaverDest )
			; Replace by code to dreamDestination
			Bool bMariaEden = False
			Bool bWolfClub = False
			Bool bSimpleSlavery = False
			Bool bRedWave = False

			If (Utility.RandomInt(0,100) > 70) 
				bWolfClub = funct.WolfClubEnslave() 
				
			ElseIf (Utility.RandomInt(0,100) > 40) 
				bSimpleSlavery = funct.SimpleSlaveryEnslave() 

			ElseIf (Utility.RandomInt(0,100) > 50) 
				bRedWave = funct.RedWaveEnslave()

			ElseIf (Utility.RandomInt(0,100) > 70) 
			 	bMariaEden = funct.MariaEdenEnslave(kSlaverDest as Actor) 
			EndIf

			If (!bWolfClub) && (!bSimpleSlavery) && (!bMariaEden) && (!bRedWave)
				Debug.MessageBox( "Your owner is very disappointed of your attitude and suddenly draws a bag over your head and renders you unconsious.\n When you wake up again, you find yourself sold to a new owner. " )

                Game.FadeOutGame(true, true, 0.5, 5)
				(kSlave as ObjectReference).MoveTo( kSlaverDest )
				kActor = kSlaverDest as Actor
				kActor.SendModEvent("PCSubTransfer")
				Game.FadeOutGame(false, true, 2.0, 20)
			Else
				kMaster.SendModEvent("PCSubMasterTravel", "Start")
				; SendModEvent("PCSubFree")
			Endif


			Utility.Wait( 1.0 )


		ElseIf kSlaverDest &&  ((fBuyout > 0) || fctFactions.checkIfFalmer(kSlaverDest as Actor)  || (kMaster == kSlaverDest))
			; Master made profit - get rid of slave
			debugTrace(" END GAME - Master made profit - get rid of slave" )

			if (iPlayerGender==0)
				_SDSMP_choke_m.Play( Game.GetPlayer() )
			else
				_SDSMP_choke.Play( Game.GetPlayer() )
			endif

			Debug.MessageBox( "Your owner is tired of your attitude and suddenly hits the back of your head and renders you unconscious.\n When you come to your senses, you find yourself discarded in the wilderness like an old shoe." )
			; Reset to 0 to avoid loop with endgame situations
			StorageUtil.SetIntValue(kMaster, "_SD_iOverallDisposition", 0)

			SendModEvent("PCSubFree")

            ; Game.FadeOutGame(true, true, 0.5, 5)
			; (kSlave as ObjectReference).MoveTo( kSlaverDest )
			; Replace by code to dreamDestination
			dreamQuest.sendDreamerBack( 50 ) ; 50 - random location

			; Game.FadeOutGame(false, true, 2.0, 20)

			If (Utility.RandomInt(0,100) > 90) 
				; Send PC some help
				SendModEvent("da_StartSecondaryQuest", "Both")
			EndIf

		Else
				kMaster.SendModEvent("PCSubMasterTravel", "Start")
				; SendModEvent("PCSubFree")

		EndIf
	Endif

EndFunction



		


function UpdateSlaveArousal()

	if (slaUtil != None)
		; slaUtil.UpdateActorExposureRate(kSlave as Actor, 2.0)
		slaUtil.SetActorExposure(kSlave as Actor, slaUtil.GetActorExposure(kSlave as Actor) + 5)
		Debug.Notification("$The shocks are making you hornier." )
	endIf

	; int eid = ModEvent.Create("slaUpdateExposure")
	; ModEvent.PushForm(eid, kSlave as Actor)
	; ModEvent.PushFloat(eid, 2.0)
	; ModEvent.Send(eid)

Endfunction


Function debugTrace(string traceMsg)
	if (StorageUtil.GetIntValue(none, "_SD_debugTraceON")==1)
		Debug.Trace("[_sdras_slave]"  + traceMsg)
	endif
endFunction