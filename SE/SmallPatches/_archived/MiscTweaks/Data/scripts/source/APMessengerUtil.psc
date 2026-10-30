Scriptname APMessengerUtil extends Quest  

import StorageUtil
import PapyrusUtil

Quest Property MQ101  Auto  

ObjectReference Property helgenInnMarker Auto
ImageSpaceModifier Property FadeToBlackHoldImod Auto
ImageSpaceModifier Property FadeToBlackBackImod Auto

ImageSpaceModifier Property WarpTime Auto
Message Property Split Auto

Quest[] Property startingQuests Auto
Quest entryQuest = none

; =========================================================
; ============================== TIME SKIPS
; =========================================================

Function SkipKeepEntrance()
    int choice = split.show()
    If choice == 0
        return
    endif

    Utility.Wait(1.1)
    WarpTime.Apply()
    Utility.Wait(2.5)

    If choice == 1
        MQ101.SetStage(6)
    elseif choice == 2
        MQ101.SetStage(7)
    endif
EndFunction

Function SkipIvarstead()

EndFunction


; =========================================================
; ============================== MENU
; =========================================================
Event OnInit()
	If(!UIExtensions.GetMenu("UIListMenu"))
		; No point preparing Menu Variables if you dont have UIExtensions
		; I assume you also dont have PapyrusUtil in such instances so below would just spam the Log with Errors zzz
		Debug.MessageBox("UI Extensions is required")
		return
	EndIf
	string[] mainListUI = new string[13]
	mainListUI[0] = " Default"
	mainListUI[1] = "Random"
	mainListUI[2] = " Regular at an inn"
	mainListUI[3] = " From overseas"
	mainListUI[4] = " A wanted criminal"
	mainListUI[5] = " Robbed and barely alive"
	mainListUI[6] = " Shipwrecked"
	mainListUI[7] = " I live in my own home"
	mainListUI[8] = " Part of a vampire clan"
	mainListUI[9] = " Member of the Forsworn"
	mainListUI[10] = " I hunt in Hircine's name"
	mainListUI[11] = " Member of a guild"
	mainListUI[12] = " The Dragonborn"

	string[] mainString = new string[13]
	mainString[0] = "APS_Pilgerer" ; Quickstart_SkipAlduin_SkipIntro
	mainString[1] = "APS_Random"
	mainString[2] =	"APSI_Random_The Bannered Mare_The Bee and Barb_The Winking Skeever_Silver-Blood Inn_Candlehearth Hall_Dead Man's Drink_Moorside Inn_The Frozen Hearth_Windpeak Inn_The Retching Netch_The Sleeping Giant Inn_Frostfruit Inn_Vilemyr Inn_Old Hroldan Inn_Four Shields Tavern_Nightgate Inn_Braidwood Inn"
	mainString[3] = "APSD_Random_East Empire Trading Company_Windhelm Docks_Dawnstar's Shore_Raven Rock Docks"
	mainString[4] = "APSW_Random_..in Whiterun (Whiterun)_..in the Rift (Riften)_..in the Pale (Dawnstar)_..in Winterhold (Winterhold)"
	mainString[5] = "APSLfD_Random_..in the Rift (Riften)_..in the Reach (Markarth)_..in Winterhold (Winterhold)"
	mainString[6] = "APSS_Shipwrecked"
	mainString[7] = "APSH_Random_..in Whiterun_..in Solitude_..in Riften_..in Markarth"
	mainString[8] = "APSV_Random_Pinemoon Cave_Bloodlet Throne_Movarth's Lair_Haemar's Shame"
	mainString[9] = "APSFor_Forsworn"
	mainString[10] = "APSW_Falkreath"
	mainString[11] = "APSG_Random_College of Winterhold_Thieves Guild_Dark Brotherhood_Companions"
	mainstring[12] = "APSM_Vanilla Start_High Hrothgar"

	StringListCopy(none, "APS_mainListUI", mainListUI)
	StringListCopy(none, "APS_mainListIntern", mainString)

	SetFormValue(none, "APSIThe Bannered Mare", startingQuests[0]) ; Inns
	SetFormValue(none, "APSIThe Bee and Barb", startingQuests[1])
	SetFormValue(none, "APSIThe Winking Skeever", startingQuests[2])
	SetFormValue(none, "APSISilver-Blood Inn", startingQuests[3])
	SetFormValue(none, "APSICandlehearth Hall", startingQuests[4])
	SetFormValue(none, "APSIDead Man's Drink", startingQuests[5])
	SetFormValue(none, "APSIMoorside Inn", startingQuests[6])
	SetFormValue(none, "APSIThe Frozen Hearth", startingQuests[7])
	SetFormValue(none, "APSIWindpeak Inn", startingQuests[8])
	SetFormValue(none, "APSIThe Retching Netch", startingQuests[9])
	SetFormValue(none, "APSIThe Sleeping Giant Inn", startingQuests[10])
	SetFormValue(none, "APSIFrostfruit Inn", startingQuests[11])
	SetFormValue(none, "APSIVilemyr Inn", startingQuests[12])
	SetFormValue(none, "APSIOld Hroldan Inn", startingQuests[13])
	SetFormValue(none, "APSIFour Shields Tavern", startingQuests[14])
	SetFormValue(none, "APSINightgate Inn", startingQuests[15])
	SetFormValue(none, "APSIBraidwood Inn", startingQuests[16])

	SetFormValue(none, "APSDEast Empire Trading Company", startingQuests[17]) ; Docks
	SetFormValue(none, "APSDWindhelm Docks", startingQuests[18])
	SetFormValue(none, "APSDDawnstar's Shore", startingQuests[19])
	SetFormValue(none, "APSDRaven Rock Docks", startingQuests[20])

	SetFormValue(none, "APSW..in Whiterun (Whiterun)", startingQuests[21]) ; Wanted
	SetFormValue(none, "APSW..in the Rift (Riften)", startingQuests[22])
	SetFormValue(none, "APSW..in the Pale (Dawnstar)", startingQuests[23])
	SetFormValue(none, "APSW..in Winterhold (Winterhold)", startingQuests[24])

	SetFormValue(none, "APSLfD..in the Rift (Riften)", startingQuests[25]) ; Left For Dead
	SetFormValue(none, "APSLfD..in the Reach (Markarth)", startingQuests[26])
	SetFormValue(none, "APSLfD..in Winterhold (Winterhold)", startingQuests[27])

	SetFormValue(none, "APSSShipwrecked", startingQuests[28]) ; Shipwrecked

	SetFormValue(none, "APSH..in Whiterun", startingQuests[29]) ; Owned House
	SetFormValue(none, "APSH..in Solitude", startingQuests[30])
	SetFormValue(none, "APSH..in Riften", startingQuests[31])
	SetFormValue(none, "APSH..in Markarth", startingQuests[32])

	SetFormValue(none, "APSVPinemoon Cave", startingQuests[33]) ; Vampire
	SetFormValue(none, "APSVBloodlet Throne", startingQuests[34])
	SetFormValue(none, "APSVMovarth's Lair", startingQuests[35])
	SetFormValue(none, "APSVHaemar's Shame", startingQuests[36])

	SetFormValue(none, "APSForForsworn", startingQuests[43]) ; Forsworn

	SetFormValue(none, "APSWFalkreath", startingQuests[37]) ; Werewolf

	SetFormValue(none, "APSGCollege of Winterhold", startingQuests[38]) ; Guilds
	SetFormValue(none, "APSGThieves Guild", startingQuests[39])
	SetFormValue(none, "APSGDark Brotherhood", startingQuests[40])
	SetFormValue(none, "APSGCompanions", startingQuests[41])

	SetFormValue(none, "APSMVanilla Start", startingQuests[44]) ; Mainquest
	SetFormValue(none, "APSMHigh Hrothgar", startingQuests[42])
