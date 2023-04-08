Scriptname LoversComfortSwingScr extends Quest  

; lovers comfort
LoversComfortUtilScr Property lcUtil Auto
LoversComfortPlayerScr Property lcPlayer Auto

ReferenceAlias Property lcActor01ARef Auto
ReferenceAlias Property lcActor01BRef Auto
ReferenceAlias Property lcMeetPoint01Ref Auto
ReferenceAlias Property lcActor02ARef Auto
ReferenceAlias Property lcActor02BRef Auto
ReferenceAlias Property lcMeetPoint02Ref Auto
ReferenceAlias Property lcActor03ARef Auto
ReferenceAlias Property lcActor03BRef Auto
ReferenceAlias Property lcMeetPoint03Ref Auto

ReferenceAlias Property Alias_Actor01 Auto
ReferenceAlias Property Alias_Slave01 Auto
ReferenceAlias Property MeetSlave01 Auto

Scene Property Scene01 Auto
Scene Property Scene02 Auto
Scene Property Scene03 Auto
Scene Property SlaveScene01 Auto

Faction Property lcSwinger Auto Hidden ; moved to lcUtil

; variable
int couplePointer = 0

Int Function AddCouple(Actor ak1, Actor ak2, ObjectReference Bed = None, Bool isSlave = false)
	Int oldPointer = -1
	If !isSlave 
		lcUtil.Log(self, "trying to add couple " + couplePointer + ": " + ak2.GetBaseObject().GetName() + " comforting " + ak1.GetBaseObject().GetName())
		oldPointer = couplePointer
		If (couplePointer == 0)
			lcActor01ARef.ForceRefTo(ak1)
			lcActor01BRef.ForceRefTo(ak2)
			lcMeetPoint01Ref.ForceRefTo(Bed)
			couplePointer = 1
		ElseIf (couplePointer == 1)
			lcActor02ARef.ForceRefTo(ak1)
			lcActor02BRef.ForceRefTo(ak2)
			lcMeetPoint02Ref.ForceRefTo(Bed)
			couplePointer = 2
		ElseIf (couplePointer == 2)
			lcActor03ARef.ForceRefTo(ak1)
			lcActor03BRef.ForceRefTo(ak2)
			lcMeetPoint03Ref.ForceRefTo(Bed)
			couplePointer = 0
		EndIf
		lcUtil.updateSwinging(ak1,ak2)
	Else 
		lcUtil.Log(self, "trying to add slave: " + ak2.GetBaseObject().GetName() + " comforting " + ak1.GetBaseObject().GetName())
		Alias_Actor01.ForceRefTo(ak1)
		Alias_Slave01.ForceRefTo(ak2)
		MeetSlave01.ForceRefTo(Bed)
		oldPointer = 3
	EndIf
	Return oldPointer
EndFunction

Scene Function getScene(Int sceneIndex)
	Scene sexScene = None
	If sceneIndex == 0
		sexScene = Scene01
	ElseIf sceneIndex == 1 
		sexScene = Scene02
	ElseIf sceneIndex == 2
		sexScene = Scene03
	ElseIf sceneIndex == 3
		sexScene = SlaveScene01
	EndIf

	Return sexScene
EndFunction

Function sceneStart(Int sceneIndex)
	lcUtil.Log(self, "Starting scene " + sceneIndex)
	Scene sexscene = getScene(sceneIndex)

	If sexScene != None
		lcUtil.Log(self, "Scene " + sexScene + " is starting")
		sexScene.Start()
		If sexScene.IsPlaying()
			lcUtil.Log(self, "Scene " + sexScene + " is playing")
		EndIf
	Else 
		lcUtil.Log(self, "sexScene was not set")
	EndIf 
EndFunction

Function sceneStop(Int sceneIndex)
	lcUtil.Log(self, "Stopping scene " + sceneIndex)
	Scene sexscene = getScene(sceneIndex)

	If sexScene != None
		If sexScene.IsPlaying()
			lcUtil.Log(self, "Scene " + sexScene + " is being stopped")
			sexScene.Stop()
		EndIf
	Else 
		lcUtil.Log(self, "sexScene was not set")
	EndIf 
EndFunction

Function StartSwingWithCouple(int i)
	sceneStop(i)

	Actor Ak1 = lcActor01ARef.GetActorReference()
	Actor Ak2 = lcActor01BRef.GetActorReference()
	
	If (i == 1)
		Ak1 = lcActor02ARef.GetActorReference()
		Ak2 = lcActor02BRef.GetActorReference()
	ElseIf (i == 2)
		Ak1 = lcActor03ARef.GetActorReference()
		Ak2 = lcActor03BRef.GetActorReference()
	EndIf

	lcUtil.Log(self,"Start Swing with Couple, scene " + i)
	
	Actor[] couple1 = new Actor[2]
	Actor[] couple2 = new Actor[2]
	
	couple1[0] = lcPlayer.PlayerRef
	If (Ak1.GetLeveledActorBase().GetSex() == lcPlayer.PlayerRef.GetLeveledActorBase().GetSex())
		couple1[1] = Ak2
		couple2[0] = Ak1
	Else
		couple1[1] = Ak1
		couple2[0] = Ak2
	EndIf
	
	Actor akSpouse = lcPlayer.GetSpouse()
	
	Actor akFollower = None
	if (lcPlayer.lcCurrentFollowers.length > 0)
		akFollower = lcPlayer.lcCurrentFollowers[0]
	EndIf
	
	If (akSpouse != None)
		If (akSpouse.GetParentCell() == lcPlayer.PlayerRef.GetParentCell())
			couple2[1] = akSpouse
		EndIf
	EndIf
	
	If (akFollower != None && couple2[1] == None)
		If (akFollower.GetParentCell() == lcPlayer.PlayerRef.GetParentCell())
			couple2[1] = akFollower
		EndIf
	EndIf

	lcUtil.Log(self,"Couple 1: " + couple1[0].GetDisplayName() + " and " + couple1[1].GetDisplayName())
	lcUtil.Log(self,"Couple 2: " + couple2[0].GetDisplayName() + " and " + couple2[1].GetDisplayName())
	
	If (couple1[1] != None && couple2[0] != None && couple2[1] != None)
		lcUtil.Log(self, "All participants ready")
		ObjectReference bed1 = lcPlayer.FindNearestBed(couple1)
		lcPlayer.MakeLove(couple1, center = bed1)
		Utility.Wait(1.0)
		ObjectReference bed2 = lcPlayer.FindNearestBed(couple2, ignoreBed = bed1)
		lcPlayer.MakeLove(couple2, center = bed2)
	Else
		lcUtil.Log(self, "Swing failed")
	EndIf
EndFunction