;BEGIN FRAGMENT CODE - Do not edit anything between this and the end comment
;NEXT FRAGMENT INDEX 2
Scriptname _sdsf_snp_06 Extends Scene Hidden

;BEGIN FRAGMENT Fragment_0
Function Fragment_0()
;BEGIN CODE
Int idx = 0
Int itemCount = 0

Actor female = _SDRAP_female.GetReference() as Actor
Actor male = _SDRAP_male.GetReference() as Actor
; ObjectReference bindings = _SDRAP_bindings.GetReference() as ObjectReference

male.ClearLookAt()

	fctSlavery.UpdateSlaveStatus( female , "_SD_iSlaveryExposure", modValue = 1)


	If ( StorageUtil.GetIntValue(male , "_SD_iDisposition") >= 0 )
		fctSlavery.ModMasterTrust( male , 1 )
	else
		fctSlavery.ModMasterTrust( male , -1 )
	endif 

_SDGVP_snp_busy.SetValue(-1)
; Self.GetowningQuest().Stop()
;END CODE
EndFunction
;END FRAGMENT

;BEGIN FRAGMENT Fragment_1
Function Fragment_1()
;BEGIN CODE
Actor male = _SDRAP_male.GetReference() as Actor

_SDGVP_snp_busy.SetValue(6)

male.SetLookAt(Game.GetPlayer())
; male.DoCombatSpellApply(VampireFeed,  Game.GetPlayer() )
;END CODE
EndFunction
;END FRAGMENT

;END FRAGMENT CODE - Do not edit anything between this and the begin comment

Quest Property _SDQP_enslavement  Auto  
ReferenceAlias Property _SDRAP_bindings  Auto  
ReferenceAlias Property _SDRAP_female  Auto  
ReferenceAlias Property _SDRAP_male  Auto  
FormList Property _SDFLP_punish_items  Auto  

GlobalVariable Property _SDGVP_snp_busy  Auto  
 
SPELL Property VampireFeed  Auto  
_SDQS_fcts_slavery Property fctSlavery  Auto
