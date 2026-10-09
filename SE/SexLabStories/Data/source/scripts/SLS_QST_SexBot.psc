Scriptname SLS_QST_SexBot extends Quest  
SexLabFramework Property SexLab  Auto  

ReferenceAlias Property SexBotAlias  Auto  

Quest Property SexBotControlQuest  Auto  

Armor Property SexBotBasicSkin Auto
Armor Property SexBotMixedSkin Auto
Armor Property SexBotPleasureSkin Auto
Armor Property SexBotEvolvedSkin Auto

Armor Property RefreshToken Auto

GlobalVariable Property SLS_SexBotOnOff  Auto  
GlobalVariable Property SexBotOilLevel Auto

Event OnInit()
	_Maintenance()
EndEvent

Function _Maintenance()
	ObjectReference SexBotREF= SexBotAlias.GetReference()
	Actor SexBotActor = SexBotAlias.GetReference() as Actor

	if SexBotActor

		StorageUtil.SetFormValue(none, "_SLS_fSexBot", SexBotActor as Form)

		ResetSexBotSkin()
        UpdateSexBotState()

		StorageUtil.SetIntValue(SexBotActor, "_SD_iRelationshipType" , 5 )
	endif

	UnregisterForAllModEvents()
	Debug.Trace("SexLab SexBot: Reset SexLab events")
	RegisterForModEvent("AnimationStart", "OnSexLabStart")
	RegisterForModEvent("AnimationEnd",   "OnSexLabEnd")
	RegisterForModEvent("OrgasmStart",    "OnSexLabOrgasm")

EndFunction

Function UpdateSexBotState()
	ObjectReference SexBotREF= SexBotAlias.GetReference()
	Actor SexBotActor = SexBotAlias.GetReference() as Actor

	if SexBotActor  
		int iEnergyLevel = StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel")
		float fEnergyLevel = StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel") as Float
		int iOilLevel = StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotOilLevel")

		Debug.Trace("[SLS_QST_SexBot] UpdateSexBotState: Energy Level: " + iEnergyLevel + " Oil Level: " + iOilLevel)

		if (iEnergyLevel <= 0) 
			StorageUtil.SetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel", 0)
		endif

		if (iOilLevel <= 0) 
			StorageUtil.SetIntValue(SexBotActor, "_SLS_SexBotOilLevel", 0)
		endif

		If (SexBotControlQuest.GetStageDone(20) == 0)
            StorageUtil.SetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel", 5)
			iEnergyLevel = StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel")
			fEnergyLevel = StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel") as Float
            SexBotActor.ForceAV("Health", 100 + (iEnergyLevel * 100) )
            SexBotActor.ForceAV("Stamina", 10 + (iEnergyLevel * 10) )
            SexBotActor.ForceAV("Magicka", 50 + (iEnergyLevel * 100) )
            SexBotActor.ForceAV("Destruction", 50 + (iEnergyLevel * 100) )
            SexBotActor.ForceAV("Illusion", 50 + (iEnergyLevel * 100) )
            SexBotActor.ForceAV("HealRate",  1.0 + (fEnergyLevel / 10.0) )
            SexBotActor.ForceAV("MagickaRate",  5.0 + (fEnergyLevel / 10.0) )
            SexBotActor.ForceAV("StaminaRate",  5.0 + (fEnergyLevel / 10.0) )

		Else
			SexBotActor.ForceAV("Health", 100 + (iEnergyLevel * 2) )
			SexBotActor.ForceAV("Stamina", 10 + (iEnergyLevel * 2) )
			SexBotActor.ForceAV("Magicka", 50 + (iEnergyLevel * 5) ) 
            SexBotActor.ForceAV("Destruction", 50 + (iEnergyLevel * 5) )
            SexBotActor.ForceAV("Illusion", 50 + (iEnergyLevel * 5) )
            SexBotActor.ForceAV("HealRate",  1.0 + (fEnergyLevel / 10.0) )
            SexBotActor.ForceAV("MagickaRate",  3.0 + (fEnergyLevel / 10.0) )
            SexBotActor.ForceAV("StaminaRate",  5.0 + (fEnergyLevel / 10.0) )

		endif
	endif
EndFunction 

Function ResetSexBotSkin()
	ObjectReference SexBotREF= SexBotAlias.GetReference()
	Actor SexBotActor = SexBotAlias.GetReference() as Actor

	if SexBotActor
		ActorBase akActorBase = SexBotActor.GetActorBase()

		String currentSkin = StorageUtil.GetStringValue(SexBotActor, "_SLS_SexBotSkin")

		if (currentSkin == "") || (currentSkin == "Basic")
			akActorBase.SetSkin(SexBotBasicSkin)
			StorageUtil.SetStringValue(SexBotActor, "_SLS_SexBotSkin", "Basic")
		elseif (currentSkin == "Mixed")
			akActorBase.SetSkin(SexBotMixedSkin)
			StorageUtil.SetStringValue(SexBotActor, "_SLS_SexBotSkin", "Mixed")
		elseif (currentSkin == "Pleasure")
			akActorBase.SetSkin(SexBotPleasureSkin)
			StorageUtil.SetStringValue(SexBotActor, "_SLS_SexBotSkin", "Pleasure")
		elseif (currentSkin == "Evolved")
			akActorBase.SetSkin(SexBotEvolvedSkin)
			StorageUtil.SetStringValue(SexBotActor, "_SLS_SexBotSkin", "Evolved")
		endif
		SexBotREF.AddItem(RefreshToken, 1)
		SexBotActor.EquipItem(RefreshToken)
		SexBotREF.RemoveItem(RefreshToken)
		SexBotActor.EvaluatePackage()
		; StorageUtil.SetIntValue(SexBotActor, "_SD_iCanBeEnslaved", 0)
		StorageUtil.SetIntValue(SexBotActor, "_SD_iCanBeStripped", -1)
	endif
