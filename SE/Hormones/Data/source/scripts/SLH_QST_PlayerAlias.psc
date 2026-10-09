Scriptname SLH_QST_PlayerAlias  extends ReferenceAlias  

SLH_QST_HormoneGrowth Property SLH_Control Auto
SLH_fctUtil Property fctUtil Auto

Keyword Property ArmorOn  Auto  
Keyword Property ClothingOn  Auto  

Event OnPlayerLoadGame()

	; Code moved to Maintenance function in SLH_QST_HormoneGrowth script
	
	;  fctUtil.bEstrusChaurus = false
	;  fctUtil.bBeeingFemale = false
	;  int idx = Game.GetModCount()
	;  string modName = ""
	;  while idx > 0
	;    idx -= 1
	;    modName = Game.GetModName(idx)
	;    if modName == "EstrusChaurus.esp"
	;      fctUtil.bEstrusChaurus = true
	;      fctUtil.ChaurusBreeder = Game.GetFormFromFile(0x00019121, modName) as spell
	;    elseif modName == "BeeingFemale.esm"
	;      fctUtil.bBeeingFemale = true
	;      fctUtil.BeeingFemalePregnancy = Game.GetFormFromFile(0x000028A0, modName) as spell
	;    endif
	;  endWhile
 

	; Test for XPMS node refresh event to trigger a refresh on load if XPMSE is detected and MCM setting enabled
	; XPMSE_MCMClose mod event - not working for force refresh of nodes scales
	; In XPMSEWeaponStyleScaleEffect, line 292: added CleanupAll() to force refresh of nodes scales on load with XPMSE_MCMClose mod event, but this is not ideal as it will cause a visual glitch on load.
	int handle = ModEvent.Create("XPMSE_MCMClose")
	if (handle)
		ModEvent.PushInt(handle, 1)
		ModEvent.Send(handle)
	endIf

	; Useless if SKSE patch for removal of cloaking spell with SPID is depployed 
	; int handle = ModEvent.Create("XPMSE_EnableCloak")
	; if (handle)
	; 	ModEvent.PushInt(handle, 1)
	; 	ModEvent.Send(handle)
	; endIf
	
	SLH_Control.Maintenance()

EndEvent
 