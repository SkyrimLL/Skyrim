Scriptname ErdTreeEldergleamControl extends ObjectReference  

SPELL Property HealSpell  Auto  

Event OnTriggerEnter(ObjectReference akActionRef)
	Actor kPlayer = Game.GetPlayer() as Actor
	ObjectReference kPlayerRef = kPlayer as ObjectReference

    if (akActionRef == kPlayerRef) 

		HealSpell.Cast(kPlayerRef, kPlayerRef)	

	EndIf
EndEvent