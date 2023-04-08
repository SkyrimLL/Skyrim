Scriptname _mindScript extends ReferenceAlias  

ReferenceAlias Property refCharm1 Auto
ReferenceAlias Property refCharm2 Auto
ReferenceAlias Property refCharm3 Auto
ReferenceAlias Property refCharm4 Auto
ReferenceAlias Property refCharm5 Auto
ReferenceAlias Property refWait1 Auto
ReferenceAlias Property refWait2 Auto
ReferenceAlias Property refWait3 Auto
ReferenceAlias Property refWait4 Auto
ReferenceAlias Property refWait5 Auto
ReferenceAlias Property refFollow1 Auto
ReferenceAlias Property refFollow2 Auto
ReferenceAlias Property refFollow3 Auto
ReferenceAlias Property refFollow4 Auto
ReferenceAlias Property refFollow5 Auto
ReferenceAlias Property refFreeze1 Auto
ReferenceAlias Property refFreeze2 Auto
ReferenceAlias Property refFreeze3 Auto
ReferenceAlias Property refFreeze4 Auto
ReferenceAlias Property refFreeze5 Auto
ReferenceAlias Property refMarker1 Auto
ReferenceAlias Property refGoMarker1 Auto
ReferenceAlias Property refGoMarker2 Auto
ReferenceAlias Property refGoMarker3 Auto
ReferenceAlias Property refGoMarker4 Auto
ReferenceAlias Property refGoMarker5 Auto
ReferenceAlias Property refTravel1 Auto
ReferenceAlias Property refTravel2 Auto
ReferenceAlias Property refTravel3 Auto
ReferenceAlias Property refTravel4 Auto
ReferenceAlias Property refTravel5 Auto
ReferenceAlias Property refTravelMarker1 Auto
ReferenceAlias Property refTravelMarker2 Auto
ReferenceAlias Property refTravelMarker3 Auto
ReferenceAlias Property refTravelMarker4 Auto
ReferenceAlias Property refTravelMarker5 Auto
ReferenceAlias Property refBound1 Auto
ReferenceAlias Property refBound2 Auto
ReferenceAlias Property refBound3 Auto
ReferenceAlias Property refBound4 Auto
ReferenceAlias Property refBound5 Auto
ReferenceAlias Property refBound6 Auto
ReferenceAlias Property refBound7 Auto
ReferenceAlias Property refBound8 Auto
ReferenceAlias Property refBound9 Auto
ReferenceAlias Property refBound10 Auto
GlobalVariable Property globalMarker Auto
Keyword Property npcKeyword Auto
Perk Property mindPerk Auto
Message Property msgConfidence Auto
Message Property msgAggression Auto
ImpactDataSet Property bloodImpact Auto
ImpactDataSet Property urinateImpact Auto
ImpactDataSet Property defecateImpact Auto
Sound Property urinateSound Auto
Sound Property defecateSound1 Auto
Sound Property defecateSound2 Auto
Sound Property defecateSound3 Auto
Potion Property defecateItem Auto
SexLabFramework Property SexLab Auto
Message Property actionMessage Auto
Idle Property beatdown Auto
Quest Property configQuest Auto
GlobalVariable Property globalStop Auto
Spell[] Property playerSpells Auto
GlobalVariable Property allowSpells Auto
GlobalVariable Property allowCharmSpell Auto
Faction Property undressedFaction Auto
Faction Property boundFaction Auto
Outfit Property nakedOutfit Auto
Faction Property decideFaction Auto
Message[] Property poseMessages Auto

Actor Property iSexActor1 Auto
Actor Property iSexActor2 Auto
Actor Property iSexActor3 Auto
string Property iSexTag1 Auto
string Property iSexTag2 Auto
string Property iSexTag3 Auto
string Property iSexNoTag Auto
bool Property iSexStart Auto
int Property iSexBed Auto
int Property iTwoOthers Auto
int Property iAdjustType Auto
Actor Property iAdjustActor Auto
Actor Property iPeeActor Auto
Actor Property iDefecateActor Auto
Actor Property iBeatActor Auto
int[] Property iTravel Auto

int[] aggression
int[] confidence
int[] relationship
int[] morality
int curBasicKey
int moveType
int[] fTime
int[] fPrev
int[] charmData
int istate
Outfit[] defOutfit
float[] modSpeed
int lastPose
int curPeeType
int curPeeSound
int curPeeTimer
sslThreadController curPeeScene

;/
Charmed flags:
1 - is following and we had to set teammate
2 - i decide what you wear
4 - i want you to be tough (+100k hp)
/;

event OnInit()
	aggression = new int[5]
	confidence = new int[5]
	relationship = new int[5]
	morality = new int[5]
	iTravel = new int[5]
	fTime = new int[5]
	fPrev = new int[5]
	charmData = new int[5]
	defOutfit = new Outfit[5]
	modSpeed = new float[5]
	lastPose = -1

	curBasicKey = 0
	istate = 0

	int i = 0
	while(i < 5)
		aggression[i] = -1
		confidence[i] = -1
		relationship[i] = -5
		morality[i] = -1
		i += 1
	endwhile

	Actor plr = Game.GetPlayer()
	if(plr && !plr.HasPerk(mindPerk))
		plr.AddPerk(mindPerk)
	endif

	globalStop.SetValue(0)

	RegisterForSingleUpdate(3)
endevent

event OnPlayerLoadGame()
	UpdateRelationship(refCharm1.GetReference() as Actor, 0)
	UpdateRelationship(refCharm2.GetReference() as Actor, 1)
	UpdateRelationship(refCharm3.GetReference() as Actor, 2)
	UpdateRelationship(refCharm4.GetReference() as Actor, 3)
	UpdateRelationship(refCharm5.GetReference() as Actor, 4)

	; Add mod events
	; PM_CharmPuppet
	; PM_GrantControlSpells
	; PM_GrantCharmSpells
	RegisterForModEvent("PMCharmPuppet",   "OnPMCharmPuppet")
	RegisterForModEvent("PMGrantControlSpells",   "OnPMGrantControlSpells")
	RegisterForModEvent("PMGrantCharmSpell",   "OnPMGrantCharmSpell")
	RegisterForModEvent("PMRemoveControlSpells",   "OnPMRemoveControlSpells")
	RegisterForModEvent("PMRemoveCharmSpell",   "OnPMRemoveCharmSpell")
endevent


