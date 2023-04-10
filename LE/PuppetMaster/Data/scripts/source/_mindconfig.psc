scriptname _mindConfig extends SKI_ConfigBase Conditional

GlobalVariable Property globalNecro Auto
GlobalVariable Property globalStop Auto
GlobalVariable Property globalSpells Auto

int Property basicKey Auto
bool Property basicUndressUrinate Auto
bool Property basicUndressDefecate Auto
bool Property basicKnockout Auto
bool Property basicSpeed Auto
float Property basicForce Auto
float Property basicUrinateDuration1 Auto
float Property basicUrinateDuration2 Auto
float Property basicUrinateDuration3 Auto
float Property basicDefecateDuration1 Auto
float Property basicDefecateDuration2 Auto
float Property basicDefecateDuration3 Auto
bool Property basicWomenUrinateStanding Auto
bool Property basicCreateExcrementItem Auto
bool Property basicTeammate Auto
bool Property basicFollowAnimals Auto
bool Property basicFollowHumans Auto
bool Property basicDialogue0 Auto Conditional
bool Property basicDialogue1 Auto Conditional
bool Property basicDialogue2 Auto Conditional
bool Property basicDialogue3 Auto Conditional
bool Property basicDialogue4 Auto Conditional
bool Property basicDialogue5 Auto Conditional
bool Property basicDialogue6 Auto Conditional
bool Property basicDialogue7 Auto Conditional
bool Property basicDialogue8 Auto Conditional
bool Property basicDialogue9 Auto Conditional
bool Property basicDialogue10 Auto Conditional
bool Property basicDialogue11 Auto Conditional
bool Property basicDialogue12 Auto Conditional
bool Property basicDialogue13 Auto Conditional
bool Property basicDialogue14 Auto Conditional
bool Property basicDialogue15 Auto Conditional
bool Property basicDialogue16 Auto Conditional
bool Property basicDialogue17 Auto Conditional

bool charmSpellON = false
bool controlSpellsON = false

int[] OIDs
int charmSpellOID 
int controlSpellsOID


event OnConfigInit()
	OIDs = new int[38]
endevent

event OnPageReset(string page)
	SetCursorFillMode(TOP_TO_BOTTOM)
	if(page == Pages[0])
		OIDs[0] = AddKeyMapOption("Action menu hotkey", basicKey, OPTION_FLAG_WITH_UNMAP)
		OIDs[31] = AddToggleOption("Add puppet spells to player", (globalSpells.GetValue() as int) != 0)
		charmSpellOID = AddToggleOption("Grant charm spell", charmSpellON)
		controlSpellsOID = AddToggleOption("Grant control spells", controlSpellsON)

	elseif(page == Pages[1])
		OIDs[4] = AddToggleOption("Your power attacks knock down puppets", basicKnockout)
		OIDs[5] = AddSliderOption("Extra force applied to knock down", basicForce)
		OIDs[32] = AddToggleOption("Following puppets are teammates", basicTeammate)
		OIDs[15] = AddToggleOption("Animals follow when puppeted", basicFollowAnimals)
		OIDs[16] = AddToggleOption("People follow when puppeted", basicFollowHumans)
		OIDs[35] = AddToggleOption("Increase move speed of puppets", basicSpeed)
		AddHeaderOption("Dialogue options")
		OIDs[17] = AddToggleOption("Follow / Wait", basicDialogue0)
		OIDs[18] = AddToggleOption("Give commands", basicDialogue1)
		OIDs[19] = AddToggleOption("Inventory", basicDialogue2)
		OIDs[20] = AddToggleOption("Freeze", basicDialogue3)
		OIDs[21] = AddToggleOption("Return to routine", basicDialogue4)
		OIDs[22] = AddToggleOption("Go to beacon", basicDialogue5)
		OIDs[23] = AddToggleOption("Adjust aggression", basicDialogue6)
		OIDs[24] = AddToggleOption("Adjust confidence", basicDialogue7)
		OIDs[25] = AddToggleOption("Sex", basicDialogue8)
		OIDs[26] = AddToggleOption("Urinate", basicDialogue9)
		OIDs[27] = AddToggleOption("Defecate", basicDialogue10)
		OIDs[28] = AddToggleOption("Undress / dress", basicDialogue11)
		OIDs[29] = AddToggleOption("Beat", basicDialogue12)
		OIDs[30] = AddToggleOption("Bondage", basicDialogue13)
		OIDs[34] = AddToggleOption("Decide outfit", basicDialogue15)
		OIDs[36] = AddToggleOption("Drink pee/eat feces", basicDialogue16)
		OIDs[37] = AddToggleOption("Immortality", basicDialogue17)
		OIDs[33] = AddToggleOption("Release", basicDialogue14)
	elseif(page == Pages[2])
		AddHeaderOption("Necrophilia")
		OIDs[1] = AddToggleOption("Enabled", (globalNecro.GetValue() as int) != 0)
		AddEmptyOption()
		AddHeaderOption("Urination")
		OIDs[2] = AddToggleOption("Undress", basicUndressUrinate)
		OIDs[6] = AddToggleOption("Women urinate standing", basicWomenUrinateStanding)
		OIDs[7] = AddSliderOption("Urinate start duration", basicUrinateDuration1)
		OIDs[8] = AddSliderOption("Urinate duration", basicUrinateDuration2)
		OIDs[9] = AddSliderOption("Urinate end duration", basicUrinateDuration3)
		AddEmptyOption()
		AddHeaderOption("Defecation")
		OIDs[10] = AddToggleOption("Undress", basicUndressDefecate)
		OIDs[14] = AddToggleOption("Create excrement item", basicCreateExcrementItem)
		OIDs[11] = AddSliderOption("Defecate start duration", basicUrinateDuration1)
		OIDs[12] = AddSliderOption("Defecate duration", basicUrinateDuration2)
		OIDs[13] = AddSliderOption("Defecate end duration", basicUrinateDuration3)
	elseif(page == Pages[3])
		OIDs[3] = AddToggleOption("Stop all scripts", false)
	else
		AddEmptyOption()
	endif
endevent

event OnOptionSelect(int option)
	if(option == OIDs[1])
		if((globalNecro.GetValue() as int) == 0)
			globalNecro.SetValue(1)
		else
			globalNecro.SetValue(0)
		endif
		SetToggleOptionValue(option, (globalNecro.GetValue() as int) != 0)
	elseif(option == OIDs[2])
		basicUndressUrinate = !basicUndressUrinate
		SetToggleOptionValue(option, basicUndressUrinate)
	elseif(option == OIDs[6])
		basicWomenUrinateStanding = !basicWomenUrinateStanding
		SetToggleOptionValue(option, basicWomenUrinateStanding)
	elseif(option == OIDs[14])
		basicCreateExcrementItem = !basicCreateExcrementItem
		SetToggleOptionValue(option, basicCreateExcrementItem)
	elseif(option == OIDs[10])
		basicUndressDefecate = !basicUndressDefecate
		SetToggleOptionValue(option, basicUndressDefecate)
	elseif(option == OIDs[35])
		basicSpeed = !basicSpeed
		SetToggleOptionValue(option, basicSpeed)
	elseif(option == OIDs[3])
		globalStop.SetValue(1)
		SetToggleOptionValue(option, true)
		Debug.MessageBox("Wait 10 seconds in game for all scripts to finish and save game,\nthen it is safe to uninstall Puppet Master mod.")
	elseif(option == OIDs[4])
		basicKnockout = !basicKnockout
		SetToggleOptionValue(option, basicKnockout)
	elseif(option == OIDs[31])
		if((globalSpells.GetValue() as int) == 0)
			globalSpells.SetValue(1)
		else
			globalSpells.SetValue(0)
		endif
		SetToggleOptionValue(option, (globalSpells.GetValue() as int) != 0)
	elseif(option == OIDs[15])
		basicFollowAnimals = !basicFollowAnimals
		SetToggleOptionValue(option, basicFollowAnimals)
	elseif(option == OIDs[16])
		basicFollowHumans = !basicFollowHumans
		SetToggleOptionValue(option, basicFollowHumans)
	elseif(option == OIDs[32])
		basicTeammate = !basicTeammate
		SetToggleOptionValue(option, basicTeammate)
	elseif(option == OIDs[17])
		basicDialogue0 = !basicDialogue0
		SetToggleOptionValue(option, basicDialogue0)
	elseif(option == OIDs[18])
		basicDialogue1 = !basicDialogue1
		SetToggleOptionValue(option, basicDialogue1)
	elseif(option == OIDs[19])
		basicDialogue2 = !basicDialogue2
		SetToggleOptionValue(option, basicDialogue2)
	elseif(option == OIDs[20])
		basicDialogue3 = !basicDialogue3
		SetToggleOptionValue(option, basicDialogue3)
	elseif(option == OIDs[21])
		basicDialogue4 = !basicDialogue4
		SetToggleOptionValue(option, basicDialogue4)
	elseif(option == OIDs[22])
		basicDialogue5 = !basicDialogue5
		SetToggleOptionValue(option, basicDialogue5)
	elseif(option == OIDs[23])
		basicDialogue6 = !basicDialogue6
		SetToggleOptionValue(option, basicDialogue6)
	elseif(option == OIDs[24])
		basicDialogue7 = !basicDialogue7
		SetToggleOptionValue(option, basicDialogue7)
	elseif(option == OIDs[25])
		basicDialogue8 = !basicDialogue8
		SetToggleOptionValue(option, basicDialogue8)
	elseif(option == OIDs[26])
		basicDialogue9 = !basicDialogue9
		SetToggleOptionValue(option, basicDialogue9)
	elseif(option == OIDs[27])
		basicDialogue10 = !basicDialogue10
		SetToggleOptionValue(option, basicDialogue10)
	elseif(option == OIDs[28])
		basicDialogue11 = !basicDialogue11
		SetToggleOptionValue(option, basicDialogue11)
	elseif(option == OIDs[29])
		basicDialogue12 = !basicDialogue12
		SetToggleOptionValue(option, basicDialogue12)
	elseif(option == OIDs[30])
		basicDialogue13 = !basicDialogue13
		SetToggleOptionValue(option, basicDialogue13)
	elseif(option == OIDs[33])
		basicDialogue14 = !basicDialogue14
		SetToggleOptionValue(option, basicDialogue14)
	elseif(option == OIDs[34])
		basicDialogue15 = !basicDialogue15
		SetToggleOptionValue(option, basicDialogue15)
	elseif(option == OIDs[36])
		basicDialogue16 = !basicDialogue16
		SetToggleOptionValue(option, basicDialogue16)
	elseif(option == OIDs[37])
		basicDialogue17 = !basicDialogue17
		SetToggleOptionValue(option, basicDialogue17)
	elseif(option == charmSpellOID)
		charmSpellON = !charmSpellON
		SetToggleOptionValue(option, charmSpellON)

		If charmSpellON
			SendModEvent("PMGrantCharmSpell")
		else
			SendModEvent("PMRemoveCharmSpell")
		endif

	elseif(option == controlSpellsOID)
		controlSpellsON = !controlSpellsON
		SetToggleOptionValue(option, controlSpellsON)

		If controlSpellsON
			SendModEvent("PMGrantControlSpells")
		else
			SendModEvent("PMRemoveControlSpells")
		endif

	endif
endevent

event OnOptionDefault(int option)
	if(option == OIDs[0])
		basicKey = 0
		SetKeyMapOptionValue(option, basicKey)
	elseif(option == OIDs[1])
		globalNecro.SetValue(1)
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[2])
		basicUndressUrinate = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[3])
		SetToggleOptionValue(option, false)
	elseif(option == OIDs[4])
		basicKnockout = false
		SetToggleOptionValue(option, false)
	elseif(option == OIDs[5])
		basicForce = 0.0
		SetSliderOptionValue(option, 0.0)
	elseif(option == OIDs[6])
		basicWomenUrinateStanding = false
		SetToggleOptionValue(option, false)
	elseif(option == OIDs[7])
		basicUrinateDuration1 = 2.0
		SetSliderOptionValue(option, 2.0)
	elseif(option == OIDs[8])
		basicUrinateDuration2 = 6.0
		SetSliderOptionValue(option, 6.0)
	elseif(option == OIDs[9])
		basicUrinateDuration3 = 2.0
		SetSliderOptionValue(option, 2.0)
	elseif(option == OIDs[10])
		basicUndressDefecate = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[11])
		basicDefecateDuration1 = 6.0
		SetSliderOptionValue(option, 6.0)
	elseif(option == OIDs[12])
		basicDefecateDuration2 = 5.0
		SetSliderOptionValue(option, 5.0)
	elseif(option == OIDs[13])
		basicDefecateDuration3 = 2.0
		SetSliderOptionValue(option, 2.0)
	elseif(option == OIDs[14])
		basicCreateExcrementItem = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[15])
		basicFollowAnimals = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[16])
		basicFollowHumans = false
		SetToggleOptionValue(option, false)
	elseif(option == OIDs[31])
		globalSpells.SetValue(1)
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[32])
		basicTeammate = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[17])
		basicDialogue0 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[18])
		basicDialogue1 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[19])
		basicDialogue2 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[20])
		basicDialogue3 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[21])
		basicDialogue4 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[22])
		basicDialogue5 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[23])
		basicDialogue6 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[24])
		basicDialogue7 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[25])
		basicDialogue8 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[26])
		basicDialogue9 = false
		SetToggleOptionValue(option, false)
	elseif(option == OIDs[27])
		basicDialogue10 = false
		SetToggleOptionValue(option, false)
	elseif(option == OIDs[28])
		basicDialogue11 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[29])
		basicDialogue12 = false
		SetToggleOptionValue(option, false) ; this is off by default.
	elseif(option == OIDs[30])
		basicDialogue13 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[33])
		basicDialogue14 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[34])
		basicDialogue15 = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[35])
		basicSpeed = true
		SetToggleOptionValue(option, true)
	elseif(option == OIDs[36])
		basicDialogue16 = false
		SetToggleOptionValue(option, false)
	elseif(option == OIDs[37])
		basicDialogue17 = true
		SetToggleOptionValue(option, true)
	elseif(option == charmSpellOID)
		charmSpellON = false
		SetToggleOptionValue(option, false)
		SendModEvent("PMRemoveCharmSpell")

	elseif(option == controlSpellsOID)
		controlSpellsON = false
		SetToggleOptionValue(option, false)
		SendModEvent("PMRemoveControlSpells")

	endif
