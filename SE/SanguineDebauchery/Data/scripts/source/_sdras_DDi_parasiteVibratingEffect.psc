Scriptname _sdras_DDi_parasiteVibratingEffect extends zadBaseLinkedEvent  

Keyword Property _SDKP_OrganicVibrate Auto
Keyword Property _SDKP_ParasiteAn Auto
Keyword Property _SDKP_ParasiteVag Auto

Int Function GetChanceModified(actor akActor, int chanceMod)
	; include both tags for truely active effects
	;float ret = Probability
	;if akActor.HasMagicEffectWithKeyword(libs.zad_EffectLively)
	;	ret *= 1.5
	;EndIf
	;if akActor.HasMagicEffectWithKeyword(libs.zad_EffectVeryLively)
	;	ret *= 2
	;EndIf
	;return ((ret - Probability) as Int)
	return 0
EndFunction

Bool Function Filter(actor akActor, int chanceMod=0)
	;if  akActor == libs.PlayerRef && akActor.GetCombatState() >= 1
	;	libs.Log("Player is in combat, and HardCoreEffects == false. Not starting new vibration effect.")
	;	return false	
	;EndIf
	;if akActor.IsInFaction(libs.Sexlab.ActorLib.AnimatingFaction)
	;	libs.Log("Player is in a sexlab scene. Not starting new vibration effect.")
	;	return false
	;EndIf
	; return (HasKeywords(akActor) && akActor.WornHasKeyword(libs.zad_DeviousPlug) && Parent.Filter(akActor, GetChanceModified(akActor, chanceMod)))
	return false
EndFunction

bool Function HasKeywords(actor akActor)
	; return (akActor.HasMagicEffectWithKeyword( _SDKP_OrganicVibrate  )  )
	return false
EndFunction

Function Execute(actor akActor)
	return
	
	;libs.Log("VibrateEffect("+chance+")")
	;int vibStrength = 0
	;int duration = 0

	;if akActor.HasMagicEffectWithKeyword ( _SDKP_ParasiteAn )
	;	libs.NotifyPlayer("The eggs roll against each other inside your ass.")

	;Elseif akActor.HasMagicEffectWithKeyword ( _SDKP_ParasiteVag  )
	;	libs.NotifyPlayer("The worm twitches and squirms deep inside you.")
;
	;EndIf

	;libs.Moan(akActor)	

	;if akActor.HasMagicEffectWithKeyword ( _SDKP_OrganicVibrate  )
	;	vibStrength = utility.RandomInt(1,5)
	;else
	;	return
	;EndIf

	; libs.VibrateEffect(akActor, vibStrength, duration, teaseOnly=libs.shouldEdgeActor(akActor))
EndFunction