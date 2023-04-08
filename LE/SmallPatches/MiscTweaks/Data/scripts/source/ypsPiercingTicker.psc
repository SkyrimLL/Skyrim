Scriptname  YpsPiercingTicker extends Quest  Conditional

; version 6.2

MiscObject Property Gold001 Auto
int PlayerFine = 0 ; total fine for dropping items. will be deducted as soon as you have gold in your pocket.
int Property BaseFine = 770 AutoReadOnly ; fine that will always be deducted

yps_PC_MCM Property MCMValues Auto  
YpsHeelsNio Property HeelsNioScript Auto
ypsHeelsTicker Property HeelsTicker auto
ypsHairScript Property Hairscript Auto
ypsUIExtensionsScript Property UIEScript Auto
ypsUtil property UtilScript Auto
yps05InfibQuest property InfibScript Auto
YPS_InterfaceSos Property Sos Auto

; =======================================================
; =======================================================
; =======================================================
; =======================================================
; ===================== PIERCINGS =======================
; =======================================================
; =======================================================
; =======================================================
; =======================================================


; constants:
float[] DaysUntilClosed  		; days after which a piercing without Piercing in it heals and closes (one ingame hour = ca. 0.04 days)
float[] DaysUntilNextStage 		; days after which next stage is reached when continuously wearing an Piercing
float[] DaysHealingAllowance 		; grace period in which piercings may be empty before beginning to heal up (player might need some time to change Piercings!)
float[] DaysPiercingMessage 		; time to wait until you get "flavor" message on your piercing status
int PiercingsDropRate = 2000		; rate that Piercings drop to ground -- if not fixed by backs or welded (e.g. value 100 means 1 in 100 ticks will drop); exception: 0 counts as "never"
int PiercingUnweldRate = 100		; rate that Yolie will want to unweld your Piercings (in ticks)
int MessageWaitTicks = 20		; average number of ticks to wait until flavor message is displayed (in order to avoid clustering); default = a good multiple of slot counts, around 30-40
int MinimalPiercingCost = 500

string[] PiercingSlotName
bool[] PiercingSlotNamePlural

int property SlotCount = 16 AutoReadOnly ; number of available piercing slots

string[] NailPolishColor
int property NailPolishCount = 69 AutoReadOnly ; number of available nail polish colors

Actor Property PlayerActor Auto Hidden

int Property NPCCommentRate = 175 AutoReadOnly ; average number of ticks until NPCs will comment on you
int property NPCCommentEarrings = 0 auto conditional
int property NPCCommentPolishedNails = 0 auto conditional
int property NPCCommentSmudgedNails = 0 auto conditional ; 30
int property NPCCommentChippedNails = 0 auto conditional ; 60 70

; slots to look for Piercings, piercings and nails:
int Property kSlotMask32 = 0x00000004 AutoReadOnly ; BODY
int Property kSlotMask33 = 0x00000008 AutoReadOnly ; Hands (Nails)
int Property kSlotMask37 = 0x00000080 AutoReadOnly ; Feet
int Property kSlotMask43 = 0x00002000 AutoReadOnly ; Ears
int Property kSlotMask44 = 0x00004000 AutoReadOnly ; Unnamed (Face/Mouth)
int Property kSlotMask45 = 0x00008000 AutoReadOnly ; Unnamed (Neck)
int Property kSlotMask46 = 0x00010000 AutoReadOnly ; Unnamed (Neck)
int Property kSlotMask49 = 0x00080000 AutoReadOnly ; DD chastity belts
int Property kSlotMask50 = 0x00100000 AutoReadOnly ; DecapitateHead
int Property kSlotMask51 = 0x00200000 AutoReadOnly ; Decapitate
int Property kSlotMask53 = 0x00800000 AutoReadOnly ; Unnamed
int Property kSlotMask54 = 0x01000000 AutoReadOnly ; Unnamed
int Property kSlotMask55 = 0x02000000 AutoReadOnly ; Unnamed (Face Alternate or Jewelry)
int Property kSlotMask56 = 0x04000000 AutoReadOnly ; Unnamed (chest secondary or undergarment)
int Property kSlotMask57 = 0x08000000 AutoReadOnly ; Unnamed (shoulder)
int Property kSlotMask60 = 0x40000000 AutoReadOnly ; Unnamed (misc/FX, use for anything that doesnt fit in the list)
int Property kSlotMask61 = 0x80000000 AutoReadOnly ; FX01

; variables:
bool[] PiercingHoleFilled	; player starts with "virgin" ears
float[] PiercingHoleEmptySince 	; timestamp since piercing holes are empty
float[] PiercingHoleFilledSince	; timestamp since piercing holes are filled
float[] NoPiercingHoleMessageSince ; timestamp for the last "flavor" message

int[] PiercingStage ; = -1 ; stage -1: ears have never been pierced; 0: ears not pierced; 1: starter piercing, no grace period; 2: only studs, short grace period; 3: all Piercings, longer grace period; 4: permanent
int[] WeldStatus ; = 0   ; 60 = secured with Piercing backs, 90 = welded and Yolie won't help (freshly pierced), 92 = Yolie won't help (lack of interest), 95 = Yolie will help

bool[] PiercingStudWorn	; Stud Piercing (Tattoo) worn in the slot

Spell[] Property PiercedSpell Auto 
Spell[] Property PiercedPermanentSpell Auto 
Perk[] Property PiercedPerk Auto 
Perk[] Property PermanentPiercedPerk Auto 
;############################### the following 2 are needed for all slots in use! ###############################
int property EarPiercingStage = -1 auto conditional
int property EarWeldStatus = 0 auto conditional
int property LeftNostrilPiercingStage = -1 auto conditional
int property LeftNostrilWeldStatus = 0 auto conditional
int property SeptumPiercingStage = -1 auto conditional
int property SeptumWeldStatus = 0 auto conditional
int property SnakeBitesPiercingStage = -1 auto conditional
int property SnakeBitesWeldStatus = 0 auto conditional
int property RightLabretPiercingStage = -1 auto conditional
int property RightLabretWeldStatus = 0 auto conditional
int property CentralLabretPiercingStage = -1 auto conditional
int property CentralLabretWeldStatus = 0 auto conditional
int property RightEyebrowPiercingStage = -1 auto conditional
int property RightEyebrowWeldStatus = 0 auto conditional
int property NoseBridgePiercingStage = -1 auto conditional
int property NoseBridgeWeldStatus = 0 auto conditional
int property NavelPiercingStage = -1 auto conditional
int property NavelWeldStatus = 0 auto conditional
int property NipplePiercingStage = -1 auto conditional
int property NippleWeldStatus = 0 auto conditional
int property ClitPiercingStage = -1 auto conditional
int property ClitWeldStatus = 0 auto conditional
int property LabiaPiercingStage = -1 auto conditional
int property LabiaWeldStatus = 0 auto conditional

int property piercedlabia = 0 auto conditional

; variables for the checkplayerpiercing routine
int[] OldMainPiercingSlot ; slot where the actual Piercing is found; other Piercings (if any) will be removed
Form[] Property OldPiercingForm Auto Hidden  	; form of the Piercing just being worn
int NewMainPiercingSlot	
Form Property NewPiercingForm Auto Hidden  	; 	newly detected form of the Piercing just being worn
bool[] PiercingWeldedToPlayer

Keyword Property ypsStarterPiercing Auto
Keyword Property ypsStudPiercing Auto

Quest Property UnboundQ Auto	; only for preventing Body show in Opening quest, cart scene

Quest Property ypsPiercedEarQuest01 Auto	; quest only for ear lobes, not for other piercing slots
Quest Property yps04DibellaFollower Auto
Quest Property yps05Infib Auto

int property PiercingCostDifference = -1 Auto Conditional  ; if >= 0, then player can afford piercing

; ##### init functions #####

Armor Property MicroStuds Auto  	;; type 1 starter stud (contained in this mod)
Form Property DiamondStuds Auto Hidden 	;; type 2 starter stud  	0x00028AD2	"Piercings Studs Diamond"
Int Property DiamondStudsFound = 0 Auto Conditional
Form Property RubyStuds Auto  Hidden	;; type 3 starter stud		0x00028AD4	"Piercings Studs Ruby"
Int Property RubyStudsFound = 0 Auto Conditional
Form Property EmeraldStuds Auto  Hidden	;; type 4 starter stud		0x00028AD6	"Piercings Studs Emerald"
Int Property EmeraldStudsFound = 0 Auto Conditional
Form Property SteelStuds Auto	 Hidden	;; type 5 starter stud	0x00002DBA	"Ear Plug Piercing" 
Int Property SteelStudsFound = 0 Auto Conditional
;Form Property LeftNostrilStud Auto Hidden	;; "Nose Piercing" 0x??00387e
;Int Property LeftNostrilStudFound = 0 Auto Conditional
;Form Property SeptumStud Auto Hidden	;; "Nose Bridge Piercing" 0x00000D62
;Int Property SeptumStudFound = 0 Auto Conditional
;Form Property SnakeBitesStud Auto Hidden	;; "Snake Bites Piercing" 0x00002857
;Int Property SnakeBitesFound = 0 Auto Conditional
;Form Property RightLabretStud Auto Hidden	;; "Lip Spike Piercing" 0x000063AA
;Int Property RightLabretStudFound = 0 Auto Conditional
;Form Property CentralLabretStud Auto Hidden	;; "Vertical Labret Piercing" 0x000063A8
;Int Property CentralLabretStudFound = 0 Auto Conditional
;Form Property RightEyebrowStud Auto Hidden	;; "Eyebrow Piercing" 0x00002856
;Int Property RightEyebrowStudFound = 0 Auto Conditional
;Form Property NoseBridgeStud Auto Hidden	;; "Nose Bridge Piercing" 0x00000D62
;Int Property NoseBridgeStudFound = 0 Auto Conditional
;Form Property NavelStud Auto Hidden	;; "piercing navel gold" 0x00007FA9
;Int Property NavelStudFound = 0 Auto Conditional
;Form Property NippleStuds Auto Hidden	;; "nipplering silver" 0x00000E30
;Int Property NippleStudsFound = 0 Auto Conditional
;Form Property ClitStud Auto Hidden	;; "piercing labia gold" 0x00007FA3
;Int Property ClitStudFound = 0 Auto Conditional
;Form Property LabiaStuds Auto Hidden	;; "16 labia rings" 0x00001831
;Int Property LabiaStudsFound = 0 Auto Conditional
; ############ add for all other starter studs

int Function LookForStuds()
; earlobes
;	DiamondStuds = Game.GetFormFromFile(0x00028AD2,"HN66 SLEEK Outfits.esp")
	DiamondStudsFound = (Game.GetModByName("HN66 SLEEK Outfits.esp") != 255 || Game.GetModByName("SexriM - YPS Resurces.esp") != 255) as int ; (DiamondStuds != NONE) as int
;	RubyStuds = Game.GetFormFromFile(0x00028AD4,"HN66 SLEEK Outfits.esp")
	RubyStudsFound = DiamondStudsFound ; (RubyStuds != NONE) as int
;	EmeraldStuds = Game.GetFormFromFile(0x00028AD6,"HN66 SLEEK Outfits.esp")
	EmeraldStudsFound = DiamondStudsFound ; (EmeraldStuds != NONE) as int
;	SteelStuds = Game.GetFormFromFile(0x00002DBA,"RegnPiercings.esp")
	SteelStudsFound = (Game.GetModByName("RegnPiercings.esp") != 255 || Game.GetModByName("SexriM - YPS Resurces.esp") != 255) as int ; (SteelStuds != NONE) as int
;; left nostril
;	LeftNostrilStud = Game.GetFormFromFile(0x0000387E,"KS Jewelry.esp")
;	LeftNostrilStudFound = (LeftNostrilStud != NONE) as int
;; septum
;	SeptumStud = Game.GetFormFromFile(0x000012CE,"Zarias_Piercings1.esp")
;	SeptumStudFound = (SeptumStud != NONE) as int
;; right and left labret
;	SnakeBitesStud = Game.GetFormFromFile(0x00002857,"RegnPiercings.esp")
;	SnakeBitesFound = (SnakeBitesStud != NONE) as int
;; right labret
;	RightLabretStud = Game.GetFormFromFile(0x000063AA,"RegnPiercings.esp")
;	RightLabretStudFound = (RightLabretStud != NONE) as int
;; (central) labret
;	CentralLabretStud = Game.GetFormFromFile(0x000063A8,"RegnPiercings.esp")
;	CentralLabretStudFound = (CentralLabretStud != NONE) as int
;; right eyebrow
;	RightEyebrowStud = Game.GetFormFromFile(0x00002856,"RegnPiercings.esp")
;	RightEyebrowStudFound = (RightEyebrowStud != NONE) as int
;; nose bridge
;	NoseBridgeStud = Game.GetFormFromFile(0x00000D62,"RegnPiercings.esp")
;	NoseBridgeStudFound = (NoseBridgeStud != NONE) as int
;; navel
;	NavelStud = Game.GetFormFromFile(0x00007FA9,"HDT Piercingsets.esp")
;	NavelStudFound = (NavelStud != NONE) as int
;; nipples
;	NippleStuds = Game.GetFormFromFile(0x00000E30,"SED7-CBBE3-BM_ALLin1-EDITION.esp")
;	NippleStudsFound = (NippleStuds != NONE) as int
;	if !NippleStudsFound
;		NippleStuds = Game.GetFormFromFile(0x00007F82,"HDT Piercingsets.esp")
;		NippleStudsFound = (NippleStuds != NONE) as int
;	endif
;; clitoris
;	ClitStud = Game.GetFormFromFile(0x00007FA3,"HDT Piercingsets.esp")
;	ClitStudFound = (ClitStud != NONE) as int
;; labia
;	LabiaStuds = Game.GetFormFromFile(0x00001831,"zarias_restraints.esp")
;	LabiaStudsFound = (LabiaStuds != NONE) as int
EndFunction

Function InitializeVariables()
	PiercingSlotName = new string[16]
; the following also be defined in the property context menu. Better leave them here, to have them available as reference
; (they need to be included in the MCM menu too, in any case)
	PiercingSlotName[1] = " earlobes"
	PiercingSlotName[2] = " left nostril"
	PiercingSlotName[3] = " septum"
	PiercingSlotName[4] = " snake bites"
	PiercingSlotName[5] = " right labret"
	PiercingSlotName[6] = " labret"
	PiercingSlotName[7] = " right eyebrow"
	PiercingSlotName[8] = " nose bridge"
	PiercingSlotName[9] = " navel"
	PiercingSlotName[10] = " nipples"
	PiercingSlotName[11] = " clitoris"
	PiercingSlotName[12] = " labia"
;	PiercingSlotName[13] = " " ; not yet implemented
;	PiercingSlotName[14] = " " ; not yet implemented
;	PiercingSlotName[15] = " " ; not yet implemented
	PiercingSlotNamePlural = new bool[16] ; default = false
	PiercingSlotNamePlural[1] = true
	PiercingSlotNamePlural[4] = true
	PiercingSlotNamePlural[10] = true
	PiercingSlotNamePlural[12] = true
;	PiercingSlotNamePlural[13] = true
;	PiercingSlotNamePlural[14] = true
;	PiercingSlotNamePlural[15] = true
	NailPolishColor = new string[69]
	NailPolishColor[0] = " (remover)"
	NailPolishColor[1] = " aqua"
	NailPolishColor[2] = " black"
	NailPolishColor[3] = " blue"
	NailPolishColor[4] = " bright red"
	NailPolishColor[5] = " dark red"
	NailPolishColor[6] = " gold"
	NailPolishColor[7] = " green"
	NailPolishColor[8] = " pink"
	NailPolishColor[9] = " purple"
	NailPolishColor[10] = " silver"
	NailPolishColor[11] = " clear"  ; french nails
	NailPolishColor[12] = " grey tips"
	NailPolishColor[13] = " zebra red"
	NailPolishColor[14] = " blood red"
	NailPolishColor[15] = " dark blue"
	NailPolishColor[16] = " dark green"
	NailPolishColor[17] = " clear"  ; 17-22 are extensions
	NailPolishColor[18] = " black"
	NailPolishColor[19] = " blue"
	NailPolishColor[20] = " gold"
	NailPolishColor[21] = " green"
	NailPolishColor[22] = " red"
	NailPolishColor[23] = " gold glitter"
	NailPolishColor[24] = " shimmery aqua"
	NailPolishColor[25] = " shimmery black"
	NailPolishColor[26] = " shimmery black cherry"
	NailPolishColor[27] = " shimmery blue"
	NailPolishColor[28] = " shimmery bright cherry"
	NailPolishColor[29] = " shimmery bright pink"
	NailPolishColor[30] = " shimmery cherry"
	NailPolishColor[31] = " shimmery clear"
	NailPolishColor[32] = " shimmery clear"
	NailPolishColor[33] = " shimmery clear"
	NailPolishColor[34] = " shimmery dark blue"
	NailPolishColor[35] = " shimmery dark green"
	NailPolishColor[36] = " shimmery grass green"
	NailPolishColor[37] = " shimmery grey"
	NailPolishColor[38] = " shimmery ivory"
	NailPolishColor[39] = " shimmery lemon"
	NailPolishColor[40] = " shimmery light green"
	NailPolishColor[41] = " shimmery magenta"
	NailPolishColor[42] = " shimmery orange"
	NailPolishColor[43] = " shimmery purple"
	NailPolishColor[44] = " shimmery rose pink"
	NailPolishColor[45] = " shimmery silver"
	NailPolishColor[46] = " shimmery sky blue"
	NailPolishColor[47] = " shimmery white"
	NailPolishColor[48] = " silver glitter"
	NailPolishColor[49] = " red glitter"
	NailPolishColor[50] = " shimmery dark cherry"
	NailPolishColor[51] = " shimmery violet"
	NailPolishColor[52] = " apricot glitter"
	NailPolishColor[53] = " copper glitter"
	NailPolishColor[54] = " green glitter"
	NailPolishColor[55] = " blue glitter"
	NailPolishColor[56] = " smudged cherry"  ; cannot be applied
	NailPolishColor[57] = " red with white dots"  ; 57-68 only manicure, not available with nail polish bottles
	NailPolishColor[58] = " white with red dots"
	NailPolishColor[59] = " (not yet implemented nail art)" ; lu
	NailPolishColor[60] = " (not yet implemented nail art)" ; la
	NailPolishColor[61] = " (not yet implemented nail art)" ; ft
	NailPolishColor[62] = " (not yet implemented nail art)" ; egf
	NailPolishColor[63] = " (not yet implemented nail art)" ; eft
	NailPolishColor[64] = " (not yet implemented nail art)" ; 64
	NailPolishColor[65] = " (not yet implemented nail art)"
	NailPolishColor[66] = " (not yet implemented nail art)"
	NailPolishColor[67] = " (not yet implemented nail art)"
	NailPolishColor[68] = " (not yet implemented nail art)"
	LookForStuds() 		; looking for stud Piercings in other esp's:
EndFunction

Event OnInit()
   int i
	utility.wait(5.0) ; wait first, to reduce game save load (and crash chance)
	PlayerActor = Game.Getplayer()
	if !OldMainPiercingSlot || OldMainPiercingSlot.length < 16
		OldMainPiercingSlot =  new int[16]
	endIf
	if !OldPiercingForm || OldPiercingForm.length < 16
		OldPiercingForm =  new form[16]
	endIf
	if !PiercingStudWorn || PiercingStudWorn.length < 16
		PiercingStudWorn =  new bool[16]
	endIf
	if !PiercingWeldedToPlayer || PiercingWeldedToPlayer.length < 16
		PiercingWeldedToPlayer =  new bool[16]
	endIf
	if !PiercingHoleFilled || PiercingHoleFilled.length < 16
		PiercingHoleFilled =  new bool[16]
	endIf
	if !PiercingHoleEmptySince || PiercingHoleEmptySince.length < 16
		PiercingHoleEmptySince =  new float[16]
	endIf
	if !PiercingHoleFilledSince || PiercingHoleFilledSince.length < 16
		PiercingHoleFilledSince =  new float[16]
	endIf
	if !NoPiercingHoleMessageSince || NoPiercingHoleMessageSince.length < 16
		NoPiercingHoleMessageSince =  new float[16]
	endIf
	if !WeldStatus || WeldStatus.length < 16
		WeldStatus =  new int[16]
	endIf
	if !PiercingStage || PiercingStage.length < 16
		PiercingStage =  new int[16]
	endIf
	if !DaysUntilClosed || DaysUntilClosed.length < 16
		DaysUntilClosed =  new float[16]
	endIf
	if !DaysUntilNextStage || DaysUntilNextStage.length < 16
		DaysUntilNextStage =  new float[16]
	endIf
	if !DaysHealingAllowance || DaysHealingAllowance.length < 16
		DaysHealingAllowance =  new float[16]
	endIf
	if !DaysPiercingMessage || DaysPiercingMessage.length < 16
		DaysPiercingMessage =  new float[16]
	endIf
	i=SlotCount
	while i>0
		i -= 1
		PiercingStage[i] = -1
		DaysUntilClosed[i] = 1.5
		DaysUntilNextStage[i] = 5.0
		DaysHealingAllowance[i] = 0.1
		DaysPiercingMessage[i] = 0.4
	endwhile
	ypsPiercedEarQuest01.SetStage(0)	; needed to enable dialogue
	InitializeVariables()

	StorageUtil.SetFloatValue(None, "YPS_TweakVersion", 1.3)
	Debug.Notification("YPS Tweak v1.3")
	RegisterForSingleUpdate(MCMValues.TickerInterval)
EndEvent


; ------ external functions ------     (for quest stage scripts etc.)

miscobject property ypsMetallicPotion auto

bool Function IsNoDrop(form ItemToCheck)
	int PSlot
	GetColoredNailsForm(CurrentNailColor)
	if ItemToCheck==ColoredNails
		return true
	elseif ItemToCheck == ypsMetallicPotion
		Debug.Notification("You should hold onto "+ItemToCheck.Getname())
		return true
	elseif MCMValues.PiercingSlotVal[0] 
		PSlot = 0
		while PSlot<12 ; or SlotCount
			PSlot += 1
			if MCMValues.PiercingSlotVal[PSlot] && (LockPiercings || PiercingWeldedToPlayer[PSlot]) && (ItemToCheck==OldPiercingForm[PSlot])
;				if (ItemToCheck == ChastityLabiaRings) && (ChastityLabiaRings != NONE)
;					Debug.Messagebox("The labia rings are welded to you and can't be removed.")
;				else
;					Debug.Notification(ItemToCheck.Getname()+" can't be removed.")
;				endif
;				return true
			endif
		endwhile
	endif
	return false
endfunction

Function ResetNPCComment(int ctype)
	if ctype == 1
		NPCCommentEarrings = 0
	elseif ctype == 2
		NPCCommentPolishedNails = 0
	elseif ctype == 3
		NPCCommentSmudgedNails = 0
	elseif ctype == 4
		NPCCommentChippedNails = 0
	endif
EndFunction

int Property CheckPiercingConditionResult Auto Conditional
Armor Property CheckStudsFound Auto Hidden
Armor Property CurrentlyWornInSlot Auto Hidden
bool Function CheckPiercingCondition(int PSlot, int PiercingType)
; checks whether piercing can be done (is stud available? is slot occupied?)
     int ASlot
     string CurrentlyWornName
	CheckPiercingConditionResult = 0
	CheckStudsFound = NONE
	if PSlot == 1 && Game.GetModByName("SexriM - YPS Resurces.esp") != 255
		if PiercingType == 1
			CheckPiercingConditionResult = 1
		elseIf PiercingType == 2
			CheckStudsFound = game.GetFormFromFile(166610, "SexriM - YPS Resurces.esp") as armor
		elseIf PiercingType == 3
			CheckStudsFound = game.GetFormFromFile(166612, "SexriM - YPS Resurces.esp") as armor
		elseIf PiercingType == 4
			CheckStudsFound = game.GetFormFromFile(166614, "SexriM - YPS Resurces.esp") as armor
		elseIf PiercingType == 5
			CheckStudsFound = game.GetFormFromFile(11706, "SexriM - YPS Resurces.esp") as armor
		endIf
	elseif PSlot == 1
		if PiercingType == 1
			CheckPiercingConditionResult = 1 ; use SlaveTats piercing, no item needed
;			CheckStudsFound = MicroStuds as Armor
		elseif PiercingType == 2
			CheckStudsFound = Game.GetFormFromFile(0x00028AD2,"HN66 SLEEK Outfits.esp") as armor
		elseif PiercingType == 3
			CheckStudsFound = Game.GetFormFromFile(0x00028AD4,"HN66 SLEEK Outfits.esp") as armor
		elseif PiercingType == 4
			CheckStudsFound = Game.GetFormFromFile(0x00028AD6,"HN66 SLEEK Outfits.esp") as armor
		elseif PiercingType == 5
			CheckStudsFound = Game.GetFormFromFile(0x00002DBA,"RegnPiercings.esp") as armor
		endif
	elseif (PSlot >= 2) && (PSlot <= 12)
		CheckPiercingConditionResult = 1 ; use SlaveTats piercing, no item needed
;		CheckStudsFound = LeftNostrilStud as Armor
;	elseif PSlot == 3
;		CheckStudsFound = SeptumStud as Armor
;	elseif PSlot == 4
;		CheckStudsFound = SnakeBitesStud as Armor
;	elseif PSlot == 5
;		CheckStudsFound = RightLabretStud as Armor
;	elseif PSlot == 6
;		CheckStudsFound = CentralLabretStud as Armor
;	elseif PSlot == 7
;		CheckStudsFound = RightEyebrowStud as Armor
;	elseif PSlot == 8
;		CheckStudsFound = NoseBridgeStud as Armor
;	elseif PSlot == 9
;		CheckStudsFound = NavelStud as Armor
;	elseif PSlot == 10
;		CheckStudsFound = NippleStuds as Armor
;	elseif PSlot == 11
;		CheckStudsFound = ClitStud as Armor
;	elseif PSlot == 12
;		CheckStudsFound = LabiaStuds as Armor
; ############ add for all other starter studs
	endif
	if (CheckStudsFound != NONE)
		ASlot = CheckStudsFound.GetSlotMask()
		CurrentlyWornInSlot = PlayerActor.GetWornForm(ASlot) as Armor
		if CurrentlyWornInSlot == NONE
			CheckPiercingConditionResult = 1
		else
			CurrentlyWornName = CurrentlyWornInSlot.GetName()
			if CurrentlyWornName == "" ; wearing something like DD placeholder items
				CurrentlyWornName = " some unidentified item blocking the piercing slot"
			else 
				CurrentlyWornName = " your "+CurrentlyWornName
			endif
			Debug.Notification("Before getting your"+PiercingSlotName[PSlot]+" pierced, you need to remove"+CurrentlyWornName+" first.")
		endif
	endif
	return CheckPiercingConditionResult as bool
EndFunction

int Function ShowPiercingCost()
	int PiercingCost
	PiercingCost = (MCMValues.PiercingCostVal * PlayerActor.Getlevel() ) as int
	if PiercingCost <= MinimalPiercingCost 
		PiercingCost = MinimalPiercingCost 
	endif
	return PiercingCost
EndFunction

sound Property PiercingGunSound Auto
sound Property PiercingNeedleSound Auto
sound Property SmallOuchSound Auto
sound Property Ouch1Sound Auto
sound Property Ouch2Sound Auto
Function PlayPiercingSound(bool UsePiercingGun, bool SecondPiercing)
	int instanceID1
	int instanceID2
	if UsePiercingGun
		instanceID1 =PiercingGunSound.play(PlayerActor)  ; play sound from self
		Sound.SetInstanceVolume(instanceID1, 1.0) 
		Utility.Wait(0.2)
		if PlayerActor.GetActorBase().GetSex() == 1	; only females say "ouch"
			instanceID2 =SmallOuchSound.play(PlayerActor)  ; play sound from self
			Sound.SetInstanceVolume(instanceID2, 0.8) 
		endif
		Utility.Wait(1.2)
	else
		instanceID1 =PiercingNeedleSound.play(PlayerActor)  ; play sound from self
		Sound.SetInstanceVolume(instanceID1, 1.0) 
		Utility.Wait(0.1)
		if PlayerActor.GetActorBase().GetSex() == 1	; only females say "ouch"
			if SecondPiercing
				instanceID2 =Ouch2Sound.play(PlayerActor)  ; play sound from self
			else
				instanceID2 =Ouch1Sound.play(PlayerActor)  ; play sound from self
			endif
			Sound.SetInstanceVolume(instanceID2, 1.0) 
		endif
		Utility.Wait(1.2)
	endif
	Sound.StopInstance(instanceID1)
	Sound.StopInstance(instanceID2)
EndFunction

string[] property SlaveTatStarterPiercingName auto
MiscObject[] property SlaveTatStarterPiercingBox auto
MiscObject property ypsEmptyPiercingBox auto

armor property ChastityLabiaRings auto
;armor property ChastityLabiaRingsShown auto
spell property yps_InfibulatedSpell auto
perk property yps_infibulated auto
float infibulated_since
bool infibulation_total_arousal_denial = false
bool showinfibulationnumbmsg = true
bool showinfibulationarousalmsg = true
bool showinfibulationarousaldecreasemsg = true


function RemoveInfibulation()
	PlayerActor.Removespell(yps_InfibulatedSpell)
	Weldstatus[12] = 0
	PlayerActor.UnequipItemSlot(49)
	PlayerActor.UnequipItemSlot(50)
	PlayerActor.RemoveItem(ChastityLabiaRings)
	PiercingStudWorn[12] = false
	OldPiercingForm[12] = NONE
endfunction

function GetChastityLabiaRingsForm()
	if ChastityLabiaRings == NONE
		if game.GetModByName("Devious Chastity Piercing.esp") != 255
			ChastityLabiaRings = Game.GetFormFromFile(0x000012c9,"Devious Chastity Piercing.esp") as armor
		endif
	endif
endfunction

;function GetChastityLabiaRingsShownForm()
;	if ChastityLabiaRingsShown == NONE
;		if game.GetModByName("Devious Chastity Piercing.esp") != 255
;			ChastityLabiaRingsShown = Game.GetFormFromFile(0x000012c8,"Devious Chastity Piercing.esp") as armor
;		endif
;	endif
;endfunction

Function ProceedPiercingProgress(int PSlot, Actor akActor, Armor StudPiercings, bool UseSlaveTatPiercing = false)
	string Actorname
	if UseSlaveTatPiercing
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		CurrentlyEquippedPiercingBox[PSlot] = SlaveTatStarterPiercingBox[PSlot]
		CurrentlyEquippedPiercingTattooName[PSlot] = SlaveTatStarterPiercingName[PSlot]
		CurrentlyEquippedPiercingName[PSlot] = "Starter Gold Ball Stud"+PluralS(PiercingSlotNamePlural[PSlot])
	endif

	Actorname = akActor.GetActorBase().Getname()
	Game.DisablePlayerControls()
	if PSlot == 1 ; earlobes
		StartEarPiercingQuest()
		Debug.Notification(Actorname + " begins gently rubbing your earlobes stimulating your blood circulation.")
		Debug.Notification("After disinfecting them with some alcohol, ...")
		Utility.Wait(1.0)
		Debug.Notification("..." + Actorname +" marks two points in the center of your earlobes with a pen.")
		Utility.Wait(1.0)
		Debug.Notification("You agree with the location but feel very nervous, as "+Actorname +" takes the piercing gun ...")
		Utility.Wait(2.8)
		PlayPiercingSound(true,false)
		Debug.Notification("... and places a stud in your right earlobe. It hurts just a little bit.")
		if UseSlaveTatPiercing
			STEBAddTattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot]+"R",0,true,true,3348992,true,MCMValues.SlaveTatLock) ; 3348992 = gold glow
		endif
		Utility.Wait(2.0)
		PlayPiercingSound(true,true)
		Debug.Notification("After a moment, " + Actorname + " proceeds with the left earlobe in the same fashion.")
		Debug.Notification("Both your earlobes are now pierced.")
		if UseSlaveTatPiercing
			STEBAddTattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot],0,true,true,3348992,true,MCMValues.SlaveTatLock)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot]+"R",true,true)
		endif
		Utility.Wait(0.5)
		PlayYpsSound(14,0.5)
		Debug.Notification(Actorname+" then secures both your earrings with earring backs.")
		STEBAddTattoo(PlayerActor,"YpsFashion","PiercingEarringBacks",0,true,true,EarringBacksGlowColor,true,MCMValues.SlaveTatLock)
		PlayYpsSound(14,0.5,0.5)
		EarringBacksWorn = true
	else  
		if (PSlot>=9) && (PSlot <=12)	; need to show your belly
			Utility.Wait(2.0)
			PlayerActor.UnequipItemSlot(32)
		endif
;		Utility.Wait(1.5)
		Debug.Notification(Actorname + " begins gently rubbing your"+PiercingSlotName[PSlot]+" stimulating your blood circulation.")
		Utility.Wait(1.0)
		Debug.Notification("After disinfection, " + Actorname +" marks the location"+PluralS(PiercingSlotNamePlural[PSlot])+"in the center of your"+PiercingSlotName[PSlot]+" with a pen.")
		Utility.Wait(1.0)
		Debug.Notification("You agree with the location but feel very nervous, as "+Actorname +" takes the piercing needle ...")
		Utility.Wait(2.8)
		if PSlot == 12
			InfibScript.DoInfibulationPiercings(akActor) ; do infibulation piercings
		elseif PiercingSlotNamePlural[PSlot]
			PlayPiercingSound(false,false)
			Debug.Notification("... and pierces one of your"+PiercingSlotName[PSlot]+". It hurts quite a lot. OUCH!")
			StumbleAnimation(0,true)
			if UseSlaveTatPiercing
				STEBAddTattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot]+"R",0,true,true,3348992,true,MCMValues.SlaveTatLock) ; 3348992 = gold glow
			endif
			Utility.Wait(2.0)
			PlayPiercingSound(false,true)
			Debug.Notification("After a moment, " + Actorname + " proceeds with the other side in the same fashion.")
			Debug.Notification("Both your"+PiercingSlotName[PSlot]+" are now pierced.")
			StumbleAnimation(0,true)
			if UseSlaveTatPiercing
				STEBAddTattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot],0,true,true,3348992,true,MCMValues.SlaveTatLock)
				SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot]+"R",true,true)
			endif
			Utility.Wait(2.0)
		else
			PlayPiercingSound(false,false)
			Debug.Notification("... and pierces your"+PiercingSlotName[PSlot]+". It hurts quite a lot. OUCH!")
			StumbleAnimation(0,true)
			if UseSlaveTatPiercing
				STEBAddTattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot],0,true,true,3348992,true,MCMValues.SlaveTatLock) ; 3348992 = gold glow
			endif
			Utility.Wait(2.0)
			Debug.Messagebox(" Your"+PiercingSlotName[PSlot]+" is now pierced.")
		endif	
	endif
	PlayerActor.AddSpell(PiercedSpell[PSlot])
	if PSlot==10 ; for nipples/clit add DD piercing perks
		PlayerActor.AddSpell(DDPiercedNipples)
	elseif PSlot==11
		PlayerActor.AddSpell(DDPiercedClit)
	endif
	if !UseSlaveTatPiercing
		PlayerActor.AddItem(StudPiercings,1)
		PlayerActor.EquipItem(StudPiercings,true,false)
	endif
	PiercingHoleFilledSince[PSlot] =  Utility.GetCurrentGameTime()	
	AddPlayerFine(ShowPiercingCost()) ; PlayerActor.RemoveItem(Gold001,ShowPiercingCost())
	WeldStatus[PSlot] = 60
	if UseSlaveTatPiercing
		PiercingStudWorn[PSlot] = true
		PlayerActor.AddItem(ypsEmptyPiercingBox,1)
		SlavetatsLock = false
	endif
	Game.EnablePlayerControls()
EndFunction

Function UseSelfPiercingKit(int PSlot) ; only applies piercing perks, no items!
	PlayerActor.AddSpell(PiercedSpell[PSlot])
	if PSlot==10 ; for nipples/clit add DD piercing perks
		PlayerActor.AddSpell(DDPiercedNipples)
	elseif PSlot==11
		PlayerActor.AddSpell(DDPiercedClit)
	endif
	if WeldStatus[PSlot]<60
		WeldStatus[PSlot]=60
	endif
	PiercingStage[PSlot]=3 ; may immediately wear all piercing items
	PiercingHoleFilledSince[PSlot] =  Utility.GetCurrentGameTime()	
	PiercingHoleEmptySince[PSlot] =  Utility.GetCurrentGameTime()
	PiercingHoleFilled[PSlot] = true ; assume filled holes at least for 1 tick
	UpdateStageVariables(PSlot)
EndFunction

;keyword property ClothingBody auto
;keyword property ArmorCuirass auto
keyword property ArmorHelmet auto
keyword property zbfWornHood auto
keyword property zad_DeviousHood auto
keyword property zad_DeviousBoots auto

Function PierceMe(int PSlot, Actor akActor, int PiercingType)
	SendModEvent("dhlp-Suspend") ; suspending DCUR events
	if LockPiercings
		Debug.Notification("You are not allowed to change your piercings.")
	elseif PSlot == 1
		if (PlayerActor.GetActorBase().GetSex() != 1) ; female
			Debug.Notification("Only females may get their ears pierced.")
		elseif (yps04DibellaFollower.Getstage() >= 180) && (yps04DibellaFollower.Getstage() < 330)
			Debug.Notification("You don't feel confident enough to get your ears pierced.")
		elseif PiercingType <= 1
