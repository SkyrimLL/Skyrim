Scriptname SLSDDi_Alias_PetFree extends ReferenceAlias  
; Pet Flame to Human

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, \
  	bool abBashAttack, bool abHitBlocked)
	Actor PetFreeActor= _SLSD_PetFreeREF.GetReference() as Actor 

	float petFreeHealth = PetFreeActor.GetAVPercentage("Health")
	; Debug.Notification("[SL Stories] Flame was hit. Pct Health:  " + petFreeHealth)

	if (_SLSD_PetPlugFree.GetValue() == 0) &&  (petFreeHealth < 0.2) 
		; Debug.Notification("[SL Stories] Starting Bind scene")
		PetSlaveBindScene.Start()
	endIf
EndEvent

ReferenceAlias Property _SLSD_PetFreeREF Auto

Scene Property PetSlaveFreeScene  Auto  
GlobalVariable Property _SLSD_PetPlugFree  Auto  
Scene Property PetSlaveBindScene  Auto  
