;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname Alicia_TIF_Follow Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
(pDialogueFollower as DialogueFollowerScript).SetFollower(Alias_Alicia.GetReference())
(pDialogueFollower as DialogueFollowerScript).FollowerFollow()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property pDialogueFollower  Auto  

Actor Property Alicia  Auto  

ReferenceAlias Property Alias_Alicia  Auto  
