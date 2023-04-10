Scriptname LoversComfortPlayerScr extends Quest  

; lovers comfort
LoversComfortUtilScr Property lcUtil Auto
LoversComfortConfigScr Property lcConfigQuest Auto
LoversComfortSwingScr Property lcSwing Auto
LoversComfortSpouseScr Property lcSpouseRef Auto
ReferenceAlias Property lcSpouseLoverRef Auto
; Valid scans for all including awake
Quest Property lcScanValid Auto

; Scenes
FormList Property lcScenes Auto

Actor[] Property lcCurrentFollowers Auto
Faction Property lcPartyReady Auto
Faction Property lcBedOwner Auto
Faction Property lcSwingReady Auto

int Property lcValidActorsInCell Auto

; SexLab
SexLabFramework Property SexLab Auto
Static Property SexLabLocationMarker Auto

; vanilla
Actor Property PlayerRef Auto
ReferenceAlias Property LoveInterest Auto
Quest Property RelationshipMarriageFIN Auto

; Aroused Scan - Not Used Any More
Quest Property slaScanAll Auto Hidden

AssociationType Property SpouseAssociation Auto
AssociationType Property SiblingsAssociation Auto
AssociationType Property CousinsAssociation Auto
AssociationType Property CourtingAssociation Auto
AssociationType Property JarlAssociation Auto

; constants
int kNPC = 43

; callback functions
String lcStageStartStr = "OnStageStart"
String lcAnimationEndStr = "OnAnimationEnd"

; thread lock
bool IsScanLocked = false

; misc variables
Cell startScanCell = None
int hostileActorsInCell = 0
Float searchRadius = 2500.0

; Valid Actors
FormList Property availableActors Auto
FormList Property validActors Auto
FormList Property slaveActors Auto

; Bed stuff
ObjectReference BedUsed
FormList Property havingSex Auto

; Scene handling
Int actorsPassedToScene = 0 

; Swing participants
Actor[] couple1 
Actor[] couple2 

Event OnInit()
	; do nothing
EndEvent


Function Maintenance()
	RegisterForSleep()
	RegisterForSingleUpdateGameTime(1)
	
	UnregisterForAllModEvents()
	RegisterForModEvent("AnimationEnd", lcAnimationEndStr)
		
	UpdateSpouse()
	
	IsScanLocked = false
EndFunction


Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	; NO LONGER USED - MOVED TO OnSleepStop
	;If lcUtil.checkForSleepBlockers(PlayerRef)
	;	lcUtil.Log(self, "Not triggering followers because of above reason")
	;	return
	;EndIf

	;lcUtil.Log(self, "OnSleepStart")
	;ComfortFollowers()
endEvent


Event OnSleepStop(bool abInterrupted)
	If (abInterrupted)
		lcUtil.Log(self, "Player sleep was interrupted, not triggering animations")
		return
	EndIf

	If lcUtil.checkForSleepBlockers(PlayerRef)
		lcUtil.Log(self, "Not triggering wake-up because of above reason")
		return
	EndIf

	; If our spouse is around, we may want to have a wake-up bonk (or a bit of self-love)
	lcUtil.Log(self, "OnSleepStop")

	if (Utility.RandomInt(0,100)>70)	
		; Load up a small 2-person array
		Actor[] acList = new Actor[2]
		acList[0] = PlayerRef
		acList[1] = None
		Actor Victim = None
		
		; make sure we are married, our spouse is nearby and not already fucking
		UpdateSpouse()
		Actor akSpouse = GetSpouse()

		If (akSpouse != None) 
			If (PlayerRef.GetCurrentLocation() == akSpouse.GetCurrentLocation() &&  !akSpouse.IsInFaction(SexLab.AnimatingFaction))
				lcUtil.Log(self, "Spouse is nearby")
				If (lcConfigQuest.IsOnSleepSpouse && lcUtil.GetActorArousal(akSpouse) > lcConfigQuest.SpouseRapeThreshold)
					; Spouse is so aroused, they rape the player
					; Maybe remove mechanic altogether?
					lcUtil.Log(self, "Spouse arousal is too damn high!")
					acList[1] = akSpouse
					Victim = PlayerRef
				ElseIf (lcConfigQuest.IsOnSleepSpouse)
					; Good clean married sex
					lcUtil.Log(self, "Wake up sex with spouse!")
					acList[1] = akSpouse
				EndIf
			EndIf
		EndIf

		Bool dontIncludePlayer = false
		int DN_ONOFF = StorageUtil.GetIntValue(none, "DN_ONOFF")
		If (acList[1] != None)
			; Sex with spouse via MakeLove
			dontIncludePlayer = true
			MakeLove(acList, akVictim = Victim, center = Game.GetPlayer() as ObjectReference)
		ElseIf (lcUtil.GetActorArousal(PlayerRef) > lcConfigQuest.OnSleepMasturbateThreshold && (lcConfigQuest.IsOnSleepMastrubate) || (DN_ONOFF==0))
			; Forever alone
			lcUtil.Log(self, "Spouse isn't around. Time for a wank!")
			acList = new Actor[1]
			acList[0] = PlayerRef
			dontIncludePlayer = true
			MakeLove(acList, akVictim = none, center = Game.GetPlayer() as ObjectReference)
		EndIf
		ComfortFollowers(dontIncludePlayer)
	endif
