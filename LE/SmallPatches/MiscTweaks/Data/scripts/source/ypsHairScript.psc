Scriptname ypsHairScript extends Quest Conditional

yps_PC_MCM Property MCMValues Auto  
ypsPiercingTicker Property PETicker Auto  
ypsUIExtensionsScript Property UIEScript Auto
ypsUtil property UtilScript Auto

bool DebugMode =false

float[] HairStageLength
string[] HairStageName
string[] DefaultHairStyleName
string[] HairColorName
int[] HairColorCode
string[] SpecialHairtypeName

bool property EnableHairgrowth = true auto
bool property EnableHairMakeover = true auto

function LoadDefaultHairstyles()
	string File
	File = "../ypsFashion/ypsHairDefault.json"
	JsonUtil.Load(File)
	int i=1
	while i<=21
		string ReadHairStyle = JsonUtil.StringListGet(File,"defaulthairstyles",i - 1 )
		if ReadHairStyle != ""
			DefaultHairStyleName[i] = ReadHairStyle
		endif
		i += 1
	endwhile
endfunction

function SetHairColors()
	HairColorName = new string[39]
	HairColorName[0]="(none)"
	HairColorName[1]="Custom"
	HairColorName[2]="Black"
	HairColorName[3]="Off Black"
	HairColorName[4]="Dark Gray"
	HairColorName[5]="Medium Gray"
	HairColorName[6]="Light Gray"
	HairColorName[7]="Platinum Blonde"
	HairColorName[8]="Bleached Blonde"
	HairColorName[9]="White Blonde"
	HairColorName[10]="Light Blonde"
	HairColorName[11]="Golden Blonde"
	HairColorName[12]="Ash Blonde"
	HairColorName[13]="Honey Blonde"
	HairColorName[14]="Strawberry Blonde"
	HairColorName[15]="Light Red"
	HairColorName[16]="Dark Red"
	HairColorName[17]="Light Auburn (Red)"
	HairColorName[18]="Dark Auburn (Red)"
	HairColorName[19]="Dark Brown"
	HairColorName[20]="Golden Brown"
	HairColorName[21]="Medium Brown"
	HairColorName[22]="Chestnut Brown"
	HairColorName[23]="Brown"
	HairColorName[24]="Light Brown"
	HairColorName[25]="Ash Brown"
	HairColorName[26]="Light Blue"
	HairColorName[27]="Light Green"
	HairColorName[28]="Pink (Red)"
	HairColorName[29]="Magenta (Red)"
	HairColorName[30]="Aubergine (Red)"
	HairColorName[31]="Medium Blue"
	HairColorName[32]="Medium Green"
	HairColorName[33]="Dark Blue"
	HairColorName[34]="Dark Green"
	HairColorName[35]="Light Turquoise (Blue Green)"
	HairColorName[36]="Medium Turquoise (Blue Green)"
	HairColorName[37]="Dark Turquoise (Blue Green)"
	HairColorName[38]="Burgundy Red"
	HairColorCode = new int[39]
	HairColorCode[2]=0x00040403
	HairColorCode[3]=0x00090909
	HairColorCode[4]=0x00202326
	HairColorCode[5]=0x002A2D31
	HairColorCode[6]=0x00515B70
	HairColorCode[7]=0x00CABFB1
	HairColorCode[8]=0x00DCD0BA
	HairColorCode[9]=0x0050585C
	HairColorCode[10]=0x00726454
	HairColorCode[11]=0x00736754
	HairColorCode[12]=0x00DEBC99
	HairColorCode[13]=0x005C4B3C
	HairColorCode[14]=0x00523523
	HairColorCode[15]=0x005A291C
	HairColorCode[16]=0x00260A02
	HairColorCode[17]=0x00482A1E
	HairColorCode[18]=0x00291E19
	HairColorCode[19]=0x001D1812
	HairColorCode[20]=0x002A241C
	HairColorCode[21]=0x0027211F
	HairColorCode[22]=0x00282222
	HairColorCode[23]=0x00352721
	HairColorCode[24]=0x00534235
	HairColorCode[25]=0x004B3C30
	HairColorCode[26]=0x0000007F
	HairColorCode[27]=0x00007F00
	HairColorCode[28]=0x007F6065
	HairColorCode[29]=0x007F007F
	HairColorCode[30]=0x00301340
	HairColorCode[31]=0x00000033
	HairColorCode[32]=0x00002F00
	HairColorCode[33]=0x00000022
	HairColorCode[34]=0x00001600
	HairColorCode[35]=0x00207067
	HairColorCode[36]=0x00103733
	HairColorCode[37]=0x000A2422
	HairColorCode[38]=0x0020000A
endfunction 

function InitHairVariables()
	HairStageLength = new float[22]
	HairStageLength[0] = 0.0 ; minimum hair length of a certain stage, in cm
	HairStageLength[1] = 0.0
	HairStageLength[2] = 0.3
	HairStageLength[3] = 1.0
	HairStageLength[4] = 3.0
	HairStageLength[5] = 6.0
	HairStageLength[6] = 12.0
	HairStageLength[7] = 20.0
	HairStageLength[8] = 30.0
	HairStageLength[9] = 37.5
	HairStageLength[10] = 45.0
	HairStageLength[11] = 52.5
	HairStageLength[12] = 60.0
	HairStageLength[13] = 75.0
	HairStageLength[14] = 90.0
	HairStageLength[15] = 105.0
	HairStageLength[16] = 120.0
	HairStageLength[17] = 135.0
	HairStageLength[18] = 145.0
	HairStageLength[19] = 160.0
	HairStageLength[20] = 180.0
	HairStageLength[21] = 210.0
	HairStageName = new string[22] ; remember to sync this with the MCM menu
	HairStageName[0] = "(none)"
	HairStageName[1] = "bald"
	HairStageName[2] = "short stubbles"
	HairStageName[3] = "long stubbles"
	HairStageName[4] = "cropped"
	HairStageName[5] = "ear length"
	HairStageName[6] = "chin length"
	HairStageName[7] = "neck length"
	HairStageName[8] = "shoulder length"
	HairStageName[9] = "armpit length"
	HairStageName[10] = "bra strap length"
	HairStageName[11] = "mid back length"
	HairStageName[12] = "waist length"
	HairStageName[13] = "hip length"
	HairStageName[14] = "tailbone length"
	HairStageName[15] = "classic length"
	HairStageName[16] = "mid-thigh length"
	HairStageName[17] = "knee length"
	HairStageName[18] = "calf length"
	HairStageName[19] = "ankle length"
	HairStageName[20] = "floor length"
	HairStageName[21] = "rapunzel length"
	DefaultHairStyleName = new string[22] ; default hair style ID for each length
	LoadDefaultHairstyles()
	SpecialHairtypeName = new string[7]
	SpecialHairtypeName[0] = "standard"
	SpecialHairtypeName[1] = "permed"
	SpecialHairtypeName[2] = "braided"
	SpecialHairtypeName[3] = "ponytail"
	SpecialHairtypeName[4] = "buzzed nape"
	SpecialHairtypeName[5] = "broad mohawk"
	SpecialHairtypeName[6] = "narrow mohawk"
endfunction

event OnInit()
	PlayerActor = Game.Getplayer()
EndEvent

Actor Property PlayerActor Auto Hidden

message property ypsPickNumber1To2 auto
message property ypsPickNumber1To3 auto
message property ypsPickNumber1To4 auto
message property ypsPickNumber1To5 auto
message property ypsPickNumber1To6 auto
message property ypsPickNumber1To7 auto
message property ypsPickNumber1To8 auto
message property ypsPickNumber1To9 auto
message property ypsPickNumber1To10 auto
message property ypsPickNumber0To9 auto
message property ypsPickNumber0To9Second auto

int function PickNumber1to10(int Limit = 10)
	if Limit == 1
		return 1
	elseif Limit == 2
		return ypsPickNumber1To2.show() + 1
	elseif Limit == 3
		return ypsPickNumber1To3.show() + 1
	elseif Limit == 4
		return ypsPickNumber1To4.show() + 1
	elseif Limit == 5
		return ypsPickNumber1To5.show() + 1
	elseif Limit == 6
		return ypsPickNumber1To6.show() + 1
	elseif Limit == 7
		return ypsPickNumber1To7.show() + 1
	elseif Limit == 8
		return ypsPickNumber1To8.show() + 1
	elseif Limit == 9
		return ypsPickNumber1To9.show() + 1
	elseif Limit == 10
		return ypsPickNumber1To10.show() + 1
	else
		return 0
	endif
endfunction

int function PickNumber(int Limit = 10)
	if Limit <= 10
		return PickNumber1to10(Limit)
	else
		if Limit > 100
			debugNotification("error: numbers > 100 not yet implemented; may only pick numbers up to 100")
			Limit = 100
		endif
		bool numberchosen = false
		int HighDigit
		int LowDigit
		int result
		while !numberchosen
			Debug.Messagebox("First pick the high digit (first digit) of a number between 01 and "+Limit+" (with leading zeroes), then pick the low (second) digit. 00 counts as 100.")
			HighDigit = ypsPickNumber0To9.show()
			LowDigit = ypsPickNumber0To9Second.show()
			if (LowDigit == 0) && (HighDigit == 0)
				HighDigit = 10
			endif
			result = HighDigit * 10 + LowDigit
			numberchosen = (result <= Limit)
		endwhile
		return result
	endif
endfunction

message property ypsHairLengthChoiceMsg1 auto
message property ypsHairLengthChoiceMsg2 auto
message property ypsHairLengthChoiceMsg3 auto

int function PickHairLength()
	int HairLength
	if Game.GetModByName("UIExtensions.esp") == 255 ; no UIExtensions -> use this mod's menus
		bool HairLengthChosen = false
		while !HairLengthChosen
			HairLength = ypsHairLengthChoiceMsg1.show()
			if HairLength < 9
				HairLengthChosen = true
			else  ; HairLength == 9
				HairLength = ypsHairLengthChoiceMsg2.show()
				if HairLength == 0
					HairLengthChosen = true
				elseif HairLength != 9
					HairLength += 8
					HairLengthChosen = true
				else
					HairLength = ypsHairLengthChoiceMsg3.show()
					if HairLength == 0
						HairLengthChosen = true
					elseif HairLength != 4
						HairLength += 16
						HairLengthChosen = true
					endif	
				endif	
			endif
		endwhile
	else
		StorageUtil.StringListClear(none,"ypsUIEList")
		int i=0
		While i < HairStageName.length
			StorageUtil.StringListAdd(none,"ypsUIEList",HairStageName[i])
			i += 1
		EndWhile
		HairLength = UIEScript.UIEGetResultFromMenu()
		if (HairLength == -1)
			; canceled with ESC/TAB
			return 0
		endif
	endif
	return HairLength
endfunction

message property ypsHairColorChoiceMsg1 auto
message property ypsHairColorChoiceMsg2 auto
message property ypsHairColorChoiceMsg3 auto
message property ypsHairColorChoiceMsg4 auto
message property ypsHairColorChoiceMsg5 auto

int function PickHairColor()
	int HairColor
	if Game.GetModByName("UIExtensions.esp") == 255 ; no UIExtensions -> use this mod's menus
		bool HairColorChosen = false
		while !HairColorChosen
			HairColor = ypsHairColorChoiceMsg1.show()
			if HairColor < 9		; 8 Color for the first menu (i.e. 1-8), 7 Colors for the second
				HairColorChosen = true
			else  ; elseif HairColor == 9
				HairColor = ypsHairColorChoiceMsg2.show()
				if HairColor == 0
					HairColorChosen = true
				elseif HairColor < 9
					HairColor += 8
					HairColorChosen = true
				else
					HairColor = ypsHairColorChoiceMsg3.show()
					if HairColor == 0
						HairColorChosen = true
					elseif HairColor < 9
						HairColor += 16
						HairColorChosen = true
					else
						HairColor = ypsHairColorChoiceMsg4.show()
						if HairColor == 0
							HairColorChosen = true
						elseif HairColor < 9
							HairColor += 24
							HairColorChosen = true

						else
							HairColor = ypsHairColorChoiceMsg5.show()
							if HairColor == 0
								HairColorChosen = true
							elseif HairColor < 7
								HairColor += 32
								HairColorChosen = true
							endif	
						endif
					endif
				endif	
			endif
		endwhile
	else
		StorageUtil.StringListClear(none,"ypsUIEList")
		int i = 0
		While i < HairColorName.length
			StorageUtil.StringListAdd(none,"ypsUIEList",HairColorName[i])
			i += 1
		EndWhile
		HairColor = UIEScript.UIEGetResultFromMenu()
		if (HairColor == -1)
			; canceled with ESC/TAB
			return 0
		endif
	endif
	return HairColor
endfunction

message property ypsCustomPresetHairstyle auto

message property ypsCustomHairStyleChoiceMsg1 auto
message property ypsCustomHairStyleChoiceMsg2 auto
message property ypsCustomHairStyleChoiceMsg3 auto
message property ypsCustomHairStyleChoiceMsg4 auto
message property ypsCustomHairStyleChoiceMsg5 auto

; standard styles are NOT available as permed too!

message property ypsHintHairstylesList auto ;	"You will now first see a list of all custom hairstyles fitting into the chosen category.\nThen you will be able to pick a number between 1 and 40.\nMake sure that you pick a number you have seen in the list, or you will have to restart this dialogue once again.")" (ok/don't show this hint again)
int DontShowHintHairstylesList = 0

string HairDatabaseListFile
string HairModName

int property StringLengthLimit = 470 autoreadonly hidden

; ChooseHairstyle() result variables:
string ChosenHairstyleID
bool HairstyleChosen ; true: selection was successful
int CustomHairstyleChosen ; 0: no custom hairstyle chosen; >=1: number of chosen custom hairstyle

