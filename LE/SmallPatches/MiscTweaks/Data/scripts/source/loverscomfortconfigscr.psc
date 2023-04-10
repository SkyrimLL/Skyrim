Scriptname LoversComfortConfigScr extends SKI_ConfigBase  

; lovers comfort
LoversComfortUtilScr Property lcUtil Auto

; general settings
bool Property IsRapeMaleAnim Auto Hidden
bool Property IsFFuseFM Auto Hidden
GlobalVariable Property IsDialoguesEnabled Auto
GlobalVariable Property CrudityLevel Auto
Int Property DialogueCrudityLevel Auto Hidden
Int Property SlaveSexAggressive Auto Hidden

; OnSleep
bool Property IsOnSleepMastrubate Auto Hidden
bool Property IsOnSleepSpouse Auto Hidden
bool Property IsOnSleepFollower Auto Hidden
int Property OnSleepMasturbateThreshold Auto Hidden

; NPC
bool Property UseSexLab Auto Hidden
bool Property IsIncest Auto  Hidden
bool Property IsMF Auto Hidden
bool Property IsMM Auto Hidden
bool Property IsFF Auto Hidden
bool Property IsNPCMastrubate Auto Hidden
int Property NPCComfortThreshold Auto Hidden
int Property NPCMasturbateThreshold Auto Hidden
bool Property PlausibleMM Auto Hidden
Bool Property SortBeforePairing Auto Hidden
Bool Property AllowSlaves Auto Hidden
Bool Property ButNotMySlaves Auto Hidden
GlobalVariable Property SexySlaveWalk Auto 
GlobalVariable Property NPCSwingLevel Auto

; spouse
bool Property IsSpouseGay Auto Hidden
bool Property IsSpouseScenesEnabled Auto Hidden
int Property SpouseArousalThreshold Auto Hidden
GlobalVariable Property gSpouseArousalThreshold Auto
int Property SpouseRapeThreshold Auto Hidden

; Logging
Bool Property verboseLogs Auto Hidden

; Follower
Int Property FollowerThreeSomeThreshold Auto Hidden
Int Property FollowerComfortThreshold Auto Hidden
GlobalVariable Property gFollowerThreeSomeThreshold Auto 
GlobalVariable Property gFollowerComfortThreshold Auto 
Bool Property SlaveFollowersCanScrew Auto Hidden

; Menus
String[] DialogueCrudityLevels

; OIDs
int RapeMaleAnimOID
int FFuseFMOID
int DialoguesEnabledOID
int DialogueCrudityOID
int SlaveSexAggressiveOID

int OnSleepFollowerOID
int OnSleepMastrubateOID
int OnSleepSpouseOID

int SpouseGayOID
int SpouseArousalThresholdOID
int SpouseRapeThresholdOID
int SpouseScenesEnabledOID

int UseSexLabOID
int IncestOID
int MFOID
int MMOID
int PlausibleMMOID
int FFOID
int NPCComfortThresholdOID
int NPCSwingLevelOID

int NPCMastrubateOID
int NPCMasturbateThresholdOID

int SortBeforePairingOID
int AllowSlavesOID
int ButNotMySlavesOID
int SexySlaveWalkOID

int verboseLogsOID
int clearPackagesOID

int FollowerThreeSomeThresholdOID
int OnSleepMasturbateThresholdOID
int FollowerComfortThresholdOID
int SlaveFollowersCanScrewOID

int SpousesEnhancedOID

Int FISSSaveOID
Int FISSLoadOID

; page names
String pgSettings = "$LC_Settings"
String pgStatus = "$LC_Status"
String pgNPC = "$LC_NPC"
String pgFollowers = "$LC_Followers"

; variables
bool IsStatusLocked = false

; Valid Actors
FormList Property allActors Auto
FormList Property validActors Auto
FormList Property slaveActors Auto

Int Function GetVersion()
	return 16
EndFunction


Event OnVersionUpdate(int a_version)
	; a_version is the new version, CurrentVersion is the old version
	If (a_version > CurrentVersion)
		lcUtil.Log(self,"Updating MCM to version "+a_version)
	EndIf

	If (a_version >= 10 && CurrentVersion < 10)
		Pages = new string[4]
		Pages[0] = pgSettings
		Pages[1] = pgFollowers
		Pages[2] = pgNPC
		Pages[3] = pgStatus
		IsStatusLocked = false
	EndIf

	If (a_version >= 11 && CurrentVersion < 11)
		DialogueCrudityLevels = new String[4]
		DialogueCrudityLevels[0] = "$LC_DialogueLevelLoving"
		DialogueCrudityLevels[1] = "$LC_DialogueLevelTeasing"
		DialogueCrudityLevels[2] = "$LC_DialogueLevelRough"
		DialogueCrudityLevels[3] = "$LC_DialogueLevelBrutal"
		DialogueCrudityLevel = 2
		CrudityLevel.SetValue(2)
	EndIf

	If (a_version >= 12 && CurrentVersion < 12)
		SlaveFollowersCanScrew = false
	EndIf

	If (a_version >= 14 && CurrentVersion < 14)
		ButNotMySlaves = true
		SlaveSexAggressive = 3
	EndIf

	If (a_version >= 15 && CurrentVersion < 15) 
		NPCSwingLevel.SetValue(40.0)
		gSpouseArousalThreshold.SetValue(SpouseArousalThreshold as Float)
		if ( FollowerThreeSomeThreshold < FollowerComfortThreshold )
			FollowerThreeSomeThreshold = FollowerComfortThreshold + 1
		EndIf
		gFollowerThreeSomeThreshold.SetValue(FollowerThreeSomeThreshold as Float)
		gFollowerComfortThreshold.SetValue(FollowerComfortThreshold as Float)
	EndIf

	If (a_version >= 16 && CurrentVersion < 16)
		DialogueCrudityLevels = new String[5]
		DialogueCrudityLevels[0] = "$LC_DialogueLevelNone"
		DialogueCrudityLevels[1] = "$LC_DialogueLevelLoving"
		DialogueCrudityLevels[2] = "$LC_DialogueLevelTeasing"
		DialogueCrudityLevels[3] = "$LC_DialogueLevelRough"
		DialogueCrudityLevels[4] = "$LC_DialogueLevelBrutal"
		DialogueCrudityLevel = DialogueCrudityLevel + 1
		CrudityLevel.SetValue(DialogueCrudityLevel)
	EndIf