EndEvent


Event OnUpdate() 
	lcUtil.Log(self, "OnUpdate" )
	ScanCurrentCell()
EndEvent


Event OnUpdateGameTime()
	lcUtil.Log(self, "OnUpdateGameTime" )
	RegisterForSingleUpdateGameTime(1)
	RegisterForSingleUpdate(1.0)
EndEvent


Event OnAnimationEnd(string eventName, string argString, float argNum, form sender)	
	Actor[] actorList = SexLab.HookActors(argString)

	If (actorList.length < 1)
		return
	EndIf
				
	int playerPosition = actorList.Find(PlayerRef)
	int spousePosition = actorList.Find(GetSpouse())
	Actor spouse = GetSpouse()
		
	If (playerPosition >= 0 && spousePosition < 0 && spouse != None)
		lcUtil.slaUtil.UpdateActorExposure(spouse, 2, "Player cheating")
	EndIf
EndEvent


Function SetSelectedFollower(Actor akRef)
	If (akRef == None)
		return
	EndIf
		
	Actor[] tmpList = new Actor[2]
	tmpList[0] = PlayerRef
	tmpList[1] = akRef
	
	MakeLove(tmpList)
EndFunction


bool Function IsPartyReady(Actor akRef)	
	Actor[] tmpList = GetPartyActors(akRef)
	
	If (tmpList.length == 3)
		akRef.SetFactionRank(lcPartyReady, 0)
		return true
	EndIf
	
	akRef.SetFactionRank(lcPartyReady, -2)
	return false
EndFunction


Function StartParty(Actor akRef)
	If (akRef == None)
		return
	EndIf
	
	Actor[] tmpList = GetPartyActors(akRef)
	If (tmpList.length == 3)
		MakeLove(tmpList)
	EndIf
	
	akRef.SetFactionRank(lcPartyReady, -2)
EndFunction


Actor[] Function GetPartyActors(Actor akRef)
	Actor[] tmpList
	
	If (akRef == None)
		return tmpList
	EndIf
	
	tmpList = new Actor[2]
	tmpList[0] = PlayerRef
	tmpList[1] = akRef
	
	Actor ak2 = GetSpouse()
	If (ak2 != None)
		If (akRef != ak2 && PlayerRef.GetParentCell() == ak2.GetParentCell())
			tmpList = sslUtility.PushActor(ak2, tmpList)
		EndIf
	EndIf
	
	int i = 0
	While (i < lcCurrentFollowers.length && tmpList.length < 3)
		ak2 = lcCurrentFollowers[i]
		If (lcUtil.GetActorArousal(ak2) > lcConfigQuest.gFollowerThreeSomeThreshold.GetValue() && PlayerRef.GetParentCell() == ak2.GetParentCell() && ak2 != akRef)
			tmpList = sslUtility.PushActor(ak2, tmpList)
		EndIf
		i += 1
	EndWhile
	
	return tmpList
EndFunction


Actor Function GetSpouse()
	return lcSpouseRef.GetActorReference()
EndFunction


Function SetSpouse(Actor akRef)
	If (akRef != None && lcSpouseRef.GetActorReference() != akRef)
		lcSpouseRef.ForceRefTo(akRef)
	EndIf
EndFunction


Function UpdateSpouse()
	If (RelationshipMarriageFIN.IsRunning() == True && RelationshipMarriageFIN.GetStage() >= 10 && LoveInterest.GetActorRef() != None)
		SetSpouse(LoveInterest.GetActorRef())
	EndIf
EndFunction


Actor Function GetSpouseLover()
	return lcSpouseLoverRef.GetActorReference()
EndFunction


Function SetSpouseLover(Actor akRef)
	If (akRef != None && lcSpouseLoverRef.GetActorReference() != akRef)
		lcSpouseLoverRef.ForceRefTo(akRef)
	EndIf
EndFunction


ObjectReference Function FindBestCenter(Actor[] sexActors)
	ObjectReference res = None
	
	If (sexActors.Find(GetSpouse()) >= 0 && sexActors.Find(GetSpouseLover()) >= 0)
		res = Game.FindClosestReferenceOfTypeFromRef(SexLabLocationMarker, sexActors[0], searchRadius)
		If (res == None)
			res = Game.FindClosestReferenceOfTypeFromRef(SexLabLocationMarker, sexActors[1], searchRadius)
		EndIf
	ElseIf sexActors.Find(PlayerRef) >= 0 ; Player Involved without Spouse
		lcUtil.Log(self, "Finding Any Unused Bed" )
		res = FindNearestBed( sexActors, true ) ; find unused bed
	Else ; No player nor spouse
		lcUtil.Log(self, "Finding Any Nearby Bed" )
		res = FindNearestBed( sexActors, false ); find any bed
	EndIf

	Return res
EndFunction

