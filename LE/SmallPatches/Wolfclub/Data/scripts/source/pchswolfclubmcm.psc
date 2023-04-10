Scriptname pchsWolfclubMCM extends SKI_ConfigBase  

int aOID
int bOID
int cOID
int dOID

int aOID_T
int bOID_T
int cOID_T
int dOID_T
int eOID_T
int fOID_T
int gOID_T

bool aVal = false;
bool bVal = false;
bool cVal = false;
bool dVal = false

event OnConfigInit()
    Pages = new string[2]
    Pages[0] = "General"
    Pages[1] = "Debug"
endEvent

event OnPageReset(string page)
	SetCursorFillMode(TOP_TO_BOTTOM)

		;Is the quest running?
		string QuestStatus = ""
		if (WolfclubQuest.IsRunning() == true)
			QuestStatus = "Yes"
		elseIf (WolfclubQuest.IsRunning() == false)
			QuestStatus = "No"
		endIf

		;What is the quest stage?
		;string QuestStage = WolfclubQuest.GetStage()
		string QuestStage = WolfclubStage.GetValueInt()

		;Convert counters to strings
		string cSC = ServeCount.GetValue()
		string cTSC = TotalServeCount.GetValueInt()
	
	if (page == "General")
		AddHeaderOption("Mod status")
		AddTextOption("Mod started :", QuestStatus)
		AddTextOption("Quest stage :", QuestStage)
		AddEmptyOption()
		AddHeaderOption("Player state")
		AddTextOption("Current unclaimed customers served:", cSC)
		;AddTextOption("Total customers served:", cTSC)
	elseIf (page == "Debug")
		;AddEmptyOption()
		AddHeaderOption("Debugging")
		aOID_T = AddTextOption("Force unequip shackles", "")
		bOID_T = AddTextOption("Fix bandits behaviour", "")
		gOID_T = AddTextOption("Unstuck player", "")
		AddEmptyOption()
		cOID_T = AddTextOption("Debug Yoren the Butcher", "")
		dOID_T = AddTextOption("Debug Darren", "")
		eOID_T = AddTextOption("Debug Rob", "")
		fOID_T = AddTextOption("Reset food/drink jobs", "")
	endIf

endEvent


event OnOptionSelect(int option)
	if (option == aOID_T)
		Game.GetPlayer().UnequipAll()
		Debug.Notification("Wolfclub: shackles are now unlocked")
		Utility.Wait(1.0)

	elseIf (option == bOID_T)
		Game.GetPlayer().RemoveFromFaction(BanditAllyFaction)
		Debug.Notification("Wolfclub: Player removed from BanditAllyFaction")
		Utility.Wait(1.0)

	elseIf (option == cOID_T)
		Yoren.Resurrect()
		Yoren.Disable()
		Yoren.MoveTo(Game.GetPlayer())
		Yoren.Enable()
		Yoren.EvaluatePackage()
		Debug.Notification("Yoren was reset!")
		Utility.Wait(1.0)

	elseIf (option == dOID_T)
		Alfred.Resurrect()
		Alfred.Disable()
		Alfred.MoveTo(Game.GetPlayer())
		Alfred.Enable()
		Alfred.EvaluatePackage()
		Debug.Notification("Alfred was reset!")
		Utility.Wait(1.0)

	elseIf (option == eOID_T)
		Rob.Resurrect()
		Rob.Disable()
		Rob.MoveTo(Game.GetPlayer())
		Rob.Enable()
		Rob.EvaluatePackage()
		Debug.Notification("Rob was reset!")
		Utility.Wait(1.0)

	elseIf (option == fOID_T)
		WolfclubStage.SetValueInt(0)
		FetchingFood.SetValueInt(0)
		FetchingVenison.SetValueInt(0)
		FetchingApple.SetValueInt(0)
		FetchingSoup.SetValueInt(0)
		FetchingDrink.SetValueInt(0)
		FetchingMead.SetValueInt(0)
		FetchingWine.SetValueInt(0)
		Debug.Notification("Food/drink jobs reset!")
		Utility.Wait(1.0)

	elseIf (option == gOID_T)
		Game.DisablePlayerControls(0, 0, 0, 0, 0, 0, 0)
		Game.SetPlayerAIDriven(false)
		Game.GetPlayer().PlayIdle(ResetIdle)
		Debug.Notification("Player unstuck!")
		Utility.Wait(1.0)

	endIf


	if (option == aOID)
        	aVal = !aVal
        	SetToggleOptionValue(aOID, aVal)

    	elseIf (option == bOID)
        	bVal = !bVal
        	SetToggleOptionValue(bOID, bVal)

	endIf
endEvent


event OnOptionDefault(int option)
    	if (option == aOID_T)
       		aVal = false
        	SetToggleOptionValue(aOID_T, aVal)

    	elseIf (option == bOID_T)
        	bVal = false
        	SetToggleOptionValue(bOID_T, bVal)

    	endIf
endEvent


event OnOptionHighlight(int option)
    if (option == aOID_T)
        	SetInfoText("Use if you cannot unequip shackles added by Wolfclub.")

	elseIf (option == bOID_T)
		SetInfoText("Use if you have issues with bandits not attacking you (where they are supposed to).")

	elseIf (option == cOID_T)
		SetInfoText("Use this if Yoren is stuck in scene or otherwise broken..")
	
	elseIf (option == dOID_T)
		SetInfoText("Use this if Alfred is stuck in scene or otherwise broken..")

	elseIf (option == eOID_T)
		SetInfoText("Use this if Rob is stuck in scene or otherwise broken..")

	elseIf (option == fOID_T)
		SetInfoText("Use this if you are stuck with food/drink jobs.")

	elseIf (option == fOID_T)
		SetInfoText("Use this if you can't move, use menu, turn camera, etc.")

	endIf
endEvent


Quest Property WolfclubQuest Auto
GlobalVariable Property ServeCount Auto
GlobalVariable Property TotalServeCount Auto
Faction Property BanditAllyFaction Auto
Actor Property Yoren Auto
Actor Property Alfred Auto
Actor Property Rob Auto
Idle Property ResetIdle Auto
GlobalVariable Property WolfclubStage Auto
GlobalVariable Property FetchingFood Auto
GlobalVariable Property FetchingVenison Auto
GlobalVariable Property FetchingApple Auto
GlobalVariable Property FetchingSoup Auto
GlobalVariable Property FetchingDrink Auto
GlobalVariable Property FetchingMead Auto
GlobalVariable Property FetchingWine Auto