endevent

event OnOptionHighlight(int option)
	if(option == OIDs[0])
		SetInfoText("Hotkey to bring up menu for urinate, defecate, masturbate.\nDefault: not set")
	elseif(option == OIDs[1])
		SetInfoText("Enable necrophilia. Sneak, sheathe weapon and activate human corpse to initiate.\nDefault: true")
	elseif(option == OIDs[2])
		SetInfoText("Automatically unequip items using SexLab normal stripping rules while urinating.\nDefault: true")
	elseif(option == OIDs[3])
		SetInfoText("This will stop all scripts and disable the mod permanently!\nYou should only do this if you plan to uninstall the mod.\nWait 10 seconds in game after this for all scripts to finish running.")
	elseif(option == OIDs[4])
		SetInfoText("If enabled, your power attacks cause puppets to fall over (ragdoll).\nDefault: false")
	elseif(option == OIDs[5])
		SetInfoText("If power attack knock down is enabled this is the amount of extra force that is applied to the hit.\nIf 0 then puppets still fall down they just don't fly further away.\nFor reference fus-ro-dah last word is 15.\nDefault: 0")
	elseif(option == OIDs[6])
		SetInfoText("Play alternate animation for women urinating.\nDefault: false")
	elseif(option == OIDs[7])
		SetInfoText("Time in seconds to play animation before starting to urinate.\nDefault: 2")
	elseif(option == OIDs[8])
		SetInfoText("Time in seconds to play urinating animation and sound.\nDefault: 6")
	elseif(option == OIDs[9])
		SetInfoText("Time in seconds to play animation after urinating.\nDefault: 2")
	elseif(option == OIDs[10])
		SetInfoText("Automatically unequip items using SexLab normal stripping rules while defecating.\nDefault: true")
	elseif(option == OIDs[11])
		SetInfoText("Time in seconds to play animation before starting to defecate.\nDefault: 6")
	elseif(option == OIDs[12])
		SetInfoText("Time in seconds to play defecating animation and sound. Excrement items created is 1 + (time / 3).\nDefault: 5")
	elseif(option == OIDs[13])
		SetInfoText("Time in seconds to play animation after defecating.\nDefault: 2")
	elseif(option == OIDs[14])
		SetInfoText("Create excrement items while defecating. You can pick these up afterwards if you like.\nDefault: true")
	elseif(option == OIDs[15])
		SetInfoText("Non-human puppets automatically start to follow when you take them under your control.\nDefault: true")
	elseif(option == OIDs[16])
		SetInfoText("Human puppets automatically start to follow when you take them under your control.\nDefault: false")
	elseif(option == OIDs[31])
		SetInfoText("Add puppet spells to player.\nDefault: true")
	elseif(option == OIDs[35])
		SetInfoText("Set movement speed of puppets higher. Tell puppet to wait and follow again for\nchange to have effect.\nDefault: true")
	elseif(option == OIDs[32])
		SetInfoText("Currently following puppets are considered teammates. That means they will sneak\nwhen you do, equip items you give them and you are blamed for their crimes.\nTell puppet to wait and follow again for change to have effect.\nDefault: true")
	else
		int i = 0
		while(i < 14)
			if((i == 0 && (OIDs[33] == option || OIDs[34] == option || OIDs[36] == option || OIDs[37] == option)) || OIDs[17 + i] == option)
				SetInfoText("Add this dialogue option to puppets.\nDefault: true")
				return
			endif
			i += 1
		endwhile
	endif
