;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname randomQuestRewardScript3 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
GetOwningQuest().SetStage(100)
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
if akSpeaker.GetRelationshipRank(Game.GetPlayer()) >= 2
	debug.notification("Now let me thank you properly...")
	actor[] sexActors = new actor[2]
	sexActors[0] = akSpeaker
	sexActors[1] = Game.GetPlayer()
	sslBaseAnimation[] anims
	anims = SexLab.GetAnimationsByTag(2, "Cowgirl, Missionary, doggy", RequireAll=False, tagSuppress="Forced")
	SexLab.StartSex(sexActors, anims)
endIf

;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SexLabFramework Property SexLab auto
