;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLS_TIF_HelloFriendDrunk Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; Debug.Notification("[SLB] NPC sex count = " + SexLab.PlayerSexCount( akSpeaker ) )

_SLS_NPCSexCount.SetValue(  -1 )

	If  (SexLab.ValidateActor( SexLab.PlayerREF) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 
		Debug.Notification( "[Resists weakly]" )
		Actor akActor = SexLab.PlayerRef
		
		sslThreadModel Thread = SexLab.NewThread()
		Thread.AddActor(akActor) ; // IsVictim = true
		Thread.AddActor(akSpeaker) ; // IsVictim = true

		If (akActor.GetActorBase().getSex() == 1)
			Thread.SetAnimations(SexLab.GetAnimationsByTags(2, "Dirty"))
		Else
			Thread.SetAnimations(SexLab.GetAnimationsByTags(2, "Dirty"))
		EndIf

		Thread.StartThread()
	EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SexLabFramework Property SexLab  Auto  

GlobalVariable Property _SLS_NPCSexCount  Auto  
