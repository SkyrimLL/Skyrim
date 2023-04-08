Scriptname pchsBroomPunishmentEnd extends Scene

Event BroomPunishmentEnd(string eventName, string argString, float argNum, form sender)
	sslBaseAnimation anim = SexLab.HookAnimation(argString)

	SexLabEndVar.SetValueInt(1)
	Debug.Notification("SL EndVar set up (broom)")

	UnregisterForModEvent("AnimationEnd_PostBroomPunishment")
EndEvent

SexLabFramework Property SexLab Auto
GlobalVariable Property SexLabEndVar Auto