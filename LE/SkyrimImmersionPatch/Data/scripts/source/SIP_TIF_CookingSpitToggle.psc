;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SIP_TIF_CookingSpitToggle Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Int IButton =  _SIP_MSG_CookingSpitMenu.Show()

If IButton == 0  ; Show the thing.
	_SIP_CookingSpitToggleMarker.Disable()
Else
	_SIP_CookingSpitToggleMarker.Enable()
EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

ObjectReference Property _SIP_CookingSpitToggleMarker  Auto  

Message Property _SIP_MSG_CookingSpitMenu  Auto  