; Find a bed nearest to one or more of the parties involved
; set AnyBed to true to find beds currently in use (since it runs when NPC is asleep)
; set AnyActor to false to stop after the first actor in range of a bed
ObjectReference Function FindNearestBed(Actor[] sexActors, Bool AnyBed = false, Bool AnyActor = true, ObjectReference ignoreBed = None)

	Int i = 0
	ObjectReference Bed = None
	ObjectReference NearestBed = None
	Float NearDistance = -1.0

	Return None ; This should be replaced by SexLab's setting to ignore beds or not


	While i < sexActors.Length
		Bed = SexLab.FindBed( (sexActors[i] as ObjectReference), Radius = searchRadius, IgnoreUsed = AnyBed, ignoreRef1 = ignoreBed )
		lcUtil.Log(self, "Bed Search in " + searchRadius + " range of " + sexActors[i].GetDisplayName())
		If Bed != None
			If SexLab.IsBedAvailable(Bed)
				lcUtil.Log(self, "Found Unused Bed " + Bed + " distance "+sexActors[i].GetDistance(Bed)+" from "+ sexActors[i].GetDisplayName())
			Else
				lcUtil.Log(self, "Found Used Bed " + Bed + " distance "+sexActors[i].GetDistance(Bed)+" from "+ sexActors[i].GetDisplayName())
			EndIf
			If NearestBed == None
				NearestBed = Bed
				NearDistance = sexActors[i].GetDistance(NearestBed)
			ElseIf sexActors[i].GetDistance(Bed) < NearDistance
				lcUtil.Log(self, "Replacing Existing Nearest Bed" )
				NearestBed = Bed
				NearDistance = sexActors[i].GetDistance(NearestBed)
			EndIf
		EndIf
		i += 1
		If !AnyActor && NearestBed != None
			i = sexActors.Length
		EndIf
	EndWhile


	If NearestBed != None
		Return NearestBed
	EndIf
	Return Bed
EndFunction

Function StartSex(Actor[] sexActors, Actor AkVictim = none, ObjectReference center = none, String sexhook = "")
	Int actorCount = sexActors.length
	lcUtil.Log(self,"StartSex Called - passed " + actorCount + " actors for hook " + sexhook)
	If !actorCount
		lcUtil.Log(self,"Not enough actors for a scene")
		Return
	EndIf

	If (actorCount < actorsPassedToScene)
		; we lost someone... 
		lcUtil.Log(self,(actorsPassedToScene-actorCount) + " actors removed by scene")
	EndIf

	sexActors = SortActors(sexActors, AkVictim)
			
	sslBaseAnimation[] animations = SelectAnimation(sexActors, AkVictim)
	
	If (animations.length < 1)
		lcUtil.Log(self, "StartSex, Error unable to select animations")
		return
	EndIf

	If center == None
		center = FindBestCenter(sexActors)
	EndIf

	lcUtil.Log(self,"About to call SexLab")
	int id = SexLab.StartSex(sexActors, animations, victim=AkVictim, centerOn=center, hook=sexhook)
	If id < 0
		Debug.Notification("SexLab animation failed to start [" + id + "]")
		lcUtil.Log(self, "SexLab animation failed to start [" + id + "]")
	EndIf
EndFunction

Function MakeLove(Actor[] sexActors, Actor AkVictim = None, ObjectReference center = None)
	int actorCount = sexActors.length
		
	int i = 0
	While i < actorCount
		If (sexActors[i] == None)
			lcUtil.Log(self, "MakeLove, Error NONE actor")
			return
		ElseIf (sexActors[i].IsChild())
			return
		EndIf
		
		lcUtil.Log(self, "MakeLove participant: " + sexActors[i].GetDisplayName())
		havingSex.AddForm(sexActors[i])
		
		i += 1
	EndWhile
									
	If center == None
		center = FindBestCenter(sexActors)
	EndIf
	lcUtil.Log(self, "Making Love on a " + center)
	
	Quest sexScene = chooseScene(sexActors,AkVictim)
	If sexScene
		lcUtil.Log(self,"Attempting to start sexScene " + sexScene)
		If (sexScene as LoversComfortSexSceneScr).loadToScene(sexActors, center, AkVictim)
			lcUtil.Log(self, "Aliases loaded OK")
			actorsPassedToScene = actorCount
			If (!(sexScene as LoversComfortSexSceneScr).sceneStart())
				lcUtil.Log(self,"No scene found - straight to sex then")
				selectAnimsAndGo(sexActors,AkVictim,center)
			EndIf
		Else
			lcUtil.Log(self, "Alias fill failed")
		EndIf
	Else
		lcUtil.Log(self, "No scenes available - start sex anyway")
		selectAnimsAndGo(sexActors,AkVictim,center)
	EndIf
EndFunction

Function selectAnimsAndGo(Actor[] sexActors, Actor AkVictim = none, ObjectReference center = None)
	sexActors = SortActors(sexActors, AkVictim)
			
	sslBaseAnimation[] animations = SelectAnimation(sexActors, AkVictim)
	
	If (animations.length < 1)
		lcUtil.Log(self, "selectAnimsAndGo, Error unable to select animations")
		return
	EndIf

	StartSex(sexActors,AkVictim,center)
EndFunction

Quest Function chooseScene(Actor[] sexActors, Actor AkVictim = none)
	Int tQuests = lcScenes.GetSize()
	lcUtil.Log(self, tQuests + " possible scenes")
	While tQuests > 0
		tQuests = tQuests - 1
		lcUtil.Log(self, "Checking " + tQuests)
		Quest sexScene = lcScenes.GetAt(tQuests) as Quest
		If sexScene.IsRunning() == false
			lcUtil.Log(self, "Found a possible scene " + sexScene)
			If (sexScene as LoversComfortSexSceneScr).canScenesBeUsed(sexActors,AkVictim)
				return sexScene
			EndIf
		EndIf
	EndWhile
	return none
