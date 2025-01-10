Scriptname SLS_SexBotAlias extends ReferenceAlias  


ReferenceAlias Property SexBotAlias  Auto  
SexLabFramework Property SexLab  Auto  

GlobalVariable Property SLS_SexBotOnOff  Auto  
GlobalVariable Property SLS_SexBotMemory  Auto  

GlobalVariable Property SLS_SexBotBody  Auto  

Faction Property DwemerFaction  Auto  


Event OnLocationChange(Location akOldLoc, Location akNewLoc)
    Form SexBotForm = StorageUtil.GetFormValue(none, "_SLS_fSexBot")
    Actor SexBotActor = SexBotForm as Actor
    
    int iDaysPassed = Game.QueryStat("Days Passed")
    int iGameDateLastCheck = StorageUtil.GetIntValue(SexBotActor, "_SLS_LastSexDate")
    int iDaysSinceLastCheck = (iDaysPassed - iGameDateLastCheck )  

    ; Cancel temporary friendly status with dwarven automata
    SexBotActor.RemoveFromFaction(DwemerFaction)

    ; debug.notification("[SLS_SexBotAlias] changing location")
    ; Debug.notification("[SLS_SexBotAlias] Days since sex - " + iDaysSinceLastCheck)

    ; Exit conditions
    If (iDaysSinceLastCheck >= 1) && (SLS_SexBotOnOff.GetValue() == 1)
        ; debug.notification("[SLS_SexBotAlias] time to update energy levels")
            StorageUtil.SetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel", StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel") - (iDaysSinceLastCheck * 2))
            SexBotActor.ForceAV("Health", 100 + (StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel") * 2) )
            SexBotActor.ForceAV("Stamina", 10 + (StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel") * 2) )
            SexBotActor.ForceAV("Magicka", 50 + (StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel") * 5) )

            iGameDateLastCheck = iDaysPassed
            StorageUtil.SetIntValue(SexBotActor, "_SLS_LastSexDate", iGameDateLastCheck)

            if (StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel")<=0)
    			Debug.Notification("E.L.L.E needs to be recharged.")
    			; SLS_SexBotOnOff.SetValue(0)

                ; ELLE is depleted - set Confidence to Coward
                SexBotActor.ForceAV("Aggression", 0 )
                SexBotActor.ForceAV("Confidence", 0 )
    			SexBotActor.EvaluatePackage()
    			Utility.Wait(1.0)
            endif
	EndIf

    ; Debug.notification("[SLS_SexBotAlias] _SLS_SexBotEnergyLevel: " + StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel"))

EndEvent

Event OnHit(ObjectReference akAggressor, Form akSource, Projectile akProjectile, bool abPowerAttack, bool abSneakAttack, bool abBashAttack, bool abHitBlocked)
    Form SexBotForm = StorageUtil.GetFormValue(none, "_SLS_fSexBot")
    Actor SexBotActor = SexBotForm as Actor
    Actor kPlayer = Game.GetPlayer()
    Actor akAggressorActor = akAggressor as Actor

    if !SexBotActor.IsInFaction(DwemerFaction)
        If (akAggressor == Game.GetPlayer())

            ;  Debug.Trace("SexBot is hitting")
            If (Utility.RandomInt(0,100)>60) && akAggressorActor.IsInFaction(DwemerFaction)  
                Debug.Notification( "Non Standard Animonculus detected - hostile posture canceled.") 

                SexBotActor.AddToFaction(DwemerFaction)
            EndIf

        ElseIf (akAggressor != None)
            ;  Debug.Trace("We were hit by " + akAggressor)

            If (Utility.RandomInt(0,100)>60) && akAggressorActor.IsInFaction(DwemerFaction) 
                Debug.Notification( "Non Standard Animonculus detected - hostile posture canceled.") 

                SexBotActor.AddToFaction(DwemerFaction)
            EndIf
        EndIf
    Endif

EndEvent
 