Scriptname RAB_InvLimits_MCMScript_v2 extends SKI_ConfigBase

	; Limits how much the player can carry, using numerous "limiter slots"
	; Anything beyond the limit is dropped shortly after being picked up.
	; Support backpacks and bandoliers to increase carry limits
	; ================== GLOBAL VARIABLES ==================

		RAB_InvLimits_PlayerScript_v2 Property RABInv_PlayerScriptReference Auto
		int MiscOption_LargeItemThreshold
		int MiscOption_MediumItemThreshold
		int MiscOption_ToggleDebug
		int MiscOption_ToggleMysteryObjects
		int MiscOption_ToggleWeightlessObjects
		
		; GLZ
		GlobalVariable Property CheckHotKey Auto
		Message Property ContainerUsageMsg  Auto
		GlobalVariable Property RABSoundEnabled Auto
		GlobalVariable Property RABWarningsEnabled Auto
		int GLZOption_ToggleDropSound
		int GLZOption_ToggleWarnings
		

	; ================== DRAW SLOT OPTIONS ==================
		; 0: Misc items				1: Weapon sheaths
		; 2: Ammo quiver			3: Valuables purse
		; 4: fragile bottles		5: Hidden slots
		; 6: Custom slot 1			7: Custom slot 2
		; 8: Custom slot 3			9: Custom slot 4

		int[] SlotOption_BaseCapacity
		int[] SlotOption_LargeBagBonus
		int[] SlotOption_SmallBagBonus
		Function RABInv_DrawSlotOptions(int Slotnumber)
			SlotOption_BaseCapacity[Slotnumber]=AddSliderOption("Start capacity",RABInv_PlayerScriptReference.RABInv_Slot_BaseCapacity[Slotnumber],"{1}")
			SlotOption_LargeBagBonus[Slotnumber]=AddSliderOption("Backpack bonus",RABInv_PlayerScriptReference.RABInv_Slot_LargeBagBonus[Slotnumber],"{1}")
			SlotOption_SmallBagBonus[Slotnumber]=AddSliderOption("Other pack bonus",RABInv_PlayerScriptReference.RABInv_Slot_SmallBagBonus[Slotnumber],"{1}")
			AddTextOption("Currently capacity: ",(RABInv_PlayerScriptReference.RABInv_Slot_BaseCapacity[Slotnumber]+RABInv_PlayerScriptReference.RABInv_Slot_CurrentBonus[Slotnumber]),OPTION_FLAG_DISABLED)
			AddTextOption("Currently used: ",RABInv_PlayerScriptReference.RABInv_Slot_CurrentUse[Slotnumber],OPTION_FLAG_DISABLED)
			AddTextOption("Currently available: ",(RABInv_PlayerScriptReference.RABInv_Slot_BaseCapacity[Slotnumber]+RABInv_PlayerScriptReference.RABInv_Slot_CurrentBonus[Slotnumber]-RABInv_PlayerScriptReference.RABInv_Slot_CurrentUse[Slotnumber]),OPTION_FLAG_DISABLED)
		EndFunction

	; ================== DRAW ITEM OPTIONS ==================

		int[] ItemOption_Size
		int[] ItemOption_Slot
		Function RABInv_DrawItemOption(string FriendlyName,int ItemNumber,int WhichOption)
			if(WhichOption==1)
				ItemOption_Size[ItemNumber]=AddSliderOption(FriendlyName+" - size",RABInv_PlayerScriptReference.RABInv_ItemSize[ItemNumber],"{1}")
			else
				ItemOption_Slot[ItemNumber]=AddSliderOption(FriendlyName+" - slot",RABInv_PlayerScriptReference.RABInv_ItemSlot[ItemNumber],"{0}")
			EndIf
		EndFunction

	; ================== ON STARTUP INIT GLOBALS ==================

		Event OnConfigRegister()
			InitOIDs()
		endEvent
		Function InitOIDs()
			SlotOption_BaseCapacity = New Int[10]
			SlotOption_LargeBagBonus = New Int[10]
			SlotOption_SmallBagBonus = New Int[10]
			ItemOption_Size = New Int[42]
			ItemOption_Slot = New Int[42]
		EndFunction

	; ================== RECALC ALL ON MENU CLOSE ==================

		Event OnConfigClose()
			RABInv_PlayerScriptReference.RABInv_RecalcAll()
		endEvent

	; ================== DRAW THE MCM PAGES ==================

		event OnPageReset(string PageToDraw)
			SetCursorFillMode(TOP_TO_BOTTOM)
			; Draw the pages
			If PageToDraw=="Limiter Slots"
				AddHeaderOption("#0 - Misc Items")
				RABInv_DrawSlotOptions(0)
				AddEmptyOption()
				AddHeaderOption("#2 - Ammo quiver")
				RABInv_DrawSlotOptions(2)
				AddEmptyOption()
				AddHeaderOption("#4 - Fragile bottles")
				RABInv_DrawSlotOptions(4)
				AddEmptyOption()
				AddHeaderOption("#6 - Books")
				RABInv_DrawSlotOptions(6)
				AddEmptyOption()
				AddHeaderOption("#8 - Clothing")
				RABInv_DrawSlotOptions(8)
				AddEmptyOption()
				SetCursorPosition(1)
				AddHeaderOption("#1 - Weapon sheaths")
				RABInv_DrawSlotOptions(1)
				AddEmptyOption()
				AddHeaderOption("#3 - Valuables purse")
				RABInv_DrawSlotOptions(3)
				AddEmptyOption()
				AddHeaderOption("#5 - Hidden pockets")
				RABInv_DrawSlotOptions(5)
				AddEmptyOption()
				AddHeaderOption("#7 - Ingredients")
				RABInv_DrawSlotOptions(7)
				AddEmptyOption()
				AddHeaderOption("#9 - Shield")
				RABInv_DrawSlotOptions(9)
			ElseIf PageToDraw=="Item defs"
				int OptionCur=1
				While OptionCur<3
					AddHeaderOption("Stowed weapons")
					RABInv_DrawItemOption("Arrows",0,OptionCur)
					RABInv_DrawItemOption("Bolts",2,OptionCur)
					RABInv_DrawItemOption("1H weapons",4,OptionCur)
					RABInv_DrawItemOption("2H weapons",6,OptionCur)
					RABInv_DrawItemOption("Daggers",8,OptionCur)
					RABInv_DrawItemOption("Crossbows",10,OptionCur)
					RABInv_DrawItemOption("Bows",12,OptionCur)
					AddHeaderOption("Equipped weapons")
					RABInv_DrawItemOption("Arrows",1,OptionCur)
					RABInv_DrawItemOption("Bolts",3,OptionCur)
					RABInv_DrawItemOption("1H weapons",5,OptionCur)
					RABInv_DrawItemOption("2H weapons",7,OptionCur)
					RABInv_DrawItemOption("Daggerss",9,OptionCur)
					RABInv_DrawItemOption("Crossbows",11,OptionCur)
					RABInv_DrawItemOption("Bows",13,OptionCur)
					AddHeaderOption("Stowed wearables")
					RABInv_DrawItemOption("Shields",14,OptionCur)
					RABInv_DrawItemOption("Cuirasses",16,OptionCur)
					RABInv_DrawItemOption("Boots",18,OptionCur)
					RABInv_DrawItemOption("Helmets",20,OptionCur)
					RABInv_DrawItemOption("Gauntlets",22,OptionCur)
					RABInv_DrawItemOption("Clothing",24,OptionCur)
					RABInv_DrawItemOption("Jewelry",26,OptionCur)
					AddHeaderOption("Equipped wearables")
					RABInv_DrawItemOption("Shields",15,OptionCur)
					RABInv_DrawItemOption("Cuirasses",17,OptionCur)
					RABInv_DrawItemOption("Boots",19,OptionCur)
					RABInv_DrawItemOption("Helmets",21,OptionCur)
					RABInv_DrawItemOption("Gauntlets",23,OptionCur)
					RABInv_DrawItemOption("Clothing",25,OptionCur)
					RABInv_DrawItemOption("Jewelry",27,OptionCur)
					AddHeaderOption("Misc Items")
					RABInv_DrawItemOption("Books/Scrolls",28,OptionCur)
					RABInv_DrawItemOption("Food",29,OptionCur)
					RABInv_DrawItemOption("Potions",30,OptionCur)
					RABInv_DrawItemOption("Drinks",31,OptionCur)
					RABInv_DrawItemOption("Ingredients",32,OptionCur)
					RABInv_DrawItemOption("Gems",33,OptionCur)
					RABInv_DrawItemOption("Soul gems",34,OptionCur)
					RABInv_DrawItemOption("Lockpicks",35,OptionCur)
					RABInv_DrawItemOption("Misc large items",36,OptionCur)
					RABInv_DrawItemOption("Misc medium items",37,OptionCur)
					RABInv_DrawItemOption("Misc small items",38,OptionCur)
					RABInv_DrawItemOption("Ingots/Ore",40,OptionCur)
					RABInv_DrawItemOption("Hides/Pelts",41,OptionCur)
					RABInv_DrawItemOption("Gold",39,OptionCur)
					SetCursorPosition(1)
					OptionCur+=1
				EndWhile
			ElseIf PageToDraw=="Misc options"
				MiscOption_LargeItemThreshold=AddSliderOption("'Large item' min weight",RABInv_PlayerScriptReference.RABInv_LargeItemThreshold,"{1}")
				MiscOption_MediumItemThreshold=AddSliderOption("'Medium item' min weight",RABInv_PlayerScriptReference.RABInv_MediumItemThreshold,"{1}")
				MiscOption_ToggleWeightlessObjects=AddToggleOption("Skip weightless items?",RABInv_PlayerScriptReference.RABInv_SkipWeightlessItems)
				MiscOption_ToggleMysteryObjects=AddToggleOption("Include mystery items?",RABInv_PlayerScriptReference.RABInv_MysteryItemsAsSmall)
				MiscOption_ToggleDebug=AddToggleOption("Enable debug messages?",RABInv_PlayerScriptReference.RABInv_PlayerWantsDebugMessages)

				; GLZ added this section
				AddEmptyOption()
				AddHeaderOption("Added Tweaks")
				AddKeyMapOptionST("RABContainerMenuKeyCode", "Menu Key to Show Container Usage", CheckHotKey.GetValueInt(), OPTION_FLAG_WITH_UNMAP)
				; add 2 toggles in the MCM, one for enabling warnings, the other for enabling the drop sound
				GLZOption_ToggleDropSound=AddToggleOption("Play sound when items are dropped?", RABSoundEnabled.GetValueInt())
				GLZOption_ToggleWarnings=AddToggleOption("Show warnings for nearly full containers?", RABWarningsEnabled.GetValueInt())
			EndIf
		endEvent

	; -------------------------- FIND WHICH OPTION  --------------------------

		string FoundOptionCat
		int FoundOptionID
		function FindThisOptionID(int FindMe)
			; Default to error
			FoundOptionCat=""
			FoundOptionID=-1
			; Check slots
			int SlotCurrent=0
			While SlotCurrent<10
				if(SlotOption_BaseCapacity[SlotCurrent] == FindMe)
					FoundOptionCat="SlotOption_BaseCapacity"
					FoundOptionID=SlotCurrent
					return
				elseif(SlotOption_LargeBagBonus[SlotCurrent] == FindMe)
					FoundOptionCat="SlotOption_LargeBagBonus"
					FoundOptionID=SlotCurrent
					return
				elseif(SlotOption_SmallBagBonus[SlotCurrent] == FindMe)
					FoundOptionCat="SlotOption_SmallBagBonus"
					FoundOptionID=SlotCurrent
					return
				endif
				SlotCurrent+=1
			EndWhile
			; Check items
			int ItemTypeCur=0
			While ItemTypeCur<42
				if(ItemOption_Size[ItemTypeCur] == FindMe)
					FoundOptionCat="ItemOption_Size"
					FoundOptionID=ItemTypeCur
					return
				elseif(ItemOption_Slot[ItemTypeCur] == FindMe)
					FoundOptionCat="ItemOption_Slot"
					FoundOptionID=ItemTypeCur
					return
				endif
				ItemTypeCur+=1
			EndWhile
		endFunction

	; -------------------------- OPEN SLIDER --------------------------

		event OnOptionSliderOpen(int a_option)
			FindThisOptionID(a_option)
			if(a_option==MiscOption_LargeItemThreshold)
				SetSliderDialogStartValue(RABInv_PlayerScriptReference.RABInv_LargeItemThreshold)
				SetSliderDialogRange(0, 50)
				SetSliderDialogInterval(0.5)
			elseif(a_option==MiscOption_MediumItemThreshold)
				SetSliderDialogStartValue(RABInv_PlayerScriptReference.RABInv_MediumItemThreshold)
				SetSliderDialogRange(0, 50)
				SetSliderDialogInterval(0.5)
			elseif(FoundOptionCat=="SlotOption_SmallBagBonus")
				SetSliderDialogStartValue(RABInv_PlayerScriptReference.RABInv_Slot_SmallBagBonus[FoundOptionID])
				SetSliderDialogRange(-50, 150)
				SetSliderDialogInterval(0.5)
			elseif(FoundOptionCat=="SlotOption_LargeBagBonus")
				SetSliderDialogStartValue(RABInv_PlayerScriptReference.RABInv_Slot_LargeBagBonus[FoundOptionID])
				; GLZ changed from 150 to 500
				; SetSliderDialogRange(-50, 150)
				SetSliderDialogRange(-50, 500)
				SetSliderDialogInterval(0.5)
			elseif(FoundOptionCat=="SlotOption_BaseCapacity")
				SetSliderDialogStartValue(RABInv_PlayerScriptReference.RABInv_Slot_BaseCapacity[FoundOptionID])
				; GLZ changed from 150 max to 1000 max
				; SetSliderDialogRange(0, 150)
				SetSliderDialogRange(0, 1000)
				SetSliderDialogInterval(0.5)
			elseif(FoundOptionCat=="ItemOption_Size")
				SetSliderDialogStartValue(RABInv_PlayerScriptReference.RABInv_ItemSize[FoundOptionID])
				SetSliderDialogRange(0, 100)
				SetSliderDialogInterval(0.1)
			elseif(FoundOptionCat=="ItemOption_Slot")
				SetSliderDialogStartValue(RABInv_PlayerScriptReference.RABInv_ItemSlot[FoundOptionID])
				SetSliderDialogRange(0,9)
				SetSliderDialogInterval(1)
			EndIf
		endEvent

	; -------------------------- ACCEPT SLIDER --------------------------

		event OnOptionSliderAccept(int a_option,float a_value)
			FindThisOptionID(a_option)
			if(a_option==MiscOption_LargeItemThreshold)
				RABInv_PlayerScriptReference.RABInv_LargeItemThreshold=a_value
				SetSliderOptionValue(a_option,a_value,"{1}")
			elseif(a_option==MiscOption_MediumItemThreshold)
				RABInv_PlayerScriptReference.RABInv_MediumItemThreshold=a_value
				SetSliderOptionValue(a_option,a_value,"{1}")
			elseif(FoundOptionCat=="SlotOption_SmallBagBonus")
				RABInv_PlayerScriptReference.RABInv_Slot_SmallBagBonus[FoundOptionID]=a_value
				SetSliderOptionValue(a_option,a_value,"{1}")
			elseif(FoundOptionCat=="SlotOption_LargeBagBonus")
				RABInv_PlayerScriptReference.RABInv_Slot_LargeBagBonus[FoundOptionID]=a_value
				SetSliderOptionValue(a_option,a_value,"{1}")
			elseif(FoundOptionCat=="SlotOption_BaseCapacity")
				RABInv_PlayerScriptReference.RABInv_Slot_BaseCapacity[FoundOptionID]=a_value
				SetSliderOptionValue(a_option,a_value,"{1}")
			elseif(FoundOptionCat=="ItemOption_Size")
				RABInv_PlayerScriptReference.RABInv_ItemSize[FoundOptionID]=a_value
				SetSliderOptionValue(a_option,a_value,"{1}")
			elseif(FoundOptionCat=="ItemOption_Slot")
				RABInv_PlayerScriptReference.RABInv_ItemSlot[FoundOptionID]=a_value as int
				SetSliderOptionValue(a_option,a_value,"{0}")
			EndIf
		endEvent

	; -------------------------- TOGGLE INPUT --------------------------

		event OnOptionSelect(int a_option)
			if(a_option==MiscOption_ToggleDebug)
				if(RABInv_PlayerScriptReference.RABInv_PlayerWantsDebugMessages==true)
					RABInv_PlayerScriptReference.RABInv_PlayerWantsDebugMessages=false
					SetToggleOptionValue(a_option,false)
				else
					RABInv_PlayerScriptReference.RABInv_PlayerWantsDebugMessages=true
					SetToggleOptionValue(a_option,true)
				endif
			elseif(a_option==MiscOption_ToggleMysteryObjects)
				if(RABInv_PlayerScriptReference.RABInv_MysteryItemsAsSmall==true)
					RABInv_PlayerScriptReference.RABInv_MysteryItemsAsSmall=false
					SetToggleOptionValue(a_option,false)
				else
					RABInv_PlayerScriptReference.RABInv_MysteryItemsAsSmall=true
					SetToggleOptionValue(a_option,true)
				endif
			elseif(a_option==MiscOption_ToggleWeightlessObjects)
				if(RABInv_PlayerScriptReference.RABInv_SkipWeightlessItems==true)
					RABInv_PlayerScriptReference.RABInv_SkipWeightlessItems=false
					SetToggleOptionValue(a_option,false)
				else
					RABInv_PlayerScriptReference.RABInv_SkipWeightlessItems=true
					SetToggleOptionValue(a_option,true)
				endif
			elseif(a_option==GLZOption_ToggleDropSound)
				if(RABSoundEnabled.GetValueInt())
					RABSoundEnabled.SetValueInt(0)
					SetToggleOptionValue(a_option,false)
				else
					RABSoundEnabled.SetValueInt(1)
					SetToggleOptionValue(a_option,true)
				endif
			elseif(a_option==GLZOption_ToggleWarnings)
				if(RABWarningsEnabled.GetValueInt())
					RABWarningsEnabled.SetValueInt(0)
					SetToggleOptionValue(a_option,false)
				else
					RABWarningsEnabled.SetValueInt(1)
					SetToggleOptionValue(a_option,true)
				endif
			endif
		endEvent
		
		; GLZ added everything below this line
		
		state RABContainerMenuKeyCode
			event OnHighlightST()
				SetInfoText("Keyboard key to show current container usage.")
			endEvent
			event OnKeyMapChangeST(int keyCode, String conflictControl, String conflictName)
				if passesKeyConflictControl(keyCode, conflictControl, conflictName)
					UnregisterForAllKeys()
					SetKeymapOptionValueST(keyCode)
					RegisterForKey(keyCode)
					CheckHotkey.SetValueInt(keyCode)
				endIf
			endEvent
			event OnDefaultST()
				UnregisterForAllKeys()
				CheckHotkey.SetValueInt(-1)
			endEvent
		endState

		bool Function passesKeyConflictControl(int keyCode, String conflictControl, String conflictName)
			if conflictControl != "" && keyCode > 0
				String msg = "This key is already mapped to: " + conflictControl
				if conflictName != ""
					msg += " (" + conflictName + ")"
				endIf
				msg += "  Do you still want to continue?"
				return ShowMessage(msg, true, "$Yes", "$No")
			else
				return true
			endIf
		EndFunction

		event OnKeyDown(int keyCode)
			; Quit if a menu is open
			if keyCode == -1 || !SafeProcess()
				return
			endIf
			if keyCode == CheckHotkey.GetValueInt()
