Scriptname pchsWolfclubDAYMOYL extends daymoyl_QuestTemplate

bool Function QuestCondition(Location akLocation, Actor akAggressor, Actor akFollower)
	if(akAggressor.IsInFaction(BanditFaction) == true)
		;Debug.Notification("DA Wolfclub: selected")
		return true
	else
		;Debug.Notification("DA Wolfclub: not selected")
		return false
	endif
endFunction


bool Function QuestStart(Location akLocation, Actor akAggressor, Actor akFollower)
		Game.DisablePlayerControls(1, 1, 0, 0, 1, 0, 1)
		Game.SetPlayerAIDriven(true)

		StartedByDA.SetValueInt(1)

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



		;Debug.Notification("DA Wolfclub: running")
		return true
endFunction

Faction Property BanditFaction Auto
Quest Property WolfclubQuest Auto
ObjectReference Property TeleportMarker Auto
Scene Property IntroScene Auto
daymoyl_MonitorVariables Property Variables Auto
daymoyl_MonitorUtility Property Util Auto
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