Event OnPMCharmPuppet(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= Game.GetPlayer()
	Actor PlayerActor= Game.GetPlayer() as Actor
 	Actor kActor = _sender as Actor

 	if (kActor != None)
		Game.GetPlayer().DoCombatSpellApply( CharmSpell, kActor)
		StorageUtil.SetIntValue(Game.GetPlayer(), "Puppet_CastTarget", 0)
	EndIf
EndEvent


Event OnPMGrantControlSpells(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= Game.GetPlayer()
	Actor PlayerActor= Game.GetPlayer() as Actor
 	Actor kActor = _sender as Actor

 	if (kActor != None)
	EndIf

	allowSpells.SetValue(1)
	StorageUtil.SetIntValue(Game.GetPlayer(), "Puppet_SpellON", 1)
EndEvent


Event OnPMGrantCharmSpell(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= Game.GetPlayer()
	Actor PlayerActor= Game.GetPlayer() as Actor
 	Actor kActor = _sender as Actor

 	if (kActor != None)
	EndIf

	allowCharmSpell.SetValue(1)
	StorageUtil.SetIntValue(Game.GetPlayer(), "Puppet_CharmSpellON", 1)
EndEvent

Event OnPMRemoveControlSpells(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= Game.GetPlayer()
	Actor PlayerActor= Game.GetPlayer() as Actor
 	Actor kActor = _sender as Actor

 	if (kActor != None)
	EndIf

	allowSpells.SetValue(0)
	StorageUtil.SetIntValue(Game.GetPlayer(), "Puppet_SpellON", -1)
EndEvent


Event OnPMRemoveCharmSpell(String _eventName, String _args, Float _argc, Form _sender)
	ObjectReference PlayerREF= Game.GetPlayer()
	Actor PlayerActor= Game.GetPlayer() as Actor
 	Actor kActor = _sender as Actor

 	if (kActor != None)
	EndIf

 	allowCharmSpell.SetValue(0)
 	StorageUtil.SetIntValue(Game.GetPlayer(), "Puppet_CharmSpellON", -1)

EndEvent



function SetTough(Actor target, bool apply = true)
	if(!target || target.IsDead())
		return
	endif

	int index = GetCharmedIndex(target)
	if(index < 0)
		return
	endif

	if(apply)
		if(Math.LogicalAnd(charmData[index], 4) != 0)
			return
		endif

		charmData[index] = Math.LogicalOr(charmData[index], 4)
		target.ModActorValue("health", 100000.0)
	else
		if(Math.LogicalAnd(charmData[index], 4) == 0)
			return
		endif

		charmData[index] = Math.LogicalAnd(charmData[index], Math.LogicalNot(4))
		target.RestoreActorValue("health", 100000.0)
		target.ModActorValue("health", -100000.0)
	endif
endfunction

function StartPeeScene(Actor owner, Actor target, bool isPee = true)
	if(!owner || !target || !IsNPC(owner) || !IsNPC(target) || IsSex(owner) || IsSex(target) || curPeeType != 0)
		return
	endif

	ClearSex()
	iSexActor1 = target
	iSexActor2 = owner
	if(isPee)
		iSexTag1 = "pee"
		if(owner.GetLeveledActorBase() && owner.GetLeveledActorBase().GetSex() == 1)
			iSexTag2 = "Arrok Lesbian"
		else
			iSexTag2 = "AP Skull Fuck"
			iSexActor1 = owner
			iSexActor2 = target
		endif
	else
		iSexTag1 = "defec"
		iSexTag2 = "Arrok Anal"
	endif
	MoveTogether()
endfunction

event OnUpdate()
	CheckAliases()

	Actor plr = Game.GetPlayer()
	if(plr && !plr.HasPerk(mindPerk))
		plr.AddPerk(mindPerk)
	endif

	if(curPeeType < 0 && curPeeScene)
		if(curPeeType > -10)
			; nothing
			if(curPeeType == -2)
				curPeeScene.GoToStage(2)
				; curPeeScene.UpdateTimer(60.0)
			endif
		elseif(curPeeType > -30)
			if(curPeeType == -21 || curPeeType == -22)
			;	curPeeSound = urinateSound.Play(curPeeScene.GetActor(0))
			elseif(curPeeType == -23)
			;	PlayFart(curPeeScene.GetActor(0))
			endif
		elseif(curPeeType > -60)
			if(curPeeType == -53)
			;	PlayFart(curPeeScene.GetActor(0))
			endif
		elseif(curPeeType > -70)
			if(curPeeType == -61 || curPeeType == -62)
				Sound.StopInstance(curPeeSound)
				curPeeSound = 0
			elseif(curPeeType == -63)
				; do nothing
			endif
		elseif(curPeeType > -80)
			; do nothing
		else
			curPeeScene.EndAnimation()
			curPeeScene = none
			curPeeType = 10
		endif

		curPeeType -= 10
	elseif(curPeeType > 0)
		curPeeTimer += 1
		if(curPeeTimer >= 5)
			curPeeTimer = 0
			curPeeType = 0
			curPeeScene = none
		endif
	endif

	; if(plr && (istate == 0) != ((allowSpells.GetValue() as int) == 0))
		if((allowSpells.GetValue() as int) != 0)
			; istate = Math.LogicalOr(istate, 1)
			int q = 0
			while(playerSpells && q < playerSpells.Length)
				if(!plr.HasSpell(playerSpells[q])) && (playerSpells[q] != CharmSpell)
					plr.AddSpell(playerSpells[q], false)
				endif
				q += 1
			endwhile
		else
			; istate = Math.LogicalAnd(istate, Math.LogicalNot(1))
			int q = 0
			while(playerSpells && q < playerSpells.Length)
				if(plr.HasSpell(playerSpells[q])) && (playerSpells[q] != CharmSpell)
					plr.RemoveSpell(playerSpells[q])
				endif
				q += 1
			endwhile
		endif
	; endif

	; if(plr && (istate == 0) != ((allowCharmSpell.GetValue() as int) == 0))
		if((allowCharmSpell.GetValue() as int) != 0)

			if(!plr.HasSpell(CharmSpell))  
				plr.AddSpell(CharmSpell, false)
			endif

		else

			if(plr.HasSpell(CharmSpell))  
				plr.RemoveSpell(CharmSpell)
			endif

		endif
	; endif

	_mindConfig cfg = GetConfig()
	if(cfg && cfg.basicKey != curBasicKey)
		if(curBasicKey > 1)
			UnregisterForKey(curBasicKey)
		endif
		curBasicKey = cfg.basicKey
		if(curBasicKey > 1)
			RegisterForKey(curBasicKey)
		endif
	endif

	if(iAdjustActor)
		if(IsCharmed(iAdjustActor))
			if(iAdjustType == 1)
				int ret = msgConfidence.Show()
				if(ret >= 0 && ret < 5)
					SetPersonality(iAdjustActor, false, ret)
				endif
			else
				int ret = msgAggression.Show()
				if(ret >= 0 && ret < 4)
					SetPersonality(iAdjustActor, true, ret)
				endif
			endif
		endif
		iAdjustActor = none
	endif

	if(iSexStart)
		TryStartSex()
		ClearSex()
	endif

	if(iPeeActor)
		Pee(iPeeActor)
		iPeeActor = none
	endif

	if(iDefecateActor)
		Defecate(iDefecateActor)
		iDefecateActor = none
	endif

	if(iBeatActor)
		Beat(GetReference() as Actor, iBeatActor)
		iBeatActor = none
	endif

	UpdateFreeze()

	if((globalStop.GetValue() as int) == 0)
		RegisterForSingleUpdate(2)
	else
		ResetScript(true)
		if(plr)
			plr.RemovePerk(mindPerk)
		endif
		if(curBasicKey > 1)
			UnregisterForKey(curBasicKey)
		endif
		curBasicKey = 0
	endif
endevent

function UpdateFreeze()
	if(fTime[0] > 0)
		fTime[0] = fTime[0] - 1
		if(fTime[0] == 0)
			Actor target = refFreeze1.GetReference() as Actor
			if(target)
				Unfreeze(target)
			endif
		endif
	endif

	if(fTime[1] > 0)
		fTime[1] = fTime[1] - 1
		if(fTime[1] == 0)
			Actor target = refFreeze2.GetReference() as Actor
			if(target)
				Unfreeze(target)
			endif
		endif
	endif

	if(fTime[2] > 0)
		fTime[2] = fTime[2] - 1
		if(fTime[2] == 0)
			Actor target = refFreeze3.GetReference() as Actor
			if(target)
				Unfreeze(target)
			endif
		endif
	endif

	if(fTime[3] > 0)
		fTime[3] = fTime[3] - 1
		if(fTime[3] == 0)
			Actor target = refFreeze4.GetReference() as Actor
			if(target)
				Unfreeze(target)
			endif
		endif
	endif

	if(fTime[4] > 0)
		fTime[4] = fTime[4] - 1
		if(fTime[4] == 0)
			Actor target = refFreeze5.GetReference() as Actor
			if(target)
				Unfreeze(target)
			endif
		endif
	endif
endfunction

_mindConfig function GetConfig()
	return configQuest as _mindConfig
endfunction

function ClearSex()
	iSexActor1 = none
	iSexActor2 = none
	iSexActor3 = none
	iSexTag1 = ""
	iSexTag2 = ""
	iSexTag3 = ""
	iSexBed = 0
	iSexNoTag = ""
	iSexStart = false
	iTwoOthers = 0
endfunction

function SendShow()
	Debug.Notification("Use show power to target someone.")
endfunction

function SetFastMove(Actor target, bool apply = true)
	if(!target)
		return
	endif

	int index = GetCharmedIndex(target)
	if(index < 0)
		return
	endif

	if(apply)
		if(modSpeed[index] > 0.0)
			SetFastMove(target, false)
		endif

		Actor plr = Game.GetPlayer()
		float speed = 100.0
		float mspeed = target.GetActorValue("speedmult")
		if(plr)
			speed = plr.GetActorValue("speedmult")
		endif
		speed += 20.0

		if(mspeed < speed)
			mspeed = speed - mspeed
			modSpeed[index] = mspeed
			target.ModActorValue("speedmult", mspeed)
		endif
	else
		if(modSpeed[index] > 0.0)
			target.ModActorValue("speedmult", -modSpeed[index])
			modSpeed[index] = 0.0
		endif
	endif
endfunction

function ResetScript(bool silent = false)
	ClearSex()

	Untie(refBound1.GetReference() as Actor)
	Untie(refBound2.GetReference() as Actor)
	Untie(refBound3.GetReference() as Actor)
	Untie(refBound4.GetReference() as Actor)
	Untie(refBound5.GetReference() as Actor)
	Untie(refBound6.GetReference() as Actor)
	Untie(refBound7.GetReference() as Actor)
	Untie(refBound8.GetReference() as Actor)
	Untie(refBound9.GetReference() as Actor)
	Untie(refBound10.GetReference() as Actor)

	SetCharmed(refCharm1.GetReference() as Actor, false)
	refCharm1.Clear()
	SetCharmed(refCharm2.GetReference() as Actor, false)
	refCharm2.Clear()
	SetCharmed(refCharm3.GetReference() as Actor, false)
	refCharm3.Clear()
	SetCharmed(refCharm4.GetReference() as Actor, false)
	refCharm4.Clear()
	SetCharmed(refCharm5.GetReference() as Actor, false)
	refCharm5.Clear()

	SetNone(refFreeze1.GetReference() as Actor)
	refFreeze1.Clear()
	SetNone(refFreeze2.GetReference() as Actor)
	refFreeze2.Clear()
	SetNone(refFreeze3.GetReference() as Actor)
	refFreeze3.Clear()
	SetNone(refFreeze4.GetReference() as Actor)
	refFreeze4.Clear()
	SetNone(refFreeze5.GetReference() as Actor)
	refFreeze5.Clear()

	SetNone(refWait1.GetReference() as Actor)
	refWait1.Clear()
	SetNone(refWait2.GetReference() as Actor)
	refWait2.Clear()
	SetNone(refWait3.GetReference() as Actor)
	refWait3.Clear()
	SetNone(refWait4.GetReference() as Actor)
	refWait4.Clear()
	SetNone(refWait5.GetReference() as Actor)
	refWait5.Clear()

	SetNone(refFollow1.GetReference() as Actor)
	refFollow1.Clear()
	SetNone(refFollow2.GetReference() as Actor)
	refFollow2.Clear()
	SetNone(refFollow3.GetReference() as Actor)
	refFollow3.Clear()
	SetNone(refFollow4.GetReference() as Actor)
	refFollow4.Clear()
	SetNone(refFollow5.GetReference() as Actor)
	refFollow5.Clear()

	SetNone(refGoMarker1.GetReference() as Actor)
	refGoMarker1.Clear()
	SetNone(refGoMarker2.GetReference() as Actor)
	refGoMarker1.Clear()
	SetNone(refGoMarker3.GetReference() as Actor)
	refGoMarker1.Clear()
	SetNone(refGoMarker4.GetReference() as Actor)
	refGoMarker1.Clear()
	SetNone(refGoMarker5.GetReference() as Actor)
	refGoMarker1.Clear()

	SetNone(refTravel1.GetReference() as Actor)
	refTravel1.Clear()
	SetNone(refTravel2.GetReference() as Actor)
	refTravel2.Clear()
	SetNone(refTravel3.GetReference() as Actor)
	refTravel3.Clear()
	SetNone(refTravel4.GetReference() as Actor)
	refTravel4.Clear()
	SetNone(refTravel5.GetReference() as Actor)
	refTravel5.Clear()

	if(!silent)
		Debug.Notification("All targets have been released and untied!")
	endif
endfunction

function CheckAliases(bool onlyBound = false)
	if(!onlyBound)
		Actor rch
		CheckAlias(refCharm1)
		UpdatePuppet(refCharm1.GetReference() as Actor, 0)
		CheckAlias(refCharm2)
		UpdatePuppet(refCharm2.GetReference() as Actor, 1)
		CheckAlias(refCharm3)
		UpdatePuppet(refCharm3.GetReference() as Actor, 2)
		CheckAlias(refCharm4)
		UpdatePuppet(refCharm4.GetReference() as Actor, 3)
		CheckAlias(refCharm5)
		UpdatePuppet(refCharm5.GetReference() as Actor, 4)

		CheckAlias(refFollow1)
		CheckAlias(refFollow2)
		CheckAlias(refFollow3)
		CheckAlias(refFollow4)
		CheckAlias(refFollow5)

		CheckAlias(refWait1)
		CheckAlias(refWait2)
		CheckAlias(refWait3)
		CheckAlias(refWait4)
		CheckAlias(refWait5)

		CheckAlias(refFreeze1)
		CheckAlias(refFreeze2)
		CheckAlias(refFreeze3)
		CheckAlias(refFreeze4)
		CheckAlias(refFreeze5)

		CheckAlias(refGoMarker1)
		CheckAlias(refGoMarker2)
		CheckAlias(refGoMarker3)
		CheckAlias(refGoMarker4)
		CheckAlias(refGoMarker5)

		CheckAlias(refTravel1)
		CheckAlias(refTravel2)
		CheckAlias(refTravel3)
		CheckAlias(refTravel4)
		CheckAlias(refTravel5)
	endif

	CheckAlias(refBound1, true)
	CheckAlias(refBound2, true)
	CheckAlias(refBound3, true)
	CheckAlias(refBound4, true)
	CheckAlias(refBound5, true)
	CheckAlias(refBound6, true)
	CheckAlias(refBound7, true)
	CheckAlias(refBound8, true)
	CheckAlias(refBound9, true)
	CheckAlias(refBound10, true)
endfunction

function UpdatePuppet(Actor target, int index)
	if(!target)
		return
	endif

	if(Math.LogicalAnd(charmData[index], 4) != 0 && !target.IsDead())
		target.RestoreActorValue("health", 100000.0)
	endif
endfunction

function SendPuppetList()
	string msg = "Puppets currently under your control:"
	string name1 = GetPuppetString(refCharm1.GetReference() as Actor)
	string name2 = GetPuppetString(refCharm2.GetReference() as Actor)
	string name3 = GetPuppetString(refCharm3.GetReference() as Actor)
	string name4 = GetPuppetString(refCharm4.GetReference() as Actor)
	string name5 = GetPuppetString(refCharm5.GetReference() as Actor)
	if(name1)
		msg = msg + "\n" + name1
	endif
	if(name2)
		msg = msg + "\n" + name2
	endif
	if(name3)
		msg = msg + "\n" + name3
	endif
	if(name4)
		msg = msg + "\n" + name4
	endif
	if(name5)
		msg = msg + "\n" + name5
	endif
	if(!name1 && !name2 && !name3 && !name4 && !name5)
		msg = msg + "\nNo puppets"
	endif
	Debug.MessageBox(msg)
endfunction

string function GetPuppetString(Actor target)
	if(!target)
		return ""
	endif
	string name = GetActorName(target)
	if(!name)
		name = "unknown"
	endif

	name = name + " ("
	if(IsFollowing(target))
		name = name + "following)"
	elseif(IsWaiting(target))
		name = name + "waiting)"
	elseif(IsFrozen(target))
		name = name + "frozen)"
	elseif(IsMarker(target))
		name = name + "beacon)"
	else
		name = name + "normal routine)"
	endif
	if(IsTied(target))
		name = name + " (bound)"
	endif
	return name
endfunction

function SetPersonality(Actor target, bool agg, int level)
	if(!target)
		return
	endif

	int index = -1
	if((refCharm1.GetReference() as Actor) == target)
		index = 0
	elseif((refCharm2.GetReference() as Actor) == target)
		index = 1
	elseif((refCharm3.GetReference() as Actor) == target)
		index = 2
	elseif((refCharm4.GetReference() as Actor) == target)
		index = 3
	elseif((refCharm5.GetReference() as Actor) == target)
		index = 4
	endif

	if(index >= 0)
		if(agg)
			aggression[index] = level
		else
			confidence[index] = level
		endif

		UpdateRelationship(target, index)
	endif
endfunction

function UpdateRelationship(Actor target, int index)
	if(!target)
		return
	endif

	Actor me = Game.GetPlayer()
	if(!me)
		return
	endif

	if(target.GetActorValue("assistance") < 1.0)
		target.SetActorValue("assistance", 1.0)
	endif
	if(target.GetActorValue("morality") != 0.0)
		target.SetActorValue("morality", 0.0)
	endif

	if(target.GetRelationshipRank(me) < 3)
		target.SetRelationshipRank(me, 3)
	endif

	if(aggression[index] >= 0 && (target.GetActorValue("aggression") as int) != aggression[index])
		target.SetActorValue("aggression", aggression[index] as float)
	endif
	if(confidence[index] >= 0 && (target.GetActorValue("confidence") as int) != confidence[index])
		target.SetActorValue("confidence", confidence[index] as float)
	endif

	target.SetNotShowOnStealthMeter(true)
	if(IsNPC(target))
		target.SetNoBleedoutRecovery(false)
		if(Math.LogicalAnd(charmData[index], 2) != 0)
			target.SetOutfit(nakedOutfit)
		endif
	endif
endfunction

function SetDecideWear(Actor target, bool apply = true)
	if(!target || target.IsDisabled() || !IsNPC(target) || target.IsDead())
		return
	endif

	ActorBase levBase = target.GetLeveledActorBase()
	if(!levBase)
		return
	endif

	int index = GetCharmedIndex(target)
	if(index >= 0)
		if(apply)
			if(Math.LogicalAnd(charmData[index], 2) != 0)
				return
			endif

			defOutfit[index] = levBase.GetOutfit()
			charmData[index] = Math.LogicalOr(charmData[index], 2)
			target.SetOutfit(nakedOutfit)
			if(!target.IsInFaction(decideFaction))
				target.AddToFaction(decideFaction)
			endif
		else
			charmData[index] = Math.LogicalAnd(charmData[index], Math.LogicalNot(2))
			if(target.IsInFaction(decideFaction))
				target.RemoveFromFaction(decideFaction)
			endif
			if(!defOutfit[index])
				return
			endif

			target.SetOutfit(defOutfit[index])
		endif
	endif
endfunction

string function GetActorName(Actor akTarget)
	if(!akTarget)
		return ""
	endif

	ActorBase akBase = akTarget.GetLeveledActorBase()
	if(akBase)
		return akBase.GetName()
	endif
	return ""
endfunction

function CheckAlias(ReferenceAlias refAlias, bool boundAlias = false)
	if(!refAlias || !refAlias.GetReference())
		return
	endif

	Actor target = refAlias.GetReference() as Actor
	if(!target || target.IsDisabled() || target.IsDead() || (boundAlias && !target.IsInFaction(boundFaction)))
		refAlias.Clear()
		if(target && (refAlias == refCharm1 || refAlias == refCharm2 || refAlias == refCharm3 || refAlias == refCharm4 || refAlias == refCharm5))
			string name = GetActorName(target)
			if(name)
				Debug.Notification(name + " has died.")
			else
				Debug.Notification("Someone under your influence has died.")
			endif
		elseif(target && boundAlias)
			Debug.Notification(GetActorName(target) + " is no longer bound.")
		endif
	endif
endfunction

int function RememberPackage(Actor target)
	if(!target)
		return 0
	endif

	if(IsFollowing(target))
		return 1
	endif
	if(IsFrozen(target))
		return 2
	endif
	if(IsWaiting(target))
		return 3
	endif
	if(IsMarker(target))
		return 4
	endif
	return 0
endfunction

function SetPackage(Actor target, int packageType)
	if(!target)
		return
	endif

	if(packageType == 1)
		SetFollow(target)
	elseif(packageType == 2)
		SetFreeze(target)
	elseif(packageType == 3)
		SetWait(target)
	elseif(packageType == 4)
		SetMarker(target)
	else
		SetNone(target)
	endif
endfunction

function RemoveAlias(Actor target, bool calculate = true, bool travel = false)
	if(!target)
		return
	endif

	if(!travel)
		target.SetDoingFavor(false)
		target.SetActorValue("WaitingForPlayer", 0.0)

		if((refFollow1.GetReference() as Actor) == target)
			refFollow1.Clear()
			if(Math.LogicalAnd(charmData[0], 1) != 0)
				target.SetPlayerTeammate(false, false)
				charmData[0] = Math.LogicalAnd(charmData[0], Math.LogicalNot(1))
			endif
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refFollow2.GetReference() as Actor) == target)
			refFollow2.Clear()
			if(Math.LogicalAnd(charmData[1], 1) != 0)
				target.SetPlayerTeammate(false, false)
				charmData[1] = Math.LogicalAnd(charmData[1], Math.LogicalNot(1))
			endif
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refFollow3.GetReference() as Actor) == target)
			refFollow3.Clear()
			if(Math.LogicalAnd(charmData[2], 1) != 0)
				target.SetPlayerTeammate(false, false)
				charmData[2] = Math.LogicalAnd(charmData[2], Math.LogicalNot(1))
			endif
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refFollow4.GetReference() as Actor) == target)
			refFollow4.Clear()
			if(Math.LogicalAnd(charmData[3], 1) != 0)
				target.SetPlayerTeammate(false, false)
				charmData[3] = Math.LogicalAnd(charmData[3], Math.LogicalNot(1))
			endif
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refFollow5.GetReference() as Actor) == target)
			refFollow5.Clear()
			if(Math.LogicalAnd(charmData[4], 1) != 0)
				target.SetPlayerTeammate(false, false)
				charmData[4] = Math.LogicalAnd(charmData[4], Math.LogicalNot(1))
			endif
			if(calculate)
				target.EvaluatePackage()
			endif
		endif

		if((refWait1.GetReference() as Actor) == target)
			refWait1.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refWait2.GetReference() as Actor) == target)
			refWait2.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refWait3.GetReference() as Actor) == target)
			refWait3.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refWait4.GetReference() as Actor) == target)
			refWait4.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refWait5.GetReference() as Actor) == target)
			refWait5.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif

		if((refFreeze1.GetReference() as Actor) == target)
			refFreeze1.Clear()
			fTime[0] = 0
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refFreeze2.GetReference() as Actor) == target)
			refFreeze2.Clear()
			fTime[1] = 0
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refFreeze3.GetReference() as Actor) == target)
			refFreeze3.Clear()
			fTime[2] = 0
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refFreeze4.GetReference() as Actor) == target)
			refFreeze4.Clear()
			fTime[3] = 0
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refFreeze5.GetReference() as Actor) == target)
			refFreeze5.Clear()
			fTime[4] = 0
			if(calculate)
				target.EvaluatePackage()
			endif
		endif

		if((refGoMarker1.GetReference() as Actor) == target)
			refGoMarker1.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refGoMarker2.GetReference() as Actor) == target)
			refGoMarker2.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refGoMarker3.GetReference() as Actor) == target)
			refGoMarker3.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refGoMarker4.GetReference() as Actor) == target)
			refGoMarker4.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refGoMarker5.GetReference() as Actor) == target)
			refGoMarker5.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
	else
		if((refTravel1.GetReference() as Actor) == target)
			refTravel1.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refTravel2.GetReference() as Actor) == target)
			refTravel2.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refTravel3.GetReference() as Actor) == target)
			refTravel3.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refTravel4.GetReference() as Actor) == target)
			refTravel4.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
		if((refTravel5.GetReference() as Actor) == target)
			refTravel5.Clear()
			if(calculate)
				target.EvaluatePackage()
			endif
		endif
	endif
