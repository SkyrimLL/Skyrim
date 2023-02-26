;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLD_TIF_MasterNeedEntertain Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
; Debug.Notification("SLD: Sending story event [3]")

Int randomNum = Utility.RandomInt(0, 100)

If (randomNum > 70)
	Debug.Notification("Dance for us...")
	SendModEvent("SDStory", "", 7.0) ; Dance
ElseIf (randomNum > 50)
	Debug.Notification("Show us what you can do...")
	SendModEvent("SDStory", "SoloShow", 0.0) ; Show
ElseIf (randomNum > 30)
	Debug.Notification("Help yourselves boys!...")
	SendModEvent("SDStory", "GangBang", 0.0) ; Gang bang
Else
	Debug.Notification("Get on your knees and lift up that ass of yours...")
	SendModEvent("SDStory", "", 0.0) ; Sex
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment
