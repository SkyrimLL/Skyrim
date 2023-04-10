Scriptname SLP_fcts_parasiteBarnacles extends Quest  

zadLibs Property libs Auto

SLP_fcts_utils Property fctUtils  Auto
SLP_fcts_parasites_devious Property fctDevious  Auto

Quest Property KynesBlessingQuest  Auto 
Quest Property QueenOfChaurusQuest  Auto 

Keyword Property _SLP_ParasiteBarnacles  Auto  

GlobalVariable Property _SLP_GV_numInfections  Auto 
GlobalVariable Property _SLP_GV_numBarnaclesInfections  Auto 

Armor Property SLP_harnessBarnaclesRendered Auto         ; Internal Device
Armor Property SLP_harnessBarnaclesInventory Auto        	       ; Inventory Device

ReferenceAlias Property BarnaclesInfectedAlias  Auto  
ObjectReference Property DummyAlias  Auto  

Sound Property WetFX  Auto

;------------------------------------------------------------------------------
Armor Function getParasiteByString(String deviousKeyword = ""  )
	Armor thisArmor = None

	if (deviousKeyword == "Barnacles" ) 
		thisArmor = SLP_harnessBarnaclesInventory
	EndIf

	return thisArmor
EndFunction

Armor Function getParasiteRenderedByString(String deviousKeyword = ""  )
	Armor thisArmor = None

	if (deviousKeyword == "Barnacles" ) 
		thisArmor = SLP_harnessBarnaclesRendered
	EndIf

	return thisArmor
EndFunction

Keyword Function getDeviousKeywordByString(String deviousKeyword = ""  )
	Keyword thisKeyword = None
 
	if (deviousKeyword == "Barnacles" )  
		thisKeyword = _SLP_ParasiteBarnacles
		
	else
		thisKeyword = fctDevious.getDeviousDeviceKeywordByString( deviousKeyword  )
	endIf

	return thisKeyword
EndFunction

Bool Function infectBarnacles( Actor kActor  )
 	Actor PlayerActor = Game.GetPlayer()

 	; Setting toggle back to 0 in case equip fails - the 'apply' function sets it to 1 if it succeeds
	; StorageUtil.SetIntValue(kActor, "_SLP_toggleSpiderEggBarnacles", 0 )

  	if (kActor == None)
  		kActor = PlayerActor
  	endIf

	If (StorageUtil.GetFloatValue(PlayerActor, "_SLP_chanceBarnacles" )==0.0)
		Debug.Trace("[SLP]	Parasite disabled - Aborting")
		Return False
	Endif

	If ((fctDevious.ActorHasKeywordByString( kActor, "Harness"  )) || (fctDevious.ActorHasKeywordByString( kActor, "Corset"  )) || (fctDevious.ActorHasKeywordByString( kActor, "Belt"  )) )
		Debug.Trace("[SLP]	Already wearing a corset - Aborting")
		Return False
	Endif


	If (!fctUtils.isFemale( kActor))
		Debug.Trace("[SLP]	Actor is not female - Aborting")
		Return False
	Endif
	

	equipParasiteNPCByString (kActor, "Barnacles")

	Return true ; Return applyBarnacles( kActor  )
EndFunction

Bool Function applyBarnacles( Actor kActor  )
 	Actor PlayerActor = Game.GetPlayer()

	If (kActor == PlayerActor)
		BarnaclesInfectedAlias.ForceRefTo(PlayerActor)
	endIf

	If !StorageUtil.HasIntValue(kActor, "_SLP_iBarnaclesInfections")
			StorageUtil.SetIntValue(kActor, "_SLP_iBarnaclesInfections",  0)
	EndIf

	StorageUtil.SetIntValue(kActor, "_SLP_toggleBarnacles", 1 )
	StorageUtil.SetIntValue(kActor, "_SLP_iBarnaclesDate", Game.QueryStat("Days Passed"))
	StorageUtil.SetIntValue(kActor, "_SLP_iInfections",  StorageUtil.GetIntValue(kActor, "_SLP_iInfections") + 1)
	StorageUtil.SetIntValue(kActor, "_SLP_iBarnaclesInfections",  StorageUtil.GetIntValue(kActor, "_SLP_iBarnaclesInfections") + 1)

	If (kActor == PlayerActor)
		_SLP_GV_numInfections.SetValue(StorageUtil.GetIntValue(kActor, "_SLP_iInfections"))
		_SLP_GV_numBarnaclesInfections.SetValue(StorageUtil.GetIntValue(kActor, "_SLP_iBarnaclesInfections"))
	endIf

	Sound.SetInstanceVolume(WetFX.Play(PlayerActor), 1.0)
	Utility.Wait(1.0) 
 
	SendModEvent("SLPBarnaclesInfection")

	if (!KynesBlessingQuest.GetStageDone(20)) && (kActor == PlayerActor)
		KynesBlessingQuest.SetStage(20)
	endif

	Return True
EndFunction

