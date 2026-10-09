Scriptname _SD_Bootstrap extends ReferenceAlias

Formlist Property _SDFL_quest_bootlist Auto

Event OnInit()
	RegisterForSingleUpdate(5.0)
EndEvent

Event OnUpdate()
	Debug.Notification("Bootstrap...")
	Int iIndex = _SDFL_quest_bootlist.GetSize()
	While iIndex
		iIndex -=1
		(_SDFL_quest_bootlist.GetAt(iIndex) as Quest).Start()
	EndWhile
	Debug.Notification("Boot Complete...")
EndEvent