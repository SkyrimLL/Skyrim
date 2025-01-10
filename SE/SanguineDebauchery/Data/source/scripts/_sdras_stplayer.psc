Scriptname _sdras_stplayer extends ReferenceAlias  


ReferenceAlias Property PlayerAlias  Auto  
SexLabFramework     property SexLab Auto

Quest Property SLS_PlayerAliciaQuest  Auto  
ReferenceAlias Property SanguineAlias  Auto  

; objectreference property SLS_PlayerNordQueenStorage auto

ObjectReference DremoraSlaver 


bool  bIsPregnant = false 
bool  bBeeingFemale = false 
bool  bEstrusChaurus = false 
spell  BeeingFemalePregnancy 
spell  ChaurusBreeder 

int daysPassed
int iGameDateLastCheck = -1
int iDaysSinceLastCheck
int iDebtLastCheck


Event OnInit()
	_maintenance()
	RegisterForSingleUpdate(10)
EndEvent

Event OnPlayerLoadGame()
	_maintenance()
	RegisterForSingleUpdate(10)
EndEvent


Function _Maintenance()
	Actor PlayerActor= Game.GetPlayer() as Actor

	If (!StorageUtil.HasIntValue(none, "_SLS_iStoriesPlayerAlicia"))
	 	StorageUtil.SetIntValue(none, "_SLS_iStoriesPlayerAlicia", 0)
	EndIf

	Debug.Trace("[SD] Registering Alicia player start")
	; Debug.Notification("[SD] Registering Alicia player start")

	UnregisterForAllModEvents()
	; Debug.Trace("SexLab Stories: Reset SexLab events")
	; RegisterForModEvent("AnimationStart", "OnSexLabStart")
	RegisterForModEvent("AnimationEnd",   "OnSexLabEnd")
	RegisterForModEvent("OrgasmStart",    "OnSexLabOrgasm")

	RegisterForModEvent("_SLS_PlayerAlicia", "OnPlayerAlicia")

	_InitExternalPregancy()

EndFunction

Event OnUpdate()
 	Actor PlayerActor= Game.GetPlayer() as Actor

	If (StorageUtil.GetIntValue(none, "_SLS_iStoriesPlayerAlicia")==0)
		Return
	endif

 	daysPassed = Game.QueryStat("Days Passed")

 	; Initial values
 	if (iGameDateLastCheck == -1)
 		iGameDateLastCheck = daysPassed
 	endIf
 
	iDaysSinceLastCheck = (daysPassed - iGameDateLastCheck ) as Int

	If (iDaysSinceLastCheck > 0)
		; iDebtLastCheck = PlayerRedWaveDebt.GetValue() as Int

	elseIf (StorageUtil.GetIntValue(none, "_SLS_iStoriesPlayerAlicia")==1)
		; _RefreshQueenFX()

	endIf

	iGameDateLastCheck = daysPassed  

	RegisterForSingleUpdate(10)
EndEvent



Event OnPlayerAlicia(String _eventName, String _args, Float _argc = -1.0, Form _sender)
 	Actor kActor = _sender as Actor
 	Actor PlayerActor= Game.GetPlayer() as Actor

	StorageUtil.SetIntValue(none, "_SLS_iStoriesPlayerAlicia", 1)

	If (!(StorageUtil.HasIntValue(none, "_SLS_iPlayerStartAlicia")))
		StorageUtil.SetIntValue(none, "_SLS_iPlayerStartAlicia", 0)
	EndIf

	SLS_PlayerAliciaQuest.SetStage(10)

	; Equip with sanguine bindings only
	; Rest of gear is normal
	; 	- restrictive collar
	; 	- harness or corset
	; 	- boots

	; PlayerActor.SendModEvent("SDEquipDevice",   "Blindfold")
	; PlayerActor.SendModEvent("SDEquipDevice",   "LegCuffs")

	RegisterForSingleUpdate(10)

EndEvent