EndEvent


Function Maintenance()
	IsStatusLocked = false
EndFunction


Event OnPageReset(string page)

	; Load custom logo in DDS format
	If (page == "")
		int xOffset = 376 - (375 / 2)
		LoadCustomContent("loverscomfort.dds", xOffset, 0)		
		return
	Else
		UnloadCustomContent()
	EndIf
	
	If (page == pgSettings)
		lcUtil.Log(self,"trying to open settings page...")
		SetCursorFillMode(TOP_TO_BOTTOM)

		; display mod's current version number
		AddTextOption("$LC_Version" , lcUtil.GetVersion(), OPTION_FLAG_DISABLED)
		; option to enable/disable Papyrus debug logging 
		verboseLogsOID = AddToggleOption("$LC_VerboseLogging", verboseLogs)
		; clear any applied AI packages that are stuck
		clearPackagesOID = AddTextOption("$LC_ClearPackages","$LC_Clear")

		; general section
		AddHeaderOption("$LC_General")
		; female-female scenes should use a strap-on instead of lesbian animations
		FFuseFMOID = AddToggleOption("$LC_FFuseFM", IsFFuseFM)
		
		; dialogue options (for sex with followers, NPCs, etc)
		If (IsDialoguesEnabled.GetValue() as Int) < 1
			DialoguesEnabledOID = AddToggleOption("$LC_DialoguesEnabled", false)
		Else
			DialoguesEnabledOID = AddToggleOption("$LC_DialoguesEnabled", true)
		EndIf

		; change crudity level of dialogue
		DialogueCrudityOID = AddMenuOption("$LC_DialogueCrudity", DialogueCrudityLevels[DialogueCrudityLevel])
		; change level at which scenes with slaves are aggressive
		SlaveSexAggressiveOID = AddMenuOption("$LC_SlaveSexAggressive", DialogueCrudityLevels[SlaveSexAggressive])
		
		AddHeaderOption("$LC_SaveLoadFISS")
		Int FISSFlag = OPTION_FLAG_DISABLED
		If (lcUtil.FISSInstalled == true)
			FISSFlag = OPTION_FLAG_NONE
			AddTextOption("$LC_FISSInstalled","$LC_Yes")
		ELse 
			AddTextOption("$LC_FISSInstalled","$LC_No")
		EndIf
		FISSSaveOID = AddTextOption("$LC_SettingsSave","$LC_Save",FISSFlag)
		FISSLoadOID = AddTextOption("$LC_SettingsLoad","$LC_Load",FISSFlag)

		SetCursorPosition(1) ; Move cursor to top right position
		
		; options for spouse relations
		AddHeaderOption("$LC_SpouseComfort")
		; if Spouse Enhanced is installed, and that mod's wake-up option is on, bogart ours
		Int OnSleepSpouseEnabled = OPTION_FLAG_NONE
		Int clashingModId = 0
		If (lcUtil.SpousesEnhancedInstalled)
			If (lcUtil._SE_EnableWakeUpAnimation.GetValueInt() == 1)
				IsOnSleepSpouse = false
				clashingModId = 1
				OnSleepSpouseEnabled = OPTION_FLAG_DISABLED
			EndIf
		EndIf
		If (lcUtil.SexLabEagerNPCsInstalled)
			If (lcUtil.EagerNPCsChance() > 0)
				IsOnSleepSpouse = false
				clashingModId = 2
				OnSleepSpouseEnabled = OPTION_FLAG_DISABLED
			EndIf
		EndIf
		; wake-up sex with the spouse option
		OnSleepSpouseOID = AddToggleOption("$LC_OnSleepSpouse", IsOnSleepSpouse, OnSleepSpouseEnabled)
		; Say why the above is disabled when it's disabled...
		If (lcUtil.SpousesEnhancedInstalled && clashingModId == 1)
			SpousesEnhancedOID = AddTextOption("$LC_SpouseEnhancedInstalled", "$LC_Yes")
		ElseIf (lcUtil.SexLabEagerNPCsInstalled && clashingModId == 2)
			SpousesEnhancedOID = AddTextOption("$LC_SexLabEagerNPCsInstalled", "$LC_Yes")
		Else
			SpousesEnhancedOID = AddTextOption("$LC_NoCompetingWakeUpMod", "$LC_Yes", OPTION_FLAG_DISABLED)
		EndIf

		; spouse can be gay (TODO: now sexlab works with sexuality - default to that?)
		SpouseGayOID = AddToggleOption("$LC_SpouseGay", IsSpouseGay)
		; arousal level at which spouse will stray/be aroused enough for sex with you
		SpouseArousalThresholdOID = AddSliderOption("$LC_SpouseArousalThreshold", gSpouseArousalThreshold.GetValue(), "{0}")
		; enable scenes in which spouse and lover talk
		SpouseScenesEnabledOID = AddToggleOption("$LC_EnableSpouseSences", IsSpouseScenesEnabled)
		; arousal level at which spouse will attempt to rape player
		SpouseRapeThresholdOID = AddSliderOption("$LC_SpouseRapeThreshold", SpouseRapeThreshold, "{0}")
		; rape anims will be male-on-female (ie with a strapon)
		RapeMaleAnimOID = AddToggleOption("$LC_RapeMaleAnim", IsRapeMaleAnim)

		; options for what to do when sleeping
		AddHeaderOption("$LC_OnSleepEvents")
		; masterbate when waking from sleep option
		OnSleepMastrubateOID = AddToggleOption("$LC_OnSleepMastrubate", IsOnSleepMastrubate)
		; what arousal level the PC should have before masturbating
		OnSleepMasturbateThresholdOID = AddSliderOption("$LC_OnSleepMasturbateThreshold", OnSleepMasturbateThreshold, "{0}")
		
	ElseIf (page == pgFollowers)

		SetCursorFillMode(TOP_TO_BOTTOM)
		; Follow options
		AddHeaderOption("$LC_FollowerEvents")
		; Followers will have sex or masturbate when you wake near them
		OnSleepFollowerOID = AddToggleOption("$LC_OnSleepFollower", IsOnSleepFollower)
		; arousal level a follower needs to have to be receptive to a threesome through dialogue
		FollowerThreeSomeThresholdOID = AddSliderOption("$LC_FollowerThreesomeThreshold", gFollowerThreesomeThreshold.GetValue(), "{0}")
		; arousal level a follower needs to have to be involved in a post-wake-up fuck
		FollowerComfortThresholdOID = AddSliderOption("$LC_FollowerComfortThreshold", gFollowerComfortThreshold.GetValue(), "{0}")
		; if followers are slaves, do they have permission to fuck of a morning?
		SlaveFollowersCanScrewOID = AddToggleOption("$LC_SlaveFollowersCanScrew", SlaveFollowersCanScrew)

		SetCursorPosition(1) ; Move cursor to top right position
		
		; Just a list of detected followers
		AddHeaderOption("$LC_CurrentFollowers")
		int i = 0
		Actor[] acList = lcUtil.lcPlayerQuest.lcCurrentFollowers
		While (i < acList.length)
			AddTextOption(acList[i].GetLeveledActorBase().GetName(), lcUtil.GetActorArousal(acList[i]), OPTION_FLAG_DISABLED)
			i += 1
		EndWhile
						
	ElseIf (page == pgNPC)

		SetCursorFillMode(TOP_TO_BOTTOM)
		; What NPCs will do on their own
		AddHeaderOption("$LC_NPCComfort")
		; Keep it in the familty
		IncestOID = AddToggleOption("$LC_EnableIncest", IsIncest)
		; Straight 
		MFOID = AddToggleOption("$LC_EnableMF", IsMF)
		; Gay
		MMOID = AddToggleOption("$LC_EnableMM", IsMM)
		; Lesbian
		FFOID = AddToggleOption("$LC_EnableFF", IsFF)
		; Use SexLab's gender prefs for who an NPC will sex
		UseSexLabOID = AddToggleOption("$LC_UseSexLab", UseSexLab)

		SetCursorPosition(1) ; Move cursor to top right position
		AddEmptyOption()
		; arousal level before an NPC will look for comfort in the night
		NPCComfortThresholdOID = AddSliderOption("$LC_NPCComfortThreshold", NPCComfortThreshold, "{0}")
		; Arousal level at which NPCs will swing with the player, if dialogues enabled
		If (IsDialoguesEnabled.GetValue() as Int) < 1
			NPCSwingLevelOID = AddSliderOption("$LC_NPCSwingThreshold", NPCSwingLevel.GetValue() as Int, "{0}", OPTION_FLAG_DISABLED)
		Else
			NPCSwingLevelOID = AddSliderOption("$LC_NPCSwingThreshold", NPCSwingLevel.GetValue() as Int, "{0}")
		EndIf
		; Will NPC's who can't find comfort will rub one out
		NPCMastrubateOID = AddToggleOption("$LC_EnableMasturbation", IsNPCMastrubate)
		; How horny do NPCs have to be to rub one out
		NPCMasturbateThresholdOID = AddSliderOption("$LC_NPCMasturbateThreshold", NPCMasturbateThreshold, "{0}")
		; Pick proper gay scenes for gay sex
		PlausibleMMOID = AddToggleOption("$LC_PlausibleMM", PlausibleMM)
		; Most aroused NPC goes first when looking for partners
		SortBeforePairingOID = AddToggleOption("$LC_SortBeforePairing", SortBeforePairing)
		; If there are slaves possible, can they be used by aroused NPCs?
		Bool SlaveWalk = false
		If ((SexySlaveWalk.GetValue() as Int) > 0)
			SlaveWalk = true
		EndIf
		If lcUtil.zbfWornCollar != None
			AllowSlavesOID = AddToggleOption("$LC_AllowSlaves", AllowSlaves)
			ButNotMySlavesOID = AddToggleOption("$LC_ButNotMySlaves", ButNotMySlaves)
			SexySlaveWalkOID = AddToggleOption("$LC_SexySlaveWalk", SlaveWalk)
		Else 
			AllowSlavesOID = AddToggleOption("$LC_AllowSlaves", AllowSlaves, OPTION_FLAG_DISABLED)
			ButNotMySlavesOID = AddToggleOption("$LC_ButNotMySlaves", ButNotMySlaves, OPTION_FLAG_DISABLED)
			SexySlaveWalkOID = AddToggleOption("$LC_SexySlaveWalk", SlaveWalk, OPTION_FLAG_DISABLED)
		EndIf
		
	ElseIf (page == pgStatus)
		lcUtil.Log(self, "trying to open status page...")
		If (IsStatusLocked)
			lcUtil.Log(self, "OnPageReset - Status is locked")
			Debug.Notification("Status page is locked :-( , try again latter")
		Else
			IsStatusLocked = true
			
			SetCursorFillMode(TOP_TO_BOTTOM)

			AddHeaderOption("$LC_Player")
			; How far round the horn are we?
			AddTextOption("$LC_ArousalLevel", lcUtil.GetActorArousal(Game.GetPlayer()), OPTION_FLAG_DISABLED)
			
			; Spouse details
			Actor akSpouse = lcUtil.lcPlayerQuest.GetSpouse()
			If (akSpouse != None)
				AddHeaderOption("$LC_Spouse")
				AddTextOption("$LC_Name", akSpouse.GetLeveledActorBase().GetName(), OPTION_FLAG_DISABLED)
				AddTextOption("$LC_ArousalLevel", lcUtil.GetActorArousal(akSpouse), OPTION_FLAG_DISABLED)
				
				; Spouse's potential lover
				Actor akLover = lcUtil.lcPlayerQuest.GetSpouseLover()
				If (akLover != None)
					AddHeaderOption("$LC_PotentialLover")
					AddTextOption("$LC_Name", akLover.GetLeveledActorBase().GetName(), OPTION_FLAG_DISABLED)
					AddTextOption("$LC_ArousalLevel", lcUtil.GetActorArousal(akLover), OPTION_FLAG_DISABLED)
					AddTextOption("$LC_LoverRank", lcUtil.GetSpouseLoverRank(akLover), OPTION_FLAG_DISABLED)
					AddTextOption("$LC_RelationshipRank", akSpouse.GetRelationshipRank(akLover), OPTION_FLAG_DISABLED)
				EndIf
			EndIf
			
			SetCursorPosition(1) ; Move cursor to top right position
			
			; Local NPC details
			; THIS IS SLOOOOOW

			AddHeaderOption("$LC_InCellNPCs")
			AddTextOption("$LC_ValidNPCs", lcUtil.lcPlayerQuest.lcValidActorsInCell, OPTION_FLAG_DISABLED)
			; AddTextOption("$LC_NPCArousalSum", lcUtil.lcPlayerQuest.lcTotalArousalInCell, OPTION_FLAG_DISABLED)
			int i = 0
			While i < allActors.GetSize()
				Actor ak = allActors.GetAt(i) as Actor
				Int va = lcUtil.IsValidActor(ak)
				String ar = "?"
				If va > 0 
					ar = lcUtil.GetActorArousal(ak) as String
				Else 
					ar = lcUtil.invalidActorType(va)
				EndIf
				AddTextOption( ak.GetLeveledActorBase().GetName(), ar, OPTION_FLAG_DISABLED )
				i += 1
			EndWhile
			
			IsStatusLocked = false
		EndIf
	EndIf
