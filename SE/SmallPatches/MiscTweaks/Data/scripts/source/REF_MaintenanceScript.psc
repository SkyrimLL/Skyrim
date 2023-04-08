Scriptname REF_MaintenanceScript Extends Quest

Actor Property PlayerREF Auto
Formlist Property REF_FRL_AllHeatSources Auto
Formlist Property REF_FRL_AllMediumHeatSources Auto
Formlist Property REF_FRL_AllSmallHeatSources Auto
Formlist Property REF_FRL_AllUnlitGiantCampfires Auto
Formlist Property REF_FRL_AllUnlitCampfires Auto
Formlist Property REF_FRL_AllUnlitEmbers Auto
Formlist Property REF_FRL_AllUnlitCandles Auto
Formlist Property REF_FRL_AllUnlitTorches Auto
Formlist Property REF_FRL_TEMP_AllGiantFiresToRelight Auto
Formlist Property REF_FRL_TEMP_AllCampfiresToRelight Auto
Formlist Property REF_FRL_TEMP_AllEmbersToRelight Auto
Formlist Property REF_FRL_TEMP_AllCandlesToRelight Auto
Formlist Property REF_FRL_TEMP_AllTorchesToRelight Auto
Message Property REF_MSG_SurvivalModePatchInstalled Auto
Message Property REF_MSG_SunHelmPatchInstalled Auto
Message Property REF_MSG_FrozenNorthPatchInstalled Auto
Message Property REF_MSG_FrostfallPatchInstalled Auto
Message Property REF_MSG_FiresHurtPatchInstalled Auto

Bool bIsSurvivalModeInstalled
Bool bIsSunHelmInstalled
Bool bIsFrozenNorthInstalled
Bool bIsFrostfallInstalled
Bool bIsFiresHurtInstalled
Float[] fVersion

Event OnInit()

	fVersion = New Float[3]
	fVersion[0] = 4
	fVersion[1] = 0
	fVersion[2] = 0
	
	bIsSurvivalModeInstalled = False
	bIsSunHelmInstalled = False
	bIsFrozenNorthInstalled = False
	bIsFrostfallInstalled = False
	bIsFiresHurtInstalled = False
	
	CheckSupportedMods()
EndEvent

Function CheckSupportedMods()
	
	If !bIsSurvivalModeInstalled
	
		If InstallSurvivalModePatch()
		
			REF_MSG_SurvivalModePatchInstalled.Show()
		EndIf
	EndIf
	
	If !bIsSunHelmInstalled
	
		If InstallSunhelmPatch()
		
			REF_MSG_SunHelmPatchInstalled.Show()
		EndIf
	EndIf
	
	If !bIsFrozenNorthInstalled
	
		If InstallFrozenNorthPatch()
		
			REF_MSG_FrozenNorthPatchInstalled.Show()
		EndIf
	EndIf
	
	If !bIsFrostfallInstalled
	
		If InstallFrostFallPatch()
		
			REF_MSG_FrostfallPatchInstalled.Show()
		EndIf
	EndIf
	
	If !bIsFiresHurtInstalled
	
		If InstallFiresHurtPatch()
		
			REF_MSG_FiresHurtPatchInstalled.Show()
		EndIf
	EndIf
EndFunction

Bool Function CheckSupportedVersion()

	If fVersion[0] != 4
	
		Return False
	EndIf
	
	If fVersion[1] != 0
		
		fVersion[1] = 0
		Self.Stop()
		Return False
	EndIf
	
	If fVersion[2] == 0
	
		Return True
	EndIf
	
	fVersion[2] = 0
	Self.Stop()
	Return False
EndFunction

Bool Function InstallSurvivalModePatch()

	If Game.GetModByName("ccQDRSSE001-SurvivalMode.esl") != 255
	
		bIsSurvivalModeInstalled = True
		
		Int iFormlistSize = REF_FRL_AllHeatSources.GetSize()
		Formlist akTargetFormlist = Game.GetFormFromFile(2218, "ccQDRSSE001-SurvivalMode.esl") As Formlist ;All Heat Sources formlist.
			
		While iFormlistSize > 0
			
			iFormlistSize -= 1
			akTargetFormlist.AddForm(REF_FRL_AllHeatSources.GetAt(iFormlistSize))
		EndWhile
	EndIf
	
	Return bIsSurvivalModeInstalled
