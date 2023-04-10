Scriptname LoversComfortUtilScr extends Quest

; vanilla
Actor Property PlayerRef Auto
GlobalVariable Property GameHour Auto
Faction Property currentFollowerFaction Auto
Faction Property dunPrisonerFaction Auto
Keyword Property pLocTypeHabitation Auto
Race Property MannequinRace Auto

; lovers comfort
Faction Property lcLoverFaction Auto
Faction Property lcSpecialFollowerFaction Auto
Faction Property ComfortFaction Auto
LoversComfortPlayerScr Property lcPlayerQuest Auto
LoversComfortConfigScr Property lcConfigQuest Auto
Faction Property lcSwinger Auto
LoversComfortSwingScr Property lcOldSwingScene Auto
LoversComfortSexSceneScr Property lcDefaultScene Auto
Armor Property swingRing Auto

; Valid Factions
FormList Property validFactions Auto

; SexLab Aroused
slaUtilScr Property slaUtil Auto
Faction Property sla_Aroused Auto

; SexLab
SexLabFramework property SexLab auto

; Possible Stuff From Other Mods
Keyword Property zbfWornCollar = None Auto Hidden
Bool Property SpousesEnhancedInstalled Auto Hidden
GlobalVariable Property _SE_EnableWakeUpAnimation Auto Hidden
Bool Property SexLabEagerNPCsInstalled Auto Hidden
;SLENMainController Property SLENMainControllerQuest Auto
Bool Property FISSInstalled Auto Hidden
Bool Property AAInstalled Auto Hidden

; DLC 
; Dragonborn
Bool Property DLC2Installed = False Auto Hidden
Quest Property DLC2SleepQuest = None Auto Hidden
Location Property DLC2SolstheimLCTN = None Auto Hidden
Keyword Property LocTypeHold Auto 

; Debug and Clean-Up
Package Property Avoid Auto
FormList Property SceneList Auto

; persistent variables
int modVersion

Event OnInit()
	Maintenance()
EndEvent