;			ProceedPiercingProgress(PSlot,akActor,MicroStuds as Armor)
			ProceedPiercingProgress(PSlot,akActor,NONE,true)
		elseif PiercingType > 1 && PiercingType < 6 && Game.GetModByName("SexriM - YPS Resurces.esp") != 255
			If PiercingType == 2
				DiamondStuds = game.GetFormFromFile(166610, "SexriM - YPS Resurces.esp")
				self.ProceedPiercingProgress(PSlot, akActor, DiamondStuds as armor, false)
			elseIf PiercingType == 3
				RubyStuds = game.GetFormFromFile(166612, "SexriM - YPS Resurces.esp")
				self.ProceedPiercingProgress(PSlot, akActor, RubyStuds as armor, false)
			elseIf PiercingType == 4
				EmeraldStuds = game.GetFormFromFile(166614, "SexriM - YPS Resurces.esp")
				self.ProceedPiercingProgress(PSlot, akActor, EmeraldStuds as armor, false)
			elseIf PiercingType == 5
				SteelStuds = game.GetFormFromFile(11706, "SexriM - YPS Resurces.esp")
				self.ProceedPiercingProgress(PSlot, akActor, SteelStuds as armor, false)
			endIf
		elseif PiercingType == 2
			DiamondStuds = Game.GetFormFromFile(0x00028AD2,"HN66 SLEEK Outfits.esp")
			ProceedPiercingProgress(PSlot,akActor,DiamondStuds as Armor)
		elseif PiercingType == 3
			RubyStuds = Game.GetFormFromFile(0x00028AD4,"HN66 SLEEK Outfits.esp")
			ProceedPiercingProgress(PSlot,akActor,RubyStuds as Armor)
		elseif PiercingType == 4
			EmeraldStuds = Game.GetFormFromFile(0x00028AD6,"HN66 SLEEK Outfits.esp")
			ProceedPiercingProgress(PSlot,akActor,EmeraldStuds as Armor)
		elseif PiercingType == 5
			SteelStuds = Game.GetFormFromFile(0x00002DBA,"RegnPiercings.esp")
			ProceedPiercingProgress(PSlot,akActor,SteelStuds as Armor)
		endif
	elseif (PSlot == 10) && (PlayerActor.WornHasKeyword(zbfWornBra) || PlayerActor.WornHasKeyword(zad_DeviousBra))
		Debug.Notification("You need to remove your chastity bra before getting your nipples pierced.")
	elseif ((PSlot == 11) || (PSlot == 12)) && (PlayerActor.WornHasKeyword(zbfWornBelt) || PlayerActor.WornHasKeyword(zad_DeviousBelt))
		Debug.Notification("You need to remove your chastity belt getting a vaginal piercing.")
	elseif ((PSlot == 7) || (PSlot == 8)) && (PlayerActor.WornHasKeyword(zad_DeviousBlindfold) || PlayerActor.WornHasKeyword(zbfWornBlindfold ))
		Debug.Notification("You need to remove your blindfold first before getting this piercing.")
	elseif (PSlot>=9) && (PSlot <=12) && (PlayerActor.GetWornForm(kSlotMask32) != NONE) ; PlayerActor.WornHasKeyword(ClothingBody) || PlayerActor.WornHasKeyword(ArmorCuirass))
		Debug.Notification("You need to remove your body clothes before getting a body piercing.")
	elseif (PSlot>=1) && (PSlot <=8) && (PlayerActor.WornHasKeyword(zbfWornHood) || PlayerActor.WornHasKeyword(zad_DeviousHood))
		Debug.Notification("You need to remove your face mask before getting this piercing.")
	elseif (PSlot>=1) && (PSlot <=8) && PlayerActor.WornHasKeyword(ArmorHelmet)
		Debug.Notification("You need to remove your helmet before getting this piercing.")
	elseif PSlot <=11
		ProceedPiercingProgress(PSlot,akActor,NONE,true)
	elseif PSlot == 12
		if game.GetModByName("Devious Chastity Piercing.esp") == 255
			Debug.Messagebox("[you need to install Devious Chastity Piercing to proceed with this piercing]")
		else
			GetChastityLabiaRingsForm()
;			GetChastityLabiaRingsShownForm()
			if (ChastityLabiaRings != NONE) ; && (ChastityLabiaRingsShown != NONE)
				Debug.SendAnimationEvent(PlayerActor,"zazapcao016")
				Debug.Messagebox("Since this is a complex piercing session, during which you shouldn't move, "+akActor.GetActorBase().Getname()+" locks you into a restraining device.")
				ProceedPiercingProgress(PSlot,akActor,ChastityLabiaRings,false)
;				PlayerActor.Equipitem(ChastityLabiaRingsShown,true,true)
				Debug.Messagebox("As you wake up you realize that "+akActor.GetActorBase().Getname()+" has removed the piercing needles one after another, and inserted a set of eight metal rings passing through both sides of your labia. Your vagina is now safe from penetration. But the procedure isn't finished yet...")
				Utility.Wait(0.02)
				WeldMyPiercings(PSlot,akActor)
				Debug.SendAnimationEvent(PlayerActor,"IdleForceDefaultState")	
			else
				Debug.Messagebox("[cannot find labia rings, maybe not properly installed]")
			endif
		endif
	else
		Debug.Trace("[YPS] bug: PierceMe Slot "+PSlot+" not implemented")
	endIf
	SendModEvent("dhlp-Resume")
EndFunction

Actor Property YolieActor Auto
Function YoliePierceMe(int PSlot, int PiercingType)
	if PiercingStage[PSlot] <= 0
		PierceMe(PSlot, YolieActor, PiercingType)
	else
		Debug.Notification("You already got your "+PSlot+" pierced.")
	endif
endFunction

Actor Property TrisActor Auto	; Tris Shadowrunner
Function TrisPierceMe(int PSlot, int PiercingType)
	if (PSlot == 12) && (OldPiercingForm[PSlot] != NONE)
		Debug.Notification("You are already wearing a labia piercing.")
	elseif PiercingStage[PSlot] <= 0
		PierceMe(PSlot, TrisActor, PiercingType)
	else
		Debug.Notification("You already got your "+PSlot+" pierced.")
	endif
endFunction


function AddPlayerFine(int FineAmount) ; used to pay for beauty services; will be deducted from player's pocket, if gold is enough
	PlayerFine += FineAmount
EndFunction

; ======== internal functions ========

Function UpdateAllStageVariables()
    int i
	i=SlotCount
	while i>0
		i -= 1
		UpdateStageVariables(i)
	endwhile
EndFunction

Function UpdateStageVariables(int PSlot) 	; set healing times according to current stage
	float fuzziness = 0.1		; variance of waiting times
	int HRI = MCMValues.HealingRateIndex	; = 0,1,2,3
	int DRI = MCMValues.DropRateIndex 	; = 0,1,2,3,4
	int UWI = MCMValues.UnweldWaitIndex	; = 0,1,2,3
	if HRI == 0
		DaysUntilNextStage[PSlot] = 0.005		; days after which next stage is reached when continuously wearing an Piercing
		MessageWaitTicks = 1
	elseif HRI == 1
		DaysUntilNextStage[PSlot] = 2.0
		MessageWaitTicks = 10
	elseif HRI == 2
		DaysUntilNextStage[PSlot] = 7.6
		MessageWaitTicks = 20
	elseif HRI == 3
		DaysUntilNextStage[PSlot] = 30.0
		MessageWaitTicks = 40
	endif
	if (PiercingStage[PSlot] == 2) || (PiercingStage[PSlot] == 3)
		DaysUntilNextStage[PSlot] = DaysUntilNextStage[PSlot]*2.43
	endif
	DaysUntilNextStage[PSlot] = DaysUntilNextStage[PSlot]*Utility.RandomFloat(1.0-fuzziness,1.0+fuzziness)
	DaysUntilClosed[PSlot] = DaysUntilNextStage[PSlot]*0.3		; days after which a piercing without Piercing in it heals and closes (one ingame hour = ca. 0.04 days);
	DaysHealingAllowance[PSlot] = DaysUntilClosed[PSlot]*0.1	; grace period in which piercings may be empty before beginning to heal up (player might need some time to change Piercings!)
	DaysPiercingMessage[PSlot] = DaysUntilClosed[PSlot]*0.06
	if PiercingStage[PSlot] == 4
		DaysPiercingMessage[PSlot] = DaysPiercingMessage[PSlot]*2.5	; with permanently pierced ears, don't need messages very often
	endif
	if DRI==0
		PiercingsDropRate = 3
	elseif DRI==1
		PiercingsDropRate = 35
	elseif DRI==2
		PiercingsDropRate = 1000
	elseif DRI==3
		PiercingsDropRate = 25000
	elseif DRI==4
		PiercingsDropRate = 0	; 0 counts as never
	endif
	if UWI == 0
		PiercingUnweldRate =1
	elseif UWI == 1
		PiercingUnweldRate =100
	elseif UWI == 2
		PiercingUnweldRate =1500
	elseif UWI == 3
		PiercingUnweldRate =30000 ; in fact it is forever
	endif
EndFunction

string Function PluralS(bool Plural)
	if Plural
		return "s " 
	else
		return " "
	endif
endfunction
string Function Has(bool Plural)
	if Plural
		return " have"
	else
		return " has"
	endif
endfunction
string Function Is(bool Plural)
	if Plural
		return " are"
	else
		return " is"
	endif
endfunction
string Function It(bool Plural)
	if Plural
		return " they"
	else
		return " it"
	endif
endfunction

Function IncreasePiercingStage(int PSlot)
	if PiercingStage[PSlot] < 4
		PiercingStage[PSlot] = PiercingStage[PSlot]+1
		if PiercingStage[PSlot] == 2
			Debug.Notification("The hole" + PluralS(PiercingSlotNamePlural[PSlot])+"in your"+PiercingSlotName[PSlot]+Has(PiercingSlotNamePlural[PSlot])+" healed a bit, you may now wear other stud piercings.")
		elseif PiercingStage[PSlot] == 3
			Debug.MessageBox("The day you have long waited for has finally arrived: The hole" + PluralS(PiercingSlotNamePlural[PSlot])+"in your"+ PiercingSlotName[PSlot] + Has(PiercingSlotNamePlural[PSlot]) + " healed quite well, and you may now wear all kinds of piercings.")
		elseif PiercingStage[PSlot] == 4
			Debug.MessageBox(" Your"+PiercingSlotName[PSlot]+Is(PiercingSlotNamePlural[PSlot])+" now permanently pierced.")
			if PSlot == 1
				ypsPiercedEarQuest01.SetStage(500)
			endif
			PlayerActor.AddSpell(PiercedPermanentSpell[PSlot]) 			
		endif
	endif
	UpdateStageVariables(PSlot)
EndFunction

Function ShowPiercingRandomMessage(int PSlot, bool FilledHoles)
	int RandInt
 if MCMValues.ShowMessagesVal
   if FilledHoles
	if PiercingStage[PSlot] == 1
		RandInt=Utility.RandomInt(1,3)
		if RandInt == 1
			Debug.Notification("Your pierced"+PiercingSlotName[PSlot]+" ache"+PluralS(!PiercingSlotNamePlural[PSlot])+"a bit. You ignore the pain, hoping that it will go off soon.")
		elseif RandInt == 2
			Debug.Notification("Your piercing suddenly hurts. Was it a good idea to get your"+PiercingSlotName[PSlot]+" pierced?")
		else
			Debug.Notification("You feel proud about your freshly pierced"+PiercingSlotName[PSlot]+".")
		endif
	elseif PiercingStage[PSlot] == 2
		if Utility.RandomInt(1,2) == 1
			Debug.Notification("Your pierced"+PiercingSlotName[PSlot]+" start"+PluralS(!PiercingSlotNamePlural[PSlot])+"itching, but the sensation goes off after a while.")
		else
			Debug.Notification("You enjoy the new piercing"+PluralS(PiercingSlotNamePlural[PSlot])+"in your"+PiercingSlotName[PSlot]+".")
		endif
	elseif PiercingStage[PSlot] == 3
		if (PSlot == 1) && (Utility.RandomInt(1,2)==1) && (StringUtil.Find(OldPiercingForm[1].Getname(),"HDT",0) >= 0)
			RandInt=3
		else
			RandInt=Utility.RandomInt(1,2)
		endif
		if RandInt == 1
			Debug.Notification("The thought to be able to wear all kinds of piercings in your"+PiercingSlotName[PSlot]+" now makes you happy.")
		elseif RandInt == 2
			Debug.Notification("You enjoy other people looking at your beautiful"+PiercingSlotName[PSlot]+".")
		else
			Debug.Notification("You enjoy the feeling of earrings dangling from your earlobes.")
		endif
	elseif PiercingStage[PSlot] == 4
		if (PSlot == 1) && (Utility.RandomInt(1,2)==1) && (StringUtil.Find(OldPiercingForm[1].Getname(),"HDT",0) >= 0)
			RandInt=3
		else
			RandInt=Utility.RandomInt(1,2)
		endif
		if RandInt == 1
			Debug.Notification("Wearing piercings in your"+PiercingSlotName[PSlot]+" just feels like a normal thing now.")
		elseif RandInt == 2
			Debug.Notification("You cannot image how you were ever able to live without wearing piercings in your"+PiercingSlotName[PSlot]+".")
		else
			Debug.Notification("You enjoy the feeling of earrings dangling from your earlobes.")
		endif
	endif
   elseif (PiercingStage[PSlot] >= 1) && (PiercingStage[PSlot] <= 2)
		Debug.Notification("You shouldn't keep your freshly pierced"+PiercingSlotName[PSlot]+" empty.")
   elseif (PiercingStage[PSlot] == 3)
		Debug.Notification("You shouldn't leave your pierced"+PiercingSlotName[PSlot]+" empty for too long.")
   elseif (PiercingStage[PSlot] == 4)
		Debug.Notification("The hole"+PluralS(PiercingSlotNamePlural[PSlot])+"in your"+PiercingSlotName[PSlot]+" will now stay open without wearing piercings.")
   endif
 endif
EndFunction

Function StartEarPiercingQuest()
	Int  EPQuestStage
	EPQuestStage = ypsPiercedEarQuest01.GetStage()
	if (EPQuestStage <60)  
		ypsPiercedEarQuest01.SetStage(60)
		ypsPiercedEarQuest01.SetObjectiveDisplayed(60)
	endif
EndFunction


;=====================

form FindPiercingForm	; not needed as arrays
bool FindPiercingFound
bool FindPiercingIsStud
bool FindPiercingIsStarter
string FindPiercingName

bool Function FindPiercing(int PSlot, int ItemSlot)		; looks for Piercing in slot and sets the above variables accordingly
	FindPiercingFound = false
	FindPiercingIsStud = false
	FindPiercingIsStarter = false
	FindPiercingForm = PlayerActor.GetWornForm(ItemSlot)
	if FindPiercingForm != NONE
	   FindPiercingName = FindPiercingForm.Getname()
	   if PSlot == 1
		if ItemSlot == kSlotMask43 
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Ring",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Pierc",0) >= 0) || (StringUtil.Find(FindPiercingName ,"cuff",0) >= 0)  || (StringUtil.Find(FindPiercingName ,"plug",0) >= 0)
			FindPiercingFound = FindPiercingFound ||  (StringUtil.Find(FindPiercingName ,"Moonrise",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Tempest",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Prisonic Fairytale",0) >= 0)  || (StringUtil.Find(FindPiercingName ,"Edelweiss",0) >= 0)
			FindPiercingFound = FindPiercingFound ||  (StringUtil.Find(FindPiercingName ,"Dream Dusk",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Blood Thorn",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Kestrel's Call",0) >= 0)  || (StringUtil.Find(FindPiercingName ,"Rising Sun",0) >= 0)
			FindPiercingFound = FindPiercingFound ||  (StringUtil.Find(FindPiercingName ,"Northern Star",0) >= 0) ||  (StringUtil.Find(FindPiercingName ,"Ear Bell",0) >= 0)
		elseif (ItemSlot == kSlotMask44) || (ItemSlot == kSlotMask45) || (ItemSlot == kSlotMask50) || (ItemSlot == kSlotMask55)
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Earring",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Earcuff",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Earplug",0) >= 0)  || (StringUtil.Find(FindPiercingName ,"Ear pierc",0) >= 0)
			FindPiercingFound = FindPiercingFound || (StringUtil.Find(FindPiercingName ,"Ear plug",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Ear cuff",0) >= 0)  || (StringUtil.Find(FindPiercingName ,"Ear ring",0) >= 0)  || (StringUtil.Find(FindPiercingName ,"creola",0) >= 0)

		endif
		if FindPiercingFound 
			FindPiercingIsStud =  (FindPiercingForm.HasKeyword(ypsStudPiercing)) || ( StringUtil.Find(FindPiercingName ,"Earrings Stud",0) >= 0) || ( StringUtil.Find(FindPiercingName ,"Ear Plug Piercing",0) >= 0)
			FindPiercingIsStarter = FindPiercingIsStud ;;; (FindPiercingForm.HasKeyword(ypsStarterPiercing)) || ( StringUtil.Find(FindPiercingName ,"Piercings Stud",0) >= 0) ;;; <- later maybe to be replaced by "Piercings Starter"
		endif
	   elseif PSlot == 2
		if ItemSlot == kSlotMask55
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Spiral Nose Ring",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Nose Piercing",0) >= 0) || (StringUtil.Find(FindPiercingName ,"IJ Nath",0) >= 0)
		endif 
		if FindPiercingFound 
			FindPiercingIsStud =  (StringUtil.Find(FindPiercingName ,"Nose Piercing",0) >= 0)
;			FindPiercingIsStarter = FindPiercingIsStud 
		endif
	   elseif PSlot == 3
		if ItemSlot == kSlotMask44
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Septum",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Nose Chain",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Piercing Combo 3",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Nose Ring",0) >= 0)
		elseif ItemSlot == kSlotMask55
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Septum",0) >= 0) || ((StringUtil.Find(FindPiercingName ,"Nose Ring",0) >= 0) && (StringUtil.Find(FindPiercingName ,"Spiral Nose Ring",0) < 0))
		endif 
		if FindPiercingFound 
			FindPiercingIsStud =  (FindPiercingName == "Nose Ring")
;			FindPiercingIsStarter = FindPiercingIsStud 
		endif
	   elseif PSlot == 4
		if ItemSlot == kSlotMask44
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Snake Bite",0) >= 0) 
		elseif ItemSlot == kSlotMask55
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Collide Lip Piercing",0) >= 0)
		endif 
		if FindPiercingFound 
			FindPiercingIsStud =  (FindPiercingName == "Snake Bites Piercing")
;			FindPiercingIsStarter = FindPiercingIsStud 
		endif
	   elseif PSlot == 5
		if ItemSlot == kSlotMask44
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Lip Spike",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Spider Bite",0) >= 0)
		endif
		if FindPiercingFound 
			FindPiercingIsStud =  (FindPiercingName == "Lip Spike Piercing")
;			FindPiercingIsStarter = FindPiercingIsStud 
		endif
	   elseif PSlot == 6
		if ItemSlot == kSlotMask44
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Vertical Labret",0) >= 0)
		endif
		if FindPiercingFound 
			FindPiercingIsStud =  (FindPiercingName == "Vertical Labret Piercing")
;			FindPiercingIsStarter = FindPiercingIsStud 
		endif
	   elseif PSlot == 7
		if ItemSlot == kSlotMask44
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Eyebrow",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Piercing Combo 2",0) >= 0 )
		elseif ItemSlot == kSlotMask32
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Nasal Stud and",0) >= 0)
		endif 
		if FindPiercingFound 
			FindPiercingIsStud =  (FindPiercingName == "Eyebrow Piercing")
;			FindPiercingIsStarter = FindPiercingIsStud 
		endif
	   elseif PSlot == 8
		if ItemSlot == kSlotMask44
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Nose Bridge",0) >= 0) || (StringUtil.Find(FindPiercingName ,"NoseBridge",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Piercing Combo 2",0) >=0)
		endif
		if FindPiercingFound 
			FindPiercingIsStud =  (FindPiercingName == "Nose Bridge Piercing")
;			FindPiercingIsStarter = FindPiercingIsStud 
		endif
	   elseif PSlot == 9
		if (ItemSlot == kSlotMask54) || (ItemSlot == kSlotMask56)
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Navel",0) >= 0)
		elseif (ItemSlot == kSlotMask53) || (ItemSlot == kSlotMask55)
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Piercings belt",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Piercings simple navel",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Pierce B",0) >= 0)
		elseif ItemSlot == kSlotMask57
			FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Navel",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Barbell",0) >= 0)
		endif 
		if FindPiercingFound 
			FindPiercingIsStud =  (FindPiercingName == "Piercing Navel Gold")
;			FindPiercingIsStarter = FindPiercingIsStud 
		endif
	   elseif PSlot == 10
		FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Nippleshield",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Nipple Piercing",0) >= 0) || (StringUtil.Find(FindPiercingName ,"piercing nipple",0) >= 0)
		FindPiercingFound = FindPiercingFound || (StringUtil.Find(FindPiercingName ,"nipplering",0) >= 0) || (StringUtil.Find(FindPiercingName ,"nipple ring",0) >= 0) || (StringUtil.Find(FindPiercingName ,"nipplesring",0) >= 0)
		if (ItemSlot == kSlotMask46)
			FindPiercingFound = FindPiercingFound || (StringUtil.Find(FindPiercingName ,"Piercings top",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Piercings simple top",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Pierce A",0) >= 0)		
		endif
		if FindPiercingFound 
			FindPiercingIsStud =  (FindPiercingName == "Nipplering Silver")
;			FindPiercingIsStarter = FindPiercingIsStud 
		endif
	   elseif PSlot == 11
		FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Piercing Labia",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Vaginal Piercing",0) >= 0) || (StringUtil.Find(FindPiercingName ,"labiarings",0) >= 0)
		FindPiercingFound = FindPiercingFound || (StringUtil.Find(FindPiercingName ,"labia ring",0) >= 0) || ( (StringUtil.Find(FindPiercingName ,"AH1",0) >= 0) && (StringUtil.Find(FindPiercingName ,"(lp)",0) >= 0) )
		FindPiercingFound = FindPiercingFound && !(StringUtil.Find(FindPiercingName ,"16 labia rings",0) >= 0) 		; 16 labia rings aren't clit piercing
		if FindPiercingFound 
			FindPiercingIsStud =  (FindPiercingName == "Piercing Labia Gold")