endfunction

function Undress(Actor target)
	if(!target)
		return
	endif

	; if(!IsDressed(target))
	;	return
	; endif

	target.AddToFaction(undressedFaction)

	SexLab.ActorLib.StripActor(target, Doanimate = false)
endfunction

function UndressClear(Actor target)
	if(!target)
		return
	endif

	target.SetOutfit(nakedOutfit)
endfunction

function Dress(Actor target)
	if(!target || target.IsDisabled() || target.IsDead())
		return
	endif

	if(target.IsInFaction(undressedFaction))
		target.RemoveFromFaction(undressedFaction)
	endif

	int wearMask = 0
	int i = 0
	while(i < 32)
		int j = Math.LeftShift(1, i)
		if(target.GetWornForm(j))
			wearMask = Math.LogicalOr(wearMask, j)
		endif
		i += 1
	endwhile
	int itemCount = target.GetNumItems()
	i = itemCount - 1
	Weapon bestWeapon = none
	int bestDamage = 0
	while(i >= 0)
		Form curItem = target.GetNthForm(i)
		if(curItem)
			Armor curArmor = curItem as Armor
			if(curArmor)
				int slotMask = curArmor.GetSlotMask()
				if(Math.LogicalAnd(wearMask, slotMask) == 0)
					wearMask = Math.LogicalOr(wearMask, slotMask)
					target.EquipItem(curItem)
				endif
			else
				Weapon curWeapon = curItem as Weapon
				if(curWeapon)
					int dmg = curWeapon.GetBaseDamage()
					if(dmg > bestDamage)
						bestWeapon = curWeapon
						bestDamage = dmg
					endif
				endif
			endif
		endif
		i -= 1
	endwhile

	if(bestWeapon)
		target.EquipItem(bestWeapon)
	endif
