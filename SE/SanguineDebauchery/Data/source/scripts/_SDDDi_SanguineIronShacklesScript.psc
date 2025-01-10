Scriptname _SDDDi_SanguineIronShacklesScript extends zadRestraintScript  

Function OnEquippedPre(actor akActor, bool silent=false)
	if !silent
		libs.NotifyActor("You slip the restraints around "+GetMessageName(akActor)+" legs, and they lock in place with a soft click.", akActor, true)
	EndIf
	Parent.OnEquippedPre(akActor, silent)
EndFunction

Function OnEquippedPost(actor akActor)
	libs.Log("RestraintScript OnEquippedPost Legs")
EndFunction

Function OnUnEquippedPost(actor akActor)
	Utility.Wait(5)
	akActor.RemoveItem(deviceInventory, 1, true)
EndFunction