EndEvent

string[] _entryName
int[] _entryId
int[] _entryParent
int[] _entryCallback
bool[] _entryChildren
int _entryChoice = -1
int _entryBuffer = 0
bool _sortEnabled = false

int _resultInt
float _resultFloat
String _resultString

bool _waitLock = false
Function Lock()
	_waitLock = true
EndFunction
bool Function WaitLock()
	int lockOut = 0
	While _waitLock
		lockOut += 1
		If lockOut > 50 ; Took more than 5 sec
			_waitLock = false
			return false
		Endif
		Utility.Wait(0.1)
	EndWhile
	return true
EndFunction
Function Unlock()
	_waitLock = false
EndFunction

Function SetEntry()
	Debug.Trace("[AP] Preparing Selection Menu")
	_entryName = Utility.CreateStringArray(512)
	_entryId = Utility.CreateIntArray(_entryName.Length)
	_entryParent = Utility.CreateIntArray(_entryName.Length)
	_entryCallback = Utility.CreateIntArray(_entryName.Length)
	_entryChildren = Utility.CreateBoolArray(_entryName.Length)
	_entryBuffer = 0
	; Reset the queue
	string[] queue = StringListToArray(none, "APS_queue")
	int p = 0
	While(p < queue.length)
		string[] tmp = StringUtil.Split(queue[p], ";")
		StringListAdd(none, "APS_mainListUI", tmp[0])
		StringListAdd(none, "APS_mainListIntern", tmp[1])
		p += 1
	EndWhile
	StringListClear(none, "APS_queue")

	; Then do menu stuff
	string[] mainListUI = StringListToArray(none, "APS_mainListUI")
	string[] mainString = StringListToArray(none, "APS_mainListIntern")
	int i = 0
	While(i < mainListUI.length)
		; Add Main Entry
		int pos = Self.AddEntryItem(mainListUI[i])
		; Analyze Sub Entry String (Prefix + SubOptions)
		string[] subListUI = StringUtil.Split(mainString[i], "_")
		string prefix = subListUI[0]
		If(subListUI.length == 2) ; No Childs
			FormListAdd(none, "APS_Quests", GetFormValue(none, prefix + subListUI[1]))
		ElseIf(subListUI.length > 2) ; Has Childs
			FormListAdd(none, "APS_Quests", none) ; Set the Parent Option to none
			Self.SetPropertyIndexBool("hasChildren", pos, true)
			int n = 1 ; Skip first Line, thats the Prefix
			While(n < subListUI.length)
				Self.AddEntryItem(subListUI[n], pos, i)
				FormListAdd(none, "APS_Quests", GetFormValue(none, prefix + subListUI[n]))
				n += 1
			EndWhile
		else ; Invalid Line, set to none and use the Default if the Player selects it
			FormListAdd(none, "APS_Quests", none)
		EndIf
		i += 1
	EndWhile
EndFunction
Function MenuOpen()
	string[] mainListUI = StringListToArray(none, "APS_mainListUI")
	string[] mainString = StringListToArray(none, "APS_mainListIntern")
	OpenMenu()
	If(_resultInt == 0) ; Default
		entryQuest = none
	ElseIf(_resultString == "Random") ; Sublist Random
		int callBack = _resultFloat as int
		If(callBack == -1) ; All Random
			callBack = Utility.RandomInt(2, mainListUI.length) ; 0 is Default, 1 is All Random
		EndIf
		string[] subList = StringUtil.Split(mainString[callBack], "_")
        ; 0 is Prefix, 1 is "random"
		entryQuest = GetFormValue(none, subList[0] + subList[Utility.RandomInt(2, subList.length - 1)]) as Quest
	else ; Base stuff.. yay!
		entryQuest = FormListGet(none,  "APS_Quests", _resultInt) as Quest
	EndIf
	FormListClear(none, "APS_Quests")
EndFunction

int Function OpenMenu(Form aForm = None, Form aReceiver = None)
	Debug.Trace("[AP] Opening Selection Menu")
	_resultFloat = -1.0
	_resultInt = -1
	_resultString = ""
	RegisterForModEvent("UIListMenu_LoadMenu", "OnLoadMenu")
	RegisterForModEvent("UIListMenu_CloseMenu", "OnUnloadMenu")
	RegisterForModEvent("UIListMenu_SelectItemText", "OnSelectText")
	RegisterForModEvent("UIListMenu_SelectItem", "OnSelect")
	Lock()
	UI.OpenCustomMenu("listmenu")
	If !WaitLock()
		return 0
	Endif
	If _resultFloat == -1.0 ; Back initiated
		return 0
	Endif
	return 1
EndFunction

int Function AddEntryItem(string entryName, int entryParent = -1, int entryCallback = -1, bool entryHasChildren = false)
	_entryName[_entryBuffer] = entryName
	_entryId[_entryBuffer] = _entryBuffer
	_entryParent[_entryBuffer] = entryParent
	_entryCallback[_entryBuffer] = entryCallback
	_entryChildren[_entryBuffer] = entryHasChildren
	int currentEntry = _entryBuffer
	_entryBuffer += 1
	return currentEntry
EndFunction
Function SetPropertyIndexBool(string propertyName, int index, bool value)
	If propertyName == "hasChildren"
		_entryChildren[index] = value
	Endif
EndFunction

Event OnSelect(string eventName, string strArg, float numArg, Form formArg)
	_resultInt = strArg as int
	_resultFloat = numArg
	Unlock()
EndEvent
Event OnSelectText(string eventName, string strArg, float numArg, Form formArg)
	_resultString = strArg
	; Do not unlock on this event, it's part of OnSelect sequence
