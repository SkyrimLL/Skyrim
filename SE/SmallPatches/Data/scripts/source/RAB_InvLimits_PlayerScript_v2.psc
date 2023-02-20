Scriptname RAB_InvLimits_PlayerScript_v2 extends ReferenceAlias

	; Limits how much the player can carry, using numerous "limiter slots"
	; Anything beyond the limit is dropped shortly after being picked up.
	; Support backpacks and bandoliers to increase carry limits
	; ================== GLOBAL VARIABLES ==================

		Actor GamePlayer
		float Property RABInv_LargeItemThreshold Auto
		float Property RABInv_MediumItemThreshold Auto
		bool RABInv_AllowDebugMessages=true
		bool Property RABInv_PlayerWantsDebugMessages Auto
		bool Property RABInv_MysteryItemsAsSmall Auto
		bool Property RABInv_SkipWeightlessItems Auto
		float[] Property RABInv_ItemSize Auto
		int[] Property RABInv_ItemSlot Auto
		
		;GLZ added
		Sound Property RABInv_DropSound Auto
		GlobalVariable Property RABSoundEnabled Auto
		GlobalVariable Property RABWarningsEnabled Auto
 
		int Property RABCarry_Capacity Auto

	; ========================== ITEM TYPE DEFS - WEAPONS ==========================

		int RABInv_ItemType_WeaponArrow=0
		int RABInv_ItemType_WeaponArrow_Equipped=1
		int RABInv_ItemType_WeaponBolt=2
		int RABInv_ItemType_WeaponBolt_Equipped=3
		int RABInv_ItemType_Weapon1H=4
		int RABInv_ItemType_Weapon1H_Equipped=5
		int RABInv_ItemType_Weapon2H=6
		int RABInv_ItemType_Weapon2H_Equipped=7
		int RABInv_ItemType_WeaponDagger=8
		int RABInv_ItemType_WeaponDagger_Equipped=9
		int RABInv_ItemType_WeaponCrossBow=10
		int RABInv_ItemType_WeaponCrossBow_Equipped=11
		int RABInv_ItemType_WeaponBow=12
		int RABInv_ItemType_WeaponBow_Equipped=13

	; ========================== ITEM TYPE DEFS - ARMOR ==========================

		int RABInv_ItemType_ArmorShield=14
		int RABInv_ItemType_ArmorShield_Equipped=15
		int RABInv_ItemType_ArmorCuirass=16
		int RABInv_ItemType_ArmorCuirass_Equipped=17
		int RABInv_ItemType_ArmorBoots=18
		int RABInv_ItemType_ArmorBoots_Equipped=19
		int RABInv_ItemType_ArmorHelmet=20
		int RABInv_ItemType_ArmorHelmet_Equipped=21
		int RABInv_ItemType_ArmorGauntlets=22
		int RABInv_ItemType_ArmorGauntlets_Equipped=23
		int RABInv_ItemType_Clothes=24
		int RABInv_ItemType_Clothes_Equipped=25
		int RABInv_ItemType_Jewelry=26
		int RABInv_ItemType_Jewelry_Equipped=27

	; ========================== ITEM TYPE DEFS - OTHER ==========================

		int RABInv_ItemType_BookScroll=28
		int RABInv_ItemType_Food=29
		int RABInv_ItemType_Potion=30
		int RABInv_ItemType_Drink=31
		int RABInv_ItemType_Ingredient=32
		int RABInv_ItemType_Gem=33
		int RABInv_ItemType_Soulgem=34
		int RABInv_ItemType_Lockpick=35
		int RABInv_ItemType_MiscLarge=36
		int RABInv_ItemType_MiscMedium=37
		int RABInv_ItemType_MiscSmall=38
		int RABInv_ItemType_Gold=39
		int RABInv_ItemType_OreIngot=40
		int RABInv_ItemType_HidePelt=41

	; ========================== SLOTS DEFS ==========================
		; 0: Misc items				1: Weapon sheaths
		; 2: Ammo quiver			3: Valuables purse
		; 4: fragile bottles		5: Hidden slots
		; 6: Custom slot 1			7: Custom slot 2
		; 8: Custom slot 3			9: Custom slot 4

		float[] Property RABInv_Slot_BaseCapacity Auto
		float[] Property RABInv_Slot_SmallBagBonus Auto
		float[] Property RABInv_Slot_LargeBagBonus Auto
		float[] Property RABInv_Slot_CurrentBonus Auto
		float[] Property RABInv_Slot_CurrentUse Auto
		string[] Property RABInv_Slot_OverloadMessage Auto


		bool RABInv_RecalcActive = false
		int RABInv_RecalcFuncVersion = 0

	; ================== DEBUG NOTIFICATIONS ==================

		Function RABInv_ShowDebugNotification(string MessageToShow)
			if(RABInv_PlayerWantsDebugMessages==true&&RABInv_AllowDebugMessages==true)
				Debug.Notification(MessageToShow)
			endif
		EndFunction

	; ================== INITIAL STARTUP ==================

		Event OnInit()
			_maintenance()
		endEvent

		Event OnPlayerLoadGame()
			_maintenance()
		endEvent
		
		function _maintenance()
			GamePlayer=Game.GetPlayer()

			if (RABCarry_Capacity!=0)
				Game.GetPlayer().SetActorValue("CarryWeight", RABCarry_Capacity as Float)
			endif

			if(!RABInv_RecalcActive)
				RABInv_RecalcAll()
			endif
		endfunction
		
	; ============= GLZ: FUNCTION TO SEE IF RECALCALL() IS ACTIVE FROM ANOTHER SCRIPT ================
	
		bool Function GLZ_RAVInvCheckRecalc()
			return RABInv_RecalcActive
		EndFunction

	; ================== FUNCTION TRIGGERED ON ITEM PICK UP ==================

		Event OnItemAdded(Form ItemReference,int ItemCount,ObjectReference akItemReference,ObjectReference akSourceContainer)
			; if full recalc is under way, queue up another to account for new items
			if(RABInv_RecalcActive)
				RABInv_RecalcAll()
			else
				int IncomingObjectType=RABInv_DetermineItemType(ItemReference)
				if(IncomingObjectType>=0&&RABInv_ItemSize[IncomingObjectType]!=0)
					if(ItemCount==50)
						RABInv_AddToSlot(IncomingObjectType,ItemReference,ItemCount,false)
					else
						RABInv_AddToSlot(IncomingObjectType,ItemReference,ItemCount,true)
					EndIf
				EndIf
			EndIf
		endEvent

		Function RABInv_AddToSlot(int IncomingObjectType,Form ItemReference,int ItemCount,bool AllowDrops)
			
			int MaxThatCanFit=Math.Floor((RABInv_Slot_BaseCapacity[RABInv_ItemSlot[IncomingObjectType]]+RABInv_Slot_CurrentBonus[RABInv_ItemSlot[IncomingObjectType]] - RABInv_Slot_CurrentUse[RABInv_ItemSlot[IncomingObjectType]])/(RABInv_ItemSize[IncomingObjectType] + 0.1))
			if(MaxThatCanFit<0)
				MaxThatCanFit=0
			EndIf
			RABInv_Slot_CurrentUse[RABInv_ItemSlot[IncomingObjectType]]=RABInv_Slot_CurrentUse[RABInv_ItemSlot[IncomingObjectType]]+RABInv_ItemSize[IncomingObjectType]*ItemCount
			RABInv_ShowDebugNotification(ItemCount+"xTYPE"+IncomingObjectType+" added to "+RABInv_ItemSlot[IncomingObjectType]+", now "+RABInv_Slot_CurrentUse[RABInv_ItemSlot[IncomingObjectType]]+"/"+RABInv_Slot_BaseCapacity[RABInv_ItemSlot[IncomingObjectType]]+"+"+RABInv_Slot_CurrentBonus[RABInv_ItemSlot[IncomingObjectType]])

			;GLZ added this line
			int iContainerUsage=Math.Ceiling(((RABInv_Slot_CurrentUse[RABInv_ItemSlot[IncomingObjectType]]) / (RABInv_Slot_BaseCapacity[RABInv_ItemSlot[IncomingObjectType]]+RABInv_Slot_CurrentBonus[RABInv_ItemSlot[IncomingObjectType]] + 0.1))*100)

			
			if(AllowDrops&&ItemCount>MaxThatCanFit)
				; Only drop weapons
				if (IncomingObjectType==1)  
					Debug.Notification(RABInv_Slot_OverloadMessage[RABInv_ItemSlot[IncomingObjectType]]+" Dropping "+(ItemCount - MaxThatCanFit)+" "+ItemReference.GetName())
					GamePlayer.DropObject(ItemReference,ItemCount - MaxThatCanFit)
				Endif

			;GLZ START CHANGES
				if(RABSoundEnabled.GetValueInt())
					int iSoundReturnCode1=RABInv_DropSound.Play(Gameplayer)
					; Debug.Notification("Return code should not be 0: "+iSoundReturnCode1)
				EndIf
			elseif(AllowDrops && (iContainerUsage > 90) && (RABWarningsEnabled.GetValueInt()))
				Debug.Notification("<font color='#FF9999'>WARNING: Container #" + RABInv_ItemSlot[IncomingObjectType] + " is " + iContainerUsage + "% full.</font>")
			elseif(AllowDrops && (iContainerUsage > 80) && (RABWarningsEnabled.GetValueInt()))
				Debug.Notification("WARNING: Container #" + RABInv_ItemSlot[IncomingObjectType] + " is " + iContainerUsage + "% full.")
			;GLZ END CHANGES

			EndIf
		EndFunction

	; ================== FUNCTION TRIGGERED ON ITEM DROP ==================

		Event OnItemRemoved(Form ItemReference,int ItemCount,ObjectReference akItemReference,ObjectReference akSourceContainer)
			; if full recalc is under way, queue up another to account for new items
			if(RABInv_RecalcActive)
				RABInv_RecalcAll()
			else
				int IncomingObjectType=RABInv_DetermineItemType(ItemReference)
				if(IncomingObjectType>=0&&RABInv_ItemSize[IncomingObjectType]!=0)
					RABInv_RemoveFromSlot(IncomingObjectType,ItemReference,ItemCount)
				EndIf
			EndIf
		endEvent

		Function RABInv_RemoveFromSlot(int IncomingObjectType,Form ItemReference,int ItemCount)
			RABInv_Slot_CurrentUse[RABInv_ItemSlot[IncomingObjectType]]=RABInv_Slot_CurrentUse[RABInv_ItemSlot[IncomingObjectType]] - RABInv_ItemSize[IncomingObjectType]*ItemCount
			RABInv_ShowDebugNotification(ItemCount+"xTYPE"+IncomingObjectType+" removed from "+RABInv_ItemSlot[IncomingObjectType]+", now "+RABInv_Slot_CurrentUse[RABInv_ItemSlot[IncomingObjectType]]+"/"+RABInv_Slot_BaseCapacity[RABInv_ItemSlot[IncomingObjectType]]+"+"+RABInv_Slot_CurrentBonus[RABInv_ItemSlot[IncomingObjectType]])
		EndFunction

	; ============================== EQUIPPING AN ITEM ==============================

		Event OnObjectEquipped(Form ItemReference,ObjectReference akReference)
			; if full recalc is under way, queue up another to account for new items
			if(RABInv_RecalcActive)
				RABInv_RecalcAll()
			else
				int BonusBagType=RABInv_IsThisABonusBag(ItemReference)
				If(BonusBagType==1)
					RABInv_AdjustSlotBonuses(1,1)
				ElseIf(BonusBagType==2)
					RABInv_AdjustSlotBonuses(1,2)
				EndIf
				RABInv_ToggleEquippedStatus(ItemReference,0,1)
			EndIf
		endEvent

	; ============================== UNEQUIPPING AN ITEM ==============================

		Event OnObjectUnequipped(Form ItemReference,ObjectReference akReference)
			; if full recalc is under way, queue up another to account for new items
			if(RABInv_RecalcActive)
				RABInv_RecalcAll()
			else
				int BonusBagType=RABInv_IsThisABonusBag(ItemReference)
				If(BonusBagType==1)
					RABInv_AdjustSlotBonuses( -1, 1)
				ElseIf(BonusBagType==2)
					RABInv_AdjustSlotBonuses( -1, 2)
				EndIf
				RABInv_ToggleEquippedStatus(ItemReference,1,0)
			EndIf
		endEvent

	; ======================== DETERMINE IF THIS IS A SUPPORT BAG ========================

		int Function RABInv_IsThisABonusBag(Form ItemReference)
			Int KeywordCur=ItemReference.GetNumKeywords()
			While(KeywordCur>0)
				String strThisKeyword

				if (ItemReference.GetNthKeyword(KeywordCur) != None)
					strThisKeyword = ItemReference.GetNthKeyword(KeywordCur).getString()
					if(strThisKeyword=="FrostfallBackpack"||strThisKeyword=="_WetBackpackSmall"||strThisKeyword=="_WetBackpackMed"||strThisKeyword=="_WetBackpackLarge"||strThisKeyword=="_WetBackpackHeavy"||strThisKeyword=="CampfireBackpack"||strThisKeyword=="HISBackPackKeyword")
						return 1
					elseif(strThisKeyword=="1Dr_BAN_small"||strThisKeyword=="1Dr_BAN_Normal"||strThisKeyword=="1Dr_BAN_medium"||strThisKeyword=="1Dr_BAN_Large")
						return 2
					EndIf
				endif
				KeywordCur -= 1

			EndWhile
			return -1
		EndFunction

	; ======================== DETERMINE IF THIS IS A SUPPORT BAG ========================

		Function RABInv_ToggleEquippedStatus(Form ItemReference,int RemoveFromEquipStatus,int AddToEquipStatus)
			int EquippedObjectType=RABInv_DetermineItemType(ItemReference)
			if(EquippedObjectType<0)
				return
			ElseIf(EquippedObjectType<4)
				RABInv_RemoveFromSlot(EquippedObjectType+RemoveFromEquipStatus,ItemReference,GamePlayer.GetItemCount(ItemReference))
				RABInv_AddToSlot(EquippedObjectType+AddToEquipStatus,ItemReference,GamePlayer.GetItemCount(ItemReference),false)
			ElseIf(EquippedObjectType<28)
				RABInv_RemoveFromSlot(EquippedObjectType+RemoveFromEquipStatus,ItemReference,1)
				RABInv_AddToSlot(EquippedObjectType+AddToEquipStatus,ItemReference,1,false)
			EndIf
		EndFunction

	; ============================== MOD BAG BONUS ==============================

		Function RABInv_AdjustSlotBonuses(int AddOrRemove,int BonusBagType)
			int SlotCurrent=0
			While SlotCurrent<10
				if(BonusBagType==1)
					RABInv_Slot_CurrentBonus[SlotCurrent]=RABInv_Slot_CurrentBonus[SlotCurrent]+(RABInv_Slot_LargeBagBonus[SlotCurrent]*AddOrRemove)
				else
					RABInv_Slot_CurrentBonus[SlotCurrent]=RABInv_Slot_CurrentBonus[SlotCurrent]+(RABInv_Slot_SmallBagBonus[SlotCurrent]*AddOrRemove)
				endIf
				RABInv_ShowDebugNotification("Bag type "+BonusBagType+": "+AddOrRemove+". Slot "+SlotCurrent+", now "+RABInv_Slot_CurrentUse[SlotCurrent]+"/"+RABInv_Slot_BaseCapacity[SlotCurrent]+"+"+RABInv_Slot_BaseCapacity[SlotCurrent])
				SlotCurrent+=1
			EndWhile
		EndFunction

	; ================== START FROM SCRATCH AND RECALC ALL ==================
		Function RABInv_RecalcAll()

			; Get ready:
			RABInv_RecalcActive = true
			; GLZ added this notification
			Debug.Notification("Calculating storage use...")
			
			RABInv_RecalcFuncVersion+=1
			int LocalFuncVersion=RABInv_RecalcFuncVersion
			RABInv_ShowDebugNotification("RABInv full recalc started")
			RABInv_AllowDebugMessages=false

			; Reset all slots:
			int SlotCurrent=0
			While SlotCurrent<10
				RABInv_Slot_CurrentBonus[SlotCurrent]=0
				RABInv_Slot_CurrentUse[SlotCurrent]=0
				SlotCurrent+=1
			EndWhile

			; Iterate all items in the player's inventory:
			Int PlayerItemCur=GamePlayer.GetNumItems()
			While(PlayerItemCur>0)

				; Bail if the function gets re-called
				if LocalFuncVersion!=RABInv_RecalcFuncVersion
					return
				endIF

				PlayerItemCur -= 1

				; Get this item:
				Form ThisItem=GamePlayer.GetNthForm(PlayerItemCur)
				if (ThisItem!=None)
					int ObjectType=RABInv_DetermineItemType(ThisItem)
					int ItemCount=GamePlayer.GetItemCount(ThisItem)

					; If it's equipped:
					if GamePlayer.IsEquipped(ThisItem)

						; Add bag bonuses:
						int BonusBagType=RABInv_IsThisABonusBag(ThisItem)
						If(BonusBagType==1)
							RABInv_AdjustSlotBonuses(1,1)
						ElseIf(BonusBagType==2)
							RABInv_AdjustSlotBonuses(1,2)
						EndIf

						; If it's something we care about:
						if(ObjectType>=0)

							; Arrows and bolts
							If(ObjectType<4)
								RABInv_AddToSlot(ObjectType+1,ThisItem,ItemCount,false)

							; Two handed weapons:
							ElseIf(ObjectType==6||ObjectType==10||ObjectType==12)
								RABInv_AddToSlot(ObjectType+1,ThisItem,1,false)
								if(ItemCount>1)
									RABInv_AddToSlot(ObjectType,ThisItem,ItemCount - 1,false)
								endif

							; All other equippables
							ElseIf(ObjectType<28)

								; How many are equipped? For dual-wield support
								int EquippedNum=0
								if(GamePlayer.GetEquippedWeapon(false)==ThisItem)
									EquippedNum+=1
								endif
								if(GamePlayer.GetEquippedWeapon(true)==ThisItem)
									EquippedNum+=1
								endif
								if(EquippedNum==0)
									EquippedNum=1
								EndIf

								; Add to the equipped and non-equipped slots as count permits:
								RABInv_AddToSlot(ObjectType+1,ThisItem,EquippedNum,false)
								if(ItemCount>EquippedNum)
									RABInv_AddToSlot(ObjectType,ThisItem,ItemCount - EquippedNum,false)
								endIf

							; Non-equippables
							Else
								RABInv_AddToSlot(ObjectType,ThisItem,ItemCount,false)
							EndIf

						EndIf

					; If it's NOT equipped, just add non-type 0 items
					elseif(ObjectType>=0)
						RABInv_AddToSlot(ObjectType,ThisItem,ItemCount,false)
					endif
				endif

			EndWhile

			; Finish up:
			RABInv_AllowDebugMessages=true
			RABInv_ShowDebugNotification("RABInv full recalc complete")
			RABInv_RecalcActive = false

			RABInv_DetermineCarryCapacity()
			
			; GLZ added this notification
			Debug.Notification("Storage calculation complete.")

		EndFunction

	; ================== DETERMINE WHICH SLOT THIS ITEM BELONGS IN ================== 

		int Function RABInv_DetermineWeightedSlotCapacity(Int iSlotNumber, Float fWeight)
			Float fWeightedSlotCapacity = 0

			fWeightedSlotCapacity = (RABInv_Slot_BaseCapacity[iSlotNumber] as Float) * fWeight   ; - RABInv_Slot_CurrentUse[iSlotNumber]

			return fWeightedSlotCapacity as Int
		EndFunction

		Function RABInv_DetermineCarryCapacity()
			Int iSlotNumber=0
			Int iCarryCapacity = 20 ; Base capacity - to account for clothes

			iCarryCapacity += RABInv_DetermineWeightedSlotCapacity(0, 1.0) ; 0: Misc items
			iCarryCapacity += RABInv_DetermineWeightedSlotCapacity(1, 0.5) ; 1: Weapon sheaths
			iCarryCapacity += RABInv_DetermineWeightedSlotCapacity(2, 0.1) ; 2: Ammo quiver
			iCarryCapacity += RABInv_DetermineWeightedSlotCapacity(3, 0.5) ; 3: Valuables purse
			iCarryCapacity += RABInv_DetermineWeightedSlotCapacity(4, 1.0) ; 4: fragile bottles
			iCarryCapacity += RABInv_DetermineWeightedSlotCapacity(5, 0.1) ; 5: Hidden slots
			iCarryCapacity += RABInv_DetermineWeightedSlotCapacity(6, 1.0) ; 6: Books
			iCarryCapacity += RABInv_DetermineWeightedSlotCapacity(7, 0.8) ; 7: Ingredients
			iCarryCapacity += RABInv_DetermineWeightedSlotCapacity(8, 2.0) ; 8: Clothing	
			iCarryCapacity += RABInv_DetermineWeightedSlotCapacity(9, 1.0) ; 9: Shield

			Game.GetPlayer().SetActorValue("CarryWeight", iCarryCapacity as Float)
			RABCarry_Capacity = iCarryCapacity

		EndFunction

	; ================== DETERMINE WHICH SLOT THIS ITEM BELONGS IN ==================

		int Function RABInv_DetermineItemType(Form ItemReference)
				if(ItemReference==None)
					return -1
				endif

			; ============================================= GOLD =============================================
				if(ItemReference.GetFormID()==15)
					return RABInv_ItemType_Gold

			; =========================================== LOCKPICKS ===========================================
				elseif(ItemReference.GetFormID()==10)
					return RABInv_ItemType_Lockpick

			; ======================================== ARROWS AND BOLTS ========================================
				elseif(ItemReference as Ammo)
					if((ItemReference as Ammo).IsBolt())
						return RABInv_ItemType_WeaponBolt
					else
						return RABInv_ItemType_WeaponArrow
					endIf

			; ======================================== WEIGHTLESS ITEMS ========================================
				elseif(ItemReference.GetWeight()==0&&RABInv_SkipWeightlessItems==true)
					return -1

			; ======================================== BOOKS & SCROLLS ========================================
				elseif(ItemReference as Scroll||ItemReference as Book)
					return RABInv_ItemType_BookScroll

			; ========================================== INGREDIENTS ==========================================
				elseif(ItemReference.HasKeywordString("VendorItemIngredient"))
					return RABInv_ItemType_Ingredient

			; =========================================== VALUABLES ===========================================
				elseif(ItemReference.HasKeywordString("VendorItemGem"))
					return RABInv_ItemType_Gem
				elseif(ItemReference as SoulGem)
					return RABInv_ItemType_Soulgem

			; =================================== POTIONS, FOOD, AND DRINK ===================================
				elseif(ItemReference as Potion)
					Potion PotionItem = ItemReference as Potion
					if(PotionItem.IsFood())
						if(ItemReference.HasKeywordString("VendorItemDrinkNonAlcohol")||ItemReference.HasKeywordString("VendorItemDrinkAlcohol"))
							return RABInv_ItemType_Drink
						else
							return RABInv_ItemType_Food
						endif
					else
						return RABInv_ItemType_Potion
					endif

			; ============================================= WEAPONS =============================================
				elseif(ItemReference as Weapon)
					int WeaponType = (ItemReference as Weapon).GetWeaponType()
					if(WeaponType == 2) ; Daggers
						return RABInv_ItemType_WeaponDagger
					elseif(WeaponType <= 4) ; Swords, maces, war axes
						return RABInv_ItemType_Weapon1H
					elseif(WeaponType == 7) ; Bows
						return RABInv_ItemType_WeaponBow
					elseif(WeaponType == 9) ; Crossbows
						return RABInv_ItemType_WeaponCrossBow
					else ; Great swords, battle axes, war hammers, staffs
						return RABInv_ItemType_Weapon2H
					EndIf

			; ============================================= ARMOR =============================================
				elseif(ItemReference as Armor)
					Armor ArmorItem = ItemReference as Armor
					if(ArmorItem.IsJewelry())
						return RABInv_ItemType_Jewelry
					elseif(ArmorItem.IsClothing())
						return RABInv_ItemType_Clothes
					elseif(ArmorItem.IsShield())
						return RABInv_ItemType_ArmorShield
					elseif(ArmorItem.IsCuirass())
						return RABInv_ItemType_ArmorCuirass
					elseif(ArmorItem.IsBoots())
						return RABInv_ItemType_ArmorBoots
					elseif(ArmorItem.IsGauntlets())
						return RABInv_ItemType_ArmorGauntlets
					elseif(ArmorItem.IsHelmet())
						return RABInv_ItemType_ArmorHelmet
					endIf

			; ========================================== CRAFTING MATERIALS ==========================================
				elseif(ItemReference.HasKeywordString("VendorItemOreIngot"))
					return RABInv_ItemType_OreIngot
				elseif(ItemReference.HasKeywordString("VendorItemAnimalHide"))
					return RABInv_ItemType_HidePelt

			; =================================== EVERYTHING ELSE BY WEIGHT ===================================
				elseif(ItemReference.GetWeight()>=RABInv_LargeItemThreshold)
					return RABInv_ItemType_MiscLarge
				elseif(ItemReference.GetWeight()>=RABInv_MediumItemThreshold)
					return RABInv_ItemType_MiscMedium
				EndIf

			; ==================================== DONE! ERROR IF NO MATCH ====================================
				if RABInv_MysteryItemsAsSmall==true
					return RABInv_ItemType_MiscSmall
				EndIf
				return -1

		EndFunction
		

