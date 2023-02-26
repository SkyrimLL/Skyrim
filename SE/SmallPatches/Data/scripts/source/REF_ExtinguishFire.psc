Scriptname REF_ExtinguishFire Extends ObjectReference
{Moderately complex script that handles the putting out of fires.}

Activator Property ExtinguishedVersion Auto
Formlist Property AppropriateOffFormlist Auto
Formlist Property REF_FRL_OcclusionDetectionMarkerList Auto
GlobalVariable Property REF_GLB_iMaxLookups Auto
GlobalVariable Property REF_GLB_fUpdateInterval Auto
Keyword Property MagicDamageFrost Auto
Keyword Property MagicDamageFire Auto
Static Property XMarker Auto
Spell Property REF_SPL_OcclusionDetectionBeam Auto

Float Property fOnLoadDelay = 5.0 Auto
Float Property fOnStateBeginUpdate = 5.0 Auto
Float Property fOcclusionVerticalOffset = 180.0 Auto
Float Property fMaximumRoofDistance = 600.0 Auto
Float Property fToleranceMax = 50.0 Auto
Float Property fDistanceToSearch = 200.0 Auto

ObjectReference akOFFVersion 
ObjectReference akFireLight 
REF_LightFire OFFVersionControl 

Bool bShouldCheckOcclusion
Float fUpdateInterval
Int iMaxLookups
Int iCurrentLookup
	
Import PO3_SKSEFunctions
Import PO3_Events_Form
Import REF_UtilityFunctions

Event OnStateBegin()

	;This is NOT called when the object intitializes, meaning that we can register for stuff here.
	bShouldCheckOcclusion = False
	RegisterForMagicEffectApplyEx(Self, MagicDamageFrost, True)
	RegisterForHitEventEx(Self, NONE, MagicDamageFrost, NONE, -1, -1, -1, -1, true)
	RegisterForHitEventEx(Self, NONE, NONE, MagicDamageFrost, -1, -1, -1, -1, true)
	RegisterForSingleUpdate(fOnStateBeginUpdate)
EndEvent

Event OnLoad()

	RegisterForMagicEffectApplyEx(Self, MagicDamageFrost, True)	
	bShouldCheckOcclusion = False
	If !Self.IsEnabled()
	
		Return
	EndIf
	
	;Register for a single 5 second update to see if we should be immediately put out.
	RegisterForSingleUpdate(fOnLoadDelay)
EndEvent

Event OnUnload()

	;Probably unecessary, but best to have peace of mind.
	UnregisterForWeatherChange(Self)
	UnregisterForAllMagicEffectApplyEx(Self)
EndEvent

Event OnUpdate()

	CheckWeather()
EndEvent

Event OnMagicEffectApplyEx(ObjectReference akCaster, MagicEffect akEffect, Form akSource, bool abApplied)

	GoToState("PutOutFire")
EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	
	Weapon akSourceWeapon = akSource As Weapon
	
	If akSourceWeapon.HasKeyword(MagicDamageFrost)
	
		If akSourceWeapon.IsBow() || IsCrossbow(akSourceWeapon)
		
			;Shot by a bow or a crossbow - this means we potentially have a conflict of enchantments.
			Actor akAggressorActor = akAggressor As Actor
			Enchantment akAmmoEnchantment = GetAmmoEnchantment(akAggressorActor)
			
			If akAmmoEnchantment.HasKeyword(MagicDamageFire)
			
				;Conflicting enchants! Do nothing.
				Return
			EndIf	
		EndIf
		
		;Hit by ice.
		GoToState("PutOutFire")
	
	ElseIf akSourceWeapon.IsBow() || IsCrossbow(akSourceWeapon)
	
		;There's a chance that the ammo is enchanted.
		Actor akAggressorActor = akAggressor As Actor
		Enchantment akAmmoEnchantment = GetAmmoEnchantment(akAggressorActor)
		
		If akAmmoEnchantment.HasKeyword(MagicDamageFrost)
		
			GoToState("PutOutFire")
		EndIf
	EndIf
EndEvent