;			FindPiercingIsStarter = FindPiercingIsStud 
		endif
	   elseif PSlot == 12
		FindPiercingFound = (StringUtil.Find(FindPiercingName ,"Piercing Labiasmall",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Labiarings",0) >= 0) || (StringUtil.Find(FindPiercingName ,"Chastity Piercing",0) >= 0)
		FindPiercingFound = FindPiercingFound || (StringUtil.Find(FindPiercingName ,"chastity ring set",0) >= 0) || (StringUtil.Find(FindPiercingName ,"16 Labia rings",0) >= 0)
		if ChastityLabiaRings != NONE 
			FindPiercingFound = FindPiercingFound || (FindPiercingForm == ChastityLabiaRings)
		endif
		if FindPiercingFound 
			FindPiercingIsStud =  (FindPiercingName == "16 labia rings") || (FindPiercingForm == ChastityLabiaRings)
			FindPiercingIsStarter = FindPiercingIsStud 
		endif
	   endif
; ####################################  add for all other slots
	endif
	return FindPiercingFound
EndFunction

;=====================

Function RemovePiercing(int PSlot, int ItemSlot)  		; unconditional remove of Piercings from slot
	if FindPiercing(PSlot, ItemSlot)
		PlayerActor.UnequipItem(FindPiercingForm)
	endif
EndFunction

Function DropPiercing(int PSlot, int ItemSlot)  		; unconditional dropping Piercings from slot to the ground
	if FindPiercing(PSlot,ItemSlot)
		PlayerActor.DropObject(FindPiercingForm)
	endif
EndFunction

int Function ValidatePiercings(int PSlot, int ItemSlot)   ; removes Piercings worn against the rules. If a piercing is properly worn in the slot, then "1" will be returned
	FindPiercing(PSlot, ItemSlot)
	if FindPiercingFound
		if (PiercingStage[PSlot] <= 0)
			Debug.Notification("The "+FindPiercingName+" slip"+PluralS(!PiercingSlotNamePlural[PSlot])+"from your"+PiercingSlotName[PSlot]+ ", because"+It(PiercingSlotNamePlural[PSlot])+Is(PiercingSlotNamePlural[PSlot])+"n't pierced.")
			PlayerActor.UnequipItem(FindPiercingForm)
			if PSlot == 1
				StartEarPiercingQuest()
			endif	
			PiercingStage[PSlot] = 0
			return 0
		else
		    if PSlot == 1
			TodayEarrings = true
		    endif
		    if (PiercingStage[PSlot] == 1) && !FindPiercingIsStarter
			Debug.Notification("You may only wear starter studs in your"+PiercingSlotName[PSlot]+" piercing"+PluralS(PiercingSlotNamePlural[PSlot])+"at this time.")
			PlayerActor.UnequipItem(FindPiercingForm)
			return 0
		    elseif (PiercingStage[PSlot] == 2) && !FindPiercingIsStud
			Debug.Notification("You may only wear studs in your"+PiercingSlotName[PSlot]+" piercing"+PluralS(PiercingSlotNamePlural[PSlot])+"at this time.")
			PlayerActor.UnequipItem(FindPiercingForm)
			return 0
		    else
			return 1
	            endif
		endif
	else
		return 0
	endif
EndFunction

Keyword Property zadNipplePiercingKeyword Auto ; 0x0000CA39
Keyword Property zadVaginalPiercingKeyword Auto ; 0x00023E70
; Keyword Property zadBootsPiercingKeyword Auto ; 0x0A027F29

bool Function DeviousNipplePiercingWorn()
;	zadNipplePiercingKeyword = Game.GetFormFromFile(0x0000CA39,"Devious Devices - Assets.esm") as keyword
;	if zadNipplePiercingKeyword==NONE
;		return false
;	else
		return PlayerActor.WornHasKeyword(zadNipplePiercingKeyword)
;	endif
endfunction

bool Function DeviousClitPiercingWorn()
;	zadVaginalPiercingKeyword = Game.GetFormFromFile(0x00023E70,"Devious Devices - Assets.esm") as keyword
;	if zadVaginalPiercingKeyword==NONE
;		return false
;	else
		return PlayerActor.WornHasKeyword(zadVaginalPiercingKeyword)
;	endif
endfunction

; pierced nipples + clit effect
; 00048597   00048598
; "Devious Devices - Integration.esm"

Spell Property DDPiercedNipples Auto
Spell Property DDPiercedClit Auto

Function StumbleAnimation(int SoundToPlay, bool PlaywhenNotRunning = false)
	bool playanims = MCMValues.ShowAnimations && ((PlaywhenNotRunning  && (PlayerActor.GetSleepState() == 0) && (PlayerActor.GetSitState() == 0))|| PlayerActor.IsRunning() || PlayerActor.IsSprinting()) && (StorageUtil.GetIntValue(PlayerActor,"DCUR_SceneRunning") == 0) && !PlayerActor.IsBleedingOut() && !PlayerActor.IsUnconscious()
	SendModEvent("dhlp-Suspend")
;	if playanims && ValidatePlayer() && (PlayerActor.IsRunning() || PlayerActor.IsSprinting()) && HeelsTicker.HeelTrainingStatus > 35 
;		PlayerActor.PushActorAway(PlayerActor, 0)
;		PlayerActor.ApplyHavokImpulse(PlayerActor.GetAngleX(), PlayerActor.GetAngleY(), -0.5, 150)
;		Utility.Wait(1.5)
;	endif		

	if playanims && ValidatePlayer()
		Debug.SendAnimationEvent(PlayerActor,"BleedOutStart")
	endif		
;	somespell.remoteCast(PlayerActor,PlayerActor,PlayerActor)
	if SoundToPlay>0
		PlayYpsSound(SoundToPlay,0.0,0.2)
	else
		Utility.Wait(1.5)
	endif
	if playanims && ValidatePlayer()
		Debug.SendAnimationEvent(PlayerActor,"BleedOutStop")	
	endif		
	SendModEvent("dhlp-Resume")
endfunction

;===================================
;===================================
;===================================


int FineForDroppingPiercings

Function CheckPlayerPiercings(int PSlot, bool CheckHealingProcess)
; the backbone of the script: 1. checks whether Piercings are worn according to the rules; 2. removes piercings, if 2 or more are worn; 3. checks piercing healing process
	int PiercingsFound = 0	; total number of Piercings found
	bool SlotPierced = PlayerActor.HasPerk(PiercedPerk[PSlot]) 
	bool DeviousPiercingWorn
	bool SamePiercingWorn
	PiercingCostDifference =  PlayerActor.GetItemCount(Gold001) - ShowPiercingCost()
	DeviousPiercingWorn = ((Pslot==10)&&DeviousNipplePiercingWorn()) || ((Pslot==11)&&DeviousClitPiercingWorn())
	if !SlotPierced && DeviousPiercingWorn ; no pierced perk but Devious piercings worn
		SlotPierced == true
		PlayerActor.AddSpell(PiercedSpell[PSlot])
		PiercingHoleFilledSince[PSlot] =  Utility.GetCurrentGameTime()	
		WeldStatus[PSlot] = 60
	endif
	if  (PiercingStage[PSlot] <= 0) && SlotPierced 				; if new pierced holes are detected, the healing time start needs to be adjusted
		PiercingHoleEmptySince[PSlot] = Utility.GetCurrentGameTime() 
		NoPiercingHoleMessageSince[PSlot] = Utility.GetCurrentGameTime() 
		PiercingStage[PSlot] = 1
		UpdateStageVariables(PSlot)
	endif
    if DeviousPiercingWorn
		PiercingWeldedToPlayer[PSlot] = false
		RemoveStudPiercing(PSlot,NONE,true)
;		WeldStatus[PSlot] = 60	; ??? Devious devices are not considered to be welded
		RemovePiercing(PSlot, kSlotMask32)
		RemovePiercing(PSlot, kSlotMask43)
		RemovePiercing(PSlot, kSlotMask44)
		RemovePiercing(PSlot, kSlotMask45)
		RemovePiercing(PSlot, kSlotMask46)
		RemovePiercing(PSlot, kSlotMask49)
		RemovePiercing(PSlot, kSlotMask50)
		RemovePiercing(PSlot, kSlotMask51)
		RemovePiercing(PSlot, kSlotMask53)
		RemovePiercing(PSlot, kSlotMask54)
		RemovePiercing(PSlot, kSlotMask55)
		RemovePiercing(PSlot, kSlotMask56)
		RemovePiercing(PSlot, kSlotMask57)
		RemovePiercing(PSlot, kSlotMask60)
		PiercingsFound = 1
    else
      if (PiercingStage[PSlot] <= 0)
		if PSlot==10 ; for nipples/clit: if slots are not pierced, then remove DD piercing perks
;			DDPiercedNipples = Game.GetFormFromFile(0x00048597,"Devious Devices - Integration.esm") as spell
;			if DDPiercedNipples != NONE
				PlayerActor.RemoveSpell(DDPiercedNipples)
;			endif
		elseif PSlot==11
;			DDPiercedClit = Game.GetFormFromFile(0x00048598,"Devious Devices - Integration.esm") as spell
;			if DDPiercedClit != NONE
				PlayerActor.RemoveSpell(DDPiercedClit)
;			endif
		endif
      endif

      PiercingWeldedToPlayer[PSlot] = (WeldStatus[PSlot] >= 90) && (WeldStatus[PSlot] <= 95)  ; 90 or 92 or 95


      if !PiercingStudWorn[PSlot]
	; ########### remember to add all other used slotmasks here! also in the routine about 10-30 lines below!
		PiercingsFound = ValidatePiercings(PSlot,kSlotMask43) + ValidatePiercings(PSlot,kSlotMask44) + ValidatePiercings(PSlot,kSlotMask45) + ValidatePiercings(PSlot,kSlotMask46) + ValidatePiercings(PSlot,kSlotMask49) + ValidatePiercings(PSlot,kSlotMask50) + ValidatePiercings(PSlot,kSlotMask51)
		PiercingsFound += ValidatePiercings(PSlot,kSlotMask32) + ValidatePiercings(PSlot,kSlotMask53) + ValidatePiercings(PSlot,kSlotMask54) + ValidatePiercings(PSlot,kSlotMask55) + ValidatePiercings(PSlot,kSlotMask56) + ValidatePiercings(PSlot,kSlotMask57) + ValidatePiercings(PSlot,kSlotMask60)

		NewPiercingForm = PlayerActor.GetWornForm(OldMainPiercingSlot[PSlot])		
				; check the form of the Piercing in the slot where the previous piercing was worn (could be empty now, or an item not fitting to piercing slot, that is ok)
		if PiercingWeldedToPlayer[PSlot] || LockPiercings
			if (OldPiercingForm[PSlot] == NONE) && !LockPiercings ; update welded status if OldForm is no longer there
				Debug.Notification("The piercing has magically disappeared from your"+PiercingSlotName[PSlot]+".")
				WeldStatus[PSlot] = 0 ; terminate welding
			elseif (OldPiercingForm[PSlot].Getname() == "")	&& !LockPiercings
				Debug.Notification("The piercing has magically vanished from your"+PiercingSlotName[PSlot]+".")
				WeldStatus[PSlot] = 0
			elseif (NewPiercingForm != OldPiercingForm[PSlot])   ; welded piercing was removed?
;Debug.Notification( "["+OldPiercingForm[PSlot].Getname()+"]"+(OldPiercingForm[PSlot] == NONE ) + "---"+(NewPiercingForm == NONE) )
				Debug.Notification(OldPiercingForm[PSlot].Getname() + " are firmly welded to your"+PiercingSlotName[PSlot]+".")
	;			PlayerActor.UnequipItemSlot(OldMainPiercingSlot[PSlot])	; remove all items from this slot

				if (PlayerActor.GetItemCount(OldPiercingForm[PSlot]) <= 0) && MCMValues.FineDroppingBoundItems && !LockPiercings ; player has dropped item
					FineForDroppingPiercings = OldPiercingForm[PSlot].GetGoldValue() * 3 + BaseFine
					AddPlayerFine(FineForDroppingPiercings)
	;				if FineForDroppingPiercings > PlayerActor.GetItemCount(Gold001)
	;					PlayerFine += FineForDroppingPiercings-PlayerActor.GetItemCount(Gold001)
	;				endif
					StumbleAnimation(0,true)
	;				PlayerActor.RemoveItem(Gold001,FineForDroppingPiercings)
					Debug.Notification("You suddenly thought to have lost your " + OldPiercingForm[PSlot].Getname() + ". Fortunately it was but a dream.")
					Debug.Notification("To salve your conscience, you decide to donate "+FineForDroppingPiercings+" coins to Dibella's Beauty Fund.")
				endif
				if (PlayerActor.GetItemCount(OldPiercingForm[PSlot]) >= 1) || ((PlayerActor.GetItemCount(OldPiercingForm[PSlot]) <= 0) && (OldPiercingForm[PSlot].Getname() != "") && MCMValues.BoundItemsReappear)
					PlayerActor.Equipitem(OldPiercingForm[PSlot],false,true)
				endif

				Utility.Wait(0.05) ; need to wait a bit here


				if !(PlayerActor.GetWornForm(OldMainPiercingSlot[PSlot]) == OldPiercingForm[PSlot]) ; failed to wear old item, e.g. just equipped some new DD items
					if Utility.Randomint(1,150) == 1
						Debug.Notification("You somehow are afraid that your " + OldPiercingForm[PSlot].Getname() + " might not be showing up and feel sad about it.")
						StumbleAnimation(8,true)
					endif
					return ; it is important to skip the piercing checking below!
	;				Debug.Notification("Your adornment "+OldPiercingForm[PSlot].Getname()+" has magically been removed from your"+PiercingSlotName[PSlot]+".")
	;				WeldStatus[PSlot] = 0 ; terminate welding
				endif

				NewPiercingForm = OldPiercingForm[PSlot]
				NewMainPiercingslot = OldMainPiercingSlot[PSlot]
			endif
		endif

		SamePiercingWorn = (NewPiercingForm == OldPiercingForm[PSlot]) && (NewPiercingForm != NONE) && (NewPiercingForm.Getname() != ""); if string is empty, there there is nothing worn at all, in particular not the same piercing!

		if (PiercingsFound >= 2) && !MCMValues.AllowMultiPiercingsVal
			if SamePiercingWorn 		; removing all slots except the current one
				if OldMainPiercingSlot[PSlot] != kSlotMask32
					RemovePiercing(PSlot, kSlotMask32)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask43
					RemovePiercing(PSlot, kSlotMask43)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask44
					RemovePiercing(PSlot, kSlotMask44)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask45
					RemovePiercing(PSlot, kSlotMask45)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask46
					RemovePiercing(PSlot, kSlotMask46)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask49
					RemovePiercing(PSlot, kSlotMask49)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask50
					RemovePiercing(PSlot, kSlotMask50)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask51
					RemovePiercing(PSlot, kSlotMask51)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask53
					RemovePiercing(PSlot, kSlotMask53)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask54
					RemovePiercing(PSlot, kSlotMask54)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask55
					RemovePiercing(PSlot, kSlotMask55)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask56
					RemovePiercing(PSlot, kSlotMask56)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask57
					RemovePiercing(PSlot, kSlotMask57)
				endif
				if OldMainPiercingSlot[PSlot] != kSlotMask60
					RemovePiercing(PSlot, kSlotMask60)
				endif
			else						; remove all Piercings
				RemovePiercing(PSlot, kSlotMask32)
				RemovePiercing(PSlot, kSlotMask43)
				RemovePiercing(PSlot, kSlotMask44)
				RemovePiercing(PSlot, kSlotMask45)
				RemovePiercing(PSlot, kSlotMask46)
				RemovePiercing(PSlot, kSlotMask49)
				RemovePiercing(PSlot, kSlotMask50)
				RemovePiercing(PSlot, kSlotMask51)
				RemovePiercing(PSlot, kSlotMask53)
				RemovePiercing(PSlot, kSlotMask54)
				RemovePiercing(PSlot, kSlotMask55)
				RemovePiercing(PSlot, kSlotMask56)
				RemovePiercing(PSlot, kSlotMask57)
				RemovePiercing(PSlot, kSlotMask60)
			endif
		endif

	; after all this is done, check again what piercing now is actually worn:

		PiercingsFound = 1	; first assume an Piercing is found
		if FindPiercing(PSlot, kSlotMask32)
			NewMainPiercingSlot = kSlotMask32
		elseif FindPiercing(PSlot, kSlotMask43)
			NewMainPiercingSlot = kSlotMask43
		elseif FindPiercing(PSlot, kSlotMask44)
			NewMainPiercingSlot = kSlotMask44
		elseif FindPiercing(PSlot, kSlotMask45)
			NewMainPiercingSlot = kSlotMask45
		elseif FindPiercing(PSlot, kSlotMask46)
			NewMainPiercingSlot = kSlotMask46
		elseif FindPiercing(PSlot, kSlotMask49)
			NewMainPiercingSlot = kSlotMask49
		elseif FindPiercing(PSlot, kSlotMask50)
			NewMainPiercingSlot = kSlotMask50
		elseif FindPiercing(PSlot, kSlotMask51)
			NewMainPiercingSlot = kSlotMask51
		elseif FindPiercing(PSlot, kSlotMask53)
			NewMainPiercingSlot = kSlotMask53
		elseif FindPiercing(PSlot, kSlotMask54)
			NewMainPiercingSlot = kSlotMask54
		elseif FindPiercing(PSlot, kSlotMask55)
			NewMainPiercingSlot = kSlotMask55
		elseif FindPiercing(PSlot, kSlotMask56)
			NewMainPiercingSlot = kSlotMask56
		elseif FindPiercing(PSlot, kSlotMask57)
			NewMainPiercingSlot = kSlotMask57
		elseif FindPiercing(PSlot, kSlotMask60)
			NewMainPiercingSlot = kSlotMask60
		else
			PiercingsFound = 0
		endif
		if PiercingsFound != 0
			NewPiercingForm = PlayerActor.GetWornForm(NewMainPiercingSlot)	; piercing detected!
			if (PSlot == 1)
				if EarlobeHolesShown
					WaitForSlavetatsUnlock()
					SlavetatsLock = true
					RemoveEarlobeHoles()
					Slavetatslock = false
				endif
				if OldPiercingForm[PSlot] != NewPiercingForm ; changed earring 
					RemoveEarringBacks()
				endif
			endif
		else
			NewPiercingForm = NONE
			if (PSlot == 1)
				RemoveEarringBacks()
				if MCMValues.ShowPiercingHoles && !EarlobeHolesShown && SlotPierced
					WaitForSlavetatsUnlock()
					SlavetatsLock = true
					ShowEarlobeHoles()
					Slavetatslock = false
				endif
			endif

		endif
		
		OldMainPiercingSlot[PSlot] = NewMainPiercingSlot ; prepare for the next loop, contains present Piercing, might be empty too
		OldPiercingForm[PSlot] = NewPiercingForm
      else ;    = if PiercingStudWorn[PSlot]...
		if PSlot == 1
			TodayEarrings = true
		endif
		RemovePiercing(PSlot, kSlotMask32)
		RemovePiercing(PSlot, kSlotMask43)
		RemovePiercing(PSlot, kSlotMask44)
		RemovePiercing(PSlot, kSlotMask45)
		RemovePiercing(PSlot, kSlotMask46)
		RemovePiercing(PSlot, kSlotMask49)
		RemovePiercing(PSlot, kSlotMask50)
		RemovePiercing(PSlot, kSlotMask51)
		RemovePiercing(PSlot, kSlotMask53)
		RemovePiercing(PSlot, kSlotMask54)
		RemovePiercing(PSlot, kSlotMask55)
		RemovePiercing(PSlot, kSlotMask56)
		RemovePiercing(PSlot, kSlotMask57)
		RemovePiercing(PSlot, kSlotMask60)
		NewPiercingForm = NONE
		OldPiercingForm[PSlot] = NewPiercingForm
      endif
    endif ; DeviousPiercingWorn

	if (PSlot==1) && (PiercingStudWorn[PSlot] || (PiercingsFound >= 1)) && (NPCCommentPolishedNails != 1) && (NPCCommentSmudgedNails != 1) && (NPCCommentChippedNails != 1) && (Utility.RandomInt(1,NPCCommentRate)==1) && MCMValues.NPCCommentsVal ; NPC comment system
		NPCCommentEarrings = 1
	endif

	if CheckHealingProcess 		; this routine checks PiercingHole healing process
		; first the routine for dropping piercings, now only working for earlobes!
		if (PSlot==1) && !LockPiercings && !EarringBacksWorn && !DeviousPiercingWorn && (Utility.RandomInt(1,PiercingsDropRate) == 1) && (PiercingsDropRate != 0) && (PiercingStudWorn[PSlot] || (PiercingsFound >= 1)) && (PiercingStage[PSlot] >= 2) && (Weldstatus[PSlot] <= 60)  ;; change later to Weldstatus < 60 (!!!)
			if PiercingStudWorn[PSlot]
				RemoveStudPiercing(PSlot,NONE,true,false) ; remove piercing and don't refund the box
				Debug.Notification("You have lost your earrings. Better secure them with backs!")
			else
				DropPiercing(PSlot, NewMainPiercingSlot)
				PiercingsFound = 0
			endif
		endif
		if PiercingStudWorn[PSlot] || (PiercingsFound >= 1)
			if PiercingStage[PSlot] >= 2
				if (Weldstatus[PSlot] == 90) 
					Weldstatus[PSlot] = 92 ; Yolie still will not help unweld your piercings, but now every tick comes the chance the she will help
				elseif (Weldstatus[PSlot] == 92) &&  (Utility.RandomInt(1,PiercingUnweldRate) == 1) 
					Weldstatus[PSlot] = 95 ; now Yolie will help unweld your piercings
				endif
			endif
			if !PiercingHoleFilled[PSlot]			; if ear holes were empty before...
				if  (Utility.GetCurrentGameTime() - PiercingHoleEmptySince[PSlot] )  >= DaysHealingAllowance[PSlot] ; reset the "filled" time, but only if holes have been empty for a longer time than the grace period
					PiercingHoleFilledSince[PSlot] =  Utility.GetCurrentGameTime()	
				endif
				PiercingHoleFilled[PSlot] = true
			endif
			if  ( (Utility.GetCurrentGameTime() - PiercingHoleFilledSince[PSlot])  >= DaysUntilNextStage[PSlot] )
				IncreasePiercingStage(PSlot)
				PiercingHoleFilledSince[PSlot] =  Utility.GetCurrentGameTime()	
			elseif ( (Utility.GetCurrentGameTime() - NoPiercingHoleMessageSince[PSlot] )  >= DaysPiercingMessage[PSlot] ) && (Utility.RandomInt(1,MessageWaitTicks) == 1)
				NoPiercingHoleMessageSince[PSlot] = Utility.GetCurrentGameTime()
				ShowPiercingRandomMessage(PSlot, true)
			endif
		elseif (PiercingStage[PSlot] > 0)     	;	 player has empty piercings
			if PiercingHoleFilled[PSlot]			; if ear holes were filled before...
				PiercingHoleEmptySince[PSlot] =  Utility.GetCurrentGameTime()
				PiercingHoleFilled[PSlot] = false
			endif
			if ( (Utility.GetCurrentGameTime() - PiercingHoleEmptySince[PSlot])  >= DaysUntilClosed[PSlot] ) && !PlayerActor.HasPerk(PermanentPiercedPerk[PSlot])
				if PSlot==1
					WaitForSlavetatsUnlock()
					SlavetatsLock = true
					RemoveEarlobeHoles()
					Slavetatslock = false
				endif
				Debug.Notification("The hole"+PluralS(PiercingSlotNamePlural[PSlot])+"in your"+PiercingSlotName[PSlot]+Has(PiercingSlotNamePlural[PSlot])+" now healed up.")
				PlayerActor.RemoveSpell(PiercedSpell[PSlot])
				if PSlot==10 ; for nipples/clit also remove DD piercing perks
;					DDPiercedNipples = Game.GetFormFromFile(0x00048597,"Devious Devices - Integration.esm") as spell
;					if DDPiercedNipples != NONE
						PlayerActor.RemoveSpell(DDPiercedNipples)
;					endif
				elseif PSlot==11
;					DDPiercedClit = Game.GetFormFromFile(0x00048598,"Devious Devices - Integration.esm") as spell
;					if DDPiercedClit != NONE
						PlayerActor.RemoveSpell(DDPiercedClit)
;					endif
				endif
				SlotPierced = false
				PiercingStage[PSlot] = 0			; 0 = ears not yet pierced
				PiercingHoleEmptySince[PSlot] = 0.0 		; needed to make the grace period working
				UpdateStageVariables(PSlot)
				PiercingHoleFilled[PSlot] = false
			elseif ( (Utility.GetCurrentGameTime() - NoPiercingHoleMessageSince[PSlot] )  >= DaysPiercingMessage[PSlot] ) && (Utility.RandomInt(1,MessageWaitTicks) == 1)
				NoPiercingHoleMessageSince[PSlot] = Utility.GetCurrentGameTime()
				ShowPiercingRandomMessage(PSlot,false)
			endif
		endif
	endif


;Debug.Notification ( "Slot"+PSlot+" EmptySince " + Utility.GameTimeToString(PiercingHoleEmptySince[PSlot]) + ";  FilledSince " +  Utility.GameTimeToString(PiercingHoleFilledSince[PSlot]) )


EndFunction

;=========================================
visualeffect property FXCameraAttachBlowingFogEffect auto

sound Property WeldingSound Auto
Function PlayWeldingSound()
	int instanceID =WeldingSound.play(PlayerActor)  ; play sound from self
	Sound.SetInstanceVolume(instanceID, 1.0) 
	Utility.Wait(5.0)
	Sound.StopInstance(instanceID)
EndFunction

Function WeldMyPiercings(int PSlot, Actor akActor)
	string Actorname
	Actorname = akActor.GetActorBase().Getname()
	if PiercingWeldedToPlayer[PSlot]
		Debug.Notification("The piercings in your"+PiercingSlotName[PSlot]+" have already been welded to you.")
	else
		if !PiercingStudWorn[PSlot]
			CheckPlayerPiercings(PSlot,false)		; no need to check healing process
		endif
		if !PiercingStudWorn[PSlot] && (OldPiercingForm[PSlot] == NONE) ;OldPiercingForm[PSlot].Getname() == ""
			Debug.Notification( "You need to wear piercings in your"+PiercingSlotName[PSlot]+" before they can be soldered onto you." )
		elseif !PiercingStudWorn[PSlot] && ((OldPiercingForm[PSlot].Getname() == "") && (OldPiercingForm[PSlot] != ChastityLabiaRings)) && ((ChastityLabiaRings != NONE))
			Debug.Notification( "You need to wear piercings in your "+PiercingSlotName[PSlot]+" again before they can be soldered onto you." )
		else
			Game.DisablePlayerControls()
			if (PSlot>=9) && (PSlot <=12)	; need to show your belly
				Utility.Wait(2.0)
				PlayerActor.UnequipItemSlot(32)
			endif
			FXCameraAttachBlowingFogEffect.Play(PlayerActor)
			if (OldPiercingForm[PSlot] != NONE) && (OldPiercingForm[PSlot] == ChastityLabiaRings)
				Debug.Notification(Actorname +" begins soldering the rings to your"+PiercingSlotName[PSlot]+".")
			elseif PiercingStudWorn[PSlot]
				Debug.Notification(Actorname +" begins soldering the " + CurrentlyEquippedPiercingName[PSlot] + " to your"+PiercingSlotName[PSlot]+".")
			else
				Debug.Notification(Actorname +" begins soldering the " + OldPiercingForm[PSlot].Getname() + " to your"+PiercingSlotName[PSlot]+".")
			endif	
			Debug.SendAnimationEvent(akActor,"idlelockpick")
			PlayWeldingSound()
			Utility.Wait(2.0)
			Debug.SendAnimationEvent(akActor,"idlelockpick")
			PlayWeldingSound()
			Utility.Wait(2.0)
			Debug.Notification("It smells like hot metal...")
			Debug.SendAnimationEvent(akActor,"idlelockpick")
			PlayWeldingSound()
			Utility.Wait(2.0)
			if (OldPiercingForm[PSlot] != NONE) && (OldPiercingForm[PSlot] == ChastityLabiaRings)
				InfibScript.WeldFileInfibulation(akActor)
				Playeractor.addspell(yps_InfibulatedSpell)
				infibulated_since = Utility.GetCurrentGameTime()
			endif
			Debug.Messagebox("Done! Now you can no longer remove the piercing"+PluralS(PiercingSlotNamePlural[PSlot])+"from your"+PiercingSlotName[PSlot]+". You wonder whether this was a smart idea...")
			PlayerActor.Equipitem(OldPiercingForm[PSlot],false,true)
			if PiercingStage[PSlot] == 1
				WeldStatus[PSlot] = 90
			else
				WeldStatus[PSlot] = 92
			endif
			Game.EnablePlayerControls()
			FXCameraAttachBlowingFogEffect.Stop(PlayerActor)
		endif
	EndIf
EndFunction
Function YolieWeldMyPiercings(int PSlot)
	WeldMyPiercings(PSlot,YolieActor)
EndFunction
Function TrisWeldMyPiercings(int PSlot)
	WeldMyPiercings(PSlot,TrisActor)
EndFunction

Function UnWeldMyPiercings(int PSlot, Actor akActor)
	string Actorname
	Actorname = akActor.GetActorBase().Getname()
	if !PiercingWeldedToPlayer[PSlot]
		Debug.Notification("The piercings in your"+PiercingSlotName[PSlot]+" have not been welded to you.")
	else
		if PiercingStage[PSlot] == 1
			Debug.Notification( Actorname +" ignores your request. You should not change the piercing"+PluralS(PiercingSlotNamePlural[PSlot])+"in your freshly pierced"+PiercingSlotName[PSlot]+".")
		elseif MCMValues.UnweldWaitIndex == 3
			Debug.Notification( Actorname +" has decided that she will never help you to unsolder your piercings again.")
		else
			if !PiercingStudWorn[PSlot] && (OldPiercingForm[PSlot] == NONE)
				Debug.Notification("The piercings in your"+PiercingSlotName[PSlot]+"have magically disappeared and are no longer soldered onto you.")
			elseif !PiercingStudWorn[PSlot] && (OldPiercingForm[PSlot].Getname() == "")
				Debug.Notification("The piercings in your"+PiercingSlotName[PSlot]+"have magically vanished and are no longer soldered onto you.")
			else
				Game.DisablePlayerControls()
				if (PSlot>=9) && (PSlot <=12)	; need to show your belly
					Utility.Wait(2.0)
					PlayerActor.UnequipItemSlot(32)
					Utility.Wait(1.5)
				endif
				if PiercingStudWorn[PSlot]
					Debug.Notification( Actorname +" tries to unsolder your currently worn " + CurrentlyEquippedPiercingName[PSlot] + " from your"+PiercingSlotName[PSlot]+"...")
				else				
					Debug.Notification( Actorname +" tries to unsolder your currently worn " + OldPiercingForm[PSlot].Getname() + " from your"+PiercingSlotName[PSlot]+"...")
				endif
				PlayWeldingSound()
				Debug.Notification( "... you wait and wait...")
				PlayWeldingSound()
				Debug.Notification( "You begin to wonder whether "+akActor.GetActorBase().Getname()+ " will be able to unsolder your piercing"+PluralS(PiercingSlotNamePlural[PSlot])+"...")
				PlayWeldingSound()
				Debug.Messagebox("Finally: It smells like hot metal. Now you can remove the piercing"+PluralS(PiercingSlotNamePlural[PSlot])+"from your"+PiercingSlotName[PSlot]+" without any issues once again.")
				if !PiercingStudWorn[PSlot]
					PlayerActor.Equipitem(OldPiercingForm[PSlot],false,true)
				endif
				Game.EnablePlayerControls()
			endif
			WeldStatus[PSlot] = 0
		endif
	endif
EndFunction
Function YolieUnWeldMyPiercings(int PSlot)
	UnWeldMyPiercings(PSlot,YolieActor)
EndFunction
Function TrisUnWeldMyPiercings(int PSlot)
	UnWeldMyPiercings(PSlot,TrisActor)
EndFunction

string[] PiercingStageString
bool PiercingStageStringNotSet = true

function ShowPiercingStatus()
	if PiercingStageStringNotSet
		PiercingStageString = new string[6]
		PiercingStageString[0] = "never been pierced"
		PiercingStageString[1] = "not pierced (healed)"
		PiercingStageString[2] = "just pierced (studs only)"
		PiercingStageString[3] = "healing (studs only)"
		PiercingStageString[4] = "healing (can wear all)"
		PiercingStageString[5] = "permanently pierced"
		PiercingStageStringNotSet = false
	endif
	int i = 1
	string StatusString = "Your piercing status:\n"
	int StatusStringLines = 0
	bool ResultPartlyShown = false
	while i <= 12
		if PiercingStage[i] >= 0
			StatusString += "\n"+PiercingSlotName[i]+": "+PiercingStageString[PiercingStage[i]+1]
			StatusStringLines += 1
			if ((i==10)&&DeviousNipplePiercingWorn()) || ((i==11)&&DeviousClitPiercingWorn())
				StatusString += ", devious piercing"
			elseif (PiercingStudWorn[i] || (OldPiercingForm[i] != NONE))
				StatusString += ", piercing worn"
				if WeldStatus[i] >= 90
					StatusString += ", welded"
				endif
				if (i == 1) && EarringBacksWorn
					StatusString += "\n(secured with earring backs)"
				endif
			else
				StatusString += ", empty"
			endif
		endif
		if StatusStringLines >= 5 ; window full, need to show it
			Debug.Messagebox(StatusString)
			ResultPartlyShown = true
			StatusString = "Your piercing status (continued):\n"
			StatusStringLines = 0
		endif
		i += 1
	endwhile
	if PlayerActor.hasperk(yps_infibulated)
		StatusString += "\n Infibulated since "+UtilScript.FormatTimeDiff((Utility.GetCurrentGameTime() - infibulated_since))
		StatusStringLines += 1
	endif
	if LockPiercings
		StatusString += "\nPiercings are permanently locked to you"
		StatusStringLines += 1
	endif
	if (StatusStringLines > 0) || !ResultPartlyShown ; show empty window only when nothing has been shown so far
		Debug.Messagebox(StatusString)
	endif
endfunction


; ===================
; = BOXED PIERCINGS =
; ===================

bool EarlobeHolesShown = false
bool EarringBacksWorn = false
MiscObject Property EarringsBacksItem auto
int EarringBacksGlowColor = 0x00404040 ; silver glow color

function ShowEarlobeHoles()
	if !EarlobeHolesShown
		STEBAddTattoo(PlayerActor,"YpsFashion","PiercingHolesEarlobes",MCMValues.PiercedHolesColorInt,true,true,0,false,MCMValues.SlaveTatLock)
		EarlobeHolesShown = true
	endif
EndFunction

function RemoveEarlobeHoles()
	if EarlobeHolesShown
		SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","PiercingHolesEarlobes",true,true)
		EarlobeHolesShown = false
	endif
EndFunction

function AddEarringBacks()
	if !PiercingStudWorn[1]
		CheckPlayerPiercings(1,false)
	endif
	if !PiercingStudWorn[1] && (OldPiercingForm[1] == NONE) ; no earrings worn
		Debug.Notification("You need wear earrings before equipping earring backs.")
	elseif EarringBacksWorn
		Debug.Notification("You are already wearing earring backs.")
	elseif SlavetatsLock
		SlavetatsBusyMessagebox()
	else
		WaitForSlavetatsUnlock() 
		SlavetatsLock = true
		Utility.Wait(0.5)
		PlayYpsSound(14,0.5)
		Debug.Notification("You secure both your earrings with earring backs.")
		STEBAddTattoo(PlayerActor,"YpsFashion","PiercingEarringBacks",0,true,true,EarringBacksGlowColor,true,MCMValues.SlaveTatLock)
		PlayYpsSound(14,0.5)
		EarringBacksWorn = true
		PlayerActor.RemoveItem(EarringsBacksItem)
		SlavetatsLock = false
	endif
EndFunction

function RemoveEarringBacks()
	if EarringBacksWorn
		WaitForSlavetatsUnlock() 
		SlavetatsLock = true
		SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","PiercingEarringBacks",true,true)
		EarringBacksWorn = false
		PlayerActor.AddItem(EarringsBacksItem,1)
		SlavetatsLock = false
	endif
EndFunction

message property ypsStudChoiceMsg1 auto
message property ypsStudChoiceMsg2 auto

int function ChoosePiercingSlot()
	bool PiercingSlotChosen = false
	int PiercingSlot
	while !PiercingSlotChosen
		PiercingSlot = ypsStudChoiceMsg1.show()
		if PiercingSlot == 0
			PiercingSlotChosen = true
		elseif PiercingSlot == 8
			PiercingSlot = ypsStudChoiceMsg2.show()
			if PiercingSlot == 0
				PiercingSlotChosen = true
			elseif PiercingSlot != 6
				PiercingSlot += 7
				PiercingSlotChosen = true
			endif	
		else
			PiercingSlotChosen = true
		endif
	endwhile
	return PiercingSlot
endfunction

function UseEmptyPiercingBox(MiscObject EmptyPiercingBox)
	int PiercingSlot
	PiercingSlot = ChoosePiercingSlot()
	if (PiercingSlot == 1) && (yps04DibellaFollower.Getstage() == 340)
		DibellaQuest.AttemptRemoveEarrings()
	elseif PiercingSlot > 0
		RemoveStudPiercing(PiercingSlot,EmptyPiercingBox)
	endif
endfunction

function RemoveStudPiercing(int PiercingSlot,MiscObject EmptyPiercingBox = NONE, bool Silent = false, bool RefundBox = true)
	if PiercingStudWorn[PiercingSlot]
	    if LockPiercings
		Debug.Notification("You are not allowed to change your piercings.")
	    elseif PiercingWeldedToPlayer[PiercingSlot] 
		Debug.Notification("You can't remove " + CurrentlyEquippedPiercingName[PiercingSlot] + ", being welded to your"+PiercingSlotName[PiercingSlot]+".")
	    elseif !Silent && (PiercingSlot == 10) && (PlayerActor.WornHasKeyword(zbfWornBra) || PlayerActor.WornHasKeyword(zad_DeviousBra))
		Debug.Notification("You need to remove your chastity bra before removing your nipple piercings.")
	    elseif !Silent && ((PiercingSlot == 11) || (PiercingSlot == 12)) && (PlayerActor.WornHasKeyword(zbfWornBelt) || PlayerActor.WornHasKeyword(zad_DeviousBelt))
		Debug.Notification("You need to remove your chastity belt before removing your vaginal piercing.")
	    elseif !Silent && ((PiercingSlot == 7) || (PiercingSlot == 8)) && (PlayerActor.WornHasKeyword(zad_DeviousBlindfold) || PlayerActor.WornHasKeyword(zbfWornBlindfold ))
		Debug.Notification("You need to remove your blindfold first before removing this piercing.")
	    elseif !Silent && (PiercingSlot>=9) && (PiercingSlot <=12) && PlayerActor.GetWornForm(kSlotMask32) != NONE ; (PlayerActor.WornHasKeyword(ClothingBody) || PlayerActor.WornHasKeyword(ArmorCuirass))
		Debug.Notification("You need to remove your body clothes before removing a body piercing.")
	    elseif !Silent && (PiercingSlot>=1) && (PiercingSlot <=8) && (PlayerActor.WornHasKeyword(zbfWornHood) || PlayerActor.WornHasKeyword(zad_DeviousHood))
		Debug.Notification("You need to remove your face mask before removing this piercing.")
	    elseif !Silent && (PiercingSlot>=1) && (PiercingSlot <=8) && PlayerActor.WornHasKeyword(ArmorHelmet)
		Debug.Notification("You need to remove your helmet before removing this piercing.")
	    elseif SlavetatsLock
		SlavetatsBusyMessagebox()
	    else
		WaitForSlavetatsUnlock() 
		SlavetatsLock = true
		if !Silent
			Debug.Notification("You decide to remove the "+CurrentlyEquippedPiercingName[PiercingSlot]+" from your"+PiercingSlotName[Piercingslot]+".")
		endif
		Utility.Wait(0.1)
		PlayYpsSound(13,0.8)
		SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PiercingSlot],true,true)
		if MCMValues.ShowPiercingHoles && (PiercingSlot == 1) && !EarlobeHolesShown
			Utility.Wait(MCMValues.SlaveTatWaitTime)
			ShowEarlobeHoles()
		endif
		SlavetatsLock = false
		RemoveEarringBacks()
		PiercingStudWorn[PiercingSlot] = false
		if RefundBox
			PlayerActor.RemoveItem(EmptyPiercingBox)
			PlayerActor.AddItem(CurrentlyEquippedPiercingBox[PiercingSlot],1)
		endif	
		CurrentlyEquippedPiercingBox[PiercingSlot] = NONE
		CurrentlyEquippedPiercingTattooName[PiercingSlot] = ""
		CurrentlyEquippedPiercingName[PiercingSlot] = ""
	    endif
	elseif !Silent
		Debug.Notification("You don't wear a stud piercing in your"+PiercingSlotName[Piercingslot]+".")
	endif
EndFunction

MiscObject[] CurrentlyEquippedPiercingBox
string[] CurrentlyEquippedPiercingTattooName
string[] CurrentlyEquippedPiercingName

function EquipStudPiercing(int PiercingSlot,string PiercingTattooName,string PiercingName,MiscObject PiercingBox,MiscObject EmptyPiercingBox,int PiercingGlowColor = 0,int PiercingFlags = 0)
	CheckPlayerPiercings(PiercingSlot,false)
	if LockPiercings
		Debug.Notification("You are not allowed to change your piercings.")
	elseif OldPiercingForm[PiercingSlot] != NONE ; already wearing a piercing
		Debug.Notification("You need to remove the piercings in your"+PiercingSlotName[Piercingslot]+" first.")
	elseif PiercingStudWorn[PiercingSlot] 
		Debug.Notification("You need to remove the stud piercings in your"+PiercingSlotName[Piercingslot]+" first.")
;	elseif PiercingStage[PiercingSlot] <= 1
;		Debug.Notification(" Your pierced "+PiercingSlotName[PiercingSlot]+Is(PiercingSlotNamePlural[PiercingSlot])+" still swollen. Once healed up you can get pierced again.")
	elseif (PiercingSlot == 10) && (PlayerActor.WornHasKeyword(zbfWornBra) || PlayerActor.WornHasKeyword(zad_DeviousBra))
		Debug.Notification("You need to remove your chastity bra before inserting your nipple piercings.")
	elseif ((PiercingSlot == 11) || (PiercingSlot == 12)) && (PlayerActor.WornHasKeyword(zbfWornBelt) || PlayerActor.WornHasKeyword(zad_DeviousBelt))
		Debug.Notification("You need to remove your chastity belt before inserting a vaginal piercing.")
	elseif ((PiercingSlot == 7) || (PiercingSlot == 8)) && (PlayerActor.WornHasKeyword(zad_DeviousBlindfold) || PlayerActor.WornHasKeyword(zbfWornBlindfold ))
		Debug.Notification("You need to remove your blindfold first before inserting this piercing.")
	elseif (PiercingSlot>=9) && (PiercingSlot <=12) && PlayerActor.GetWornForm(kSlotMask32) != NONE ; (PlayerActor.WornHasKeyword(ClothingBody) || PlayerActor.WornHasKeyword(ArmorCuirass))
		Debug.Notification("You need to remove your body clothes before inserting a body piercing.")
	elseif (PiercingSlot>=1) && (PiercingSlot <=8) && (PlayerActor.WornHasKeyword(zbfWornHood) || PlayerActor.WornHasKeyword(zad_DeviousHood))
		Debug.Notification("You need to remove your face mask before inserting this piercing.")
	elseif (PiercingSlot>=1) && (PiercingSlot <=8) && PlayerActor.WornHasKeyword(ArmorHelmet)
		Debug.Notification("You need to remove your helmet before inserting this piercing.")
	elseif PiercingStage[PiercingSlot] <= 0
		Debug.Notification("The "+PiercingName+" slip"+PluralS(!PiercingSlotNamePlural[PiercingSlot])+"from your"+PiercingSlotName[PiercingSlot]+ ", because"+It(PiercingSlotNamePlural[PiercingSlot])+Is(PiercingSlotNamePlural[PiercingSlot])+"n't pierced.")
		if PiercingSlot == 1
			StartEarPiercingQuest()
		endif	
	elseif SlavetatsLock
		SlavetatsBusyMessagebox()
	else
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		CurrentlyEquippedPiercingBox[PiercingSlot] = PiercingBox
		CurrentlyEquippedPiercingTattooName[PiercingSlot] = PiercingTattooName
		CurrentlyEquippedPiercingName[PiercingSlot] = PiercingName
		if (PiercingSlot>=9) && (PiercingSlot<=12)	; need to show your belly
			Utility.Wait(1.0)
			PlayerActor.UnequipItemSlot(32)
		endif
		Debug.Notification("You open the box, take the "+PiercingName+" and place them into your pierced"+PiercingSlotName[PiercingSlot])
		PlayerActor.RemoveItem(PiercingBox,1)
		if PiercingSlotNamePlural[PiercingSlot] ; has left and right part
			Debug.Notification("First on the right side...")
			if MCMValues.ShowAnimations && ValidatePlayer()
				Debug.SendAnimationEvent(PlayerActor,"idleStudy")
			endif		
			Utility.Wait(0.1)
			PlayYpsSound(13,0.8)
			STEBAddTattoo(PlayerActor,"YpsFashion",PiercingTattooName+"R",0,true,true,PiercingGlowColor,true,MCMValues.SlaveTatLock)
			Debug.Notification("... then on the left side.")
		endif
		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStudy")
		endif		
		Utility.Wait(0.1)
		PlayYpsSound(13,0.8)
		STEBAddTattoo(PlayerActor,"YpsFashion",PiercingTattooName,0,true,true,PiercingGlowColor,true,MCMValues.SlaveTatLock)
		if PiercingSlotNamePlural[PiercingSlot]
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion",PiercingTattooName+"R",true,true)
		endif
		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStop")
		endif	
		if (PiercingSlot == 1) && EarlobeHolesShown
			RemoveEarlobeHoles()
		endif
		PiercingStudWorn[PiercingSlot] = true
		PlayerActor.AddItem(EmptyPiercingBox,1)
		SlavetatsLock = false
	endif
EndFunction

; =======================================================
; =======================================================
; =======================================================
; =======================================================
; ==================== NAIL POLISH ======================
; =======================================================
; =======================================================
; =======================================================
; =======================================================

sound Property NailPolishOpenSound Auto ; Soundtype 1
sound Property NailPolishBrushStrokeSound Auto ; Soundtype 2
sound Property RubbingSound Auto ; Soundtype 3
sound Property DryerSound Auto ; Soundtype 4
sound Property NailFileSound Auto ; Soundtype 5
sound Property SoakingSound Auto ; Soundtype 6
sound Property ScrapeSound Auto ; Soundtype 7
sound Property SobbingSound Auto ; Soundtype 8
sound Property CryingSound Auto ; Soundtype 9
sound Property CrampSound Auto ; Soundtype 10
sound Property ShavingSound Auto ; Soundtype 11
sound Property zadShortMoan Auto ; Soundtype 12
sound Property PHYChain Auto ; Soundtype 13
sound Property EarringBacksSound Auto ; Soundtype 14
sound Property ScissorsSound Auto ; Soundtype 15
sound Property WashSound Auto ; Soundtype 16
sound Property BuzzSound Auto ; Soundtype 17
sound Property RinseSound Auto ; Soundtype 18
sound Property ypsWipeSound Auto ; Soundtype 19
sound Property ypsWearNylonsSound Auto ; Soundtype 20
sound Property ypsRemoveNylonsSound Auto ; Soundtype 21
sound property YPSGirlMemoriesSM auto ; soundtype 22

Function PlayYpsSound(int Soundtype, float soundtime = 0.0, float waittime = 0.0) ; soundtime 0.0 will play default length
	; DBF - Silent mode
	int instanceID1 = -1

   if (PlayerActor.GetActorBase().GetSex() == 1) || ((Soundtype != 8) && (Soundtype != 9)) 	; only females sob and cry
		if Soundtype == 1 && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = NailPolishOpenSound.play(PlayerActor)  ; play sound from self

		elseif Soundtype == 2 && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = NailPolishBrushStrokeSound.play(PlayerActor)

		elseif Soundtype == 3  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = RubbingSound.play(PlayerActor)

		elseif Soundtype == 4  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = DryerSound.play(PlayerActor)

		elseif Soundtype == 5  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = NailFileSound.play(PlayerActor)

		elseif Soundtype == 6  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = SoakingSound.play(PlayerActor)

		elseif Soundtype == 7  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = ScrapeSound.play(PlayerActor)

		elseif Soundtype == 8  
			instanceID1 = SobbingSound.play(PlayerActor)

		elseif Soundtype == 9
			instanceID1 = CryingSound.play(PlayerActor)

		elseif Soundtype == 10
			instanceID1 = CrampSound.play(PlayerActor)

		elseif Soundtype == 11  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = ShavingSound.play(PlayerActor)

		elseif Soundtype == 12
			instanceID1 = zadShortMoan.play(PlayerActor)

		elseif Soundtype == 13  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = PHYChain.play(PlayerActor)

		elseif Soundtype == 14 && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = EarringBacksSound.play(PlayerActor)

		elseif Soundtype == 15  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = ScissorsSound.play(PlayerActor)

		elseif Soundtype == 16  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = WashSound.play(PlayerActor)

		elseif Soundtype == 17  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = BuzzSound.play(PlayerActor)

		elseif Soundtype == 18  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = RinseSound.play(PlayerActor)

		elseif Soundtype == 19  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = ypsWipeSound.play(PlayerActor)

		elseif Soundtype == 20  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = ypsWearNylonsSound.play(PlayerActor)

		elseif Soundtype == 21  && (StorageUtil.GetIntValue(none, "yps_SilentMode")==0)
			instanceID1 = ypsRemoveNylonsSound.play(PlayerActor)
		endif

		if (instanceID1 != -1)
			Sound.SetInstanceVolume(instanceID1, 1.0) 
			if soundtime == 0.0
				if (Soundtype == 3) || (Soundtype == 4) || (Soundtype == 6) || (Soundtype >= 20)
					Utility.Wait(12)
				else
					Utility.Wait(2.5)
				endif
			else
				Utility.Wait(soundtime)
			endif
			Sound.StopInstance(instanceID1)
			Utility.Wait(Waittime)  ; this time will always be waited
		endif
   endif
EndFunction

; nail polish stage: 0 = no nail polish, 10 = in process of applying nail polish
; 20 = nail polish applied and drying, 30 = nail polished smudged, 40 = nail polish dried and ok (will last a week)
; 50 = nail polish manicured (will last a month), 60 = nail polish starts chipping off, 
; 70 = only some remains of nail polish left (still need to remove them with nail polish remover!)

int NailPolishStage = 0

float NailPolishAppliedSince = 0.0
float NailPolishRemovedSince = 0.0
float NailPolishLoverSince = 0.0 ; "NPLover" means NP is applied, or not applied and still in grace period
bool NailPolishLover = false

float property NailPolishDryTime = 0.021 AutoReadOnly ; 0.04 = 1 game hour
;float property NailPolishLoverGracePeriod = 2.3 AutoReadOnly

;; MiscObject[] Property ManicurePackage Auto ; manicure packages, needed in inventory

int NailPolishDryStage = 0

Function SetNailPolishStage(int NewStage)
	if (NewStage == 0) && (NailPolishStage > 0) ; NP got removed
		NailPolishRemovedSince = Utility.GetCurrentGameTime()
	endif
	if (NewStage >= 20) && (NailPolishStage < 20) ; NP got applied
		NailPolishAppliedSince = Utility.GetCurrentGameTime()
	endif
	NailPolishStage = NewStage 