EndFunction

Actor[] Function SortActors(Actor[] actorList, Actor akVictim)
	actorList = SexLab.SortActors(actorList)

	If AkVictim != None
		If lcConfigQuest.IsRapeMaleAnim
			int i = 0
			While i < actorList.length
				If (actorList[i] == AkVictim)
					actorList[i] = actorList[0]
					actorList[0] = AkVictim
					return actorList
				EndIf
				i += 1
			EndWhile
		EndIf
	EndIf
	
	return actorList
EndFUnction


sslBaseAnimation[] Function SelectAnimation(Actor[] sexActors, Actor vicAk)
	int maleCount = 0
	int femaleCount = 0
	
	int i = 0
	While i < sexActors.length
		If (sexActors[i].GetLeveledActorBase().GetSex() == 0)
			maleCount += 1
		Else
			femaleCount += 1
		EndIf
		i += 1
	EndWhile
	
	sslBaseAnimation[] animations
	
	; masturbation
	If (sexActors.length == 1)
		If (maleCount == 1)
			animations = SexLab.GetAnimationsByTag(1, "Masturbation", "M")
		Else
			animations = SexLab.GetAnimationsByTag(1, "Masturbation", "F")
		EndIf
	EndIf

	If ( lcConfigQuest.PlausibleMM && maleCount > 1 && femaleCount == 0  && animations.length < 1 )
		animations = SexLab.GetAnimationsByTags( maleCount, "Anal,Handjob,Blowjob,Fisting", TagSuppress = "Vaginal,Breast", RequireAll = False )
	EndIf
	
	If (!(lcConfigQuest.IsFFuseFM && maleCount == 0) && animations.length < 1)
		animations = SexLab.GetAnimationsByType(sexActors.length, males = maleCount, females = femaleCount, aggressive = (vicAk != None), sexual = true)
	EndIf
	
	If (animations.length < 1)
		animations = SexLab.GetAnimationsByType(sexActors.length, males = -1, females = -1, aggressive = (vicAk != None), sexual = true)
	EndIf

	If (animations.length < 1)
		animations = SexLab.GetAnimationsByType(sexActors.length, males = -1, females = -1, aggressive = false, sexual = true)
	EndIf
	
	return animations
EndFunction


Function ScanCurrentCell()
	Actor akSpouse = GetSpouse()
	
	; Check for cases where we won't scan
	If (IsScanLocked)
		lcUtil.Log(self, "ScanCurrentCell is locked")
		return
	ElseIf (PlayerRef.IsInCombat())
		lcUtil.Log(self, "ScanCurrentCell is skipped - player in combat")
		return
	ElseIf (PlayerRef.GetParentCell().IsInterior() == false && akSpouse == None)
		lcUtil.Log(self, "ScanCurrentCell is skipped - exterior cell, no spouse")
		return
	ElseIf (PlayerRef.GetParentCell().IsInterior() == false && akSpouse != None)
		If !(PlayerRef.getCurrentLocation() == akSpouse.getCurrentLocation() && !lcUtil.IsCurrentFollower(akSpouse))
			lcUtil.Log(self, "ScanCurrentCell is skipped - exterior cell, no spouse in location")
			return
		EndIf
	EndIf
	
	; Start scanning
	IsScanLocked = true	
	startScanCell = PlayerRef.GetParentCell()
	lcUtil.Log(self, "ScanCurrentCell started in " + startScanCell.GetName(), true)

	Float ftimeStart = Utility.GetCurrentRealTime()
	; Scan for all actors that might be horny
	; Fills three FormLists: All, Asleep and Slaves
	Int validActorsFound = DoFirstScan()
	Float fTimeNow = Utility.GetCurrentRealTime()
	lcUtil.Log(self, validActorsFound + " DoFirstScan() Complete after " + (fTimeNow - ftimeStart) + " seconds")
	; validActors are asleep
	DoSecondScan(validActors)
	fTimeNow = Utility.GetCurrentRealTime()
	lcUtil.Log(self, "DoSecondScan() Complete after " + (fTimeNow - ftimeStart) + " seconds")
	; any remaining actors, check for slaves
	UseSlaveForComfort(validActors,slaveActors)
	fTimeNow = Utility.GetCurrentRealTime()
	lcUtil.Log(self, "UseSlaveForComfort() Complete after " + (fTimeNow - ftimeStart) + " seconds")
	; finally, check anyone aroused enough for a wank
	ComfortLoneNPCs(validActors)
	fTimeNow = Utility.GetCurrentRealTime()
	lcUtil.Log(self, "ComfortLoneNPCs() Complete after " + (fTimeNow - ftimeStart) + " seconds")
	
	; If player has a spouse, and they're in the same location, see if they'll stray
	If (akSpouse != None)
		If (PlayerRef.getCurrentLocation() == akSpouse.getCurrentLocation())
			lcSpouseRef.DoLoversScan(validActors)
			fTimeNow = Utility.GetCurrentRealTime()
			lcUtil.Log(self, "DoLoversScan() Complete after " + (fTimeNow - ftimeStart) + " seconds")
		EndIf
	EndIf
	
	float ftimeEnd = Utility.GetCurrentRealTime()
	lcUtil.Log(self, "ScanCurrentCell finished after " + (ftimeEnd - ftimeStart) + " seconds in " + startScanCell.GetName(), true)

	startScanCell = None
	IsScanLocked = false
