Scriptname DES_FalmerTrackingScript Extends ReferenceAlias

;-- Properties --------------------------------------

Actor Property PlayerRef Auto
Formlist Property DES_ValeFormlist Auto
GlobalVariable Property DES_Vale Auto
GlobalVariable Property DES_NonVale Auto
Keyword Property LocTypeFalmerHive Auto

;-- Variables ---------------------------------------

;-- Functions ---------------------------------------

EVENT OnLocationChange(Location akOldLoc, Location akNewLoc)
	IF akNewLoc.HasKeyword(LocTypeFalmerHive)
		DES_NonVale.SetValue(0)
		DES_Vale.SetValue(100)
	ENDIF
	
	IF	DES_ValeFormlist.HasForm(akNewLoc)
		DES_NonVale.SetValue(100)
		DES_Vale.SetValue(0)
	ENDIF 
ENDEVENT