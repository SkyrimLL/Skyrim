Scriptname LoversComfortPlayerAliasScr extends ReferenceAlias

LoversComfortUtilScr Property lcUtil Auto
LoversComfortPlayerScr Property lcPlayerQuest Auto

Event OnPlayerLoadGame()
	lcUtil.Maintenance()
EndEvent


Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	lcPlayerQuest.RegisterForSingleUpdate(5.0)
EndEvent


Event OnCellLoad()
	lcPlayerQuest.RegisterForSingleUpdate(5.0)
EndEvent