function ChooseHairstyle(int HairLengthStage, int SpecialHairtype, bool ImmediatelyShowHairstyle = false) 
; results: set in the 3 variables above
	int HairStyle
	HairstyleChosen = false
	ChosenHairstyleID = ""
	CustomHairstyleChosen = 0
	string selectionresult
	Debug.Messagebox("Choose a hairstyle\n("+HairStageName[HairLengthStage]+", "+SpecialHairtypeName[SpecialHairtype]+")")
	Utility.Wait(0.02)
	int CustomStyle
	if MCMValues.CustomHairEnabled
		CustomStyle = ypsCustomPresetHairstyle.show() ; 0 = preset, 1 = custom
	else
		CustomStyle = 0
	endif
	if Game.GetModByName("UIExtensions.esp") == 255 ; no UIExtensions -> use this mod's menus
		if CustomStyle
			string CustomResultString = ""
			int i=1
			while i<41
	;;;;;;;;;;;;;;;		if (MCMValues.CustomHairStyleLength[i] == HairLengthStage) && ( (SpecialHairType == MCMValues.CustomHairStyleSpecial[i]) || ((SpecialHairType == 1) && (MCMValues.CustomHairStyleSpecial[i] == 0) ) ) ; standard styles are available as permed too!
				if (MCMValues.CustomHairStyleLength[i] == HairLengthStage) && (SpecialHairType == MCMValues.CustomHairStyleSpecial[i]) 
					CustomResultString = CustomResultString + "\n("+i+") " + MCMValues.CustomHairStyleName[i]
				endif
				i += 1
			endwhile
			if CustomResultString == ""
				debugNotification("There are no "+SpecialHairtypeName[SpecialHairtype]+" custom styles available ("+HairStageName[HairLengthStage]+")")
			else
				if !DontShowHintHairstylesList
					DontShowHintHairstylesList = ypsHintHairstylesList.show()
				endif
				Debug.Messagebox("Pick one of these custom hairstyles\n("+HairStageName[HairLengthStage]+", "+SpecialHairtypeName[SpecialHairtype]+"):"+CustomResultString)
				bool HairStyleSelection = false
				while !HairStyleSelection
					HairStyle = ypsCustomHairStyleChoiceMsg1.show()
					if HairStyle < 9
						HairStyleSelection = true
					else
						HairStyle = ypsCustomHairStyleChoiceMsg2.show()
						if HairStyle == 0
							HairStyleSelection = true
						elseif HairStyle < 9
							HairStyle += 8
							HairStyleSelection = true
						else
							HairStyle = ypsCustomHairStyleChoiceMsg3.show()
							if HairStyle == 0
								HairStyleSelection = true
							elseif HairStyle < 9
								HairStyle += 16
								HairStyleSelection = true
							else
								HairStyle = ypsCustomHairStyleChoiceMsg4.show()
								if HairStyle == 0
									HairStyleSelection = true
								elseif HairStyle < 9
									HairStyle += 24
									HairStyleSelection = true
								else
									HairStyle = ypsCustomHairStyleChoiceMsg5.show()
									if HairStyle == 0
										HairStyleSelection = true
									elseif HairStyle < 9
										HairStyle += 32
										HairStyleSelection = true
									endif
								endif
							endif
						endif	
					endif
				endwhile
	;;;;;;;;;;;;;;;			if (HairStyle != 0) && (MCMValues.CustomHairStyleLength[HairStyle] == HairLengthStage) && ( (SpecialHairType == MCMValues.CustomHairStyleSpecial[HairStyle]) || ((SpecialHairType == 1) && (MCMValues.CustomHairStyleSpecial[HairStyle] == 0) ) )
				if (HairStyle != 0) && (MCMValues.CustomHairStyleLength[HairStyle] == HairLengthStage) && (SpecialHairType == MCMValues.CustomHairStyleSpecial[HairStyle])
					ChosenHairstyleID = MCMValues.CustomHairStyleName[HairStyle]
					HairstyleChosen = true
					CustomHairstyleChosen = HairStyle
				endif
			endif
		else ; no custom style -> preset styles
			JsonUtil.StringListClear(none,"ypsHairstyleModSelection")
			HairDatabaseListFile = "../ypsFashion/ypsHairDatabase.json"
			string StageAndType = MCMValues.CustomStyleKeystring(HairLengthStage,SpecialHairtype)
			int i=0
			JsonUtil.Load(HairDatabaseListFile)
			HairModName = JsonUtil.StringListGet(HairDatabaseListFile,"HairstyleMods",i)
			while HairModName != ""
				if !MCMValues.CheckInstalledHairmods || (Game.GetModByName(HairModName) != 255)
					string HairModListName = "../ypsFashion/"+HairModName+".json"
					JsonUtil.Load(HairModListName)
					if JsonUtil.StringListCount(HairModListName,StageAndType) > 0
						JsonUtil.StringListAdd(none,"ypsHairstyleModSelection",HairModName)
					endif
				endif
				i += 1
				HairModName = JsonUtil.StringListGet(HairDatabaseListFile,"HairstyleMods",i)
			endwhile
			int ModsCount = JsonUtil.StringListCount(none,"ypsHairstyleModSelection")
			if ModsCount > 0
				string ModList = "Hair mods found with "+SpecialHairtypeName[SpecialHairtype]+" "+HairStageName[HairLengthStage]+" hair style:\n"
				i=0
				while i < ModsCount
					int j = i + 1
					Modlist = Modlist + j + ": "+ JsonUtil.StringListGet(none,"ypsHairstyleModSelection",i) + " | "
					if StringUtil.Getlength(Modlist) > StringLengthLimit
						Debug.Messagebox(Modlist + "... (more)")
						Modlist = "... "
					endif
					i += 1
				endwhile
				int ModNumber = 1
				if ModsCount > 1
					Debug.Messagebox(Modlist + "\nChoose a number between 1 and "+ModsCount)
					Utility.Wait(0.1)
					ModNumber = PickNumber(ModsCount)
				else
					Debug.Messagebox(ModList)
				endif
				string ChosenHairMod = JsonUtil.StringListGet(none,"ypsHairstyleModSelection",ModNumber - 1 )
				string ChosenHairModListName = "../ypsFashion/"+ChosenHairMod+".json"
				int ChosenHairstyleCount = JsonUtil.StringListCount(ChosenHairModListName,StageAndType)
				string HairStyleList = "Suitable hair styles in "+ChosenHairMod+": "
				i=0
				while i < ChosenHairstyleCount
					int j = i + 1
					if StringUtil.Getlength(HairStyleList) > StringLengthLimit
						Debug.Messagebox(HairStyleList + "... (more)")
						HairStyleList = "... "
					endif
					HairStyleList = HairStyleList + j + ": "+ JsonUtil.StringListGet(ChosenHairModListName,StageAndType,i) + " | "
					i += 1
				endwhile
				int HairstyleNumber = 1
				if ChosenHairstyleCount > 1
					Debug.Messagebox(HairStyleList + "\nChoose a number between 1 and "+ChosenHairstyleCount)
					Utility.Wait(0.1)
					HairstyleNumber = PickNumber(ChosenHairstyleCount)
				else
					Debug.Messagebox(HairStyleList)
				endif
				ChosenHairstyleID = JsonUtil.StringListGet(ChosenHairModListName,StageAndType,HairstyleNumber - 1 )
				HairstyleChosen = true
	;Debug.Messagebox("Selected: "+ChosenHairstyleID)

			else
				debugNotification("No hairstyles found ("+SpecialHairtypeName[SpecialHairtype]+", "+HairStageName[HairLengthStage]+")")
			endif
		endif
	else ; UIExtensions version
		StorageUtil.StringListClear(none,"ypsUIEList")
		if CustomStyle
			int[] origIndex = new int[41]
			int i=1
			int j=0
			while i<41
				if (MCMValues.CustomHairStyleLength[i] == HairLengthStage) && (SpecialHairType == MCMValues.CustomHairStyleSpecial[i]) 
					origIndex[j] = i
					StorageUtil.StringListAdd(none,"ypsUIEList",MCMValues.CustomHairStyleName[i])
					j += 1
				endif
				i += 1
			endwhile
			if j == 0
				debugNotification("There are no "+SpecialHairtypeName[SpecialHairtype]+" custom styles available ("+HairStageName[HairLengthStage]+")")
			else
				if j == 1
					; only one matching style
					HairStyle = origIndex[0]
				else
					debugNotification("Pick one of these custom hairstyles ("+HairStageName[HairLengthStage]+", "+SpecialHairtypeName[SpecialHairtype]+")")
					bool HairStyleSelection = false
					i = UIEScript.UIEGetResultFromMenu()
				if i != -1
						; not aborted
						HairStyle = origIndex[i]
					endif
				endif
				if (HairStyle != 0) && (MCMValues.CustomHairStyleLength[HairStyle] == HairLengthStage) && (SpecialHairType == MCMValues.CustomHairStyleSpecial[HairStyle])
					ChosenHairstyleID = MCMValues.CustomHairStyleName[HairStyle]
					HairstyleChosen = true
					CustomHairstyleChosen = HairStyle
				endif
			endif
		else ; no custom style -> preset styles
			Game.DisablePlayerControls() ; need to disable player controls, because jsonutil might crash when it's overloaded
			HairDatabaseListFile = "../ypsFashion/ypsHairDatabase.json"
			string StageAndType = MCMValues.CustomStyleKeystring(HairLengthStage,SpecialHairtype)

			bool StyleChosen = false
			while !StyleChosen

				int i=0
				JsonUtil.Load(HairDatabaseListFile)
				HairModName = JsonUtil.StringListGet(HairDatabaseListFile,"HairstyleMods",i)
				StorageUtil.StringListClear(none,"ypsUIEList") ; preparing hairstyle list
				if ImmediatelyShowHairstyle
					StorageUtil.StringListAdd(none,"ypsUIEList","[finish selection]")
				endif
				while HairModName != "" ; prepare list of corresponding hair style from all installed mods
					if !MCMValues.CheckInstalledHairmods || (Game.GetModByName(HairModName) != 255)
						string HairModListName = "../ypsFashion/"+HairModName+".json"
						JsonUtil.Load(HairModListName)
						int ChosenHairstyleCount = JsonUtil.StringListCount(HairModListName,StageAndType)
						int j=0
						while j < ChosenHairstyleCount
							StorageUtil.StringListAdd(none,"ypsUIEList",JsonUtil.StringListGet(HairModListName,StageAndType,j))
							j += 1
						endwhile
					endif
					i += 1
					JsonUtil.Load(HairDatabaseListFile)
					HairModName = JsonUtil.StringListGet(HairDatabaseListFile,"HairstyleMods",i)
				endwhile
				SelectionResult = UIEScript.UIEGetResultStringFromMenu()
				if !ImmediatelyShowHairstyle
					StyleChosen = true
					ChosenHairstyleID = SelectionResult
					HairstyleChosen = ChosenHairstyleID != ""
				elseif SelectionResult == "[finish selection]"
					StyleChosen = true
				else
					ChosenHairstyleID = SelectionResult
					CurrentHairstyleName = ChosenHairstyleID ; now show selected hair to player, but don't leave the loop