endfunction

bool function IsDressed(Actor target)
	if(!target)
		return true
	endif

	return !target.IsInFaction(undressedFaction)
endfunction

int function GetCharmedIndex(Actor target)
	if(!target)
		return -1
	endif

	if((refCharm1.GetReference() as Actor) == target)
		return 0
	endif
	if((refCharm2.GetReference() as Actor) == target)
		return 1
	endif
	if((refCharm3.GetReference() as Actor) == target)
		return 2
	endif
	if((refCharm4.GetReference() as Actor) == target)
		return 3
	endif
	if((refCharm5.GetReference() as Actor) == target)
		return 4
	endif
	return -1
endfunction

function SetCharmed(Actor target, bool apply = true)
	if(!target)
		return
	endif

	if(apply && target.IsChild())
		Debug.Notification("You can't influence children.")
		return
	endif

	Actor me = GetReference() as Actor
	if(!me)
		return
	endif

	_mindConfig cfg = GetConfig()
	if(!cfg)
		return
	endif

	if(apply)
		if(IsCharmed(target))
			return
		endif

		int index
		if(!refCharm1.GetReference())
			refCharm1.ForceRefTo(target)
			index = 0
		elseif(!refCharm2.GetReference())
			refCharm2.ForceRefTo(target)
			index = 1
		elseif(!refCharm3.GetReference())
			refCharm3.ForceRefTo(target)
			index = 2
		elseif(!refCharm4.GetReference())
			refCharm4.ForceRefTo(target)
			index = 3
		else
			if(refCharm5.GetReference())
				SetCharmed(refCharm5.GetReference() as Actor, false)
			endif
			refCharm5.ForceRefTo(target)
			index = 4
		endif

		string name = GetActorName(target)
		if(name)
			Debug.Notification(name + " is now under your influence.")
		else
			Debug.Notification("You have influenced someone.")
		endif

		defOutfit[index] = none
		charmData[index] = 0
		aggression[index] = -1
		confidence[index] = -1
		relationship[index] = target.GetRelationshipRank(me)
		morality[index] = target.GetActorValue("morality") as int

		UpdateRelationship(target, index)
		target.StopCombat()

		if(!target.HasKeyword(npcKeyword))
			if(cfg.basicFollowAnimals)
				SetFollow(target)
			endif
		elseif(cfg.basicFollowHumans)
			SetFollow(target)
		endif
		return
	else
		if((refCharm1.GetReference() as Actor) == target)
			if(relationship[0] > -5)
				target.SetRelationshipRank(me, relationship[0])
				relationship[0] = -5
			endif
			if(morality[0] >= 0)
				target.SetActorValue("morality", morality[0] as float)
				morality[0] = -1
			endif
			SetFastMove(target, false)
			SetTough(target, false)
			refCharm1.Clear()
			SetNone(target)

			if(defOutfit[0])
				if(target.IsEnabled() && !target.IsDead())
					target.SetOutfit(defOutfit[0])
				endif
				defOutfit[0] = none
			endif

			if(target.IsEnabled() && !target.IsDead() && !IsDressed(target))
				Dress(target)
			endif
	
			string name = GetActorName(target)
			if(name)
				Debug.Notification(name + " is no longer under your influence.")
			else
				Debug.Notification("Someone is released from your influence.")
			endif
			return
		endif
		if((refCharm2.GetReference() as Actor) == target)
			if(relationship[1] > -5)
				target.SetRelationshipRank(me, relationship[1])
				relationship[1] = -5
			endif
			if(morality[1] >= 0)
				target.SetActorValue("morality", morality[1] as float)
				morality[1] = -1
			endif
			SetFastMove(target, false)
			SetTough(target, false)
			refCharm2.Clear()
			SetNone(target)

			if(defOutfit[1])
				if(target.IsEnabled() && !target.IsDead())
					target.SetOutfit(defOutfit[1])
				endif
				defOutfit[1] = none
			endif

			if(target.IsEnabled() && !target.IsDead() && !IsDressed(target))
				Dress(target)
			endif
	
			string name = GetActorName(target)
			if(name)
				Debug.Notification(name + " is no longer under your influence.")
			else
				Debug.Notification("Someone is released from your influence.")
			endif
			return
		endif
		if((refCharm3.GetReference() as Actor) == target)
			if(relationship[2] > -5)
				target.SetRelationshipRank(me, relationship[2])
				relationship[2] = -5
			endif
			if(morality[2] >= 0)
				target.SetActorValue("morality", morality[2] as float)
				morality[2] = -1
			endif
			SetFastMove(target, false)
			SetTough(target, false)
			refCharm3.Clear()
			SetNone(target)

			if(defOutfit[2])
				if(target.IsEnabled() && !target.IsDead())
					target.SetOutfit(defOutfit[2])
				endif
				defOutfit[2] = none
			endif

			if(target.IsEnabled() && !target.IsDead() && !IsDressed(target))
				Dress(target)
			endif
	
			string name = GetActorName(target)
			if(name)
				Debug.Notification(name + " is no longer under your influence.")
			else
				Debug.Notification("Someone is released from your influence.")
			endif
			return
		endif
		if((refCharm4.GetReference() as Actor) == target)
			if(relationship[3] > -5)
				target.SetRelationshipRank(me, relationship[3])
				relationship[3] = -5
			endif
			if(morality[3] >= 0)
				target.SetActorValue("morality", morality[3] as float)
				morality[3] = -1
			endif
			SetFastMove(target, false)
			SetTough(target, false)
			refCharm4.Clear()
			SetNone(target)

			if(defOutfit[3])
				if(target.IsEnabled() && !target.IsDead())
					target.SetOutfit(defOutfit[3])
				endif
				defOutfit[3] = none
			endif

			if(target.IsEnabled() && !target.IsDead() && !IsDressed(target))
				Dress(target)
			endif
	
			string name = GetActorName(target)
			if(name)
				Debug.Notification(name + " is no longer under your influence.")
			else
				Debug.Notification("Someone is released from your influence.")
			endif
			return
		endif
		if((refCharm5.GetReference() as Actor) == target)
			if(relationship[4] > -5)
				target.SetRelationshipRank(me, relationship[4])
				relationship[4] = -5
			endif
			if(morality[4] >= 0)
				target.SetActorValue("morality", morality[4] as float)
				morality[4] = -1
			endif
			SetFastMove(target, false)
			SetTough(target, false)
			refCharm5.Clear()
			SetNone(target)

			if(defOutfit[4])
				if(target.IsEnabled() && !target.IsDead())
					target.SetOutfit(defOutfit[4])
				endif
				defOutfit[4] = none
			endif

			if(target.IsEnabled() && !target.IsDead() && !IsDressed(target))
				Dress(target)
			endif
	
			string name = GetActorName(target)
			if(name)
				Debug.Notification(name + " is no longer under your influence.")
			else
				Debug.Notification("Someone is released from your influence.")
			endif
			return
		endif
	endif
endfunction

bool function IsCharmed(Actor target)
	if(!target)
		return false
	endif

	return (refCharm1.GetReference() as Actor) == target || (refCharm2.GetReference() as Actor) == target || (refCharm3.GetReference() as Actor) == target || (refCharm4.GetReference() as Actor) == target || (refCharm5.GetReference() as Actor) == target
endfunction

bool function IsFollowing(Actor target)
	if(!target)
		return false
	endif

	return (refFollow1.GetReference() as Actor) == target || (refFollow2.GetReference() as Actor) == target || (refFollow3.GetReference() as Actor) == target || (refFollow4.GetReference() as Actor) == target || (refFollow5.GetReference() as Actor) == target
endfunction

bool function IsMarker(Actor target)
	if(!target)
		return false
	endif

	return (refGoMarker1.GetReference() as Actor) == target || (refGoMarker2.GetReference() as Actor) == target || (refGoMarker3.GetReference() as Actor) == target || (refGoMarker4.GetReference() as Actor) == target || (refGoMarker5.GetReference() as Actor) == target
endfunction