;				Debug.Notification("Calculating storage use...")
				; Check to see if recalc is already active; if so skip
				If (RABInv_PlayerScriptReference.GLZ_RAVInvCheckRecalc())
					Debug.Notification("Waiting for storage recalculation...")
					While(RABInv_PlayerScriptReference.GLZ_RAVInvCheckRecalc())
						Utility.Wait(1.0)
					EndWhile
				EndIf
				int[] iUsageArray = new int[9]
				int iSlot=0
				While iSlot<10	
					iUsageArray[iSlot]=Math.Ceiling(((RABInv_PlayerScriptReference.RABInv_Slot_CurrentUse[iSlot]) / (RABInv_PlayerScriptReference.RABInv_Slot_BaseCapacity[iSlot] + RABInv_PlayerScriptReference.RABInv_Slot_CurrentBonus[iSlot]))*100) as int
					iSlot = iSlot + 1
				EndWhile
				ContainerUsageMsg.Show(iUsageArray[0], iUsageArray[1], iUsageArray[2], iUsageArray[3], iUsageArray[4], iUsageArray[5], iUsageArray[6], iUsageArray[7], iUsageArray[8]) 
			endIf
		endEvent

		Bool Function SafeProcess()
			If (!Utility.IsInMenuMode()) \
			&& (!UI.IsMenuOpen("Dialogue Menu")) \
			&& (!UI.IsMenuOpen("Console")) \
			&& (!UI.IsMenuOpen("Crafting Menu")) \
			&& (!UI.IsMenuOpen("MessageBoxMenu")) \
			&& (!UI.IsMenuOpen("ContainerMenu")) \
			&& (!UI.IsMenuOpen("InventoryMenu")) \
			&& (!UI.IsMenuOpen("BarterMenu")) \
			&& (!UI.IsTextInputEnabled())
				;IsInMenuMode to block when game is paused with menus open
				;Dialogue Menu check to block when dialog is open
				;Console check to block when console is open - console does not trigger IsInMenuMode and thus needs its own check
				;Crafting Menu check to block when crafting menus are open - game is not paused so IsInMenuMode does not work
				;MessageBoxMenu check to block when message boxes are open - while they pause the game, they do not trigger IsInMenuMode
				;ContainerMenu check to block when containers are accessed - while they pause the game, they do not trigger IsInMenuMode
				;InventoryMenu check to block when inventory is open - when used with Skyrim Souls
				;BarterMenu check to block when buy items in shop - when used with Skyrim Souls
				;IsTextInputEnabled check to block when editable text fields are open
				Return True
			Else
				Return False
			EndIf
		EndFunction