Event OnWeatherChange(Weather akOldWeather, Weather akNewWeather)

	Int iWeatherCode = akNewWeather.GetClassification()
	
	If iWeatherCode == 2 || iWeatherCode == 3
	
		GoToState("ListeningForWeatherTransition")
	EndIf
EndEvent

Function ResetSelf()

	;Empty in the empty state.
EndFunction

Function CheckWeather()
	
	If Self.IsInInterior()
	
		Return
	EndIf
	
	;If it is raining, extinguish this fire. Otherwise, just listen for a weather change.
	Int iWeatherCode = Weather.GetCurrentWeather().GetClassification()
	
	;Appropriate weather codes - 2 (RAINY) and 3 (SNOWY)
	If (iWeatherCode == 2 || iWeatherCode == 3)
	
		bShouldCheckOcclusion = True
		GoToState("ListeningForWeatherTransition")
	EndIf
	
	RegisterForWeatherChange(Self)
EndFunction

State ListeningForWeatherTransition

	;While in this state, the fire polls every x seconds to see when the weather has fully transitioned.
	;To prevent hanging, this state has (by default) a value of 10 max iterations.
	Event OnBeginState()
	
		iMaxLookups = REF_GLB_iMaxLookups.GetValue() As Int
		fUpdateInterval = REF_GLB_fUpdateInterval.GetValue()
		iCurrentLookup = 0
		
		If bShouldCheckOcclusion
	
			;Are we occluded? Perform the test.
			ObjectReference akCasterMarker = Self.PlaceAtMe(XMarker)
			akCasterMarker.MoveTo(Self, 0.0, 0.0, fOcclusionVerticalOffset)
			ObjectReference akTargetMarker = akCasterMarker.PlaceAtMe(XMarker)
			akTargetMarker.MoveTo(akCasterMarker, 0.0, 0.0, 500.0) ;Position does not matter as long as it is directly above.
			
			REF_SPL_OcclusionDetectionBeam.Cast(akCasterMarker, akTargetMarker)
			
			Utility.Wait(3.0)
			
			ObjectReference akClosestMarker = Game.FindClosestReferenceOfAnyTypeInListFromRef(REF_FRL_OcclusionDetectionMarkerList, Self, fMaximumRoofDistance)

			if (akClosestMarker != None)
			
				Float fClosestX = akClosestMarker.GetPositionX()
				Float fClosestY = akClosestMarker.GetPositionY()
				Float fCenterX = Self.GetPositionX()
				Float fCenterY = Self.GetPositionY()
				
				Float fToleranceX = Math.Abs(Math.Abs(fClosestX) - Math.Abs(fCenterX))
				Float fToleranceY = Math.Abs(Math.Abs(fClosestY) - Math.Abs(fCenterY))

			
				akCasterMarker.Disable()
				akCasterMarker.Delete()
				akTargetMarker.Disable()
				akTargetMarker.Delete()
						
				If fToleranceX < fToleranceMax && fToleranceY < fToleranceMax && akClosestMarker
				
					GoToState("")
					Return
				EndIf
			endif
		EndIf
		
		RegisterForSingleUpdate(fUpdateInterval)
	EndEvent
	
	Event OnUpdate()
	
		iCurrentLookup += 1
		
		If ((iCurrentLookup > iMaxLookups) || (Weather.GetCurrentWeatherTransition() >= 0.95))
		
			;Check to see if it is still raining or snowing.
			Int iWeatherCode = Weather.GetCurrentWeather().GetClassification()
			
			If iWeatherCode == 2 || iWeatherCode == 3
			
				GoToState("PutOutFire")
			Else
			
				;Player likely used clear skies.
				GoToState("")
			EndIf
		Else
		
			RegisterForSingleUpdate(fUpdateInterval)
		EndIf
	EndEvent
	
	Event OnMagicEffectApplyEx(ObjectReference akCaster, MagicEffect akEffect, Form akSource, bool abApplied)

		;Interrupted by frost spell. Unregister for update, put out fire.
		UnregisterForUpdate()
		GoToState("PutOutFire")
	EndEvent
	
	Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
	
		Weapon akSourceWeapon = akSource As Weapon
		
		If akSourceWeapon.HasKeyword(MagicDamageFrost)
		
			If akSourceWeapon.IsBow() || IsCrossbow(akSourceWeapon)
			
				;Shot by a bow or a crossbow - this means we potentially have a conflict of enchantments.
				Actor akAggressorActor = akAggressor As Actor
				Enchantment akAmmoEnchantment = GetAmmoEnchantment(akAggressorActor)
				
				If akAmmoEnchantment.HasKeyword(MagicDamageFire)
				
					;Conflicting enchants! Do nothing.
					Return
				EndIf	
			EndIf
			
			;Hit by ice.
			UnregisterForUpdate()
			GoToState("PutOutFire")
		
		ElseIf akSourceWeapon.IsBow() || IsCrossbow(akSourceWeapon)
		
			;There's a chance that the ammo is enchanted.
			Actor akAggressorActor = akAggressor As Actor
			Enchantment akAmmoEnchantment = GetAmmoEnchantment(akAggressorActor)
			
			If akAmmoEnchantment.HasKeyword(MagicDamageFrost)
			
				UnregisterForUpdate()
				GoToState("PutOutFire")
			EndIf
		EndIf
	EndEvent
