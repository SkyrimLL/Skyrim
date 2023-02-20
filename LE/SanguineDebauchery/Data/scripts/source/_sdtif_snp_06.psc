;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _sdtif_snp_06 Extends TopicInfo Hidden

;BEGIN FRAGMENT Fragment_1
Function Fragment_1(ObjectReference akSpeakerRef)
Actor akSpeaker = akSpeakerRef as Actor
;BEGIN CODE
Actor slave = _SDRAP_slave.GetReference() as Actor
Int gold = slave.GetItemCount( _SDMOP_gold )

slave.RemoveItem(_SDMOP_gold, gold, False, akSpeaker)

Int newBuyout =  (_SDGVP_buyout.GetValue() as Int) - gold

if (newBuyout <= 0) 
	newBuyout = 0
EndIf

_SDGVP_buyout.SetValue(newBuyout )

;Self.GetOwningQuest().ModObjectiveGlobal( -5.0 , _SDGVP_demerits, 3, _SDGVP_demerits_join.GetValue() as Float, False, True, _SDGVP_config_verboseMerits.GetValueInt() as Bool )	

Self.GetOwningQuest().ModObjectiveGlobal( gold as Float, _SDGVP_buyoutEarned, 2, _SDGVP_buyout.value ) 

If (newBuyout == 0 )
	Self.GetOwningQuest().SetObjectiveDisplayed( 90 )
EndIf

akSpeaker.ShowGiftMenu( True, _SDFLP_trade_items )
_SDKP_trust_hands.SetValue(0)
_SDQP_enslavement_tasks.Stop()
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

FormList Property _SDFLP_trade_items  Auto  
Quest Property _SDQP_enslavement_tasks  Auto  
MiscObject Property _SDMOP_gold  Auto  
ReferenceAlias Property _SDRAP_slave  Auto  
GlobalVariable Property _SDGVP_buyout  Auto  
GlobalVariable Property _SDGVP_buyoutEarned  Auto  
GlobalVariable Property _SDGVP_demerits  Auto 
GlobalVariable Property _SDGVP_demerits_join  Auto  
GlobalVariable Property _SDGVP_config_verboseMerits  Auto

GlobalVariable Property _SDKP_trust_hands  Auto  
