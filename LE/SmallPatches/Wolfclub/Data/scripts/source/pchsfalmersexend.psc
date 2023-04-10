Scriptname pchsFalmerSexEnd extends Scene  

Event FalmerEnd(string eventName, string argString, float argNum, form sender)
	sslBaseAnimation anim = SexLab.HookAnimation(argString)

	SexLabEndVar.SetValueInt(1)
	Debug.Notification("SL EndVar set up (falmer)")

	UnregisterForModEvent("AnimationEnd_Falmer")
EndEvent

SexLabFramework Property SexLab Auto
GlobalVariable Property SexLabEndVar Auto