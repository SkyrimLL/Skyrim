Scriptname SLS_TRG_MeetSexBot extends ObjectReference  

SLS_QST_SexBot Property SexBotControlQuest  Auto

Event OnTriggerEnter(ObjectReference akActionRef)
    Actor akActor = akActionRef as Actor
    Actor SexBotActor = SexBotRef as Actor
    Actor FalmerActor = FalmerRef as Actor

    if akActionRef == Game.GetPlayer()
        ; Debug.Notification("You have activated the MeetSexBot trigger.")   

        if (SLS_SexBotMeet.GetValue() == 0)
	     ; SexBotActor.AddToFaction(FalmerFaction)
		Debug.SendAnimationEvent( SexBotActor, "IdleForceDefaultState" )
            SexBotOilLevel.SetValue(50)

            StorageUtil.SetIntValue(SexBotActor, "_SLS_SexBotOilLevel", SexBotOilLevel.GetValue() as Int)
            SLS_SexBotOnOff.SetValue(1) 
            ; SexBotActor.EvaluatePackage()
            Utility.Wait(1.0)
            Debug.Notification("Energy level: " + StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel") )
            Debug.Notification("Lubrication level: " + StorageUtil.GetIntValue(SexBotActor, "_SLS_SexBotOilLevel") )

            StorageUtil.SetIntValue(SexBotActor, "_SLS_SexBotEnergyLevel", 5) 
            SexBotControlQuest.UpdateSexBotState()

            FalmerActor.StopCombatAlarm()
	        FalmerActor.Stopcombat()
            SexBotActor.StopCombatAlarm()
	        SexBotActor.Stopcombat()

            ; If  (SexLab.ValidateActor(FalmerActor) > 0) &&  (SexLab.ValidateActor(SexBotActor) > 0) 
                SexLab.QuickStart(SexBotActor , FalmerActor ,  AnimationTags = "Sex") 
            ; EndIf

            SLS_SexBotMeet.SetValue(1)

        endif

    endif
EndEvent

ObjectReference Property SexBotRef   Auto  
ObjectReference Property FalmerRef  Auto  

GlobalVariable Property SexBotOilLevel  Auto  
GlobalVariable Property SLS_SexBotOnOff  Auto  
GlobalVariable Property SLS_SexBotMeet  Auto  

Quest Property SexBotQuest  Auto  

SexLabFramework Property SexLab  Auto  
Faction Property FalmerFaction  Auto  