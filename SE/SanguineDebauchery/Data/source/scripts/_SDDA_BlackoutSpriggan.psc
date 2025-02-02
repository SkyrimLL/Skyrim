Scriptname _SDDA_BlackoutSpriggan extends _sd_daymoyl_questtemplate

GlobalVariable Property GameHour Auto

Location thisLocation
Actor thisPlayer
Actor thisAggressor

Bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
{Condition that must be satisfied for the quest to fire. Should be overloaded in the childs}
	Debug.Trace("[SDDA] Blackout Spriggan: condition")

	thisLocation = akLocation
	thisPlayer = Game.GetPlayer()
	thisAggressor = akAggressor

	Debug.Trace("[SDDA] Blackout Spriggan start enslavement attempt (Humanoid):" + thisAggressor)
	Debug.Trace("	start master is Creature:" + StorageUtil.GetIntValue( thisAggressor, "_SD_bIsSpriggan"))
	
	if (Utility.RandomInt(1,100)<=StorageUtil.GetIntValue(thisPlayer, "_SD_iChanceSprigganInfection")) && (StorageUtil.GetIntValue(thisPlayer, "_SD_iEnslavementInitSequenceOn")!=1) && (StorageUtil.GetIntValue( thisAggressor, "_SD_bIsSpriggan") == 1)  ; Simplified check for DA only - SD mod event will handle complex faction checks
		Debug.Trace("[SD DA integration] QuestCondition - Spriggan - Passed")
		return true
	else
		Debug.Trace("[SD DA integration] QuestCondition - Spriggan - Failed")
		return false
	endif

EndFunction

bool Function QuestStart(Location akLocation, Actor akAggressor, Actor akFollower)
	Debug.Trace("[SDDA] Blackout Spriggan: selected")
	
	SendModEvent("da_StartRecoverSequence", numArg = 100, strArg = "KeepBlackScreen") ;Without this the "fall through floor bug occurs"
	
	registerforsingleupdate(4)

	Debug.Trace("SD Blackout end master:" + thisAggressor)
	; Debug.Notification("Blackout end master:" + thisAggressor)

	if (thisAggressor)
		; Debug.Trace("[SD] Sending enslavement story.")
 		; StorageUtil.SetIntValue(thisAggressor, "_SD_iForcedSlavery", 1)
		; StorageUtil.SetIntValue(thisAggressor, "_SD_iSpeakingNPC", 1)
		thisAggressor.SendModEvent("SDSprigganEnslave")
	else
		Debug.Trace("[SDDA] Problem - Aggressor was reset before enslavement.")
	EndIf
	utility.wait(3)

	SendModEvent("da_StartRecoverSequence") ;The earlier call doesn't seem to clear the bleedout state so repeat the call
	
	return true
endFunction

Event OnUpdate()
	; Game.getplayer().moveto(SSLV_CageMark) 
	; SSLV_CageMark.Activate(Game.GetPlayer())


	; GameHour.Mod(8.0) ; wait 8 hours game time 
endevent

