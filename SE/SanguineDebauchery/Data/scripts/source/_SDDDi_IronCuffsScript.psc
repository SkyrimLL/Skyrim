Scriptname _SDDDi_IronCuffsScript extends zadRestraintScript  


zadArmbinderQuestScript Property abq Auto

; Messages
Message Property zad_ArmBinderPreEquipMsg Auto
Message Property zad_ArmBinderEquipPostMsg Auto
Message Property zad_ArmBinderDisableLocksMsg Auto
Message Property zad_ArmBinderEnableLocksMsg Auto
Message Property _SDDDi_IronCuffsImpossibleStruggleMsg Auto
Message Property _SDDDi_IronCuffsStruggleMsg Auto

 

Bool Property Locked = true Auto

Function OnEquippedPre(actor akActor, bool silent=false)
	if !silent
		if akActor == libs.PlayerRef
			zad_ArmBinderEquipPostMsg.Show()
		Else
			libs.NotifyActor("You slip "+GetMessageName(akActor)+" wrists into the cuffs, which lock with a soft click.", akActor, true)
		EndIf
	EndIf
	Parent.OnEquippedPre(akActor, silent)
EndFunction


Function OnEquippedPost(actor akActor)
	;akActor.UnequipItemSlot(36) ; Unequip ring to avoid clipping
	if akActor == libs.PlayerRef
		libs.UpdateControls()
		abq.IsLoose = False
		abq.StruggleCount = 0
		abq.EnableStruggling()
		SetCustomMessage()
	EndIf
	libs.ApplyBoundAnim(akActor)
EndFunction


Function SetCustomMessage()
	SetDefaultMessages()
EndFunction


Function SetDefaultMessages()
	abq.CustomStruggleMsg = _SDDDi_IronCuffsStruggleMsg
	abq.CustomStruggleImpossibleMsg = _SDDDi_IronCuffsImpossibleStruggleMsg
EndFunction

int Function OnEquippedFilter(actor akActor, bool silent=false)
	if akActor != libs.PlayerRef || silent
		return 0 ; Proceed.
	EndIf
        int interaction = zad_ArmBinderPreEquipMsg.show()
        if interaction == 0 ; Equip Device
    abq.IsLocked = Locked
		return 0 ; Proceed
	ElseIf interaction == 1 ; Manipulate Locks
		if Locked
			zad_ArmBinderDisableLocksMsg.Show()
			Locked = False
		Else
			zad_ArmBinderEnableLocksMsg.Show()
			Locked = True
		EndIf
		return OnEquippedFilter(akActor)
	ElseIf interaction == 2 ; Put it away
		return 2
	EndIf
	libs.Error("Invalid menu option selected for Armbinder Script")
	return 0
EndFunction


Function DeviceMenu(Int msgChoice = 0)
	msgChoice = abq.ShowDeviceMenu(msgChoice)
	DeviceMenuExt(msgChoice)
	SyncInventory()
EndFunction


Function OnRemoveDevice(actor akActor)
	if akActor == libs.PlayerRef
		SetDefaultMessages()
	EndIf
	if !libs.IsAnimating(akActor)
		Debug.SendAnimationEvent(akActor, "IdleForceDefaultState")
	EndIf
EndFunction