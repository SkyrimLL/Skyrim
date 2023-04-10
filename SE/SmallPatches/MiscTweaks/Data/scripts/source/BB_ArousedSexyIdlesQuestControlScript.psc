Scriptname BB_ArousedSexyIdlesQuestControlScript extends Quest  

int Property ModID Auto
int Property mtidle_base Auto
int Property ModCRC Auto
GlobalVariable Property BB_ArousedSexyIdlesUpdateTime Auto
Quest Property BB_ArousedSexyIdlesQuest Auto
bool Updating = false

Event OnInit()
	ModCRC = FNIS_aa.GetInstallationCRC()
	if ModCRC == 0
		;
	else
		ModID = FNIS_aa.GetAAModID("asi", "ArousedSexyIdles", true)
		mtidle_base = FNIS_aa.GetGroupBaseValue(ModID, FNIS_aa._mtidle(), "ArousedSexyIdles", true)
	endif
	RegisterForModEvent("sla_UpdateComplete", "OnArousalComputed")
	RestartQuest()
	RegisterForSingleUpdate(BB_ArousedSexyIdlesUpdateTime.Value)
endEvent

Event OnArousalComputed(string eventName, string argString, float argNum, form sender)
	RestartQuest()
endEvent

Event OnUpdate()
	RestartQuest()
	RegisterForSingleUpdate(BB_ArousedSexyIdlesUpdateTime.Value)
endEvent

Function RestartQuest()
	if Updating == false
		Updating = true
		BB_ArousedSexyIdlesQuest.Stop()
		BB_ArousedSexyIdlesQuest.Start()
		Utility.Wait(5)
		Updating = false
	endif
endFunction