bool function IsWaiting(Actor target)
	if(!target)
		return false
	endif

	return (refWait1.GetReference() as Actor) == target || (refWait2.GetReference() as Actor) == target || (refWait3.GetReference() as Actor) == target || (refWait4.GetReference() as Actor) == target || (refWait5.GetReference() as Actor) == target
endfunction

bool function IsFrozen(Actor target)
	if(!target)
		return false
	endif

	return (refFreeze1.GetReference() as Actor) == target || (refFreeze2.GetReference() as Actor) == target || (refFreeze3.GetReference() as Actor) == target || (refFreeze4.GetReference() as Actor) == target || (refFreeze5.GetReference() as Actor) == target
endfunction

bool function IsTravel(Actor target)
	if(!target)
		return false
	endif

	return (refTravel1.GetReference() as Actor) == target || (refTravel2.GetReference() as Actor) == target || (refTravel3.GetReference() as Actor) == target || (refTravel4.GetReference() as Actor) == target || (refTravel5.GetReference() as Actor) == target
endfunction

function SetNone(Actor target)
	RemoveAlias(target, true)
endfunction

bool function IsTied(Actor target)
	if(!target)
		return false
	endif

	return target.IsInFaction(boundFaction)
endfunction

bool function Untie(Actor target)
	if(!target)
		return false
	endif

	if(target.IsInFaction(boundFaction))
		target.RemoveFromFaction(boundFaction)
		CheckAliases(true)
		if(target.Is3DLoaded())
			SetRagdoll(target)
		endif
		return true
	endif

	return false
endfunction

function Tie(Actor target, int type = 0, Form eqItem = none)
	if(!target || target.IsDisabled() || target.IsDead() || !IsNPC(target))
		return
	endif

	Untie(target)

	if(type == 0)
		type = lastPose
	endif

	if(type >= 1)
		target.AddToFaction(boundFaction)
		target.SetFactionRank(boundFaction, type)
		Debug.Notification("You have bound " + GetActorName(target) + ".")
		if(!refBound1.GetReference())
			refBound1.ForceRefTo(target)
			target.EvaluatePackage()
			return
		endif
		if(!refBound2.GetReference())
			refBound2.ForceRefTo(target)
			target.EvaluatePackage()
			return
		endif
		if(!refBound3.GetReference())
			refBound3.ForceRefTo(target)
			target.EvaluatePackage()
			return
		endif
		if(!refBound4.GetReference())
			refBound4.ForceRefTo(target)
			target.EvaluatePackage()
			return
		endif
		if(!refBound5.GetReference())
			refBound5.ForceRefTo(target)
			target.EvaluatePackage()
			return
		endif
		if(!refBound6.GetReference())
			refBound6.ForceRefTo(target)
			target.EvaluatePackage()
			return
		endif
		if(!refBound7.GetReference())
			refBound7.ForceRefTo(target)
			target.EvaluatePackage()
			return
		endif
		if(!refBound8.GetReference())
			refBound8.ForceRefTo(target)
			target.EvaluatePackage()
			return
		endif
		if(!refBound9.GetReference())
			refBound9.ForceRefTo(target)
			target.EvaluatePackage()
			return
		endif
		if(refBound10.GetReference())
			Untie(refBound10.GetReference() as Actor)
		endif
		refBound10.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
endfunction

function MoveTogether(int type = 1)
	Actor target1 = iSexActor1
	Actor target2 = iSexActor2
	Actor target3 = iSexActor3

	if(target3)
		if(!target1)
			target1 = target3
			target3 = none
		elseif(!target2)
			target2 = target3
			target3 = none
		endif
	endif

	if(!target1 || !target2)
		ClearSex()
		return
	endif

	if(target1.IsDisabled() || target1.IsDead())
		ClearSex()
		return
	endif

	if(target2.IsDisabled() || target2.IsDead())
		ClearSex()
		return
	endif

	if(target3 && (target3.IsDisabled() || target3.IsDead()))
		ClearSex()
		return
	endif

	float radius = 256.0

	if(target1.GetDistance(target2) <= radius && (!target3 || (target3.GetDistance(target1) <= radius && target3.GetDistance(target2) <= radius)))
		iSexStart = true
		return
	endif

	Actor anchor = none

	if(Game.GetPlayer() == target1)
		anchor = target1
	elseif(Game.GetPlayer() == target2)
		anchor = target2
	elseif(target3 && Game.GetPlayer() == target3)
		anchor = target3
	endif

	if(!anchor)
		if(IsTied(target1))
			anchor = target1
		elseif(IsTied(target2))
			anchor = target2
		elseif(target3 && IsTied(target3))
			anchor = target3
		endif
	endif

	if(!anchor)
		if(!IsCharmed(target1))
			anchor = target1
		elseif(!IsCharmed(target2))
			anchor = target2
		elseif(target3 && !IsCharmed(target3))
			anchor = target3
		endif
	endif

	if(!anchor)
		anchor = target2
	endif

	if(anchor != Game.GetPlayer())
		SetFreeze(anchor, 5)
	endif

	moveType = 1
	if(target3)
		moveType = 2
	endif

	if(anchor != target1)
		int index = SetTravel(target1, anchor)
		if(index >= 0)
			iTravel[index] = type
		endif
	endif

	if(anchor != target2)
		int index = SetTravel(target2, anchor)
		if(index >= 0)
			iTravel[index] = type
		endif
	endif

	if(target3 && anchor != target3)
		int index = SetTravel(target3, anchor)
		if(index >= 0)
			iTravel[index] = type
		endif
	endif
endfunction

function SetFollow(Actor target)
	if(!target)
		return
	endif

	RemoveAlias(target, false)

	_mindConfig cfg = GetConfig()
	if(!cfg)
		return
	endif

	if(cfg.basicSpeed)
		SetFastMove(target, true)
	endif

	if(!refFollow1.GetReference())
		refFollow1.ForceRefTo(target)
		if(target.IsPlayerTeammate() || !cfg.basicTeammate)
			charmData[0] = Math.LogicalAnd(charmData[0], Math.LogicalNot(1))
		else
			charmData[0] = Math.LogicalOr(charmData[0], 1)
			target.SetPlayerTeammate(true, true)
		endif
		target.EvaluatePackage()
		return
	endif
	if(!refFollow2.GetReference())
		refFollow2.ForceRefTo(target)
		if(target.IsPlayerTeammate() || !cfg.basicTeammate)
			charmData[1] = Math.LogicalAnd(charmData[1], Math.LogicalNot(1))
		else
			charmData[1] = Math.LogicalOr(charmData[1], 1)
			target.SetPlayerTeammate(true, true)
		endif
		target.EvaluatePackage()
		return
	endif
	if(!refFollow3.GetReference())
		refFollow3.ForceRefTo(target)
		if(target.IsPlayerTeammate() || !cfg.basicTeammate)
			charmData[2] = Math.LogicalAnd(charmData[2], Math.LogicalNot(1))
		else
			charmData[2] = Math.LogicalOr(charmData[2], 1)
			target.SetPlayerTeammate(true, true)
		endif
		target.EvaluatePackage()
		return
	endif
	if(!refFollow4.GetReference())
		refFollow4.ForceRefTo(target)
		if(target.IsPlayerTeammate() || !cfg.basicTeammate)
			charmData[3] = Math.LogicalAnd(charmData[3], Math.LogicalNot(1))
		else
			charmData[3] = Math.LogicalOr(charmData[3], 1)
			target.SetPlayerTeammate(true, true)
		endif
		target.EvaluatePackage()
		return
	endif
	refFollow5.ForceRefTo(target)
	if(target.IsPlayerTeammate() || !cfg.basicTeammate)
		charmData[4] = Math.LogicalAnd(charmData[4], Math.LogicalNot(1))
	else
		charmData[4] = Math.LogicalOr(charmData[4], 1)
		target.SetPlayerTeammate(true, true)
	endif
	target.EvaluatePackage()
endfunction

function SetWait(Actor target)
	if(!target)
		return
	endif

	RemoveAlias(target, false)

	if(!refWait1.GetReference())
		refWait1.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
	if(!refWait2.GetReference())
		refWait2.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
	if(!refWait3.GetReference())
		refWait3.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
	if(!refWait4.GetReference())
		refWait4.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
	refWait5.ForceRefTo(target)
	target.EvaluatePackage()
endfunction

function SetFreeze(Actor target, int duration = 0)
	if(!target)
		return
	endif

	if(!refFreeze1.GetReference())
		fPrev[0] = RememberPackage(target)
		fTime[0] = duration
		RemoveAlias(target, false, false)
		RemoveAlias(target, false, true)
		refFreeze1.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
	if(!refFreeze2.GetReference())
		fPrev[1] = RememberPackage(target)
		fTime[1] = duration
		RemoveAlias(target, false, false)
		RemoveAlias(target, false, true)
		refFreeze2.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
	if(!refFreeze3.GetReference())
		fPrev[2] = RememberPackage(target)
		fTime[2] = duration
		RemoveAlias(target, false, false)
		RemoveAlias(target, false, true)
		refFreeze3.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
	if(!refFreeze4.GetReference())
		fPrev[3] = RememberPackage(target)
		fTime[3] = duration
		RemoveAlias(target, false, false)
		RemoveAlias(target, false, true)
		refFreeze4.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
	fPrev[4] = RememberPackage(target)
	fTime[4] = duration
	RemoveAlias(target, false, false)
	RemoveAlias(target, false, true)
	refFreeze5.ForceRefTo(target)
	target.EvaluatePackage()
endfunction

function Unfreeze(Actor target)
	if(!target)
		return
	endif

	if((refFreeze1.GetReference() as Actor) == target)
		refFreeze1.Clear()
		SetPackage(target, fPrev[0])
		fTime[0] = 0
		return
	endif
	if((refFreeze2.GetReference() as Actor) == target)
		refFreeze2.Clear()
		SetPackage(target, fPrev[1])
		fTime[1] = 0
		return
	endif
	if((refFreeze3.GetReference() as Actor) == target)
		refFreeze3.Clear()
		SetPackage(target, fPrev[2])
		fTime[2] = 0
		return
	endif
	if((refFreeze4.GetReference() as Actor) == target)
		refFreeze4.Clear()
		SetPackage(target, fPrev[3])
		fTime[3] = 0
		return
	endif
	if((refFreeze5.GetReference() as Actor) == target)
		refFreeze5.Clear()
		SetPackage(target, fPrev[4])
		fTime[4] = 0
		return
	endif
endfunction

