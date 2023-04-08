Scriptname pchsEscapePunishmentTrigger extends ObjectReference  

Event OnTriggerEnter(ObjectReference akActionRef)
	If (akActionRef == PlayerREF)
		Debug.Notification("Now you will be punished for trying to escape!")
		TriggerMarker.Disable()
		ThisScene.Stop()
		Game.DisablePlayerControls(1, 1, 0, 1, 1, 1, 1)
		Game.SetPlayerAIDriven()
		NextScene.Start()
	EndIf
EndEvent

ObjectReference Property TriggerMarker Auto
Scene Property NextScene Auto
Actor Property PlayerREF Auto
Scene Property ThisScene Auto