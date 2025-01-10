Scriptname SLP_fcts_parasiteSpiderEgg extends Quest  

zadLibs Property libs Auto

SLP_fcts_utils Property fctUtils  Auto
SLP_fcts_parasites_devious Property fctDevious  Auto

Quest Property KynesBlessingQuest  Auto 
Quest Property QueenOfChaurusQuest  Auto 

Keyword Property _SLP_ParasiteSpiderEgg  Auto  
Keyword Property _SLP_ParasiteSpiderPenis  Auto  

GlobalVariable Property _SLP_GV_numInfections  Auto 
GlobalVariable Property _SLP_GV_numSpiderEggInfections  Auto 

Armor Property SLP_plugSpiderEggRendered Auto         ; Internal Device
Armor Property SLP_plugSpiderEggInventory Auto        	       ; Inventory Device
Armor Property SLP_plugSpiderPenisRendered Auto         ; Internal Device
Armor Property SLP_plugSpiderPenisInventory Auto        	       ; Inventory Device

ReferenceAlias Property SpiderEggInfectedAlias  Auto  
ObjectReference Property DummyAlias  Auto  

SPELL Property StomachRot Auto

Sound Property CritterFX  Auto
Sound Property WetFX  Auto

Ingredient  Property SmallSpiderEgg Auto

;------------------------------------------------------------------------------
Armor Function getParasiteByString(String deviousKeyword = ""  )
	Armor thisArmor = None

	if (deviousKeyword == "SpiderEgg" ) 
		thisArmor = SLP_plugSpiderEggInventory

	Elseif (deviousKeyword == "SpiderPenis" )  
		thisArmor = SLP_plugSpiderPenisInventory

	EndIf

	return thisArmor
EndFunction

Armor Function getParasiteRenderedByString(String deviousKeyword = ""  )
	Armor thisArmor = None

	if (deviousKeyword == "SpiderEgg" ) 
		thisArmor = SLP_plugSpiderEggRendered

	Elseif (deviousKeyword == "SpiderPenis" )  
		thisArmor = SLP_plugSpiderPenisRendered

	EndIf

	return thisArmor
EndFunction

Keyword Function getDeviousKeywordByString(String deviousKeyword = ""  )
	Keyword thisKeyword = None
 
	if (deviousKeyword == "SpiderEgg" )  
		thisKeyword = _SLP_ParasiteSpiderEgg

	elseif (deviousKeyword == "SpiderPenis" )  
		thisKeyword = _SLP_ParasiteSpiderPenis

	else
		thisKeyword = fctDevious.getDeviousDeviceKeywordByString( deviousKeyword  )

	endIf

	return thisKeyword
EndFunction

Bool Function infectSpiderEgg( Actor kActor )
 	Actor PlayerActor = Game.GetPlayer()

 	; Setting toggle back to 0 in case equip fails - the 'apply' function sets it to 1 if it succeeds
	; StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderEgg", 0 )

  	if (kActor == None)
  		kActor = PlayerActor
  	endIf
 
 	If (StorageUtil.GetFloatValue(PlayerActor, "_SLP_chanceSpiderEgg" )==0.0)
		Debug.Trace("[SLP]	Parasite disabled - Aborting")
		Return False
	Endif

	If (isInfectedByString( kActor,  "SpiderEgg" ))
		Debug.Trace("[SLP]	Already infected - Aborting")
		Return False
	Endif

	If (fctDevious.ActorHasKeywordByString( kActor, "PlugVaginal"  ))
		Debug.Trace("[SLP]	Already wearing a vaginal plug - Aborting")
		Return False
	Endif

	If (!fctUtils.isFemale( kActor))
		Debug.Trace("[SLP]	Actor is not female - Aborting")
		Return False
	Endif

	equipParasiteNPCByString (kActor, "SpiderEgg")


	Return true ; Return applySpiderEgg( kActor )

EndFunction

