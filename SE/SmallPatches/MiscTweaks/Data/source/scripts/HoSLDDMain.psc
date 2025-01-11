Scriptname HoSLDDMain extends Quest  

int Property PlayerInThread = -1 Auto Hidden

HoSLDDThread[] Property Threads Auto;

SexLabFramework Property SexLab  Auto

;VISUAL EFFECTS

Spell Property HoSuccubusDrain Auto
Spell Property HoSuccubusDrainGlow Auto
Spell Property HoSuccubusDrainGlowVicSpell Auto
Spell Property HoSoulAbrosb Auto
Spell Property HoDrainFeaturesSpell Auto
Spell Property HoFeedTransitionSpell Auto


EffectShader property DragonPowerAbsorbFXS auto ;AURA
VisualEffect property WarewolfExtractVFX auto ;REDBALL
VisualEffect property MAGDragonPowerAbsorbEffect auto ;BOOM
VisualEffect property MAGDragonPowerAbsorbManEffect auto ;ABSORB SOUL

EffectShader property HoSLDDDrainBody auto ;Light
EffectShader property HoSLDDDrainBodyVictim auto ;Light

PlayerVampireQuestScript Property PlayerVampireQuest  Auto

;END VFX

;USED REFS
Faction Property HoSLDDPowers auto
Faction Property HoSLDDDrainSlave auto
Keyword Property Vampire auto
Keyword Property ActorTypeNPC auto
SoulGem Property pSoulGemBlackFilled  Auto  
SoulGem Property pSoulGemBlack Auto  
Race Property DraugrRace Auto

HoVampireConfig Property VampConfig Auto
string[] FeedingTexts
Actor PlayerRef;

string Property NINODE_LEFT_BREAST = "NPC L Breast" AutoReadOnly
string Property NINODE_RIGHT_BREAST = "NPC R Breast" AutoReadOnly

;END USED REFS


;IDLES

Idle Property FeedFront Auto
Idle Property FeedBack Auto

;END IDLES

string Property ModVer = "1.5" Auto Hidden

Function StartedSex()
	RegisterForSleep()
EndFunction

Function EndSex()
	PlayerInThread = -1 ;-1 is the thread number we use for null 
EndFunction

Function OnInit()

	;VampireFeed
	RegisterForAnimationEvent(PlayerRef, "VampireFeedEnd") ; The only node working atm.

	FeedingTexts = new string[5]
 	FeedingTexts[0] = "Unbearable lust clouds your mind as you feed"
	FeedingTexts[1] = "Feeding fills you with incredible lust"
	FeedingTexts[2] = "Your arousal increases while feeding from your victim"
	FeedingTexts[3] = "You feel immense pleasure when you feed"
	FeedingTexts[4] = "As your fangs sink deep your body flows with lust"

	Debug.Notification("SLDD Installed")
	RegisterForModEvent("HoSLDD_GivePlayerPowers", "GivePlayerPowers")
	RegisterForModEvent("HoSLDD_TakeAwayPlayerPowers", "TakeAwayPlayerPowers")



	VampConfig.OnConfigInit()
	ReInit()
EndFunction

Event GivePlayerPowers()
	Game.GetPlayer().AddToFaction(HoSLDDPowers)
	Debug.Notification("Your draining powers grow stronger")
EndEvent

Event TakeAwayPlayerPowers()
	Game.GetPlayer().RemoveFromFaction(HoSLDDPowers)
	Debug.Notification("Your draining powers are taken away")
EndEvent

Function ReInit()
	;RegisterForKey(82) ; Num0
	RegisterForKey(VampConfig.DrainKey) ; Manual Drain Key
	RegisterForKey(VampConfig.DrainCurrentDeathKey) ; Force death key
	RegisterForKey(VampConfig.HotEnableModKey) ;Mod Eanable key

	RegisterForModEvent("HoSLDD_DialogFeedBloodMale", "NpcActionBloodMale")
	RegisterForModEvent("HoSLDD_DialogFeedBloodFemale", "NpcActionBloodFemale")
	RegisterForModEvent("HoSLDD_SuccubusAggressive", "SuccubusAggressiveFuck")
	RegisterForModEvent("HoSLDD_SuccubusNonAggressive", "SuccubusNonAggressiveFuck")

	RegisterForModEvent("HoSLDD_SuccubusFeedFromVictim", "SuccubusFeed")


	RegisterForModEvent("HoSLDD_HypnoFeed", "NpcHypnoFeed")
	

	PlayerRef = Game.GetPlayer()
EndFunction

Event OnKeyDown(Int KeyCode)
	If VampConfig.ModEnabled && PlayerInThread != -1
		If KeyCode == 82
			OnInit()
			Debug.Notification("Reloaded Init!")
		ElseIf KeyCode == VampConfig.DrainKey
			if Threads[PlayerInThread].autoDrain == false && Threads[PlayerInThread].isHavingSex == true && VampConfig.AllowDrain && VampConfig.ManualDrain && Threads[PlayerInThread].PlayerHasControl
				Threads[PlayerInThread].StartManualDrain(true)
			EndIf
		ElseIf KeyCode == VampConfig.DrainCurrentDeathKey && Threads[PlayerInThread].isHavingSex
			If Threads[PlayerInThread].forceDeath == false
				Threads[PlayerInThread].forceDeath = true
				Debug.Notification("You decide to drain your victim to death")
			Else
				Threads[PlayerInThread].forceDeath = false
				Debug.Notification("You decide to spare your victims life")
			EndIf
		EndIf
	EndIf
EndEvent