EndEvent

Event OnOptionMenuOpen(int option)
	If (option == DialogueCrudityOID)
    	SetMenuDialogOptions(DialogueCrudityLevels)
        SetMenuDialogStartIndex(DialogueCrudityLevel)
        SetMenuDialogDefaultIndex(2)

    ElseIf (option == SlaveSexAggressiveOID)
    	SetMenuDialogOptions(DialogueCrudityLevels)
        SetMenuDialogStartIndex(SlaveSexAggressive)
        SetMenuDialogDefaultIndex(3)

    EndIf
EndEvent

Event OnOptionMenuAccept(int option, int index)
	If (option == DialogueCrudityOID)
		DialogueCrudityLevel = index
		SetMenuOptionValue(DialogueCrudityOID,DialogueCrudityLevels[DialogueCrudityLevel])
		CrudityLevel.SetValue(DialogueCrudityLevel)

	ElseIf (option == SlaveSexAggressiveOID)
		SlaveSexAggressive = index
		SetMenuOptionValue(SlaveSexAggressiveOID,DialogueCrudityLevels[SlaveSexAggressive])

	EndIf
EndEvent

Event OnOptionSelect(int option)
	If (option == RapeMaleAnimOID)
		IsRapeMaleAnim = !IsRapeMaleAnim
		SetToggleOptionValue(RapeMaleAnimOID, IsRapeMaleAnim)

	ElseIf (option == FFuseFMOID)
		IsFFuseFM = !IsFFuseFM
		SetToggleOptionValue(FFuseFMOID, IsFFuseFM)
	
	ElseIf (option == OnSleepMastrubateOID)
		IsOnSleepMastrubate = !IsOnSleepMastrubate
		SetToggleOptionValue(OnSleepMastrubateOID, IsOnSleepMastrubate)
		
	ElseIf (option == OnSleepFollowerOID)
		IsOnSleepFollower = !IsOnSleepFollower
		SetToggleOptionValue(OnSleepFollowerOID, IsOnSleepFollower)

	ElseIf (option == SlaveFollowersCanScrewOID)
		SlaveFollowersCanScrew = !SlaveFollowersCanScrew
		SetToggleOptionValue(SlaveFollowersCanScrewOID, SlaveFollowersCanScrew)

	ElseIf (option == DialoguesEnabledOID)
		If ((IsDialoguesEnabled.GetValue() as Int) < 1)
			IsDialoguesEnabled.SetValue(1)
			SetToggleOptionValue(DialoguesEnabledOID, true)
		Else
			IsDialoguesEnabled.SetValue(0)
			SetToggleOptionValue(DialoguesEnabledOID, false)
		EndIf

	ElseIf (option == OnSleepSpouseOID)
		IsOnSleepSpouse = !IsOnSleepSpouse
		SetToggleOptionValue(OnSleepSpouseOID, IsOnSleepSpouse)
			
	ElseIf (option == SpouseGayOID)
		IsSpouseGay = !IsSpouseGay
		SetToggleOptionValue(SpouseGayOID, IsSpouseGay)

	ElseIf (option == SpouseScenesEnabledOID)
		IsSpouseScenesEnabled = !IsSpouseScenesEnabled
		SetToggleOptionValue(SpouseScenesEnabledOID, IsSpouseScenesEnabled)
		
	ElseIf (option == UseSexLabOID)
		UseSexLab = !UseSexLab
		SetToggleOptionValue(UseSexLabOID, UseSexLab)
		
	ElseIf (option == IncestOID)
		IsIncest = !IsIncest
		SetToggleOptionValue(IncestOID, IsIncest)
		
	ElseIf (option == MFOID)
		IsMF = !IsMF
		SetToggleOptionValue(MFOID, IsMF)
		
	ElseIf (option == MMOID)
		IsMM = !IsMM
		SetToggleOptionValue(MMOID, IsMM)
		
	ElseIf (option == PlausibleMMOID)
		PlausibleMM = !PlausibleMM
		SetToggleOptionValue(PlausibleMMOID, PlausibleMM)
		
	ElseIf (option == FFOID)
		IsFF = !IsFF
		SetToggleOptionValue(FFOID, IsFF)
		
	ElseIf (option == NPCMastrubateOID)
		IsNPCMastrubate = !IsNPCMastrubate
		SetToggleOptionValue(NPCMastrubateOID, IsNPCMastrubate)

	ElseIf (option == SortBeforePairingOID)
		SortBeforePairing = !SortBeforePairing
		SetToggleOptionValue(SortBeforePairingOID, SortBeforePairing)
		
	ElseIf (option == AllowSlavesOID)
		AllowSlaves = !AllowSlaves
		SetToggleOptionValue(AllowSlavesOID, AllowSlaves)
	
	ElseIf (option == ButNotMySlavesOID)
		ButNotMySlaves = !ButNotMySlaves
		SetToggleOptionValue(ButNotMySlavesOID, ButNotMySlaves)

	ElseIf (option == SexySlaveWalkOID)
		If ((SexySlaveWalk.GetValue() as Int) < 1)
			SexySlaveWalk.SetValue(1)
			SetToggleOptionValue(SexySlaveWalkOID, true)
		Else
			SexySlaveWalk.SetValue(0)
			SetToggleOptionValue(SexySlaveWalkOID, false)
		EndIf

	ElseIf (option == verboseLogsOID)
		verboseLogs = !verboseLogs
		SetToggleOptionValue(verboseLogsOID, verboseLogs)

	ElseIf (option == clearPackagesOID)
		lcUtil.ClearAllAIPackages()
		SetTextOptionValue(clearPackagesOID, "$LC_Done")
		SetOptionFlags(clearPackagesOID, OPTION_FLAG_DISABLED)

	ElseIf (option == FISSSaveOID)
		SaveFISSSettings()

	ElseIf (option == FISSLoadOID)
		LoadFISSSettings()

	EndIf