Bool Function applySpiderEgg( Actor kActor )
 	Actor PlayerActor = Game.GetPlayer()
  	Int iNumSpiderEggs

	iNumSpiderEggs = Utility.RandomInt(5,10)
	If (StorageUtil.GetIntValue(kActor, "_SLP_iSpiderEggCount")!=0)
		iNumSpiderEggs = StorageUtil.GetIntValue(kActor, "_SLP_iSpiderEggCount")
	Endif

	If (kActor == PlayerActor)
		SpiderEggInfectedAlias.ForceRefTo(PlayerActor)
	endIf
	if (iNumSpiderEggs>=8)
		StomachRot.RemoteCast(kActor as ObjectReference, kActor,kActor as ObjectReference)
	endIf

	fctUtils.ApplyBodyChange( kActor, "SpiderEgg", "Belly", 1.0 + (4.0 * (iNumSpiderEggs as Float) / StorageUtil.GetFloatValue(PlayerActor, "_SLP_bellyMaxSpiderEgg" )), StorageUtil.GetFloatValue(PlayerActor, "_SLP_bellyMaxSpiderEgg" ))

	If !StorageUtil.HasIntValue(kActor, "_SLP_iSpiderEggInfections")
			StorageUtil.SetIntValue(kActor, "_SLP_iSpiderEggInfections",  0)
	EndIf

	StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderEgg", 1 )
	StorageUtil.SetIntValue(kActor, "_SLP_iSpiderEggDate", Game.QueryStat("Days Passed"))
	StorageUtil.SetIntValue(kActor, "_SLP_iInfections",  StorageUtil.GetIntValue(kActor, "_SLP_iInfections") + 1)
	StorageUtil.SetIntValue(kActor, "_SLP_iSpiderEggInfections",  StorageUtil.GetIntValue(kActor, "_SLP_iSpiderEggInfections") + 1)
	StorageUtil.SetIntValue(kActor, "_SLP_iSpiderEggCount", iNumSpiderEggs )

	If (kActor == PlayerActor)
		_SLP_GV_numInfections.SetValue(StorageUtil.GetIntValue(kActor, "_SLP_iInfections"))
		_SLP_GV_numSpiderEggInfections.SetValue(StorageUtil.GetIntValue(kActor, "_SLP_iSpiderEggInfections"))
	endIf

	Sound.SetInstanceVolume(WetFX.Play(PlayerActor), 1.0)
	Utility.Wait(1.0)
	Sound.SetInstanceVolume(CritterFX.Play(PlayerActor), 1.0)
	Utility.Wait(1.0)

	SendModEvent("SLPSpiderEggInfection")

	if (!KynesBlessingQuest.GetStageDone(20)) && (kActor == PlayerActor)
		KynesBlessingQuest.SetStage(20)
	endif
	
	Return True
EndFunction

Function cureSpiderEgg( Actor kActor, Bool bHarvestParasite = False   )
  	Actor PlayerActor = Game.GetPlayer()
 	Int iNumSpiderEggs
 	Int iNumSpiderEggsRemoved
 
  	if (kActor == None)
  		kActor = PlayerActor
  	endIf

  	If (isInfectedByString( kActor,  "SpiderPenis" )) 
  		; The spider penis is blocking the eggs
  		return
  	endif

  	
	If (fctDevious.ActorHasKeywordByString( kActor, "Belt"  ))
		Debug.Trace("[SLP]	Already wearing a belt - Aborting")
		Return 
	Endif
 
	If (isInfectedByString( kActor,  "SpiderEgg" ))
		iNumSpiderEggsRemoved = Utility.RandomInt(2,8)
		iNumSpiderEggs = StorageUtil.GetIntValue(kActor, "_SLP_iSpiderEggCount") - iNumSpiderEggsRemoved

		if (iNumSpiderEggs < 0) || (bHarvestParasite)
			If (kActor == PlayerActor)
				SpiderEggInfectedAlias.ForceRefTo(DummyAlias)
			endIf
			iNumSpiderEggs = 0
			StorageUtil.SetIntValue(kActor, "_SLP_iSpiderEggCount", 0 )

			kActor.DispelSpell(StomachRot)

			StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderEgg", 0)
			clearParasiteNPCByString (kActor, "SpiderEgg")

			If (bHarvestParasite)
				PlayerActor.AddItem(SLP_plugSpiderEggInventory,1)
			else
				PlayerActor.AddItem(SmallSpiderEgg,iNumSpiderEggsRemoved)
			Endif

		else
			debug.messagebox("Some eggs detached from the cluster... more remain inside you.")
			PlayerActor.AddItem(SmallSpiderEgg,iNumSpiderEggsRemoved)
		Endif

		fctUtils.ApplyBodyChange( kActor, "SpiderEgg", "Belly", 1.0 + (4.0 * (iNumSpiderEggs as Float) / StorageUtil.GetFloatValue(PlayerActor, "_SLP_bellyMaxSpiderEgg" )), StorageUtil.GetFloatValue(PlayerActor, "_SLP_bellyMaxSpiderEgg" ) )
 
		StorageUtil.SetIntValue(kActor, "_SLP_iSpiderEggCount", iNumSpiderEggs )
		SendModEvent("SLPSpiderEggInfection")
	Else
		; Reset variables if called after device is removed
		StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderEgg", 0)
	EndIf