EndFunction


Int Function DoFirstScan()
	Float fTimeStart = Utility.GetCurrentRealTime()
	lcUtil.Log(self, "DoFirstScan() Starting")

	; Clear Form List
	Float tScanAll = Utility.GetCurrentRealTime()
	LoversComfortScanAllScript scanner = (lcScanValid as LoversComfortScanAllScript)
	availableActors.Revert()
	validActors.Revert()
	slaveActors.Revert()
	; Scan
	Int allAvailale = scanner.getArousedActors()
	Float tScanDone = Utility.GetCurrentRealTime()
	lcUtil.Log(self, allAvailale + " Scan For All Complete after " + (tScanDone - tScanAll) + " seconds")
	float fTimeNow = Utility.GetCurrentRealTime()

	Actor[] tmpCurrentFollowers 
	
	; No longer using this
	;lhostileActorsInCell = 0
		
	float fTimeBeforeLoop = Utility.GetCurrentRealTime()
	; validActors are those that are asleep
	int NPCcount = validActors.GetSize()
	lcUtil.Log(self, NPCcount + " sleeping actors to check")
	int i = 0
	While (i < NPCcount)
		Actor tmpAk = validActors.GetAt(i) as Actor
		String akName = tmpAk.GetDisplayName()

		lcUtil.Log(self, "Checking "+(i+1)+"/"+NPCcount+": "+akName)

		fTimeNow = Utility.GetCurrentRealTime()
		; Need to check some other stuff though
		; eg filter slaves, already in a scene
		int akRes = lcUtil.IsValidActor(tmpAk)

		If akRes >= 0
			; If they're valid, check they're aroused enough
			lcUtil.Log(self, "IsValidActor(" + akName + ") = VALID took " + (Utility.GetCurrentRealTime() - fTimeNow) + " seconds")
			fTimeNow = Utility.GetCurrentRealTime()
			Int akArousal = lcUtil.GetActorArousal(tmpAk)
			lcUtil.Log(self, "Arousal Check took " + (Utility.GetCurrentRealTime() - fTimeNow) + " seconds")
			lcUtil.Log(self, "Scan " + akName + " arousal: " + akArousal + " vs " + lcConfigQuest.NPCComfortThreshold )
			If akArousal < lcConfigQuest.NPCComfortThreshold 
				lcUtil.Log(self, akName + " not available due to low arousal")
				validActors.RemoveAddedForm(tmpAk)
				NPCcount -= 1
				i -= 1
			EndIf
		ElseIf akRes < -1
			lcUtil.Log(self, "IsValidActor(" + akName + ") = " + akRes + " took " + (Utility.GetCurrentRealTime() - fTimeNow) + " seconds")
		Else
			lcUtil.Log(self, "IsValidActor() was passed a None object!")
		EndIf
		
		i += 1
	EndWhile

	lcUtil.Log(self,"Checking Followers")
	fTimeNow = Utility.GetCurrentRealTime()
	int followerCount = availableActors.GetSize()
	i = 0
	While (i < followerCount)
		Actor tmpAk = availableActors.GetAt(i) as Actor
		lcUtil.Log(self,"FollowCheck on " + tmpAk.GetDisplayName())
		; Add followers to array
		If (lcUtil.IsCurrentFollower(tmpAk))
			lcUtil.LogName(self, tmpAk, "added as a follower")
			tmpCurrentFollowers = sslUtility.PushActor(tmpAk, tmpCurrentFollowers)
		EndIf
		i += 1
	EndWhile
	lcUtil.Log(self, "Add Current Followers took " + (Utility.GetCurrentRealTime() - fTimeNow) + " seconds")

	lcUtil.Log(self, followerCount + " NPCs (" + NPCcount + " available) scanned took " + (Utility.GetCurrentRealTime() - fTimeBeforeLoop) + " seconds")

	; Count valid sleeping actors remaining
	lcValidActorsInCell = validActors.GetSize()

	; Store followers in global array
	If (startScanCell == PlayerRef.GetParentCell())
		lcCurrentFollowers = tmpCurrentFollowers
	EndIf

	lcUtil.Log(self, "DoFirstScan() took " + (Utility.GetCurrentRealTime() - fTimeStart) + " seconds")
	return lcValidActorsInCell
EndFunction

; Scan all possible combinations until we find one that works
Function DoSecondScan(FormList validActorList)
	int i = 0
	While (i < validActorList.GetSize() && startScanCell == PlayerRef.GetParentCell())
		Actor tmpAk1 = (validActorList.GetAt(i) as Actor)
		
		int j = i+1
		While (j < validActorList.GetSize())
			Actor tmpAk2 = (validActorList.GetAt(j) as Actor)
			If (ComfortNPC(tmpAk1, tmpAk2))
				lcUtil.Log(self, "Before Removal validActorList Size is "+validActorList.GetSize())
				validActorList.RemoveAddedForm(tmpAk1)
				validActorList.RemoveAddedForm(tmpAk2)
				lcUtil.Log(self, "After Removal validActorList Size is "+validActorList.GetSize())
				return
			EndIf
			j += 1
		EndWhile
		
		i += 1
	EndWhile
EndFunction

