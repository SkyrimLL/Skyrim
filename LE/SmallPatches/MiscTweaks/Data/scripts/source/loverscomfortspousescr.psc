Scriptname LoversComfortSpouseScr extends ReferenceAlias  

LoversComfortUtilScr Property lcUtil Auto
LoversComfortPlayerScr Property lcPlayer Auto
LoversComfortConfigScr Property lcConfig Auto

Quest Property lcSpouseNoteQuest Auto
Quest Property lcLoverNoteQuest Auto
Quest Property lcLoverHello04Quest Auto
Quest Property lcLoverHello02Quest Auto

ReferenceAlias Property lcNoteFromSpouse Auto
ReferenceAlias Property lcNoteFromLover Auto

Actor Property PlayerRef Auto
WiCourierScript Property WICourierScr Auto
GlobalVariable Property GameDaysPassed Auto

Float LastSpouseNoteTime = 0.0;
Float NextSceneTime03 = 0.0;
Float NextSceneTime04 = 0.0;

Event OnUpdate()
	Actor akSpouse = GetActorReference()
	
	If (akSpouse == None)
		; no spouse shut-down script
		Return
	EndIf
	lcUtil.Log(self,"SpouseOnUpdate")

	; Check Marriage Stuff
	; lcUtil.Log(self,"SpouseCurrentHome (Int) " + (lcPlayer.RelationshipMarriageFIN as RelationshipMarriageSpouseHouseScript).SpouseCurrentHome)
	; if (lcPlayer.RelationshipMarriageFIN as RelationshipMarriageSpouseHouseScript).SpouseHouse
	;	lcUtil.Log(self,"SpouseHouse (Actor) " + (lcPlayer.RelationshipMarriageFIN as RelationshipMarriageSpouseHouseScript).SpouseHouse.GetActorRef().GetDisplayName())
	;	lcUtil.Log(self,"SpouseHouse (ToInt) " + (lcPlayer.RelationshipMarriageFIN as RelationshipMarriageSpouseHouseScript).TranslateHouseAliasToInt((lcPlayer.RelationshipMarriageFIN as RelationshipMarriageSpouseHouseScript).SpouseHouse))
	; EndIf
	
	Actor akLover = lcPlayer.GetSpouseLover()
	lcUtil.LogName(self,akLover,"is current spouse love")
	
	Actor tmpAk = Game.FindRandomActorFromRef(akSpouse, 1024)
	lcUtil.LogName(self,tmpAk,"is possible spouse love")
	If (lcUtil.IsValidActor(tmpAk, awakeOK = true, skipLoc = true) >= 0)
		akLover = SelectLover(tmpAk, akLover)
		lcUtil.LogName(self,akLover,"selected as possible lover (OnUpdate)")
		lcPlayer.SetSpouseLover(akLover)
	EndIf
	
	UpdateLoverRelationship(akSpouse, akLover)
	SpouseSendCourier(akSpouse)
	
	RegisterForSingleUpdate(60.0)
EndEvent

Function DoLoversScan(FormList validActorList)
	Actor akLover = lcPlayer.GetSpouseLover()

	lcUtil.Log(self,"possible ValidActors for lover: " + validActorList.GetSize())

	int i = 0
	While (i < validActorList.GetSize())
		lcUtil.LogName(self,akLover,"checked as possible lover (LoverScan)")
		Actor tmpAk = (validActorList.GetAt(i) as Actor)
		akLover = SelectLover(tmpAk, akLover)
		i += 1
	EndWhile
	
	lcPlayer.SetSpouseLover(akLover)
	
	RegisterForSingleUpdate(1.0)
EndFunction