Function cureBarnacles( Actor kActor, Bool bHarvestParasite = False   )
 	Actor PlayerActor = Game.GetPlayer()
 
  	if (kActor == None)
  		kActor = PlayerActor
  	endIf


	If (isInfectedByString( kActor,  "Barnacles" ))
		StorageUtil.SetIntValue(kActor, "_SLP_toggleBarnacles", 0 )
		clearParasiteNPCByString (kActor, "Barnacles")

		If (bHarvestParasite)
			PlayerActor.AddItem(SLP_harnessBarnaclesInventory,1)
		Endif

		If (kActor == PlayerActor)
			BarnaclesInfectedAlias.ForceRefTo(DummyAlias)
		endIf

	Else
		; Reset variables if called after device is removed
		StorageUtil.SetIntValue(kActor, "_SLP_toggleBarnacles", 0)
	EndIf
EndFunction

Function refreshParasite(Actor kActor, String sParasite)
 	Actor PlayerActor = Game.GetPlayer()

	If (sParasite == "Barnacles")
		If (isInfectedByString( kActor,  "Barnacles" ))  
			StorageUtil.SetIntValue(kActor, "_SLP_toggleBarnacles", 1)
			equipParasiteNPCByString (kActor, "Barnacles")

			If (kActor == PlayerActor) 
				; Debug.Notification("[SLP]	Spriggan Alias attached")
				Debug.Trace("[SLP]	Barnacles Alias attached")
				BarnaclesInfectedAlias.ForceRefTo(PlayerActor)
			endIf
		Else
			StorageUtil.SetIntValue(kActor, "_SLP_toggleBarnacles", 0)
			clearParasiteNPCByString (kActor, "Barnacles")

			If (kActor == PlayerActor) 
				; Debug.Notification("[SLP]	Spriggan Alias attached")
				Debug.Trace("[SLP]	Barnacles Alias cleared")
				BarnaclesInfectedAlias.ForceRefTo(DummyAlias)	
			endif		
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
				ParasiteMessage = "The husks on my thighs keep pinching me!"
			elseif (rollMessage >= 20)
				ParasiteMessage = "One of the husks keep pushing against my ass!" 
			else 
				ParasiteMessage = "The husks on my breasts keep bouncing and stretching them!"
			endIf

		elseif (iSexLabValidateActor <= 0)
			if (rollMessage >= 120)
				ParasiteMessage = "The husks between my legs are making me so tight!"
			elseif (rollMessage >= 90)  
				ParasiteMessage = "My skin is so sensitive and hot!" 
			else 
				ParasiteMessage = "I swear I can feel their pleasure too!"
			endIf


		elseif	kParasiteHost.IsRunning() || kParasiteHost.IsSprinting() 
			if (rollMessage >= 90)
				ParasiteMessage = "The husks keep sucking on my tits."
			elseif (rollMessage >= 50)
				ParasiteMessage = "Running is turning the husks into a constant tingle"
			else 
				ParasiteMessage = "The thingling from the husks is breathtaking..."
			endIf

		elseif	kParasiteHost.IsInCombat() 
			if (rollMessage >= 90)
				ParasiteMessage = "The husks protect me with cloud of spores."
			elseif (rollMessage >= 70)
				ParasiteMessage = "The lights from the orbs is so comforting."
			else 
				ParasiteMessage = "Those orbs amplify sensations on my skin!." 
			endIf
			
		else
			if (rollmessage >= 118)
				ParasiteMessage = "These orbs keep releasing slime on my skin!"		
            elseif (rollMessage >= 6)
                ParasiteMessage = "If only the husks could spread and cover me completely!"
			else
				ParasiteMessage = "The husks are almost completely over my pussy!"
			endIf
		endif

	else
		; Third person thought
		if kParasiteHost.IsOnMount() 
			if (rollMessage >= 120)
				ParasiteMessage = "The husks keep pinching your thighs."
			elseif (rollMessage >= 20)
				ParasiteMessage = "One of the husks keep pushing against your ass!" 
			else 
				ParasiteMessage = "The husks on your breasts keep bouncing and stretching them!"
			endIf

		elseif (iSexLabValidateActor <= 0)
			if (rollMessage >= 120)
				ParasiteMessage = "The husks between your legs are making you so much tighter!"
			elseif (rollMessage >= 90)  
				ParasiteMessage = "Your skin is so sensitive and itchy!" 
			else 
				ParasiteMessage = "The husks become warmer from sex!"
			endIf


		elseif	kParasiteHost.IsRunning() || kParasiteHost.IsSprinting() 
			if (rollMessage >= 90)
				ParasiteMessage = "The husks keep sucking on your tits painfully."
			elseif (rollMessage >= 50)
				ParasiteMessage = "Running is turning the husks into a hard shell."
			else 
				ParasiteMessage = "The thingling from the husks is driving you mad..."
			endIf

		elseif	kParasiteHost.IsInCombat() 
			if (rollMessage >= 90)
				ParasiteMessage = "The husks ooze a thin cloud of spores."
			elseif (rollMessage >= 70)
				ParasiteMessage = "The lights from the orbs is getting more menacing."
			else 
				ParasiteMessage = "Those orbs feel almost electric on your skin!." 
			endIf
			
		else
			if (rollmessage >= 118)
				ParasiteMessage = "These orbs keep your skin well lubricated!"		
            elseif (rollMessage >= 6)
                ParasiteMessage = "What if the husks spread and cover you completely!"
			else
				ParasiteMessage = "The husks are almost covering your pussy!"
			endIf
		endif
	endIf

	Debug.Notification(ParasiteMessage) ;temp messages
endfunction