Function Maintenance()
	int newVersion = 20160116

	; Check Spouse's lover is OK
	Int loverValidity = IsValidActor(lcPlayerQuest.GetSpouseLover())
	If  loverValidity < -1 && loverValidity > -9
		Log(self,"Invalid Lover. Detected as " + invalidActorType(loverValidity))
		lcPlayerQuest.lcSpouseLoverRef.Clear()
	EndIf

	If lcOldSwingScene.IsRunning()
		Log(self,"Old Swing Quest Is Running")
	Else
		Log(self,"Old Swing Quest Is NOT Running")
	EndIf

	Log(self,"Current size of Scenes List: " + SceneList.GetSize() )

	; Upgrade Section
	If modVersion < 20151127 
		lcOldSwingScene.Stop()
		Log(self,"Stopped Old Swing Quest")
	EndIf

	If modVersion < 20151120
		lcDefaultScene.canIncludePlayer = true
	EndIf

	If modVersion < 20150406
		; This is mainly for me - shouldn't have happened to anyone else
		Log(self,"Scene: " + lcPlayerQuest.lcSwing.SlaveScene01)
		Scene properScene = Game.GetFormFromFile(0x0007D086, "LoversComfort.esp") As Scene
		lcPlayerQuest.lcSwing.SlaveScene01 = properScene
		Log(self,"Scene: " + lcPlayerQuest.lcSwing.SlaveScene01)
	EndIf

	If modVersion < 20150317
		lcConfigQuest.SpouseRapeThreshold = 80
		lcConfigQuest.FollowerThreeSomeThreshold = 30
		lcConfigQuest.OnSleepMasturbateThreshold = 90
		lcConfigQuest.FollowerComfortThreshold = 70
	EndIf

	If modVersion < 20150310
		lcConfigQuest.verboseLogs = false
		lcConfigQuest.SortBeforePairing = false
		lcConfigQuest.AllowSlaves = false
	EndIf

	if modVersion < 20140104
		lcConfigQuest.NPCComfortThreshold = 0
		lcConfigQuest.NPCMasturbateThreshold = 75
		lcConfigQuest.PlausibleMM = false
		lcConfigQuest.UseSexLab = false
	EndIf
	
	If modVersion < 20130824
		lcConfigQuest.SpouseArousalThreshold = 50
	EndIf
	
	If modVersion < 20131207
		lcPlayerQuest.lcSpouseLoverRef.Clear()
	EndIf
	
	If modVersion < newVersion
		Log(self,"Upgrading Further Lover's Comfort from " + modVersion)
		modVersion = newVersion
		Debug.Notification("Further Lover's Comfort upgrade: " + modVersion)
	EndIf
	
	Log(self,"Running Further Lover's Comfort " + GetVersion())
	Log(self,"Running Sexlab Aroused " + slaUtil.GetVersion() + "." + slaUtil.slaConfig.GetVersion())
	Log(self,"Running SexLab Framework " + SexLab.GetVersion())
	Log(self,"Player: " + Game.GetPlayer().GetDisplayName())
	Actor lcSpouse = lcPlayerQuest.GetSpouse()
	If lcSpouse != None
		Log(self,"Spouse: " + lcSpouse.GetDisplayName())
		Actor lcLover = lcPlayerQuest.GetSpouseLover()
		If lcLover != None
			Log(self,"Spouse's Lover: " + lcLover.GetDisplayName())
		Else
			Log(self,"Spouse not straying")
		EndIf
	Else
		Log(self,"Player is unmarried")
	EndIf

	; Soft checks
	; Zaz Animation Pack
	Int Zaz = Game.GetModByName("ZazAnimationPack.esm")
	If Zaz != 255
		Log(self, "ZazAnimationPack Installed")
		zbfWornCollar = (Game.GetFormFromFile(0x008A4E, "ZazAnimationPack.esm") as Keyword)
		Log(self, "Slave Collar Loaded - " + zbfWornCollar)
	EndIf

	; Spouse Enhanced - Wake Up Cuddle Will Clash
	Int SE = Game.GetModByName("SpousesEnhanced.esp")
	If SE != 255
		Log(self, "Spouses Enhanced Installed")
		_SE_EnableWakeUpAnimation = (Game.GetFormFromFile(0x004F2C, "SpousesEnhanced.esp") as GlobalVariable)
		Log(self, "Spouses Enhanced - Wake Up Setting: " + _SE_EnableWakeUpAnimation.GetValue())
		SpousesEnhancedInstalled = True
		If _SE_EnableWakeUpAnimation.GetValueInt() == 1
			Log(self,"Spouses Enhanced - Wake Up Cuddle is on. Disabling FLC Wake Up scene")
			lcConfigQuest.IsOnSleepSpouse = false
		EndIf
	Else 
		SpousesEnhancedInstalled = False
	EndIF

	; Sexlab Eager NPCs - Follower Wake-Up Will Clash
	Int SLEN = Game.GetModByName("SexLab Eager NPCs.esp")
	If (SLEN != 255)
		Log(self, "SexLab Eager NPCs Installed")
		SexLabEagerNPCsInstalled = True
		If (EagerNPCsChance() > 0)
			Log(self,"Spouses Enhanced - Wake Up Sex is possible. Disabling FLC Wake Up scene")
			lcConfigQuest.IsOnSleepSpouse = false
		EndIf
	Else
		SexLabEagerNPCsInstalled = False
	EndIf
	
	Int DLC2 = Game.GetModByName("Dragonborn.esm")
	DLC2Installed = false
	If (DLC2 != 255)
		Log(self, "Dragonborn DLC Installed")
		DLC2Installed = true
		DLC2SleepQuest = (Game.GetFormFromFile(0x01C4E4, "Dragonborn.esm") as Quest)
		DLC2SolstheimLCTN = (Game.GetFormFromFile(0x016E2A, "Dragonborn.esm") as Location)
	EndIf

	AAInstalled = false
	Int SLAA = Game.GetModByName("SexLab-AmorousAdventures.esp")
	If (SLAA != 255)
		Log(self,"Amorous Adventures Installed")
		AAInstalled = true
	EndIF

	FISSInstalled = false
	Int FISSid = Game.GetModByName("FISS.esp")
	If (FISSid != 255)
		Log(self,"FISS Esp detected")

		FISSInstalled = true
		FISSInterface FISS = FISSFactory.getFISS()
		If (FISS != None)
			Log(self,"FISS available")
			FISSInstalled = true
		EndIf
	EndIf

	checkForSleepBlockers(PlayerRef)

	;SexLab.Config.BedOffset[3] = 70

	lcPlayerQuest.Maintenance()
	lcConfigQuest.Maintenance()