Actor Function SelectLover(Actor akRef, Actor prevLover)
	lcUtil.Log(self,"SelectLover")
	Actor akSpouse = GetActorReference()
	If akRef
		lcUtil.LogName(self,akSpouse," is the spouse")
	EndIf
	If akRef
		lcUtil.LogName(self,akRef," is the possible lover")
	EndIf
	If prevLover
		lcUtil.LogName(self,prevLover," is the previous lover")
	EndIf

	
	If (akRef == None)
		lcUtil.Log(self,"New lover is null - return previous")
		Return prevLover
	ElseIf (akSpouse == None)
		lcUtil.Log(self,"Spouse is null - return previous")
		Return prevLover
	ElseIf (akSpouse == akRef)
		lcUtil.Log(self,"New lover is spouse - return previous")
		Return prevLover
	EndIf
	
	If (prevLover != None)
		If (akSpouse == prevLover)
			lcUtil.Log(self,"Spouse is previous lover, unset previous")
			prevLover = None
		ElseIf (!lcUtil.IsInSameSettlement(akSpouse, prevLover))
			lcUtil.Log(self,"Spouse and previous lover not in the same location, unset previous")
			prevLover = None
		ElseIf (!lcConfig.IsSpouseGay && akSpouse.GetLeveledActorBase().GetSex() == prevLover.GetLeveledActorBase().GetSex())
			lcUtil.Log(self,"Spouse is not gay, and lover is the same sex, unset previous")
			prevLover = None
		EndIf
	EndIf
	
	; check settings
	If (!(!lcConfig.IsSpouseGay && akSpouse.GetLeveledActorBase().GetSex() == akRef.GetLeveledActorBase().GetSex()))
		lcUtil.Log(self,"Spouse can love new possible lover")
		If (prevLover == None)
			lcUtil.Log(self,"Previous lover unset")
			If (akRef.GetRelationshipRank(akSpouse) >= 0)
				lcUtil.Log(self,"Relationship between new lover and spouse is high enough")
				Return akRef
			EndIf
		ElseIf (akRef.GetRelationshipRank(akSpouse) > prevLover.GetRelationshipRank(akSpouse))
			lcUtil.Log(self,"New lover has a higher relationship to spouse than previous")
			Return akRef
		ElseIf (lcUtil.GetSpouseLoverRank(akRef) > lcUtil.GetSpouseLoverRank(prevLover))
			lcUtil.Log(self,"New lover has a higher LC rank than previous")
			Return akRef
		EndIf
	EndIf
	
	lcUtil.Log(self,"New lover wasn't better, stick with the old")
	Return prevLover
EndFunction