EndEvent


Event OnOptionSliderOpen(int option)						
	If option == SpouseArousalThresholdOID
		SetSliderDialogStartValue(gSpouseArousalThreshold.GetValue())
		SetSliderDialogDefaultValue(50)
		SetSliderDialogRange(0, lcUtil.slaUtil.slaArousalCap)
		SetSliderDialogInterval(1)

	ElseIf option == NPCComfortThresholdOID
		SetSliderDialogStartValue(NPCComfortThreshold as float)
		SetSliderDialogDefaultValue(60)
		SetSliderDialogRange(0, lcUtil.slaUtil.slaArousalCap)
		SetSliderDialogInterval(1)

	ElseIf (option == NPCSwingLevelOID)
		SetSliderDialogStartValue(NPCSwingLevel.GetValue())
		SetSliderDialogDefaultValue(40)
		SetSliderDialogRange(0, lcUtil.slaUtil.slaArousalCap)
		SetSliderDialogInterval(1)

	ElseIf option == NPCMasturbateThresholdOID
		SetSliderDialogStartValue(NPCMasturbateThreshold as float)
		SetSliderDialogDefaultValue(75)
		SetSliderDialogRange(0, lcUtil.slaUtil.slaArousalCap)
		SetSliderDialogInterval(1)

	ElseIf option == SpouseRapeThresholdOID
		SetSliderDialogStartValue(SpouseRapeThreshold as float)
		SetSliderDialogDefaultValue(80)
		SetSliderDialogRange(0, lcUtil.slaUtil.slaArousalCap)
		SetSliderDialogInterval(1)

	ElseIf option == FollowerThreeSomeThresholdOID
		SetSliderDialogStartValue(gFollowerThreeSomeThreshold.GetValue())
		SetSliderDialogDefaultValue(70)
		Int minVal = gFollowerComfortThreshold.GetValue() as Int
		minVal = minVal + 1
		SetSliderDialogRange(minVal, lcUtil.slaUtil.slaArousalCap)
		SetSliderDialogInterval(1)

	ElseIf option == FollowerComfortThresholdOID
		SetSliderDialogStartValue(gFollowerComfortThreshold.GetValue())
		SetSliderDialogDefaultValue(30)
		Int maxVal = gFollowerThreeSomeThreshold.GetValue() as Int
		maxVal = maxVal - 1
		SetSliderDialogRange(0, maxVal)
		SetSliderDialogInterval(1)

	ElseIf option == OnSleepMasturbateThresholdOID
		SetSliderDialogStartValue(OnSleepMasturbateThreshold as float)
		SetSliderDialogDefaultValue(90)
		SetSliderDialogRange(0, lcUtil.slaUtil.slaArousalCap)
		SetSliderDialogInterval(1)

	EndIf