;	AdjustNailPolishEffects()
EndFunction

int CurrentNailColor = 0

Armor Property ColoredNails Auto Hidden
Armor[] Property ypsColoredNails Auto

Armor[] Property ColoredNailsForm Auto Hidden ; array to save forms, so that no GetFormFromFile call is needed
Function GetColoredNailsForm(int Color)
	ColoredNails = NONE
	if (Color >= 1) && (Color <= 10)
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(4107 + Color, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("Kaw's Claws.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x0000100B+Color,"Kaw's Claws.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
	elseif Color == 11
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(3427, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("HN66_NAILS4ALL.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x00000D63,"HN66_NAILS4ALL.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
	elseif Color == 12
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(4808, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("HN66_NAILS4ALL.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x000012C8,"HN66_NAILS4ALL.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
	elseif Color == 13
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(4810, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("HN66_NAILS4ALL.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x000012CA,"HN66_NAILS4ALL.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
	elseif Color == 14
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(4812, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("HN66_NAILS4ALL.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x000012CC,"HN66_NAILS4ALL.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
	elseif Color == 15
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(10331, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("HN66_NAILS4ALL.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x0000285B,"HN66_NAILS4ALL.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
	elseif Color == 16
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(11717, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("HN66_NAILS4ALL.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x00002DC5,"HN66_NAILS4ALL.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
	elseif Color == 17
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(3427, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("HN66mage4vanilla.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x00000D63,"HN66mage4vanilla.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
	elseif Color == 18
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(3427, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("HN66mage4vanilla.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x00000D63,"HN66mage4vanilla.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
		ColoredNails = Game.GetFormFromFile(0x00000D67,"HN66mage4vanilla.esp") as armor
	elseif Color == 19
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(3427, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("HN66mage4vanilla.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x00000D63,"HN66mage4vanilla.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
		ColoredNails = Game.GetFormFromFile(0x00000D69,"HN66mage4vanilla.esp") as armor
	elseif Color == 20
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(3435, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("HN66mage4vanilla.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x00000D6B,"HN66mage4vanilla.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
	elseif Color == 21
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(3437, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("HN66mage4vanilla.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x00000D6D,"HN66mage4vanilla.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
	elseif Color == 22
		if (ColoredNailsForm[Color] == None) 
			if game.GetModByName("SexriM - YPS Resurces.esp") != 255
				ColoredNailsForm[Color] = game.GetFormFromFile(3439, "SexriM - YPS Resurces.esp") as armor
			elseIf (Game.GetModByName("HN66mage4vanilla.esp") != 255)
				ColoredNailsForm[Color] = Game.GetFormFromFile(0x00000D6F,"HN66mage4vanilla.esp") as armor
			endif
		endif
		ColoredNails = ColoredNailsForm[Color]
	elseif (Color >= 23) && (Color <= 68) && MCMValues.UseYpsPolishedNailsVal
		ColoredNails = ypsColoredNails[Color]
	endif
EndFunction


Potion[] Property NailPolishBottle Auto ; to be set in property context menu

function GiveNailpolishBottle(int type)
	Playeractor.Additem(NailPolishBottle[type])
endfunction

bool function RemoveNailPolishBottle(int number)
	potion item = NailPolishBottle[number]
	if item != NONE
		if Game.GetPlayer().GetItemCount(item) >= 1
			Game.GetPlayer().RemoveItem(item)
			return true
		else
			return false
		endif
	else
		return false
	endif
endfunction

message property ypsWantNailExtensions auto
int property ProfessionalManicureCost = 600 autoreadonly

Function LookAndApplyManicure(string Actorname = "your assistant")
    bool DibellaQuestRunning = ( YPS04DibellaFollower.Getstage() == 410 )
    int i
    int ChosenNailColor
;;    bool ManicurePackageFound
    if (NailPolishStage != 0) && (NailPolishStage != 50) ; can remove nail polish yourself?	
		Debug.Notification("You need to remove your nail polish first.")
    elseif LockMakeup && ! DibellaQuestRunning
	Debug.Notification("You are not allowed to change your makeup.")
    else	
	if NailPolishStage == 0
		int WantNailExtension = 0
		if Game.GetModByName("HN66mage4vanilla.esp") != 255 || game.GetModByName("SexriM - YPS Resurces.esp") != 255
			if DibellaQuestRunning
				WantNailExtension = 0
			else
				WantNailExtension = ypsWantNailExtensions.show()
			endif
			Utility.Wait(0.1)
		endif
		if ( ! DibellaQuestRunning ) && (Game.GetModByName("UIExtensions.esp") == 255) ; no UIExtensions -> use this mod's menus
			string ManicureChoice
			if WantNailExtension
				ManicureChoice = "Color choices for nail extensions:\n"
				i = 17
				while i <= 22
					ManicureChoice += "\n" + (i - 16) + ": " + NailPolishColor[i]
					i += 1
				endwhile
				ManicureChoice += "\n\nCost: " + ((ProfessionalManicureCost * 1.5) as int)
				Debug.Messagebox(ManicureChoice)
				ChosenNailColor = 16 + HairScript.Picknumber(6) ; number from 1-6
			else
				bool ValidNailColorChosen = false
				while !ValidNailColorChosen
					ManicureChoice = "Color choices for nails:\n"
					if Game.GetModByName("Kaw's Claws.esp") != 255 ||  game.GetModByName("SexriM - YPS Resurces.esp") != 255
						i = 1
					elseif Game.GetModByName("HN66_NAILS4ALL.esp") != 255
						i = 11
					else
						i = 23
					endif
					int NumberOfLinesShown = 3
					while i <= 58
						ManicureChoice += "\n"
						if NumberOfLinesShown >= 12
							Debug.Messagebox(ManicureChoice + "(more...)")
							Utility.Wait(0.01)
							ManicureChoice = ""
							NumberOfLinesShown = 0
						endif
						if i <= 9
							ManicureChoice += "0" ; add leading zeroes
						endif
						ManicureChoice += i + ": " + NailPolishColor[i]
						NumberOfLinesShown += 1
						if (i == 10) && (Game.GetModByName("HN66_NAILS4ALL.esp") == 255 && Game.GetModByName("SexriM - YPS Resurces.esp") == 255)
							i = 23
						elseif i == 16
							i = 23
						elseif i == 55
							i = 57
						else
							i += 1
						endif
					endwhile
					ManicureChoice += "\n\nCost: " + ProfessionalManicureCost
					Debug.Messagebox(ManicureChoice)
					Utility.Wait(0.01)
					Debug.Messagebox("Pick a valid color code from 01 to 58")
					ChosenNailColor = HairScript.Picknumber(58)
					if (ChosenNailColor <= 10) && (Game.GetModByName("Kaw's Claws.esp") != 255 || Game.GetModByName("SexriM - YPS Resurces.esp") != 255)
						ValidNailColorChosen = true
					elseif (ChosenNailColor >= 11) && (ChosenNailColor <= 16) && ((Game.GetModByName("HN66_NAILS4ALL.esp") != 255) || (Game.GetModByName("SexriM - YPS Resurces.esp") != 255))
						ValidNailColorChosen = true
					elseif (ChosenNailColor >= 23) && (ChosenNailColor != 56)
						ValidNailColorChosen = true
					endif
				endwhile
			endif
		elseif DibellaQuestRunning ; Dibella Quest running, no choice needed
			ChosenNailColor = 30
		else  ; UIExtensions installed
			StorageUtil.StringListClear(none,"ypsUIEList")
			int[] origIndex = new int[58]
			int j=0
			bool ValidNailColorChosen = false
			while !ValidNailColorChosen
				if WantNailExtension
					i = 17
					while i <= 22
						origIndex[j] = i
						StorageUtil.StringListAdd(none,"ypsUIEList",NailPolishColor[i])
						j += 1
						i += 1
					endwhile
				else
					if Game.GetModByName("Kaw's Claws.esp") != 255 || Game.GetModByName("SexriM - YPS Resurces.esp") != 255
						i = 1
					elseif Game.GetModByName("HN66_NAILS4ALL.esp") != 255
						i = 11
					else
						i = 23
					endif
					while i <= 58
						origIndex[j] = i
						StorageUtil.StringListAdd(none,"ypsUIEList",NailPolishColor[i])
						j += 1
						if (i == 10) && (Game.GetModByName("HN66_NAILS4ALL.esp") == 255 && Game.GetModByName("SexriM - YPS Resurces.esp") == 255)
							i = 23
						elseif i == 16
							i = 23
						elseif i == 55
							i = 57
						else
							i += 1
						endif
					endwhile
				endif
				i = UIEScript.UIEGetResultFromMenu()
				if i != -1 ; not aborted
					ChosenNailColor = origIndex[i]
					ValidNailColorChosen = true
				endif
			endwhile
;************************************************************************
		endif
	else  ; already have professionaly manicured nails -> look for removal package
		Debug.Messagebox("You already have professionaly manicured nails. Please sit down to get them removed. Cost: " + ProfessionalManicureCost)
		ChosenNailColor = 0
	endif
	if ChosenNailColor > 0
		Debug.Notification("Your choice:"+NailpolishColor[ChosenNailColor])
	endif
	ApplyFingerNailPolish(NailpolishColor[ChosenNailColor],ChosenNailColor,NONE,true,Actorname,DibellaQuestRunning)
    endif
EndFunction

int[] property NailRBGColors auto ; to be set in script property section
message property NailPolishLocationMsg auto

Function ApplyNailPolish(string NailColorName, int ColorNumber, potion NailPolishItem)
	int lsButton
	bool QuestException = (ColorNumber != 0) && ( (yps04DibellaFollower.Getstage() == 360) || (yps04DibellaFollower.Getstage() == 390) )
	if (yps04DibellaFollower.Getstage() == 430)
		Debug.Notification("You begin to remove your finger nail polish...")
		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idlelockpick")
			Game.DisablePlayerControls()
		endIf
		PlayYpsSound(3,0.0,2.0)
		Debug.Messagebox("You try to rub away the polish from your finger nails, but now the colors shine even brighter! Your professionaly manicured nails are coated with an extra hard layer of nail varnish, which cannot be removed with nail polish remover lotion.")
		YPS04DibellaFollower.SetObjectiveCompleted(430)
		YPS04DibellaFollower.SetObjectiveDisplayed(440)
		YPS04DibellaFollower.Setstage(440)
		Game.EnablePlayerControls()
	elseif LockMakeup && ! QuestException
		Debug.Notification("You are not allowed to change your makeup.")
	elseif PlayerActor.IsInCombat()
		Debug.Notification("You cannot apply or remove nail polish during battle.")
		PlayerActor.Additem(NailPolishItem)
	elseif PlayerActor.IsSwimming()
		Debug.Notification("You cannot apply or remove nail polish when swimming.")
		PlayerActor.Additem(NailPolishItem)
	elseif PlayerActor.IsRunning() || PlayerActor.IsSprinting()
		Debug.Notification("You cannot apply or remove nail polish when running.")
		PlayerActor.Additem(NailPolishItem)
	elseif PlayerActor.IsOnMount()
		Debug.Notification("You cannot apply or remove nail polish while sitting on a mount.")
		PlayerActor.Additem(NailPolishItem)
	elseif SlavetatsLock
		SlavetatsBusyMessagebox()
		PlayerActor.Additem(NailPolishItem)
	elseif !ValidatePlayer()
		Debug.Notification("You cannot apply or remove nail polish right now.")
		PlayerActor.Additem(NailPolishItem)
	else
		SendModEvent("dhlp-Suspend") 
		if (yps04DibellaFollower.Getstage() == 360)
			lsButton = 0
		elseif (yps04DibellaFollower.Getstage() == 390)
			lsButton = 1
		else
			lsButton = NailPolishLocationMsg.show()
		endif
		if lsButton == 0
			ApplyFingerNailPolish(NailColorName,ColorNumber,NailPolishItem)
		else
			ApplyToeNailPolish(NailColorName,ColorNumber,NailPolishItem)
		endif
		SendModEvent("dhlp-Resume")
	endif
EndFunction

bool FingernailSmudged = false
bool DontEquipFingernails = false
bool FingernailSmallcrackle = false
bool FingernailBigcrackle = false
int CurrentFingernailColor

Function RemoveFingernailTattoo(string FingernailNumberString="")
	if FingernailBigcrackle
		FingernailNumberString = "Bigcrackle"
	elseif FingernailSmallcrackle
		FingernailNumberString = "Smallcrackle"
	elseif FingernailSmudged
		FingernailNumberString = "Smudged"
	endif
	SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","Fingernails"+FingernailNumberString,true,true)
EndFunction

; ### replace this later by MCM value?
bool FingernailGlossy = true

Function AddFingernailTattoo(string FingernailNumberString="")
	if FingernailBigcrackle
		FingernailNumberString = "Bigcrackle"
	elseif FingernailSmallcrackle
		FingernailNumberString = "Smallcrackle"
	elseif FingernailSmudged
		FingernailNumberString = "Smudged"
	endif
	STEBAddTattoo(PlayerActor,"YpsFashion","Fingernails"+FingernailNumberString,CurrentFingernailColor,true,true,0,FingernailGlossy,MCMValues.SlaveTatLock)
EndFunction

Function NPProfessionalApplication(string MsgString, int SoundCode)
	Debug.Notification(MsgString)
	PlayYpsSound(SoundCode,0.0,2.0)
EndFunction

Function PaintFingernail(string MsgString, int FingerNumber)
	Debug.Notification(MsgString)
	PlayYpsSound(2)
	if MCMValues.SlowNailPolishVal
		AddFingernailTattoo(FingerNumber+"a")
		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idlelockpick")
			Game.DisablePlayerControls()
		endif	
		if FingerNumber>1
			RemoveFingernailTattoo(FingerNumber - 1)
		endif	
		PlayYpsSound(2)
		if FingerNumber<10
			AddFingernailTattoo(FingerNumber)
		else
			AddFingernailTattoo()
		endif
		RemoveFingernailTattoo(FingerNumber+"a")
	else
		if FingerNumber<10
			AddFingernailTattoo(FingerNumber)
		else
			AddFingernailTattoo()
		endif
		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idlelockpick")
			Game.DisablePlayerControls()
		endif	
		if FingerNumber>1
			RemoveFingernailTattoo(FingerNumber - 1)
		endif	
	endif
EndFunction

Function ApplyFingerNailPolish(string NailColorName, int Color, potion NailPolishItem, bool Professional = false, string ActorName = "your assistant", bool DibellaQuestRunning = false)
    string CurrentlyWornHandItemName
	WaitForSlavetatsUnlock()
	SlavetatsLock = true
;;	if Professional && (PlayerActor.GetItemCount(ManicurePackage[Color]) == 0) 
;;		Debug.Notification("(BUG?) You need to get the corresponding manicure package before the assistant will help you.")
;;	elseif Color == 0
	if Color == 0
		; REMOVE NAIL POLISH
		if Professional
			if NailPolishStage == 0
				Debug.Notification("There is no nail polish to remove.")
			elseif NailPolishStage != 50
				Debug.Notification("You should remove the nail polish yourself.")
			else
			  bool PlayerSitState = false
			  int SitRetryCount = 6
			  while !PlayerSitState && (SitRetryCount > 0)
				SitRetryCount -= 1
				if PlayerActor.GetSitState() != 3
					Debug.Notification("Please find a place to sit down for your nail session.")
					Utility.Wait(4.5)
				else

					PlayerSitState = true
				endif
			  endwhile
			  if !PlayerSitState
				Debug.Notification("You need to sit and calm down before "+ActorName+" can help you.")
			  else
			    GetColoredNailsForm(CurrentNailColor)
			    if (PlayerActor.GetWornForm(kSlotMask33) != NONE) && (PlayerActor.GetWornForm(kSlotMask33) != ColoredNails)
				Debug.Notification("You cannot remove your nail polish while wearing an item on your hands.")
			    else
				Game.DisablePlayerControls()
				Debug.Notification(ActorName+" begins to remove your manicured nails...")
;;				PlayerActor.RemoveItem(ManicurePackage[Color])
				Utility.Wait(2.0)
				Debug.Notification("First your nails are being soaked in remover lotion.")
				PlayYpsSound(6,0.0,2.0)
				Debug.Notification("You move your fingers thoroughly in the solution.")
				PlayYpsSound(6,0.0,2.0)
				Debug.Notification("The color on your nails has now been dissolved.")
				if !MCMValues.QuickNailPolishVal
					Utility.Wait(3.2)
					NPProfessionalApplication(Actorname+" gently scratches the paint from the right thumb.",7)
					NPProfessionalApplication("Next comes the index finger of your right hand...",7)
					NPProfessionalApplication("... followed by the middle finger...",7)
					NPProfessionalApplication("... and the ring finger.",7)
					NPProfessionalApplication("Eventually "+ActorName+" removes the polish from the small finger.",7)
					NPProfessionalApplication("Now the paint from your left thumb is being removed.",7)
					NPProfessionalApplication("Next comes the index finger of your left hand...",7)
					NPProfessionalApplication("... followed by the middle finger.",7)
					NPProfessionalApplication("Just two fingers left: the ring finger...",7)
					NPProfessionalApplication("... and finally the little finger.",7)
				endif
				GetColoredNailsForm(CurrentNailColor)
				CurrentNailColor = 0
				SetNailPolishStage(0)
				TodayFingernailPolish = true ; keep note
				Debug.Notification("Now you are no longer wearing colored nails.")
				
				SetFingerNailPolishEvent(NailColor = "", Smudged = FingernailSmudged)
				if ColoredNails != NONE
					PlayerActor.UnEquipitem(ColoredNails,true,false)
					PlayerActor.RemoveItem(ColoredNails,1,true)
				endif
				AddPlayerFine(ProfessionalManicureCost)
				Game.EnablePlayerControls()
			    endif
			  endif
			endif
		elseif NailPolishStage == 0
			Debug.Notification("There is no nail polish to remove.")
			PlayerActor.Additem(NailPolishItem)
		else
		    if DontEquipFingerNails 
			ColoredNails = NONE
		    else
			GetColoredNailsForm(CurrentNailColor)
		    endif
		    if (PlayerActor.GetWornForm(kSlotMask33) != NONE) && (PlayerActor.GetWornForm(kSlotMask33) != ColoredNails)
			Debug.Notification("You cannot remove your finger nail polish while wearing an item on your hands.")
			PlayerActor.Additem(NailPolishItem)
		    else
			Game.DisablePlayerControls()
			Debug.Notification("You begin to remove your finger nail polish...")
			if MCMValues.ShowAnimations && ValidatePlayer()
				Debug.SendAnimationEvent(PlayerActor,"idlelockpick")
				Game.DisablePlayerControls()
			endif
			PlayYpsSound(3,0.0,2.0)
			if NailPolishStage == 50
				Debug.Notification("You try to rub away the polish from your finger nails, but now the colors shine even brighter! Your professionaly manicured nails are coated with an extra hard layer of nail varnish, which cannot be removed with nail polish remover lotion.")
			else
				if ColoredNails != NONE
					PlayerActor.UnEquipitem(ColoredNails,true,false)
					PlayerActor.RemoveItem(ColoredNails,1,true)
				endif
				if !MCMValues.QuickNailPolishVal
; add here removal finger by finger
				endif
				SetNailPolishStage(0)
				TodayFingernailPolish = true ; keep note
				RemoveFingernailTattoo()
				Utility.Wait(MCMValues.SlaveTatWaitTime)
				FingernailBigcrackle = false
				FingernailSmallcrackle = false
				FingernailSmudged = false
				DontEquipFingernails = false
				CurrentNailColor = 0
				Debug.Notification("You have finished removing your nail polish.")
				SetFingerNailPolishEvent(NailColor = "", Smudged = false)
			endif
			Game.EnablePlayerControls()
		    endif
		endif
	elseif Color >= 1
	  if Nailpolishstage > 0
		Debug.Notification("You need to remove the old nail polish first before it can be applied anew.")
		if !Professional
			PlayerActor.Additem(NailPolishItem)
		endif
;	  elseif PlayerActor.GetActorBase().GetSex() != 1
;		Debug.Notification("Only girls are allowed to use nail polish.")
;		if !Professional
;			PlayerActor.Additem(NailPolishItem)
;		endif
	  else
		GetColoredNailsForm(Color)
		if Professional && (ColoredNails == NONE)
			Debug.Notification("[[[Cannot find nails item for color "+NailColorName+". Did you install the corresponding mod?]]]")
			if !Professional
				PlayerActor.Additem(NailPolishItem)
			endif
		elseif (PlayerActor.GetWornForm(ColoredNails.GetSlotMask()) != NONE) || (PlayerActor.GetWornForm(kSlotMask33) != NONE) ; already wearing a hand piece
			CurrentlyWornHandItemName = PlayerActor.GetWornForm(ColoredNails.GetSlotMask()).GetName()
			if CurrentlyWornHandItemName == "" ; wearing something like DD placeholder items
				CurrentlyWornHandItemName = " some unidentified item blocking the nails slot"
			else 
				CurrentlyWornHandItemName = " your "+CurrentlyWornHandItemName 
			endif
			Debug.Notification("Before applying nail polish, you need to remove"+CurrentlyWornHandItemName+" first.")
			if !Professional
				PlayerActor.Additem(NailPolishItem)
			endif
		elseif Professional
		  bool PlayerSitState = false
		  int SitRetryCount = 6
		  while !PlayerSitState && (SitRetryCount > 0)
			SitRetryCount -= 1
			if PlayerActor.GetSitState() != 3
				Debug.Notification("Please find a place to sit down for your nail session.")
				Utility.Wait(4.5)
			else
				PlayerSitState = true
			endif
		  endwhile
		  if !PlayerSitState
			Debug.Notification("You need to sit and calm down before "+ActorName+" can help you.")
		  else
			Game.DisablePlayerControls()
			SetNailPolishStage(10)
;;			PlayerActor.RemoveItem(ManicurePackage[Color])
			if !MCMValues.QuickNailPolishVal
				NPProfessionalApplication(Actorname+" begins to file the thumb of your right hand.",5)
				NPProfessionalApplication("Next comes the index finger of your right hand...",5)
				NPProfessionalApplication("... followed by the middle finger...",5)
				NPProfessionalApplication("... and the ring finger.",5)
				NPProfessionalApplication("Eventually "+ActorName+" files the nail of the small finger.",5)
				NPProfessionalApplication("Now the your left thumb is being filed.",5)
				NPProfessionalApplication("Next comes the index finger of your left hand...",5)
				NPProfessionalApplication("... followed by the middle finger.",5)
				NPProfessionalApplication("Just two fingers left: the ring finger...",5)
				NPProfessionalApplication("... and finally the little finger.",5)
			endif
			if (Color >= 17) && (Color <= 22)
				NPProfessionalApplication(Actorname+" gently applies the glue for the extensions.",2)
				PlayYpsSound(2,0.0,2.0)
				PlayYpsSound(2,0.0,2.0)
				PlayYpsSound(2,0.0,2.0)
				PlayYpsSound(2,0.0,2.0)
				Debug.Notification(Actorname+" now attaches the nail extensions.")
				GetColoredNailsForm(17)
				PlayerActor.Equipitem(ColoredNails,false,false)
				GetColoredNailsForm(Color)
				Utility.Wait(8.0)
				NPProfessionalApplication(Actorname+" now files the nail extensions into shape.",5)
				PlayYpsSound(5,0.0,2.0)
				PlayYpsSound(5,0.0,2.0)
				PlayYpsSound(5,0.0,2.0)
			endif
			Debug.Notification(ActorName+" gently opens the nail polish bottle.")
			PlayYpsSound(1,0.0,2.0)
			Debug.Notification("An odd smell evaporates from the bottle.")
			if Color==57
				Debug.Notification("Now "+ActorName+" begins to apply red nail polish.")
			elseif Color==58
				Debug.Notification("Now "+ActorName+" begins to apply white nail polish.")
			else
				Debug.Notification("Now "+ActorName+" begins to apply"+NailColorName+" nail polish.")
			endif

			if !MCMValues.QuickNailPolishVal
				Utility.Wait(2.0)
				NPProfessionalApplication("First the thumb of your right hand.",2)
				NPProfessionalApplication("Next comes the index finger of your right hand...",2)
				NPProfessionalApplication("... followed by the middle finger.",2)
				NPProfessionalApplication(ActorName+" neatly paints the small finger of your right hand.",2)
				NPProfessionalApplication("Now she finishes your right hand by painting the ring finger.",2)
; might add another MCM option here...
				Debug.Notification("Now "+ActorName+" moves on to your left hand.")
				Utility.Wait(4.5)
				NPProfessionalApplication("She carefully paints your left thumb.",2)
				NPProfessionalApplication("Next comes the index finger of your left hand...",2)
				NPProfessionalApplication("... followed by the middle finger.",2)
				NPProfessionalApplication("She neatly paints the ring finger of your left hand...",2)
				NPProfessionalApplication("... and finishes your left hand by painting the little finger.",2)
			endif
			if (Color >= 17) && (Color <= 22) ; remove clear nail extensions
				GetColoredNailsForm(17)
				if ColoredNails != NONE
					PlayerActor.UnEquipitem(ColoredNails,true,false)
					PlayerActor.RemoveItem(ColoredNails,1,true)
				endif
				GetColoredNailsForm(Color)
			endif
			if (Color==57) || (Color==58)
				if Color==57
					GetColoredNailsForm(28) ; bright cherry
				else
					GetColoredNailsForm(47) ; white
				endif
				PlayerActor.Equipitem(ColoredNails,false,true)
				GetColoredNailsForm(Color)
				Debug.Notification("The base color has now been applied. "+ActorName+" begins blow-drying your nails.")
				if !MCMValues.QuickNailPolishVal
					PlayYpsSound(4)
					Debug.Notification("You smell the scent of freshly applied nail polish.")
					PlayYpsSound(4)
					Debug.Notification("Your nail polish begins to dry.")
				endif
				if Color==57
					Debug.Notification("Now "+ActorName+" begins to paint small white dots on your red nails.")
				else
					Debug.Notification("Now "+ActorName+" begins to paint small red dots on your white nails.")
				endif
				Utility.Wait(0.7)
				PlayYpsSound(2,0.0,2.5)
				PlayYpsSound(2,0.0,2.5)
				PlayYpsSound(2,0.0,2.5)

				PlayYpsSound(2,0.0,2.5)
				PlayYpsSound(2,0.0,2.5)
			endif

			PlayerActor.Equipitem(ColoredNails,false,false)  ; equip the final new nails
			if (Color==57) || (Color==58) ; remove red or white nails
				if Color==57
					GetColoredNailsForm(28) ; bright cherry
				else
					GetColoredNailsForm(47) ; white
				endif
				if ColoredNails != NONE
					PlayerActor.RemoveItem(ColoredNails,1,true)
				endif
				GetColoredNailsForm(Color)
			endif
			CurrentNailColor = Color
			Debug.Notification("You look at both hands again and are very satisfied with the result.")
			Utility.Wait(2.0)
			Debug.Messagebox("Finally done! However, you need to remain seated until the nail polish has completely dried. "+ActorName+" begins blow-drying your nails.")
			if !MCMValues.QuickNailPolishVal
				PlayYpsSound(4)
				Debug.Notification("You smell the scent of freshly applied nail polish.")
				PlayYpsSound(4)
				Debug.Notification("Your nail polish begins to dry.")
				PlayYpsSound(4)
				Debug.Notification("The nail polish scent begins to fade away.")
				PlayYpsSound(4)
				Debug.Notification("Your nail polish has almost dried.")
				PlayYpsSound(4)
			endif
			Debug.Messagebox("Your nail polish has completely hardened and dried. Your finger nails are now all \ncolored"+NailColorName+". How pretty!\nYour manicure will last for "+UtilScript.FormatTimeDiff(MCMValues.NailPolishDurationProfessional)) ; about "+MCMValues.NailPolishDurationProfessional as int+" days.")
			SetNailPolishStage(50)
			if ! DibellaQuestRunning
				if(Color >= 17) && (Color <= 22)
					AddPlayerFine( (ProfessionalManicureCost * 1.5) as int)
				else
					AddPlayerFine(ProfessionalManicureCost)
				endif
			endif
			Game.EnablePlayerControls()
		  endif
		else
			Game.DisablePlayerControls()
			SetNailPolishStage(10)
			Debug.Notification("You gently open the nail polish bottle.")
			PlayYpsSound(1,0.0,2.0)
			Debug.Notification("An odd smell evaporates from the bottle.")
			Debug.Notification("Now you begin to apply"+NailColorName+" nail polish.")
			CurrentFingernailColor = NailRBGColors[Color]
			if !MCMValues.QuickNailPolishVal
				Utility.Wait(2.0)
				PaintFingernail("You begin painting the thumb of your right hand.",1)
				PaintFingernail("Next comes the index finger of your right hand...",2)
				PaintFingernail("... followed by the middle finger.",3)
				PaintFingernail("You neatly paint the small finger of your right hand.",4)
				PaintFingernail("Now you finish your right hand by painting the ring finger.",5)
				Debug.Notification("Now you move on to your left hand.")
				Utility.Wait(4.5)
				PaintFingernail("You carefully paint your left thumb.",6)
				PaintFingernail("Next comes the index finger of your left hand...",7)
				PaintFingernail("... followed by the middle finger.",8)
				Debug.Notification("You are extra careful not to smudge the nail polish on your left hand.")
				Utility.Wait(3.5)
				PaintFingernail("You neatly paint the ring finger of your left hand...",9)
				PaintFingernail("... and you finish your left hand by painting the little finger.",10)
			else
				AddFingernailTattoo()
			endif
			PlayerActor.Equipitem(ColoredNails,false,false)
			Debug.Notification("You look at both hands again and are quite satisfied with the result.")
			Utility.Wait(4.0)
			Debug.Messagebox("Finally done! Your finger nails are now all \ncolored"+NailColorName+". How pretty!\nYou should avoid running around until the nail polish has completely dried.")
			if MCMValues.ShowAnimations && ValidatePlayer()
				Debug.SendAnimationEvent(PlayerActor,"idleStop")
			endif		
			TodayFingernailPolish = true ; keep note
			CurrentNailColor = Color
			NailPolishDryStage = 0
			SetNailPolishStage(20)
			Game.EnablePlayerControls()
			SetFingerNailPolishEvent(NailColor = NailPolishColor[CurrentNailColor], Smudged = FingernailSmudged)
		endif
	  endif
	endif
	SlavetatsLock = false
	if DibellaQuestRunning
		SendModEvent("yps-ToeNailsEvent",  "",30)
	endif
EndFunction

bool Function NailPolishCheck() ; returns true if status changed
	float TimeDiff
	int FineForDroppingNails
	TimeDiff = Utility.GetCurrentGameTime()-NailPolishAppliedSince
	bool NailPolishCheckResult = false
	if NailPolishStage == 20
		GetColoredNailsForm(CurrentNailColor)
		if (yps04DibellaFollower.Getstage() == 360) || ( EnableSmudging && MCMValues.SmudgeNailpolish && ((PlayerActor.GetWornForm(kSlotMask33) != NONE) && (PlayerActor.GetWornForm(kSlotMask33) != ColoredNails)) || PlayerActor.IsInCombat() || PlayerActor.IsSwimming() || PlayerActor.IsRunning() || PlayerActor.IsSprinting() ) ; PlayerActor.GetSitState() != 3
			WaitForSlavetatsUnlock()
			SlavetatsLock = true
			RemoveFingernailTattoo()
			Utility.Wait(MCMValues.SlaveTatWaitTime)
			FingernailSmudged = true
			AddFingernailTattoo()
			SlavetatsLock = false
			DontEquipFingernails = true
			GetColoredNailsForm(CurrentNailColor)
			if ColoredNails != NONE
				PlayerActor.UnEquipitem(ColoredNails,true,false)
				PlayerActor.RemoveItem(ColoredNails,1,true)
			endif
			Debug.Messagebox("Oh no! Now you have smudged your freshly painted finger nails!\nBetter don't run around before your nail polish has completely dried.")
			SetFingerNailPolishEvent(NailColor = NailPolishColor[CurrentNailColor], Smudged = FingernailSmudged)
			if (yps04DibellaFollower.Getstage() == 360)
				YPS04DibellaFollower.SetObjectiveCompleted(360)
				YPS04DibellaFollower.SetObjectiveDisplayed(370)
				YPS04DibellaFollower.Setstage(370)
			endif
			NailPolishDryStage = 0
			SetNailPolishStage(30)
			NailPolishCheckResult = true
		else
			if (TimeDiff>= NailPolishDryTime) 
				Debug.Messagebox("Your finger nail polish has completely dried. You may move around freely again.\nYour manicure will last for "+UtilScript.FormatTimeDiff(MCMValues.NailPolishDuration));  about "+MCMValues.NailPolishDuration as int+" days.")
				NailPolishDryStage = 0
				SetNailPolishStage(40)
			elseif (TimeDiff>= (NailPolishDryTime*0.17)) && (NailPolishDryStage == 0)
				NailPolishDryStage += 1
				Debug.Notification("You smell the scent of freshly applied nail polish.")
			elseif (TimeDiff>= (NailPolishDryTime*0.33)) && (NailPolishDryStage == 1)
				NailPolishDryStage += 1
				Debug.Notification("Your nail polish begins to dry.")
			elseif (TimeDiff>= (NailPolishDryTime*0.5)) && (NailPolishDryStage == 2)
				NailPolishDryStage += 1
				Debug.Notification("Better don't run around before the nail polish has dried.")
			elseif (TimeDiff>= (NailPolishDryTime*0.67)) && (NailPolishDryStage == 3)
				NailPolishDryStage += 1
				Debug.Notification("The nail polish scent begins to fade away.")
			elseif (TimeDiff>= (NailPolishDryTime*0.83)) && (NailPolishDryStage == 4)
				NailPolishDryStage += 1
				Debug.Notification("Your nail polish has almost dried.")
			endif
		endif
	endif
	if NailPolishStage >= 20 ; first check whether nails are correctly worn!
		if !DontEquipFingerNails
			GetColoredNailsForm(CurrentNailColor)
		endif
;		if !DontEquipFingerNails && (ColoredNails == NONE) ; nail mod uninstalled
;			Debug.Messagebox("The paint on your nails has magically vanished! ((Did you uninstall the nails mod?))")
;			SetNailPolishStage(0)
;		else
		  if !DontEquipFingerNails
			if (ColoredNails != NONE) && (PlayerActor.GetItemCount(ColoredNails) <= 0) && MCMValues.FineDroppingBoundItems ; player has dropped item
				FineForDroppingNails = ColoredNails.GetGoldValue() * 3 + BaseFine
;				if FineForDroppingNails > PlayerActor.GetItemCount(Gold001)
;					PlayerFine += FineForDroppingNails-PlayerActor.GetItemCount(Gold001)
;				endif
				AddPlayerFine(FineForDroppingNails)
				StumbleAnimation(0,true)
				if MCMValues.BoundItemsReappear
					PlayerActor.AddItem(ColoredNails)
				endif
;				PlayerActor.RemoveItem(Gold001,FineForDroppingNails)
				Debug.Notification("You suddenly thought to have lost your beautiful nails. Fortunately it was but a dream.")
				Debug.Notification("To salve your conscience, you decide to donate "+FineForDroppingNails+" coins to the Tamriel Beauty Fund.")
			endif
			if (PlayerActor.GetWornForm(ColoredNails.GetSlotMask()) == NONE) && ( (PlayerActor.GetItemCount(ColoredNails) >= 1) || ((PlayerActor.GetItemCount(ColoredNails) <= 0) && MCMValues.BoundItemsReappear) )  ; wearing no hand piece
				PlayerActor.Equipitem(ColoredNails,false,true)
			endif
		  endif

		  if (NailPolishStage==30) ; NPC Comment
				NPCCommentPolishedNails = 0
				NPCCommentChippedNails = 0
				if (NPCCommentEarrings != 1) && (Utility.RandomInt(1,NPCCommentRate)==1) && MCMValues.NPCCommentsVal
					NPCCommentSmudgedNails = 1
				endif
		  elseif (NailPolishStage>=60)
				NPCCommentPolishedNails = 0
				NPCCommentSmudgedNails = 0
				if (NPCCommentEarrings != 1) && (Utility.RandomInt(1,NPCCommentRate)==1) && MCMValues.NPCCommentsVal 
					NPCCommentChippedNails = 1
				endif
		  else
				NPCCommentSmudgedNails = 0
				NPCCommentChippedNails = 0
				if (NPCCommentEarrings != 1) && (Utility.RandomInt(1,NPCCommentRate)==1) && MCMValues.NPCCommentsVal
					NPCCommentPolishedNails = 1
				endif
		  endif



		  if (NailPolishStage == 40) || (NailPolishStage == 30) ; dried and ok OR smudged
			if (TimeDiff >= MCMValues.NailPolishDuration) && !PermanentMakeup
				SetNailPolishStage(60)
				NailPolishCheckResult = true
				WaitForSlavetatsUnlock()
				SlavetatsLock = true
				RemoveFingernailTattoo()
				Utility.Wait(MCMValues.SlaveTatWaitTime)
				FingernailSmallcrackle = true
				AddFingernailTattoo()
				SlavetatsLock = false
				DontEquipFingernails = true
				GetColoredNailsForm(CurrentNailColor)
				if ColoredNails != NONE
					PlayerActor.UnEquipitem(ColoredNails,true,false)
					PlayerActor.RemoveItem(ColoredNails,1,true)
				endif
				Debug.Notification("Your nail polish starts chipping off.")
			endif
		  elseif NailPolishStage == 50 ; professional manicure
			if (TimeDiff >= MCMValues.NailPolishDurationProfessional) && !PermanentMakeup
				SetNailPolishStage(60)
				NailPolishCheckResult = true
				WaitForSlavetatsUnlock()
				SlavetatsLock = true
				RemoveFingernailTattoo()
				Utility.Wait(MCMValues.SlaveTatWaitTime)
				FingernailSmallcrackle = true
				AddFingernailTattoo()
				SlavetatsLock = false
				DontEquipFingernails = true
				GetColoredNailsForm(CurrentNailColor)
				if ColoredNails != NONE
					PlayerActor.UnEquipitem(ColoredNails,true,false)
					PlayerActor.RemoveItem(ColoredNails,1,true)
				endif
				Debug.Notification("Your professional manicure starts wearing off. You can remove it yourself now with normal nail polish remover lotion.")
				NailPolishAppliedSince = Utility.GetCurrentGameTime()-MCMValues.NailPolishDuration ; readjust to normal wear off time
			endif
		  elseif NailPolishStage == 60 ; starts chipping
			if (TimeDiff >= (MCMValues.NailPolishDuration*1.37)) && !PermanentMakeup
				WaitForSlavetatsUnlock()
				SlavetatsLock = true
				RemoveFingernailTattoo()
				Utility.Wait(MCMValues.SlaveTatWaitTime)
				FingernailBigcrackle = true
				AddFingernailTattoo()
				SlavetatsLock = false
				DontEquipFingernails = true
				GetColoredNailsForm(CurrentNailColor)
				if ColoredNails != NONE
					PlayerActor.UnEquipitem(ColoredNails,true,false)
					PlayerActor.RemoveItem(ColoredNails,1,true)
				endif
				SetNailPolishStage(70)
				NailPolishCheckResult = true
				Debug.Notification("Most of your nail polish has chipped off. You really should reapply it now.")
			endif
		  elseif (NailPolishStage == 70) || (NailPolishStage == 30)  ; most worn off or smudged
			if (TimeDiff >= (MCMValues.NailPolishDuration*2.9)) && !PermanentMakeup
				SetNailPolishStage(0)
				NailPolishCheckResult = true
				WaitForSlavetatsUnlock()
				SlavetatsLock = true
				RemoveFingernailTattoo()
				Utility.Wait(MCMValues.SlaveTatWaitTime)
				SlavetatsLock = false
				FingernailBigcrackle = false
				FingernailSmallcrackle = false
				FingernailSmudged = false
				DontEquipFingernails = false
				GetColoredNailsForm(CurrentNailColor)
				if ColoredNails != NONE
					PlayerActor.UnEquipitem(ColoredNails,true,false)
				endif
				Debug.Notification("All of your nail polish has chipped off. You can reapply it now.")
				SetFingerNailPolishEvent(NailColor = "", Smudged = FingernailSmudged)
			endif
		  endif
;		endif
	endif

	if (NailPolishStage<20) ; NPC comment system

		NPCCommentPolishedNails = 0
		NPCCommentSmudgedNails = 0
		NPCCommentChippedNails = 0
	endif
	return NailPolishCheckResult
EndFunction ; NailPolishCheck()


; =======================================================
; =======================================================
; =======================================================
; =======================================================
; ====================== MAKE UP ========================
; =======================================================
; =======================================================
; =======================================================
; =======================================================

Function STEBAddTattoo(Form _form, String _section, String _name, int _color, bool _last, bool _silent, int _glowColor, bool _gloss, bool _lock)
;
; +++ The code of this function is derived from the "SlaveTats Event Bridge" mod by Weird. Courtesy of the author. Many thanks!
;
	if !_form as Actor
		return
	endIf
	string poolName = "STEB_OnAddTattoo"
	;where the search results are
	int foundTattoos = JValue.addToPool(JArray.object(), poolName)
	;the search template, based on the tattoo json
	int searchTemplate = JValue.addToPool(JValue.objectFromPrototype("{\"name\": \"" + _name + "\", \"section\":\"" + _section + "\"}"), poolName)
	int tattoo = 0
	;search for the template
	if SlaveTats.query_available_tattoos(searchTemplate, foundTattoos) ;returns true if an error ocurred
		debug.trace("[YPS] [STEB] ERROR: OnAddTattoo query error")
		JValue.cleanPool(poolName)
		return
	endIf
	;set the optional parameters
	tattoo = JArray.getObj(foundTattoos, 0)
	JMap.setInt(tattoo, "color", _color)
	if _glowColor > 0
		JMap.setInt(tattoo, "glow", _glowColor)
	endif
	if _gloss
		JMap.setInt(tattoo, "gloss", 1)
	endIf
	if _lock
		JMap.setInt(tattoo, "locked", 1)
	endIf
	if SlaveTats.add_tattoo(_form as Actor, tattoo)
		debug.trace("[YPS] [STEB] ERROR: OnAddTattoo add_tattoo error")
		JValue.cleanPool(poolName)
		return
	endIf
	if _last
		if SlaveTats.synchronize_tattoos(_form as Actor, _silent)
			Debug.Notification("[STEB] ERROR: OnAddTattoo synchronize_tattoos failed")
			JValue.cleanPool(poolName)
			return
		endif
	endIf
	JValue.cleanPool(poolName)
EndFunction


bool SlavetatsLock = false

Function WaitForSlavetatsUnlock()
	while SlavetatsLock
		Utility.Wait(MCMValues.SlaveTatWaitTime+1.0)
	endwhile
EndFunction

Function SlavetatsBusyMessagebox(string Msg = "")
	Debug.Notification("[SlaveTats is Busy. Try again in about 15 seconds.]")
EndFunction


; ===================
; ==== LIPSTICK =====
; ===================

bool LipstickApplied = false
int LipstickPct = 0 ; Lipstick cover percentage
int CurrentLipstickColor = 0
string LipStickSmudged = ""

Function RemoveLipstickTattoo(int Pct, string Smudged)
	SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","Lipstick"+Pct+Smudged,true,true)
EndFunction

Function AddLipstickTattoo(int Pct, string Smudged)
	STEBAddTattoo(PlayerActor,"YpsFashion","Lipstick"+Pct+Smudged,CurrentLipstickColor,true,true,0,MCMValues.LipstickGloss,MCMValues.SlaveTatLock)
EndFunction

float AddLipstickTime
message property LipstickThicknessMsg auto
bool CustomColorLipstick = false

keyword property zbfWornGag auto
keyword property zad_DeviousGag auto

string CurrentLipstickColorName = ""

Function ApplyLipstick(string LipstickColorName, int LipstickHexColor, potion LipstickItem)
    if LockMakeup
		Debug.Notification("You are not allowed to change your makeup.")
    elseif LipstickApplied && (LipStickSmudged == "")
		Debug.Notification("You need to remove the old lipstick before applying anew.")
		PlayerActor.Additem(LipstickItem)
    elseif PlayerActor.WornHasKeyword(zbfWornGag) || PlayerActor.WornHasKeyword(zad_DeviousGag)  ; <- this is needed only for the case that the gag plug is removed
		Debug.Notification("Although this color would look nicely on your lips, you need to remove your gag first.")
		PlayerActor.Additem(LipstickItem)
    elseif !(LipStickSmudged == "")
		Debug.Notification("Do you really want to paint on top of your smudged lipstick?")
		PlayerActor.Additem(LipstickItem)
    elseif PlayerActor.IsOnMount()
		Debug.Notification("You cannot apply lipstick when on a mount.")
		PlayerActor.Additem(LipstickItem)
    elseif SlavetatsLock
		SlavetatsBusyMessagebox()
		PlayerActor.Additem(LipstickItem)
	elseif !ValidatePlayer()
		Debug.Notification("You cannot apply lipstick right now.")
		PlayerActor.Additem(LipstickItem)
    else
		SendModEvent("dhlp-Suspend")
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		Game.DisablePlayerControls()
		if PlayerActor.IsInCombat() && EnableSmudging && MCMValues.SmudgeLipstick
			LipStickSmudged = "Smudged"
			Debug.Notification("It is not a good idea to apply lipstick during battle.")
		elseif PlayerActor.IsSwimming() && EnableSmudging && MCMValues.SmudgeLipstick
			LipStickSmudged = "Smudged"
			Debug.Notification("It is not a good idea to apply lipstick when swimming.")
		elseif (PlayerActor.IsRunning() || PlayerActor.IsSprinting()) && EnableSmudging && MCMValues.SmudgeLipstick
			LipStickSmudged = "Smudged"
			Debug.Notification("It is not a good idea to apply lipstick when running.")
		else
			Debug.Notification("Now applying"+LipstickColorName+" lipstick.")
			CurrentLipstickColorName = LipstickColorName			
		endif
		if LipstickHexColor == -1 ; Custom Color Lipstick
			CustomColorLipstick = true
			LipstickHexColor = MCMValues.LipstickCustomColorInt
			CurrentLipstickColorName = "Custom"
		endif

		int lsButton = LipstickThicknessMsg.show()
		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStudy")
		endif		
		PlayYpsSound(2,3.0)

		LipstickPct = 50+25*lsButton 

		CurrentLipstickColor = LipstickHexColor
		AddLipstickTattoo(LipStickPct,LipStickSmudged)
		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStop")
		endif		
		LipstickApplied = true
		TodayLipstick = true
		AddLipstickTime = Utility.GetCurrentGameTime()-MCMValues.DaysUntilMakeupFades*(1.0-LipStickPct/100.0)  ; modify the time
		HeelsNioScript.SleepRegister()
		Game.EnablePlayerControls()
		SlavetatsLock = false
		SendModEvent("dhlp-Resume")
		SetLipstickEvent(LipColor = LipstickColorName, Smudged = LipStickSmudged)
    endif
EndFunction

Function RemoveLipstick(potion LipstickItem)
    if yps04DibellaFollower.Getstage() == 250
		DibellaQuest.AttemptRemoveLipstick()
    elseif LockMakeup
		Debug.Notification("You are not allowed to change your makeup.")
    elseif PlayerActor.IsInCombat()
		Debug.Notification("You cannot remove lipstick when fighting.")
		PlayerActor.Additem(LipstickItem)
    elseif PlayerActor.IsSwimming()
		Debug.Notification("You cannot remove lipstick when swimming.")
		PlayerActor.Additem(LipstickItem)
    elseif PlayerActor.IsOnMount()
		Debug.Notification("You cannot remove lipstick when on a mount.")
		PlayerActor.Additem(LipstickItem)
    elseif PlayerActor.IsRunning() || PlayerActor.IsSprinting()
		Debug.Notification("You cannot remove lipstick when running.")
		PlayerActor.Additem(LipstickItem)
	elseif PlayerActor.WornHasKeyword(zbfWornGag) || PlayerActor.WornHasKeyword(zad_DeviousGag)  ; <- this is needed only for the case that the gag plug is removed
		Debug.Notification("Before removing lipstick, you need to remove your gag first.")
		PlayerActor.Additem(LipstickItem)
	elseif !LipstickApplied
		Debug.Notification("There is no lipstick to remove.")
		PlayerActor.Additem(LipstickItem)
	elseif SlavetatsLock
		SlavetatsBusyMessagebox()
		PlayerActor.Additem(LipstickItem)
	elseif !ValidatePlayer()
		Debug.Notification("You cannot remove lipstick right now.")
		PlayerActor.Additem(LipstickItem)
	else
		SendModEvent("dhlp-Suspend")
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		Game.DisablePlayerControls()
		Debug.Notification("You gently rub the color from your lips.")
		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStudy")
		endif		
		PlayYpsSound(3,3.0)

		RemoveLipstickTattoo(LipStickPct,LipStickSmudged)

		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStop")
		endif		
		Game.EnablePlayerControls()
		LipstickApplied = false 
		LipstickPct = 0
		LipStickSmudged = ""
		CustomColorLipstick = false
		SlavetatsLock = false
		SendModEvent("dhlp-Resume")
		SetLipstickEvent(LipColor = "", Smudged = "")
    endif
EndFunction

bool Function ReduceLipstickPctTo(float NewPct) ; NewPct = 0.0 ... 100.0, if greater than actual percentage then nothing happens
; will return TRUE if a new stage has been reached
	int NewPctStage
	if NewPct <= 0.0
		NewPctStage = 0
	else
		NewPctStage = 25*(4-(((100.0-NewPct)/25.0) as int))
	endif
	if NewPctStage<LipStickPct
		RemoveLipstickTattoo(LipStickPct,LipStickSmudged)
		if NewPctStage==75
			Debug.Notification("Your lipstick has lost a little of its opacity.")
		elseif NewPctStage==50
			Debug.Notification("Your lipstick has lost some of its opacity.")
		elseif NewPctStage==25
			Debug.Notification("Your lipstick has lost much of its opacity.")
		elseif NewPctStage==0
			Debug.Notification("Your lipstick has worn off.")
		endif
		LipstickPct = NewPctStage
		Utility.Wait(MCMValues.SlaveTatWaitTime)
		if LipStickPct>0
			AddLipstickTattoo(LipstickPct,LipStickSmudged)
		else
			LipstickApplied = false
			LipStickSmudged = ""
			CustomColorLipstick = false
			SetLipstickEvent(LipColor = "", Smudged = "")
		endif
		return true
	else
		return false
	endif
EndFunction

Function SmudgeLipstick()
;Debug.Notification("oh noes, smudgy...")
	if (LipStickSmudged == "") && (LipStickPct>0)
		RemoveLipstickTattoo(LipStickPct,LipStickSmudged)
		Utility.Wait(MCMValues.SlaveTatWaitTime)
		LipStickSmudged = "Smudged"
		AddLipstickTattoo(LipStickPct,LipStickSmudged)
		SetLipstickEvent(LipColor = CurrentLipstickColorName, Smudged = LipStickSmudged)
	endif
EndFunction

; float property DaysUntilLipstickFades = 0.8 autoreadonly ; days until lipstick completely fades away

bool Function CheckLipstick()
	float LSAppliedTime
	WaitForSlavetatsUnlock()
	SlavetatsLock = true
	bool LipstickReduced = false
	if LipstickApplied && !PermanentMakeup
		LSAppliedTime=Utility.GetCurrentGameTime()-AddLipstickTime
		LipstickReduced = ReduceLipstickPctTo(100.0 - (100.0*LSAppliedTime/MCMValues.DaysUntilMakeupFades))
		if (LipStickSmudged == "")
		    if (! LockMakeup) && (! PermanentMakeup) && EnableSmudging && MCMValues.SmudgeLipstick && ((LipstickPct*LipstickPct)>=Utility.RandomFloat(0.0,10000.0)) && (Utility.RandomFloat(1.0,100.0) <= MCMValues.SmudgeMakeupChance)
				if PlayerActor.IsInCombat()
					Debug.Notification("You have smeared your lipstick during combat.")
					SmudgeLipstick()
					LipstickReduced = true
				elseif PlayerActor.IsSwimming()
					Debug.Notification("You have smeared your lipstick when swimming.")
					SmudgeLipstick()
					LipstickReduced = true
				endif
		    endif
		endif
	endif
	SlavetatsLock = false
	return LipstickReduced
EndFunction

; ===================
; ==== EYESHADOW ====
; ===================
; sample tattoo name: "EyeshadowFull75Smudged"

bool EyeshadowApplied = false
int EyeshadowPct = 0 ; Eyeshadow cover percentage
int CurrentEyeshadowColor = 0
string EyeshadowSmudged = ""
string EyeshadowStyle = "Light"

Function RemoveEyeshadowTattoo(string Style, int Pct, string Smudged)
	SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","Eyeshadow"+Style+Pct+Smudged,true,true)
EndFunction


Function AddEyeshadowTattoo(string Style, int Pct, string Smudged)
	STEBAddTattoo(PlayerActor,"YpsFashion","Eyeshadow"+Style+Pct+Smudged,CurrentEyeshadowColor,true,true,0,false,MCMValues.SlaveTatLock)
EndFunction

float AddEyeshadowTime
message property EyeshadowThicknessMsg auto
message property EyeshadowStyleMsg auto
bool CustomColorEyeshadow = false
keyword property zad_DeviousBlindfold auto
keyword property zbfWornBlindfold auto

string CurrentEyeshadowColorName

Function ApplyEyeshadow(string EyeshadowColorName, int EyeshadowHexColor, MiscObject EyeshadowItem)
    if LockMakeup
		Debug.Notification("You are not allowed to change your makeup.")
    elseif EyeshadowApplied && (EyeshadowSmudged == "")
		Debug.Notification("You need to remove the old Eyeshadow before applying anew.")
	elseif PlayerActor.WornHasKeyword(zad_DeviousBlindfold) || PlayerActor.WornHasKeyword(zbfWornBlindfold )
		Debug.Notification("Although this color would look nicely on your eyelids, you need to remove your blindfold first.")
    elseif !(EyeshadowSmudged == "")
		Debug.Notification("Do you really want to paint on top of your smudged Eyeshadow?")
    elseif PlayerActor.IsOnMount()
		Debug.Notification("You cannot apply eyeshadow when on a mount.")
    elseif SlavetatsLock
		SlavetatsBusyMessagebox()
	elseif !ValidatePlayer()
		Debug.Notification("You cannot apply eyeshadow right now.")
    else
		SendModEvent("dhlp-Suspend")
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		Game.DisablePlayerControls()
		PlayerActor.RemoveItem(EyeshadowItem)
		if PlayerActor.IsInCombat() && EnableSmudging && MCMValues.SmudgeEyeshadow
			EyeshadowSmudged = "Smudged"
			Debug.Notification("It is not a good idea to apply Eyeshadow during battle.")
		elseif PlayerActor.IsSwimming() && EnableSmudging && MCMValues.SmudgeEyeshadow
			EyeshadowSmudged = "Smudged"
			Debug.Notification("It is not a good idea to apply Eyeshadow when swimming.")
		elseif (PlayerActor.IsRunning() || PlayerActor.IsSprinting()) && EnableSmudging && MCMValues.SmudgeEyeshadow
			EyeshadowSmudged = "Smudged"
			Debug.Notification("It is not a good idea to apply Eyeshadow when running.")
		else
			Debug.Notification("Now applying"+EyeshadowColorName+" Eyeshadow.")
			CurrentEyeshadowColorName = EyeshadowColorName
		endif
		if EyeshadowHexColor == -1 ; Custom Color Eyeshadow
			CustomColorEyeshadow = true
			EyeshadowHexColor = MCMValues.EyeshadowCustomColorInt
			CurrentEyeshadowColorName = "Custom"
		endif
		int lsButton = EyeshadowThicknessMsg.show()
		int stButton = EyeshadowStyleMsg.show()
		if stButton==0
			EyeshadowStyle = "Light"
		else
		EyeshadowStyle = "Full"
		endif
		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStudy")
		endif		
		PlayYpsSound(2,3.0)
		EyeshadowPct = 50+25*lsButton 
		CurrentEyeshadowColor = EyeshadowHexColor
		AddEyeshadowTattoo(EyeshadowStyle,EyeshadowPct,EyeshadowSmudged)
		SlavetatsLock = false
		if MCMValues.ShowAnimations && ValidatePlayer() 
			Debug.SendAnimationEvent(PlayerActor,"idleStop")
		endif		
		EyeshadowApplied = true
		TodayEyeshadow = true
		AddEyeshadowTime = Utility.GetCurrentGameTime()-MCMValues.DaysUntilMakeupFades*(1.0-EyeshadowPct/100.0)  ; modify the time
		HeelsNioScript.SleepRegister()
		Game.EnablePlayerControls()
		SlavetatsLock = false
		SendModEvent("dhlp-Resume")
		SetEyeShadowEvent(EyeShadowColor = EyeshadowColorName, Smudged = EyeshadowSmudged)
    endif
EndFunction

ypsDibellaQuest Property DibellaQuest Auto

Function RemoveEyeshadow(MiscObject EyeshadowItem)
    if yps04DibellaFollower.Getstage() == 250
		DibellaQuest.AttemptRemoveEyeshadow()
    elseif LockMakeup
		Debug.Notification("You are not allowed to change your makeup.")
    elseif PlayerActor.IsInCombat()
		Debug.Notification("You cannot remove eyeshadow when fighting.")
    elseif PlayerActor.IsSwimming()
		Debug.Notification("You cannot remove eyeshadow when swimming.")
    elseif PlayerActor.IsOnMount()
		Debug.Notification("You cannot remove eyeshadow when on a mount.")
    elseif PlayerActor.IsRunning() || PlayerActor.IsSprinting()
		Debug.Notification("You cannot remove eyeshadow when running.")
    elseif !EyeshadowApplied
		Debug.Notification("There is no eyeshadow to remove.")
    elseif PlayerActor.WornHasKeyword(zad_DeviousBlindfold) || PlayerActor.WornHasKeyword(zbfWornBlindfold )
		Debug.Notification("Before removing eyeshadow, you need to remove your blindfold first.")
    elseif SlavetatsLock
		SlavetatsBusyMessagebox()
	elseif !ValidatePlayer()
		Debug.Notification("You cannot removing eyeshadow right now.")
    else
		SendModEvent("dhlp-Suspend")
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		Game.DisablePlayerControls()
		PlayerActor.Removeitem(EyeshadowItem)
		Debug.Notification("You gently rub the eyeshadow from your eyes.")
		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"idleStudy")
		endif		
		PlayYpsSound(3,3.0)

		RemoveEyeshadowTattoo(EyeshadowStyle,EyeshadowPct,EyeshadowSmudged)

		if MCMValues.ShowAnimations && ValidatePlayer() 
			Debug.SendAnimationEvent(PlayerActor,"idleStop")
		endif		
		Game.EnablePlayerControls()
		EyeshadowApplied = false 
		EyeshadowPct = 0
		EyeshadowSmudged = ""
		CustomColorEyeshadow = false
		SlavetatsLock = false
		SendModEvent("dhlp-Resume")
		SetEyeShadowEvent(EyeShadowColor = "", Smudged = "")
	endif
EndFunction

FormList Property ypsEyeshadows auto
int[] property EyeshadowRGBColors auto ; to be set in script property section
MiscObject Property ypsEyeshadowItem_Remover auto
message property ypsApplyRemoveEyeshadow auto

function UseEyeshadowApplicator()
	Utility.Wait(0.01)
	int ApplyRemove = 0
	if PlayerActor.GetItemCount(ypsEyeshadowItem_Remover) > 0
		ApplyRemove = ypsApplyRemoveEyeshadow.show()
	endif
	if ApplyRemove
		RemoveEyeshadow(ypsEyeshadowItem_Remover)
	else
		if Game.GetModByName("UIExtensions.esp") == 255 ; no UIExtensions -> use this mod's menus
			;FormList EyeshadowInInventory ; This doesn't appear to do anything except log spam
			int EyeshadowsNumber = ypsEyeshadows.GetSize()
			string EyeshadowsNotification = "Eyeshadow colors found in inventory:\n"
			int i = 1
			int FoundEyeshadows = 0
			StorageUtil.IntListClear(none,"ypsEyeshadowChoiceNumber")
			StorageUtil.StringListClear(none,"ypsEyeshadowChoiceNames")
			while i <= EyeshadowsNumber
				Form Eyeshadow = ypsEyeshadows.GetAt(i - 1)
				if PlayerActor.GetItemCount(Eyeshadow) > 0
					FoundEyeshadows += 1
					;EyeshadowInInventory.AddForm(Eyeshadow) ; This doesn't appear to do anything except log spam
					String SingleName = Eyeshadow.Getname()
					int index1 = StringUtil.Find(SingleName,"(") + 1
					int index2 = StringUtil.Find(SingleName,")")
					SingleName = StringUtil.Substring(SingleName,index1,index2 - index1)
					EyeshadowsNotification += "(" + FoundEyeshadows + ") " + SingleName + "\n"
					StorageUtil.IntListAdd(none,"ypsEyeshadowChoiceNumber",i - 1)
					StorageUtil.StringListAdd(none,"ypsEyeshadowChoiceNames",SingleName)
				endif
				i += 1
			endwhile
			if FoundEyeshadows == 0
				Debug.Notification("No eyeshadow found in your inventory.")
			else
				Debug.Messagebox(EyeshadowsNotification)
				i = HairScript.Picknumber(FoundEyeshadows) - 1 ; beginning with 0
				ApplyEyeshadow(" "+StorageUtil.StringListGet(none,"ypsEyeshadowChoiceNames",i),EyeshadowRGBColors[StorageUtil.IntListGet(none,"ypsEyeshadowChoiceNumber",i)], ypsEyeshadows.GetAt(StorageUtil.IntListGet(none,"ypsEyeshadowChoiceNumber",i)) as MiscObject)
			endif
		else ; UIExtensions installed
			StorageUtil.StringListClear(none,"ypsUIEList")

			;FormList EyeshadowInInventory ; This doesn't appear to do anything except log spam
			int EyeshadowsNumber = ypsEyeshadows.GetSize()
			int i = 1
			int FoundEyeshadows = 0
			StorageUtil.IntListClear(none,"ypsEyeshadowChoiceNumber")
			StorageUtil.StringListClear(none,"ypsEyeshadowChoiceNames")
			while i <= EyeshadowsNumber
				Form Eyeshadow = ypsEyeshadows.GetAt(i - 1)
				if PlayerActor.GetItemCount(Eyeshadow) > 0
					FoundEyeshadows += 1
					;EyeshadowInInventory.AddForm(Eyeshadow) ; This doesn't appear to do anything except log spam
					String SingleName = Eyeshadow.Getname()
					int index1 = StringUtil.Find(SingleName,"(") + 1
					int index2 = StringUtil.Find(SingleName,")")
					SingleName = StringUtil.Substring(SingleName,index1,index2 - index1)
					StorageUtil.StringListAdd(none,"ypsUIEList",SingleName)
					StorageUtil.IntListAdd(none,"ypsEyeshadowChoiceNumber",i - 1)
					StorageUtil.StringListAdd(none,"ypsEyeshadowChoiceNames",SingleName)
				endif
				i += 1
			endwhile
			if FoundEyeshadows == 0
				Debug.Notification("No eyeshadow found in your inventory.")
			else
				i = UIEScript.UIEGetResultFromMenu()
				if i != -1 ; not aborted
					ApplyEyeshadow(" "+StorageUtil.StringListGet(none,"ypsEyeshadowChoiceNames",i),EyeshadowRGBColors[StorageUtil.IntListGet(none,"ypsEyeshadowChoiceNumber",i)], ypsEyeshadows.GetAt(StorageUtil.IntListGet(none,"ypsEyeshadowChoiceNumber",i)) as MiscObject)
				endif
			endif
		endif
	endif
endfunction


bool Function ReduceEyeshadowPctTo(float NewPct) ; NewPct = 0.0 ... 100.0, if greater than actual percentage then nothing happens
;Debug.Notification("reduce to "+NewPct+"%")
	int NewPctStage
	if NewPct <= 0.0
		NewPctStage = 0
	else
		NewPctStage = 25*(4-(((100.0-NewPct)/25.0) as int))
	endif
	if NewPctStage<EyeshadowPct
		RemoveEyeshadowTattoo(EyeshadowStyle,EyeshadowPct,EyeshadowSmudged)
		if NewPctStage==75
			Debug.Notification("Your eyeshadow has lost a little of its opacity.")
		elseif NewPctStage==50
			Debug.Notification("Your eyeshadow has lost some of its opacity.")
		elseif NewPctStage==25

			Debug.Notification("Your eyeshadow has lost much of its opacity.")
		elseif NewPctStage==0
			Debug.Notification("Your eyeshadow has worn off.")
		endif
		EyeshadowPct = NewPctStage
		Utility.Wait(MCMValues.SlaveTatWaitTime)
		if EyeshadowPct>0
			AddEyeshadowTattoo(EyeshadowStyle,EyeshadowPct,EyeshadowSmudged)
		else
			EyeshadowApplied = false
			EyeshadowSmudged = ""
			CustomColorEyeshadow = false
			SetEyeShadowEvent(EyeShadowColor = "", Smudged = "")
		endif
		return true
	else
		return false		
	endif
EndFunction

Function SmudgeEyeshadow()
	if (EyeshadowSmudged == "") && (EyeshadowPct>0)
		RemoveEyeshadowTattoo(EyeshadowStyle,EyeshadowPct,EyeshadowSmudged)
		Utility.Wait(MCMValues.SlaveTatWaitTime)
		EyeshadowSmudged = "Smudged"
		AddEyeshadowTattoo(EyeshadowStyle,EyeshadowPct,EyeshadowSmudged)
		SetEyeShadowEvent(EyeShadowColor = CurrentEyeshadowColorName, Smudged = EyeshadowSmudged)
	endif
EndFunction

; float property DaysUntilEyeshadowFades = 0.8 autoreadonly ; days until Eyeshadow completely fades away

bool Function CheckEyeshadow()
	float LSAppliedTime
	WaitForSlavetatsUnlock()
	SlavetatsLock = true
	bool EyeshadowReduced = false
	if EyeshadowApplied && !PermanentMakeup
		LSAppliedTime=Utility.GetCurrentGameTime()-AddEyeshadowTime
		EyeshadowReduced = ReduceEyeshadowPctTo(100.0 - (100.0*LSAppliedTime/MCMValues.DaysUntilMakeupFades))
		if (EyeshadowSmudged == "")
		    if (! LockMakeup) && (! PermanentMakeup) && EnableSmudging && MCMValues.SmudgeEyeshadow && ((EyeshadowPct*EyeshadowPct)>=Utility.RandomFloat(0.0,10000.0)) && (Utility.RandomFloat(1.0,100.0) <= MCMValues.SmudgeMakeupChance)
			if PlayerActor.IsInCombat()
				Debug.Notification("You have smeared your eyeshadow during combat.")
				SmudgeEyeshadow()
				EyeshadowReduced = true
			elseif PlayerActor.IsSwimming()
				Debug.Notification("You have smeared your eyeshadow when swimming.")
				SmudgeEyeshadow()
				EyeshadowReduced = true
			endif
		    endif
		endif
	endif
	SlavetatsLock = false
	return EyeshadowReduced
EndFunction

; ===================
; ====  TOENAILS ====
; ===================


bool ToenailpolishApplied = false
int CurrentToenailColor = 0
bool ToenailSmudged = false
bool ToenailSmallcrackle = false
bool ToenailBigcrackle = false
bool ToenailGlossy = true
int ToenailPolishStage = 0 ; 0 = no polish, 10 = in process of applying, 20 = applied and drying, 30 = smudged, 40 = nail polish dried, 50 = manicured, 60 = starts chipping, 70 = only some remains left
float ToenailPolishAppliedSince = 0.0
float ToenailPolishRemovedSince = 0.0
bool CustomColorToenailPolish = false

Function RemoveToenailTattoo(string ToenailNumberString="")
	if ToenailBigcrackle
		ToenailNumberString = "Bigcrackle"
	elseif ToenailSmallcrackle
		ToenailNumberString = "Smallcrackle"
	elseif ToenailSmudged
		ToenailNumberString = "Smudged"
	endif
	SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","Toenails"+ToenailNumberString,true,true)
EndFunction

Function AddToenailTattoo(string ToenailNumberString="", bool last = true)
	if ToenailBigcrackle
		ToenailNumberString = "Bigcrackle"
	elseif ToenailSmallcrackle
		ToenailNumberString = "Smallcrackle"
	elseif ToenailSmudged
		ToenailNumberString = "Smudged"
	endif
	STEBAddTattoo(PlayerActor,"YpsFashion","Toenails"+ToenailNumberString,CurrentToenailColor,last,true,0,ToenailGlossy,MCMValues.SlaveTatLock)
EndFunction

Function SetToenailPolishStage(int NewStage)
	if (NewStage == 0) && (ToenailPolishStage > 0) ; NP got removed
		ToenailPolishRemovedSince = Utility.GetCurrentGameTime()
	endif
	if (NewStage >= 20) && (ToenailPolishStage < 20) ; NP got applied
		ToenailPolishAppliedSince = Utility.GetCurrentGameTime()
	endif
	ToenailPolishStage = NewStage 
EndFunction

Armor Property CinderellaFeetItem Auto

form[] property OpenSlaveboots auto hidden ; space to save DD slaveboots, so that no GetFormFromFile call is needed

armor property yps_SlaveBoots Auto

bool Function OpenSlavebootsWorn()  ; some slave boots allow application of toenail polish
	bool OpenBootResult = false
	form WornBoots = PlayerActor.GetWornForm(kSlotMask37)
	if (WornBoots == NONE) || (WornBoots == yps_SlaveBoots) || (StringUtil.Find(WornBoots.Getname(),"Slave Boots") >= 0) || (WornBoots == CinderellaFeetItem)
		return true
	elseif OpenSlaveboots[1] == NONE
		OpenSlaveboots[1] = Game.GetFormFromFile(0x000048b9,"Devious Devices - Expansion.esm") 
	endif
	if WornBoots == OpenSlaveboots[1]
		return true
	elseif OpenSlaveboots[2] == NONE
		OpenSlaveboots[2] = Game.GetFormFromFile(0x00002dc8,"Devious Devices - Expansion.esm")
	endif
	if WornBoots == OpenSlaveboots[2]
		return true
	elseif Game.GetModByName("Deviously Cursed Loot.esp") != 255
		if OpenSlaveboots[3] == NONE
			OpenSlaveboots[3] = Game.GetFormFromFile(0x0004b5ce,"Deviously Cursed Loot.esp")
		endif
		if WornBoots == OpenSlaveboots[3]
			return true
		elseif OpenSlaveboots[4] == NONE
			OpenSlaveboots[4] = Game.GetFormFromFile(0x000a139d,"Deviously Cursed Loot.esp")
		endif
		if WornBoots == OpenSlaveboots[4]
			return true
		elseif OpenSlaveboots[5] == NONE
			OpenSlaveboots[5] = Game.GetFormFromFile(0x00017ca1,"Deviously Cursed Loot.esp")
		endif
		if WornBoots == OpenSlaveboots[5]
			return true
		elseif OpenSlaveboots[6] == NONE
			OpenSlaveboots[6] = Game.GetFormFromFile(0x0000b9fc,"Deviously Cursed Loot.esp")
		endif
		if WornBoots == OpenSlaveboots[6]
			return true
		elseif OpenSlaveboots[7] == NONE
			OpenSlaveboots[7] = Game.GetFormFromFile(0x0002ab3d,"Deviously Cursed Loot.esp") ; shock boots
		endif
		if WornBoots == OpenSlaveboots[7]
			return true
		else
			return false
		endif

	else
		return false
	endif
EndFunction

Function PaintToenail(string MsgString, int ToeNumber) ; paint a single toenail
	Debug.Notification(MsgString)
	PlayYpsSound(2)
	AddToenailTattoo(ToeNumber)
	if ToeNumber>1
		RemoveToenailTattoo(ToeNumber - 1)
	endif
EndFunction

string CurrentToenailColorName = ""

Function ApplyToeNailPolish(string ToenailColorName, int ColorNumber, potion TonailPolishItem)
    bool QuestException = (ColorNumber != 0) && (yps04DibellaFollower.Getstage() == 390)
    if LockMakeup && ! QuestException
		Debug.Notification("You are not allowed to change your makeup.")
    elseif !OpenSlavebootsWorn()  ; PlayerActor.GetWornForm(kSlotMask37) != NONE
		Debug.Notification("You need to remove your shoes before applying or removing toenail polish.")
		PlayerActor.Additem(TonailPolishItem)
    elseif PlayerActor.IsOnMount()
		Debug.Notification("You cannot apply or remove toenail polish while sitting on a mount.")
		PlayerActor.Additem(TonailPolishItem)
	elseif NylonsCurrentlyWorn
		Debug.Notification("You cannot apply or remove toenail polish when wearing nylons.")
		PlayerActor.Additem(TonailPolishItem)
    elseif SlavetatsLock
		SlavetatsBusyMessagebox()
		PlayerActor.Additem(TonailPolishItem)
	elseif !ValidatePlayer()
		Debug.Notification("You cannot apply or remove toenail polish right now.")
		PlayerActor.Additem(TonailPolishItem)
    elseif ColorNumber == 0   ; remove toenail polish
		if ToenailPolishStage == 0
			Debug.Notification("There is no toenail polish to remove.")
			PlayerActor.Additem(TonailPolishItem)
		else
			WaitForSlavetatsUnlock()
			SlavetatsLock = true
			Debug.Notification("You sit down and begin to remove your toenail polish...")
			if MCMValues.ShowAnimations  && ValidatePlayer()
				Debug.SendAnimationEvent(PlayerActor,"zazapc009")
			endif		
			Game.DisablePlayerControls()
			PlayYpsSound(3,0.0,2.0)
			;if !MCMValues.QuickNailPolishVal
			;	add here removal toe by toe
			;endif
			
			SetToenailPolishStage(0)
			RemoveToenailTattoo()
			Utility.Wait(MCMValues.SlaveTatWaitTime)
			ToenailBigcrackle = false
			ToenailSmallcrackle = false
			ToenailSmudged = false
			ToenailpolishApplied = false
			TodayToenailPolish = true ; keeping note that you had toenail polish applied today
			CurrentToenailColor = 0
			Debug.Notification("You have finished removing your toenail polish.")
			SetToeNailPolishEvent(NailColor = "", Smudged = ToenailSmudged)
			if MCMValues.ShowAnimations && ValidatePlayer()
				Debug.SendAnimationEvent(PlayerActor,"IdleForceDefaultState")	
			endif		
			SlavetatsLock = false
			Game.EnablePlayerControls()
		endif
    elseif ToenailpolishApplied
		Debug.Notification("You need to remove the old toenail polish before applying anew.")
		PlayerActor.Additem(TonailPolishItem)
    else
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		Game.DisablePlayerControls()
		int ToenailHexColor = NailRBGColors[ColorNumber]
		if PlayerActor.GetWornForm(kSlotMask37) != NONE
			Debug.Notification("You clumsily sit down reaching over your deformed feet and begin applying"+ToenailColorName+" toenail polish.")
		else
			Debug.Notification("You sit down and begin applying"+ToenailColorName+" toenail polish.")
		endif
		if ToenailHexColor == -1 ; Custom Color 
			CustomColorToenailPolish = true
			ToenailHexColor = MCMValues.EyeshadowCustomColorInt  ;;; later gets its own value
		endif
		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"zazapc009")
			Game.DisablePlayerControls()
		endif		
		SetToenailPolishStage(10)
		Debug.Notification("You gently open the nail polish bottle.")
		PlayYpsSound(1,0.0,2.0)
		Debug.Notification("An odd smell evaporates from the bottle.")
		Debug.Notification("Now you begin to apply"+ToenailColorName+" nail polish on your toes.")
		CurrentToenailColor = ToenailHexColor
		if !MCMValues.QuickNailPolishVal
			PaintToenail("You begin painting the big toe of your right foot.",1)
			PaintToenail("Next comes the second toe of your right foot...",2)
			PaintToenail("... followed by the middle toe.",3)
			PaintToenail("You neatly paint the fourth toe of your right foot.",4)
			PaintToenail("Now you finish your right foot by painting the small toe.",5)
			Debug.Notification("Now you move on to your left foot.")
			Utility.Wait(4.5)
			PaintToenail("You carefully paint the small toe of your left foot.",6)
			PaintToenail("Next comes the fourth toe...",7)
			PaintToenail("... followed by the middle toe of your left foot.",8)
			Debug.Notification("You are extra careful not to smudge the nail polish on your feet.")
			Utility.Wait(3.5)
			PaintToenail("You neatly paint the second toe of your left foot...",9)
			Debug.Notification("... and you finish your left foot by painting the big toe.")
			PlayYpsSound(2)
			AddToenailTattoo()
			RemoveToenailTattoo("9")
		else
			AddToenailTattoo()
		endif
		if MCMValues.ShowAnimations && ValidatePlayer()
			Debug.SendAnimationEvent(PlayerActor,"IdleForceDefaultState")	
		endif		
		ToenailpolishApplied = true
		ToenailPolishAppliedSince = Utility.GetCurrentGameTime()
		ToenailPolishDryStage = 0
		Debug.MessageBox("Finally done! Your toenails are now all \ncolored"+ToenailColorName+". How pretty!\nYou should not run around until the toenail polish has completely dried.")
		CurrentToenailColorName = ToenailColorName
		SetToenailPolishStage(20)
		TodayToenailPolish = true
		SlavetatsLock = false
		Game.EnablePlayerControls()
		SetToeNailPolishEvent(NailColor = CurrentToenailColorName, Smudged = ToenailSmudged)
    endif
EndFunction

int ToenailPolishDryStage = 0

bool Function ToenailPolishCheck()  ; check for smudged + crackles
	float TimeDiff
	TimeDiff = Utility.GetCurrentGameTime()-ToenailPolishAppliedSince
	bool ToeNailPolishCheckResult = false
	if ToenailPolishStage == 20
		if (YPS04DibellaFollower.GetStage() == 390) || ( EnableSmudging && MCMValues.SmudgeNailpolish && (!OpenSlavebootsWorn() || PlayerActor.IsInCombat() || PlayerActor.IsSwimming() || PlayerActor.IsRunning() || PlayerActor.IsSprinting()) )
			Debug.MessageBox("Oh no! Now you have smudged your freshly painted toenails!\nBetter stand still until your toenail polish has completely dried.")
			SmudgeToenailPolish()
			ToeNailPolishCheckResult = true
			if YPS04DibellaFollower.GetStage() == 390
				YPS04DibellaFollower.SetObjectiveCompleted(390)
				YPS04DibellaFollower.SetObjectiveDisplayed(400)
				YPS04DibellaFollower.Setstage(400)
			endif
		else
			if (TimeDiff>= NailPolishDryTime) 
				Debug.Messagebox("Your toenail polish has completely dried. You may move around freely again.\nYour pedicure will last for "+UtilScript.FormatTimeDiff(MCMValues.NailPolishDuration)) ; about "+MCMValues.NailPolishDuration as int+" days.")
				SetToenailPolishStage(40)
			elseif (TimeDiff>= (NailPolishDryTime*0.17)) && (ToenailPolishDryStage == 0)
				ToenailPolishDryStage += 1
				Debug.Notification("You smell the scent of freshly applied nail polish.")
			elseif (TimeDiff>= (NailPolishDryTime*0.33)) && (ToenailPolishDryStage == 1)
				ToenailPolishDryStage += 1
				Debug.Notification("Your toenail polish begins to dry.")
			elseif (TimeDiff>= (NailPolishDryTime*0.5)) && (ToenailPolishDryStage == 2)
				ToenailPolishDryStage += 1
				Debug.Notification("Better don't run around before the nail polish has dried.")
			elseif (TimeDiff>= (NailPolishDryTime*0.67)) && (ToenailPolishDryStage == 3)
				ToenailPolishDryStage += 1
				Debug.Notification("The nail polish scent begins to fade away.")
			elseif (TimeDiff>= (NailPolishDryTime*0.83)) && (ToenailPolishDryStage == 4)
				ToenailPolishDryStage += 1
				Debug.Notification("Your toenail polish has almost dried.")
			endif
		endif

	endif
	if (ToenailPolishStage == 40) || (ToenailPolishStage == 30) ; dried and ok OR smudged
		if (TimeDiff >= MCMValues.NailPolishDuration) && !PermanentMakeup
			SetToenailPolishStage(60)
			ToeNailPolishCheckResult = true
			WaitForSlavetatsUnlock()
			SlavetatsLock = true
			RemoveToenailTattoo()
			Utility.Wait(MCMValues.SlaveTatWaitTime)
			ToenailSmallcrackle = true
			AddToenailTattoo()
			Debug.Notification("Your toe nail polish starts chipping off.")
			SlavetatsLock = false
		endif
	elseif (ToenailPolishStage == 60) || (ToenailPolishStage == 30) ; dried and ok OR smudged
		if (TimeDiff >= (MCMValues.NailPolishDuration*1.37)) && !PermanentMakeup
			SetToenailPolishStage(70)
			ToeNailPolishCheckResult = true
			WaitForSlavetatsUnlock()
			SlavetatsLock = true
			RemoveToenailTattoo()
			Utility.Wait(MCMValues.SlaveTatWaitTime)
			ToenailBigcrackle = true
			AddToenailTattoo()
			Debug.Notification("Most of your toe nail polish has chipped off. You really should reapply it now.")
			SlavetatsLock = false
		endif
	elseif (ToeNailPolishStage == 70) || (ToeNailPolishStage == 30)  ; most worn off or smudged
		if (TimeDiff >= (MCMValues.NailPolishDuration*2.9)) && !PermanentMakeup
			SetToenailPolishStage(0)
			ToeNailPolishCheckResult = true
			WaitForSlavetatsUnlock()
			SlavetatsLock = true
			RemoveToenailTattoo()
			Utility.Wait(MCMValues.SlaveTatWaitTime)
			Debug.Notification("All of your toenail polish has chipped off. You can reapply it now.")
			SlavetatsLock = false
			ToenailBigcrackle = false
			ToenailSmallcrackle = false
			ToenailSmudged = false
			ToenailpolishApplied = false
			CurrentToenailColor = 0
			SetToeNailPolishEvent(NailColor = "", Smudged = ToenailSmudged)
		endif
	endif
	return ToeNailPolishCheckResult
EndFunction


Function SmudgeToenailPolish()
	WaitForSlavetatsUnlock()
	SlavetatsLock = true
	if !ToenailSmudged
		RemoveToenailTattoo()
		Utility.Wait(MCMValues.SlaveTatWaitTime)
		ToenailSmudged = true
		ToenailPolishStage = 30
		AddToenailTattoo()
		SetToeNailPolishEvent(NailColor = CurrentToenailColorName, Smudged = ToenailSmudged)
	endif
	SlavetatsLock = false
EndFunction

function ShowMakeupStatus()
	String MakeupStatusString = "Your makeup status:\n"
	if NailPolishStage > 10
		MakeupStatusString += "Fingernail polish color: "+NailPolishColor[CurrentNailColor]
		if (CurrentNailColor >= 17) && (CurrentNailColor <= 22)
			MakeupStatusString += " (extensions)"
		endif
		MakeupStatusString += "\nStatus: "
		if NailPolishStage <= 20
			MakeupStatusString += "drying"
		elseif NailPolishStage == 30
			MakeupStatusString += "smudged"
		elseif NailPolishStage == 40
			MakeupStatusString += "applied"
		elseif NailPolishStage == 50
			MakeupStatusString += "professional"
		else
			MakeupStatusString += "chipping off"
		endif
		if !PermanentMakeup
			float TimeDiff
			if NailPolishStage == 50
				TimeDiff = MCMValues.NailPolishDurationProfessional + NailPolishAppliedSince - Utility.GetCurrentGameTime()
			else
				TimeDiff = MCMValues.NailPolishDuration + NailPolishAppliedSince - Utility.GetCurrentGameTime()
			endif
			if TimeDiff > 0.0
				MakeupStatusString += "\nwill last for "+UtilScript.FormatTimeDiff(TimeDiff);+ TimeDiff +" days"
			endif
		endif
		MakeupStatusString += "\n"
	endif
	if ToenailpolishApplied
		MakeupStatusString += "Toenail polish color: "+CurrentToenailColorName+"\nStatus: "
		if ToenailSmudged
			MakeupStatusString += "smudged"
		elseif ToenailSmallcrackle || ToenailBigcrackle
			MakeupStatusString += "chipping off"
		elseif NailPolishStage <= 20
			MakeupStatusString += "drying"
		else
			MakeupStatusString += "applied"
		endif
		float TimeDiff = MCMValues.NailPolishDuration + ToeNailPolishAppliedSince - Utility.GetCurrentGameTime()
		if !PermanentMakeup && (TimeDiff >0)
			MakeupStatusString += "\nwill last for "+UtilScript.FormatTimeDiff(TimeDiff);+TimeDiff+" days"
		endif
		MakeupStatusString += "\n"
	endif
	if LipstickApplied
		MakeupStatusString += "Lipstick color: "+CurrentLipstickColorName
		MakeupStatusString += "\nLipstick coverage: "+LipstickPct+"% "+LipStickSmudged
		MakeupStatusString += "\n"
	endif
	if EyeshadowApplied
		MakeupStatusString += "Eyeshadow color: "+CurrentEyeshadowColorName
		MakeupStatusString += "\nEyeshadow coverage: "+EyeshadowPct+"% "+EyeshadowSmudged
		MakeupStatusString += ""
	endif
	if PermanentMakeup
		MakeupStatusString += "\nAll makeup is permanent."
	endif
	if LockMakeup
		MakeupStatusString += "\nAll makeup is locked to you."
	endif
	Debug.Messagebox(MakeupStatusString)
endfunction



; ===================
; ==== PUBIC HAIR ===
; ===================

float PubicHairStageSince = 0.0 ; last time a new pubic hair stage was reached
int Property PubicHairStage = 4 Auto Hidden ; begin with "small bush", which will immediately grow into a "large bush" upon activating hair growth

Function RemovePubicHairTattoo(int Stage)
	if Stage>0
		SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","PubicStage"+Stage,true,true)
	endif
EndFunction

;GetBodyHairColor(PlayerActor)
int Function GetBodyHairColor(actor akActor)
	if MCMValues.UseHairColor
		return akActor.GetActorBase().GetHairColor().GetColor()   ; later change this to natural color!!! !!!!!!!!!!!!!!!!
; !!!!! change above to natural color!
	else 
		return MCMValues.PubicHairCustomColorInt
	endif
endfunction

Function AddPubicHairTattoo(int Stage)
	STEBAddTattoo(PlayerActor,"YpsFashion","PubicStage"+Stage,GetBodyHairColor(PlayerActor),true,true,0,false,MCMValues.SlaveTatLock)
EndFunction

Function RemoveAllPubicHairSlavetats()
	Int i = 1
	While i <= 5
		RemovePubicHairTattoo(i)
		;Utility.Wait(1.0)
		i += 1
	EndWhile
EndFunction

Function SwitchPubicHairMethod()
	If MCMValues.UseSoSPubicHair
		RemovePubicHairTattoo(PubicHairStage)
		AddPubicHairItem()
	Else
		RemovePubicHairItem()
		AddPubicHairTattoo(PubicHairStage)
	EndIf
EndFunction

keyword property zad_DeviousCorset auto
keyword property zad_DeviousBelt auto
keyword property zad_DeviousHarness auto
keyword property zad_DeviousHobbleSkirt auto
keyword property zad_DeviousLegCuffs auto
keyword property zad_DeviousSuit auto

keyword property zbfWornBelt auto

keyword property zad_DeviousBra auto
keyword property zbfWornBra auto

keyword property zad_DeviousYoke Auto
keyword property zbfWornYoke Auto
keyword property zad_DeviousArmbinder Auto
keyword property zad_DeviousArmbinderElbow Auto

form[] property SOSPubicHairItems auto hidden
;/
form function GetSOSPubicHairItem(int stage) ; stage = 3,4,5
	form PubicHairItem = NONE
	if stage < 3
		return NONE
	else
		if (SOSPubicHairItems[stage - 3] == NONE) && (Game.GetModByName("SOS - Pubic Hair for Females Addon.esp") != 255)  ; pubic hair meshes installed
			if stage == 3
				PubicHairItem = Game.GetFormFromFile(0x000424B8,"SOS - Pubic Hair for Females Addon.esp") ; landing strip

			elseif stage == 4
				PubicHairItem = Game.GetFormFromFile(0x000424ff,"SOS - Pubic Hair for Females Addon.esp") ; bush
			elseif stage == 5
				PubicHairItem = Game.GetFormFromFile(0x00000d77,"SOS - Pubic Hair for Females Addon.esp") ; wild
			endif
			SOSPubicHairItems[stage - 3] = PubicHairItem
		endif
		return SOSPubicHairItems[stage - 3]
	endif
endfunction
/;
Form Function GetSosPubicHairByName(Int Stage)
	If Stage == 1
		Return Sos.FindSchlongByName("Pubic Hair Landing Strip")
	ElseIf Stage == 2
		Return Sos.FindSchlongByName("Pubic Hair Bush")
	ElseIf Stage == 3
		Return Sos.FindSchlongByName("Pubic Hair Wild")
	ElseIf Stage == 4
		Return Sos.FindSchlongByName("Pubic Hair Untamed")
	ElseIf Stage == 5 ; There aren't enough meshes for this stage so just re-use untamed
		Return Sos.FindSchlongByName("Pubic Hair Untamed")
	EndIf
	Return None
EndFunction

Function AddPubicHairItem()
    if MCMValues.PubicHairEnabled && MCMValues.UseSoSPubicHair
	;/
	form CurrentPubicHair = GetSOSPubicHairItem(PubicHairStage)
	if CurrentPubicHair != NONE
		Armor CurrentBodyArmor = PlayerActor.GetWornForm(kSlotMask32) as Armor
		PlayerActor.Equipitem(CurrentPubicHair,false,true)
		Utility.Wait(0.1)
		if CurrentBodyArmor != NONE ; equipping pubic hair will unequip body armor, need to reequip it
			PlayerActor.EquipItem(CurrentBodyArmor,false,true)
		endif
	endif
    endif
	/;
	
	;(Game.GetFormFromFile(0x, ""))SetSchlong
	
		Sos.SetSchlong(PlayerActor, GetSosPubicHairByName(PubicHairStage)) ; Needs interface
	EndIf
EndFunction

Function RemovePubicHairItem()
;/
	form CurrentPubicHair = GetSOSPubicHairItem(PubicHairStage)
	if CurrentPubicHair != NONE
		Armor CurrentBodyArmor = PlayerActor.GetWornForm(kSlotMask32) as Armor
		PlayerActor.UnequipItemSlot(52)	
		Utility.Wait(0.1)
		if CurrentBodyArmor != NONE ; removing pubic hair will unequip body armor, need to reequip it
			PlayerActor.EquipItem(CurrentBodyArmor,false,true)
		endif
		PlayerActor.Removeitem(CurrentPubicHair,1,true)
	endif
	/;
	Sos.RemoveSchlong(PlayerActor)
EndFunction

bool function UpdatePubicHairStatus(int NewPubicHairStage)
	if PubicHairStage != NewPubicHairStage
		int OldPubicHairStage = PubicHairStage
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		if NewPubicHairStage == 0
			Debug.Notification("Your pussy has now been denuded.")
		elseif NewPubicHairStage == 1
			;Debug.Notification("Your pussy feels itchy. Some pubic hair has grown.")
			Debug.Notification("Your pussy feels itchy. A small strip has grown.")
		elseif NewPubicHairStage == 2
			;Debug.Notification("Your pussy feels itchy. Your pubic hair has grown longer.")
			Debug.Notification("Your pubic hair has grown into a small bush.")
		elseif NewPubicHairStage == 3
			;Debug.Notification("Your pussy feels itchy. Still more pubic hair has grown.")
			Debug.Notification("Your pubic hair has grown into a large bush.")
		elseif NewPubicHairStage == 4
			;Debug.Notification("Your pubic hair has grown into a small bush.")
			Debug.Notification("Your pubic hair has grown into a wild bush.")
		elseif NewPubicHairStage == 5
			;Debug.Notification("Your pubic hair has grown into a large bush.")
			; Silent as there are no meshes for stage 5
		endif
		RemovePubicHairItem()
		PubicHairStage = NewPubicHairStage
		If MCMValues.UseSoSPubicHair
			AddPubicHairItem()
		Else
			AddPubicHairTattoo(PubicHairStage)
		EndIf
		RemovePubicHairTattoo(OldPubicHairStage)
		PubicHairStageSince = Utility.GetCurrentGameTime()
		SlavetatsLock = false
		SendPubicHairStageChangeEvent()
		return true
	else
		return false
	endif
endfunction

bool Function CheckPubicHair()
    bool PubesChanged = false
    if PubicHairStage == 0
	TodayShavePubic = true ; remember that you had shaved pubic hair
    endif
    if (PubicHairStage<5) 
	if ((Utility.GetCurrentGameTime() - PubicHairStageSince) >= MCMValues.PubicHairGrowthTime)
		PubesChanged = UpdatePubicHairStatus(PubicHairStage+1)
;		WaitForSlavetatsUnlock()
;		SlavetatsLock = true
;		RemovePubicHairItem()
;		PubicHairStage += 1
;		AddPubicHairTattoo(PubicHairStage)
;		AddPubicHairItem()
;		RemovePubicHairTattoo(PubicHairStage - 1)
;		PubicHairStageSince = Utility.GetCurrentGameTime()
;		SlavetatsLock = false
	elseif MCMValues.PubicHairItching && (PubicHairStage<4) && (Utility.Randomint(1,10) <= PubicHairStage) && (StorageUtil.GetIntValue(PlayerActor,"DCUR_SceneRunning") == 0)
		SendModEvent("dhlp-Suspend")
		Debug.Notification("Your pussy feels very itchy. You should shave your pubic hair.")
		if ValidatePlayer() && !PlayerActor.IsOnMount() && !PlayerActor.IsInCombat() && !PlayerActor.IsBleedingOut() && !PlayerActor.IsSwimming() && !PlayerActor.IsUnconscious() && (PlayerActor.GetSleepState() == 0) && (PlayerActor.GetSitState() == 0)
			if PlayerActor.WornhasKeyword(zad_DeviousYoke) || PlayerActor.WornhasKeyword(zbfWornYoke) 
				Debug.SendAnimationEvent(PlayerActor,"ZapYokeHorny01") ; DDYokeSolo
				Game.DisablePlayerControls()
				Utility.Wait(Utility.RandomInt(5,15))
			elseif PlayerActor.WornhasKeyword(zad_DeviousArmbinder) || PlayerActor.WornhasKeyword(zad_DeviousArmbinderElbow)
				Debug.SendAnimationEvent(PlayerActor,"ZapArmbHorny01") ; DDArmbinderSolo 
				Game.DisablePlayerControls()
				Utility.Wait(Utility.RandomInt(5,15))
			else
				Debug.SendAnimationEvent(PlayerActor,"DDBeltedSolo") ; DDBeltedSolo
				Game.DisablePlayerControls()
				Utility.Wait(Utility.RandomInt(5,15))
			endif
		endif
		PlayYpsSound(12)
		if ValidatePlayer() && !PlayerActor.IsOnMount() && !PlayerActor.IsInCombat() && !PlayerActor.IsBleedingOut() && !PlayerActor.IsSwimming() && !PlayerActor.IsUnconscious() && (PlayerActor.GetSleepState() == 0) && (PlayerActor.GetSitState() == 0) ; && !PlayerActor.WornhasKeyword(zad_DeviousYoke) &&  !PlayerActor.WornhasKeyword(zbfWornYoke) && !PlayerActor.WornhasKeyword(zad_DeviousArmbinder)
			Debug.SendAnimationEvent(PlayerActor,"IdleForceDefaultState")	
			Game.EnablePlayerControls()
		endif
		SendModEvent("dhlp-Resume")
	endif
    endif
    return PubesChanged
EndFunction

Bool Function CanShavePubicHair(Form ShavingCreamItem)
	if PlayerActor.GetWornForm(kSlotMask32) != NONE
		Debug.Notification("You need to remove your clothes before shaving your pussy.")
		Return false
	;elseif PlayerActor.WornHasKeyword(zad_DeviousCorset) ; Don't understand why you can't shave with a corset. Changed it to a harness instead
	;	Debug.Notification("You need to remove your corset before shaving your pussy.")
	elseif PlayerActor.WornHasKeyword(zad_DeviousHarness)
		Debug.Notification("You need to remove your harness before shaving your pussy.")
		Return false
	elseif (PlayerActor.WornHasKeyword(zbfWornBelt) || PlayerActor.WornHasKeyword(zad_DeviousBelt)) && !PlayerActor.Hasperk(yps_infibulated)
		Debug.Notification("You need to remove your chastity belt before shaving your pussy.")
		Return false
	elseif PlayerActor.GetItemCount(ShavingKnife) == 0
		Debug.Notification("You need a shaving knife to shave your pussy.")
		Return false
	elseif PlayerActor.GetItemCount(ShavingCreamItem) == 0
		Debug.Notification("You need some shaving cream to shave your pussy.")
		Return false
	elseif PlayerActor.IsOnMount()
		Debug.Notification("You cannot shave your pussy when sitting on a mount.")
		Return false
	elseif SlavetatsLock
		SlavetatsBusyMessagebox()
		Return false
	elseif !ValidatePlayer()
		Debug.Notification("You cannot shave your pussy right now.")
		Return false
	EndIf
	Return true
EndFunction

MiscObject Property ShavingKnife Auto

Function ShavePubicHair(MiscObject ShavingCreamItem)
	Utility.Wait(0.1)
	if CanShavePubicHair(ShavingCreamItem)
		SendModEvent("dhlp-Suspend")
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		if (PubicHairStage <= 0)
			Debug.Notification("Your pubic hair is still very short, but you decide shave it away.")
		elseif PlayerActor.Hasperk(yps_infibulated)
			Debug.Messagebox("You decide to shave away the pubic hair around your infibulation rings.")
		else
			Debug.Notification("You decide to shave away your pubic hair.")
		endif
		PlayerActor.Removeitem(ShavingCreamItem)
		Utility.Wait(0.8)
		if MCMValues.QuickBodyShave
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","PubicStage"+PubicHairStage,true,true)
			RemovePubicHairItem()
		else
			Debug.Notification("First you apply shaving cream on your pussy.")
			PlayYpsSound(2)
			if MCMValues.ShowAnimations && ValidatePlayer()
				Debug.SendAnimationEvent(PlayerActor,"DDBeltedSolo")
				Game.DisablePlayerControls()
			endif	
			PlayYpsSound(2)
			STEBAddTattoo(PlayerActor,"YpsFashion","PubicShavingCream1",0,true,true,0,false,MCMValues.SlaveTatLock)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","PubicStage"+PubicHairStage,true,true)
			STEBAddTattoo(PlayerActor,"YpsFashion","PubicShavingCream2",0,true,true,0,false,MCMValues.SlaveTatLock)
			Debug.Notification("You gently move the razor over your pussy.")
			PlayYpsSound(11)
			PlayYpsSound(11)
			RemovePubicHairItem()
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","PubicShavingCream1",true,true)
			STEBAddTattoo(PlayerActor,"YpsFashion","PubicShavingCream3",0,true,true,0,false,MCMValues.SlaveTatLock)
			if PlayerActor.Hasperk(yps_infibulated)
				Debug.Notification("You are extra careful around your infibulation rings.")
			else
				Debug.Notification("You gently shave the middle of your pussy.")
			endif
			PlayYpsSound(11)
			PlayYpsSound(11)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","PubicShavingCream2",true,true)
			STEBAddTattoo(PlayerActor,"YpsFashion","PubicShavingCream4",0,true,true,0,false,MCMValues.SlaveTatLock)
			if MCMValues.ShowAnimations && ValidatePlayer()
				Debug.SendAnimationEvent(PlayerActor,"IdleForceDefaultState")	
			endif		
			Utility.Wait(2.0)
			if MCMValues.ShowAnimations && ValidatePlayer()
				Debug.SendAnimationEvent(PlayerActor,"DDBeltedSolo")
				Game.DisablePlayerControls()
			endif	
			Utility.Wait(4.5)
			Debug.Notification("You shave away a third stroke of your pubic hair.")
			PlayYpsSound(11)
			PlayYpsSound(11)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","PubicShavingCream3",true,true)
			STEBAddTattoo(PlayerActor,"YpsFashion","PubicShavingCream5",0,true,true,0,false,MCMValues.SlaveTatLock)
			Debug.Notification("You shave away the left edge of the pubic hair.")
			PlayYpsSound(11)
			PlayYpsSound(11)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","PubicShavingCream4",true,true)
			STEBAddTattoo(PlayerActor,"YpsFashion","PubicShavingCream6",0,true,true,0,false,MCMValues.SlaveTatLock)
			if MCMValues.ShowAnimations && ValidatePlayer()
				Debug.SendAnimationEvent(PlayerActor,"IdleForceDefaultState")	
			endif		
			Utility.Wait(2.0)
			if MCMValues.ShowAnimations && ValidatePlayer()
				Debug.SendAnimationEvent(PlayerActor,"DDBeltedSolo")
				Game.DisablePlayerControls()
			endif	
			Utility.Wait(4.5)
			Debug.Notification("You gently shave away the last remains of your pubic hair.")
			PlayYpsSound(11,1.7)
			PlayYpsSound(11,1.7)
			PlayYpsSound(11,1.7)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","PubicShavingCream5",true,true)
			Debug.Notification("You rub away the remaining shaving cream...")
			PlayYpsSound(3)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","PubicShavingCream6",true,true)
			Debug.Notification("... and gently strike with your fingers over your smoothly shaven pussy.")
			PlayYpsSound(12)
			Utility.Wait(2.0)
			if MCMValues.ShowAnimations && ValidatePlayer()
				Debug.SendAnimationEvent(PlayerActor,"IdleForceDefaultState")	
			endif
		endif
		PubicHairStage = 0
		SlavetatsLock = false
		PubicHairStageSince = Utility.GetCurrentGameTime()
		SendModEvent("dhlp-Resume")
		SendPubicHairStageChangeEvent()
	endif
EndFunction

; ===================
; === ARMPIT HAIR ===
; ===================

float ArmpitsHairStageSince = 0.0 ; last time a new Armpits hair stage was reached
int ArmpitsHairStage = 4 ; begin with "small bush", which will immediately grow into a "large bush" upon activating hair growth

Function RemoveArmpitsHairTattoo(int Stage)
	if Stage>0
		SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","ArmpitsStage"+Stage,true,true)
	endif
EndFunction

Function AddArmpitsHairTattoo(int Stage)
	STEBAddTattoo(PlayerActor,"YpsFashion","ArmpitsStage"+Stage,GetBodyHairColor(PlayerActor),true,true,0,false,MCMValues.SlaveTatLock)
EndFunction


bool function UpdateArmpitHairStatus(int NewArmpitsHairStage)
	if ArmpitsHairStage != NewArmpitsHairStage
		int OldArmpitHairStage = ArmpitsHairStage
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		if NewArmpitsHairStage == 0
			Debug.Notification("Your armpits have now been denuded.")
		elseif NewArmpitsHairStage == 1
			Debug.Notification("Your armpits feel itchy. Some hair has grown.")
		elseif NewArmpitsHairStage == 2
			Debug.Notification("Your armpits feel itchy. Your hair has grown longer.")
		elseif NewArmpitsHairStage == 3
			Debug.Notification("Your armpits feel itchy. Still more hair has grown.")
		elseif NewArmpitsHairStage == 4
			Debug.Notification("Your armpit hair has grown into a small bush.")
		elseif NewArmpitsHairStage == 5
			Debug.Notification("Your armpit hair has grown into a large bush.")
		endif
		ArmpitsHairStage = NewArmpitsHairStage
		AddArmpitsHairTattoo(ArmpitsHairStage)
		RemoveArmpitsHairTattoo(OldArmpitHairStage)
		ArmpitsHairStageSince = Utility.GetCurrentGameTime()
		SlavetatsLock = false
		return true
	else
		return false
	endif
endfunction

bool Function CheckArmpitsHair()
    bool ArmpitsChanged = false
    if ArmpitsHairStage == 0
	TodayShaveArmpits = true ; remember that you had shaved armpits
    endif
    if (ArmpitsHairStage<5) 
	if ((Utility.GetCurrentGameTime() - ArmpitsHairStageSince) >= MCMValues.PubicHairGrowthTime)
;		WaitForSlavetatsUnlock()
;		SlavetatsLock = true
;		ArmpitsHairStage += 1
;		AddArmpitsHairTattoo(ArmpitsHairStage)
;		RemoveArmpitsHairTattoo(ArmpitsHairStage - 1)
;		ArmpitsHairStageSince = Utility.GetCurrentGameTime()
;		SlavetatsLock = false
		ArmpitsChanged = UpdateArmpitHairStatus(ArmpitsHairStage+1)
	elseif MCMValues.PubicHairItching && (ArmpitsHairStage<4) && (Utility.Randomint(1,10) <= ArmpitsHairStage) && (StorageUtil.GetIntValue(PlayerActor,"DCUR_SceneRunning") == 0)
		SendModEvent("dhlp-Suspend")
		Debug.Notification("Your armpits feel very itchy. You should shave your hair.")
		if ValidatePlayer() && !PlayerActor.IsOnMount() && !PlayerActor.IsInCombat() && !PlayerActor.IsBleedingOut() && !PlayerActor.IsSwimming() && !PlayerActor.IsUnconscious() && (PlayerActor.GetSleepState() == 0)
			if PlayerActor.WornhasKeyword(zad_DeviousYoke) || PlayerActor.WornhasKeyword(zbfWornYoke) 
				Debug.SendAnimationEvent(PlayerActor,"idleStudy")
				Game.DisablePlayerControls()
				Utility.Wait(15)
			endif
		endif
		PlayYpsSound(12)
		if ValidatePlayer() && !PlayerActor.IsOnMount() && !PlayerActor.IsInCombat() && !PlayerActor.IsBleedingOut() && !PlayerActor.IsSwimming() && !PlayerActor.IsUnconscious() && (PlayerActor.GetSleepState() == 0) ; && !PlayerActor.WornhasKeyword(zad_DeviousYoke) &&  !PlayerActor.WornhasKeyword(zbfWornYoke) && !PlayerActor.WornhasKeyword(zad_DeviousArmbinder)
			Debug.SendAnimationEvent(PlayerActor,"idleStop")
			Game.EnablePlayerControls()
		endif
		SendModEvent("dhlp-Resume")
	endif
    endif
    return ArmpitsChanged
EndFunction

;idle property zbfHandsAtHips auto
idle property DDYokeOffset03 auto

Function ShaveArmpitsHair(MiscObject ShavingCreamItem)
	Utility.Wait(0.1)
	if PlayerActor.GetWornForm(kSlotMask32) != NONE
		Debug.Notification("You need to remove your clothes before shaving your armpits.")
;	elseif PlayerActor.WornHasKeyword(zad_DeviousCorset)
;		Debug.Notification("You need to remove your corset before shaving your armpits.")
	elseif PlayerActor.GetItemCount(ShavingKnife) == 0
		Debug.Notification("You need a shaving knife to shave your armpits.")
	elseif PlayerActor.GetItemCount(ShavingCreamItem) == 0
		Debug.Notification("You need some shaving cream to shave your armpits.")
	elseif PlayerActor.IsOnMount()
		Debug.Notification("You cannot shave your armpits when sitting on a mount.")
	elseif SlavetatsLock
		SlavetatsBusyMessagebox()
	elseif !ValidatePlayer()
		Debug.Notification("You cannot shave your armpits right now.")
	else
		SendModEvent("dhlp-Suspend")
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		if (ArmpitsHairStage <= 0)
			Debug.Notification("Your armpit hair is still very short, but you decide shave it away.")
		else
			Debug.Notification("You decide shave away your armpit hair.")
		endif
		PlayerActor.Removeitem(ShavingCreamItem)
		Utility.Wait(0.2)
		if MCMValues.QuickArmpitShave
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","ArmpitsStage"+ArmpitsHairStage,true,true)
		else
			Debug.Notification("First you apply shaving cream on your armpits.")
			PlayYpsSound(2)
			if MCMValues.ShowAnimations && ValidatePlayer()
				PlayerActor.PlayIdle(DDYokeOffset03)
;				Debug.SendAnimationEvent(PlayerActor,"idleStudy")
				Game.DisablePlayerControls()
			endif	
			PlayYpsSound(2)
			STEBAddTattoo(PlayerActor,"YpsFashion","ArmpitsShavingCream1",0,true,true,0,false,MCMValues.SlaveTatLock)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","ArmpitsStage"+ArmpitsHairStage,true,true)
			STEBAddTattoo(PlayerActor,"YpsFashion","ArmpitsShavingCream2",0,true,true,0,false,MCMValues.SlaveTatLock)
			Debug.Notification("You gently move the razor over your left armpit.")
			PlayYpsSound(11,1.0)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","ArmpitsShavingCream1",true,true)
			STEBAddTattoo(PlayerActor,"YpsFashion","ArmpitsShavingCream3",0,true,true,0,false,MCMValues.SlaveTatLock)
			Debug.Notification("You gently shave the middle of your left armpits.")
			PlayYpsSound(11,1.0)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","ArmpitsShavingCream2",true,true)
			STEBAddTattoo(PlayerActor,"YpsFashion","ArmpitsShavingCream4",0,true,true,0,false,MCMValues.SlaveTatLock)
;			if MCMValues.ShowAnimations && ValidatePlayer()
;				Debug.SendAnimationEvent(PlayerActor,"idleStop")
;			endif		
			Utility.Wait(0.01)
			if MCMValues.ShowAnimations && ValidatePlayer()
				PlayerActor.PlayIdle(DDYokeOffset03)
;				Debug.SendAnimationEvent(PlayerActor,"idleStudy")
				Game.DisablePlayerControls()
			endif	
			Utility.Wait(0.01)
			Debug.Notification("After a last stroke on your left armpit you turn to the right side.")
			PlayYpsSound(11,1.0)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","ArmpitsShavingCream3",true,true)
			STEBAddTattoo(PlayerActor,"YpsFashion","ArmpitsShavingCream5",0,true,true,0,false,MCMValues.SlaveTatLock)
			Debug.Notification("You shave away another stroke of your right armpit hair.")
			PlayYpsSound(11,1.0)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","ArmpitsShavingCream4",true,true)
			STEBAddTattoo(PlayerActor,"YpsFashion","ArmpitsShavingCream6",0,true,true,0,false,MCMValues.SlaveTatLock)
;			if MCMValues.ShowAnimations && ValidatePlayer()
;				Debug.SendAnimationEvent(PlayerActor,"idleStop")
;			endif		
			Utility.Wait(0.5)
			if MCMValues.ShowAnimations && ValidatePlayer()
				PlayerActor.PlayIdle(DDYokeOffset03)
;				Debug.SendAnimationEvent(PlayerActor,"idleStudy")
				Game.DisablePlayerControls()
			endif	
			Utility.Wait(0.5)
			Debug.Notification("You gently shave away the last remains of your armpit hair.")
			PlayYpsSound(11,1.0)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","ArmpitsShavingCream5",true,true)
			Debug.Notification("You rub away the remaining shaving cream...")
			PlayYpsSound(3,1.0)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion","ArmpitsShavingCream6",true,true)
			Debug.Notification("... and gently strike with your fingers over your smoothly shaven armpits.")
			PlayYpsSound(12)
			Utility.Wait(0.5)
			if MCMValues.ShowAnimations && ValidatePlayer()
				Debug.SendAnimationEvent(PlayerActor,"IdleForceDefaultState")	
;				Debug.SendAnimationEvent(PlayerActor,"idleStop")
			endif		
		endif
		ArmpitsHairStage = 0
		ArmpitsHairStageSince = Utility.GetCurrentGameTime()
		SlavetatsLock = false
		SendModEvent("dhlp-Resume")
		if yps04DibellaFollower.Getstage() == 280
			YPS04DibellaFollower.SetObjectiveCompleted(280)
			YPS04DibellaFollower.SetObjectiveDisplayed(290)
			YPS04DibellaFollower.Setstage(290)
		endif
	endif
EndFunction

; 

; ===================
; =====  NYLONS =====
; ===================
; (stockings and pantyhose)

bool NylonsNeverWorn = true ; player has never worn nylons?
bool NylonsCurrentlyWorn = false
bool NylonsCurrentlyPaid = true

int CurrentNylonsType = 0 ; as currently worn (be careful when changing these variable!), 0 = "Stockings", 1 = "Tights"
int CurrentNylonsPattern = 0 ; as currently worn
int CurrentNylonsColor = 0 ; as currently worn

message property ypsNylonsType auto
message property ypsNylonsPattern auto
message property ypsNylonsColor auto
message property ypsNylonsPurchase auto
message property ypsNylonsWearSameAgain auto

float NylonsWornSince

string function NylonsTypeString(int Type)
	if Type == 0
		return "Stockings"
	else
		return "Tights"
	endif
endfunction

string function NylonsPatternString(int pattern)
	if pattern == 0
		return "Sheer"
	elseif pattern == 1
		return "Opaque"
	elseif pattern == 2
		return "Striped" 
	elseif pattern == 3
		return "Fishnet"
	elseif pattern == 4
		return "Hearts"
	elseif pattern == 5
		return "Floral"
	endIf
endFunction

int function NylonsColorValue(int color)
	if color == 0 ; black
		return 0x00000000
	elseif color == 1 ; white
		return 0x00ffffff
	elseif color == 2 ; tan
		return 0x00fac6af 
	elseif color == 3 ; brown
		return 0x00654321
	elseif color == 4 ; red
		return 0x0088000e
	elseif color == 5 ; blue
		return 0x00000099
	elseif color == 6 ; green
		return 0x00006600
	elseif color == 7 ; pink
		return 0x00ffaaaa
	elseif color == 8 ; hotpink
		return 0x00ff7777
	elseif color == 9 ; violet
		return 0x00c715aa
	endif
endfunction

function RemoveNylonsTattoo(int NylonsType, int Nylonspattern)
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		SlaveTats.simple_remove_tattoo(PlayerActor, NylonsTypeString(NylonsType),"Legs " + NylonsPatternString(Nylonspattern),false,true)
		SlaveTats.simple_remove_tattoo(PlayerActor, NylonsTypeString(NylonsType),"Feet " + NylonsPatternString(Nylonspattern),true,true)
		SlavetatsLock = false
endFunction

function AddNylonsTattoo(int NylonsType, int Nylonspattern, int NylonsColor) ; add tattoo according to current settings
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		if ToenailpolishApplied ; make sure that toenail polish tattoo is applied before the stockings, not after them!
			RemoveToenailTattoo()
			AddToeNailTattoo("",false)
		endif
        STEBAddTattoo(PlayerActor,NylonsTypeString(NylonsType),"Legs " + NylonsPatternString(Nylonspattern),NylonsColorValue(NylonsColor),false,true,0,false,MCMValues.SlaveTatLock)
        STEBAddTattoo(PlayerActor,NylonsTypeString(NylonsType),"Feet " + NylonsPatternString(Nylonspattern),NylonsColorValue(NylonsColor),true,true,0,false,MCMValues.SlaveTatLock)
		SlavetatsLock = false
endFunction

; ToenailPolishStages: 0 = no polish, 10 = in process of applying, 20 = applied and drying, 30 = smudged, 40 = ok and dried, 50 = manicured, 60 = starts chipping, 70 = only some remains left

function WearRemoveNylons()
	int newtype = 0
	int newpattern = 0
	int newcolor = 0
	if !NylonsCurrentlyWorn
		bool SameAgain = false
		if NylonsCurrentlyPaid && !NylonsNeverWorn
			SameAgain = ypsNylonsWearSameAgain.Show()
		endif
		if SameAgain
			ApplyNylons(CurrentNylonsType,CurrentNylonsPattern,CurrentNylonsColor,false,NylonsCurrentlyPaid)
		else
			newtype = ypsNylonsType.show()
			newpattern = ypsNylonsPattern.show()
			newcolor = ypsNylonsColor.show()
			ApplyNylons(newtype,newpattern,newcolor)
		endif
	else ; just remove them
		ApplyNylons()
	endif
endfunction 

message property yps_DibellaQuestTryNylons auto

function ApplyNylons(int newNylonsType = 0, int newNylonsPattern = 0, int newNylonsColor = 0, bool force_unwear = false, bool NylonsAlreadyPaidFor = false) ; force_unwear even if other equipment is worn // will need to pay for nylons later
	Form Boots = PlayerActor.GetWornForm(kSlotMask37)
	if (PlayerActor.WornHasKeyword(zad_DeviousBoots) || (PlayerActor.GetWornForm(kSlotMask37) == yps_SlaveBoots)) && (yps04DibellaFollower.Getstage() != 580) ; at Dibella quest stage 580: squeeze nylons through boots is allowed
		Debug.Messagebox("You need to remove your foot devices before wearing or removing nylons.")
	elseif Boots.GetName() != "" ; wearing something standard boots
		Debug.Messagebox("You need to remove your "+Boots.GetName()+" before wearing or removing nylons.")
	elseif SlavetatsLock && !force_unwear
		SlavetatsBusyMessagebox()
	elseif NylonsCurrentlyWorn ; -> remove nylons
		if PlayerActor.WornHasKeyword(zad_DeviousLegCuffs) && !force_unwear
			Debug.Messagebox("You may not remove your "+NylonsTypeString(CurrentNylonsType)+" while wearing your leg cuffs.")
		elseif PlayerActor.WornHasKeyword(zad_DeviousHobbleSkirt) && !force_unwear
			Debug.Messagebox("You may not remove your "+NylonsTypeString(CurrentNylonsType)+" while wearing your hobble skirt.")
		elseif PlayerActor.WornHasKeyword(zad_DeviousSuit) && !force_unwear
			Debug.Messagebox("You may not remove your "+NylonsTypeString(CurrentNylonsType)+" while wearing your suit.")
		elseif PlayerActor.WornHasKeyword(zad_DeviousBelt) && (CurrentNylonsType == 1) && !force_unwear ; tights
			Debug.Messagebox("You may not remove your tights while wearing your chastity belt.")
		elseif PlayerActor.WornHasKeyword(zad_DeviousHarness) && (CurrentNylonsType == 1) && !force_unwear
			Debug.Messagebox("You may not remove your tights while wearing your harness.")
		else
			NylonsCurrentlyWorn = false
			if MCMValues.ShowAnimations
				int Gender = PlayerActor.GetLeveledActorBase().GetSex()
				Debug.SendAnimationEvent(PlayerActor, "Arrok_Undress_G"+Gender)
			endif
			PlayYpsSound(21)
			RemoveNylonsTattoo(CurrentNylonsType,CurrentNylonsPattern)
			Utility.Wait(MCMValues.SlaveTatWaitTime)
		endif
	elseif ToenailPolishStage == 10
		Debug.Messagebox("You may not wear nylons while applying toenail polish.")
	elseif ToenailPolishStage == 20
		Debug.Messagebox("You shouldn't wear nylons before your toenail polish has dried completely.")
	else
		if PlayerActor.WornHasKeyword(zad_DeviousLegCuffs)
			Debug.Messagebox("You may not wear "+NylonsTypeString(newNylonsType)+" while wearing your leg cuffs.")
		elseif PlayerActor.WornHasKeyword(zad_DeviousHobbleSkirt)
			Debug.Messagebox("You may not wear "+NylonsTypeString(newNylonsType)+" while wearing your hobble skirt.")
		elseif PlayerActor.WornHasKeyword(zad_DeviousSuit)
			Debug.Messagebox("You may not wear "+NylonsTypeString(newNylonsType)+" while wearing your suit.")
		elseif PlayerActor.WornHasKeyword(zad_DeviousBelt) && (newNylonsType == 1) ; tights
			Debug.Messagebox("You may not wear tights while wearing your chastity belt.")
		elseif PlayerActor.WornHasKeyword(zad_DeviousHarness) && (newNylonsType == 1)
			Debug.Messagebox("You may not wear tights while wearing your harness.")
		elseif (PlayerActor.GetActorBase().GetSex() != 1)
			Debug.Messagebox("Only females are allowed to wear nylons.")
		elseif (yps04DibellaFollower.Getstage() >= 190) && (yps04DibellaFollower.Getstage() <= 390)
			Debug.Messagebox("You don't feel confident enough to wear nylons.")
		else
			NylonsWornSince = Utility.GetCurrentGameTime()
			CurrentNylonsType = newNylonsType
			CurrentNylonsPattern = newNylonsPattern
			CurrentNylonsColor = newNylonsColor
			if NylonsNeverWorn
				Debug.Notification("You try on nylons for the very first time...")
				NylonsNeverWorn = false
			endif
			if MCMValues.ShowAnimations
				int Gender = PlayerActor.GetLeveledActorBase().GetSex()
				Debug.SendAnimationEvent(PlayerActor, "Arrok_Undress_G"+Gender)
			endif
			PlayYpsSound(20)
			AddNylonsTattoo(CurrentNylonsType,CurrentNylonsPattern,CurrentNylonsColor)
			NylonsCurrentlyPaid = NylonsAlreadyPaidFor
			if yps04DibellaFollower.Getstage() == 580
				NylonsCurrentlyPaid = true ; get them for free this time
				Utility.Wait(0.02)
				yps_DibellaQuestTryNylons.Show()
			endif
			Utility.Wait(0.02)
			Debug.Notification("As you slide into the nylons you feel very comfortable.")
			Utility.Wait(MCMValues.SlaveTatWaitTime)
			Debug.Notification("The "+NylonsTypeString(CurrentNylonsType)+" make your legs feel silky and smooth.")
			NylonsCurrentlyWorn = true
			NylonsWornSince = Utility.GetCurrentGameTime()
		endif
	endif
endfunction

;Function STEBAddTattoo(Form _form, String _section, String _name, int _color, bool _last, bool _silent, int _glowColor, bool _gloss, bool _lock)

; ==================

message property ypsBodyHairLocationMsg auto

Function ShaveHair(MiscObject ShavingCreamItem)
	int LocationChoice = ypsBodyHairLocationMsg.show()
	if LocationChoice == 1
		ShaveArmpitsHair(ShavingCreamItem)
	elseif LocationChoice == 2 ; Pubic
		If MCMValues.UseSoSPubicHair
			Int Select = (Game.GetFormFromFile(0x09DF47, "yps-ImmersivePiercing.esp") as Message).Show()
			If Select == 0 ; Shave
				ShavePubicHair(ShavingCreamItem)
			Else ; Trim
				If PubicHairIsGrownEnough(Select) && CanShavePubicHair(ShavingCreamItem)
					PlayYpsSound(2) ; Are these sounds right?
					PlayYpsSound(11)
					Debug.Notification("You carefully trim your pubic hair")
					RemovePubicHairItem()
					PubicHairStage = Select
					PubicHairStageSince = Utility.GetCurrentGameTime()
					AddPubicHairItem()
					PlayerActor.RemoveItem(ShavingCreamItem, 1)
					SendPubicHairStageChangeEvent()
				EndIf
			EndIf
		Else
			ShavePubicHair(ShavingCreamItem)
		EndIf
	elseif LocationChoice == 3
		Hairscript.ShaveHead(ShavingCreamItem)
	endif
EndFunction

Bool Function PubicHairIsGrownEnough(Int DesiredStage)
	;Debug.Messagebox("PubicHairStage: " + PubicHairStage + "\nDesiredStage: " + DesiredStage)
	If PubicHairStage > DesiredStage
		Return true
	EndIf
	Debug.Notification("My pubic hair isn't grown enough")
	Return false
EndFunction

; =======================================================
; =======================================================
; =======================================================
; =======================================================
; ====================== COMMON =========================
; =======================================================
; =======================================================
; =======================================================
; =======================================================

Function PlayerSleepStop()
	AddEyeshadowTime = Utility.GetCurrentGameTime()
	AddLipstickTime = Utility.GetCurrentGameTime()
	if (! LockMakeup) && (! PermanentMakeup) && EnableSmudging && MCMValues.SmudgeLipstick && (LipStickSmudged == "") && (LipStickPct>0) && (Utility.RandomFloat(1.0,100.0) <= MCMValues.SmudgeMakeupChance)
		SmudgeLipstick()
		Debug.Notification("You have smeared your lipstick during sleep.")
	endif
	if (! LockMakeup) && (! PermanentMakeup) && EnableSmudging && MCMValues.SmudgeEyeshadow && (EyeshadowSmudged == "") && (EyeshadowPct>0) && (Utility.RandomFloat(1.0,100.0) <= MCMValues.SmudgeMakeupChance)
		SmudgeEyeshadow()
		Debug.Notification("You have smeared your eyeshadow during sleep.")
	endif
EndFunction

; ===================
; ====  SEXLAB   ====
; ===================


SexLabFramework property SexLab auto
bool SexlabAnimRunning = false

int function ValidatePlayer()
;* *   -1 = The Actor does not exists (it is None)
;* *   -10 = The Actor is already part of a SexLab animation
;* *   -12 = The Actor does not have the 3D loaded
;* *   -13 = The Actor is dead (He's dead Jim.)
;* *   -14 = The Actor is disabled
;* *   -15 = The Actor is flying (so it cannot be SexLab animated)
;* *   -16 = The Actor is on mount (so it cannot be SexLab animated)

	if !PlayerActor
		return -1
	endIf	
	; Primary checks
	if SexLab.IsActorActive(PlayerActor)
		return -10
	elseIf !PlayerActor.Is3DLoaded()
		return -12
	elseIf PlayerActor.IsDead() && PlayerActor.GetActorValue("Health") < 1.0
		return -13
	elseIf PlayerActor.IsDisabled()
		return -14
	elseIf PlayerActor.IsFlying()
		return -15
	elseIf PlayerActor.IsOnMount()
		return -16
	endIf
	
	return 1
	
endFunction

event SexlabAnimStart(string eventName, string argString, float argNum, form sender)
;	actor[] actors = SexLab.HookActors(argString)
;	If actors.Find(PlayerActor) >= 0
;		SexlabAnimRunning = true
;	endIf
endEvent

event SexlabAnimEnd(string eventName, string argString, float argNum, form sender)
;	actor[] actors = SexLab.HookActors(argString)
;	If actors.Find(PlayerActor) >= 0
;		SexlabAnimRunning = False
;	endIf
endEvent

; ===================
; ==== ADDICTION ====
; ===================

float MakeupAddictionLevel = 0.0
float MakeupAddictionHighestLevel = 0.0
;float property MakeupAddictionIncreaseIntensity = 0.03 autoreadonly
;float property MakeupAddictionDecreaseIntensity = 0.01 autoreadonly
bool TodayToenailPolish = false
bool TodayFingernailPolish = false
bool TodayEarrings = false
bool TodayLipstick = false
bool TodayEyeshadow = false
bool TodayShaveArmpits = false
bool TodayShavePubic = false
bool property TodayHeels = false auto ; will be set from YpsHeelsTicker script
bool property CurrentlyInHeels = false auto ; will be set from YpsHeelsTicker script
bool property TodayHairdye = false auto ; will be set from the YpsHair script
bool property CurrentlyHairdye = false auto ; dito
bool property TodayHairPerm = false auto
bool property CurrentlyHairPerm = false auto
bool property TodayHairLong = false auto
bool property CurrentlyHairLong = false auto
bool property TodayHairBuzz = false auto
bool property CurrentlyHairBuzz = false auto
bool property CurrentlyMohawk = false auto
bool TodayNylons = false

Spell[] Property FashionAddictionBuffs Auto  ; 1 = 2%, 2 = 5%, x = (x-1)*5%
Spell[] Property FashionAddictionDebuffs Auto ; x = x*(-10%)
int FashionAddictionBuffLevel = 0

Function AddAddictionBuff()

	if FashionAddictionBuffLevel > 0
		PlayerActor.AddSpell(FashionAddictionBuffs[FashionAddictionBuffLevel])
	elseif FashionAddictionBuffLevel < 0
		PlayerActor.AddSpell(FashionAddictionDebuffs[ -1 * FashionAddictionBuffLevel])
	endif	
EndFunction
Function RemoveAddictionBuff()
	if FashionAddictionBuffLevel > 0
		PlayerActor.RemoveSpell(FashionAddictionBuffs[FashionAddictionBuffLevel])
	elseif FashionAddictionBuffLevel < 0
		PlayerActor.RemoveSpell(FashionAddictionDebuffs[ -1 * FashionAddictionBuffLevel])
	endif	
EndFunction
int function CurrentFashionLevel()
	int FashionLevel = 0
	if MCMValues.AddictionToenailPolish && (ToenailPolishStage > 0)
		FashionLevel += 1
	endif
	if MCMValues.AddictionFingernailPolish && (NailPolishStage > 0)
		FashionLevel += 1
	endif
	if MCMValues.AddictionEarrings && (PiercingStudWorn[1] || (OldPiercingForm[1] != NONE))
		FashionLevel += 1
	endif
	if MCMValues.AddictionLipstick && LipstickApplied
		FashionLevel += 1
	endif
	if MCMValues.AddictionEyeshadow && EyeshadowApplied
		FashionLevel += 1
	endif
	if MCMValues.AddictionShaveArmpits && (ArmpitsHairStage == 0)
		FashionLevel += 1
	endif
	if MCMValues.AddictionShavePubic && (PubicHairStage == 0)
		FashionLevel += 1
	endif
	if MCMValues.AddictionHeels && CurrentlyInHeels
		FashionLevel += 1
	endif
	if MCMValues.AddictionHairdye && CurrentlyHairdye
		FashionLevel += 1
	endif
	if MCMValues.AddictionHairperm && CurrentlyHairperm
		FashionLevel += 1
	endif
	if MCMValues.AddictionHairlong && CurrentlyHairlong
		FashionLevel += 1
	endif
	if MCMValues.AddictionHairbuzz && CurrentlyHairbuzz
		FashionLevel += 1
	endif
	if MCMValues.AddictionNylons && NylonsCurrentlyWorn
		TodayNylons = true
		FashionLevel += 1
	endif
	if CurrentlyMohawk
		FashionLevel -= MCMValues.MohawkFashionDebuff
	endif
	if(Game.GetModByName("Bathing in Skyrim - Main.esp") != 255)
		FormList DirtinessSpellList = Game.GetFormFromFile(0xCFAE, "Bathing in Skyrim - Main.esp") As FormList ; 0 - Clean, 1 - NotDirty
		Int Dirtiness = 0
		Int Index = 0
		While Index < DirtinessSpellList.GetSize() && Dirtiness == 0
			Spell DirtinessSpell = DirtinessSpellList.GetAt(Index) As Spell
			if PlayerActor.HasSpell(DirtinessSpell)
				Dirtiness = Index +1
			endif
			Index += 1
		EndWhile
		FashionLevel -= (Dirtiness - 2)
	endif
	return FashionLevel
endfunction
Function AdjustAddictionBuff()
	int FashionLevel = CurrentFashionLevel()
	int NewFashionAddictionBuffLevel = FashionLevel - (MakeupAddictionLevel as int)
	if NewFashionAddictionBuffLevel < -10
		NewFashionAddictionBuffLevel = -10
	elseif (NewFashionAddictionBuffLevel == 0) && ((MakeupAddictionLevel as int) != 0)
		NewFashionAddictionBuffLevel = 1 ; don't catch this situation with the next "elseif"
	elseif (NewFashionAddictionBuffLevel >= 1)
		NewFashionAddictionBuffLevel += 1
	endif
	if NewFashionAddictionBuffLevel > 11
		NewFashionAddictionBuffLevel = 11
	endif
	if NewFashionAddictionBuffLevel != FashionAddictionBuffLevel
		RemoveAddictionBuff()
		FashionAddictionBuffLevel = NewFashionAddictionBuffLevel
		AddAddictionBuff()
		SendAddictionBuffChangeEvent()
	endif
EndFunction

int function TodaysFashionLevel()
	int TodaysLevel = 0
	if MCMValues.AddictionToenailPolish && (TodayToenailPolish || (ToenailPolishStage > 0))
		TodaysLevel += 1
	endif
	if MCMValues.AddictionFingernailPolish && (TodayFingernailPolish || (NailPolishStage > 0))
		TodaysLevel += 1
	endif
	if MCMValues.AddictionEarrings && TodayEarrings
		TodaysLevel += 1
	endif
	if MCMValues.AddictionLipstick && (TodayLipstick || LipstickApplied)
		TodaysLevel += 1
	endif
	if MCMValues.AddictionEyeshadow && (TodayEyeshadow || EyeshadowApplied)
		TodaysLevel += 1
	endif
	if MCMValues.AddictionShaveArmpits && (TodayShaveArmpits || (ArmpitsHairStage == 0))
		TodaysLevel += 1
	endif
	if MCMValues.AddictionShavePubic && (TodayShavePubic || (PubicHairStage == 0))
		TodaysLevel += 1
	endif
	if MCMValues.AddictionHeels && TodayHeels
		TodaysLevel += 1
	endif
	if MCMValues.AddictionHairdye && TodayHairdye
		TodaysLevel += 1
	endif
	if MCMValues.AddictionHairperm && TodayHairperm
		TodaysLevel += 1
	endif
	if MCMValues.AddictionHairlong && TodayHairlong
		TodaysLevel += 1
	endif
	if MCMValues.AddictionHairbuzz && TodayHairbuzz
		TodaysLevel += 1
	endif
	if MCMValues.AddictionNylons && TodayNylons
		TodaysLevel += 1
	endif
	if CurrentlyMohawk
		TodaysLevel -= MCMValues.MohawkFashionDebuff
	endif
	return TodaysLevel
endfunction

function CheckAddictionStatus()
	int TodaysLevel = TodaysFashionLevel()
	TodayToenailPolish = false
	TodayFingernailPolish = false
	TodayEarrings = false
	TodayLipstick = false
	TodayEyeshadow = false
	TodayShaveArmpits = false
	TodayShavePubic = false
	TodayHeels = false
	TodayHairdye = false
	TodayHairperm = false
	TodayHairlong = false
	TodayHairbuzz = false
	TodayNylons = false
	float OldMakeupAddictionLevel = MakeupAddictionLevel
	if TodaysLevel > (MakeupAddictionLevel as int)
		MakeupAddictionLevel += MCMValues.AddictionIncreaseSpeed * 0.0025 * (TodaysLevel - (MakeupAddictionLevel as int))
		if (MakeupAddictionLevel as int) > (OldMakeupAddictionLevel as int)
			Debug.Notification("You have become more addicted to fashion.")
			MakeupAddictionLevel += 0.5  ; don't fall back to previous level easily!
			SendAddictionLevelChangeEvent()
		endif
	elseif TodaysLevel < (MakeupAddictionLevel as int)
		MakeupAddictionLevel -= MCMValues.AddictionDecreaseSpeed * 0.0025 ; decrease always slow
		if (MakeupAddictionLevel as int) < (OldMakeupAddictionLevel as int)
			Debug.Notification("You have become less addicted to fashion.")
			MakeupAddictionLevel -= 0.1  ; don't fall back to previous level easily, but it is easier to go up than down
			SendAddictionLevelChangeEvent()
		endif
	endif
	if MakeupAddictionLevel > MakeupAddictionHighestLevel 
		MakeupAddictionHighestLevel = MakeupAddictionLevel
	endif
	if MCMValues.AddictionArousal
		float PlayerExposure = StorageUtil.GetFloatValue(PlayerActor, "SLAroused.ActorExposure")
		if PlayerExposure < 100.0
			PlayerExposure += TodaysLevel * MCMValues.AddictionArousalStrength
			if PlayerExposure > 100.0
				PlayerExposure = 100.0
			endif
			StorageUtil.SetFloatValue(PlayerActor, "SLAroused.ActorExposure",PlayerExposure)
		endif
;Debug.Notification("MA: "+MakeupAddictionLevel+"|"+PlayerExposure)
	endif
endfunction


; ===================
; =  YPS MOD EVENTS =
; ===================

bool LockMakeup = false
bool LockPiercings = false
bool PermanentMakeup = false
bool EnableSmudging = true

Event OnLockMakeupEvent(string eventName, string strArg, float numArg, Form sender)
	Debug.Notification("You may no longer change your makeup.")
	LockMakeup = true
EndEvent
Event OnUnlockMakeupEvent(string eventName, string strArg, float numArg, Form sender)
	Debug.Notification("You may once again change your makeup.")
	LockMakeup = false
EndEvent
Event OnLockPiercingsEvent(string eventName, string strArg, float numArg, Form sender)
	Debug.Notification("You may no longer change your piercings.")
	LockPiercings = true
EndEvent
Event OnUnlockPiercingsEvent(string eventName, string strArg, float numArg, Form sender)
	Debug.Notification("You may once again change your piercings.")
	LockPiercings = false
EndEvent
Event OnPermanentMakeupEvent(string eventName, string strArg, float numArg, Form sender)
	Debug.Notification("Your makeup will no longer wear off.")
	PermanentMakeup = true
EndEvent
Event OnNoPermanentMakeupEvent(string eventName, string strArg, float numArg, Form sender)
	Debug.Notification("Your makeup will wear off over time again.")
	PermanentMakeup = false
EndEvent
Event OnDisableSmudgingEvent(string eventName, string strArg, float numArg, Form sender)
	Debug.Notification("Your makeup will no longer smudge.")
	EnableSmudging = false
EndEvent
Event OnEnableSmudgingEvent(string eventName, string strArg, float numArg, Form sender)
	Debug.Notification("Your makeup may now smudge.")
	EnableSmudging = true
EndEvent
Event OnLipstickEvent(string eventName, string LipstickColorName, float LipstickHexColor, Form sender)
	OnLipstickTweakedEvent(LipstickColorName, LipstickHexColor as Int)
EndEvent
Event OnLipstickTweakedEvent(String LipstickColorName, Int LipstickHexColor, String Smudged = "")
	SendModEvent("dhlp-Suspend")
	WaitForSlavetatsUnlock()
	SlavetatsLock = true
	Game.DisablePlayerControls()
	if LipstickApplied
		Debug.Notification("Removing old lipstick...")
		RemoveLipstickTattoo(LipStickPct,LipStickSmudged)
		Game.EnablePlayerControls()
		LipstickApplied = false 
		LipstickPct = 0
		LipStickSmudged = ""
		CustomColorLipstick = false
	endif
	if LipstickColorName != "" ; only apply new lipstick when color name is specified
		if LipstickHexColor == -1 ; Custom Color Lipstick
			CustomColorLipstick = true
			LipstickHexColor = MCMValues.LipstickCustomColorInt
		endif
		LipstickPct = 100
		CurrentLipstickColor = LipstickHexColor as int
		LipStickSmudged = Smudged
		AddLipstickTattoo(LipStickPct,LipStickSmudged)
		LipstickApplied = true
		AddLipstickTime = Utility.GetCurrentGameTime()-MCMValues.DaysUntilMakeupFades*(1.0-LipStickPct/100.0)  ; modify the time
		Debug.Notification("Your lips are now colored "+LipstickColorName+".")
		HeelsNioScript.SleepRegister()
	endif
	SetLipstickEvent(LipstickColorName, Smudged)
	Game.EnablePlayerControls()
	SlavetatsLock = false
	SendModEvent("dhlp-Resume")
EndEvent ; Lipstick
Event OnEyeshadowEvent(string eventName, string EyeshadowColorName, float EyeshadowHexColor, Form sender)
	OnEyeshadowTweakedEvent(EyeshadowColorName, EyeshadowHexColor as Int)
EndEvent
Event OnEyeshadowTweakedEvent(String EyeshadowColorName, Int EyeshadowHexColor, String Smudged = "")
	SendModEvent("dhlp-Suspend")
	WaitForSlavetatsUnlock()
	SlavetatsLock = true
	Game.DisablePlayerControls()
	if EyeshadowApplied
		Debug.Notification("Removing old Eyeshadow...")
		RemoveEyeshadowTattoo(EyeshadowStyle ,EyeshadowPct,EyeshadowSmudged)
		Game.EnablePlayerControls()
		EyeshadowApplied = false 
		EyeshadowPct = 0
		EyeshadowSmudged = ""
		CustomColorEyeshadow = false
	endif
	if EyeshadowColorName != "" ; only apply new eyeshadow when color name is specified
		if EyeshadowHexColor == -1 ; Custom Color Eyeshadow
			CustomColorEyeshadow = true
			EyeshadowHexColor = MCMValues.EyeshadowCustomColorInt
		endif
		EyeshadowPct = 100
		CurrentEyeshadowColor = EyeshadowHexColor as int
		EyeshadowStyle = "Full"
		EyeshadowSmudged = Smudged
		AddEyeshadowTattoo(EyeshadowStyle,EyeshadowPct,EyeshadowSmudged)
		EyeshadowApplied = true
		AddEyeshadowTime = Utility.GetCurrentGameTime()-MCMValues.DaysUntilMakeupFades*(1.0-EyeshadowPct/100.0)  ; modify the time
		Debug.Notification("Your eyelids are now colored "+EyeshadowColorName+".")
		HeelsNioScript.SleepRegister()
	endif
	SetEyeShadowEvent(EyeshadowColorName, Smudged)
	Game.EnablePlayerControls()
	SlavetatsLock = false
	SendModEvent("dhlp-Resume")
EndEvent ; Eyeshadow
Event OnFingerNailsEvent(string eventName, string argString, float Color, Form sender)
		WaitForSlavetatsUnlock()
		SlavetatsLock = true
		Game.DisablePlayerControls()
		if CurrentNailColor != 0
			if DontEquipFingerNails 
				ColoredNails = NONE
			else
				GetColoredNailsForm(CurrentNailColor)
			endif
			if ColoredNails != NONE
				PlayerActor.UnEquipitem(ColoredNails,true,false)

				PlayerActor.RemoveItem(ColoredNails,1,true)
			endif
			SetNailPolishStage(0)
			RemoveFingernailTattoo()
			Utility.Wait(MCMValues.SlaveTatWaitTime)
			FingernailBigcrackle = false
			FingernailSmallcrackle = false
			FingernailSmudged = false
			DontEquipFingernails = false
			CurrentNailColor = 0
			Debug.Notification("Your old nail polish has been removed.")
			Game.EnablePlayerControls()
		endif
		if (Color >= 1.0) && (Color <= 58.0)
			GetColoredNailsForm(Color as int)
			SetNailPolishStage(10)
			CurrentFingernailColor = NailRBGColors[Color as int]
			AddFingernailTattoo()
			PlayerActor.Equipitem(ColoredNails,false,false)
			Debug.MessageBox("Your finger nails are now all \ncolored"+NailPolishColor[Color as int] +". How pretty!\nYou should avoid running around until the nail polish has completely dried.")
			CurrentNailColor = Color as int
			NailPolishDryStage = 0
			SetNailPolishStage(20)
		endif
		SetFingerNailPolishEvent(NailPolishColor[Color as int], Smudged = FingernailSmudged)
		Game.EnablePlayerControls()
		SlavetatsLock = false
EndEvent
Event OnToeNailsEvent(string eventName, string argString, float Color, Form sender)
      WaitForSlavetatsUnlock()
      SlavetatsLock = true
      if ToenailPolishStage != 0
	Debug.Notification("You sit down and wait for your toenail polish to be removed...")
	if MCMValues.ShowAnimations && ValidatePlayer() 
		Debug.SendAnimationEvent(PlayerActor,"zazapc009")
	endif		
	Game.DisablePlayerControls()
	PlayYpsSound(3,0.0,2.0)
;	if !MCMValues.QuickNailPolishVal
; add here removal toe by toe
;	endif
	SetToenailPolishStage(0)
	RemoveToenailTattoo()
	Utility.Wait(MCMValues.SlaveTatWaitTime)
	ToenailBigcrackle = false
	ToenailSmallcrackle = false
	ToenailSmudged = false
	ToenailpolishApplied = false
	CurrentToenailColor = 0
	if MCMValues.ShowAnimations && ValidatePlayer()
		Debug.SendAnimationEvent(PlayerActor,"IdleForceDefaultState")	
	endif		
	SlavetatsLock = false
	Game.EnablePlayerControls()
      endif
      int ColorNumber = Color as int
      if (Colornumber > 0) && (ColorNumber <= 58)   
	Game.DisablePlayerControls()
	int ToenailHexColor = NailRBGColors[ColorNumber]
	if ToenailHexColor == -1 ; Custom Color 
		CustomColorToenailPolish = true
		ToenailHexColor = MCMValues.EyeshadowCustomColorInt  ;;; later gets its own value
	endif
	if MCMValues.ShowAnimations && ValidatePlayer()
		Debug.SendAnimationEvent(PlayerActor,"zazapc009")
		Game.DisablePlayerControls()
	endif		
	SetToenailPolishStage(10)
	CurrentToenailColor = ToenailHexColor
	AddToenailTattoo()
	if MCMValues.ShowAnimations && ValidatePlayer()
		Debug.SendAnimationEvent(PlayerActor,"IdleForceDefaultState")	
	endif		
	ToenailpolishApplied = true
	ToenailPolishAppliedSince = Utility.GetCurrentGameTime()
	ToenailPolishDryStage = 0
	if YPS04DibellaFollower.Getstage() == 410
		Debug.MessageBox("Finally done! Your toenails are now all \ncolored"+NailPolishColor[Color as int]+". How pretty!")
		SetToenailPolishStage(40)
		Utility.Wait(1.0)
		YPS04DibellaFollower.SetObjectiveCompleted(410)
		YPS04DibellaFollower.SetObjectiveDisplayed(420)
		YPS04DibellaFollower.Setstage(420)
	else
		Debug.MessageBox("Finally done! Your toenails are now all \ncolored"+NailPolishColor[Color as int]+". How pretty!\nYou should not run around until the toenail polish has completely dried.")
		SetToenailPolishStage(20)
	endif
	SetToeNailPolishEvent(NailColor = NailPolishColor[Color as int], Smudged = ToenailSmudged)
	SlavetatsLock = false
	Game.EnablePlayerControls()
      endif
EndEvent
Event OnPiercingEvent(string eventName, string ActorString, float PiercingSlot, Form sender)
    int PSlot = PiercingSlot as int
    if PiercingStage[PSlot]<=0
	string Actorname = ActorString
	if Actorname == ""
		Actorname = "Somebody"
	endif
	WaitForSlavetatsUnlock()
	SlavetatsLock = true
	CurrentlyEquippedPiercingBox[PSlot] = SlaveTatStarterPiercingBox[PSlot]
	CurrentlyEquippedPiercingTattooName[PSlot] = SlaveTatStarterPiercingName[PSlot]
	CurrentlyEquippedPiercingName[PSlot] = "Starter Gold Ball Stud"+PluralS(PiercingSlotNamePlural[PSlot])
	Game.DisablePlayerControls()
	if PSlot == 1 ; earlobes
		StartEarPiercingQuest()
		Debug.Notification(Actorname + " begins gently rubbing your earlobes stimulating your blood circulation. After disinfecting them with some alcohol, ...")
		Utility.Wait(1.0)
		Debug.Notification("..." + Actorname +" marks two points in the center of your earlobes with a pen.")
		Utility.Wait(1.0)
		Debug.Notification("You feel very nervous, as "+Actorname +" takes the piercing gun ...")
		Utility.Wait(2.8)
		PlayPiercingSound(true,false)
		Debug.Notification("... and places a stud in your right earlobe. It hurts just a little bit.")
;		STEBAddTattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot]+"R",0,true,true,3348992,true,MCMValues.SlaveTatLock) ; 3348992 = gold glow
		Utility.Wait(2.0)
		PlayPiercingSound(true,true)
		Debug.Notification("After a moment, " + Actorname + " proceeds with the left earlobe in the same fashion. Both your earlobes are now pierced.")
		STEBAddTattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot],0,true,true,3348992,true,MCMValues.SlaveTatLock)
;		SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot]+"R",true,true)
		Utility.Wait(0.5)
		PlayYpsSound(14,0.5)
		Debug.Notification(Actorname+" then secures both your earrings with earring backs.")
		STEBAddTattoo(PlayerActor,"YpsFashion","PiercingEarringBacks",0,true,true,EarringBacksGlowColor,true,MCMValues.SlaveTatLock)
		PlayYpsSound(14,0.5,0.5)
		EarringBacksWorn = true
	else  
		if (PSlot>=9) && (PSlot <=12)	; need to show your belly
			Utility.Wait(2.0)
			PlayerActor.UnequipItemSlot(32)
		endif
		Debug.Notification(Actorname + " begins gently rubbing your"+PiercingSlotName[PSlot]+" stimulating your blood circulation.")
		Utility.Wait(1.0)
		Debug.Notification("After disinfection, " + Actorname +" marks the location"+PluralS(PiercingSlotNamePlural[PSlot])+"in the center of your"+PiercingSlotName[PSlot]+" with a pen.")
		Utility.Wait(1.0)
		Debug.Notification("You notice the location and feel very nervous, as "+Actorname +" takes the piercing needle ...")
		Utility.Wait(2.8)
		if PiercingSlotNamePlural[PSlot]
; --- later need to add 8 ouches on each side for PSlot == 12
			PlayPiercingSound(false,false)
			Debug.Notification("... and pierces one of your"+PiercingSlotName[PSlot]+". It hurts quite a lot. OUCH!")
			StumbleAnimation(0,true)
			STEBAddTattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot]+"R",0,true,true,3348992,true,MCMValues.SlaveTatLock) ; 3348992 = gold glow
			Utility.Wait(2.0)
			PlayPiercingSound(false,true)
			Debug.Notification("After a moment, " + Actorname + " proceeds with the other side in the same fashion. Both your"+PiercingSlotName[PSlot]+" are now pierced.")
			StumbleAnimation(0,true)
			STEBAddTattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot],0,true,true,3348992,true,MCMValues.SlaveTatLock)
			SlaveTats.simple_remove_tattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot]+"R",true,true)
			Utility.Wait(2.0)
		else
			PlayPiercingSound(false,false)
			Debug.Notification("... and pierces your"+PiercingSlotName[PSlot]+". It hurts quite a lot. OUCH!")
			StumbleAnimation(0,true)
			STEBAddTattoo(PlayerActor,"YpsFashion",CurrentlyEquippedPiercingTattooName[PSlot],0,true,true,3348992,true,MCMValues.SlaveTatLock) ; 3348992 = gold glow
			Utility.Wait(2.0)
			Debug.Notification(" Your"+PiercingSlotName[PSlot]+" is now pierced.")
		endif	
	endif
	PlayerActor.AddSpell(PiercedSpell[PSlot])
	if PSlot==10 ; for nipples/clit add DD piercing perks
		PlayerActor.AddSpell(DDPiercedNipples)
	elseif PSlot==11
		PlayerActor.AddSpell(DDPiercedClit)
	endif
	PiercingHoleFilledSince[PSlot] =  Utility.GetCurrentGameTime()	
	WeldStatus[PSlot] = 60
	PiercingStudWorn[PSlot] = true
	PlayerActor.AddItem(ypsEmptyPiercingBox,1)
	SlavetatsLock = false
	Game.EnablePlayerControls()
    else
	Debug.Notification(" Your"+PiercingSlotName[PSlot]+Has(PiercingSlotNamePlural[PSlot])+" already been pierced.")
    endif
EndEvent
Event OnHaircutEvent(string eventName, string HairstyleName, float HairStage, Form sender)
	Hairscript.DoPlayerHairCut(HairStage as int,false,HairstyleName)
EndEvent
Event OnSetHaircutEvent(string eventName, string HairstyleName, float HairStage, Form sender)
	bool silent = ( HairStage < 0 )
	if silent
		HairStage = - HairStage
	endif
	Hairscript.DoPlayerHairCut(HairStage as int,true,HairstyleName,"",silent)
EndEvent
Event OnHairColorBaseEvent(string eventName, string HairColorName, float HairColor, Form sender)
	Hairscript.SetNaturalHairColor(HairColor as int)
EndEvent
Event OnHairColorDyeEvent(string eventName, string HairColorName, float HairColor, Form sender)
	Hairscript.DoPlayerHairColoring(HairColor as int , HairColorName, false)
	Hairscript.Checkhair()
EndEvent
Event OnForcePermEvent(string eventName, string HairStyleName, float HairLengthStage, Form sender)
	Hairscript.ForcePerm(HairLengthStage as int , HairStyleName)
EndEvent
Event OnForceBuzzedNapeEvent(string eventName, string HairStyleName, float HairLengthStage, Form sender)
	Hairscript.ForceBuzzedNape(HairLengthStage as int , HairStyleName)
EndEvent
Event OnForceBroadMohawkEvent(string eventName, string HairStyleName, float HairLengthStage, Form sender)
	Hairscript.ForceBroadMohawk(HairLengthStage as int , HairStyleName)
EndEvent
Event OnForceNarrowMohawkEvent(string eventName, string HairStyleName, float HairLengthStage, Form sender)
	Hairscript.ForceNarrowMohawk(HairLengthStage as int , HairStyleName)
EndEvent
Event OnDisableHairgrowthEvent(string eventName, string HairStyleName, float HairLengthStage, Form sender)
	Debug.Notification("Hairgrowth is now disabled.")
	Hairscript.EnableHairgrowth = false
EndEvent
Event OnEnableHairgrowthEvent(string eventName, string HairStyleName, float HairLengthStage, Form sender)
	Debug.Notification("Hairgrowth is now enabled.")
	Hairscript.EnableHairgrowth = true
EndEvent
Event OnDisableHairMakeoverEvent(string eventName, string HairStyleName, float HairLengthStage, Form sender)
	Debug.Notification("Hair makeovers are now disabled.")
	Hairscript.EnableHairMakeover = false
EndEvent
Event OnEnableHairMakeoverEvent(string eventName, string HairStyleName, float HairLengthStage, Form sender)
	Debug.Notification("Hair makeovers are now enabled.")
	Hairscript.EnableHairMakeover = true
EndEvent
Event OnArchedFeetEvent(string eventName, string HairStyleName, float HairLengthStage, Form sender)
	HeelsTicker.IncreaseHeelTrainingStatus(40)
EndEvent
Event OnBondageFeetEvent(string eventName, string HairStyleName, float HairLengthStage, Form sender)
	HeelsTicker.IncreaseHeelTrainingStatus(50)
EndEvent

Event OnSetPlayerGenderEvent(string eventName, string ToGender, float Permanent, Form sender)
	int GenderValue = 1
	if ToGender == "male"
		Gendervalue = 0
	endif
	SetPlayerGender(Gendervalue, (Permanent != 0) as int)
EndEvent

Event OnSetPubicHairLengthEvent(string eventName, string VoidString, float NewStatus, Form sender)
	int NewIntStatus = (NewStatus as int)
	if (NewIntStatus >= 0) && (NewIntStatus <= 5)
		UpdatePubicHairStatus(NewIntStatus)
	endif
EndEvent
Event OnSetArmpitsHairLengthEvent(string eventName, string VoidString, float NewStatus, Form sender)
	int NewIntStatus = (NewStatus as int)
	if (NewIntStatus >= 0) && (NewIntStatus <= 5)
		UpdateArmpitHairStatus(NewIntStatus)
	endif
EndEvent

; ===================
; ===== GENERAL =====
; ===================

function SaveGameLoad() ; this is executed from the player alias, once a save game is loaded
	Utility.Wait(9.0)
	RegisterForModEvent("AnimationStart", "SexlabAnimStart")	; hook on Sexlab Animations
	RegisterForModEvent("AnimationEnd", "SexlabAnimEnd")
	RegisterForModEvent("yps-LipstickEvent", "OnLipstickEvent")
	RegisterForModEvent("yps-LipstickTweakedEvent", "OnLipstickTweakedEvent")
	RegisterForModEvent("yps-EyeshadowEvent", "OnEyeshadowEvent")
	RegisterForModEvent("yps-EyeshadowTweakedEvent", "OnEyeshadowTweakedEvent")
	RegisterForModEvent("yps-FingerNailsEvent", "OnFingerNailsEvent")
	RegisterForModEvent("yps-ToeNailsEvent", "OnToeNailsEvent")
	RegisterForModEvent("yps-LockMakeupEvent", "OnLockMakeupEvent")
	RegisterForModEvent("yps-UnlockMakeupEvent", "OnUnlockMakeupEvent")
	RegisterForModEvent("yps-LockPiercingsEvent", "OnLockPiercingsEvent")
	RegisterForModEvent("yps-UnlockPiercingsEvent", "OnUnlockPiercingsEvent")
	RegisterForModEvent("yps-PermanentMakeupEvent", "OnPermanentMakeupEvent")
	RegisterForModEvent("yps-NoPermanentMakeupEvent", "OnNoPermanentMakeupEvent")
	RegisterForModEvent("yps-DisableSmudgingEvent", "OnDisableSmudgingEvent")
	RegisterForModEvent("yps-EnableSmudgingEvent", "OnEnableSmudgingEvent")
	RegisterForModEvent("yps-PiercingEvent", "OnPiercingEvent")

	RegisterForModEvent("yps-ArchedFeetEvent", "OnArchedFeetEvent")
	RegisterForModEvent("yps-BondageFeetEvent", "OnBondageFeetEvent")
	RegisterForModEvent("yps-HaircutEvent", "OnHaircutEvent")
	RegisterForModEvent("yps-HairColorBaseEvent", "OnHairColorBaseEvent")

	RegisterForModEvent("yps-HairColorDyeEvent", "OnHairColorDyeEvent")
	RegisterForModEvent("yps-SetHaircutEvent", "OnSetHaircutEvent")
	RegisterForModEvent("yps-ForcePermEvent", "OnForcePermEvent")
	RegisterForModEvent("yps-ForceBuzzedNapeEvent", "OnForceBuzzedNapeEvent")
	RegisterForModEvent("yps-ForceBroadMohawkEvent", "OnForceBroadMohawkEvent")
	RegisterForModEvent("yps-ForceNarrowMohawkEvent", "OnForceNarrowMohawkEvent")
	RegisterForModEvent("yps-DisableHairgrowthEvent", "OnDisableHairgrowthEvent")
	RegisterForModEvent("yps-EnableHairgrowthEvent", "OnEnableHairgrowthEvent")
	RegisterForModEvent("yps-DisableHairMakeoverEvent", "OnDisableHairMakeoverEvent")
	RegisterForModEvent("yps-EnableHairMakeoverEvent", "OnEnableHairMakeoverEvent")
	RegisterForModEvent("yps-SetPlayerGenderEvent", "OnSetPlayerGenderEvent")
	RegisterForModEvent("yps-SetPubicHairLengthEvent", "OnSetPubicHairLengthEvent")
	RegisterForModEvent("yps-SetArmpitsHairLengthEvent", "OnSetArmpitsHairLengthEvent")
	if MCMValues.HairControlEnabled
		Hairscript.CheckHair()
	endif
	HairScript.LoadDefaultHairstyles()
	
	TweakVersionCheck()
endfunction

Function TweakVersionCheck()
	If StorageUtil.GetFloatValue(None, "yps_TweakVersion", Missing = -1.0) < 1.3
		If StorageUtil.GetFloatValue(None, "yps_TweakVersion", Missing = -1.0) < 1.0
			StorageUtil.SetFloatValue(None, "yps_TweakVersion", 1.0)
			Debug.Notification("YPS Tweak v1.0")
		EndIf
	
		If StorageUtil.GetFloatValue(None, "yps_TweakVersion", Missing = -1.0) < 1.1
			; Remove all pubic hair slavetats. May have been locked by 1.0
			RemoveAllPubicHairSlavetats()
			StorageUtil.SetFloatValue(None, "yps_TweakVersion", 1.1)
			Debug.Notification("YPS Tweak v1.1")
		EndIf
		
		If StorageUtil.GetFloatValue(None, "yps_TweakVersion", Missing = -1.0) < 1.2
			StorageUtil.SetIntValue(None, "yps_PubicHairStage", PubicHairStage)
			StorageUtil.SetFloatValue(None, "yps_TweakVersion", 1.2)
			Debug.Notification("YPS Tweak v1.2")
		EndIf
		
		If StorageUtil.GetFloatValue(None, "yps_TweakVersion", Missing = -1.0) < 1.3
			StorageUtil.SetFloatValue(None, "yps_TweakVersion", 1.3)
			Debug.Notification("YPS Tweak v1.3")
		EndIf
	EndIf
EndFunction

function ShowBodyStatus()
	String StatusString = "Your body status: \n"
	StatusString += "\nPubic Hair Stage: "+PubicHairStage
	StatusString += "\nArmpit Hair Stage: "+ArmpitsHairStage
	if NylonsCurrentlyWorn
		StatusString += "\nCurrently wearing "+NylonsPatternString(CurrentNylonsPattern)+" "+NylonsTypeString(CurrentNylonsType)
	endif
	StatusString += "\nCurrent Fashion level: "+CurrentFashionLevel()
	StatusString += "\nTodays Fashion level: "+TodaysFashionLevel()
	StatusString += "\nFashion Addiction level: "+ (MakeupAddictionLevel as int) + "/11"
	if PlayerFine>0
		StatusString += "\nStill to pay to fund: "+ PlayerFine
	endif
	StatusString += "\n"+ HeelsTicker.CurrentHeelTrainingStatusString()
	int PlayerGender = PlayerActor.GetActorBase().GetSex()
	if PlayerGender >= 0
		StatusString += "\nGender lock: " 
		if RequiredPlayerGender == 0
			StatusString += "male" 
		elseif RequiredPlayerGender == 1
			StatusString += "female" 
		elseif RequiredPlayerGender == -1
			StatusString += "none" 
		endif
		if PlayerGenderPermanent
			StatusString += " (permanent)" 
		endif
	endif
	Debug.Messagebox(StatusString)
endfunction

; ===================
; === SEX CHANGE ====
; ===================

int RequiredPlayerGender = -1 ; -1 = all ok, 0 = male, 1 = female
bool PlayerGenderPermanent = false

function SetPlayerGender(int Gendervalue, bool Permanent = false) ; 0 = male, 1 = female
	if PlayerGenderPermanent
		Debug.Notification("There is no effect. Your current gender is permanent.")
	elseif (Gendervalue == PlayerActor.GetActorBase().GetSex()) && !Permanent
		if (Gendervalue == 0)
			Debug.Notification("There is no effect, because you already are a boy.")
		elseif (Gendervalue == 1)
			Debug.Notification("There is no effect, because you already are a girl.")
		endif	
	else
		if (Gendervalue != PlayerActor.GetActorBase().GetSex())
			if (Gendervalue == 0)
				Debug.Notification("You feel yourself slowly turning into a boy.")
			elseif (Gendervalue == 1)
				Debug.Notification("You feel yourself slowly turning into a girl.")
			endif	
		endif
		RequiredPlayerGender = Gendervalue
		if Permanent
			PlayerGenderPermanent = true
			Utility.Wait(20.0)
			Debug.Notification("You are now permanently locked into your gender. No way back.")
			PlayYpsSound(10)
		endif
	endif
endfunction

function CheckPlayerGender(int Gendervalue) ; 0 = male, 1 = female
	while PlayerActor.GetActorBase().GetSex() != Gendervalue
		if Gendervalue == 0
			Debug.Messagebox("You need to continue your journey as a boy!\n\n(Change your sex in Racemenu)")
		elseif Gendervalue == 1
			Debug.Messagebox("You need to continue your journey as a girl!\n\n(Change your sex in Racemenu)")
		endif
		Utility.Wait(0.3)
		Game.ShowRacemenu()
		Utility.Wait(0.01)
	endwhile
endfunction


; =======================================================
; =======================================================
; =======================================================
; =======================================================
; =======================================================
; =======================================================
; =======================================================
; =======================================================
; =======================================================

int PayFineAmount

float HourlyTickerLastCallTime = 0.0
float property HourlyTickerPeriod = 0.0416666666 autoreadonly ; ingame time (days) for Hourly ticker, 1/24 = 0.041666666666
float DailyTickerLastCallTime = 0.0
float property DailyTickerPeriod = 1.0 autoreadonly ; ingame time (days) for daily ticker, normally 1.0

bool ContinueSlavetatsUpdate = true
bool CheckLipstickScheduled = false
bool CheckEyeshadowScheduled = false
bool CheckArmpitsHairScheduled = false
bool CheckPubicHairScheduled = false
bool CheckFingernailPolishScheduled = false
bool CheckToenailPolishScheduled = false

bool Dibella550BeginWait = false
int property Dibella550EndWait = 0 auto conditional ;  variable used to start dialogue for stage 550
float Dibella550BeginWaitTime = 0.0

bool v514init = false
bool v53init = false
bool v61_init = false

bool property NeedQuaffMetallicPotion = false auto

message property ypsResetNaturalHairColor auto

Event OnUpdate()
	if !v61_init
		v61_init = true
		MCMValues.InitPages()
		Debug.Notification("YPS Immersive Fashion v. 6.2 started." )
		HairScript.InitHairVariables()
		HairScript.SetHairColors()
		HairScript.HairGrowthInit()
		yps04DibellaFollower.Start()
	endif
	if !v53init && UnboundQ.GetStageDone(250)
		v53init = true
		utility.wait(4.0) ; wait first, to reduce game save load (and crash chance)
		if !v514init
			InitializeVariables()
			PiercingStudWorn =  new bool[16]
			CurrentlyEquippedPiercingBox = new MiscObject[16] 
			CurrentlyEquippedPiercingTattooName = new string[16]
			CurrentlyEquippedPiercingName = new string[16]
			MCMValues.InitPages()
			v514init = true
			ColoredNailsForm = new Armor[23]
			OpenSlaveboots = new form[20]
		endif
		SOSPubicHairItems = new form[3]
		RegisterForModEvent("AnimationStart", "SexlabAnimStart")	; hook on Sexlab Animations
		RegisterForModEvent("AnimationEnd", "SexlabAnimEnd")
		RegisterForModEvent("yps-LipstickEvent", "OnLipstickEvent")
		RegisterForModEvent("yps-LipstickTweakedEvent", "OnLipstickTweakedEvent")
		RegisterForModEvent("yps-EyeshadowEvent", "OnEyeshadowEvent")
		RegisterForModEvent("yps-EyeshadowTweakedEvent", "OnEyeshadowTweakedEvent")
		RegisterForModEvent("yps-FingerNailsEvent", "OnFingerNailsEvent")
		RegisterForModEvent("yps-ToeNailsEvent", "OnToeNailsEvent")
		RegisterForModEvent("yps-LockMakeupEvent", "OnLockMakeupEvent")
		RegisterForModEvent("yps-UnlockMakeupEvent", "OnUnlockMakeupEvent")
		RegisterForModEvent("yps-LockPiercingsEvent", "OnLockPiercingsEvent")
		RegisterForModEvent("yps-UnlockPiercingsEvent", "OnUnlockPiercingsEvent")
		RegisterForModEvent("yps-PermanentMakeupEvent", "OnPermanentMakeupEvent")
		RegisterForModEvent("yps-NoPermanentMakeupEvent", "OnNoPermanentMakeupEvent")
		RegisterForModEvent("yps-DisableSmudgingEvent", "OnDisableSmudgingEvent")
		RegisterForModEvent("yps-EnableSmudgingEvent", "OnEnableSmudgingEvent")
		RegisterForModEvent("yps-PiercingEvent", "OnPiercingEvent")
		RegisterForModEvent("yps-ArchedFeetEvent", "OnArchedFeetEvent")
		RegisterForModEvent("yps-BondageFeetEvent", "OnBondageFeetEvent")
		RegisterForModEvent("yps-HaircutEvent", "OnHaircutEvent")
		RegisterForModEvent("yps-HairColorBaseEvent", "OnHairColorBaseEvent")
		RegisterForModEvent("yps-HairColorDyeEvent", "OnHairColorDyeEvent")
		RegisterForModEvent("yps-SetHaircutEvent", "OnSetHaircutEvent")
		RegisterForModEvent("yps-ForcePermEvent", "OnForcePermEvent")
		RegisterForModEvent("yps-ForceBuzzedNapeEvent", "OnForceBuzzedNapeEvent")
		RegisterForModEvent("yps-ForceBroadMohawkEvent", "OnForceBroadMohawkEvent")
		RegisterForModEvent("yps-DisableHairgrowthEvent", "OnDisableHairgrowthEvent")
		RegisterForModEvent("yps-EnableHairgrowthEvent", "OnEnableHairgrowthEvent")
		RegisterForModEvent("yps-DisableHairMakeoverEvent", "OnDisableHairMakeoverEvent")
		RegisterForModEvent("yps-EnableHairMakeoverEvent", "OnEnableHairMakeoverEvent")
		RegisterForModEvent("yps-SetPlayerGenderEvent", "OnSetPlayerGenderEvent")
		RegisterForModEvent("yps-SetPubicHairLengthEvent", "OnSetPubicHairLengthEvent")
		RegisterForModEvent("yps-SetArmpitsHairLengthEvent", "OnSetArmpitsHairLengthEvent")
	endif
	if !PiercingStudWorn || PiercingStudWorn.length < 16
		PiercingStudWorn =  new bool[16]
	endIf
     if ((Utility.GetCurrentGameTime()-HourlyTickerLastCallTime)>=HourlyTickerPeriod) && (PlayerActor.GetSleepState()==0)	  ; ticker for checks that need to be done hourly
		HourlyTickerLastCallTime=Utility.GetCurrentGameTime()
		if NeedQuaffMetallicPotion
			if(yps04DibellaFollower.Getstage() >= 300) && (yps04DibellaFollower.Getstage() <= 590)
				DibellaQuest.QuaffMetallicPotion()
			endif
			if(yps04DibellaFollower.Getstage() == 370) && (!yps04DibellaFollower.IsObjectiveCompleted(350)) ;Fix a previous error in the code
				YPS04DibellaFollower.SetObjectiveDisplayed(370,False)
				yps04DibellaFollower.Stop()
				yps04DibellaFollower.Reset()
			endif
		endif
		if ((yps04DibellaFollower.Getstage() == 550) && (Dibella550EndWait == 0)) ; need to wait 12 hours until talking to Ray again
			if !Dibella550BeginWait
				Dibella550BeginWaitTime = Utility.GetCurrentGameTime()
				Dibella550BeginWait = true
			elseif (Utility.GetCurrentGameTime() - Dibella550BeginWaitTime) >= 0.5
				Dibella550EndWait = 1
			endif
		endif
		if NylonsCurrentlyWorn && !NylonsCurrentlyPaid && ((Utility.GetCurrentGameTime() - NylonsWornSince) >= 0.042) ; after 1 hour game time
			if ypsNylonsPurchase.show()
				NylonsCurrentlyPaid = true
				PlayerFine += 50 ; 
				Debug.Notification("added 50 gold debt to Dibella Fund")
			else
				ApplyNylons(0,0,0,true) ; remove currently worn nylons
			endif
		endif
		CheckLipstickScheduled = true
		CheckEyeshadowScheduled = true 
		CheckArmpitsHairScheduled = MCMValues.ArmpitHairEnabled
		CheckPubicHairScheduled = MCMValues.PubicHairEnabled
	;	CheckFingernailPolishScheduled = !MCMValues.DisablePolishedNailsVal
	;	CheckToenailPolishScheduled = CheckFingernailPolishScheduled ; = !MCMValues.DisablePolishedNailsVal
     endif

     if (!PlayerActor.IsInCombat()) || MCMValues.MakeupUpdateDuringBattle ; postpone slow SlaveTat calls when in battle
		ContinueSlavetatsUpdate = true
		if CheckLipstickScheduled ; only do one SlaveTat call per tick
			ContinueSlavetatsUpdate = !CheckLipstick()
			CheckLipstickScheduled = false
		endif
		if ContinueSlavetatsUpdate
			if CheckEyeshadowScheduled 
				ContinueSlavetatsUpdate = !CheckEyeshadow()
				CheckEyeshadowScheduled = false
			endif
			if  ContinueSlavetatsUpdate
				if CheckArmpitsHairScheduled
					ContinueSlavetatsUpdate = !CheckArmpitsHair()
					CheckArmpitsHairScheduled = false
				endif
				if ContinueSlavetatsUpdate
					if CheckPubicHairScheduled
						ContinueSlavetatsUpdate = !CheckPubicHair()
						CheckPubicHairScheduled = false
					endif
	;				if ContinueSlavetatsUpdate
	;					if CheckFingernailPolishScheduled
	;						ContinueSlavetatsUpdate = !NailPolishCheck()
	;						CheckFingernailPolishScheduled = false
	;					endif
	;					if ContinueSlavetatsUpdate && CheckToenailPolishScheduled
	;						ToeNailPolishCheck() ; ContinueSlavetatsUpdate = !ToeNailPolishCheck()
	;						CheckToenailPolishScheduled = false
	;					endif
	;				endif
				endif
			endif
		endif
     endif

;    if !MCMValues.DisablePolishedNailsVal
;	NailPolishCheck()
;	ToenailPolishCheck()
;    endif

	if (yps04DibellaFollower.Getstage() == 580) && NylonsCurrentlyWorn
		YPS04DibellaFollower.SetObjectiveCompleted(580)
		YPS04DibellaFollower.SetObjectiveDisplayed(590)
		yps04DibellaFollower.Setstage(590)
;		Debug.Messagebox("(provisional end of this quest branch; will be continued in a future update...)")
	endif


	if game.GetModByName("Devious Chastity Piercing.esp") == 255
		ChastityLabiaRings = NONE ; reset the piercings
;		ChastityLabiaRingsShown = NONE
	elseif PlayerActor.hasperk(yps_infibulated) ; just make sure that the device hasn't been removed by another mod
		GetChastityLabiaRingsForm()
		if (ChastityLabiaRings != NONE)
			if PiercingStage[12] <= 0
				PiercingStage[12] = 1
			endif
			if (PlayerActor.GetWornForm(kSlotMask49) != ChastityLabiaRings) && (PlayerActor.GetWornForm(kSlotMask50) != ChastityLabiaRings)
				Debug.Notification("You sense the solid rings on your infibulated genitals.")
				PlayerActor.Equipitem(ChastityLabiaRings,true,true)
;				PlayerActor.Equipitem(ChastityLabiaRingsShown,true,true) ; no longer needed
			endif
			float newarousal = 0.0
			float currentarousal = StorageUtil.GetFloatValue(PlayerActor, "SLAroused.ActorExposure")
			if !infibulation_total_arousal_denial
				float time_diff = Utility.GetCurrentGameTime() - infibulated_since
				if time_diff <= 2.0 		; calculate max, arousal level: starts from 0, then added 2 per day up to maximum of 24, then declining 1 per day to 0
					if showinfibulationnumbmsg
						Debug.Messagebox("Your infibulated vagina feels numb. You can't feel aroused for a few days.")
						showinfibulationnumbmsg = false
					endif
					newarousal = 2 * time_diff
				elseif time_diff <= 10.0 
					if showinfibulationarousalmsg
						Debug.Messagebox("Your labia piercings have healed a bit. You begin to feel your arousal increasing over time.")
						showinfibulationarousalmsg = false
					endif
					newarousal = time_diff * 6.0
					if currentarousal > newarousal
						newarousal = currentarousal
					endif
				elseif time_diff <= 30.0 
					if showinfibulationarousaldecreasemsg
						Debug.Messagebox("Due to your lack of sexual intercourse caused by the infibulation rings, you feel your sexual desire begins slowly fading away.")
						showinfibulationarousaldecreasemsg = false
					endif
					newarousal = 90.0 - (time_diff * 3)
					if currentarousal < newarousal
						newarousal = currentarousal
					endif			
				else
					Playypssound(10)
					Debug.Messagebox("After wearing the infibulation rings for a long period of time, you are no longer exposed to arousal. You may fully concentrate on your daily chores now.")
					infibulation_total_arousal_denial = true
				endif
			endif
			StorageUtil.SetFloatValue(PlayerActor, "SLAroused.ActorExposure",newarousal)
		endif
	endif
	
     if ((Utility.GetCurrentGameTime()-DailyTickerLastCallTime)>=DailyTickerPeriod) && (PlayerActor.GetSleepState()==0)	  ; ticker for checks that need to be done Daily
		if (yps04DibellaFollower.Getstage() >= 300) && (yps04DibellaFollower.Getstage() <= 590)
			NeedQuaffMetallicPotion = true
			DibellaQuest.QuaffMetallicPotion()
		endif
		DailyTickerLastCallTime=Utility.GetCurrentGameTime()
		if MCMValues.AddictionEnabled
			CheckAddictionStatus()
		endif
		if MCMValues.HairControlEnabled
			Hairscript.CheckHairGrowth()
		endif
		InfibScript.InfibulationStainCheck()
		DibellaQuest.CheckPotionProgression()
		DibellaQuest.ChestOperationHealing()
	 elseif MCMValues.HairControlEnabled && MCMValues.FrequentHairControl 
		Hairscript.CheckHair(routine = true)
     endif

     AdjustAddictionBuff()

     if (PlayerFine>0) && (PlayerActor.GetItemCount(Gold001)>0) ; player can payoff some fine
		if PlayerFine>PlayerActor.GetItemCount(Gold001)
			PayFineAmount = PlayerActor.GetItemCount(Gold001)
		else
			PayFineAmount = PlayerFine
		endif
		PlayerFine -= PayFineAmount ; many thanks to Weird for this line ;)
		if PlayerFine == 0
			Debug.Notification("You pay all of your debts to Dibella's Beauty Fund.")
		else
			Debug.Notification("You pay some of your debts to Dibella's Beauty Fund. Still to pay: "+PlayerFine)
		endif
		PlayerActor.RemoveItem(Gold001,PayFineAmount)
     endif
     if MCMValues.PiercingSlotVal[0]	; general monitor enabled
		if MCMValues.PiercingSlotVal[1]   ; earlobes
			CheckPlayerPiercings(1,true)
			EarPiercingStage = PiercingStage[1]
			EarWeldStatus = WeldStatus[1]
		endif
		if MCMValues.PiercingSlotVal[2]   ; left nostril
			CheckPlayerPiercings(2,true)
			LeftNostrilPiercingStage = PiercingStage[2]
			LeftNostrilWeldStatus = WeldStatus[2]
		endif
		if MCMValues.PiercingSlotVal[3]   ; septum
			CheckPlayerPiercings(3,true)
			SeptumPiercingStage = PiercingStage[3]
			SeptumWeldStatus = WeldStatus[3]
		endif
		if MCMValues.PiercingSlotVal[4]   ; snake bites
			CheckPlayerPiercings(4,true)
			SnakeBitesPiercingStage = PiercingStage[4]
			SnakeBitesWeldStatus = WeldStatus[4]
		endif
		if MCMValues.PiercingSlotVal[5]   ; right labret
			CheckPlayerPiercings(5,true)
			RightLabretPiercingStage = PiercingStage[5]
			RightLabretWeldStatus = WeldStatus[5]
		endif
		if MCMValues.PiercingSlotVal[6]   ; (central) labret
			CheckPlayerPiercings(6,true)
			CentralLabretPiercingStage = PiercingStage[6]
			CentralLabretWeldStatus = WeldStatus[6]
		endif
		if MCMValues.PiercingSlotVal[7]   ; right eyebrow
			CheckPlayerPiercings(7,true)
			RightEyebrowPiercingStage = PiercingStage[7]
			RightEyebrowWeldStatus = WeldStatus[7]
		endif
		if MCMValues.PiercingSlotVal[8]   ; nose bridge
			CheckPlayerPiercings(8,true)
			NoseBridgePiercingStage = PiercingStage[8]
			NoseBridgeWeldStatus = WeldStatus[8]
		endif
		if MCMValues.PiercingSlotVal[9]   ; navel
			CheckPlayerPiercings(9,true)
			NavelPiercingStage = PiercingStage[9]
			NavelWeldStatus = WeldStatus[9]
		endif
		if MCMValues.PiercingSlotVal[10]   ; nipples
			CheckPlayerPiercings(10,true)
			NipplePiercingStage = PiercingStage[10]
			NippleWeldStatus = WeldStatus[10]
		endif
		if MCMValues.PiercingSlotVal[11]   ; clit
			CheckPlayerPiercings(11,true)
			ClitPiercingStage = PiercingStage[11]
			ClitWeldStatus = WeldStatus[11]
		endif
		if MCMValues.PiercingSlotVal[12]   ; labia
			CheckPlayerPiercings(12,true)
			LabiaPiercingStage = PiercingStage[12]
			LabiaWeldStatus = WeldStatus[12]
		endif
     endif

	if !MCMValues.DisablePolishedNailsVal
		NailPolishCheck()
		ToeNailPolishCheck()
	endif

    if RequiredPlayerGender >= 0
		CheckPlayerGender(RequiredPlayerGender)
    endif
    RegisterForSingleUpdate(MCMValues.TickerInterval)
endEvent


int HookCount

function ScriptHook() ; script function attached to the "script hook" item, for testing purposes
	if HookCount>=1 ;    <- here need to fill in the max number of options wanted, which are then played through one after the other
		HookCount = 0
	endif
	HookCount += 1
	Debug.Notification("Hook active. Stage "+HookCount)
	if HookCount == 1
;...
	elseif HookCount == 2
		SendModEvent("yps-SetArmpitsHairLengthEvent", "", 4)
	elseif HookCount == 3
		SendModEvent("yps-SetArmpitsHairLengthEvent", "", 0)
	elseif HookCount == 4
		SendModEvent("yps-SetPubicHairLengthEvent", "", 0)
	elseif HookCount == 5
		SendModEvent("yps-SetPubicHairLengthEvent", "", 5)
	elseif HookCount == 6
		SendModEvent("yps-SetArmpitsHairLengthEvent", "", 5)
	endif
EndFunction

; ADDED STUFF =============================================================================

Function SetLipstickEvent(String LipColor, String Smudged)
	StorageUtil.SetStringValue(None, "yps_LipstickColor", LipColor)
	StorageUtil.SetStringValue(None, "yps_LipstickSmudged", Smudged)
	SendFashionChangeEvent("Lipstick")
EndFunction

Function SetEyeShadowEvent(String EyeShadowColor, String Smudged)
	StorageUtil.SetStringValue(None, "yps_EyeShadowColor", EyeShadowColor)
	StorageUtil.SetStringValue(None, "yps_EyeShadowSmudged", Smudged)
	SendFashionChangeEvent("EyeShadow")
EndFunction

Function SetFingerNailPolishEvent(String NailColor, String Smudged)
	StorageUtil.SetStringValue(None, "yps_FingerNailPolishColor", NailColor)
	StorageUtil.SetStringValue(None, "yps_FingerNailPolishSmudged", Smudged)
	SendFashionChangeEvent("FingerNailPolish")
EndFunction

Function SetToeNailPolishEvent(String NailColor, String Smudged)
	StorageUtil.SetStringValue(None, "yps_ToeNailPolishColor", NailColor)
	StorageUtil.SetStringValue(None, "yps_ToeNailPolishSmudged", Smudged)
	SendFashionChangeEvent("ToeNailPolish")
EndFunction

; Tweak mod events and StorageUtil variables ==============================================

Function SendHairStageChangeEvent()
	; StorageUtil.GetIntValue(None, "YpsCurrentHairLengthStage") ; Player's current hair stage. Looks like max hair stage is 21 - Rapunzel
	SendModEvent(eventName = "yps_HairStageChange", strArg = "", numArg = StorageUtil.GetIntValue(None, "YpsCurrentHairLengthStage") as Float)
EndFunction

Function SendPubicHairStageChangeEvent()
	StorageUtil.SetIntValue(None, "yps_PubicHairStage", PubicHairStage)
	SendModEvent(eventName = "yps_PubicHairStageChange", strArg = "", numArg = PubicHairStage as Float)
EndFunction

Function SendAddictionBuffChangeEvent()
	StorageUtil.SetIntValue(None, "yps_AddictionBuff", FashionAddictionBuffLevel)
	SendModEvent(eventName = "yps_AddictionBuffChange", strArg = "", numArg = FashionAddictionBuffLevel)
EndFunction

Function SendAddictionLevelChangeEvent()
	StorageUtil.SetIntValue(None, "yps_AddictionLevel", MakeupAddictionLevel as int)
	SendModEvent(eventName = "yps_AddictionLevel", strArg = "", numArg = (MakeupAddictionLevel as int) as Float)
EndFunction

Function SendFashionChangeEvent(String ChangeType, Float numArg = 0.0)
	; ChangeTypes:
	; Lipstick
	; 		StorageUtil.GetStringValue(None, "yps_LipstickColor")
	; 		StorageUtil.GetStringValue(None, "yps_LipstickSmudged") ; "" = Not smudged, "Smudged" = Smudged
	
	; Eyeshadow
	;		StorageUtil.GetStringValue(None, "yps_EyeShadowColor")
	;		StorageUtil.GetStringValue(None, "yps_EyeShadowSmudged") ; "" = Not smudged, "Smudged" = Smudged
	
	; FingerNailPolish
	;		StorageUtil.GetStringValue(None, "yps_FingerNailPolishColor")
	;		StorageUtil.GetStringValue(None, "yps_FingerNailPolishSmudged") ; "" = Not smudged, "Smudged" = Smudged
	
	; ToeNailPolish
	;		StorageUtil.GetStringValue(None, "yps_ToeNailPolishColor")
	;		StorageUtil.GetStringValue(None, "yps_ToeNailPolishSmudged") ; "" = Not smudged, "Smudged" = Smudged
	
	SendModEvent(eventName = "yps_FashionChange", strArg = ChangeType, numArg = numArg)
EndFunction