EndState

State PutOutFire

	Event OnBeginState()
		
		;Before the wait, grab the scale and unregister for frost.
		UnregisterForAllMagicEffectApplyEx(Self)
		Float fScale = Self.GetScale()
		
		akOFFVersion = Self.PlaceAtMe(ExtinguishedVersion)

		if (akOFFVersion != none)
			akOFFVersion.SetAngle(Self.GetAngleX(), Self.GetAngleY(), Self.GetAngleZ())
			akOFFVersion.SetScale(fScale)
			
			;Turn off the light.
			ObjectReference[] akNearbyLights = FindAllReferencesOfFormType(Self, 31, fDistanceToSearch)
			
			;Find the nearest, enabled light source.
			Int iIteration = akNearbyLights.Length
			Float fMaxDistance = 0.0
			
			While iIteration > 0
				
				iIteration -= 1
				ObjectReference akCandidateLight = akNearbyLights[iIteration]
				
				If akCandidateLight.GetDistance(akOFFVersion) >= fMaxDistance && akCandidateLight.IsEnabled()
				
					akFireLight = akCandidateLight
				EndIf
			EndWhile
			
			If akFireLight
			
				akFireLight.DisableNoWait()
			EndIf
			
			Self.Disable(True)
			
			;Visual component done. Move on to background stuff that allows the fire to be re-lit by the player.
			OFFVersionControl = akOFFVersion As REF_LightFire
			OFFVersionControl.LitVersion = Self
			
			;Stop tracking frost hits and weather changes.
			UnregisterForWeatherChange(Self)
			UnregisterForAllMagicEffectApplyEx(Self)
			UnregisterForAllHitEventsEx(Self)
			
			;Add the fire to a list of fires to reset if the player goes into an interior
			AppropriateOffFormlist.AddForm(akOFFVersion)
		endif
		
		;Leave this state
		GoToState("Waiting")
	EndEvent
	
	;@override
	Function ResetSelf()
	
		GoToState("")	
	EndFunction
EndState

State Waiting

	;In this state, the fire was put out. We're waiting to be relit via an external source.
	;@override
	Function ResetSelf()
	
		;Note - this function is called by the REF_FurnitureScript script and the REF_CleanupScript.
		Self.Enable()
		
		If akOFFVersion.IsEnabled()
	
			akOFFVersion.Disable(True)
			akOFFVersion.Delete()
		EndIf
		
		If !akFireLight.IsEnabled()
		
			akFireLight.Enable()
		EndIf
		
		;Clear pointers to have minimal impact on the save.
		If OFFVersionControl.LitVersion
	
			OFFVersionControl.LitVersion = NONE
		EndIf
		
		akOFFVersion = NONE
		akFireLight = NONE
		OFFVersionControl = NONE
		bShouldCheckOcclusion = NONE
		
		GoToState("")
	EndFunction
EndState