endevent

event OnOptionSliderOpen(int option)
	if(option == OIDs[5])
		SetSliderDialogStartValue(basicForce)
		SetSliderDialogDefaultValue(0.0)
		SetSliderDialogRange(0.0, 100.0)
		SetSliderDialogInterval(1.0)
	elseif(option == OIDs[7])
		SetSliderDialogStartValue(basicUrinateDuration1)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(0.5)
	elseif(option == OIDs[8])
		SetSliderDialogStartValue(basicUrinateDuration2)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(0.5)
	elseif(option == OIDs[9])
		SetSliderDialogStartValue(basicUrinateDuration3)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(0.5)
	elseif(option == OIDs[11])
		SetSliderDialogStartValue(basicDefecateDuration1)
		SetSliderDialogDefaultValue(6.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(0.5)
	elseif(option == OIDs[12])
		SetSliderDialogStartValue(basicDefecateDuration2)
		SetSliderDialogDefaultValue(5.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(0.5)
	elseif(option == OIDs[13])
		SetSliderDialogStartValue(basicDefecateDuration3)
		SetSliderDialogDefaultValue(2.0)
		SetSliderDialogRange(0.0, 20.0)
		SetSliderDialogInterval(0.5)
	endif
endevent

event OnOptionSliderAccept(int option, float value)
	if(option == OIDs[5])
		basicForce = value
		SetSliderOptionValue(option, value)
	elseif(option == OIDs[7])
		basicUrinateDuration1 = value
		SetSliderOptionValue(option, value)
	elseif(option == OIDs[8])
		basicUrinateDuration2 = value
		SetSliderOptionValue(option, value)
	elseif(option == OIDs[9])
		basicUrinateDuration3 = value
		SetSliderOptionValue(option, value)
	elseif(option == OIDs[11])
		basicDefecateDuration1 = value
		SetSliderOptionValue(option, value)
	elseif(option == OIDs[12])
		basicDefecateDuration2 = value
		SetSliderOptionValue(option, value)
	elseif(option == OIDs[13])
		basicDefecateDuration3 = value
		SetSliderOptionValue(option, value)
	endif
endevent

event OnOptionKeyMapChange(int option, int keyCode, string conflictControl, string conflictName)
	if(option == OIDs[0])
		basicKey = keyCode
		SetKeyMapOptionValue(OIDs[0], basicKey)
	endif
endevent