Event OnKeyUp(Int KeyCode, Float HoldTime)
	If KeyCode == VampConfig.DrainKey && PlayerInThread != -1
		if Threads[PlayerInThread].manualDrain == true
			Threads[PlayerInThread].StopManualDrain()
		EndIf
	EndIf
EndEvent

Function BedFeed()
	if VampConfig.ModEnabled
		if VampConfig.IncreaseArousal

			Utility.Wait(1.0)
			if VampConfig.VisualEffects
				HoFeedTransitionSpell.Cast(PlayerRef,PlayerRef)
			Endif

			ShowFeedMassage()

		Endif
	EndIf
EndFunction

Event OnAnimationEvent(ObjectReference akSource, string asEventName)	
	if VampConfig.ModEnabled
		if VampConfig.IncreaseArousal
			if VampConfig.VisualEffects
				HoFeedTransitionSpell.Cast(PlayerRef,PlayerRef)
			Endif

			ShowFeedMassage()
		Endif
	EndIf
EndEvent

Event OnSleepStop(bool abInterrupted)
	PlayerRef = Game.GetPlayer()
	if(VampConfig.CurrentBreastSize > VampConfig.MinBreastSize)
		Debug.Notification("Your breasts feel smaller")
		VampConfig.CurrentBreastSize -= 0.4
	EndIf

	if VampConfig.CurrentBreastSize < VampConfig.MinBreastSize
		VampConfig.CurrentBreastSize = VampConfig.MinBreastSize
	EndIf

	if(VampConfig.BreastGowing)
		NetImmerse.SetNodeScale(PlayerRef, NINODE_LEFT_BREAST, VampConfig.CurrentBreastSize, True)
		NetImmerse.SetNodeScale(PlayerRef, NINODE_LEFT_BREAST, VampConfig.CurrentBreastSize, False)
		NetImmerse.SetNodeScale(PlayerRef, NINODE_RIGHT_BREAST, VampConfig.CurrentBreastSize, True)
		NetImmerse.SetNodeScale(PlayerRef, NINODE_RIGHT_BREAST, VampConfig.CurrentBreastSize, False)
	EndIf

EndEvent

Function ShowFeedMassage()
	int nr = Utility.RandomInt(0, 5)
	If nr > FeedingTexts.Length
		nr = 4
	EndIf
	Debug.Notification(FeedingTexts[nr]);
EndFunction


;;;;;;;;;;;;;;; MOD EVENTS ;;;;;;;;;;;;;;;

Event NpcActionBloodMale(Form victim)
	Actor akRef = victim as Actor
	Debug.Notification(akRef.GetBaseObject().GetName() + " allows you to feed")

	actor[] sexActors = new actor[2]
    sexActors[0] = PlayerRef
    sexActors[1] = akRef

    sslBaseAnimation[] anims
    anims = SexLab.GetAnimationsByTag(2,"Blowjob")
    SexLab.StartSex(sexActors, anims, allowBed=true)

EndEvent

Event NpcActionBloodFemale(Form victim)
	Actor akRef = victim as Actor
	Debug.Notification(akRef.GetBaseObject().GetName() + " allows you to feed")

	actor[] sexActors = new actor[2]
    sexActors[0] = akRef
    sexActors[1] = PlayerRef

    sslBaseAnimation[] anims
    anims = SexLab.GetAnimationsByTag(2,"Lesbian","Oral")
    SexLab.StartSex(sexActors, anims, allowBed=true)

EndEvent

Event NpcHypnoFeed(Form Victim)
	Actor akRef = victim as Actor

	
	Game.ForceThirdPerson()
	utility.Wait(0.1)
	akRef.UnequipItem(akRef.GetWornForm(0x00000001),true,false)

	utility.Wait(0.33)

	PlayerRef.PlayIdleWithTarget(FeedFront, akRef)
	
	utility.Wait(0.3)
   	Game.TriggerScreenBlood(10)

   	utility.Wait(3)

   	PlayerVampireQuest.VampireFeed()
   	akRef.StopCombat()		
	akRef.StopCombatAlarm()
	PlayerRef.SetAttackActorOnSight(False)

EndEvent

Event SuccubusFeed(Form Succubus,Form Victim)
	Actor akRef = victim as Actor
	Actor Succ= Succubus as Actor
	
	Game.ForceThirdPerson()
	utility.Wait(0.1)
	akRef.UnequipItem(akRef.GetWornForm(0x00000001),true,false)

	utility.Wait(0.1)

	Succ.PlayIdleWithTarget(FeedFront, akRef)
	
	utility.Wait(0.3)
   	Game.TriggerScreenBlood(10)

   	utility.Wait(3)

   	akRef.StopCombat()		
	akRef.StopCombatAlarm()
	Succ.SetAttackActorOnSight(False)

EndEvent

Event SuccubusAggressiveFuck(Form a)
	Actor Succubus = a as Actor
	actor[] sexActors = new actor[2]
    sexActors[0] = Succubus
    sexActors[1] = PlayerRef

    sslBaseAnimation[] anims
    anims = SexLab.GetAnimationsByTag(2,"Cowgirl")

    SexLab.StartSex(sexActors, anims, victim=PlayerRef, allowBed=true)

EndEvent


Event SuccubusNonAggressiveFuck(Form a)
	Debug.Notification("Playing non agro fuck")
	Actor Succubus = a as Actor
	actor[] sexActors = new actor[2]
    sexActors[0] = Succubus
    sexActors[1] = PlayerRef

    sslBaseAnimation[] anims
    SexLab.StartSex(sexActors, anims, victim=PlayerRef)
EndEvent