EndFunction

Int Function EagerNPCsChance()
	SLENMainController SLENMainControllerQst = (Game.GetFormFromFile(0x000D62, "SexLab Eager NPCs.esp") as SLENMainController)
	Log(self, "SexLab Eager NPCs - Wake Up Sex Chance: " + SLENMainControllerQst.SleepEventChance)
	Return SLENMainControllerQst.SleepEventChance
EndFunction

Int Function GetVersion()
	return modVersion
EndFunction

; Carve the log
Function Log( String Mod, String Text, Bool toGame = false )
	If lcConfigQuest.verboseLogs
		Debug.Trace( Mod + ": " + Text)
		If toGame
			Debug.Notification( Text )
		EndIf
	EndIf
EndFunction

Function LogName( String Mod, Actor Aktor, String Text)
	;String akName = Aktor.GetDisplayName()
	String akName = "[None]"
	If Aktor != none
		akName = Aktor.GetDisplayName() + " (" + Aktor + ")"
	EndIf
	String newText = akName + " " + Text
	Log(Mod,newText)
EndFunction

Bool Function checkForSleepBlockers(Actor akRef)
	If (SpousesEnhancedInstalled)
		If _SE_EnableWakeUpAnimation.GetValueInt() == 1
			Log(self,"Spouses Enhanced - Wake Up Cuddle is on.")
			lcConfigQuest.IsOnSleepSpouse = false
			Return True
		EndIf
	EndIf
	
	If (SexLabEagerNPCsInstalled)
		If (EagerNPCsChance() > 0)
			Log(self,"Eager NPCs - Wake Up Sex is possible.")
			lcConfigQuest.IsOnSleepSpouse = false
			Return True
		EndIf
	EndIf
	
	If DLC2Installed
		Location pCurrent = akRef.getCurrentLocation()
		If (pCurrent!=none)
			Log(self, "current location is " + pCurrent.GetName())
			If (pCurrent.IsSameLocation(DLC2SolstheimLCTN, LocTypeHold)) 
				Log(self,"This is in Solstheim")
				If (DLC2SleepQuest.IsRunning())
					Log(self,"DLC2 Pillar Quest is still in progress")
					Return True
				EndIf
			Else
				Log(self,"This is not in Solstheim")
			EndIf
		Endif
	EndIf

	Return False
EndFunction

bool Function IsCurrentFollower(Actor akRef)
	If (akRef == None)
		return false
	EndIf
	
	If (akRef.GetFactionRank(currentFollowerFaction) >= 0 || akRef.GetFactionRank(lcSpecialFollowerFaction) >= 0 )
		return true
	EndIf
	
	return false
EndFunction