Event OnSexLabStart(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= PlayerAlias.GetReference()
	Actor PlayerActor= PlayerAlias.GetReference() as Actor
	Float fBreastScale 

 
	if !Self || !SexLab || (StorageUtil.GetIntValue(none, "_SLS_iStoriesPlayerAlicia")==0)
	;	Debug.Trace("SexLab Stories: Critical error on SexLab Start")
		Return
	EndIf

	If (StorageUtil.GetIntValue(none, "_SLS_iStoriesPlayerAlicia")==0)
		Return
	endif
	
	; Debug.Notification("SexLab Hormones: Sex start")

	Actor[] actors = SexLab.HookActors(_args)
	Actor   victim = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim
	
	; Debug.Notification("Has player: " + _hasPlayer(actors))
	; Debug.Notification("Arousal trigger: " + (slaUtil.GetActorExposure(akRef = PlayerActor) / 3))

	; If (_hasPlayer(actors))

	; EndIf

	; Debug.Notification("SexLab Hormones: Forced refresh flag: " + StorageUtil.GetIntValue(none, "_SLH_iForcedRefresh"))
	
	If victim	;none consensual
		;

	Else        ;consensual
		;
		
	EndIf


EndEvent

Event OnSexLabEnd(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= PlayerAlias.GetReference()
	Actor PlayerActor= PlayerAlias.GetReference() as Actor
	ActorBase pActorBase = PlayerActor.GetActorBase()
    sslBaseAnimation animation = SexLab.HookAnimation(_args)
    Float fBreastScale 

	if !Self || !SexLab  || (StorageUtil.GetIntValue(none, "_SLS_iStoriesPlayerAlicia")==0)
	;	Debug.Trace("SexLab Stories: Critical error on SexLab End")
		Return
	EndIf


	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim
	
	; if config.bDebugMsg
	; 	_listActors("End: ", actors)
	; EndIf

	; If (_hasPlayer(actors))
		;
	; EndIf

 
EndEvent 

Event OnSexLabOrgasm(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= PlayerAlias.GetReference()
	Actor PlayerActor= PlayerAlias.GetReference() as Actor
	Float fBreastScale 

	if !Self || !SexLab  || (StorageUtil.GetIntValue(none, "_SLS_iStoriesPlayerAlicia")==0)
	;	Debug.Trace("SexLab Stories: Critical error on SexLab Orgasm")
		Return
	EndIf

	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim

	If (_hasPlayer(actors))

	EndIf
	
EndEvent





Function _InitExternalPregancy()
	bEstrusChaurus = false
	bBeeingFemale = false
	int idx = Game.GetModCount()
	string modName = ""
	while idx > 0
	idx -= 1
	modName = Game.GetModName(idx)

	if modName == "EstrusChaurus.esp"
	  bEstrusChaurus = true
	  ChaurusBreeder = Game.GetFormFromFile(0x00019121, modName) as spell

	elseif modName == "BeeingFemale.esm"
	  bBeeingFemale = true
	  BeeingFemalePregnancy = Game.GetFormFromFile(0x000028A0, modName) as spell
	endif
	endWhile
EndFunction

bool function isPregnantBySoulGemOven(actor kActor) 
  	return (StorageUtil.GetIntValue(Game.GetPlayer(), "sgo_IsBellyScaling") == 1) || (StorageUtil.GetIntValue(Game.GetPlayer(), "sgo_IsBreastScaling ") == 1)

endFunction

bool function isPregnantBySimplePregnancy(actor kActor) 
  	return StorageUtil.HasFloatValue(kActor, "SP_Visual")

endFunction

bool function isPregnantByBeeingFemale(actor kActor)
	 if ( (bBeeingFemale==true) &&  ( (StorageUtil.GetIntValue(kActor, "FW.CurrentState")>=4) && (StorageUtil.GetIntValue(kActor, "FW.CurrentState")<=8))  )
    	return true
	endIf
	return false
endFunction
 
bool function isPregnantByEstrusChaurus(actor kActor)
	if bEstrusChaurus==true && ChaurusBreeder != none
	return kActor.HasSpell(ChaurusBreeder)
	endIf
	return false
endFunction

bool function isPregnant(actor kActor)
	bIsPregnant = ( isPregnantBySoulGemOven(kActor) || isPregnantBySimplePregnancy(kActor) || isPregnantByBeeingFemale(kActor) || isPregnantByEstrusChaurus(kActor) || ((StorageUtil.GetIntValue(Game.GetPlayer(), "PSQ_SuccubusON") == 1) && (StorageUtil.GetIntValue(Game.GetPlayer(), "PSQ_SoulGemPregnancyON") == 1)) )
EndFunction

Bool function isFemale(actor kActor)
	Bool bIsFemale
	ActorBase kActorBase = kActor.GetActorBase()

	if (kActorBase.GetSex() == 1) ; female
		bIsFemale = True
	Else
		bIsFemale = False
	EndIf

	return bIsFemale
EndFunction


Bool Function _hasPlayer(Actor[] _actors)
	ObjectReference PlayerREF= PlayerAlias.GetReference()

	int idx = 0
	while idx < _actors.Length
		if _actors[idx] == PlayerRef
			return True
		endif
		idx += 1
	endwhile
	Return False
EndFunction

Bool Function _hasActor(Actor[] _actors, Actor thisActor)

	int idx = 0
	while idx < _actors.Length
		if _actors[idx] == thisActor as ObjectReference
			return True
		endif
		idx += 1
	endwhile
	Return False
EndFunction

Bool Function _hasRace(Actor[] _actors, Race thisRace)
	ActorBase aBase 
	Race aRace 
	Actor kPlayer = Game.GetPlayer()

	int idx = 0
	while idx < _actors.Length
		if (_actors[idx]) && (_actors[idx] != kPlayer )
			; aBase = _actors[idx].GetBaseObject() as ActorBase
			; aRace = aBase.GetRace()
			aRace = _actors[idx].GetLeveledActorBase().GetRace()
			if (aRace == thisRace)
				return True
			endif
		EndIf
		idx += 1
	endwhile
	Return False
EndFunction

