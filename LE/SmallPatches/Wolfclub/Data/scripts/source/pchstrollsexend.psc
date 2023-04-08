Scriptname pchsTrollSexEnd extends Scene

Event TrollEnd(string eventName, string argString, float argNum, form sender)
	sslBaseAnimation anim = SexLab.HookAnimation(argString)

	SexLabEndVar.SetValueInt(1)
	Debug.Notification("SL EndVar set up (troll)")

	UnregisterForModEvent("AnimationEnd_Troll")
EndEvent

SexLabFramework Property SexLab Auto
GlobalVariable Property SexLabEndVar Auto