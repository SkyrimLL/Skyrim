;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 1
Scriptname SLH_tif_DremoraOutcast02 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
	Actor kVictim  = Game.GetPlayer() as Actor

	kVictim.resethealthandlimbs()

	If (Utility.RandomInt(0,10)>6)

		int AttackerMagicka = akSpeaker.GetActorValue("magicka") as int
		int VictimMagicka = kVictim.GetActorValue("magicka") as int
		Int IButton = _SLH_warning.Show()

		If IButton == 0 ; Show the thing.

			If (SexLab.ValidateActor( kVictim) > 0) && (SexLab.ValidateActor(akSpeaker) > 0) 
				SexLab.QuickStart(kVictim, akSpeaker , Victim = kVictim, AnimationTags = "Sex")
			EndIf
		Else
			If AttackerMagicka > VictimMagicka
				AttackerMagicka = VictimMagicka
				If (SexLab.ValidateActor( kVictim) > 0) && (SexLab.ValidateActor(akSpeaker) > 0) 
					Debug.MessageBox("Your body feels too warm and aroused for the effects of the healing spell. Your mind is just not strong enough to resist the urges...")
					SexLab.QuickStart(kVictim, akSpeaker , Victim = kVictim, AnimationTags = "Sex")
				EndIf
			EndIf
			akSpeaker.DamageActorValue("magicka",AttackerMagicka) 
			kVictim.DamageActorValue("magicka",AttackerMagicka)
		EndIf

	EndIf
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

SexLabFramework Property SexLab  Auto  

Message Property _SLH_warning  Auto  
