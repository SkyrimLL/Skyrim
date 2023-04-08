Scriptname pchsEscapeAttemptTrigger extends ObjectReference  

Event OnTriggerEnter(ObjectReference akActionRef)
	If (akActionRef == PlayerREF && WolfclubStage.GetValueInt() >= 10 && WolfclubStage.GetValueInt() < 500)

		LeashScene.Start()
		UntreatedEscapeAttemptCount.SetValueInt(1)

	EndIf
EndEvent

GlobalVariable Property WolfclubStage Auto 
GlobalVariable Property UntreatedEscapeAttemptCount Auto
Scene Property LeashScene Auto
Actor Property PlayerREF Auto