EndFunction

Event OnSexLabStart(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference SexBotREF= SexBotAlias.GetReference()
	Actor SexBotActor= SexBotAlias.GetReference() as Actor

	if !Self || !SexLab 
		Debug.Trace("SexLab SexBot: Critical error on SexLab Start")
		Return
	EndIf
	
	Actor[] actors = SexLab.HookActors(_args)
	Actor   victim = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim

	; If (_hasPlayer(actors))

	; EndIf

	If (_hasActor(actors, SexBotActor))
		Int iOilLevel = SexBotOilLevel.GetValue() as Int

		SexBotOilLevel.SetValue(iOilLevel - 1)

		StorageUtil.SetIntValue(SexBotActor, "_SLS_SexBotOilLevel", SexBotOilLevel.GetValue() as Int)

		Debug.Notification("Energy level: " + StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel") )
		Debug.Notification("Lubrication level: " + StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotOilLevel") )

	Else        
		;
		
	EndIf


EndEvent

Event OnSexLabEnd(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference SexBotREF= SexBotAlias.GetReference()
	Actor SexBotActor= SexBotAlias.GetReference() as Actor

	if !Self || !SexLab 
		Debug.Trace("SexLab SexBot: Critical error on SexLab End")
		Return
	EndIf


	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim
	
	If (_hasActor(actors, SexBotActor)) ; || ((_hasPlayer(actors)) && animation.HasTag("Dwemer")) )
		; Debug.Trace("SexLab Stories: Orgasm!")
        StorageUtil.SetIntValue(SexBotActor, "_SLS_LastSexDate", Game.QueryStat("Days Passed"))

		; If (SLS_SexBotOnOff.GetValue() == 0)
			SLS_SexBotOnOff.SetValue(1) 
			; StorageUtil.SetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel", 1)

			Debug.Notification("E.L.L.E is now recharged")
			SexBotActor.EvaluatePackage()
			Utility.Wait(1.0)
			; Debug.SendAnimationEvent(Target, "IdleForceDefaultState")	
		; EndIf

		SexBotControlQuest.SetObjectiveDisplayed(22, false)

        StorageUtil.SetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel", StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel") + 1)
		UpdateSexBotState()

    	if SexBotActor.IsInFaction(FalmerFaction)
    		SexBotActor.RemoveFromFaction(FalmerFaction)
    	endif
	EndIf

EndEvent 

Event OnSexLabOrgasm(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference SexBotREF= SexBotAlias.GetReference()
	Actor SexBotActor= SexBotAlias.GetReference() as Actor
    sslBaseAnimation animation = SexLab.HookAnimation(_args)
	

	if !Self || !SexLab 
		Debug.Trace("SexLab Stories: Critical error on SexLab Orgasm")
		Return
	EndIf

	Actor[] actors  = SexLab.HookActors(_args)
	Actor   victim  = SexLab.HookVictim(_args)
	Actor[] victims = new Actor[1]
	victims[0] = victim

	If (_hasActor(actors, SexBotActor)) ; || ((_hasPlayer(actors)) && animation.HasTag("Dwemer")) )
		; Debug.Trace("SexLab Stories: Orgasm!") 

		; If (SLS_SexBotOnOff.GetValue() == 0)
			SLS_SexBotOnOff.SetValue(1) 
			; StorageUtil.SetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel", 1)

			; Debug.Notification("E.L.L.E is now recharged")

			; ELLE is recharged - set Confidence to Coward
            SexBotActor.ForceAV("Aggression", 1 )
            SexBotActor.ForceAV("Confidence", 4 )
			SexBotActor.EvaluatePackage()
			Utility.Wait(1.0)
			; Debug.SendAnimationEvent(Target, "IdleForceDefaultState")	
		; EndIf

		; SexBotControlQuest.SetObjectiveDisplayed(22, false)

        StorageUtil.SetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel", StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel") + 1)
        UpdateSexBotState()

    	Debug.trace("[SLS_QST_SexBot] _SLS_SexBotEnergyLevel: " + StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel"))
	EndIf
	
EndEvent


int function iMin(int a, int b)
	if (a<=b)
		return a
	else
		return b
	EndIf
EndFunction

int function iMax(int a, int b)
	if (a<b)
		return b
	else
		return a
	EndIf
EndFunction

float function fMin(float  a, float b)
	if (a<=b)
		return a
	else
		return b
	EndIf
EndFunction

float function fMax(float a, float b)
	if (a<b)
		return b
	else
		return a
	EndIf
EndFunction

Bool Function _hasPlayer(Actor[] _actors)
	ObjectReference PlayerREF= Game.GetPlayer() as ObjectReference

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
		if _actors[idx] == thisActor 
			return True
		endif
		idx += 1
	endwhile
	Return False
EndFunction

Bool Function _hasRace(Actor[] _actors, Race thisRace)
	ActorBase aBase 
	Race aRace 

	int idx = 0
	while idx < _actors.Length
		if (_actors[idx])
			; aBase = _actors[idx].GetBaseObject() as ActorBase
			aRace = _actors[idx].GetLeveledActorBase().GetRace()
			if aRace == thisRace
				return True
			endif
		EndIf
		idx += 1
	endwhile
	Return False
EndFunction

Faction Property FalmerFaction  Auto  