EndEvent
Event OnLoadMenu(string eventName, string strArg, float numArg, Form formArg)
	string[] entries = Utility.CreateStringArray(_entryName.Length)
	int i = 0
	While i < _entryBuffer
		entries[i] = _entryName[i] + ";;" + _entryParent[i] + ";;" + _entryId[i] + ";;" + _entryCallback[i] + ";;" + (_entryChildren[i] as int)
		i += 1
	EndWhile
	
	UI.InvokeStringA("CustomMenu", "_root.listMenu." + "LM_AddTreeEntries", entries)
	UI.InvokeBool("CustomMenu", "_root.listMenu." + "LM_SetSortingEnabled", _sortEnabled)
EndEvent
Event OnUnloadMenu(string eventName, string strArg, float numArg, Form formArg)
	UnregisterForModEvent("UIListMenu_LoadMenu")
	UnregisterForModEvent("UIListMenu_CloseMenu")
	UnregisterForModEvent("UIListMenu_SelectItem")
EndEvent

; =========================================================
; ============================== DIALOGUE BUILDING
; =========================================================
Function SetEntryQuestRandom()
	Int index = Utility.RandomInt(0, startingQuests.Length - 1)
	Debug.Trace("AP -> " + _entryName[index])
	entryQuest = startingQuests[index]
	_entryChoice = index
EndFunction

Function SetEntryQuestNative(int index)
	Debug.Trace("AP -> Setting Entry Quest " + startingQuests[index] + " = " + startingQuests[index].GetId())
	Debug.Trace("AP -> " + _entryName[index])
	entryQuest = startingQuests[index]
	_entryChoice = index
EndFunction

Function SetEntryQuestNativeRandom(int lower, int upper)
	Int index = Utility.RandomInt(lower, upper)
	Debug.Trace("AP -> " + _entryName[index])
	entryQuest = startingQuests[index]
	_entryChoice = index
EndFunction

Function SetEntryQuestCustom(Quest that)
	entryQuest = that
EndFunction

; =========================================================
; ============================== ENTER GAME
; =========================================================
Function enterGame()
	Actor Player = Game.GetPlayer()
	ObjectReference PlayerRef = Game.GetPlayer()
	Cell startcell = Player.GetParentCell()
	; Start Intro Quest
	Player.SetDontMove(true)
	FadeToBlackHoldImod.Apply()
	If(!entryQuest) ; default Quests
		PlayerRef.MoveTo(helgenInnMarker)
	ElseIf(entryQuest.Start() == false)
		Debug.MessageBox("Failed to start Intro Quest with ID = " + entryQuest.GetFormID() + "\nMoving you to Helgen Inn..")
		PlayerRef.MoveTo(helgenInnMarker)
	EndIf

	if (_entryChoice != -1)
		Debug.MessageBox("A new start... " + _entryName[_entryChoice])
	endif

	; Wait for the Player to leave the Starting Cell, then finish it up
	int timeout = 25
	While(Player.GetParentCell() == startcell && timeout > 0)
		timeout -= 1
		Utility.Wait(0.2)
	EndWhile
	If(timeout == 0)
		Debug.MessageBox("You seem to be stuck. I'll move you into the Helgen Inn D:\nNormally a starting Option is expected to move you out of this cell. If this happens every time you use this Starting Option, you should get in touch with the Author that implemented it.\nQuest ID = " + entryQuest.GetFormID())
		PlayerRef.MoveTo(helgenInnMarker)

	EndIf
	Player.SetDontMove(false)
	FadeToBlackHoldImod.PopTo(FadeToBlackBackImod)
	; ((Self as Quest) as APDialogueHelgen).SetPositions()
	Free()
	Game.RequestSave()
EndFunction

Function Free()
	string[] mainString = StringListToArray(none, "APS_mainListIntern")
	int i = 0
	While(i < mainString.length)
		string[] subListUI = StringUtil.Split(mainString[i], "_")
		string prefix = subListUI[0]
		int n = 1 ; Skip first Line, is Prefix
		While(n < subListUI.length)
			If(StringUtil.GetNthChar(subListUI[n], 0) == "~")
				string[] tmp = StringUtil.Split(subListUI[n], "~")
				tmp = StringUtil.Split(tmp[0], ":")
				FormListClear(none, tmp[1])
			EndIf
			SetFormValue(none, prefix + subListUI[n], none)
			n += 1
		EndWhile
		i += 1
	EndWhile
	StringListClear(none, "APS_mainListUI")
	StringListClear(none, "APS_mainListIntern")
EndFunction
