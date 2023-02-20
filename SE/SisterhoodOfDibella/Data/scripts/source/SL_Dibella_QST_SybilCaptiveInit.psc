Scriptname SL_Dibella_QST_SybilCaptiveInit extends ObjectReference  

ReferenceAlias Property SybilAlias  Auto  

LeveledItem Property TortureDevice  Auto  
LeveledItem Property BondageItem  Auto  
Armor Property MinerOutfit Auto


Quest Property SybilQuest  Auto  

ObjectReference Property SybilInitTrigger  Auto  

ObjectReference Property CaptorsChestREF  Auto  

ObjectReference Property SybilReleaseTrigger  Auto  

Event OnTriggerEnter(ObjectReference akActionRef)
      ; Only trigger when Sybil quest is active and Fjotra is actually there
      
      if (SybilQuest.GetStageDone(60)) || (SybilQuest.GetStageDone(70))
      	ObjectReference SybilREF= SybilAlias.GetReference()
      	Actor SybilActor= SybilAlias.GetActorRef() 

            if ( (akActionRef == Game.GetPlayer())  && (SybilREF != None)  ) 
           		; Debug.Notification("Sybil is enabled:" + SybilREF)

                   ; SybilActor.removeallitems(CaptorsChestREF  )
                   ; utility.wait(0.5)

                  SybilActor.UnequipAll()
                  if (StorageUtil.GetIntValue(none, "_SD_iSanguine")==1)
                        ; If (Utility.RandomInt(0,100)> 90)
                        ;      SybilActor.SendModEvent("SDEquipDevice",   "Blindfold|blindfold,leather,zap")
                        ; endif
                        ; If (Utility.RandomInt(0,100)> 60)
                          SybilActor.SendModEvent("SDEquipDevice",   "PlugAnal|Breton")
                          SybilActor.SendModEvent("SDEquipDevice",   "PlugVaginal|Breton")
                          SybilActor.SendModEvent("SDEquipDevice",   "Belt|Breton") 
                        ; Endif
                        SybilActor.SendModEvent("SDEquipDevice",   "WristRestraint|Breton")
                        ; SybilActor.SendModEvent("SDEquipDevice",   "Gag|Breton")
                        SybilActor.SendModEvent("SDEquipDevice",   "Collar|Breton")
                  else

                        SybilREF.additem(BondageItem  )
                        SybilActor.equipitem(BondageItem  ,False,False)
                        utility.wait(0.5)

                        SybilREF.additem(TortureDevice  )
                        SybilActor.equipitem(TortureDevice  ,False,False)
                        utility.wait(0.5)
       
                  endif

                  SybilREF.additem(MinerOutfit )
                  SybilActor.equipitem(MinerOutfit ,False,False)
                  utility.wait(0.5)
                  
                  utility.wait(0.5)


      		; Run once
      		SybilReleaseTrigger.enable() 
      		SybilInitTrigger.disable()
      	EndIf
      Endif
EndEvent