; See if two non-slave NPCs can sex
bool Function ComfortNPC(Actor akRef, Actor tmpAk)
	If (akRef == None || tmpAk == None)
		return false
	EndIf

	lcUtil.Log(self, "Can " + tmpAk.GetBaseObject().GetName() + " comfort " + akRef.GetBaseObject().GetName() + "?" )
		
	; Are our NPCs related enough to screw
	bool comfortFlag = AreNPCRelated(akRef, tmpAk)

	; Get our two NPC's sexuality
	Bool akRefSex = akRef.GetLeveledActorBase().GetSex()
	Int  akRefSexuality = SexLab.Stats.GetSexuality(akRef)
	Bool tmpAkSex = tmpAk.GetLeveledActorBase().GetSex()
	Int  tmpAkSexuality = SexLab.Stats.GetSexuality(tmpAk)

	lcUtil.Log(self, akRef.GetBaseObject().GetName() + " Sex " + akRefSex + " Score " + akRefSexuality )
	lcUtil.Log(self, tmpAk.GetBaseObject().GetName() + " Sex " + tmpAkSex + " Score " + tmpAkSexuality )

	; If they can screw, are they both awake?
	If (comfortFlag)
		Int akRefSleep = akRef.GetSleepState()
		Int tmpAkSleep = tmpAk.GetSleepState()

		If (akRefSleep != 3 && tmpAkSleep != 3)
			; Both NPCs awake
			lcUtil.Log(self, "Comfort Failed: Neither party is asleep" )
			comfortFlag = false
		EndIf
	EndIf

	; can screw and at least one is asleep...
	If (comfortFlag && lcConfigQuest.UseSexLab)
		; Check homo/hetero via SexLab
		lcUtil.Log(self, "Checking SexLab Gender Prefs")
		If ( (akRefSexuality > 64 || tmpAkSexuality > 64) && akRefSex == tmpAkSex )
			lcUtil.Log(self, "Comfort Failed: One or both NPCs are straight and they are the same gender" )
			comfortFlag = false
		ElseIf( (akRefSexuality < 36 || tmpAkSexuality < 36) && akRefSex != tmpAkSex )
			lcUtil.Log(self, "Comfort Failed: One or both NPCs are gay and they are not the same gender" )
			comfortFlag = false
		Else
			lcUtil.Log(self, "Comfort OK - SexLab Partners Match")
		EndIf
	ElseIf !lcConfigQuest.UseSexLab
		lcUtil.Log(self, "Not Using SexLab Gender Prefs")
	Else
		lcUtil.Log(self, "NPCs Not Related")
	EndIf
		
	; If the are related, find the appropriate sex attractive (or we don't care), check settings...
	If comfortFlag 
		If (!lcConfigQuest.IsMF && akRefSex != tmpAkSex)
			lcUtil.Log(self, "Comfort Failed: Straight sex not allowed and parties are not the same gender" )
			comfortFlag = false
		ElseIf (!lcConfigQuest.IsMM && akRefSex == 0 && tmpAkSex == 0)
			lcUtil.Log(self, "Comfort Failed: gay sex not allowed and parties are both male" )
			comfortFlag = false
		ElseIf (!lcConfigQuest.IsFF && akRefSex == 1 && tmpAkSex == 1)
			lcUtil.Log(self, "Comfort Failed: lesbian sex not allowed and parties are both female" )
			comfortFlag = false
		ElseIf (!lcConfigQuest.IsIncest && (akRef.HasAssociation(SiblingsAssociation, tmpAk) || akRef.HasAssociation(CousinsAssociation, tmpAk)))
			lcUtil.Log(self, "Comfort Failed: incest not allowed and parties are related" )
			comfortFlag = false
		EndIf
	EndIf

	; Related, sexually compatible, and we allow such a pairing...
	If (comfortFlag)
		lcUtil.Log(self, "Yes! : " + tmpAk.GetBaseObject().GetName() + " comforting " + akRef.GetBaseObject().GetName())
		
		Actor[] tmpList = new Actor[2]
		tmpList[0] = tmpAk
		tmpList[1] = akRef

		MakeLove(tmpList)
	
		; Pass them into the Swing scene, which has 3 NPC-NPC scenes, and one NPC-slave scene
		; However, this drops them into MakeLove at the end, which will put them into the new
		; scenes - so switch to StartSex function or call MakeLove here?
		;Int scIndex = lcSwing.AddCouple(akRef, tmpAk, Bed = FindNearestBed( tmpList, false, false ))
		;lcSwing.sceneStart(scIndex)
		; This controls the swinging functions, so leaving there for the moment. Ideally, these would
		; be replicated in the new Scenes. 
		; Bugs: I suspect that, if a couple makes love a second time in a short period, there may be
		; scene confusion when swinging as well. eg. couple makes love, gets loaded to Aliases A1 and B1.
		; When they make love again, they are loaded to A2 and B2, but are still in A1 and B1 because those
		; weren't cleared. The swinging system will try and stop scene 1 rather than the running scene 2,
		; which may cause issues as scene 2 tries to grab the NPCs for the scene...

		return true
	EndIf
	
	return false
EndFunction

; Return True if the NPCs have a permitted relationship
bool Function AreNPCRelated(Actor akRef, Actor tmpAk)
	bool comfortFlag = false
	
	If (akRef.GetRelationshipRank(tmpAk) == 4)
		lcUtil.Log(self, "Relationship: Lovers" )
		comfortFlag = true
	ElseIf (akRef.HasAssociation(SpouseAssociation, tmpAk))
		lcUtil.Log(self, "Relationship: Married" )
		comfortFlag = true
	ElseIf (akRef.HasAssociation(JarlAssociation, tmpAk))
		lcUtil.Log(self, "Relationship: Jarl" )
		comfortFlag = true
	ElseIf (akRef.HasAssociation(CourtingAssociation, tmpAk))
		lcUtil.Log(self, "Relationship: Courting" )
		comfortFlag = true
	ElseIf (akRef.HasAssociation(SiblingsAssociation, tmpAk))
		lcUtil.Log(self, "Relationship: Siblings" )
		comfortFlag = true
	ElseIf (akRef.HasAssociation(CousinsAssociation, tmpAk))
		lcUtil.Log(self, "Relationship: Cousins" )
		comfortFlag = true
	ElseIf lcUtil.SameValidFaction(akRef,tmpAk)
		lcUtil.Log(self, "Relationship: Same Faction")
		comfortFlag = true
	Else
		lcUtil.Log(self, "Relationship: None" )
	EndIf
	
	return comfortFlag
EndFunction

Bool Function UseSlaveForComfort(Formlist actorList, Formlist slaveList)
	If !lcConfigQuest.AllowSlaves
		lcUtil.Log(self, "Slaves not allowed for comfort")
		Return false
	EndIf

	Int Slavecount = slaveActors.GetSize()

	If Slavecount < 1
		lcUtil.Log(self, "No slaves available")
		Return false
	EndIf

	Int i = 0
	While i < actorList.GetSize() && startScanCell == PlayerRef.GetParentCell()
		Actor tmpAk = (actorList.GetAt(i) aS Actor)
		Int j = 0

		If tmpAk.GetSleepState() == 3
			lcUtil.Log(self, "IsValidActor() = VALID - " + tmpAk.GetBaseObject().GetName() )
			While j < slaveList.GetSize()
				Actor slave = (slaveList.GetAt(j) as Actor)
				lcUtil.Log(self, "Looking at slave " + slave.GetBaseObject().GetName() )
				; Check Same Location
				If !tmpAk.getCurrentLocation().IsSameLocation(slave.getCurrentLocation())
					; Slave must have left
					slaveList.RemoveAddedForm(slave)
					j -= 1
				ElseIf lcUtil.IsValidActor(slave) == -13
					If (lcConfigQuest.ButNotMySlaves && lcUtil.IsCurrentFollower(slave))
						lcUtil.Log(self, slave.GetBaseObject().GetName() + " is one of my slaves, so not allowed" )	
					Else 
						lcUtil.Log(self, "Found a slave for " + tmpAk.GetBaseObject().GetName() + "... " + slave.GetBaseObject().GetName() )
						Actor[] tmpList = new Actor[2]
						tmpList[0] = slave
						tmpList[1] = tmpAk
						Actor victim = none
						If (lcConfigQuest.CrudityLevel.GetValue() as Int >= lcConfigQuest.SlaveSexAggressive)
							victim = slave
						EndIf
						MakeLove(tmpList, AkVictim = victim)
					EndIf
				EndIf
				j += 1
			EndWhile
		Else
			lcUtil.Log(self, "Not Asleep - " + tmpAk.GetBaseObject().GetName() )
		EndIf
		i += 1
	EndWhile

	Return False
EndFunction

; Couldn't find a partner? Have a wank?
Function ComfortLoneNPCs(FormList actorList)
	If (!lcConfigQuest.IsNPCMastrubate)
		Return
	EndIf
	
	int i = 0
	While (i < actorList.GetSize() && startScanCell == PlayerRef.GetParentCell())
		Actor tmpAk = (actorList.GetAt(i) aS Actor)
		If (lcUtil.IsValidActor(tmpAk) >= 0)
			If (lcUtil.GetActorArousal(tmpAk) > lcConfigQuest.NPCMasturbateThreshold && tmpAk.GetSleepState() == 3)
				lcUtil.Log(self, "Found : " + tmpAk.GetBaseObject().GetName() + " comforting self")
				Actor[] tmpList = new Actor[1]
				tmpList[0] = tmpAk

				MakeLove(tmpList)
				Return
			EndIf
		EndIf
		i += 1
	EndWhile
EndFunction

Function ComfortFollowers( Bool dontIncludePlayer = true)
	If (!lcConfigQuest.IsOnSleepFollower)
		Return
	EndIf
	
	; scan follow list to see if there are any over the arousal level
	; NB list is only populated after a cellscan

	lcUtil.Log(self,"ComfortFollowers")
	Actor[] followerList = lcCurrentFollowers
	Actor[] tmpList

	lcUtil.Log(self,followerList.length + " followers for comfort")
	
	; criteria for comfort: IsValidActor (optional slaves allowed)
	; arousal higher than set in MCM
	; max three followers allowerd (TODO: increase to 4, or maybe more)
	int i = 0
	While (i < followerList.length)
		Actor tmpAk = followerList[i]
		lcUtil.LogName(self,tmpAk," comfort check")
		Int followerValid = lcUtil.IsValidActor(tmpAk, awakeOK = true, slaveOk = lcConfigQuest.SlaveFollowersCanScrew)
		If ( followerValid >= 0)
			If (lcUtil.GetActorArousal(tmpAk) > lcConfigQuest.gFollowerComfortThreshold.GetValue() && tmpList.length < 3)
				tmpList = sslUtility.PushActor(tmpAk, tmpList)
				lcUtil.LogName(self,tmpAk," will comfort")
			EndIf
		Else 
			lcUtil.LogName(self,tmpAk,"failed for comfort: "+lcUtil.invalidActorType(followerValid))
		EndIf		
		i += 1
	EndWhile
	
	; If the list of valid actors is at least 1 and less than 4, pass to MakeLove function
	If (tmpList.length == 1 && !dontIncludePlayer) 
		; lone Follower will invite player
		lcUtil.Log(self,"Single follower inviting player")
		tmpList = sslUtility.PushActor(PlayerRef, tmpList)
		; since we're using the player on wake-up they should be right on the bed
		MakeLove(tmpList, AkVictim = none, center = FindNearestBed( tmpList, false ))
	ElseIf (tmpList.length > 0 && tmpList.length < 4)
		lcUtil.Log(self,tmpList.length + " actors in comfort scene")
		MakeLove(tmpList)
	EndIf
EndFunction

Function setUpSwinging( Actor ak1 )
	lcUtil.Log(self,"Checking swinging with couple, seed actor: " + ak1.GetDisplayName())

	Actor ak2 = lcUtil.lastLover(ak1)

	If (ak2 == None)
		lcUtil.Log(self,ak1,GetName() + " has no last lover - swing abort")
		ak1.RemoveFromFaction(lcSwingReady)
		Return
	EndIf

	; ak1 should be above arousal level, but ak2 may not
	If (lcUtil.GetActorArousal(ak2) < lcConfigQuest.NPCSwingLevel.GetValue())
		lcUtil.Log(self,"Partner " + ak2.GetDisplayName() + " is not aroused enough ("+lcUtil.GetActorArousal(ak2)+" vs "+lcConfigQuest.NPCSwingLevel.GetValue() )
		ak1.RemoveFromFaction(lcSwingReady)
		ak2.RemoveFromFaction(lcSwingReady)
		Return
	EndIf

	If (!lcUtil.IsInSameSettlement(ak1,ak2,true))
		lcUtil.Log(self,ak1.GetDisplayName() + " not in the same cell as " + ak2.GetDisplayName() + " - swing abort")
		ak1.RemoveFromFaction(lcSwingReady)
		ak2.RemoveFromFaction(lcSwingReady)
		Return
	EndIf

	couple1 = new Actor[2]
	couple2 = new Actor[2]
	
	couple1[0] = PlayerRef
	; TODO: Better partner matching?
	If (SexLab.GetGender(ak1) == SexLab.GetGender(PlayerRef))
		couple1[1] = ak2
		couple2[0] = ak1
	Else
		couple1[1] = ak1
		couple2[0] = ak2
	EndIf
	
	Actor akSpouse = GetSpouse()
	
	Actor akFollower = None
	if (lcCurrentFollowers.length > 0)
		akFollower = lcCurrentFollowers[0]
	EndIf
	
	If (akSpouse != None)
		If ( lcUtil.IsInSameSettlement(PlayerRef,akSpouse,true) )
			couple2[1] = akSpouse
		EndIf
	EndIf
	
	If (akFollower != None && couple2[1] == None)
		If (lcUtil.IsInSameSettlement(PlayerRef,akFollower,true))
			couple2[1] = akFollower
		EndIf
	EndIf

	lcUtil.Log(self,"Couple 1: " + couple1[0].GetDisplayName() + " and " + couple1[1].GetDisplayName())
	lcUtil.Log(self,"Couple 2: " + couple2[0].GetDisplayName() + " and " + couple2[1].GetDisplayName())
	
	If (couple1[1] != None && couple2[0] != None && couple2[1] != None)
		lcUtil.Log(self, "All participants ready")
		couple1[1].AddToFaction(lcSwingReady)
		couple2[0].AddToFaction(lcSwingReady)
		couple2[1].AddToFaction(lcSwingReady)
	Else
		ak1.RemoveFromFaction(lcSwingReady)
		If (ak2 != None)
			ak2.RemoveFromFaction(lcSwingReady)
		EndIf
		lcUtil.Log(self, "Swinging failed - Not enough participants available")
	EndIf
EndFunction

Function startSwinging()
	lcUtil.Log(self,"Staring swinging with couple: " + couple1[1].GetDisplayName() + " and " + couple2[0].GetDisplayName() )
	lcUtil.Log(self,"Extra participant " + couple2[1].GetDisplayName())

	If (couple1[1] != None && couple2[0] != None && couple2[1] != None)
		ObjectReference bed1 = FindNearestBed(couple1)
		MakeLove(couple1, center = bed1)
		Utility.Wait(1.0)
		ObjectReference bed2 = FindNearestBed(couple2, ignoreBed = bed1)
		MakeLove(couple2, center = bed2)
	Else 
		lcUtil.Log(self,"Couples not set!")
	EndIf
EndFunction

Function removeSwingRing(Actor akActor, Bool alsoPartner = false)
	lcUtil.removeSwingRing(akActor, alsoPartner)
EndFunction