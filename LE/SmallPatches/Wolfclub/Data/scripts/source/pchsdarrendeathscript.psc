Scriptname pchsDarrenDeathScript extends ObjectReference  

Event OnActivate(ObjectReference akActionRef)
	If WolfclubQuest.GetStage() == 520
		Debug.MessageBox("While searching Darren's dead body, you've found a key. To your delight, it seems to unlock all you shackles.")
		Game.GetPlayer().Unequipall()
	EndIF
EndEvent

Quest Property WolfclubQuest Auto