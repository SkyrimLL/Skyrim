Scriptname pchsPlayerEquipmentScript extends ReferenceAlias  


	Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
		If ((WolfclubStage.GetValueInt() >= 10) && (WolfclubStage.GetValueInt() <= 510) && (akDestContainer == Game.GetPlayer()))
			
			If ((akBaseItem == Cuffs) && (CuffsFlag.GetValueInt() == 1))
				Game.GetPlayer().EquipItem(Cuffs)
				Debug.Notification("You have to wear your cuffs!")
			
			ElseIf ((akBaseItem == Collar) && (CollarFlag.GetValueInt() == 1))
				Game.GetPlayer().EquipItem(Collar)
				Debug.Notification("You have to wear your collar!")
			
			ElseIf ((akBaseItem == Gag) && (GagFlag.GetValueInt() == 1))
				Game.GetPlayer().EquipItem(Gag)
				Debug.Notification("You have to wear your gag!")
			
			ElseIf ((akBaseItem == Hood) && (HoodFlag.GetValueInt() == 1))
				Game.GetPlayer().EquipItem(Hood)
				Debug.Notification("You have to wear your hood!")

			ElseIf ((akBaseItem == Yoke) && (YokeFlag.GetValueInt() == 1))
				Game.GetPlayer().EquipItem(Yoke)
				Debug.Notification("You have to wear your yoke!")

			EndIf
			
		EndIf
	EndEvent


Quest Property WolfclubQuest Auto
Armor Property Cuffs Auto
Armor Property Collar Auto
Armor Property Gag Auto
Armor Property Hood Auto
Armor Property Yoke Auto
GlobalVariable Property CuffsFlag Auto
GlobalVariable Property CollarFlag Auto
GlobalVariable Property GagFlag Auto
GlobalVariable Property HoodFlag Auto
GlobalVariable Property YokeFlag Auto
GlobalVariable Property WolfclubStage Auto