EndFunction

Function cureSpiderEggAll( Actor kActor, Bool bHarvestParasite = False   )
  	Actor PlayerActor = Game.GetPlayer()
 	Int iNumSpiderEggs
 	Int iNumSpiderEggsRemoved
 
  	if (kActor == None)
  		kActor = PlayerActor
  	endIf

  	If (isInfectedByString( kActor,  "SpiderPenis" )) 
  		; The spider penis is blocking the eggs
  		return
  	endif
  	
	If (fctDevious.ActorHasKeywordByString( kActor, "Belt"  ))
		Debug.Trace("[SLP]	Already wearing a belt - Aborting")
		Return 
	Endif

	If (isInfectedByString( kActor,  "SpiderEgg" ))
		iNumSpiderEggsRemoved = StorageUtil.GetIntValue(kActor, "_SLP_iSpiderEggCount")
		; iNumSpiderEggs = StorageUtil.GetIntValue(kActor, "_SLP_iSpiderEggCount") - iNumSpiderEggsRemoved


		If (kActor == PlayerActor)
			SpiderEggInfectedAlias.ForceRefTo(DummyAlias)
		endIf

		iNumSpiderEggs = 0
		StorageUtil.SetIntValue(kActor, "_SLP_iSpiderEggCount", 0 )

		kActor.DispelSpell(StomachRot)

		StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderEgg", 0)
		clearParasiteNPCByString (kActor, "SpiderEgg")

		If (bHarvestParasite)
			PlayerActor.AddItem(SLP_plugSpiderEggInventory,1)
		else
			PlayerActor.AddItem(SmallSpiderEgg,iNumSpiderEggsRemoved)
		Endif


		fctUtils.ApplyBodyChange( kActor, "SpiderEgg", "Belly", 1.0 + (4.0 * (iNumSpiderEggs as Float) / StorageUtil.GetFloatValue(PlayerActor, "_SLP_bellyMaxSpiderEgg" )), StorageUtil.GetFloatValue(PlayerActor, "_SLP_bellyMaxSpiderEgg" ) )
 
		StorageUtil.SetIntValue(kActor, "_SLP_iSpiderEggCount", iNumSpiderEggs )
		SendModEvent("SLPSpiderEggInfection")
	Else
		; Reset variables if called after device is removed
		StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderEgg", 0)
	EndIf
EndFunction


;------------------------------------------------------------------------------
Bool Function infectSpiderPenis( Actor kActor  )
 	Actor PlayerActor = Game.GetPlayer()

 	; Setting toggle back to 0 in case equip fails - the 'apply' function sets it to 1 if it succeeds
	; StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderPenis", 0 )

  	if (kActor == None)
  		kActor = PlayerActor
  	endIf
 
	If (StorageUtil.GetFloatValue(PlayerActor, "_SLP_chanceSpiderPenis" )==0.0)
		Debug.Trace("[SLP]	Parasite disabled - Aborting")
		Return False
	Endif

	If (isInfectedByString( kActor,  "SpiderPenis" )) || (isInfectedByString( kActor,  "ChaurusQueenVag" )) || (isInfectedByString( kActor,  "ChaurusWormVag" )) || (isInfectedByString( kActor,  "SpiderEggs" ))
		Debug.Trace("[SLP]	Already infected - Aborting")
		Return False
	Endif

	If (fctDevious.ActorHasKeywordByString( kActor, "PlugVaginal"  ))
		Debug.Trace("[SLP]	Already wearing a vaginal plug - Aborting")
		Return False
	Endif

	If (!fctUtils.isFemale( kActor))
		Debug.Trace("[SLP]	Actor is not female - Aborting")
		Return False
	Endif
 
	equipParasiteNPCByString (kActor, "SpiderPenis")

	Return true ; Return applySpiderPenis( kActor  )
EndFunction