function SetMarker(Actor target)
	if(!target)
		return
	endif

	RemoveAlias(target, false)

	if(!refGoMarker1.GetReference())
		refGoMarker1.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
	if(!refGoMarker2.GetReference())
		refGoMarker2.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
	if(!refGoMarker3.GetReference())
		refGoMarker3.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
	if(!refGoMarker4.GetReference())
		refGoMarker4.ForceRefTo(target)
		target.EvaluatePackage()
		return
	endif
	refGoMarker5.ForceRefTo(target)
	target.EvaluatePackage()
endfunction

int function SetTravel(Actor target, ObjectReference marker)
	if(!target || !marker)
		return -1
	endif

	RemoveAlias(target, false, true)

	if(IsCharmed(target))
		SetWait(target)
	endif

	if(!refTravel1.GetReference())
		ObjectReference markerRef = refTravelMarker1.GetReference()
		markerRef.MoveTo(marker)
		refTravel1.ForceRefTo(target)
		target.EvaluatePackage()
		iTravel[0] = 0
		return 0
	endif
	if(!refTravel2.GetReference())
		ObjectReference markerRef = refTravelMarker2.GetReference()
		markerRef.MoveTo(marker)
		refTravel2.ForceRefTo(target)
		target.EvaluatePackage()
		iTravel[1] = 0
		return 1
	endif
	if(!refTravel3.GetReference())
		ObjectReference markerRef = refTravelMarker3.GetReference()
		markerRef.MoveTo(marker)
		refTravel3.ForceRefTo(target)
		target.EvaluatePackage()
		iTravel[2] = 0
		return 2
	endif
	if(!refTravel4.GetReference())
		ObjectReference markerRef = refTravelMarker4.GetReference()
		markerRef.MoveTo(marker)
		refTravel4.ForceRefTo(target)
		target.EvaluatePackage()
		iTravel[3] = 0
		return 3
	endif

	ObjectReference markerRef = refTravelMarker5.GetReference()
	markerRef.MoveTo(marker)
	refTravel5.ForceRefTo(target)
	target.EvaluatePackage()
	iTravel[4] = 0
	return 4
endfunction

function OnTravel(int index, Actor target)
	int type = 0
	if(index >= 0 && index < 5)
		type = iTravel[index]
	endif
	
	RemoveAlias(target, true, true)
	if(type == 0)
		return
	endif

	if(type == 1)
		if(moveType == 2)
			moveType = 1
			SetFreeze(target, 4)
		else
			SetFreeze(target, 1)
			TryStartSex()
			ClearSex()
		endif
		return
	endif
endfunction

function SetFavor(Actor target)
	if(!target)
		return
	endif

	target.SetDoingFavor(true)
endfunction

function PlaceMarker()
	Actor plr = Game.GetPlayer()
	if(!plr)
		return
	endif

	ObjectReference marker = refMarker1.GetReference()
	if(!marker)
		return
	else
		marker.MoveTo(plr)
	endif
	
	globalMarker.SetValue(1)
	Debug.Notification("Set influence beacon to current position.")
endfunction

function TryStartSex()
	Actor man = iSexActor1
	Actor woman = iSexActor2
	Actor third = iSexActor3

	Actor plr = GetReference() as Actor

	;Debug.Notification("Trying to start.")

	if(!man || !plr)
		return
	endif

	sslThreadModel make = SexLab.NewThread()

	bool hasPlayer = man == plr || woman == plr || third == plr
	int actorCount = 1
	if(third && woman)
		actorCount = 3
	elseif(third || woman)
		actorCount = 2
	endif

	if(IsTied(man))
		Untie(man)
	endif
	if(woman && IsTied(woman))
		Untie(woman)
	endif
	if(third && IsTied(third))
		Untie(third)
	endif

	if(woman)
		make.AddActor(woman, isVictim = false)
	endif

	make.AddActor(man, isVictim = false)

	if(third)
		make.AddActor(third, isVictim = false)
	endif

	sslBaseAnimation[] anims
	string hookName = ""
	if(iSexTag1 == "pee" || iSexTag1 == "defec")
		hookName = "peeScene"
		anims = new sslBaseAnimation[1]
		anims[0] = SexLab.GetAnimationByName(iSexTag2)
		if(iSexTag2 == "Arrok Lesbian")
			curPeeType = 2
		elseif(iSexTag1 == "pee")
			curPeeType = 1
		else
			curPeeType = 3
		endif
		curPeeTimer = 0
		make.DisableLeadIn(true)
	else
		anims = SexLab.GetAnimationsByTag(actorCount, iSexTag1, iSexTag2, iSexTag3, iSexNoTag)
	endif

	make.SetAnimations(anims)

	if(iSexBed >= 0)
		make.SetBedding(0)
	else
		make.SetBedding(-1)
	endif

	if(hookName)
		make.SetHook(hookName)
		RegisterForModEvent("AnimationStart_" + hookName, hookName)
	endif
	make.StartThread()
endfunction

event peeScene(string eventName, string argString, float argNum, form sender)
    sslThreadController cont = SexLab.HookController(argString)
	if(cont)
		; cont.UpdateTimer(60.0)
	endif
    UnregisterForModEvent("AnimationStart_peeScene")
	curPeeType = -curPeeType
	curPeeScene = cont
endEvent

function ActionKey()
	if(Game.IsMovementControlsEnabled() && !Utility.IsInMenuMode())
		Actor me = GetReference() as Actor
		if(me)
			int choice = actionMessage.show()
			if(choice == 0)
				Pee(me)
			elseif(choice == 1)
				Defecate(me)
			elseif(choice == 2)
				DefecateAndPee(me)
			elseif(choice == 3)
				Masturbate(me)
			elseif(choice == 4)
				Pose(me)
			elseif(choice == 5)
				; Nothing was selected
			endif
		endif
	endif
endfunction

function Pose(Actor target, bool ask = true, int index = -1)
	if(!target)
		return
	endif

	if(!ask)
		if(index == 0)
			index = lastPose
		elseif(index < 0)
			return
		endif

		if(Game.GetPlayer() != target)
			Tie(target, index)
			return
		endif

		if(index != lastPose)
			lastPose = index
			Debug.Notification("Set this as selected pose for bind.")
		endif

		if(index == 1)
			Debug.SendAnimationEvent(target, "ZazAPCAO052")
		elseif(index == 2)
			Debug.SendAnimationEvent(target, "ZazAPCAO315")
		elseif(index == 3)
			Debug.SendAnimationEvent(target, "ZazAPCAO304")
		elseif(index == 4)
			Debug.SendAnimationEvent(target, "ZazAPCAO313")
		elseif(index == 5)
			Debug.SendAnimationEvent(target, "ZazAPCAO305")
		elseif(index == 6)
			Debug.SendAnimationEvent(target, "ZazAPC006")
		elseif(index == 7)
			Debug.SendAnimationEvent(target, "ZazAPC008")
		elseif(index == 8)
			Debug.SendAnimationEvent(target, "ZazAPC014")
		elseif(index == 9)
			Debug.SendAnimationEvent(target, "ZazAPC016")
		elseif(index == 10)
			Debug.SendAnimationEvent(target, "ZazAPC018")
		elseif(index == 11)
			Debug.SendAnimationEvent(target, "ZazAPC057")
		elseif(index == 12)
			Debug.SendAnimationEvent(target, "ZazAPC305")
		elseif(index == 13)
			Debug.SendAnimationEvent(target, "ZazAPCAO005")
		elseif(index == 14)
			Debug.SendAnimationEvent(target, "ZazAPCAO006")
		elseif(index == 15)
			Debug.SendAnimationEvent(target, "ZazAPCAO008")
		elseif(index == 16)
			Debug.SendAnimationEvent(target, "ZazAPCAO007")
		endif
	elseif(poseMessages)
		int ret = poseMessages[index + 1].Show()
		if(ret == 5 && index < 1)
			Pose(target, ask, index + 1)
		else
			Pose(target, false, (index + 1) * 5 + (ret + 1))
		endif
	endif
endfunction

ObjectReference function CreateExcrement(Actor target)
	return target.PlaceAtMe(defecateItem as Form)
endfunction

function SetRagdoll(Actor target, ObjectReference origin = none, float force = 0.1)
	if(!origin)
		origin = Game.GetPlayer()
	endif

	if(target)
		origin.PushActorAway(target, force)
	endif
endfunction

bool function IsNPC(Actor target, bool allowPlayer = true)
	if(!target)
		return false
	endif

	return (allowPlayer && target == Game.GetPlayer()) || target.HasKeyword(npcKeyword)
endfunction

bool function IsSex(Actor target, bool stop = false)
	sslThreadController thread = SexLab.GetActorController(target)
	if(thread)
		if(stop)
			thread.EndAnimation(false)
		endif
		return true
	endif
	return false
endfunction

