Scriptname pchsExternalEnslavementTrigger extends ReferenceAlias  

Event OnInit()
	Debug.Notification("Wolfclub OnInit initialized")
	RegisterEvents()
	RegisterForSingleUpdate(3)
endEvent

event OnPlayerLoadGame()
	RegisterEvents()
	RegisterForSingleUpdate(1)
	Debug.Notification("Wolfclub OnLoad initialized")
endevent

function RegisterEvents()
	RegisterForModEvent("WolfClubEnslavePlayer","WolfclubMakePlayerSlave")
endfunction

bool function pchsWolfClubMakePlayerSlave() global
	int handle = ModEvent.Create("WolfClubEnslavePlayer")
	if handle
		return ModEvent.Send(handle)
	endif
	return false
endfunction

Event WolfclubMakePlayerSlave()
	WolfClubEnslave()
EndEvent

function WolfClubEnslave()
		Game.DisablePlayerControls(1, 1, 0, 0, 1, 0, 1)
		Game.SetPlayerAIDriven(true)

		StartedByDA.SetValueInt(1)
		StartedByModEvent.SetValueInt(1)

		Game.GetPlayer().RemoveAllItems(chest, 1)
		Game.GetPlayer().EquipItem(Collar, true, false)
		Game.GetPlayer().EquipItem(Cuffs, true, false)
		Game.GetPlayer().EquipItem(Gag, true, false)
		Chest.Lock(true, true)
		Game.GetPlayer().AddToFaction(BanditAllyFaction)

		Game.GetPlayer().MoveTo(TeleportMarker)
		TeleportMarker.Activate(Game.GetPlayer())

		WolfclubStage.SetValueInt(20)

		Game.GetPlayer().PlayIdle(BoundIdle)

		IntroScene.Start()
		WhipScene.Start()
		FuckScene.Start()
endfunction

Quest Property WolfclubQuest Auto
Faction Property BanditFaction Auto
ObjectReference Property TeleportMarker Auto
Scene Property IntroScene Auto
Armor Property Collar  Auto  
Armor Property Cuffs  Auto  
ObjectReference Property Chest  Auto  
Faction Property BanditAllyFaction  Auto  
Armor Property Gag  Auto  
Idle Property BoundIdle  Auto  
Scene Property WhipScene  Auto  
Scene Property FuckScene  Auto
GlobalVariable Property StartedByDA Auto
GlobalVariable Property WolfclubStage Auto
GlobalVariable Property StartedByModEvent Auto