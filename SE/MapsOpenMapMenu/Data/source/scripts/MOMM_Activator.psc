Scriptname MOMM_Activator Extends ObjectReference

; Controller that lifts any registered menu-restriction mods' checks before
; opening the map menu, and restores them once the map menu is closed.
MOMM_MapMenuController Property MapMenuController Auto

Auto STATE Waiting
Event OnActivate(ObjectReference akActivator)
    if akActivator == Game.GetPlayer()
        ; Player is close enough - open the world map menu
        ; int MapKey = Input.GetMappedKey("Quick Map")
        ; Input.TapKey(MapKey)
        MapMenuController.RequestOpenMapMenu()
    endif
EndEvent
EndState