EndEvent


Event OnOptionSliderAccept(int option, float value)					
	If option == SpouseArousalThresholdOID
		gSpouseArousalThreshold.SetValue(value)
		SetSliderOptionValue(option, value, "{0}")

	ElseIf option == NPCComfortThresholdOID
		NPCComfortThreshold = value as Int
		SetSliderOptionValue(option, value, "{0}")

	ElseIf (option == NPCSwingLevelOID)
		NPCSwingLevel.SetValue(value)
		SetSliderOptionValue(option, value as Int, "{0}")

	ElseIf option == NPCMasturbateThresholdOID
		NPCMasturbateThreshold = value as Int
		SetSliderOptionValue(option, value, "{0}")

	ElseIf option == SpouseRapeThresholdOID
		SpouseRapeThreshold = value as Int
		SetSliderOptionValue(option, value, "{0}")

	ElseIf option == FollowerThreeSomeThresholdOID
		gFollowerThreeSomeThreshold.SetValue(value)
		SetSliderOptionValue(option, value, "{0}")

	ElseIf option == FollowerComfortThresholdOID
		gFollowerComfortThreshold.SetValue(value)
		SetSliderOptionValue(option, value, "{0}")

	ElseIf option == OnSleepMasturbateThresholdOID
		OnSleepMasturbateThreshold = value as Int
		SetSliderOptionValue(option, value, "{0}")

	EndIf