function Pee(Actor target, float startDuration = -1.0, float duration = -1.0, float endDuration = -1.0, int standing = 0, bool skipAnimation = false, bool skipSound = false)
	if(!target || !IsNPC(target))
		return
	endif

	ActorBase targetBase = target.GetLeveledActorBase()
	if(!targetBase)
		return
	endif

	bool bound = IsTied(target)
	bool tied = false ; wrong
	bool isPlayer = target == Game.GetPlayer()
	bool isFemale = targetBase.GetSex() == 1
	bool isStanding = (!isFemale && standing == 0) || standing > 0
	string anim
	string anim2
	int prevStatus = -1

	if(IsSex(target) || bound)
		skipAnimation = true
	endif

	Form[] removedArmor

	_mindConfig cfg = GetConfig()
	if(!cfg)
		return
	endif

	if(startDuration < 0.0)
		startDuration = cfg.basicUrinateDuration1
	endif
	if(duration < 0.0)
		duration = cfg.basicUrinateDuration2
	endif
	if(endDuration < 0.0)
		endDuration = cfg.basicUrinateDuration3
	endif

	if(isFemale && standing == 0 && cfg.basicWomenUrinateStanding)
		isStanding = true
	endif

	if(!skipAnimation)
		if(cfg.basicUndressUrinate)
			removedArmor = SexLab.StripActor(target)
		endif

		if(isPlayer)
			Game.ForceThirdPerson()
			Game.DisablePlayerControls(true, true, true, false, true, false, true, false, 0)
		else
			prevStatus = RememberPackage(target)
			SetFreeze(target)
			target.AllowPCDialogue(false)
		endif

		anim = ""
		if(isFemale)
			if(isStanding)
				if(tied)
					; nothing just stand
				else
					anim = "ZazAPC203"
				endif
			else
				if(tied)
					anim = "ZazAPC206"
				else
					anim = "ZazAPC202"
				endif
			endif
		else
			if(isStanding)
				if(tied)
					; nothing just stand
				else
					anim = "ZazAPC207"
				endif
			else
				if(tied)
					anim = "ZazAPC206"
				else
					anim = "ZazAPC201"
				endif
			endif
		endif

		if(anim)
			PlayAnim(target, anim)
		endif

		if(startDuration > 0.0)
			Utility.Wait(startDuration)
		endif

		anim2 = ""

		if(isFemale)
			if(isStanding)
				if(tied)
					; TODO find anim for this
				else
					anim2 = "ZazAPCAO103"
				endif
			else
				if(tied)
					anim2 = "ZazAPCAO106"
				else
					anim2 = "ZazAPCAO102"
				endif
			endif
		else
			if(isStanding)
				if(tied)
					anim2 = "ZazAPCAO112"
				else
					anim2 = "ZazAPCAO107"
				endif
			else
				if(tied)
					anim2 = "ZazAPCAO106"
				else
					anim2 = "ZazAPCAO110"
				endif
			endif
		endif

		if(anim2)
			PlayAnim(target, anim2)
		endif
	endif

	CreateUrine(target)
	if(duration > 0.0)
		if(!skipSound)
			int soundId = urinateSound.Play(target)
			Utility.Wait(duration)
			Sound.StopInstance(soundId)
		else
			Utility.Wait(duration)
		endif
	endif

	if(!skipAnimation)
		if(anim)
			PlayAnim(target, anim)
		else
			ResetAnim(target)
		endif

		if(endDuration > 0.0)
			Utility.Wait(endDuration)
		endif

		if(removedArmor)
			SexLab.UnstripActor(target, removedArmor)
		endif

		if(isPlayer)
			Game.EnablePlayerControls()
		else
			if(prevStatus >= 0)
				SetPackage(target, prevStatus)
			endif
			target.AllowPCDialogue(true)
		endif

		if(anim)
			ResetAnim(target)
		endif
	endif
endfunction

function Defecate(Actor target, float startDuration = -1.0, float duration = -1.0, float endDuration = -1.0, int standing = 0, bool skipAnimation = false, bool skipSound = false)
	if(!target || !IsNPC(target))
		return
	endif

	ActorBase targetBase = target.GetLeveledActorBase()
	if(!targetBase)
		return
	endif

	bool bound = IsTied(target)
	bool tied = false ; wrong
	bool isPlayer = target == Game.GetPlayer()
	bool isFemale = targetBase.GetSex() == 1
	bool isStanding = standing > 0

	int prevStatus = -1

	if(IsSex(target) || bound)
		skipAnimation = true
	endif

	_mindConfig cfg = GetConfig()
	if(!cfg)
		return
	endif

	if(startDuration < 0.0)
		startDuration = cfg.basicDefecateDuration1
	endif
	if(duration < 0.0)
		duration = cfg.basicDefecateDuration2
	endif
	if(endDuration < 0.0)
		endDuration = cfg.basicDefecateDuration3
	endif

	Form[] removedArmor

	if(!skipAnimation)
		if(cfg.basicUndressDefecate)
			removedArmor = SexLab.StripActor(target)
		endif

		if(isPlayer)
			Game.ForceThirdPerson()
			Game.DisablePlayerControls(true, true, true, false, true, false, true, false, 0)
		else
			prevStatus = RememberPackage(target)
			SetFreeze(target)
			target.AllowPCDialogue(false)
		endif

		string anim = ""
		if(isFemale)
			if(isStanding)
				if(tied)
					; nothing just stand
				else
					anim = "ZazAPC203"
				endif
			else
				if(tied)
					anim = "ZazAPC206"
				else
					anim = "ZazAPC202"
				endif
			endif
		else
			if(isStanding)
				if(tied)
					; nothing just stand
				else
					anim = "ZazAPC204"
				endif
			else
				if(tied)
					anim = "ZazAPC206"
				else
					anim = "ZazAPC201"
				endif
			endif
		endif

		if(anim)
			PlayAnim(target, anim)
		endif
	endif

	if(startDuration > 0.0)
		float middle = startDuration * 0.5
		if(middle >= 2.0)
			Utility.Wait(middle)
			PlayFart(target)
			Utility.Wait(middle)
		else
			Utility.Wait(startDuration)
		endif
	endif

	bool firstLoop = true
	while(duration >= 0.0)
		PlayFart(target)
		if(cfg.basicCreateExcrementItem)
			CreateExcrement(target)
		endif
		if(firstLoop)
			CreateDefecate(target)
		endif
		firstLoop = false
		if(duration > 0.0)
			Utility.Wait(3.0)
		endif
		duration -= 3.0
	endwhile

	if(!skipAnimation)
		if(endDuration > 0.0)
			Utility.Wait(endDuration)
		endif

		if(removedArmor)
			SexLab.UnstripActor(target, removedArmor)
		endif

		if(isPlayer)
			Game.EnablePlayerControls()
		else
			if(prevStatus >= 0)
				SetPackage(target, prevStatus)
			endif
			target.AllowPCDialogue(true)
		endif

		ResetAnim(target)
	endif
endfunction

function DefecateAndPee(Actor target, float startDuration = -1.0, float duration = -1.0, float endDuration = -1.0, int standing = 0, bool skipAnimation = false, bool skipSound = false, bool peeFirst = false)
	if(!target || !IsNPC(target))
		return
	endif

	ActorBase targetBase = target.GetLeveledActorBase()
	if(!targetBase)
		return
	endif

	bool bound = IsTied(target)
	bool tied = false ; wrong
	bool isPlayer = target == Game.GetPlayer()
	bool isFemale = targetBase.GetSex() == 1
	bool isStanding = standing > 0
	string anim
	string anim2
	int prevStatus = -1

	if(IsSex(target) || bound)
		skipAnimation = true
	endif

	Form[] removedArmor

	_mindConfig cfg = GetConfig()
	if(!cfg)
		return
	endif

	float dur1
	float dur2
	float dur3

	if(peeFirst)
		if(startDuration < 0.0)
			dur1 = cfg.basicUrinateDuration1
		else
			dur1 = startDuration
		endif
		if(duration < 0.0)
			dur2 = cfg.basicUrinateDuration2
		else
			dur2 = duration
		endif
		if(endDuration < 0.0)
			dur3 = cfg.basicUrinateDuration3
		else
			dur3 = endDuration
		endif

		if(!skipAnimation)
			if(cfg.basicUndressUrinate || cfg.basicUndressDefecate)
				removedArmor = SexLab.StripActor(target)
			endif

			if(isPlayer)
				Game.ForceThirdPerson()
				Game.DisablePlayerControls(true, true, true, false, true, false, true, false, 0)
			else
				prevStatus = RememberPackage(target)
				SetFreeze(target)
				target.AllowPCDialogue(false)
			endif

			anim = ""
			if(isFemale)
				if(isStanding)
					if(tied)
						; nothing just stand
					else
						anim = "ZazAPC203"
					endif
				else
					if(tied)
						anim = "ZazAPC206"
					else
						anim = "ZazAPC202"
					endif
				endif
			else
				if(isStanding)
					if(tied)
						; nothing just stand
					else
						anim = "ZazAPC207"
					endif
				else
					if(tied)
						anim = "ZazAPC206"
					else
						anim = "ZazAPC201"
					endif
				endif
			endif

			if(anim)
				PlayAnim(target, anim)
			endif

			if(dur1 > 0.0)
				Utility.Wait(dur1)
			endif

			anim2 = ""

			if(isFemale)
				if(isStanding)
					if(tied)
						; TODO find anim for this
					else
						anim2 = "ZazAPCAO103"
					endif
				else
					if(tied)
						anim2 = "ZazAPCAO106"
					else
						anim2 = "ZazAPCAO102"
					endif
				endif
			else
				if(isStanding)
					if(tied)
						anim2 = "ZazAPCAO112"
					else
						anim2 = "ZazAPCAO107"
					endif
				else
					if(tied)
						anim2 = "ZazAPCAO106"
					else
						anim2 = "ZazAPCAO110"
					endif
				endif
			endif

			if(anim2)
				PlayAnim(target, anim2)
			endif
		endif

		CreateUrine(target)
		if(dur2 > 0.0)
			if(!skipSound)
				int soundId = urinateSound.Play(target)
				Utility.Wait(dur2)
				Sound.StopInstance(soundId)
			else
				Utility.Wait(dur2)
			endif
		endif

		if(!skipAnimation)
			if(anim)
				PlayAnim(target, anim)
			else
				ResetAnim(target)
			endif

			if(dur3 > 0.0)
				Utility.Wait(dur3)
			endif
		endif
	endif

	if(startDuration < 0.0)
		dur1 = cfg.basicDefecateDuration1
	else
		dur1 = startDuration
	endif
	if(duration < 0.0)
		dur2 = cfg.basicDefecateDuration2
	else
		dur2 = duration
	endif
	if(endDuration < 0.0)
		dur3 = cfg.basicDefecateDuration3
	else
		dur3 = endDuration
	endif

	if(!skipAnimation)
		if(!removedArmor && (cfg.basicUndressDefecate || cfg.basicUndressUrinate))
			removedArmor = SexLab.StripActor(target)
		endif

		if(!peeFirst)
			if(isPlayer)
				Game.ForceThirdPerson()
				Game.DisablePlayerControls(true, true, true, false, true, false, true, false, 0)
			else
				prevStatus = RememberPackage(target)
				SetFreeze(target)
				target.AllowPCDialogue(false)
			endif
		endif

		anim = ""
		if(isFemale)
			if(isStanding)
				if(tied)
					; nothing just stand
				else
					anim = "ZazAPC203"
				endif
			else
				if(tied)
					anim = "ZazAPC206"
				else
					anim = "ZazAPC202"
				endif
			endif
		else
			if(isStanding)
				if(tied)
					; nothing just stand
				else
					anim = "ZazAPC204"
				endif
			else
				if(tied)
					anim = "ZazAPC206"
				else
					anim = "ZazAPC201"
				endif
			endif
		endif

		if(anim)
			PlayAnim(target, anim)
		endif
	endif

	if(dur1 > 0.0)
		float middle = dur1 * 0.5
		if(middle >= 2.0)
			Utility.Wait(middle)
			PlayFart(target)
			Utility.Wait(middle)
		else
			Utility.Wait(dur1)
		endif
	endif

	bool firstLoop = true
	while(dur2 >= 0.0)
		PlayFart(target)
		if(cfg.basicCreateExcrementItem)
			CreateExcrement(target)
		endif
		if(firstLoop)
			CreateDefecate(target)
		endif
		firstLoop = false
		if(dur2 > 0.0)
			Utility.Wait(3.0)
		endif
		dur2 -= 3.0
	endwhile

	if(!skipAnimation)
		if(dur3 > 0.0)
			Utility.Wait(dur3)
		endif

		if(peeFirst)
			if(removedArmor)
				SexLab.UnstripActor(target, removedArmor)
			endif

			if(isPlayer)
				Game.EnablePlayerControls()
			else
				if(prevStatus >= 0)
					SetPackage(target, prevStatus)
				endif
				target.AllowPCDialogue(true)
			endif

			ResetAnim(target)
		endif
	endif

	if(!peeFirst)
		if(startDuration < 0.0)
			dur1 = cfg.basicUrinateDuration1
		else
			dur1 = startDuration
		endif
		if(duration < 0.0)
			dur2 = cfg.basicUrinateDuration2
		else
			dur2 = duration
		endif
		if(endDuration < 0.0)
			dur3 = cfg.basicUrinateDuration3
		else
			dur3 = endDuration
		endif

		if(!skipAnimation)
			anim = ""
			if(isFemale)
				if(isStanding)
					if(tied)
						; nothing just stand
					else
						anim = "ZazAPC203"
					endif
				else
					if(tied)
						anim = "ZazAPC206"
					else
						anim = "ZazAPC202"
					endif
				endif
			else
				if(isStanding)
					if(tied)
						; nothing just stand
					else
						anim = "ZazAPC207"
					endif
				else
					if(tied)
						anim = "ZazAPC206"
					else
						anim = "ZazAPC201"
					endif
				endif
			endif

			if(anim)
				PlayAnim(target, anim)
			endif

			if(dur1 > 0.0)
				Utility.Wait(dur1)
			endif

			anim2 = ""

			if(isFemale)
				if(isStanding)
					if(tied)
						; TODO find anim for this
					else
						anim2 = "ZazAPCAO103"
					endif
				else
					if(tied)
						anim2 = "ZazAPCAO106"
					else
						anim2 = "ZazAPCAO102"
					endif
				endif
			else
				if(isStanding)
					if(tied)
						anim2 = "ZazAPCAO112"
					else
						anim2 = "ZazAPCAO107"
					endif
				else
					if(tied)
						anim2 = "ZazAPCAO106"
					else
						anim2 = "ZazAPCAO110"
					endif
				endif
			endif

			if(anim2)
				PlayAnim(target, anim2)
			endif
		endif

		CreateUrine(target)
		if(dur2 > 0.0)
			if(!skipSound)
				int soundId = urinateSound.Play(target)
				Utility.Wait(dur2)
				Sound.StopInstance(soundId)
			else
				Utility.Wait(dur2)
			endif
		endif

		if(!skipAnimation)
			if(anim)
				PlayAnim(target, anim)
			else
				ResetAnim(target)
			endif

			if(dur3 > 0.0)
				Utility.Wait(dur3)
			endif

			if(removedArmor)
				SexLab.UnstripActor(target, removedArmor)
			endif

			if(isPlayer)
				Game.EnablePlayerControls()
			else
				if(prevStatus >= 0)
					SetPackage(target, prevStatus)
				endif
				target.AllowPCDialogue(true)
			endif

			ResetAnim(target)
		endif
	endif
