Scriptname APMessengerUtil extends Quest  

APDialoguePlayer Property EventScript Auto
Quest Property MQ101  Auto 

ObjectReference Property helgenInnMarker Auto
ImageSpaceModifier Property FadeToBlackHoldImod Auto
ImageSpaceModifier Property FadeToBlackBackImod Auto

ImageSpaceModifier Property WarpTime Auto
Message Property Split Auto

; =========================================================
; ============================== TIME SKIPS
; =========================================================

Function SkipKeepEntrance(bool skipImod = false)
    int choice = split.show()
    If choice == 0
        return
	ElseIf !skipImod
		Utility.Wait(1.1)
		WarpTime.Apply()
		Utility.Wait(2.5)
    endif
    If choice == 1
        MQ101.SetStage(6)
    elseif choice == 2
        MQ101.SetStage(7)
    endif
EndFunction

; =========================================================
; ============================== ENTER GAME
; =========================================================
Function enterGame()
	Actor Player = Game.GetPlayer()
	Cell startcell = Player.GetParentCell()
	; Start Intro Quest
	Player.SetDontMove(true)
	FadeToBlackHoldImod.Apply()
	If(!EventScript.StartingQuest) ; default Quests
		Game.GetPlayer().MoveTo(helgenInnMarker)
	ElseIf(!EventScript.StartingQuest.Start())
		Debug.MessageBox("Failed to start Intro Quest " + EventScript.StartingQuest.GetFormID() + "\nMoving you to Helgen Inn..")
		Game.GetPlayer().MoveTo(helgenInnMarker)
	EndIf
	; Wait for the Player to leave the Starting Cell, then finish it up
	int timeout = 25
	While(Player.GetParentCell() == startcell && timeout > 0)
		timeout -= 1
		Utility.Wait(0.2)
	EndWhile
	If(timeout == 0)
		Debug.MessageBox("You seem to be stuck. I'll move you into the Helgen Inn.\nUsually, your selected start quest is expected to move you out of this cell. If this happens every time you use this Starting Option, you should get in touch with the Author that implemented it.\nQuest ID = " + EventScript.StartingQuest.GetFormID())
		Game.GetPlayer().MoveTo(helgenInnMarker)
	EndIf
	Player.SetDontMove(false)
	FadeToBlackHoldImod.PopTo(FadeToBlackBackImod)
	; ((Self as Quest) as APDialogueHelgen).SetPositions()
	Game.RequestSave()
EndFunction