EndEvent


Event OnOptionHighlight(int option)
	If (option == RapeMaleAnimOID)
		SetInfoText("$LC_InfoRapeMaleAnim")

	ElseIf (option == FFuseFMOID)
		SetInfoText("$LC_InfoFFuseFM")
		
	ElseIf (option == OnSleepMastrubateOID)
		SetInfoText("$LC_InfoOnSleepMastrubate")
		
	ElseIf (option == OnSleepFollowerOID)
		SetInfoText("$LC_InfoOnSleepFollower")

	ElseIf (option == SlaveFollowersCanScrewOID)
		SetInfoText("$LC_InfoSlaveFollowersCanScrew")
	
	ElseIf (option == DialoguesEnabledOID)
		SetInfoText("$LC_InfoDialoguesEnabled")
						
	ElseIf (option == SpouseArousalThresholdOID)
		SetInfoText("$LC_InfoSpouseArousalThreshold")
	
	ElseIf (option == FollowerThreeSomeThresholdOID)
		SetInfoText("$LC_InfoFollowerThreeSomeThreshold")

	ElseIf (option == FollowerComfortThresholdOID)
		SetInfoText("$LC_InfoFollowerComfortThreshold")

	ElseIf (option == SpouseRapeThresholdOID)	
		SetInfoText("$LC_InfoSpouseRapeThreshold")
	
	ElseIf (option == OnSleepMasturbateThresholdOID)
		SetInfoText("$LC_OnSleepMasturbateThreshold")

	ElseIf (option == NPCComfortThresholdOID)
		SetInfoText("$LC_InfoNPCComfortThreshold")

	ElseIf (option == NPCSwingLevelOID)
		SetInfoText("$LC_InfoNPCSwingThreshold")
		
	ElseIf (option == NPCMasturbateThresholdOID)
		SetInfoText("$LC_InfoNPCMasturbateThreshold")
		
	ElseIf (option == OnSleepSpouseOID)
		SetInfoText("$LC_InfoOnSleepSpouse")

	ElseIf (option == SpousesEnhancedOID)
		SetInfoText("$LC_SpousesEnhancedInfo")

	ElseIf (option == SpouseGayOID)
		SetInfoText("$LC_InfoSpouseGay")
		
	ElseIf (option == SpouseScenesEnabledOID)
		SetInfoText("$LC_InfoEnableSpouseSences")
		
	ElseIf (option == PlausibleMMOID)
		SetInfoText("$LC_InfoPlausibleMM")

	ElseIf (option == UseSexLabOID)
		SetInfoText("$LC_InfoUseSexLab")

	ElseIf (option == SortBeforePairingOID)
		SetInfoText("$LC_InfoSortBeforePairing")

	ElseIf (option == AllowSlavesOID)
		SetInfoText("$LC_InfoAllowSlaves")
		
	ElseIf (option == ButNotMySlavesOID)
		SetInfoText("$LC_InfoButNotMySlaves")

	ElseIf (option == SexySlaveWalkOID)
		SetInfoText("$LC_InfoSexySlaveWalk")

	ElseIf (option == SlaveSexAggressiveOID)
		SetInfoText("$LC_InfoSlaveSexAggressive")

	ElseIf (option == DialogueCrudityOID)
		SetInfoText("$LC_InfoDialogueCrudity")

	ElseIf (option == IncestOID || option == MFOID || option == MMOID || option == FFOID || option == NPCMastrubateOID)
		SetInfoText("$LC_InfoNPCIncest")

	ElseIf (option == FISSSaveOID || option == FISSLoadOID)
		SetInfoText("$LC_InfoFISS")

	EndIf
EndEvent


