Scriptname DES_NordicTrackingScript Extends ReferenceAlias

;-- Properties --------------------------------------

Actor Property PlayerRef Auto
Formlist Property DES_NonCultFormlist Auto
GlobalVariable Property DES_Cult Auto
GlobalVariable Property DES_NonCult Auto
Keyword Property LocTypeDraugrCrypt Auto

;-- Variables ---------------------------------------

;-- Functions ---------------------------------------

EVENT OnLocationChange(Location akOldLoc, Location akNewLoc)
	IF akNewLoc.HasKeyword(LocTypeDraugrCrypt )
		DES_NonCult.SetValue(100)
		DES_Cult.SetValue(0)
	ENDIF
	
	IF	DES_NonCultFormlist.HasForm(akNewLoc)
		DES_NonCult.SetValue(0)
		DES_Cult.SetValue(100)
	ENDIF 
ENDEVENT