Scriptname pchsDarrenEscapeSleepBedroll extends ObjectReference  

Event OnActivate(ObjectReference akActionRef)
	If (akActionRef == PlayerREF && WolfclubStage.GetValueInt() == 70)
		;WolfclubQuest.SetStage(80)
		WolfclubStage.SetValueInt(80)

		Darren.MoveTo(WaitMarker)
		Guard.Disable()
		EscapeTrigger.Disable()
		Horse.Enable()
		Carriage.Enable()

		FadeToBlackImod.Apply()	
		Utility.Wait(2.0)
		FadeToBlackHoldImod.Apply()
		Utility.Wait(3.0)
		FadeToBlackHoldImod.Remove()
		FadeToBlackBackImod.Apply()
		
		Debug.MessageBox("Now is your chance. Escape!")
	EndIf
EndEvent

ObjectReference Property Darren Auto
ObjectReference Property Guard Auto
ObjectReference Property WaitMarker Auto 
Actor Property PlayerREF Auto
ObjectReference Property EscapeTrigger Auto
ImageSpaceModifier Property FadeToBlackImod Auto
ImageSpaceModifier Property FadeToBlackBackImod Auto
ImageSpaceModifier Property FadeToBlackHoldImod Auto
Quest Property WolfclubQuest Auto
ObjectReference Property Horse Auto
ObjectReference Property Carriage Auto
GlobalVariable Property WolfclubStage Auto