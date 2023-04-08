ScriptName mzinBathePlayerAlias Extends ReferenceAlias

mzinBatheQuest Property BatheQuest Auto
Spell Property GetDirtyOverTimeReactivatorCloakSpell Auto

Actor Property PlayerRef Auto

Bool Reapplying

Event OnPlayerLoadGame()
	BatheQuest.UpdateDangerousWater()
	BatheQuest.RegForEvents()
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)
	If Reapplying == False
		Reapplying = True
		PlayerRef.RemoveSpell(GetDirtyOverTimeReactivatorCloakSpell)
		Utility.Wait(1)
		PlayerRef.AddSpell(GetDirtyOverTimeReactivatorCloakSpell, False)
		Reapplying = False
	EndIf
EndEvent