Bool Function applySpiderPenis( Actor kActor  )
 	Actor PlayerActor = Game.GetPlayer()
  	Int iNumSpiderEggs

	iNumSpiderEggs = Utility.RandomInt(5,10)

	If (kActor == PlayerActor)
		SpiderEggInfectedAlias.ForceRefTo(PlayerActor)
	endIf
	if (iNumSpiderEggs>=4)
		StomachRot.RemoteCast(kActor as ObjectReference, kActor,kActor as ObjectReference)
	endIf

	fctUtils.ApplyBodyChange( kActor, "SpiderEgg", "Belly", 1.0 + (4.0 * (iNumSpiderEggs as Float) / StorageUtil.GetFloatValue(PlayerActor, "_SLP_bellyMaxSpiderEgg" )), StorageUtil.GetFloatValue(PlayerActor, "_SLP_bellyMaxSpiderEgg" ) )

	If !StorageUtil.HasIntValue(kActor, "_SLP_iSpiderEggInfections")
			StorageUtil.SetIntValue(kActor, "_SLP_iSpiderEggInfections",  0)
	EndIf

	StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderPenis", 1 )
	StorageUtil.SetIntValue(kActor, "_SLP_iSpiderEggDate", Game.QueryStat("Days Passed"))
	StorageUtil.SetIntValue(kActor, "_SLP_iSpiderPenisDate", Game.QueryStat("Days Passed"))
	StorageUtil.SetIntValue(kActor, "_SLP_iInfections",  StorageUtil.GetIntValue(kActor, "_SLP_iInfections") + 1)
	StorageUtil.SetIntValue(kActor, "_SLP_iSpiderEggInfections",  StorageUtil.GetIntValue(kActor, "_SLP_iSpiderEggInfections") + 1)
	StorageUtil.SetIntValue(kActor, "_SLP_iSpiderEggCount", iNumSpiderEggs )

	If (kActor == PlayerActor)
		_SLP_GV_numInfections.SetValue(StorageUtil.GetIntValue(kActor, "_SLP_iInfections"))
		_SLP_GV_numSpiderEggInfections.SetValue(StorageUtil.GetIntValue(kActor, "_SLP_iSpiderEggInfections"))
	endIf

	Sound.SetInstanceVolume(WetFX.Play(PlayerActor), 1.0)
	Utility.Wait(1.0)
	Sound.SetInstanceVolume(CritterFX.Play(PlayerActor), 1.0)
	Utility.Wait(1.0)
 
	SendModEvent("SLPSpiderEggInfection")

	if (!KynesBlessingQuest.GetStageDone(20)) && (kActor == PlayerActor)
		KynesBlessingQuest.SetStage(20)
	endif

	
	Return True
EndFunction

Function cureSpiderPenis( Actor kActor, Bool bHarvestParasite = False   )
 	Actor PlayerActor = Game.GetPlayer()

  	if (kActor == None)
  		kActor = PlayerActor
  	endIf

  	
	If (fctDevious.ActorHasKeywordByString( kActor, "Belt"  ))
		Debug.Trace("[SLP]	Already wearing a belt - Aborting")
		Return  
	Endif
 
	If (isInfectedByString( kActor,  "SpiderPenis" ))
		StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderPenis", 0 )
		clearParasiteNPCByString (kActor, "SpiderPenis")

		If (bHarvestParasite)
			PlayerActor.AddItem(SLP_plugSpiderPenisInventory,1)
		Endif

		StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderEgg", 1 )
		equipParasiteNPCByString (kActor, "SpiderEgg")

	Else
		; Reset variables if called after device is removed
		StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderPenis", 0)
	EndIf
EndFunction

Function refreshParasite(Actor kActor, String sParasite)

	If (sParasite == "SpiderPenis")
		If (isInfectedByString( kActor,  "SpiderPenis" ))  
			StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderPenis", 1)
			equipParasiteNPCByString (kActor, "SpiderPenis")

		Else
			StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderPenis", 0)
			clearParasiteNPCByString (kActor, "SpiderPenis")
		Endif

	ElseIf (sParasite == "SpiderEgg")
		If (isInfectedByString( kActor,  "SpiderEgg" ))  
			StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderEgg", 1)
			equipParasiteNPCByString (kActor, "SpiderEgg")


		Else
			StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderEgg", 0)
			clearParasiteNPCByString (kActor, "SpiderEgg")
		Endif

	Endif