Event OnOptionDefault(int option)		
	If (option == RapeMaleAnimOID)
		IsRapeMaleAnim = true ; default value
		SetToggleOptionValue(RapeMaleAnimOID, IsRapeMaleAnim)
		
	ElseIf (option == FFuseFMOID)
		IsFFuseFM = true ; default value
		SetToggleOptionValue(FFuseFMOID, IsFFuseFM)
		
	ElseIf (option == OnSleepMastrubateOID)
		IsOnSleepMastrubate = true ; default value
		SetToggleOptionValue(OnSleepMastrubateOID, IsOnSleepMastrubate)
		
	ElseIf (option == OnSleepFollowerOID)
		IsOnSleepFollower = true ; default value
		SetToggleOptionValue(OnSleepFollowerOID, IsOnSleepFollower)

	ElseIf (option == SlaveFollowersCanScrewOID)
		SlaveFollowersCanScrew = false; default
		SetToggleOptionValue(SlaveFollowersCanScrewOID, SlaveFollowersCanScrew)

	ElseIf (option == DialoguesEnabledOID)
		IsDialoguesEnabled.SetValue(1)
		SetToggleOptionValue(DialoguesEnabledOID, true)
						
	ElseIf (option == SpouseArousalThresholdOID)
		SpouseArousalThreshold = 50 ; default value
		SetSliderOptionValue(SpouseArousalThresholdOID, gSpouseArousalThreshold.GetValue(), "{0}")
	
	ElseIf (option == FollowerThreeSomeThresholdOID)
		FollowerThreeSomeThreshold = 70 ; default value
		SetSliderOptionValue(FollowerThreeSomeThresholdOID, gFollowerThreeSomeThreshold.GetValue(), "{0}")

	ElseIf (option == FollowerComfortThresholdOID)
		FollowerComfortThreshold = 30 ; default value
		SetSliderOptionValue(FollowerComfortThresholdOID, gFollowerComfortThreshold.GetValue(), "{0}")

	ElseIf (option == SpouseRapeThresholdOID)
		SpouseRapeThreshold = 80 ; default value
		SetSliderOptionValue(SpouseRapeThresholdOID, SpouseRapeThreshold as float, "{0}")
	
	ElseIf (option == OnSleepMasturbateThresholdOID)
		OnSleepMasturbateThreshold = 90 ; default value
		SetSliderOptionValue(OnSleepMasturbateThresholdOID, OnSleepMasturbateThreshold as float, "{0}")

	ElseIf (option == NPCComfortThresholdOID)
		NPCComfortThreshold = 60 ; default value
		SetSliderOptionValue(NPCComfortThresholdOID, NPCComfortThreshold as float, "{0}")

	ElseIf (option == NPCSwingLevelOID)
		NPCSwingLevel.SetValue(40.0) ; default value
		SetSliderOptionValue(NPCSwingLevelOID, NPCSwingLevel.GetValue(), "{0}")
		
	ElseIf (option == NPCMasturbateThresholdOID)
		NPCMasturbateThreshold = 75 ; default value
		SetSliderOptionValue(NPCMasturbateThresholdOID, NPCMasturbateThreshold as float, "{0}")
		
	ElseIf (option == OnSleepSpouseOID)
		IsOnSleepSpouse = true ; default value
		SetToggleOptionValue(OnSleepSpouseOID, IsOnSleepSpouse)
				
	ElseIf (option == SpouseGayOID)
		IsSpouseGay = true ; default value
		SetToggleOptionValue(SpouseGayOID, IsSpouseGay)

	ElseIf (option == SpouseScenesEnabledOID)
		IsSpouseScenesEnabled = true ; default value
		SetToggleOptionValue(SpouseScenesEnabledOID, IsSpouseScenesEnabled)
	
	ElseIf (option == UseSexLabOID)
		UseSexLab = false ; default value
		SetToggleOptionValue(UseSexLabOID, UseSexLab)
		
	ElseIf (option == IncestOID)
		IsIncest = true ; default value
		SetToggleOptionValue(IncestOID, IsIncest)
		
	ElseIf (option == MFOID)
		IsMF = true ; default value
		SetToggleOptionValue(MFOID, IsMF)
		
	ElseIf (option == MMOID)
		IsMM = true ; default value
		SetToggleOptionValue(MMOID, IsMM)
		
	ElseIf (option == PlausibleMMOID)
		PlausibleMM = false ; default value
		SetToggleOptionValue(PlausibleMMOID, PlausibleMM)
		
	ElseIf (option == FFOID)
		IsFF = true ; default value
		SetToggleOptionValue(FFOID, IsFF)
		
	ElseIf (option == NPCMastrubateOID)
		IsNPCMastrubate = true ; default value
		SetToggleOptionValue(NPCMastrubateOID, IsNPCMastrubate)

	EndIf
EndEvent