; Test if actor is real and valid
; Most tests moved to scanner now
Int Function IsValidActor(Actor akRef, Bool awakeOK = false, Bool slaveOK = false, Bool skipLoc = false)
	If (akRef == None)
		return -1
	ElseIf (akRef == PlayerRef)
		return -2
	ElseIf (akref.IsChild())
		return -3
	ElseIf (akRef.HasKeywordString("ActorTypeGhost"))
		return -4
	ElseIf (akRef.HasKeywordString("ActorTypeCreature"))
		return -5
	ElseIf (!akRef.HasKeywordString("ActorTypeNPC"))
		return -6
	ElseIf (SexLab.ValidateActor(akRef) < 1)
		return -7
	ElseIf (akRef.IsInFaction(dunPrisonerFaction))
		return -8
	ElseIf (akRef.IsInCombat())
		return -9
	ElseIf (akRef.IsInFaction(SexLab.AnimatingFaction))
		return -10
	ElseIf (akRef.IsInFaction(ComfortFaction))
		return -12
	ElseIf (!skipLoc && !IsInSameSettlement(Game.GetPlayer(),akRef,true))
		return -11
	ElseIf (!slaveOK && IsSlave(akRef))
		return -13
	ElseIf (!awakeOK && akRef.GetSleepState() != 3.0)
		return -14
	EndIf
	
	return 1
EndFunction

String Function invalidActorType(Int Code)
	String[] codeType = new String[15]
	codeType[0] = "N/A"
	codeType[1] = "No Ref"
	codeType[2] = "Player"
	codeType[3] = "Child"
	codeType[4] = "Ghost"
	codeType[5] = "Creature"
	codeType[6] = "Not Human"
	codeType[7] = "SexLab Invalid"
	codeType[8] = "Prisoner"
	codeType[9] = "N/A"
	codeType[10] = "Having Sex"
	codeType[11] = "Left"
	codeType[12] = "Comforting"
	codeType[13] = "Slave"
	codeType[14] = "Awake"

	Return codeType[(Math.Abs(Code) as Int)]
EndFunction


int Function GetSpouseLoverRank(Actor akRef)
	If (akRef == None)
		return -2
	EndIf
	
	Return akRef.GetFactionRank(lcLoverFaction)
EndFunction


int Function UpdateSpouseLoverRank(Actor akRef, int val)
	If (akRef == None)
		return -2
	EndIf
	
	int newVal = GetSpouseLoverRank(akRef) + val
	
	If (val < -7)
		newVal = -2
	ElseIf (newVal < 0)
		newVal = 0
	ElseIf (newVal > 5)
		newVal = 5
	EndIf
	
	akRef.SetFactionRank(lcLoverFaction, newVal)
	
	return newVal
EndFunction

; Get an actor's arousal, seeding if not set
Int Function GetActorArousal(Actor tmpAk)
	Int arousal = tmpAk.GetFactionRank(sla_Aroused)
	If arousal == -2
		; Might be unseeded
		arousal = slaUtil.GetActorArousal(tmpAk)
	EndIf
	Return arousal
EndFunction

; Depreciated - used to get last time actor had sex
Bool Function HasCoolDownTime(Actor akRef)
	Float fTimeStart = Utility.GetCurrentRealTime()
	Float tmpVal = slaUtil.GetActorDaysSinceLastSex(akRef)
	
	If (0.0 <= tmpVal && tmpVal <= 0.25)
		Log(self, "Successful HasCoolDownTime() took " + (Utility.GetCurrentRealTime() - fTimeStart) + " seconds")
		return true
	EndIf
	
	Log(self, "Unsuccessful HasCoolDownTime() took " + (Utility.GetCurrentRealTime() - fTimeStart) + " seconds")
	return false
EndFunction

; Are two actors in the same faction (from hardcoded formlist)
Bool Function SameValidFaction(Actor akOne, Actor akTwo)
	String akOneName = akOne.GetBaseObject().GetName()
	String akTwoName = akTwo.GetBaseObject().GetName()
	Log(self, "Valid Faction Check for " + akOneName + " and " + akTwoName)
	Int i = validFactions.GetSize()
	While i > 0
		i -= 1
		Faction testFaction = validFactions.GetAt(i) as Faction
		Log(self, "Faction Test on " + testFaction.GetName())
		Int akOneFac = akOne.GetFactionRank(testFaction)
		Int akTwoFac = akTwo.GetFactionRank(testFaction)
		Log(self, akOneName + " is rank " + akOneFac)
		Log(self, akTwoName + " is rank " + akTwoFac)
		If akOneFac >= 0 && akTwoFac >= 0
			Return True
		EndIf
	EndWhile
	Log(self, "No Faction Match")
	Return False