EndFunction
;------------------------------------------------------------------------------
Bool Function isInfectedByString( Actor akActor,  String sParasite  )
	Bool isInfected = False

	; By order of complexity

	if (akActor && sParasite && (StorageUtil.GetIntValue(akActor, "_SLP_toggle" + sParasite)==1) )
		isInfected = True

	elseif (akActor && sParasite && (StorageUtil.GetIntValue(akActor, "_SLP_iHiddenParasite_" + sParasite)==1) )
		isInfected = True

	elseif (akActor && sParasite && akActor.WornHasKeyword(getDeviousKeywordByString(sParasite)) )
		isInfected = True
	Endif

	Return isInfected
EndFunction

Function equipParasiteNPCByString(Actor kActor, String sParasite)
	fctDevious.equipParasiteNPC (kActor, sParasite,getDeviousKeywordByString(sParasite),getParasiteByString(sParasite), getParasiteRenderedByString(sParasite) ) 
EndFunction

Function clearParasiteNPCByString(Actor kActor, String sParasite)
	fctDevious.clearParasiteNPC (kActor, sParasite,getDeviousKeywordByString(sParasite),getParasiteByString(sParasite), true, true)
EndFunction


Bool Function ActorHasKeywordByString(actor akActor, String deviousKeyword = "")
	return libs.ActorHasKeyword(akActor, getDeviousKeywordByString( deviousKeyword ))
EndFunction


; ------- Parasite thoughts