Function SaveFISSSettings()
	If (!lcUtil.FISSInstalled)
		lcUtil.Log(self,"FISS Save Called When FISS not installed")
		ShowMessage("$LC_FISSNotInstalled")
		Return
	EndIf

	If (ShowMessage("$LC_FISSSaveOK", True) == False)
		Return
	EndIf

	FISSInterface FISS = FISSFactory.GetFISS()

	FISS.BeginSave("LoversComfort.xml","Lover's Comfort")

	FISS.SaveBool("IsRapeMaleAnim",IsRapeMaleAnim)
	FISS.SaveBool("IsFFuseFM",IsFFuseFM)
	FISS.SaveFloat("IsDialoguesEnabled",IsDialoguesEnabled.GetValue())
	FISS.SaveFloat("CrudityLevel",CrudityLevel.GetValue())
	FISS.SaveInt("DialogueCrudityLevel",DialogueCrudityLevel)
	FISS.SaveInt("SlaveSexAggressive",SlaveSexAggressive)
	FISS.SaveBool("IsOnSleepMastrubate",IsOnSleepMastrubate)
	FISS.SaveBool("IsOnSleepSpouse",IsOnSleepSpouse)
	FISS.SaveBool("IsOnSleepFollower",IsOnSleepFollower)
	FISS.SaveInt("OnSleepMasturbateThreshold",OnSleepMasturbateThreshold)
	FISS.SaveBool("UseSexLab",UseSexLab)
	FISS.SaveBool("IsIncest",IsIncest)
	FISS.SaveBool("IsMF",IsMF)
	FISS.SaveBool("IsMM",IsMM)
	FISS.SaveBool("IsFF",IsFF)
	FISS.SaveBool("IsNPCMastrubate",IsNPCMastrubate)
	FISS.SaveInt("NPCComfortThreshold",NPCComfortThreshold)
	FISS.SaveInt("NPCMasturbateThreshold",NPCMasturbateThreshold)
	FISS.SaveBool("PlausibleMM",PlausibleMM)
	FISS.SaveBool("SortBeforePairing",SortBeforePairing)
	FISS.SaveBool("AllowSlaves",AllowSlaves)
	FISS.SaveBool("ButNotMySlaves",ButNotMySlaves)
	FISS.SaveFloat("SexySlaveWalk",SexySlaveWalk.GetValue())
	FISS.SaveFloat("NPCSwingLevel",NPCSwingLevel.GetValue())
	FISS.SaveBool("IsSpouseGay",IsSpouseGay)
	FISS.SaveBool("IsSpouseScenesEnabled",IsSpouseScenesEnabled)
	FISS.SaveFloat("gSpouseArousalThreshold",gSpouseArousalThreshold.GetValue())
	FISS.SaveInt("SpouseRapeThreshold",SpouseRapeThreshold)
	FISS.SaveBool("verboseLogs",verboseLogs)
	FISS.SaveFloat("gFollowerThreeSomeThreshold",gFollowerThreeSomeThreshold.GetValue())
	FISS.SaveFloat("gFollowerComfortThreshold",gFollowerComfortThreshold.GetValue())
	FISS.SaveBool("SlaveFollowersCanScrew",SlaveFollowersCanScrew)

	String SaveOK = FISS.EndSave()

	If (SaveOK != "")
		ShowMessage("$LC_SaveFailed")
		lcUtil.Log(self,"FISS Save Failed: " + SaveOK, true)
	Else
		ShowMessage("$LC_SaveOK")
		ForcePageReset()
	EndIf
EndFunction

Function LoadFISSSettings()
	If (!lcUtil.FISSInstalled)
		lcUtil.Log(self,"FISS Load Called When FISS not installed")
		ShowMessage("$LC_FISSNotInstalled")
		Return
	EndIf

	If (ShowMessage("$LC_FISSLoadOK", True) == False)
		Return
	EndIf

	FISSInterface FISS = FISSFactory.GetFISS()

	FISS.BeginLoad("LoversComfort.xml")

	IsRapeMaleAnim = FISS.LoadBool("IsRapeMaleAnim")
	IsFFuseFM = FISS.LoadBool("IsFFuseFM")
	IsDialoguesEnabled.SetValue(FISS.LoadFloat("IsDialoguesEnabled"))
	CrudityLevel.SetValue(FISS.LoadFloat("CrudityLevel"))
	DialogueCrudityLevel = FISS.LoadInt("DialogueCrudityLevel")
	SlaveSexAggressive = FISS.LoadInt("SlaveSexAggressive")
	IsOnSleepMastrubate = FISS.LoadBool("IsOnSleepMastrubate")
	IsOnSleepSpouse = FISS.LoadBool("IsOnSleepSpouse")
	IsOnSleepFollower = FISS.LoadBool("IsOnSleepFollower")
	OnSleepMasturbateThreshold = FISS.LoadInt("OnSleepMasturbateThreshold")
	UseSexLab = FISS.LoadBool("UseSexLab")
	IsIncest = FISS.LoadBool("IsIncest")
	IsMF = FISS.LoadBool("IsMF")
	IsMM = FISS.LoadBool("IsMM")
	IsFF = FISS.LoadBool("IsFF")
	IsNPCMastrubate = FISS.LoadBool("IsNPCMastrubate")
	NPCComfortThreshold = FISS.LoadInt("NPCComfortThreshold")
	NPCMasturbateThreshold = FISS.LoadInt("NPCMasturbateThreshold")
	PlausibleMM = FISS.LoadBool("PlausibleMM")
	SortBeforePairing = FISS.LoadBool("SortBeforePairing")
	AllowSlaves = FISS.LoadBool("AllowSlaves")
	ButNotMySlaves = FISS.LoadBool("ButNotMySlaves")
	SexySlaveWalk.SetValue(FISS.LoadFloat("SexySlaveWalk"))
	NPCSwingLevel.SetValue(FISS.LoadFloat("NPCSwingLevel"))
	IsSpouseGay = FISS.LoadBool("IsSpouseGay")
	IsSpouseScenesEnabled = FISS.LoadBool("IsSpouseScenesEnabled")
	gSpouseArousalThreshold.SetValue(FISS.LoadFloat("gSpouseArousalThreshold"))
	SpouseRapeThreshold = FISS.LoadInt("SpouseRapeThreshold")
	verboseLogs = FISS.LoadBool("verboseLogs")
	gFollowerThreeSomeThreshold.SetValue(FISS.LoadFloat("gFollowerThreeSomeThreshold"))
	gFollowerComfortThreshold.SetValue(FISS.LoadFloat("gFollowerComfortThreshold"))
	SlaveFollowersCanScrew = FISS.LoadBool("SlaveFollowersCanScrew")

	String SaveOK = FISS.EndLoad()

	If (SaveOK != "")
		ShowMessage("$LC_LoadFailed")
		lcUtil.Log(self,"FISS Save Failed: " + SaveOK, true)
	Else
		ShowMessage("$LC_LoadOK")
		ForcePageReset()
	EndIf
EndFunction