Scriptname ErdTreeLightControl extends ObjectReference  

ObjectReference Property ErdTreeLightSickly  Auto  

ObjectReference Property ErdTreeLightHealthy  Auto  

ObjectReference Property ErdTreeLightSapling  Auto  

ObjectReference Property ErdTreeRef  Auto  

Quest Property T03  Auto  

SPELL Property HealSelf10  Auto  

SPELL Property HealSelf50  Auto  

SPELL Property HealSelf100  Auto  

Event OnTriggerEnter(ObjectReference akActionRef)
	Actor kPlayer = Game.GetPlayer() as Actor
	ObjectReference kPlayerRef = kPlayer as ObjectReference

     if (akActionRef == kPlayerRef) 
     	Int iRandomNum = utility.RandomInt(0,100)

     	if (!ErdTreeRef.IsEnabled())
     		; Add old tree back if sapling is alredy in place. The old tree shouldn't just vanish like that.
     		ErdTreeRef.Enable()
     	endif
 
 		if (T03.GetStageDone(100)==1) && (ErdTreeLightSickly.IsEnabled())
 			; Tree sap collected
 			ErdTreeLightSickly.Disable()
 			ErdTreeLightHealthy.Enable()
 			
 		elseif (T03.GetStageDone(105)==1) && (ErdTreeLightSickly.IsEnabled())
 			; Tree sapling returned
 			ErdTreeLightSickly.Disable()
 			ErdTreeLightHealthy.Enable()
 			; ErdTreeLightSapling.Enable()
 		Endif

		if (ErdTreeLightSickly.IsEnabled()) && (iRandomNum <= 20)
			HealSelf10.Cast(kPlayerRef, kPlayerRef)	

		elseif (ErdTreeLightHealthy.IsEnabled()) && (iRandomNum <= 80)
			HealSelf100.Cast(kPlayerRef, kPlayerRef)	

		elseif (ErdTreeLightSapling.IsEnabled()) && (iRandomNum <= 50)
			HealSelf50.Cast(kPlayerRef, kPlayerRef)	

		endif

	EndIf
EndEvent