function parasiteRandomThoughts(actor kParasiteHost, Int iSexLabValidateActor = 1)
	Int rollMessage 
	Int rollFirstPerson 
	String ParasiteMessage = ""
	Float fHormoneParasite = StorageUtil.GetFloatValue(kParasiteHost, "_SLH_fHormonePheromones" ) 	 

	rollMessage = Utility.RandomInt(0,140)
	rollFirstPerson = Utility.RandomInt(0,100)

	;wait a little to show the messages, because on ragdoll the hud is hidden
	; Utility.Wait(2.0)

	If (StorageUtil.GetFloatValue(kParasiteHost, "_SLP_thoughtsDelay")==0)
		Return
	Endif

	; Under 50.0, only play a sound
	; if (fHormoneParasite<50.0)
	; 	Return
	; Endif

	; Debug.Notification("[SLH] Parasite First Person Roll: " + rollFirstPerson)
	; Debug.Notification("[SLH] Parasite First Person: " + (StorageUtil.GetFloatValue(kParasiteHost, "_SLH_fHormonePheromones") as Int))

	If (rollFirstPerson <= (fHormoneParasite as Int))
		; First person thought
		if kParasiteHost.IsOnMount() 
			if (rollMessage >= 120)
				ParasiteMessage = "I hope the eggs won't get crushed from riding!"
			elseif (rollMessage >= 110)
				ParasiteMessage = "Riding is making the eggs bounce inside me!" 
			elseif (rollMessage >= 90)
				ParasiteMessage = "I can feel the eggs so deep from riding..."
			elseif (rollMessage >= 80)
				ParasiteMessage = "Riding with a belly full of eggs is going to make me come!"
			elseif (rollMessage >= 60)
				ParasiteMessage = "I bet riding would feel even better with more spider eggs inside me."
			elseif (rollMessage >= 50)
				ParasiteMessage = "The eggs are making me tingle!"
			elseif (rollMessage >= 40) 
				ParasiteMessage = "I need to find another spider and get bred more."
			elseif (rollMessage >= 20)
				ParasiteMessage = "The eggs keep rolling so deep inside me!" 
			else 
				ParasiteMessage = "Those eggs feel so good! *Giggle*"
			endIf

		elseif (iSexLabValidateActor <= 0)
			if (rollMessage >= 120)
				ParasiteMessage = "The eggs are filling me up so good!"
			elseif (rollMessage >= 115)
				ParasiteMessage = "I can feel the eggs rub me fron the inside!"
			elseif (rollMessage >= 110)
				ParasiteMessage = "My vagina is so full right now!"
			elseif (rollMessage >= 109)
				ParasiteMessage = "Being fucked with these eggs inside is making me so horny."
			elseif (rollMessage >= 107)
				ParasiteMessage = "The eggs are making me so wet!"
			elseif (rollMessage >= 105)
				ParasiteMessage = "Always wet, always horny, always full of eggs."
			elseif (rollMessage >= 100)
				ParasiteMessage = "I need get fucked by spiders more."
			elseif (rollMessage >= 90)  
				ParasiteMessage = "I could fuck full of eggs all day long!" 
			else 
				ParasiteMessage = "I need to keep these eggs in or find more!"
			endIf


		elseif	kParasiteHost.IsRunning() || kParasiteHost.IsSprinting() 
			if (rollMessage >= 90)
				ParasiteMessage = "The eggs keep rolling inside me."
			elseif (rollMessage >= 50)
				ParasiteMessage = "I swear one egg is about to push out when I run."
			else 
				ParasiteMessage = "Gosh, these eggs rubbing inside me make me so horny..."
			endIf

		elseif	kParasiteHost.IsInCombat() 
			if (rollMessage >= 90)
				ParasiteMessage = "I can swear the eggs just pulled deeper inside me."
			elseif (rollMessage >= 70)
				ParasiteMessage = "The eggs are making me so slimy between my legs."
			else 
				ParasiteMessage = "Those eggs are driving me crazy!." 
			endIf
			
		else
			if (rollmessage >= 118)
				ParasiteMessage = "These eggs are making me feel so full!"		
            elseif (rollMessage >= 6)
                ParasiteMessage = "What if an egg breaks and a spider comes out!?"
			else
				ParasiteMessage = "Ohhh one egg almost pushed out!"
			endIf
		endif

	else
		; Third person thought
		if kParasiteHost.IsOnMount() 
			if (rollMessage >= 120)
				ParasiteMessage = "The eggs keep your pussy lips spread from riding!"
			elseif (rollMessage >= 110)
				ParasiteMessage = "Riding is making the eggs bounce inside you!" 
			elseif (rollMessage >= 90)
				ParasiteMessage = "The eggs burrow deeper from riding..."
			elseif (rollMessage >= 80)
				ParasiteMessage = "Riding with a belly full of eggs feels so good!"
			elseif (rollMessage >= 60)
				ParasiteMessage = "Riding would feel even better with more spider eggs inside you."
			elseif (rollMessage >= 50)
				ParasiteMessage = "The eggs are driving you mad!"
			elseif (rollMessage >= 40) 
				ParasiteMessage = "You need to find another spider to breed you."
			elseif (rollMessage >= 20)
				ParasiteMessage = "The eggs keep rolling so deep inside you!" 
			else 
				ParasiteMessage = "Those eggs feel so good inside!"
			endIf

		elseif (iSexLabValidateActor <= 0)
			if (rollMessage >= 120)
				ParasiteMessage = "The eggs are filling you up so good!"
			elseif (rollMessage >= 115)
				ParasiteMessage = "You can feel the eggs rub and stretch you."
			elseif (rollMessage >= 110)
				ParasiteMessage = "Your vagina is so full right now!"
			elseif (rollMessage >= 109)
				ParasiteMessage = "Being fucked with these eggs inside is making you so horny."
			elseif (rollMessage >= 107)
				ParasiteMessage = "The eggs are making you so wet!"
			elseif (rollMessage >= 105)
				ParasiteMessage = "Always wet, always horny, always full of eggs."
			elseif (rollMessage >= 100)
				ParasiteMessage = "You need to find more spiders to fuck."
			elseif (rollMessage >= 90)  
				ParasiteMessage = "You could fuck full of eggs all day long!" 
			else 
				ParasiteMessage = "You need to keep these eggs in or find more!"
			endIf


		elseif	kParasiteHost.IsRunning() || kParasiteHost.IsSprinting() 
			if (rollMessage >= 90)
				ParasiteMessage = "The eggs keep rolling inside you."
			elseif (rollMessage >= 50)
				ParasiteMessage = "One egg is about to burst out as you run."
			else 
				ParasiteMessage = "These eggs rubbing inside you and keep you horny."
			endIf

		elseif	kParasiteHost.IsInCombat() 
			if (rollMessage >= 90)
				ParasiteMessage = "The eggs pull deeper inside you."
			elseif (rollMessage >= 70)
				ParasiteMessage = "The eggs are making you so slimy between your legs."
			else 
				ParasiteMessage = "Those eggs are so distracting!." 
			endIf
			
		else
			if (rollmessage >= 118)
				ParasiteMessage = "These eggs are making you feel so full!"		
            elseif (rollMessage >= 6)
                ParasiteMessage = "What if an egg breaks and a spider comes out!?"
			else
				ParasiteMessage = "One egg almost pushed out!"
			endIf
		endif
	endIf

	Debug.Notification(ParasiteMessage) ;temp messages
endfunction