;debugNotification("(please wait until choice list is prepared)") ; remind player of hiccups of the UIE selection (they do happen, and I don't know why)
					HairstyleChosen = ChosenHairstyleID != ""
					checkhair()
					Utility.Wait(0.1)
				endif
			endwhile
			Game.EnablePlayerControls() 


;					if ChosenHairstyleCount > 0
;						ModsCount += 1
;						ChosenHairMod = HairModName ; in case only one mod is found ....
;						StorageUtil.StringListAdd(none,"ypsUIEList",HairModName)
;					endif


;			if ModsCount == 0
;				debugNotification("No hairstyles found ("+SpecialHairtypeName[SpecialHairtype]+", "+HairStageName[HairLengthStage]+")")
;				return
;			endif
;			if ModsCount > 1
;				ChosenHairMod = UIEScript.UIEGetResultStringFromMenu()
;			endif
;			if ChosenHairMod != ""
;				string ChosenHairModListName = "../ypsFashion/"+ChosenHairMod+".json"
;
;				int ChosenHairstyleCount = JsonUtil.StringListCount(ChosenHairModListName,StageAndType)
;				if ChosenHairstyleCount > 1
;					bool StyleChosen = false
;					while !StyleChosen
;						debugNotification("Please choose a style from " + ChosenHairMod)
;						i=0
;						StorageUtil.StringListClear(none,"ypsUIEList")
;						while i < ChosenHairstyleCount
;							StorageUtil.StringListAdd(none,"ypsUIEList",JsonUtil.StringListGet(ChosenHairModListName,StageAndType,i))
;							i += 1
;						endwhile
;						if ImmediatelyShowHairstyle
;							StorageUtil.StringListAdd(none,"ypsUIEList","[finish selection]")
;						endif
;						string SelectionResult = UIEScript.UIEGetResultStringFromMenu()
;						if !ImmediatelyShowHairstyle
;							StyleChosen = true
;							ChosenHairstyleID = SelectionResult
;						elseif SelectionResult == "[finish selection]"
;							StyleChosen = true
;						else
;							ChosenHairstyleID = SelectionResult
;							CurrentHairstyleName = ChosenHairstyleID ; now show selected hair to player
;							checkhair()
;						endif
;					endwhile
;				else
;					ChosenHairstyleID = JsonUtil.StringListGet(ChosenHairModListName,StageAndType,0)
;					debugNotification("Only "+ChosenHairstyleID+" from "+ChosenHairMod+" matches") 
;				endif
;				HairstyleChosen = ChosenHairstyleID != ""
;			endif

		endif
	endif


endfunction

MiscObject Property ypsComb auto
MiscObject Property ypsHairScissors auto
MiscObject Property ypsHairShampoo auto
MiscObject Property ypsHairColorBottle auto
MiscObject Property ypsHairPermLotion auto
MiscObject Property ypsElasticHairband auto
MiscObject Property ypsHairMakeoverOrb auto
MiscObject Property yps00ScriptHook auto
MiscObject Property ypsMirror auto

ColorForm InitialHairColorForm

bool HairgrowthInitDone = false
message property ypsEnableHairControlMsg auto
message property ypsUseCurrentHairColor auto

function SetCurrentHairLengthStage(int NewStage)
	CurrentHairLengthStage = NewStage
	StorageUtil.SetIntValue(none, "YpsCurrentHairLengthStage", NewStage)
	PETicker.CurrentlyHairLong = (CurrentHairLengthStage >= 10) ; bra strap or longer counts as "long"
	PETicker.TodayHairLong = PETicker.TodayHairLong || PETicker.CurrentlyHairLong
	PETicker.SendHairStageChangeEvent()
endfunction

function ChoseNaturalHairColor()
	bool NaturalHairColorChosen = false
	InitialHairColorForm = PlayerActor.GetActorBase().GetHairColor()
	if !ypsUseCurrentHairColor.show() 
		int ChosenHairColor = PickHairColor()
		NaturalHairColorChosen = (ChosenHairColor >= 2)
		if NaturalHairColorChosen
			SetNaturalHairColor(HairColorCode[ChosenHairColor])
		endif
	endif
	if !NaturalHairColorChosen
		debugNotification("Setting player natural hair color to current hair color")
		SetNaturalHairColor(InitialHairColorForm.GetColor())
	endif
	CheckHair()
endfunction

function HairgrowthInit() ; call this only once, upon initialization of the mod
	if !HairgrowthInitDone
		int EnablehairControl = ypsEnableHairControlMsg.show()  ; enable hair growth control: 0=no, 1=body, 2=head, 3=both
		if (EnablehairControl % 2) == 1
			MCMValues.ArmpitHairEnabled = true
			MCMValues.PubicHairEnabled = true
		endif
		if (EnablehairControl >= 2)
			HairgrowthInitDone = true
			CurrentHairLengthStage = 0
			while CurrentHairLengthStage == 0
				Debug.Messagebox("Now choose your initial hair length.\nHair growth is slow; you might want to start with long hair.")
				Utility.Wait(0.1)
				SetCurrentHairLengthStage(PickHairLength())
				if CurrentHairLengthStage == 0
					debugNotification("No hair length chosen. Starting with bald hair.")
					SetCurrentHairLengthStage(1)
				endif
			endwhile
			CurrentHairLength = HairStageLength[CurrentHairLengthStage]
			CurrentUndyedHairLength = CurrentHairLength
			SetStandardHairstyle(CurrentHairLengthStage)
			LastHairLengthUpdate = Utility.GetCurrentGameTime()
			
			ChoseNaturalHairColor()
			
			if DebugMode
				PlayerActor.Additem(ypsComb,1)
				PlayerActor.Additem(ypsElasticHairBand,1)
				PlayerActor.Additem(ypsHairScissors,1)
				PlayerActor.Additem(ypsHairShampoo,1)
				PlayerActor.Additem(ypsHairColorBottle,1)
				PlayerActor.Additem(ypsHairPermLotion,1)
				PlayerActor.Additem(ypsHairMakeoverOrb,1)
				PlayerActor.Additem(ypsMirror,1)
				PlayerActor.Additem(yps00ScriptHook,1)
			endif
			Utility.Wait(0.5)
			CheckHair()
			StorageUtil.SetIntValue(none, "YpsCurrentHairLengthStage", CurrentHairLengthStage)
		else
			MCMValues.HaircontrolEnabled = false
		endif
	endif
endfunction

ColorForm PAColorForm

race property ArgonianRace auto
race property BretonRace auto
race property DarkElfRace auto
race property HighElfRace auto
race property ImperialRace auto
race property KhajiitRace auto
race property NordRace auto
race property OrcRace auto
race property RedguardRace auto
race property WoodElfRace auto

race property ArgonianRaceVampire auto
race property BretonRaceVampire auto
race property DarkElfRaceVampire auto
race property HighElfRaceVampire auto
race property ImperialRaceVampire auto
race property KhajiitRaceVampire auto
race property NordRaceVampire auto
race property OrcRaceVampire auto
race property RedguardRaceVampire auto
race property WoodElfRaceVampire auto

race function RemoveVampireRace(race CurrentRace)
	if CurrentRace == ArgonianRaceVampire
		return ArgonianRace
	elseif CurrentRace == BretonRaceVampire
		return BretonRace
	elseif CurrentRace == DarkElfRaceVampire
		return DarkElfRace
	elseif CurrentRace == HighElfRaceVampire
		return HighElfRace
	elseif CurrentRace == ImperialRaceVampire
		return ImperialRace
	elseif CurrentRace == KhajiitRaceVampire
		return KhajiitRace
	elseif CurrentRace == NordRaceVampire
		return NordRace
	elseif CurrentRace == OrcRaceVampire
		return OrcRace
	elseif CurrentRace == RedguardRaceVampire
		return RedguardRace
	elseif CurrentRace == WoodElfRaceVampire
		return WoodElfRace
	else
		return CurrentRace ; unable to remove vampire race, keeping vampire race
	endif
endfunction

int Property kSlotMask31 = 0x00000002 AutoReadOnly ; Hair (i.e. helmet)
bool ExtraCheckHairDue = false
keyword property ActorTypeUndead auto

int property BuzzCutReminders = 10 autoreadonly hidden ; 10 reminders
int BuzzCutRemindersLeft = 0

bool AlreadyDidHairCheck = false;

bool currentlyrunninghaircheck = false

function WaitUntilHaircheckDone()
	if currentlyrunninghaircheck
		debugNotification("(hair script is busy)")
	endif
	while currentlyrunninghaircheck
		Utility.Wait(0.5)
	endwhile
endfunction

function CheckHair(bool SetFashionAddictionValues = true, bool routine = false)  ; sets hair to currently worn hairstyle + color
	if (!currentlyrunninghaircheck) || (!routine)
		WaitUntilHaircheckDone()
		Utility.Wait(0.02)
		currentlyrunninghaircheck = true
		DoCheckHair(SetFashionAddictionValues)
		currentlyrunninghaircheck = false
	endif
endfunction


function DoCheckHair(bool SetFashionAddictionValues = true) 
	if AlreadyDidHairCheck && ( PlayerActor.IsOnMount() || (MCMValues.HelmetPreventsHaircheck && (PlayerActor.GetWornForm(kSlotMask31) != NONE)) ); conditions to postpone haircheck
		ExtraCheckHairDue = true
		RegisterForSingleUpdate(30.0) ; start the ticker to retry hair check over and over
	else
		ExtraCheckHairDue = false ; stop the ticker
		race CurrentPlayerRace
		bool PlayerIsVampire = PlayerActor.HasKeyword(ActorTypeUndead)
		if PlayerIsVampire && MCMValues.VampireHaircontrol
			CurrentPlayerRace = PlayerActor.getrace()
			PlayerActor.setrace(RemoveVampireRace(CurrentPlayerRace))
		endif
		HeadPart CurrentHair = HeadPart.GetHeadPart(CurrentHairstyleName)
		PlayerActor.ChangeHeadPart(CurrentHair)
		if !MCMValues.HairColorControlDisabled
;			InitialHairColorForm = PlayerActor.GetActorBase().GetHairColor() ; (this is not required)
			InitialHairColorForm.SetColor(CurrentHairColor())
			PlayerActor.GetLeveledActorBase().SetHairColor(InitialHairColorForm)
			if MCMValues.QueueNiNodeUpdate
				String facegen = "bUseFaceGenPreprocessedHeads:General"
				Utility.SetINIBool(facegen, False)
				If !PlayerActor.WornHasKeyword(PETicker.zad_DeviousGag) && !PlayerActor.WornHasKeyword(PETicker.zbfWornGag) && !PETicker.Sexlab.IsMouthOpen(PlayerActor)
					PlayerActor.QueueNiNodeUpdate() ; Closes the PC mouth if open
				EndIf
				Utility.SetINIBool(facegen, True)
			endif
		endif
		if PlayerIsVampire && MCMValues.VampireHaircontrol
			PlayerActor.setrace(CurrentPlayerRace)
		endif
		bool HairDyeReminder = false
		if MCMValues.HairDyeGrowsOut
			HairDyeReminder = (CurrentUndyedHairLength >= 2.0) && (CurrentUndyedHairLength < CurrentHairLength) && (Utility.GetCurrentGameTime() >= MCMValues.MinHairColorDuration + LastColorationTime) ; more than 2.5cm hair undyed, and redye possible
		else 
			float FadeTime = Utility.GetCurrentGameTime() - LastColorationTime - MCMValues.ColorationDuration ; how many days into fade time?
			HairDyeReminder = (FadeTime >= 0) && (FadeTime < MCMValues.ColorationFadeInterval)
		endif
		bool HairLongProudness = CurrentHairlengthStage >= 10 ; bra strap or longer
		if (PlayerSpecialHairtype == 4)
			BuzzCutRemindersLeft = BuzzCutReminders ; set count to max
		elseif CurrentHairLengthStage < 5 ; too short for buzz
			BuzzCutRemindersLeft = 0
		endif
		int RandInt=Utility.RandomInt(1,9)
		if (RandInt == 1) && HairDyeReminder
			debugNotification("You should redye your hair.")
		elseif (RandInt == 2) && HairLongProudness
			debugNotification("You are really proud of your long hair.")
;		elseif (RandInt == 3) && BuzzCutRemindersLeft && (PlayerSpecialHairtype < 4) && (PlayerSpecialHairtype != 1) && (CurrentHairLengthStage >= 5) ; only remind if hair is standard or braid or ponytail, and length allows buzzcut (chin)
		elseif (RandInt == 3) && (PlayerSpecialHairtype == 4) && (CurrentHairLength - HairStageLength[CurrentHairLengthStage] >= 1.0) ; more than 1cm has grown out
			debugNotification("You should refresh your buzz nape haircut.")
			BuzzCutRemindersLeft -= 1
;		elseif (RandInt == 4)
;				PETicker.PlayYpsSound(22)
		endif
		AlreadyDidHairCheck = true
	endif
	if SetFashionAddictionValues
		PETicker.CurrentlyHairPerm = (PlayerSpecialHairtype == 1)
		PETicker.TodayHairPerm = PETicker.TodayHairPerm || PETicker.CurrentlyHairPerm
		PETicker.CurrentlyHairBuzz = (PlayerSpecialHairtype == 4)
		PETicker.TodayHairBuzz = PETicker.TodayHairBuzz || PETicker.CurrentlyHairBuzz
		PETicker.CurrentlyMohawk = (PlayerSpecialHairtype == 5) || (PlayerSpecialHairtype == 6)
		if MCMValues.HairDyeGrowsOut
			PETicker.CurrentlyHairDye = ((CurrentUndyedHairLength / (CurrentHairLength + 0.0001) < 0.25) || (CurrentUndyedHairLength <= 2.0)) && (CurrentUndyedHairLength < CurrentHairLength) ; have dyed some, and less than 25% or less then 2cm hair is undyed
		else 
			PETicker.CurrentlyHairDye = (Utility.GetCurrentGameTime() - LastColorationTime <= MCMValues.ColorationDuration)
		endif
		PETicker.TodayHairDye = PETicker.TodayHairDye || PETicker.CurrentlyHairDye
		PETicker.CurrentlyHairLong = (CurrentHairLengthStage >= 10) ; bra strap or longer counts as "long"
		PETicker.TodayHairLong = PETicker.TodayHairLong || PETicker.CurrentlyHairLong
	endif
endfunction

event OnUpdate()
	if ExtraCheckHairDue
		CheckHair()
	endif
endevent

float CurrentHairLength ; in cm
float CurrentUndyedHairLength ; undyed hair growing after a dye
float property HairGrowthPerDay = 0.04166666666 autoreadonly ; (1.25cm per month)
float LastHairLengthUpdate ; last time the hair length was updated

int CurrentHairlengthStage
string CurrentHairstyleName

bool HairgrowthLock = false

string function FollowupHairstyle(string OriginalStyle, int HairlengthStage, int SpecialHairtype = 0)
; returns the HairstyleID, to which OriginalStyle will grow in
; returns empty string if no such hairstyle exists
; note that the FollowupHairstyle will persist the PlayerSpecialHairtype (e.g. perm will grow into a perm, braid into braid, buzz into a buzz, mohawk into a mohwak etc.)
	string File
	File = "../ypsFashion/ypsHairgrowthDatabase.json"
	JsonUtil.Load(File)
;Debug.Messagebox(MCMValues.CustomStyleKeystring(HairLengthStage,SpecialHairtype)+":"+OriginalStyle+" is followed by: "+JsonUtil.GetStringValue(File,MCMValues.CustomStyleKeystring(HairLengthStage,SpecialHairtype)+":"+OriginalStyle)
	return JsonUtil.GetStringValue(File,MCMValues.CustomStyleKeystring(HairLengthStage,SpecialHairtype)+":"+OriginalStyle)
; make also sure that the length matches!
endfunction

function CheckHairGrowth()
; updates (grown) hair length
    if EnableHairgrowth && !Hairgrowthlock && !PlayerActor.IsOnMount() ; don't do this during a hair cut or coloring session!!! or when player is sitting on a mount
	float CurrentHairLengthUpdateTime = Utility.GetCurrentGameTime()
	float HairGrown = HairGrowthPerDay * (CurrentHairLengthUpdateTime-LastHairLengthUpdate) * MCMValues.HairGrowthMultiplicator * (1+ (MCMValues.FastHairGrowth as int)*9)
	CurrentHairLength += HairGrown
	CurrentUndyedHairLength += HairGrown
	LastHairLengthUpdate = CurrentHairLengthUpdateTime
	if (CurrentHairlengthStage<21) && (CurrentHairLength >= HairStageLength[CurrentHairlengthStage+1])
		if (PlayerCurrentCustomHairstyle > 0) && (PlayerCurrentCustomHairstyle < 40) && (MCMValues.CustomHairStyleLength[PlayerCurrentCustomHairstyle+1] == (CurrentHairlengthStage + 1)) ; next custom hair style fits to new length
			SetCurrentHairLengthStage(CurrentHairlengthStage + 1)
			CurrentHairstyleName = MCMValues.CustomHairStyleName[CurrentHairLengthStage]
			PlayerSpecialHairtype == MCMValues.CustomHairStyleSpecial[CurrentHairlengthStage]
			PlayerCurrentCustomHairstyle += 1
			debugNotification("Your hair has grown to "+HairStageName[CurrentHairlengthStage])
		else
			string FollowupStyle = FollowupHairstyle(CurrentHairstyleName,CurrentHairlengthStage,PlayerSpecialHairtype)
			if FollowupStyle == ""
				if PlayerSpecialHairtype == 1 ; perm
					debugNotification("Your perm has grown out.")
					PlayerSpecialHairtype = 0
				elseif PlayerSpecialHairtype == 2
					debugNotification("Your braid dissolves, as your hair grows.")
					PlayerSpecialHairtype = 0
				elseif PlayerSpecialHairtype == 3
					debugNotification("Your ponytail dissolves, as your hair grows.")
					PlayerSpecialHairtype = 0
				elseif PlayerSpecialHairtype == 4
					debugNotification("Your buzzed nape disappears, as your hair grows.")
					PlayerSpecialHairtype = 0
				endif
			endif
			if (PlayerSpecialHairtype >= 5) && (FollowupStyle == "") ; mohawk at maximum length
				debugNotification("Your mohawk cannot grow any longer. You decide to trim it down.")
				PETicker.PlayYpsSound(11)
				PETicker.PlayYpsSound(11)
				CurrentHairLength = HairStageLength[CurrentHairlengthStage]
				if CurrentUndyedHairLength > CurrentHairLength ; hair got cut shorter than undyed hair length
					CurrentUndyedHairLength = CurrentHairLength
				endif
			else ; grow mohawk or any other type 0~4
				SetCurrentHairLengthStage(CurrentHairlengthStage + 1)
				SetStandardHairstyle(CurrentHairLengthStage,FollowupStyle,PlayerSpecialHairtype)
				if (PlayerSpecialHairtype >= 5) 
					debugNotification("Your mohawk has grown. You decide to shave your head sides.")
					PETicker.PlayYpsSound(11)
					PETicker.PlayYpsSound(11)
				else
					debugNotification("Your hair has grown to "+HairStageName[CurrentHairlengthStage])
				endif
			endif
		endif
	endif
	CheckHair()
	if DebugMode
		debugNotification("Hair length now "+CurrentHairLength+"cm, undyed: "+CurrentUndyedHairLength)
	endif
    endif
endfunction

int NaturalHairColor
int NaturalHairColorRed ; the RGB color values split up
int NaturalHairColorGreen
int NaturalHairColorBlue
int HairColorationColor
int HairColorationColorRed
int HairColorationColorGreen
int HairColorationColorBlue

function SetNaturalHairColor(int Color) ; always use this to set the natural color, so that the RGB colors are computed correctly
	NaturalHairColor = Color
	NaturalHairColorRed = Color / 65536
	NaturalHairColorGreen = (Color / 256) % 256
	NaturalHairColorBlue = Color % 256
endfunction
int function vividify(int Colorvalue, int maxvalue) ; makes a single R or G or B color more vivid
	if maxvalue == 0 ; avoid division by zero
		maxvalue = 1
	endif
	int limit = (maxvalue * 5) / 3
	if limit >= 256
		limit = 255
	endif
	int result = Colorvalue * Limit / maxvalue
	return result
endfunction
function SetHairColorationColor(int Color, bool vividcolors = false) ; always use this to set the color, so that the RGB colors are computed correctly
	HairColorationColorRed = Color / 65536
	HairColorationColorGreen =  (Color / 256) % 256
	HairColorationColorBlue = Color % 256
	if vividcolors
		int maxRGBValue = HairColorationColorRed
		if HairColorationColorGreen > maxRGBValue
			maxRGBValue = HairColorationColorGreen
		endif
		if HairColorationColorBlue > maxRGBValue
			maxRGBValue = HairColorationColorBlue
		endif
		HairColorationColorRed = vividify(HairColorationColorRed,maxRGBValue)
		HairColorationColorGreen = vividify(HairColorationColorGreen,maxRGBValue)
		HairColorationColorBlue = vividify(HairColorationColorBlue,maxRGBValue)
		HairColorationColor = (HairColorationColorRed * 65536) + (HairColorationColorGreen * 256) + HairColorationColorBlue
	else
		HairColorationColor = Color
	endif

endfunction

function RemoveHairColoration() ; resets the player hair to all natural hair color (debug function)
	debugNotification("removing unnatural hair coloration from player")
	CurrentUndyedHairLength = CurrentHairLength
	CurrentHairColorName = HairColorName[0]
	CheckHair()
endfunction

float LastColorationTime = -99999.99  ; a long time in the past, so no color is left at game start

string CurrentHairColorName

int function CurrentHairColor() ; computes the current hair color, taking into account colorized hair and fade-off time
	float FadeFactor = 0.0
	if MCMValues.HairDyeGrowsOut
		if CurrentHairLength > 0.0
			FadeFactor = CurrentUndyedHairLength / CurrentHairLength ; else FadeFactor = 0.0
		endif
	else
		float FadeTime = Utility.GetCurrentGameTime() - LastColorationTime - MCMValues.ColorationDuration ; how many days into fade time?
		if FadeTime >= MCMValues.ColorationFadeInterval
			FadeFactor = 1.0 ; hair color completely faded
		elseif FadeTime > 0.0
			FadeFactor = FadeTime / MCMValues.ColorationFadeInterval ; note that division by zero may not happen (will never be caught in this "if" statement)
;		elseif FadeTime <= 0.0
;			FadeFactor = 0.0 ; -> not needed, because this is the default value
		endif
	endif
	int HairColorRed = (NaturalHairColorRed * FadeFactor + HairColorationColorRed * (1-FadeFactor)) as int
	int HairColorBlue = (NaturalHairColorBlue * FadeFactor + HairColorationColorBlue * (1-FadeFactor)) as int
	int HairColorGreen = (NaturalHairColorGreen * FadeFactor + HairColorationColorGreen * (1-FadeFactor)) as int
	return HairColorRed*65536 + HairColorGreen*256 + HairColorBlue
endfunction

MiscObject Property ypsHairTrophy20 auto
MiscObject Property ypsHairTrophy30 auto
MiscObject Property ypsHairTrophy40 auto
MiscObject Property ypsHairTrophy50 auto
MiscObject Property ypsHairTrophy60 auto
MiscObject Property ypsHairTrophy70 auto
MiscObject Property ypsHairTrophy80 auto
MiscObject Property ypsHairTrophy90 auto
MiscObject Property ypsHairTrophy100 auto
MiscObject Property ypsHairTrophy110 auto
MiscObject Property ypsHairTrophy120 auto
MiscObject Property ypsHairTrophy130 auto
MiscObject Property ypsHairTrophy140 auto
MiscObject Property ypsHairTrophy150 auto
MiscObject Property ypsHairTrophy160 auto
MiscObject Property ypsHairTrophy170 auto
MiscObject Property ypsHairTrophy180 auto

function SetStandardHairstyle(int HairlengthStage, string NewHairStyleName = "", int NewPlayerSpecialHairtype = 0) 
; sets the appearance of standard hairstyle of a certain length
; sets also the CurrentHairstyleName
; does not change current hairlength stage value!
; does not change the appearance (need a Checkhair call later)
	if NewHairStyleName != ""
		CurrentHairstyleName = NewHairStyleName
		PlayerCurrentCustomHairstyle = 0
		PlayerSpecialHairtype = NewPlayerSpecialHairtype ; standard hair, no perm etc.
	elseif (MCMValues.CustomHairAsDefault) && (MCMValues.CustomHairStyleLength[HairLengthStage] == HairLengthStage)
		CurrentHairstyleName = MCMValues.CustomHairStyleName[HairLengthStage]
		PlayerCurrentCustomHairstyle = HairLengthStage
		PlayerSpecialHairtype = MCMValues.CustomHairStyleSpecial[HairLengthStage]
	else
		int HairLengthNameStage = HairLengthStage ; if current default hair mod is not installed, downgrade to shorter
		while (HairLengthNameStage > 1) && !CheckForInstalledHairMod(DefaultHairStyleName[HairLengthNameStage],false)
			HairLengthNameStage -= 1
		endwhile
		CurrentHairstyleName = DefaultHairStyleName[HairLengthNameStage]
		PlayerCurrentCustomHairstyle = 0
		PlayerSpecialHairtype = NewPlayerSpecialHairtype
	endif
endfunction

; make sure to catch special case before calling haircut function: mohawk, nape...!!!

function DoPlayerHairCut(int NewHairStage, bool ForceHairCut = false, string NewHairStyleName = "", string HairCutterName = "", bool silent = false)
	bool HairGrowth = NewHairStage > CurrentHairlengthStage
	float DyedHairLength = CurrentHairLength - CurrentUndyedHairLength
	if HairGrowth && !ForceHairCut
		Debug.Messagebox("Currently your hair is only "+HairStageName[CurrentHairlengthStage]+", and cannot be cut to "+HairStageName[NewHairStage])
	else
		float TrophyLength = 0.0
		if HairStageLength[NewHairStage] <= 15.0
			TrophyLength = CurrentHairLength - 15.0 ; very short hair does not count to trophy
		else
			TrophyLength = CurrentHairLength - HairStageLength[NewHairStage]
		endif
		if Silent
			debugNotification("Your hair has grown to "+HairStageName[NewHairStage])
		else
			if NewHairStage >= 4
				PETicker.PlayYpsSound(15,7.0) ; scissors sound
				if HairCutterName == ""
					debugNotification("Your hair has now been cut to "+HairStageName[NewHairStage])
				else
					debugNotification("Your hair has now been cut by "+HairCutterName+" to "+HairStageName[NewHairStage])
				endif
			else
				if NewHairStage >= 2
					PETicker.PlayYpsSound(17,12.0) ; buzz sound
				endif
				if HairCutterName == ""
					debugNotification("Your hair has now been trimmed to "+HairStageName[NewHairStage])
				else
					debugNotification("Your hair has now been trimmed by "+HairCutterName+" to "+HairStageName[NewHairStage])
				endif
			endif
		endif
		CurrentHairLength = HairStageLength[NewHairStage]
		if HairGrowth ; when hair grows, must adjust UndyedHair
			CurrentUndyedHairLength = CurrentHairLength - DyedHairLength
		endif
		if CurrentUndyedHairLength >= CurrentHairLength ; hair got cut shorter than undyed hair length
			CurrentUndyedHairLength = CurrentHairLength
			CurrentHairColorName = HairColorName[0] ; no more colorated hair left, set to color name to "none"
		endif

		SetCurrentHairLengthStage(NewHairStage)
		SetStandardHairstyle(CurrentHairLengthStage,NewHairStyleName)
		LastHairLengthUpdate = Utility.GetCurrentGameTime()
		CheckHair()
		if (TrophyLength >= 20.0) && ! silent
			string FHD = "" ; <from hairdresser> string
			if HairCutterName != ""
				FHD = " from "+HairCutterName
			endif
			MiscObject HairTrophy
			if TrophyLength >= 90.0
				if TrophyLength >= 180.0
					HairTrophy = ypsHairTrophy180
				elseif TrophyLength >= 170.0
					HairTrophy = ypsHairTrophy170
				elseif TrophyLength >= 160.0
					HairTrophy = ypsHairTrophy160
				elseif TrophyLength >= 150.0
					HairTrophy = ypsHairTrophy150
				elseif TrophyLength >= 140.0
					HairTrophy = ypsHairTrophy140
				elseif TrophyLength >= 130.0
					HairTrophy = ypsHairTrophy130
				elseif TrophyLength >= 120.0
					HairTrophy = ypsHairTrophy120
				elseif TrophyLength >= 110.0
					HairTrophy = ypsHairTrophy110
				elseif TrophyLength >= 100.0
					HairTrophy = ypsHairTrophy100
				else
					HairTrophy = ypsHairTrophy90
				endif
				Debug.Messagebox("You receive"+FHD+" a bundle of your cut off hair as reward.\nYou'll have to wait an endless time to let it grow back.")
			elseif TrophyLength >= 80.0
				HairTrophy = ypsHairTrophy80
				Debug.Messagebox("You receive"+FHD+" a bundle of your cut off hair as reward.\nIt will take an incredibly long time to grow back.")
			elseif TrophyLength >= 70.0
				HairTrophy = ypsHairTrophy70
				Debug.Messagebox("You receive"+FHD+" a bundle of your cut off hair as reward.\nIt will take a very long time to grow back.")
			elseif TrophyLength >= 60.0
				HairTrophy = ypsHairTrophy60
				Debug.Messagebox("You receive"+FHD+" a bundle of your cut off hair as reward.\nIt will take a long time to grow back.")
			elseif TrophyLength >= 50.0
				HairTrophy = ypsHairTrophy50
				Debug.Messagebox("You receive"+FHD+" a bundle of your cut off hair as reward.\nIt will take a quite long time to grow back.")
			elseif TrophyLength >= 40.0
				HairTrophy = ypsHairTrophy40
				Debug.Messagebox("You receive"+FHD+" a bundle of your cut off hair as reward.\nIt will take a while to grow back.")
			elseif TrophyLength >= 30.0
				HairTrophy = ypsHairTrophy30
				Debug.Messagebox("You receive"+FHD+" a bundle of your cut off hair as reward.\nIt will take some time to grow back.")
			else
				HairTrophy = ypsHairTrophy20
				Debug.Messagebox("You receive"+FHD+" a bundle of your cut off hair as reward.\nIt will take a little while to grow back.")
			endif
			PlayerActor.AddItem(HairTrophy,1)
			Utility.Wait(0.01)
		endif
	endif
endfunction

function DoPlayerHairColoring(int Color, string ColorName, bool Showmsg = true, bool CheckAddictionStatus = true, bool vividcolors = false)
	SetHairColorationColor(Color,vividcolors)
	CurrentHairColorName = ColorName
	LastColorationTime = Utility.GetCurrentGameTime()
	CurrentUndyedHairLength = 0.0
	CheckHair(CheckAddictionStatus)
	if Showmsg
		if MCMValues.HairDyeGrowsOut
			Debug.Messagebox("Your hair has now been colored "+ColorName+".\nThe new color will gradually fade as your hair grows longer.")
		else
			Debug.Messagebox("Your hair has now been colored "+ColorName+".\nThe new color will last for "+UtilScript.FormatTimeDiff(MCMValues.ColorationDuration)+"and will then gradually fade away within another "+UtilScript.FormatTimeDiff(MCMValues.ColorationFadeInterval))
		endif
	endif
endfunction

function DoPlayerHairColoringStandard(int ColorNumber, bool Showmsg = true, bool CheckAddictionStatus = true, bool vividcolors = false) ; color hair to one of the preset colors (or preset custom color), or a more vivid version of it
	if ColorNumber == 0
		Debug.Messagebox("(no hair color selected)")
	elseif ColorNumber == 1
		DoPlayerHairColoring(MCMValues.CustomHairColorValueInt,MCMValues.CustomHairColorName,Showmsg,CheckAddictionStatus,vividcolors)
	else
		DoPlayerHairColoring(HairColorCode[ColorNumber],HairColorName[ColorNumber],Showmsg,CheckAddictionStatus,vividcolors)
	endif
endfunction

bool function CheckForInstalledHairMod(string HairstyleName, bool ShowMsgBox = true)
	bool CheckResult = true
	if MCMValues.CheckInstalledHairmods
		if StringUtil.Find(HairstyleName ,"0") == 0
			CheckResult = Game.GetModByName("KS Hairdo's.esp") != 255
			if !CheckResult && ShowMsgBox
				Debug.Messagebox("for hairstyle ["+HairstyleName+"] you need to install: KS Hairdo's")
			endif
		elseif StringUtil.Find(HairstyleName ,"1") == 0
			CheckResult = Game.GetModByName("KS Hairdos - HDT.esp") != 255
			if !CheckResult && ShowMsgBox
				Debug.Messagebox("for hairstyle ["+HairstyleName+"] you need to install: KS Hairdos - HDT")
			endif
		elseif StringUtil.Find(HairstyleName ,"LH") == 0
			CheckResult = Game.GetModByName("LovelyHairstylesCE.esp") != 255
			if !CheckResult && ShowMsgBox
				Debug.Messagebox("for hairstyle ["+HairstyleName+"] you need to install: LovelyHairstylesCE")
			endif
		elseif StringUtil.Find(HairstyleName ,"Yoo_MeridaHair_") == 0
			CheckResult = Game.GetModByName("MeridaHair.esp") != 255
			if !CheckResult && ShowMsgBox
				Debug.Messagebox("for hairstyle ["+HairstyleName+"] you need to install: Merida HDT Hair")
			endif
		elseif StringUtil.Find(HairstyleName ,"ApachiiHairF") == 0
			CheckResult = Game.GetModByName("ApachiiHair.esm") != 255
			if !CheckResult && ShowMsgBox
				Debug.Messagebox("for hairstyle ["+HairstyleName+"] you need to install: Apachii Sky Hair v. 1.6 full")
			endif
		elseif StringUtil.Find(HairstyleName ,"ApachiiHairHuman") == 0
			CheckResult = Game.GetModByName("ApachiiHairFemales.esm") != 255
			if !CheckResult && ShowMsgBox
				Debug.Messagebox("for hairstyle ["+HairstyleName+"] you need to install: Apachii Sky Hair Female v. 1.5")
			endif
		endif
	endif
	return CheckResult
endfunction

int PlayerSpecialHairtype = 0 ; 0=standard,1=permed,2=braided,3=ponytail,4=broad mohawk,5=narrow mohawk
float PlayerPermDate = -100000.0 ; large negative value
int PlayerCurrentCustomHairstyle = 0 ; = 0 if no custom hairstyle is applied, otherwise it's the custom hairstyle number

; the following functions are tied to certain items
function HairGrowthPotion()
	if (PlayerSpecialHairtype >= 5)
		debugNotification("The potion has no effect on your mohawk.")
	elseif !EnableHairGrowth
		debugNotification("The potion doesn't seem to have any effect.")
	elseif (CurrentHairLength < HairStageLength[21]) && !PlayerActor.IsOnMount()
		CurrentUndyedHairLength += HairStageLength[21] - CurrentHairLength
		CurrentHairLength = HairStageLength[21]
		LastHairLengthUpdate = Utility.GetCurrentGameTime()
		if PlayerSpecialHairtype == 1 ; perm
			debugNotification("Your perm has grown out.")
		elseif PlayerSpecialHairtype == 2
			debugNotification("Your braid dissolves, as your hair grows.")
		elseif PlayerSpecialHairtype == 3
			debugNotification("Your ponytail dissolves, as your hair grows.")
		elseif PlayerSpecialHairtype == 4
			debugNotification("Your buzzed nape disappears, as your hair grows.")
		endif
; add some sound ...
		PlayerSpecialHairtype = 0
		SetCurrentHairLengthStage(21)
		SetStandardHairstyle(CurrentHairLengthStage,"",PlayerSpecialHairtype)
		debugNotification("Your hair has grown to "+HairStageName[CurrentHairlengthStage])
		CheckHair()
	endif
endfunction
function NaturalHairColorPotion()
	int ChosenHairColor = PickHairColor()
	if ChosenHairColor >= 2
		SetNaturalHairColor(HairColorCode[ChosenHairColor])
		CheckHair()
	elseif ChosenHairColor == 1
		SetNaturalHairColor(MCMValues.CustomHairColorValueInt)
		CheckHair()
	endif
endfunction
function UseComb() ; use comb (it is in fact a brush!) to revert hairstyle back to standard
	if (!EnableHairMakeover) && ( YPS04DibellaFollower.Getstage() != 520)
		debugNotification("Your hairstyle may not be changed.")
	else
		HairgrowthLock = true ; disable hair growth for a while
		if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStudy")
		endif		
		if PlayerSpecialHairtype == 1
			if YPS04DibellaFollower.Getstage() == 520
				PETicker.PlayYpsSound(11)
				Utility.Wait(3.0)
				debugNotification("You brush your hair very intensively...")
				PETicker.PlayYpsSound(11)
				Utility.Wait(3.0)
				PETicker.PlayYpsSound(11)
				Utility.Wait(3.0)
				PETicker.PlayYpsSound(11)
				debugNotification("Too bad, the current style sticks on your hair.")
			else
				debugNotification("You brush your beautifully permed hair.")
			endif
			PETicker.PlayYpsSound(11)
			PETicker.PlayYpsSound(11)
		elseif PlayerSpecialHairtype == 2
			debugNotification("You undo your braids and brush your hair.")
			PlayerSpecialHairtype = 0
			PETicker.PlayYpsSound(11)
			PETicker.PlayYpsSound(11)
			SetStandardHairstyle(CurrentHairlengthStage)
			CheckHair()
		elseif PlayerSpecialHairtype == 3
			debugNotification("You undo your ponytail and brush your hair.")
			PlayerSpecialHairtype = 0
			PETicker.PlayYpsSound(11)
			PETicker.PlayYpsSound(11)
			SetStandardHairstyle(CurrentHairlengthStage)
			CheckHair()
		elseif PlayerSpecialHairtype == 4
			if YPS04DibellaFollower.Getstage() == 520
				debugNotification("You try to brush your hair into a normal hairstyle...")
			else
				debugNotification("You brush your bob, and strike gently over your buzzed nape.")
			endif
			PETicker.PlayYpsSound(11)
			if YPS04DibellaFollower.Getstage() == 520
				debugNotification("... but your buzzed nape cut sits firmly on your head.")
			endif
			PETicker.PlayYpsSound(11)
		elseif (PlayerSpecialHairtype == 5) || (PlayerSpecialHairtype == 6)
			if YPS04DibellaFollower.Getstage() == 520
				debugNotification("You try to brush your hair into a normal hairstyle...")
			else
				debugNotification("You brush your mohawk and make sure the hair is fitting.")
			endif
			PETicker.PlayYpsSound(11)
			if YPS04DibellaFollower.Getstage() == 520
				debugNotification("... but your mohawk cut sits firmly on your head.")
			endif
			PETicker.PlayYpsSound(11)
		else
			debugNotification("You thoroughly brush your hair, reverting your hair back to its natural style.")
			PETicker.PlayYpsSound(11)
			PETicker.PlayYpsSound(11)
			SetStandardHairstyle(CurrentHairLengthStage)
			CheckHair()
		endif
		if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStop")
		endif		
		HairgrowthLock = false
	endif
	if YPS04DibellaFollower.Getstage() == 520
		YPS04DibellaFollower.SetObjectiveCompleted(520)
		YPS04DibellaFollower.SetObjectiveDisplayed(530)
		YPS04DibellaFollower.Setstage(530)
	endif
endfunction
function ForcePerm(int HairLength, string HairStyleName) ; will force a perm on the player, no matter what the current hairstyle or length is (includes changing hair length)
	HairgrowthLock = true
	CurrentHairstyleName = HairStyleName
	CurrentHairLength = HairStageLength[HairLength]
	if CurrentUndyedHairLength > CurrentHairLength ; hair got cut shorter than undyed hair length
		CurrentUndyedHairLength = CurrentHairLength
	endif
	PlayerCurrentCustomHairstyle = 0
	SetCurrentHairLengthStage(HairLength)
	PlayerSpecialHairtype = 1
	PlayerPermDate = Utility.GetCurrentGameTime()
	CheckHair()
	HairgrowthLock = false
endfunction
function ForceBuzzedNape(int HairLength, string HairStyleName) ; will force a buzzed nape on the player, no matter what the current hairstyle or length is (includes changing hair length)
	HairgrowthLock = true
	CurrentHairstyleName = HairStyleName
	CurrentHairLength = HairStageLength[HairLength]
	if CurrentUndyedHairLength > CurrentHairLength ; hair got cut shorter than undyed hair length
		CurrentUndyedHairLength = CurrentHairLength
	endif
	PlayerCurrentCustomHairstyle = 0
	SetCurrentHairLengthStage(HairLength)
	PlayerSpecialHairtype = 4
	CheckHair()
	HairgrowthLock = false
endfunction
function ForceBroadMohawk(int HairLength, string HairStyleName) ; will force a broad mohawk on the player, no matter what the current hairstyle or length is (includes changing hair length)
	HairgrowthLock = true
	CurrentHairstyleName = HairStyleName
	CurrentHairLength = HairStageLength[HairLength]
	if CurrentUndyedHairLength > CurrentHairLength ; hair got cut shorter than undyed hair length
		CurrentUndyedHairLength = CurrentHairLength
	endif
	PlayerCurrentCustomHairstyle = 0
	SetCurrentHairLengthStage(HairLength)
	PlayerSpecialHairtype = 5
	CheckHair()
	HairgrowthLock = false
endfunction
function ForceNarrowMohawk(int HairLength, string HairStyleName) ; will force a narrow mohawk on the player, no matter what the current hairstyle or length is (includes changing hair length)
	HairgrowthLock = true
	CurrentHairstyleName = HairStyleName
	CurrentHairLength = HairStageLength[HairLength]
	if CurrentUndyedHairLength > CurrentHairLength ; hair got cut shorter than undyed hair length
		CurrentUndyedHairLength = CurrentHairLength
	endif
	PlayerCurrentCustomHairstyle = 0
	SetCurrentHairLengthStage(HairLength)
	PlayerSpecialHairtype = 6
	CheckHair()
	HairgrowthLock = false
endfunction
function UsePermLotion() ; this is a debug item, not available in game, only via console
	if !EnableHairMakeover
		debugNotification("Your hairstyle may not be changed.")
	else
		HairgrowthLock = true
		float TimeDiff = MCMValues.MinHairPermDuration + PlayerPermDate - Utility.GetCurrentGameTime()
		if TimeDiff > 0.0	
			Debug.Messagebox("To protect your hair, you need to wait for another "+UtilScript.FormatTimeDiff(TimeDiff)+"before you can remove the perm or perm your hair again.")
		else
			if PlayerSpecialHairtype == 2
				debugNotification("You need to remove your braids before perming your hair.")
			elseif PlayerSpecialHairtype == 3
				debugNotification("You need to remove your ponytail before perming your hair.")
			elseif PlayerSpecialHairtype == 4
				debugNotification("You may not perm a buzzed nape haircut.")
			elseif PlayerSpecialHairtype >= 5
				debugNotification("You may not perm a mohawk haircut.")
			elseif PlayerSpecialHairtype == 0
				debugNotification("Now styling hair with perm lotion.")
				ChooseHairstyle(CurrentHairlengthStage, 1)
				if HairstyleChosen
					PETicker.PlayYpsSound(16,10.0,0.1)
					PlayerCurrentCustomHairstyle = CustomHairstyleChosen
					CurrentHairstyleName = ChosenHairstyleID
					PETicker.PlayYpsSound(18,10.0,0.1)
					CheckHair()
					PlayerSpecialHairtype = 1
					PlayerPermDate = Utility.GetCurrentGameTime()
				endif
			elseif PlayerSpecialHairtype == 1
					debugNotification("Now removing your hair perm.")
					PETicker.PlayYpsSound(16,10.0,0.1)
					SetStandardHairstyle(CurrentHairLengthStage)
					PlayerSpecialHairtype = 0
					PETicker.PlayYpsSound(18,10.0,0.1)
					CheckHair()
					PlayerPermDate = Utility.GetCurrentGameTime()
			endif
		endif
		HairgrowthLock = false
	endif
endfunction
function UseShampoo()
	if (!EnableHairMakeover) && ( YPS04DibellaFollower.Getstage() != 510)
		debugNotification("Your hairstyle may not be changed.")
	else
		HairgrowthLock = true
		Utility.Wait(0.1)
		if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStudy")
		endif
		int OldHairColorationColor = HairColorationColor ; as RGB value
		float OldUndyedHairLength = CurrentUndyedHairLength
;		string OldHairColorName = CurrentHairColorName
		if YPS04DibellaFollower.Getstage() == 510	
			PETicker.PlayYpsSound(16,10.0,0.1)
			Utility.Wait(3.0)
			Debug.Messagebox("You massage the shampoo into your hair.")

			SetHairColorationColor(0x00FFFFFF) ; show hair as white
			CurrentUndyedHairLength = 0.0

			PETicker.PlayYpsSound(16,10.0,0.1)
			Utility.Wait(3.0)
			Debug.Messagebox("You try hard to wash the color off your hair.")
			PETicker.PlayYpsSound(16,10.0,0.1)

			SetHairColorationColor(OldHairColorationColor)
			CurrentUndyedHairLength = OldUndyedHairLength
			CheckHair()

			Debug.Messagebox("...but to no avail. The coloration shines even stronger, and the hairstyle just persists.")
			PETicker.PlayYpsSound(18,10.0,0.1)
		elseif PlayerSpecialHairtype == 1
			PETicker.PlayYpsSound(16,10.0,0.1)
			Debug.Messagebox("You massage the shampoo into your hair.")

			SetHairColorationColor(0x00FFFFFF) ; show hair as white
			CurrentUndyedHairLength = 0.0
			CheckHair()

			Utility.Wait(3.0)
			Debug.Messagebox("You wash the shampoo off your hair. After you are done, your hair reverts back to its permed style.")
			PETicker.PlayYpsSound(18,10.0,0.1)

			SetHairColorationColor(OldHairColorationColor)
			CurrentUndyedHairLength = OldUndyedHairLength
			CheckHair()
	; switch briefly to standard style here? ........................................................................................
		elseif PlayerSpecialHairtype == 2
			debugNotification("You should remove your braids before styling your hair with shampoo.")
		elseif PlayerSpecialHairtype == 3
			debugNotification("You should remove your ponytail before styling your hair with shampoo.")
		elseif PlayerSpecialHairtype == 4
			PETicker.PlayYpsSound(16,10.0,0.1)
			Debug.Messagebox("You massage the shampoo into your hair.")
			Utility.Wait(3.0)

			SetHairColorationColor(0x00FFFFFF) ; show hair as white
			CurrentUndyedHairLength = 0.0
			CheckHair()

			Debug.Messagebox("You wash the shampoo off your hair and bring your buzzed nape haircut in shape again.")
			PETicker.PlayYpsSound(18,10.0,0.1)

			SetHairColorationColor(OldHairColorationColor)
			CurrentUndyedHairLength = OldUndyedHairLength
			CheckHair()
		elseif PlayerSpecialHairtype >= 5
			PETicker.PlayYpsSound(16,10.0,0.1)
			Debug.Messagebox("You massage the shampoo into your hair.")
			Utility.Wait(3.0)

			SetHairColorationColor(0x00FFFFFF) ; show hair as white
			CurrentUndyedHairLength = 0.0
			CheckHair()

			Debug.Messagebox("You wash the shampoo off your hair and bring your mohawk haircut in shape again.")
			PETicker.PlayYpsSound(18,10.0,0.1)

			SetHairColorationColor(OldHairColorationColor) 
			CurrentUndyedHairLength = OldUndyedHairLength
			CheckHair()
		else
			debugNotification("Now styling hair with shampoo.")
			ChooseHairstyle(CurrentHairlengthStage, 0)
			if HairstyleChosen
				PETicker.PlayYpsSound(16,10.0,0.1)
				Debug.Messagebox("You massage the shampoo into your hair.")
				Utility.Wait(3.0)

				SetHairColorationColor(0x00FFFFFF) ; show hair as white
				CurrentUndyedHairLength = 0.0
				CheckHair()

				Debug.Messagebox("... and rinse it off again. Your hair looks and smells pleasantly.")
				PETicker.PlayYpsSound(18,10.0,0.1)
				PlayerCurrentCustomHairstyle = CustomHairstyleChosen
				CurrentHairstyleName = ChosenHairstyleID

				SetHairColorationColor(OldHairColorationColor)
				CurrentUndyedHairLength = OldUndyedHairLength
				CheckHair()
	; add here and above: removal of shampoo item ??............................................................................................
			endif
		endif
		debugNotification("You dry your hair with the soulgem hair dryer...")
		PETicker.PlayYpsSound(4,10.0)
		if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStop")
		endif		
		HairgrowthLock = false
		if YPS04DibellaFollower.Getstage() == 510
			YPS04DibellaFollower.SetObjectiveCompleted(510)
			YPS04DibellaFollower.SetObjectiveDisplayed(520)
			YPS04DibellaFollower.Setstage(520)
		endif
	endif
endfunction
int property MinimumLengthStageForPonytail = 7 autoreadonly
function UseElasticHairband() ; for braids and ponytails
	if !EnableHairMakeover
		debugNotification("Your hairstyle may not be changed.")
	else
		HairgrowthLock = true
		Utility.Wait(0.1)
		if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStudy")
		endif		
		if PlayerSpecialHairtype == 2
			debugNotification("You undo your braids.")
			PlayerSpecialHairtype = 0
			PETicker.PlayYpsSound(11)
			SetStandardHairstyle(CurrentHairlengthStage)
			CheckHair()
		elseif PlayerSpecialHairtype == 3
			debugNotification("You remove your ponytail.")
			PlayerSpecialHairtype = 0
			PETicker.PlayYpsSound(11)
			SetStandardHairstyle(CurrentHairlengthStage)
			CheckHair()
		elseif PlayerSpecialHairtype == 1
			debugNotification("You may not braid your permed hair.")
		elseif PlayerSpecialHairtype == 4
			debugNotification("You have a buzzed nape and may not braid your hair.")
		elseif (PlayerSpecialHairtype == 5) || (PlayerSpecialHairtype == 6)
			debugNotification("You have a mohawk and may not braid your hair.")
		else
			if CurrentHairlengthStage < MinimumLengthStageForPonytail
				Debug.Messagebox("You need to grow your hair at least to length "+HairStageName[MinimumLengthStageForPonytail]+" to apply a braid or a ponytail.")
			else
				int StandardStylingChoice = ypsWantBraidPonytailMsg.show() ; 0=none 1=braid 2=ponytail
				if StandardStylingChoice > 0
					int ChoseHairStyleRetry = 1
					while ChoseHairStyleRetry == 1
						ChooseHairstyle(CurrentHairLengthStage,StandardStylingChoice+1)
						if HairStyleChosen && (ChosenHairstyleID != "")
							RequestedHairStyleID = ChosenHairstyleID
							RequestedCustomHairStyle = CustomHairstyleChosen
							ChoseHairStyleRetry = 0
						else
							ChoseHairStyleRetry = ypsNoHairstyleChosenMsg.show() ; 0 = cancel, 1 = retry
						endif
					endwhile
					if HairStyleChosen && (ChosenHairstyleID != "")
						debugNotification("You carefull comb and style your beautiful hair.")
						CurrentHairstyleName = RequestedHairStyleID
						PlayerCurrentCustomHairstyle = RequestedCustomHairStyle
						if StandardStylingChoice == 1 ; braided
							debugNotification("You style your hair into a beautiful braid.")
							PETicker.PlayYpsSound(11)
							PlayerSpecialHairtype = 2
						elseif StandardStylingChoice == 2 ; ponytail
							debugNotification("You style your hair into a beautiful ponytail.")
							PETicker.PlayYpsSound(11)
							PlayerSpecialHairtype = 3
						else
							debug.trace("[YPS] Bug: invalid special style request.")
						endif
						CheckHair()
					endif
				endif
			endif
		endif		
		if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStop")
		endif		
		HairgrowthLock = false
	endif
endfunction
function UseHairColorBottle() ; this is a debug item, not available in game, only via console
	if !EnableHairMakeover
		debugNotification("Your hairstyle may not be changed.")
	else
		HairgrowthLock = true
		float TimeDiff = MCMValues.MinHairColorDuration + LastColorationTime - Utility.GetCurrentGameTime()
		if TimeDiff > 0.0	
			Debug.Messagebox("To protect your hair, you need to wait for another "+UtilScript.FormatTimeDiff(TimeDiff)+"before you can color your hair again.")
		else
			DoPlayerHairColoringStandard(PickHairColor())
		endif
		HairgrowthLock = false
	endif
endfunction

function UseHairMakeoverOrb() ; this is a debug item
	CompleteHairMakeoverProcess(PlayerActor)
endfunction

function UseHairScissors() ; this is a debug item, not available in game, only via console
	if !EnableHairMakeover
		debugNotification("Your hairstyle may not be changed.")
	else
		HairgrowthLock = true
		int NewHairLength = PickHairLength()
		if NewHairLength > 0
			DoPlayerHairCut(NewHairLength)
		endif
		HairgrowthLock = false
	endif
endfunction

Function HaircutProcess(string Actorname,int NewHairLength, bool InDibellaQuest = false)
; this will be called for players wanting a "hair cut" in the dialogue with the hairdresser
; will result in a "normal" haircut (no special hairtype), unless custom style is configured as default and special
	if PlayerSpecialHairtype == 2
		debugNotification(Actorname+" removes your braids and combs your hair.")
		PlayerSpecialHairtype = 0
		PETicker.PlayYpsSound(11)
		SetStandardHairstyle(CurrentHairlengthStage)
		CheckHair()
	elseif PlayerSpecialHairtype == 3
		debugNotification(Actorname+" removes your ponytail and combs your hair.")
		PlayerSpecialHairtype = 0
		PETicker.PlayYpsSound(11)
		SetStandardHairstyle(CurrentHairlengthStage)
		CheckHair()
	endif
	bool OneStepDone = false
	if (NewHairLength >= 7) 
		if CurrentHairlengthStage-NewHairLength >= 6
			Debug.Messagebox(Actorname+" combs your long hair for a last time.\nYou almost want to cry, but then just take a deep breath as "+Actorname+" begins cutting your hair.")
			PETicker.PlayYpsSound(11)
		elseif CurrentHairlengthStage-NewHairLength >= 3
			Debug.Messagebox(Actorname+" combs your long hair for a last time.\nYou take a deep breath as "+Actorname+" begins cutting your hair.")
			PETicker.PlayYpsSound(11)
		endif
		Debug.Messagebox(Actorname+" begins to cut your hair to "+HairStageName[NewHairLength]+".")
		DoPlayerHairCut(NewHairLength,false,"",Actorname)
		OneStepDone = true
	endif
	if (NewHairLength <= 6) && (PlayerSpecialHairtype < 4) && ((NewHairLength == 6) || !MCMValues.QuickHaircut); will first trim to chin length, but not if you have a nape buzz (length 6 or 7) or mohawk
		if !MCMValues.QuickHaircut
			if CurrentHairlengthStage >= 11 ; mid back
				if InDibellaQuest
					Debug.Messagebox(Actorname+" combs your long hair for a last time.\nYou feel relieved as "+Actorname+" begins cutting your beautiful hair.")
				else
					Debug.Messagebox(Actorname+" combs your long hair for a last time.\nIt is very hard to suppress your tears as "+Actorname+" begins cutting your beautiful hair.")
					PETicker.PlayYpsSound(8)
					PETicker.PlayYpsSound(9)
				endif
				PETicker.PlayYpsSound(15,7.0) ; scissors sound
				PETicker.PlayYpsSound(11)
				if InDibellaQuest
					debugNotification("You feel relieved as strands of your hair are falling to the ground.")
				else
					debugNotification("You feel sad as strands of your beautiful hair are falling to the ground.")
					PETicker.PlayYpsSound(8)
					PETicker.PlayYpsSound(9)
				endif
				PETicker.PlayYpsSound(15,7.0) ; scissors sound
				PETicker.PlayYpsSound(11)
				debugNotification("Byebye long hair...")
				if !InDibellaQuest
					PETicker.PlayYpsSound(8)
					PETicker.PlayYpsSound(9)
				endif
				PETicker.PlayYpsSound(15,7.0) ; scissors sound
				PETicker.PlayYpsSound(11)
				if CurrentHairlengthStage >= 12 ; waist length
					if InDibellaQuest
						debugNotification("You feel relieved as more strands are falling to the ground.")
					else
						debugNotification("What am I doing? Still more hair strands are falling to the ground.")
						PETicker.PlayYpsSound(8)
						PETicker.PlayYpsSound(9)
					endif
					PETicker.PlayYpsSound(15,7.0) ; scissors sound
					PETicker.PlayYpsSound(11)
				endif
				if CurrentHairlengthStage >= 13 ; hip length
					if InDibellaQuest
						debugNotification("It's relieving... still more strands are falling to the ground.")
					else
						debugNotification("It's so depressing... more hair strands are falling to the ground.")
						PETicker.PlayYpsSound(8)
						PETicker.PlayYpsSound(9)
					endif
					PETicker.PlayYpsSound(15,7.0) ; scissors sound
					PETicker.PlayYpsSound(11)
				endif
			elseif CurrentHairlengthStage >= 10 ; bra strap
				Debug.Messagebox(Actorname+" combs your long hair for a last time.\nYou almost want to cry, but then just take a deep breath as "+Actorname+" begins cutting your hair.")
				PETicker.PlayYpsSound(8)
				PETicker.PlayYpsSound(15,7.0) ; scissors sound
				PETicker.PlayYpsSound(11)
				debugNotification("You feel sad as strands of your beautiful hair are falling to the ground.")
				PETicker.PlayYpsSound(8)
				PETicker.PlayYpsSound(15,7.0) ; scissors sound
				PETicker.PlayYpsSound(11)
			elseif CurrentHairlengthStage >= 9 ; armpit
				Debug.Messagebox(Actorname+" combs your long hair for a last time.\nYou take a deep breath as "+Actorname+" begins cutting your hair.")
				PETicker.PlayYpsSound(8)
				PETicker.PlayYpsSound(15,7.0) ; scissors sound
				PETicker.PlayYpsSound(11)
			elseif CurrentHairlengthStage >= 8 ; shoulder
				Debug.Messagebox(Actorname+" combs your shoulder long hair for a last time and begins cutting your hair.")
				PETicker.PlayYpsSound(8)
				PETicker.PlayYpsSound(15,7.0) ; scissors sound
				PETicker.PlayYpsSound(11)
			endif
		endif
		if CurrentHairlengthStage >= 6
			debugNotification(Actorname+" begins to trim your hair to chin length.")
			DoPlayerHairCut(6,false,"",Actorname)
			OneStepDone = true
		endif
	endif
	if (CurrentHairlengthStage >= 5) && (NewHairLength <= 5) && (PlayerSpecialHairtype < 5) && ((NewHairLength == 5) || !MCMValues.QuickHaircut) ; not for mohawks
		if OneStepDone
			debugNotification(Actorname+" continues to trim your hair to ear length.")
		else
			debugNotification(Actorname+" begins to trim your hair to ear length.")
		endif
		DoPlayerHairCut(5,false,"",Actorname)
		OneStepDone = true
	endif
	if (CurrentHairlengthStage >= 4) && (NewHairLength <= 4) && (PlayerSpecialHairtype < 5) && ((NewHairLength == 4) || !MCMValues.QuickHaircut) ; not for mohawks
		if OneStepDone
			debugNotification(Actorname+" continues to crop your hair.")
		else
			debugNotification(Actorname+" begins to crop your hair.")
		endif
		DoPlayerHairCut(4,false,"",Actorname)
	endif
	if (CurrentHairlengthStage >= 3) && (NewHairLength <= 3) && (PlayerSpecialHairtype < 5) && ((NewHairLength == 3) || !MCMValues.QuickHaircut) ; not for mohawks
		debugNotification(Actorname+" takes the soulgem razor and crops your hair to long stubbles.")
		DoPlayerHairCut(3,false,"",Actorname)		
	endif
	if (CurrentHairlengthStage >= 2) && (NewHairLength <= 2)
		debugNotification(Actorname+" takes the soulgem razor and crops your hair to short stubbles.")
		DoPlayerHairCut(2,false,"",Actorname)
	endif
	if NewHairLength == 1
		debugNotification(Actorname+" begins to apply shaving cream on your head.")
		PETicker.PlayYpsSound(2)
		debugNotification(Actorname+" then takes the shaving knife and shaves your head smooth.")
		if !MCMValues.QuickHaircut
			PETicker.PlayYpsSound(11)
			PETicker.PlayYpsSound(11)
			PETicker.PlayYpsSound(11)
		endif
		DoPlayerHairCut(1,false,"",Actorname)
		debugNotification(Actorname+" gently rubs away the remaining shaving cream. All of your head hair is now gone.")
		PETicker.PlayYpsSound(3)
	endif
endfunction

bool RequestedMakeover = false ; anything requested at all
int RequestedNewHairLength = 0
int RequestedSpecialHairType = 0
bool RequestedDefaultHairstyle = true
bool RequestedHaircut = false
int RequestedHairColor = 0
bool RequestedHairDye = false
bool RequestedHairdyeRefresh = false
bool RequestedPermRefresh = false
bool RequestedPermRemove = false
string RequestedHairStyleID
int RequestedCustomHairStyle = 0
bool RequestedStandardHairStyling = false ; after the cut, do a standard hair styling (type 0)
float HairMakeoverPrice = 0.0
; ...

function ResetHairMakeOverVariables()
	RequestedMakeover = false
	RequestedNewHairLength = 0
	RequestedSpecialHairType = 0
	RequestedDefaultHairstyle = true ; want the preset default hairstyle for a certian length
	RequestedHaircut = false
	RequestedHairColor = 0
	RequestedHairDye = false
	RequestedHairdyeRefresh = false
	RequestedPermRefresh = false
	RequestedPermRemove = false
	RequestedHairStyleID = ""
	RequestedCustomHairStyle = 0
	RequestedStandardHairStyling = false
	HairMakeoverPrice = 0.0
endfunction

; Dialogue will be like this:
; Preparation stage: reset all variables
; Dialogue choice 1: I want a complete hair makeover session
; Messagebox: Do you want a haircut? Yes. 
; Normal cut / Buzzed nape / Mohawk ; get choice menu (depending on current length, you will get different choice selection!)
; Do you want a perm? (only if length matches!)
; Do you want a hair dye? (only if not bald)
; (only if normal cut): Do you want your hair braided, ponytail, combed?
; Ok, let's begin then.
; Dialogue choice 2: I want a haircut only
; Dialogue choice 3: I want a perm only
; Dialogue choice 4: I want a dye only

message property ypsWantHaircutMsg auto
message property ypsChoseHairlengthAgainMsg auto ; no valid hair length chosen. Try again? cancel / yes
message property ypsRedoBuzzedNapeMsg auto ; no, yes
message property ypsTrimBuzzedNapeMsg auto ; Your buzzed nape hair style is currently at neck length. Trim it to chin or ear length?
message property ypsTrimBuzzedNapeChinMsg auto ; Your buzzed nape hair style is currently at chin length. Trim it to ear length?
message property ypsStyleMohawkBroadNarrowMsg auto ; You currently have a broad mohawk. Keep / Restyle / Shave down to narrow Mohawk
message property ypsStyleMohawkNarrowMsg auto ; You currently have a narrow mohawk. Keep / Restyle
message property ypsNormalMohawkBuzzedMsg auto
message property ypsNormalMohawkMsg auto
message property ypsBroadNarrowMohawkMsg auto
message property ypsWantPermMsg auto
message property ypsWantHairDyeMsg auto
message property ypsWantHairDyeRefreshMsg auto
message property ypsWantCombedBraidPonytailMsg auto
message property ypsWantBraidPonytailMsg auto
message property ypsNoHairstyleChosenMsg auto ; No Hair style chosen. Cancel / Retry
message property ypsMakeoverConfirmMsg auto ; ProceedWithThisMakeover? CancelYesModify
message property ypsAddRemovePerm auto ; cancel / new perm / refresh perm / remove perm

function ShowHairStatus()
	float TimeToWaitForPerm = MCMValues.MinHairPermDuration + PlayerPermDate - Utility.GetCurrentGameTime()
	if TimeToWaitForPerm < 0.0
		TimeToWaitForPerm = 0.0
	endif
	float TimeToWaitForColor = MCMValues.MinHairColorDuration + LastColorationTime - Utility.GetCurrentGameTime()
	if TimeToWaitForColor < 0.0
		TimeToWaitForColor = 0.0
	endif
	string HairColorNameString = "(none)"
	if CurrentUndyedHairlength < CurrentHairLength
		HairColorNameString = CurrentHairColorName
	endif
	string StatusString = "Your hair status:\n\nCurrent Hair Length Stage: "+CurrentHairlengthStage+" ("+HairStageName[CurrentHairlengthStage]+")\nCurrent Hair Length: "+CurrentHairLength+" cm\n(undyed: "+CurrentUndyedHairlength+" cm)"
	if CurrentHairlengthStage < 21
		StatusString += "\nStill needed for next stage: "+(HairStageLength[CurrentHairlengthStage+1] - CurrentHairLength)+" cm"
		float StillNeededForNextStage = (HairStageLength[CurrentHairlengthStage+1] - CurrentHairLength) / ( HairGrowthPerDay * MCMValues.HairGrowthMultiplicator * (1+ (MCMValues.FastHairGrowth as int)*9) )
		StatusString += "\n(or "+((StillNeededForNextStage+1) as int)+" days)"
	else
		StatusString += "Maximum hair stage reached."
	endif
	StatusString += "\nCurrent Hairstyle: "+CurrentHairstyleName+"\nCurrent Hairstyle Type: "+SpecialHairtypeName[PlayerSpecialHairtype]
	StatusString += "\nCurrent Hair Dye Color: "+HairColorNameString+"\nTime to wait until next perm: "+UtilScript.FormatTimeDiff(TimeToWaitForPerm)+"\nTime to wait until next hair dye: "+UtilScript.FormatTimeDiff(TimeToWaitForColor)
	Debug.Messagebox(StatusString)
endfunction

function UseMirror()
	Utility.Wait(0.1)
	debugNotification("You look into your mirror...")
	ShowHairStatus()
	Utility.Wait(0.1)
	PETicker.ShowPiercingStatus()
	Utility.Wait(0.1)
	PETicker.ShowMakeupStatus()
	Utility.Wait(0.1)
	PETicker.ShowBodyStatus() 
endfunction


function CompleteHairMakeoverProcess(Actor akActor, bool DontNeedToSit = false) ; this will be called for players wanting a "complete makeover" in the dialogue with the hairdresser
  if !EnableHairMakeover
	debugNotification("Your hairstyle may not be changed.")
  elseif (PlayerActor.GetWornForm(kSlotMask31) != NONE)
	string HeadItemName = PlayerActor.GetWornForm(kSlotMask31).Getname()
	if HeadItemName == ""
		HeadItemName = "head item"
	endif
	debugNotification("You need to remove your "+HeadItemName+" first.")
  elseif !HairgrowthLock
	HairgrowthLock = true
	Utility.Wait(0.05)
	int ReallyProceed = 2
	while ReallyProceed == 2 ; 0 = cancel, 1 = proceed, 2 = modify choice
		ResetHairMakeOverVariables()
		debugNotification("Current Hair Length Stage "+CurrentHairlengthStage+" ("+HairStageName[CurrentHairlengthStage]+")")
		int WantHaircut = ypsWantHaircutMsg.show()

		if WantHaircut
			float TimeDiff = MCMValues.MinHairPermDuration + PlayerPermDate - Utility.GetCurrentGameTime()
			if MCMValues.MayNotCutPerm && (PlayerSpecialHairtype == 1) && (TimeDiff > 0.0)
				Debug.Messagebox(akActor.GetActorBase().Getname()+" refuses to cut your beautifully permed hair; you should wait for another "+UtilScript.FormatTimeDiff(TimeDiff))
			else
				int QueryingHairLength = 1
				while QueryingHairLength
					int NewHairLength = PickHairLength()
					if (NewHairLength > CurrentHairlengthStage)
						Debug.Messagebox("Currently your hair is only "+HairStageName[CurrentHairlengthStage]+", and cannot be cut to "+HairStageName[NewHairLength])
					elseif (PlayerSpecialHairtype == 4) && (NewHairLength > 4) ; buzzed napes: only cropped length (length 4) or shorter allowed
						Debug.Messagebox("Your buzzed nape hairstyle may only be cut to "+HairStageName[4]+" or shorter.")
						RequestedNewHairLength = CurrentHairLengthStage
					elseif (PlayerSpecialHairtype >= 5) && (NewHairLength > 1) ; mohawk
						Debug.Messagebox("Your mohawk may not be cut to "+HairStageName[NewHairLength]+"; to remove the mohawk, you need to get a head shave.\nAlternatively, you may get your mohawk redone (cancel the hair length choice, and a new window will pop up soon).")
						RequestedNewHairLength = CurrentHairLengthStage
					else
						if (NewHairLength <= 8) && ((CurrentHairLengthStage - NewHairLength) >= 6) ; warning message for dramatic hairlength difference
							Debug.Messagebox("That will be a dramatic change. Are you really sure???")
						elseif (NewHairLength <= 8) && ((CurrentHairLengthStage - NewHairLength) >= 5) ; warning message for dramatic hairlength difference
							Debug.Messagebox("That will be quite a dramatic change. Are you sure?")
						elseif (NewHairLength <= 8) && ((CurrentHairLengthStage - NewHairLength) >= 4) ; warning message for dramatic hairlength difference
							Debug.Messagebox("That will be quite a dramatic change. I guess you know what you want?")
						elseif (NewHairLength <= 8) && ((CurrentHairLengthStage - NewHairLength) >= 3) ; warning message for dramatic hairlength difference
							Debug.Messagebox("That will be quite a dramatic change, but I shall do what you want.")
						endif
						if (NewHairLength == 2) || (NewHairLength == 3) ; warning message for cropped hair
							Debug.Messagebox("You have chosen cropped hair. Most girls prefer longer hairstyles, but if you really want.. it's your choice to make, but don't complain later on.")
						elseif (NewHairLength == 1) ; warning message for bald hair
							Debug.Messagebox("You really want a head shave? Are you absolutely sure? Well, what can I say... *sigh*")
						endif
						RequestedNewHairLength = NewHairLength
						RequestedMakeover = (RequestedNewHairLength > 0)
						RequestedHaircut = true
					endif
					if RequestedNewHairLength
						QueryingHairLength = 0
					else
						QueryingHairLength = ypsChoseHairlengthAgainmsg.show() ; no valid hairlength chosen. Try again? cancel / yes
					endif
				endwhile
			endif
		else
			RequestedNewHairLength = CurrentHairLengthStage
		endif
		if (PlayerSpecialHairtype == 4) && (RequestedNewHairLength == CurrentHairLengthStage) ; restyle buzzed nape, but only if no shorter haircut requested
			if ypsRedoBuzzedNapeMsg.show() ; no/yes
				RequestedSpecialHairType = 4
				RequestedMakeover = true
				if CurrentHairlengthStage == 7
					if ypsTrimBuzzedNapeMsg.show() == 1 ; Your buzzed nape hair style is currently at neck length. Trim it to ear (1) or chin (2) length? or not (0)
						RequestedNewHairLength = 5
					elseif ypsTrimBuzzedNapeMsg.show() == 2 
						RequestedNewHairLength = 6
					endif
				endif
				if CurrentHairlengthStage == 6
					if ypsTrimBuzzedNapeChinMsg.show()  ; Your buzzed nape hair style is currently at chin length. Trim it to ear length?
						RequestedNewHairLength = 5
					endif
				endif
			endif
		elseif (PlayerSpecialHairtype == 5) && (RequestedNewHairLength == CurrentHairLengthStage) ; restyle broad mohawk, but only if no head shave requested
			int MohawkChoice = ypsStyleMohawkBroadNarrowMsg.show() ; You currently have a broad mohawk. Keep / Restyle / Shave down to narrow Mohawk
			if MohawkChoice
				RequestedSpecialHairType = 5 + MohawkChoice - 1
				RequestedMakeover = true
				int QueryingHairLength = 1
				int NewHairLength
				while QueryingHairLength
					NewHairLength = PickHairLength()
					if (NewHairLength > CurrentHairlengthStage)
						Debug.Messagebox("Currently your mohawk is only "+HairStageName[CurrentHairlengthStage]+", and cannot be cut to "+HairStageName[NewHairLength])
					else
						QueryingHairLength = 0
					endif
				endwhile
				RequestedNewHairLength = NewHairLength
			endif	
		elseif (PlayerSpecialHairtype == 6) && (RequestedNewHairLength == CurrentHairLengthStage) ; restyle narrow mohawk, but only if no head shave requested
			int MohawkChoice = ypsStyleMohawkNarrowMsg.show() ; You currently have a narrow mohawk. Keep / Restyle
			if MohawkChoice
				RequestedSpecialHairType = 6
				RequestedMakeover = true
				int QueryingHairLength = 1
				int NewHairLength
				while QueryingHairLength
					NewHairLength = PickHairLength()
					if (NewHairLength > CurrentHairlengthStage)
						Debug.Messagebox("Currently your mohawk is only "+HairStageName[CurrentHairlengthStage]+", and cannot be cut to "+HairStageName[NewHairLength])
					else
						QueryingHairLength = 0
					endif
				endwhile
				RequestedNewHairLength = NewHairLength
			endif	
		elseif (PlayerSpecialHairtype == 0) || (PlayerSpecialHairtype == 2) || (PlayerSpecialHairtype == 3)
			if (RequestedNewHairLength >= 5) && (RequestedNewHairLength <= 7) 
				RequestedSpecialHairType = ypsNormalMohawkBuzzedMsg.show()
				if RequestedSpecialHairType == 1
					RequestedMakeover = true
					RequestedSpecialHairType = 4 ; buzzed nape
				elseif RequestedSpecialHairType == 2
					RequestedMakeover = true
					RequestedSpecialHairType = 5 + ypsBroadNarrowMohawkMsg.show() ; broad or narrow mohawk
					if !RequestedHaircut ; ask for hair length again, if no hair length already chosen
						int QueryingHairLength = 1
						int NewHairLength
						while QueryingHairLength
							NewHairLength = PickHairLength()
							if (NewHairLength > CurrentHairlengthStage)
								Debug.Messagebox("Currently your hair is only "+HairStageName[CurrentHairlengthStage]+", and cannot be cut to "+HairStageName[NewHairLength])
							else
								QueryingHairLength = 0
							endif
						endwhile
						RequestedNewHairLength = NewHairLength
					endif
				endif
			elseif (RequestedNewHairLength >= 4) && (RequestedNewHairLength <= 12) ; mohawk range
				RequestedSpecialHairType = ypsNormalMohawkMsg.show()
				if RequestedSpecialHairType == 1
					RequestedSpecialHairType = 5 + ypsBroadNarrowMohawkMsg.show() ; mohawk
					RequestedMakeover = true
					int QueryingHairLength = 1
					int NewHairLength
					while QueryingHairLength
						NewHairLength = PickHairLength()
						if (NewHairLength > CurrentHairlengthStage)
							Debug.Messagebox("Currently your hair is only "+HairStageName[CurrentHairlengthStage]+", and cannot be cut to "+HairStageName[NewHairLength])
						else
							QueryingHairLength = 0
						endif
					endwhile
					RequestedNewHairLength = NewHairLength
				endif
			endif
		endif
		if (RequestedNewHairLength >= 5) && (RequestedSpecialHairType == 0) && (PlayerSpecialHairtype <= 3) ; perm
			float TimeDiff = MCMValues.MinHairPermDuration + PlayerPermDate - Utility.GetCurrentGameTime()
			if TimeDiff > 0.0
				if !WantHaircut && (PlayerSpecialHairtype == 1) ; if haircut was already wanted, this message would appear double
					Debug.Messagebox("To protect your hair, you need to wait another "+UtilScript.FormatTimeDiff(TimeDiff)+"before getting a new perm.")
				endif
			elseif (PlayerSpecialHairtype == 1) && (RequestedNewHairLength == CurrentHairLengthStage)
				int PermRedo = ypsAddRemovePerm.show() ; cancel / new perm / refresh perm / remove perm
				if PermRedo == 1
					RequestedSpecialHairType = 1
					RequestedMakeover = true
				elseif PermRedo == 2
					RequestedPermRefresh = true
					RequestedMakeover = true
					RequestedSpecialHairType = 1
				elseif PermRedo == 3
					RequestedPermRemove = true
					RequestedMakeover = true
					RequestedSpecialHairType = 0
				endif
			else
				RequestedSpecialHairType = ypsWantPermMsg.show()
				RequestedMakeover = RequestedMakeover || RequestedSpecialHairType
			endif
		endif
		if (RequestedNewHairLength >= 2) && (RequestedSpecialHairType == 0) && (PlayerSpecialHairtype <= 3) && (PlayerSpecialHairtype != 1)
			int StandardStylingChoice = ypsWantCombedBraidPonytailMsg.show()
			if StandardStylingChoice == 1
				RequestedStandardHairStyling = true
				RequestedMakeover = true
			elseif StandardStylingChoice == 2
				RequestedSpecialHairType = 2
				RequestedStandardHairStyling = true
				RequestedMakeover = true
			elseif StandardStylingChoice == 3
				RequestedSpecialHairType = 3
				RequestedStandardHairStyling = true
				RequestedMakeover = true
			endif
		endif
		if RequestedNewHairLength >= 2 ; dye, no need to color bald hair
			bool HairRedyePossible = false
			if MCMValues.HairDyeGrowsOut
				HairRedyePossible = (CurrentUndyedHairLength > 0.5) && (CurrentUndyedHairLength < CurrentHairLength) ; more than 0.5cm hair undyed
			else 
				float FadeTime = Utility.GetCurrentGameTime() - LastColorationTime - MCMValues.ColorationDuration ; how many days into fade time?
				HairRedyePossible = (FadeTime >= 0) && (FadeTime < MCMValues.ColorationFadeInterval)
			endif
			if HairRedyePossible
				RequestedHairdyeRefresh = ypsWantHairDyeRefreshMsg.show()
				RequestedMakeover = RequestedMakeover || RequestedHairdyeRefresh
			endif
			if !RequestedHairdyeRefresh
				RequestedHairDye = ypsWantHairDyeMsg.show()
				if RequestedHairDye
					float TimeDiff = MCMValues.MinHairColorDuration + LastColorationTime - Utility.GetCurrentGameTime()
					if TimeDiff > 0.0	
						Debug.Messagebox("To protect your hair, you need to wait for another "+UtilScript.FormatTimeDiff(TimeDiff)+"before you can color your hair again.")
						RequestedHairDye = 0
					else


						RequestedHairColor = PickHairColor()
						RequestedHairDye = (RequestedHairColor > 0)
						RequestedMakeover = RequestedMakeover || RequestedHairDye
					endif
				endif
			endif
		endif
		RequestedDefaultHairstyle = (RequestedSpecialHairType == 0) && !RequestedStandardHairStyling ; no special hair, and no styling: results in default hair for the length
		if !RequestedDefaultHairstyle && !RequestedPermRefresh; need to choose a hairstyle (no standard / current hairstyle)
			int ChoseHairStyleRetry = 1
			while ChoseHairStyleRetry == 1
				ChooseHairstyle(RequestedNewHairLength,RequestedSpecialHairType)
				if HairStyleChosen && (ChosenHairstyleID != "")
					RequestedHairStyleID = ChosenHairstyleID
					RequestedCustomHairStyle = CustomHairstyleChosen
					ChoseHairStyleRetry = 0
				else
					ChoseHairStyleRetry = ypsNoHairstyleChosenMsg.show() ; 0 = cancel, 1 = retry
				endif
			endwhile
		endif
		if RequestedMakeover && ((RequestedHairStyleID != "") || RequestedDefaultHairstyle || RequestedPermRefresh)
			string MakeoverChoice = ""
			if RequestedNewHairLength > 0
				MakeoverChoice += "Haircut: "+HairStageName[RequestedNewHairLength]+"\n"
			endif
			if RequestedDefaultHairstyle
				MakeoverChoice += "Hairstyle choice: default ("+HairStageName[RequestedNewHairLength]+")\n"
			elseif RequestedPermRefresh
				MakeoverChoice += "Hairstyle choice: "+CurrentHairstyleName+"\n"
			else
				MakeoverChoice += "Hairstyle choice: "+RequestedHairStyleID+"\n"
			endif
			if RequestedHairDye
				MakeoverChoice += "Hair coloration: "+HairColorName[RequestedHairColor]+"\n"
			endif
			MakeoverChoice += "Hairstyle type: "+SpecialHairtypeName[RequestedSpecialHairType]
			if RequestedStandardHairStyling
				MakeoverChoice += "\nAdditional request: Standard hair styling."
			endif

			HairMakeoverPrice = MCMValues.HairCutPrice * PlayerActor.GetLevel()
			if RequestedHairdyeRefresh
				HairMakeoverPrice += MCMValues.HairColorPrice * CurrentUndyedHairLength * 0.5 * PlayerActor.GetLevel() ; redye discount
			elseif RequestedHairDye
				HairMakeoverPrice += MCMValues.HairColorPrice * RequestedNewHairLength * PlayerActor.GetLevel()
			endif
			if RequestedSpecialHairType == 1

				HairMakeoverPrice += MCMValues.HairPermPrice * RequestedNewHairLength * PlayerActor.GetLevel()
			endif
			MakeoverChoice += "\nPrice for the makeover: " + (HairMakeoverPrice as int) + " gold"

			Debug.Messagebox("Your choice:\n"+MakeoverChoice)
			ReallyProceed = ypsMakeoverConfirmMsg.show() ; cancel/yes/modify
		else
			ReallyProceed = 0
		endif
	endwhile ; repeat until ReallyProceed <= 1
	if ReallyProceed == 1
		DoMakeoverSession(akActor, DontNeedToSit)
	endif
	HairgrowthLock = false
  endif
endfunction

function DoMakeoverSession(Actor akActor, bool DontNeedToSit = false, bool InDibellaQuest = false) ; Actor will do makeover session on player according to "requested"-variables; will not check whether the choices are valid!
    if (RequestedHairStyleID == "") && !RequestedDefaultHairstyle && !RequestedPermRefresh
		Debug.Messagebox("No valid hair style selected.\n\nPlease try again from the beginning.")
    else
	bool PlayerSitState = DontNeedToSit ; if there is no need to sit, playersitstate counts as true immediately
	int SitRetryCount = 6
	while !PlayerSitState && (SitRetryCount > 0)
		SitRetryCount -= 1
		if PlayerActor.GetSitState() != 3
			debugNotification("Please find a place to sit down for your hair makeover.")
			Utility.Wait(4.5)
		else
			PlayerSitState = true
		endif
	endwhile
	if !PlayerSitState
		Debug.MessageBox("You need to sit and calm down before "+akActor.GetActorBase().Getname()+" can help you. Please try again.")
	else
		Game.DisablePlayerControls()
		string Actorname = akActor.GetActorBase().Getname()
; makeover process: first open braids/ponytails, then cut, then perm/buzz/mohawk, then color, then standard styling
		if !MCMValues.QuickHaircut
			if PlayerSpecialHairtype == 2
				if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
					Debug.SendAnimationEvent(akActor,"idlelockpick")
				endif		
				debugNotification(Actorname+" undoes your braids and combs your hair.")
				PlayerSpecialHairtype = 0
				PETicker.PlayYpsSound(11)
				SetStandardHairstyle(CurrentHairlengthStage)
				CheckHair()
			elseif PlayerSpecialHairtype == 3
				if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
					Debug.SendAnimationEvent(akActor,"idlelockpick")
				endif		
				debugNotification(Actorname+" undoes your ponytail and combs your hair.")
				PlayerSpecialHairtype = 0
				PETicker.PlayYpsSound(11)
				SetStandardHairstyle(CurrentHairlengthStage)
				CheckHair()
			endif
		endif
		Game.DisablePlayerControls()
		if RequestedSpecialHairType < 4 ; (buzzed haircut and mohawks are done below)
			if (RequestedNewHairLength >= 1) && RequestedHaircut
				if MCMValues.ShowAnimations && !MCMValues.QuickHaircut && PETicker.ValidatePlayer()
					Debug.SendAnimationEvent(akActor,"idlelockpick")
				endif		
				HaircutProcess(Actorname,RequestedNewHairLength,InDibellaQuest)
;			elseif RequestedStandardHairStyling || (RequestedSpecialHairType > 0) ; trim your hair to the same length
;				if MCMValues.ShowAnimations && !MCMValues.QuickHaircut && PETicker.ValidatePlayer()
;					Debug.SendAnimationEvent(akActor,"idlelockpick")
;				endif		
;				debugNotification(Actorname+" slightly trims your hair.")
;				CurrentHairLength = HairStageLength[CurrentHairLengthStage]
			endif
		endif
		Game.DisablePlayerControls()
		if RequestedPermRemove
			debugNotification(Actorname+" will now remove your hair perm.")
			if !MCMValues.QuickHaircut
				if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
					Debug.SendAnimationEvent(akActor,"idlelockpick")
				endif		
				debugNotification(Actorname+" first applies the perm lotion.")
				PETicker.PlayYpsSound(16,10.0,0.1)
				debugNotification(Actorname+" then combs your hair.")
				PETicker.PlayYpsSound(11)
				debugNotification("You wait until the perm lotion takes effect.")
				Utility.Wait(5.0)
				debugNotification("The perm lotion smells awful.")
				Utility.Wait(15.0)
				debugNotification(Actorname+" finally washes out the perm lotion.")
				if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
					Debug.SendAnimationEvent(akActor,"idlelockpick")
				endif		
				PETicker.PlayYpsSound(18,10.0,0.1)
			endif
			SetStandardHairstyle(CurrentHairLengthStage)
			PlayerSpecialHairtype = 0
			CheckHair()
			PlayerPermDate = Utility.GetCurrentGameTime()
		elseif RequestedSpecialHairType == 1 ; perm
			if RequestedPermRefresh
				debugNotification("Your perm will now be refreshed.")
			else
				debugNotification("You will now be given a perm.")
			endif
			if !MCMValues.QuickHaircut
				if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
					Debug.SendAnimationEvent(akActor,"idlelockpick")
				endif		
				debugNotification(Actorname+" first curls up your hair.")
				PETicker.PlayYpsSound(11)
				debugNotification(Actorname+" then applies the perm lotion.")
				PETicker.PlayYpsSound(16,10.0,0.1)
				Utility.Wait(5.0)
				debugNotification("You wait until the perm lotion takes effect.")
				Utility.Wait(5.0)
				debugNotification("The perm lotion smells awful.")
				Utility.Wait(15.0)
				debugNotification(Actorname+" finally washes out the perm lotion.")
				if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
					Debug.SendAnimationEvent(akActor,"idlelockpick")
				endif		
				PETicker.PlayYpsSound(18,10.0,0.1)
			endif
			if !RequestedPermRefresh
				CurrentHairstyleName = RequestedHairStyleID
				PlayerSpecialHairtype = 1
				PlayerCurrentCustomHairstyle = CustomHairstyleChosen
			endif
			CheckHair()
			if !MCMValues.QuickHaircut
				debugNotification(Actorname+" blows your hair dry.")
				if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
					Debug.SendAnimationEvent(akActor,"idlelockpick")
				endif		
				PETicker.PlayYpsSound(4,10.0,0.1)
			endif
			PlayerPermDate = Utility.GetCurrentGameTime()
			debugNotification("You have now beautifully permed hair.")
		elseif RequestedSpecialHairType == 4 ; buzz nape
			if PlayerSpecialHairtype == 0 ; new buzz
				if (RequestedNewHairLength >= 1) && (RequestedNewHairLength < CurrentHairLengthStage)
					if MCMValues.ShowAnimations && !MCMValues.QuickHaircut && PETicker.ValidatePlayer()
						Debug.SendAnimationEvent(akActor,"idlelockpick")
					endif		
					HaircutProcess(Actorname,RequestedNewHairLength)
				endif
				if !MCMValues.QuickHaircut
					debugNotification(Actorname+" now takes the soulgem haircutter and buzzes your nape.")
					if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
						Debug.SendAnimationEvent(akActor,"idlelockpick")
					endif		
					Utility.Wait(0.1)
					PETicker.PlayYpsSound(17,12.0)
				endif
				CurrentHairstyleName = RequestedHairStyleID
				PlayerCurrentCustomHairstyle = RequestedCustomHairStyle
				PlayerSpecialHairtype = 4
				CheckHair()
				debugNotification("You now have a fresh buzzed nape haircut.")
			elseif PlayerSpecialHairtype == 4 ; refresh buzz
				if ((CurrentHairLengthStage == 6) || (CurrentHairLengthStage == 7)) && (RequestedNewHairLength < CurrentHairLengthStage) ; ... trim
					if MCMValues.ShowAnimations && !MCMValues.QuickHaircut && PETicker.ValidatePlayer()
						Debug.SendAnimationEvent(akActor,"idlelockpick")
					endif		
					HaircutProcess(Actorname,RequestedNewHairLength)
				endif
				if !MCMValues.QuickHaircut
					Utility.Wait(1.5)
					debugNotification(Actorname+" now takes the haircutter and buzzes your nape.")
					Utility.Wait(0.1)
					if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
						Debug.SendAnimationEvent(akActor,"idlelockpick")
					endif		
					PETicker.PlayYpsSound(17,12.0)
				endif
				CurrentHairstyleName = RequestedHairStyleID
				PlayerCurrentCustomHairstyle = RequestedCustomHairStyle
				CurrentHairLength = HairStageLength[CurrentHairLengthStage] ; reset hairlength
				PlayerSpecialHairtype = 4
				CheckHair()
				debugNotification("You now have a freshly buzzed nape again.")
			else
				Debug.Trace("[YPS] Bug: wrong buzz beginning hairtype.")
			endif
		elseif (RequestedSpecialHairType == 5) || (RequestedSpecialHairType == 6) ; broad mohawk
			if PlayerSpecialHairtype == 0 ; new mohawk
				if (RequestedNewHairLength > 0) && (RequestedNewHairLength < CurrentHairLengthStage)
					if MCMValues.ShowAnimations && !MCMValues.QuickHaircut && PETicker.ValidatePlayer()
						Debug.SendAnimationEvent(akActor,"idlelockpick")
					endif		
					HaircutProcess(Actorname,RequestedNewHairLength)
				endif
				if !MCMValues.QuickHaircut
					Utility.Wait(1.5)
					debugNotification(Actorname+" now takes the haircutter and buzzes both sides of your head.")
					Utility.Wait(0.1)
					if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
						Debug.SendAnimationEvent(akActor,"idlelockpick")
					endif		
					PETicker.PlayYpsSound(17,12.0)
				endif
				CurrentHairstyleName = RequestedHairStyleID
				PlayerSpecialHairtype = RequestedSpecialHairType
				CheckHair()
				PlayerCurrentCustomHairstyle = RequestedCustomHairStyle
				debugNotification("You now have a fresh mohawk haircut.")
			elseif (PlayerSpecialHairtype == 5) || (PlayerSpecialHairtype == 6) ; refresh mohawk
				if !MCMValues.QuickHaircut
					Utility.Wait(0.1)
					debugNotification(Actorname+" now takes the haircutter and buzzes both sides of your head.")
					Utility.Wait(0.1)
					if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
						Debug.SendAnimationEvent(akActor,"idlelockpick")
					endif		
					PETicker.PlayYpsSound(17,12.0)
				endif
				CurrentHairstyleName = RequestedHairStyleID
				PlayerSpecialHairtype = RequestedSpecialHairType
				CheckHair()
				PlayerCurrentCustomHairstyle = RequestedCustomHairStyle
				debugNotification("You now have a fresh mohawk again.")
			else
				Debug.trace("[YPS] Bug: wrong mohawk beginning hairtype.")
			endif
		endif
		Game.DisablePlayerControls()
		if RequestedHairDye || RequestedHairdyeRefresh
			int OldHairColorationColor = HairColorationColor
			string OldHairColorName = CurrentHairColorName
			if InDibellaQuest
				Debug.Messagebox("That new haircut isn't quite what you had hoped for.\n"+Actorname+" still continues working on your hairstyle.")
			endif
			if !MCMValues.QuickHaircut
				Utility.Wait(0.1)
				debugNotification("You will now be given a hair dye.")
				Utility.Wait(0.1)
				debugNotification(Actorname+" first washes your hair.")
				if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
					Debug.SendAnimationEvent(akActor,"idlelockpick")
				endif		
				PETicker.PlayYpsSound(18,10.0,0.1)
				debugNotification(Actorname+" then applies the hair dye lotion.")
				if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
					Debug.SendAnimationEvent(akActor,"idlelockpick")
				endif		
				PETicker.PlayYpsSound(16,10.0,0.1)
				if RequestedHairDye
					DoPlayerHairColoringStandard(RequestedHairColor,false,false,true) ; during coloration process, show hair color in a more vivid way
				else ; RequestedHairdyeRefresh -> use current color
					DoPlayerHairColoring(OldHairColorationColor,OldHairColorName,false,false,true)
				endif
				debugNotification("You wait until the hair dye takes effect.")
				Utility.Wait(5.0)
				debugNotification("The coloration cream has a strong fruity smell.")
				Utility.Wait(15.0)
				debugNotification(Actorname+" finally washes out the hair dye lotion.")
				if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
					Debug.SendAnimationEvent(akActor,"idlelockpick")
				endif		
				PETicker.PlayYpsSound(18,10.0,0.1)
			endif
			if RequestedHairDye
				DoPlayerHairColoringStandard(RequestedHairColor)
			else ; RequestedHairdyeRefresh -> use current color
				DoPlayerHairColoring(OldHairColorationColor,OldHairColorName)
			endif
			Utility.Wait(0.1)
			debugNotification(Actorname+" blows your hair dry.")
			PETicker.PlayYpsSound(4,10.0,0.1)
		endif
		Game.DisablePlayerControls()
		if RequestedStandardHairStyling
			if PlayerSpecialHairtype != 0
				Debug.trace("[YPS] Bug: invalid special hairtype request.")
			else
				if !MCMValues.QuickHaircut
					debugNotification(Actorname+" carefully combs and styles your beautiful hair.")
					if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
						Debug.SendAnimationEvent(akActor,"idlelockpick")
					endif		
					Utility.Wait(0.1)
				endif
				CurrentHairstyleName = RequestedHairStyleID
				PlayerCurrentCustomHairstyle = RequestedCustomHairStyle
				if RequestedSpecialHairType == 0 ; combed
					PlayerSpecialHairtype = 0
				elseif RequestedSpecialHairType == 2 ; braided
					debugNotification(Actorname+" styles your hair into a beautiful braid.")
					if MCMValues.ShowAnimations && !MCMValues.QuickHaircut && PETicker.ValidatePlayer()
						Debug.SendAnimationEvent(akActor,"idlelockpick")
					endif		
					PlayerSpecialHairtype = 2
				elseif RequestedSpecialHairType == 3 ; ponytail
					debugNotification(Actorname+" styles your hair into a beautiful ponytail.")
					if MCMValues.ShowAnimations && !MCMValues.QuickHaircut && PETicker.ValidatePlayer()
						Debug.SendAnimationEvent(akActor,"idlelockpick")
					endif		
					PlayerSpecialHairtype = 3
				else
					Debug.trace("[YPS] Bug: invalid special style request.")
				endif
				CheckHair()
			endif
		endif
		PETicker.AddPlayerFine(HairMakeoverPrice as int)
		Game.EnablePlayerControls()
		debugNotification("Your hair makeover session has finished.")
		CheckHair()
		if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
			Debug.SendAnimationEvent(akActor,"idleStop")
		endif		
	endif
    endif
endfunction

Quest Property yps04DibellaFollower Auto

function DibellaQuestMakeoverSession(Actor Hairdresser)
	RequestedNewHairLength = MCMValues.DibellaQuestHairstyleLength
	if MCMValues.DibellaQuestHairstyleLength >= 2
		RequestedSpecialHairType = MCMValues.DibellaQuestHairstyleType
	else
		RequestedSpecialHairType = 0  ; bald hair is just a normal hairstyle
	endif
	RequestedDefaultHairstyle = false ; we don't want the preset default hairstyle for a certian length
	RequestedHaircut = true
	RequestedHairColor = MCMValues.DibellaQuestHairstyleColor
	if MCMValues.DibellaQuestHairstyleLength >= 2
		RequestedHairDye = true
	else
		RequestedHairDye = false ; don't need to dye bald hair
	endif
	RequestedHairdyeRefresh = false
	RequestedPermRefresh = false
	RequestedPermRemove = false
	RequestedHairStyleID = MCMValues.DibellaQuestHairstyleName ; later be changed to zzSDAnadine
	RequestedCustomHairStyle = 0
	RequestedStandardHairStyling = (RequestedSpecialHairType == 0)
	HairMakeoverPrice = 0.0
	DoMakeoverSession(Hairdresser,false,true)
	YPS04DibellaFollower.SetObjectiveCompleted(490)
	YPS04DibellaFollower.SetObjectiveDisplayed(500)
	YPS04DibellaFollower.Setstage(500)
endfunction

function DibellaQuestAddRibbon()
	if MCMValues.DibellaQuestHairstyleAcc
		CurrentHairstyleName = MCMValues.DibellaQuestHairstyleAccName
		CheckHair()
	endif
endfunction

message property ypsHairstyleSpecialMsg auto
function HairCatalog() ; this will be called when "show me a list of all preconfigured hair styles" is called
  if !HairgrowthLock
	HairgrowthLock = true
	int ShowHairLength = PickHairLength()
	int ShowHairSpecial = ypsHairstyleSpecialMsg.show()

	string PreviousHairstyle = CurrentHairstyleName
	float PreviousUndyedHairLength = CurrentUndyedHairLength
	float PreviousColorationTime = LastColorationTime
	int PreviousColorationColor = HairColorationColor

	ChooseHairstyle(ShowHairLength,ShowHairSpecial,true)
	if HairstyleChosen
		string ShowHairstyle = ChosenHairstyleID
		int ShowHairColor = HairColorCode[PickHairColor()]
		debugNotification("Now showing the selected style for 5 seconds.")
		CurrentHairstyleName = ShowHairstyle
		CurrentUndyedHairLength = 0.0
		LastColorationTime = Utility.GetCurrentGameTime()
		if ShowHairColor
			SetHairColorationColor(ShowHairColor)
		endif
		checkhair(false)
		utility.wait(5.0)
	endif
	
	CurrentHairstyleName = PreviousHairstyle
	CurrentUndyedHairLength = PreviousUndyedHairLength
	LastColorationTime = PreviousColorationTime
	SetHairColorationColor(PreviousColorationColor)

	checkhair()

	HairgrowthLock = false
  endif
endfunction

function OpenRaceMenu() ; this will be called when "(preview hair styles in racemenu)" is called
	Debug.Messagebox("You will now be able to *preview* hairstyles in racemenu.\nNote that only YPS preset hairstyles or custom hairstyles (defined in MCM) may be choosen during the makeover session.")
	Utility.Wait(0.3)
	Game.ShowRacemenu()
	Utility.Wait(0.01)
	CheckHair()
endfunction

MiscObject Property ypsShavingKnife Auto

function ShaveHead(MiscObject ShavingCreamItem) ; this is called when you click on shaving cream in your inventory (will be called from other script)
	Utility.Wait(0.1)
	if PlayerActor.GetItemCount(ypsShavingKnife) == 0
		debugNotification("You need a shaving knife to shave your head.")
	elseif PlayerActor.GetItemCount(ShavingCreamItem) == 0
		debugNotification("You need some shaving cream to shave your head.")
	elseif CurrentHairLengthStage >= 4
		debugNotification("Your hair is to long to shave it yourself. Find a hairdresser.")
	else
		if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStudy")
		endif		
		debugNotification("You begin to apply shaving cream on your head.")
		PETicker.PlayYpsSound(2)
		debugNotification("You then take the shaving knife and shave your head smooth.")
		if !MCMValues.QuickHaircut
			PETicker.PlayYpsSound(11)
			PETicker.PlayYpsSound(11)
			PETicker.PlayYpsSound(11)
		endif
		DoPlayerHairCut(1)
		if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStudy")
		endif		
		debugNotification("You gently rub away the remaining shaving cream. All of your head hair is now gone.")
		PETicker.PlayYpsSound(3)
		PlayerActor.Removeitem(ShavingCreamItem,1)
		if MCMValues.ShowAnimations && PETicker.ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStop")
		endif		
	endif
endfunction

; DBF - Silent mode
Function debugNotification(string sMsg)
	if (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
		Debug.Notification(sMsg)
	endif
endFunction