EndFunction

Bool Function InstallSunhelmPatch()

	If Game.GetModByName("SunHelmSurvival.esp") != 255
	
		bIsSunHelmInstalled = True
		;Sunhelm requires three patches. One is to add all heat sources to the heat sources Formlist.
		;Two is to add campfires to medium heat sources.
		;Three is to add embers and torces to small heat sources.
		
		Formlist akTargetFormlist = Game.GetFormFromFile(7885080, "SunHelmSurvival.esp") As Formlist ;All heat sources formlist
		Int iFormlistSize = REF_FRL_AllHeatSources.GetSize()
		
		While iFormlistSize > 0
			
			iFormlistSize -= 1
			akTargetFormlist.AddForm(REF_FRL_AllHeatSources.GetAt(iFormlistSize))
		EndWhile
			
		akTargetFormlist = Game.GetFormFromFile(7885082, "SunHelmSurvival.esp") As Formlist
		iFormlistSize = REF_FRL_AllMediumHeatSources.GetSize()
		
		While iFormlistSize > 0
			
			iFormlistSize -= 1
			akTargetFormlist.AddForm(REF_FRL_AllMediumHeatSources.GetAt(iFormlistSize))
		EndWhile
			
		akTargetFormlist = Game.GetFormFromFile(7885083, "SunHelmSurvival.esp") As Formlist
		iFormlistSize = REF_FRL_AllSmallHeatSources.GetSize()
		
		While iFormlistSize > 0
			
			iFormlistSize -= 1
			akTargetFormlist.AddForm(REF_FRL_AllSmallHeatSources.GetAt(iFormlistSize))
		EndWhile		
	EndIf
	
	Return bIsSurvivalModeInstalled
EndFunction

Bool Function InstallFrozenNorthPatch()

	If Game.GetModByName("TheFrozenNorth.esp") != 255
	
		bIsFrozenNorthInstalled = True
		
		Int iFormlistSize = REF_FRL_AllMediumHeatSources.GetSize()
		Formlist akTargetFormlist = Game.GetFormFromFile(2091, "TheFrozenNorth.esp") As Formlist ;Medium Heat Sources formlist
			
		While iFormlistSize > 0
			
			iFormlistSize -= 1
			akTargetFormlist.AddForm(REF_FRL_AllMediumHeatSources.GetAt(iFormlistSize))
		EndWhile
			
		iFormlistSize = REF_FRL_AllSmallHeatSources.GetSize()
		akTargetFormlist = Game.GetFormFromFile(2112, "TheFrozenNorth.esp") As Formlist ;Small Heat Sources formlist.
			
		While iFormlistSize > 0
			
			iFormlistSize -= 1
			akTargetFormlist.AddForm(REF_FRL_AllSmallHeatSources.GetAt(iFormlistSize))
		EndWhile
	EndIf
	
	Return bIsFrozenNorthInstalled
EndFunction

Bool Function InstallFrostFallPatch()

	If Game.GetModByName("Frostfall.esp") != 255
	
		bIsFrostfallInstalled = True
		
		Int iFormlistSize = REF_FRL_AllHeatSources.GetSize()
		Formlist akTargetFormlist = Game.GetFormFromFile(167686, "Campfire.esm") As Formlist ;All Heat Sources formlist.
		
		While iFormlistSize > 0
		
			iFormlistSize -= 1
			akTargetFormlist.AddForm(REF_FRL_AllHeatSources.GetAt(iFormlistSize))
		EndWhile
		
		iFormlistSize = REF_FRL_AllMediumHeatSources.GetSize()
		akTargetFormlist = Game.GetFormFromFile(167684, "Campfire.esm") As Formlist ;All Medium Heat Sources formlist.
		
		While iFormlistSize > 0
		
			iFormlistSize -= 1
			akTargetFormlist.AddForm(REF_FRL_AllMediumHeatSources.GetAt(iFormlistSize))
		EndWhile
		
		iFormlistSize = REF_FRL_AllSmallHeatSources.GetSize()
		akTargetFormlist = Game.GetFormFromFile(167683, "Campfire.esm") As Formlist ;All Smol Heat Sources formlist.
		
		While iFormlistSize > 0
		
			iFormlistSize -= 1
			akTargetFormlist.AddForm(REF_FRL_AllSmallHeatSources.GetAt(iFormlistSize))
		EndWhile
	EndIf
	
	Return bIsFrostfallInstalled