EndFunction

ObjectReference Function FindClosestObjectOfType(ObjectReference arCenter, int formTypeFilter)
	If (arCenter == None)
		return None
	EndIf
	
	Cell currentCell = PlayerRef.GetParentCell()
	int itemCount = currentCell.GetNumRefs(formTypeFilter)
	ObjectReference bestRef = None
	
	If (itemCount > 0)
		bestRef = currentCell.GetNthRef(0, formTypeFilter)
	Else
		return None
	EndIf
	
	int i = 1
	While (i < itemCount)
		i += 1
		ObjectReference tmpRef = currentCell.GetNthRef(i, formTypeFilter)
		If arCenter.GetDistance(tmpRef) < arCenter.GetDistance(bestRef)
			bestRef = tmpRef
		EndIf
	EndWhile
	
	return bestRef
EndFunction

; Are two actors in the same location
Bool Function IsInSameSettlement(Actor ak1, Actor ak2, Bool cellOnly = false)
	If (ak1 == None || ak2 == None)
		Return False
	EndIf
	Log(self,"IsInSameSettlement: " + ak1.GetDisplayName() + " and " + ak2.GetDisplayName())

	Location ak1Loc = ak1.getCurrentLocation()
	Location ak2Loc = ak2.getCurrentLocation()

	If (ak1Loc == None || ak2Loc == None) 
		If (ak1Loc == None)
			Log(self, ak1.GetDisplayName() + " in a None location")
		EndIf
		If (ak2Loc == None)
			Log(self, ak2.GetDisplayName() + " in a None location")
		EndIf
		Return False
	EndIf

	Log(self,ak1.GetDisplayName() + " is in location " + ak1Loc.GetName() )
	Log(self,ak2.GetDisplayName() + " is in location " + ak2Loc.GetName() )

	Bool samePlace = false;
	If cellOnly
		samePlace = ak1Loc.IsSameLocation(ak2Loc)
	Else 
		samePlace = ak1Loc.IsSameLocation(ak2Loc, pLocTypeHabitation)
	EndIf

	Log(self,"Location Match? " + samePlace )
	
	Return samePlace
EndFunction

; Add an actor to a formlist, sorted if required
Int Function PushActor(Actor akRef, FormList actorList)
	If akRef != None
		; Is already in formlist?
		If !actorList.HasForm(akRef)
			If lcConfigQuest.SortBeforePairing
				AddSorted(actorList,akRef)
			Else
				actorList.AddForm(akRef)
			EndIf
		EndIf 
	EndIf
	Return actorList.GetSize()
EndFunction

; check if an actor has a ZAP collar
Bool Function IsSlave(Actor akRef)
	If lcConfigQuest.AllowSlaves
		If zbfWornCollar != None
			Return akRef.WornHasKeyword(zbfWornCollar)
		EndIf
	EndIf
	Return False
EndFunction

