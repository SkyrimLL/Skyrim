;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SL_Dibella_TIF_InitiationTask06b_skip Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; t02.SetStage(10)
Self.GetOwningQuest().SetObjectiveDisplayed(25, abDisplayed=False)
Self.GetOwningQuest().SetObjectiveDisplayed(26)
Self.GetOwningQuest().SetStage(22)

Game.GetPlayer().AddItem( DibellaBook, 1)


	If  (SexLab.ValidateActor( SexLab.PlayerREF) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 
		Debug.Notification( "Sister Dynia embraces you..." )
		Actor akActor = SexLab.PlayerRef
		
		sslThreadModel Thread = SexLab.NewThread()
		Thread.AddActor(akSpeaker) ; // IsVictim = true
		Thread.AddActor(akActor) ; // IsVictim = true

		If (akActor.GetActorBase().getSex() == 1)
			Thread.SetAnimations(SexLab.GetAnimationsByTags(2, "Lesbian", "Aggressive"))
		Else
			Thread.SetAnimations(SexLab.GetAnimationsByTags(2, "MF", "Aggressive"))
		EndIf

		Thread.StartThread()
	EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property t02  Auto  

SexLabFramework Property SexLab  Auto  

Book Property DibellaBook  Auto  