EndFunction

Bool Function InstallFiresHurtPatch()

	If Game.GetModByName("abotFiresHurt.esp") != 255
	
		bIsFiresHurtInstalled = True
		
		Int iFormlistSize = REF_FRL_AllMediumHeatSources.GetSize()
		Formlist akTargetFormlist = Game.GetFormFromFile(8942, "abotFiresHurt.esp") As Formlist ;Medium Heat Sources formlist
			
		While iFormlistSize > 0
			
			iFormlistSize -= 1
			akTargetFormlist.AddForm(REF_FRL_AllMediumHeatSources.GetAt(iFormlistSize))
		EndWhile
			
		iFormlistSize = REF_FRL_AllSmallHeatSources.GetSize()
		akTargetFormlist = Game.GetFormFromFile(68305, "abotFiresHurt.esp") As Formlist ;Small Heat Sources formlist.
			
		While iFormlistSize > 0
			
			iFormlistSize -= 1
			akTargetFormlist.AddForm(REF_FRL_AllSmallHeatSources.GetAt(iFormlistSize))
		EndWhile
	EndIf
	
	Return bIsFiresHurtInstalled
EndFunction

Function RevertAppropriateFires()

	CheckFiresInList(REF_FRL_AllUnlitGiantCampfires, REF_FRL_TEMP_AllGiantFiresToRelight)
	CheckFiresInList(REF_FRL_AllUnlitCampfires, REF_FRL_TEMP_AllCampfiresToRelight)
	CheckFiresInList(REF_FRL_AllUnlitEmbers, REF_FRL_TEMP_AllEmbersToRelight)
	CheckFiresInList(REF_FRL_AllUnlitCandles, REF_FRL_TEMP_AllCandlesToRelight)
	CheckFiresInList(REF_FRL_AllUnlitTorches, REF_FRL_TEMP_AllTorchesToRelight)
EndFunction

Function CheckFiresInList(Formlist akSourceList, Formlist akTempList)

	Int iFormlistLength = akSourceList.GetSize()

	While iFormlistLength > 0
	
		iFormlistLength -= 1
		
		ObjectReference akFoundFire = akSourceList.GetAt(iFormlistLength) As ObjectReference

		if (akFoundFire != None)
		
			If akFoundFire.IsInInterior()
			
				If akFoundFire.GetEditorLocation() ;May be NONE

					If (akFoundFire.GetEditorLocation() != None)
				
						If akFoundFire.GetEditorLocation().IsCleared()
							
							If akFoundFire.IsEnabled()
							
								(akFoundFire As REF_LightFire).ReLight()
							EndIf
							
							akTempList.AddForm(akFoundFire)
						EndIf
					endif

				EndIf
			Else
			
				If akFoundFire.GetDistance(PlayerREF) > 15000

					if (akFoundFire.GetEditorLocation() != None)
				
						If akFoundFire.IsEnabled() && !akFoundFire.GetEditorLocation().IsCleared()
						
							(akFoundFire As REF_LightFire).ReLight()
						EndIf 
						
						akTempList.AddForm(akFoundFire)

					endif
				EndIf
			EndIf
		endif
	EndWhile
	
	iFormlistLength = akTempList.GetSize()
	
	While iFormlistLength > 0
	
		iFormlistLength -= 1
		akSourceList.RemoveAddedForm(akTempList.GetAt(iFormlistLength))
	EndWhile
	
	akTempList.Revert()
EndFunction