; add to FormList with sorting by arousal
Function AddSorted(FormList listToAddTo, Actor actorRef)
	If listToAddTo.GetSize() < 1
		Log(self, "FormList is empty. Adding " + actorRef.GetDisplayName())
		listToAddTo.AddForm(actorRef)
	Else 
		Log(self, "FormList size is " + listToAddTo.GetSize())
		Actor[] tempList = new Actor[24]
		Int i = 0
		Int j = 0
		Bool yetAdded = False
		While i < listToAddTo.GetSize()
			Actor existingActor = (listToAddTo.GetAt(i) as Actor)
			Int existingActorArousal = GetActorArousal(existingActor)
			Int comparedActorArousal = GetActorArousal(actorRef)
			Log(self, "Existing Actor " + existingActor.GetDisplayName() + " at " + i + " - arousal: " + existingActorArousal)
			If existingActorArousal < comparedActorArousal && !yetAdded
				Log(self, "Adding new Actor " + actorRef.GetDisplayName() + " at " + i + " - arousal: " + comparedActorArousal)
				tempList[j] = actorRef
				j += 1
				yetAdded = True
			EndIf
			tempList[j] = existingActor
			i += 1
			j += 1
		EndWhile

		If !yetAdded
			; Wasn't added - arousal less than everyone else
			tempList[j] = actorRef
		EndIf
		Log(self, "tempList size is " + j)

		; clear original list
		listToAddTo.Revert()

		i = 0
		While tempList[i] != None
			listToAddTo.AddForm((tempList[i] as Actor))
			Log(self,"Copying " + (tempList[i] as Actor).GetDisplayName() + " to FormList from pos " + i)
			i += 1
		EndWhile
		Log(self, "FormList size is now " + listToAddTo.GetSize())
	EndIf
EndFunction

Function ClearAllAIPackages()
	Int removedFrom = ActorUtil.RemoveAllPackageOverride(Avoid)
	Log(self,"Removed Avoid package from " + removedFrom + " actors")
EndFunction

Function updateSwinging( Actor ak1, Actor ak2 )
	; Have they had sex before?
	Int upRank = 1
	If StorageUtil.FormListFind(ak1,"00_LC_PreviousLovers",ak2) >= 0
		Log(self, "Old Lovers " + ak1.GetDisplayName() + " and " + ak2.GetDisplayName() )
		upRank = 2
	Else
		Log(self, "Adding New Lovers " + ak1.GetDisplayName() + " and " + ak2.GetDisplayName() )
		StorageUtil.FormListAdd(ak1,"00_LC_PreviousLovers",ak2)
		StorageUtil.FormListAdd(ak2,"00_LC_PreviousLovers",ak1)
	EndIf

	StorageUtil.SetFormValue(ak1,"00_LC_LastLover",ak2)
	StorageUtil.SetFormValue(ak2,"00_LC_LastLover",ak1)

	upSwingRank(ak1,upRank)
	upSwingRank(ak2,upRank)
EndFunction

Function upSwingRank(Actor ak, Int upRank)
	Int sw = ak.GetFactionRank(lcSwinger)

	If sw > -1 
		sw += upRank
		ak.SetFactionRank(lcSwinger, sw)
		Log(self, "Increasing swing rank of " + ak.GetDisplayName() + " by " + upRank + " to " + sw)
		If upRank > 1
			Log(self,"Adding swinger ring to " + ak.GetDisplayName())
			ak.AddItem(swingRing,1,true)
			ak.EquipItem(swingRing, true, true)
		EndIf
	Else
		Log(self, "Setting swing rank of " + ak.GetDisplayName() + " 0")
		ak.SetFactionRank(lcSwinger, 0)
	EndIf
EndFunction

Actor Function lastLover(Actor ak)
	Return (StorageUtil.GetFormValue(ak,"00_LC_LastLover") as Actor)
EndFunction

Function removeSwingRing(Actor akActor, Bool alsoPartner = false)
	If (akActor == None)
		Log(self,"Remove Swing Ring passed no actor")
		Return
	EndIf

	Log(self,"Removing Swing Ring from " + akActor.GetDisplayName())
	If (akActor.IsEquipped(swingRing))
		akActor.UnequipItem(swingRing, abSilent = true)
		akActor.RemoveItem(swingRing, 1, true)
	EndIf
	If (akActor.IsEquipped(swingRing))
		Log(self,"Error: Swing Ring not removed")
	EndIf

	If (alsoPartner)
		removeSwingRing(lastLover(akActor))
	EndIf
EndFunction