;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLS_TIF_SexBotSex1 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor kPlayer = Game.GetPlayer()

	If  (SexLab.ValidateActor( kPlayer ) > 0) &&  (SexLab.ValidateActor(akSpeaker) > 0) 

	If (Utility.RandomInt(0,100)<30)
		SexLab.QuickStart(kPlayer , akSpeaker,  AnimationTags = "Sex")
	else
		SexLab.QuickStart(akSpeaker , kPlayer ,  AnimationTags = "Sex")
	Endif

	else
		Debug.Notification("Ask again when both be found less occupied!")
	endIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SexLabFramework Property SexLab  Auto  

 