Function UpdateLoverRelationship(Actor akSpouse, Actor akSpouseLover)
	If (akSpouse == None || akSpouseLover == None)
		return
	ElseIf (!lcUtil.IsInSameSettlement(akSpouse, akSpouseLover))
		return
	EndIf
	
	lcUtil.Log(self,"UpdateLoverRelationship")

	Int loverRank = lcUtil.GetSpouseLoverRank(akSpouseLover)
	lcUtil.Log(self,"Current Lover rank " + loverRank)
	Int hoursSinceSex = lcUtil.slaUtil.GetActorHoursSinceLastSex(akSpouseLover)
	lcUtil.Log(self,"Hours since sex with lover " + hoursSinceSex)
	
	Float timeSinceLastContact = GameDaysPassed.GetValue() - StorageUtil.GetFloatValue(akSpouseLover, "LoversComfort.SpouseLoverContactTime", 0)
	lcUtil.Log(self,"Time since last contact " + timeSinceLastContact)
	lcUtil.Log(self,"Spouse Arousal: " + lcUtil.GetActorArousal(akSpouse) + " Threshold: " + lcConfig.gSpouseArousalThreshold.GetValue())
	If (lcUtil.GetActorArousal(akSpouse) > lcConfig.gSpouseArousalThreshold.GetValue() && timeSinceLastContact >= 1)
		; cheap cooldown method
		StorageUtil.SetFloatValue(akSpouseLover, "LoversComfort.SpouseLoverContactTime", GameDaysPassed.GetValue())
		lcUtil.Log(self,"Increasing Lover rank by 1")
		loverRank = lcUtil.UpdateSpouseLoverRank(akSpouseLover, 1)
		lcUtil.slaUtil.UpdateActorExposure(akSpouse, -10, "contact with lover " + akSpouseLover.GetLeveledActorBase().GetName())

		If (loverRank == 3)
			If (!lcLoverNoteQuest.IsRunning())
				lcUtil.Log(self,"Starting Lover Letter Quest")
				lcLoverNoteQuest.Start()
			Else
				lcUtil.Log(self,"Restarting Lover Letter Quest")
				lcNoteFromLover.GetRef().Delete()
				lcLoverNoteQuest.Stop()
				lcLoverNoteQuest.Start()
			EndIf
		EndIf
	EndIf
	
	If (akSpouse.GetCurrentLocation() != PlayerRef.GetCurrentLocation())
		lcUtil.Log(self,"Player and Spouse are in different locations")
		Return
	ElseIf (akSpouse.GetCurrentLocation() != akSpouseLover.GetCurrentLocation())
		lcUtil.Log(self,"Spouse and Lover are in different locations")
		Return
	ElseIf (akSpouse.IsInFaction(lcPlayer.SexLab.AnimatingFaction))
		lcUtil.LogName(Self,akSpouse,"- Spouse busy having sex")
		Return
	ElseIf (akSpouseLover.IsInFaction(lcPlayer.SexLab.AnimatingFaction))
		lcUtil.LogName(Self,akSpouseLover,"- Lover busy having sex")
		Return
	EndIf	
		
	If (loverRank >= 5 && lcUtil.GetActorArousal(akSpouse) > lcConfig.gSpouseArousalThreshold.GetValue())
		lcUtil.Log(self,"Spouse and Lover are in the same location: time for love")
		Actor[] tmpList = new Actor[2]
		tmpList[0] = akSpouse
		tmpList[1] = akSpouseLover
		lcPlayer.MakeLove(tmpList)
		Return
	EndIf
	
	If (lcLoverHello02Quest.IsRunning())
		lcUtil.Log(self,"Lover Hello 02 Quest is running")
		Return
	ElseIf (lcLoverHello04Quest.IsRunning())
		lcUtil.Log(self,"Lover Hello 04 Quest is running")
		Return
	EndIf
		
	If (loverRank == 2 && lcConfig.IsSpouseScenesEnabled && NextSceneTime03 < GameDaysPassed.GetValue())
		lcUtil.Log(self,"Started Lover Hello 02 Quest...")
		lcLoverHello02Quest.Start()
		NextSceneTime03 = GameDaysPassed.GetValue() + 1.0
		Return
	EndIf
		
	If (loverRank == 4 && lcConfig.IsSpouseScenesEnabled && NextSceneTime04 < GameDaysPassed.GetValue())
		lcUtil.Log(self,"Started Lover Hello 04 Quest...")
		lcLoverHello04Quest.Start()
		NextSceneTime04 = GameDaysPassed.GetValue() + 1.0
		Return
	EndIf
EndFunction


Function SpouseSendCourier(Actor akSpouse)
	If (akSpouse == None)
		Return
	EndIf

	lcUtil.Log(self,"Spouse Note Quest - Anything to do?")
	
	If (!lcSpouseNoteQuest.IsRunning())
		lcUtil.Log(self,"Not running. Start the Quest.")
		lcSpouseNoteQuest.Start()
	EndIf
		
	If (lcSpouseNoteQuest.GetStage() == 0 && lcUtil.GetActorArousal(akSpouse) > lcConfig.gSpouseArousalThreshold.GetValue() && PlayerRef.GetItemCount(lcNoteFromSpouse.GetReference().GetBaseObject()) < 1 && !lcUtil.IsCurrentFollower(akSpouse))
		; send message
		lcUtil.Log(self,"Set Courier going: we are on Stage 0, Spouse is sufficientlay aroused, player does not have the note and Spouse is not a follower")
		WICourierScr.addAliasToContainer(lcNoteFromSpouse)
		LastSpouseNoteTime = GameDaysPassed.GetValue()
		lcSpouseNoteQuest.SetStage(10)
	ElseIf (lcSpouseNoteQuest.GetStage() == 10 && WICourierScr.pCourierContainer.GetItemCount(lcNoteFromSpouse.GetReference().GetBaseObject()) < 1)
		lcUtil.Log(self,"Courier has arrived: we are on Stage 10 and the courier doesn't have the note anymore")
		; courier don't have message
		lcSpouseNoteQuest.SetStage(20)
	ElseIf (lcSpouseNoteQuest.GetStage() == 20 && GameDaysPassed.GetValue() - LastSpouseNoteTime > 7.0)
		lcUtil.Log(self,"Let's try again: we are on Stage 20 and 7 days has passed since the last note")
		; delete note and reset quest
		lcNoteFromSpouse.GetRef().Delete()
		lcSpouseNoteQuest.Stop()
	EndIf
EndFunction