Scriptname SLP_TRG_WhiterunSantuarySource extends ObjectReference  

Event OnContainerChanged(ObjectReference akNewContainer, ObjectReference akOldContainer)
	Actor akPlayer = Game.GetPlayer()
	Form RightHandWeapon 
	Form LeftHandWeapon  

	if (akNewContainer == akPlayer) && (QueenOfChaurusQuest.GetStageDone(255)==0) 
		RightHandWeapon = akPlayer.GetEquippedWeapon(0) 
		LeftHandWeapon = akPlayer.GetEquippedWeapon(1)

		if ((RightHandWeapon as Weapon) == Nettlebane) || ((LeftHandWeapon as Weapon) == Nettlebane)
		    Debug.Messagebox("Using Nettlebane, you manage to dislodge the rusted saw from the ancient roots. The roots above you emit a crystaline sound, almost of relief. The poisonous gas is evacuated quickly as the ground starts shaking.")

		 	; Talk to Danica again to move to stage 260
		    DanicaPurespring.SendModEvent("SLPCureFaceHuggerGag")
		    ; akPlayer.SendModEvent("SLPCureFaceHuggerGag")

		 	CorruptionOffSpell.cast(WhiterunSancturaryCorruptionActivator, akNewContainer)
		 	WhiterunSancturaryCorruptionMarker.disable()
 
		 	fctParasites.infectParasiteByString(akPlayer, "EstrusChaurusEgg")


		 	QueenOfChaurusQuest.SetStage(255) 
		 	; checkpoint flag to mark the end of corruption of the temple
		 	; Talk to Danica again to move to stage 260
		 	; QueenOfChaurusQuest.SetStage(260)
		endif

	endIf
endEvent

WEAPON Property Nettlebane  Auto  
Quest Property QueenOfChaurusQuest Auto
ObjectReference Property WhiterunSancturaryCorruptionMarker Auto
ObjectReference Property WhiterunSancturaryCorruptionActivator Auto
Actor Property DanicaPurespring Auto
SPELL Property CorruptionOffSpell Auto
SLP_fcts_parasites Property fctParasites  Auto



 

 