endfunction

function PlayFart(Actor target, int fartId = -1)
	if(!target)
		return
	endif

	if(fartId < 0 || fartId > 2)
		fartId = Utility.RandomInt(0, 2)
	endif

	if(fartId == 0)
		defecateSound1.Play(target)
	elseif(fartId == 1)
		defecateSound2.Play(target)
	else
		defecateSound3.Play(target)
	endif
endfunction

function Necro(Actor source, Actor target)
	if(!source || !target || !target.IsDead() || source.IsDead())
		return
	endif

	if(!IsNPC(source) || !IsNPC(target))
		return
	endif

	if(IsSex(source) || IsSex(target))
		return
	endif

	ActorBase sourceBase = source.GetLeveledActorBase()
	ActorBase targetBase = target.GetLeveledActorBase()

	if(!sourceBase || !targetBase)
		return
	endif

	bool isWoman = sourceBase.GetSex() == 1

	string anim = "Arrok Leg Up Fuck"
	if(sourceBase.GetSex() == 1)
		anim = "Arrok Cowgirl"
	endif

	target.Resurrect()

	float waited = 2.0
	while(!target.Is3DLoaded() && waited >= 0.0)
		Utility.Wait(0.1)
		waited -= 0.1
	endwhile

	target.UnequipAll()

	target.SetUnconscious()
	target.AllowPCDialogue(false)
	target.SetDontMove(true)
	target.SetActorValue("Paralysis", 1.0)

	Debug.SendAnimationEvent(target, "Ragdoll")
	;SetRagdoll(target)

	if(source.IsWeaponDrawn())
		source.SheatheWeapon()
	endif

	RegisterForModEvent("AnimationStart_Necro", "StartNecro")
	RegisterForModEvent("AnimationEnd_Necro", "EndNecro")

	sslThreadModel make = SexLab.NewThread()
	sslBaseAnimation[] anims = new sslBaseAnimation[1]

	if(isWoman)
		make.AddActor(source)
		make.AddActor(target, isVictim = true, forceSilent = true)
	else
		make.AddActor(target, isVictim = true, forceSilent = true)
		make.AddActor(source)
	endif
	anims[0] = SexLab.GetAnimationByName(anim)

	make.SetAnimations(anims)
	make.DisableUndressAnimation(target)
	;make.DisableRagdollEnd(source)
	make.SetBedding(-1)
	make.SetHook("Necro")
	make.StartThread()
endfunction

event StartNecro(string EventName, string argString, Float argNum, form sender)
	Actor target = SexLab.HookVictim(argString)
	if(target)
		target.SetActorValue("Paralysis", 0.0)
	endif
	UnregisterForModEvent("AnimationStart_Necro")
endevent

event EndNecro(string EventName, string argString, Float argNum, form sender)
	Actor target = SexLab.HookVictim(argString)
	if(target)
		Debug.SendAnimationEvent(target, "Ragdoll")
		target.KillEssential()
	endif
	UnregisterForModEvent("AnimationEnd_Necro")
endevent

function PlayAnim(Actor target, string idleAnimEvent)
	if(!target || !IsNPC(target))
		return
	endif

	Debug.SendAnimationEvent(target, idleAnimEvent)
endfunction

function Masturbate(Actor target)
	if(!target || !IsNPC(target) || target.IsDead() || IsSex(target))
		return
	endif

	actor[] sexActors = new actor[1]
	sexActors[0] = target

	ActorBase targetBase = target.GetLeveledActorBase()
	string gtag = "M"
	if(targetBase && targetBase.GetSex() == 1)
		gtag = "F"
	endif
	sslBaseAnimation[] anims = SexLab.GetAnimationsByTag(1, "Masturbation", gtag)
	SexLab.StartSex(sexActors, anims, allowBed = target == Game.GetPlayer())
endfunction

function Beat(Actor source, Actor target, bool blood = true)
	if(!source || !target || !IsNPC(source) || !IsNPC(target) || target.IsDead())
		return
	endif

	if(IsSex(source) || IsSex(target))
		return
	endif

	if(source == Game.GetPlayer())
		Game.ForceThirdPerson()
		Game.DisablePlayerControls(true, true, true, false, true, false, true, false, 0)
	endif

	;source.SheatheWeapon()
	Form wpLeft = source.GetEquippedObject(0)
	Form wpRight = source.GetEquippedObject(1)
	if(wpLeft)
		source.UnequipItemEx(wpLeft, 2)
	endif
	if(wpRight)
		source.UnequipItemEx(wpRight, 1)
	endif

	int tries = 0
	while(tries < 4)
		if(source.PlayIdleWithTarget(beatdown, target))
			tries = 500
		else
			tries += 1
		endif
		Utility.Wait(0.5)
	endwhile

	if(tries != 500)
		if(wpLeft)
			source.EquipItemEx(wpLeft, 2, false, false)
		endif
		if(wpRight)
			source.EquipItemEx(wpRight, 1, false, false)
		endif
		if(source == Game.GetPlayer())
			Game.EnablePlayerControls()
		endif
		return
	endif
	
	Utility.Wait(1.0)
	if(blood)
		CreateBlood(target)
	endif
	Utility.Wait(1.5)

	; to get rid of infinite combat stance at the end
	ResetAnim(source)

	; the following looks bad but is necessary to get rid of combat stance later
	;ResetAnim(target)
	;SetRagdoll(target)
	Debug.SendAnimationEvent(target, "Ragdoll")

	if(wpLeft)
		source.EquipItemEx(wpLeft, 2, false, false)
	endif
	if(wpRight)
		source.EquipItemEx(wpRight, 1, false, false)
	endif

	if(source == Game.GetPlayer())
		Game.EnablePlayerControls()
	endif

	target.StopCombat()
endfunction

function CreateBlood(Actor target)
	if(target)
		target.PlayImpactEffect(bloodImpact)
	endif
endfunction

function CreateDefecate(Actor target, bool onself = false, bool onground = true)
	;/if(onself) ; if anyone knows how to make this work let me know please
		target.PlayImpactEffect(defecateImpact, "NPC L Thigh")
		target.PlayImpactEffect(defecateImpact, "NPC R Thigh")
	endif/;
	if(onground)
		target.PlayImpactEffect(defecateImpact)
	endif
endfunction

function CreateUrine(Actor target, bool onself = false, bool onground = true)
	;/if(onself) ; if anyone knows how to make this work let me know please
		target.PlayImpactEffect(urinateImpact, "NPC L Thigh")
		target.PlayImpactEffect(urinateImpact, "NPC R Thigh")
	endif/;
	if(onground)
		target.PlayImpactEffect(urinateImpact)
	endif
endfunction

function ResetAnim(Actor target)
	if(!target)
		return
	endif

	; todo what if tied
	Debug.SendAnimationEvent(target, "IdleForceDefaultState")
endfunction

event OnKeyUp(int keyCode, float holdTime)
	if(keyCode == curBasicKey)
		ActionKey()
	endif
endevent


SPELL Property CharmSpell  Auto  
