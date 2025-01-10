Scriptname _sdmes_spriggan_bloom extends activemagiceffect  
{ USED }
Import Utility

_SDQS_snp Property snp Auto
_SDQS_functions Property funct Auto
_SDQS_fcts_outfit Property fctOutfit  Auto

_SDQS_config Property config Auto
SexLabFramework property SexLab auto

ReferenceAlias Property _SDRAP_grovemarker  Auto
ReferenceAlias Property _SDRAP_hostarmor  Auto
Keyword Property _SDKP_isbeast  Auto  

Spell Property _SDSP_cum  Auto
Sound Property _SDSM_sloppy  Auto
Sound Property _SDSM_cum  Auto

Int uiPosition
Int uiSubPosition = 0
Int uiStage = 0
Int uiSpuge = 0

int i_SDSM_sloppy_id
int i_SDSM_cum_id

Float fUpdateCum
Float fUpdateSound
Float fUpdateGrunt
Bool  bUpdateGrunt
Float fUpdateSex
Float fStartSex
Float fGCRT

Bool bUpdatePos
Bool bPositionUpdate = False

Actor kTarget
Actor kCaster
ObjectReference kHostArmor = None

VisualEffect Property SprigganFX  Auto  
Float fDistance

Event OnUpdate()
	If ( kCaster.IsDead() || kTarget.IsDead() )
		; Self.Dispel()
		Return
	EndIf

	fGCRT = GetCurrentRealTime()
	fDistance = kCaster.GetDistance( kTarget )

	If ( fGCRT > fUpdateGrunt - 0.3 && bUpdateGrunt )
		bUpdateGrunt = False
		kTarget.SetExpressionOverride( 16, RandomInt( 60, 90 ) )
	EndIf

	; A value smaller than the amount of time it takes your code to complete plus a little
	; overhead time can cause the game to freeze as the scripting system becomes overwhelmed.
	; For any value less than a few seconds RegisterForSingleUpdate is much safer.
	If ( Self )
		RegisterForSingleUpdate( 0.1 )
	EndIf
EndEvent

Event OnEffectStart(Actor akTarget, Actor akCaster)
	; Debug.Notification( "Host: Effect start" )
	Actor PlayerRef = Game.GetPlayer()

	kTarget = akTarget
	kCaster = akCaster
	kHostArmor = _SDRAP_hostarmor.GetReference() as ObjectReference

	fStartSex = GetCurrentRealTime()
	fUpdateSex = GetCurrentRealTime() + RandomFloat( 10.0, 15.0 )
	fUpdateGrunt = GetCurrentRealTime() + 4.0
	fUpdateSound = GetCurrentRealTime() + 1.5
	fUpdateCum = GetCurrentRealTime() + 0.2

	; HACK: position handled by sexlab
	; uiPosition = Math.Floor( snp._SDUIP_position * 4 )


	; Debug.MessageBox("Roots swarm arount you...")

	; kTarget.RemoveAllItems(akTransferTo = _SD_sprigganHusk)
	; Utility.Wait(1.0)

	_SDSP_cum.RemoteCast(kTarget, kTarget, kTarget)
	; kCaster.GetActorBase().SetProtected()
	; kCaster.SetAlpha(0.0)
	SprigganFX.Play( akTarget, 120 )

	_SD_spriggan_sprout1.Disable()
	_SD_spriggan_sprout2.Disable()
	_SD_spriggan_sprout3.Disable()

	Debug.Messagebox("Sprigglings sprout around you...")

	_SD_spriggan_sprout1.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ()), 120.0 * Math.Cos(PlayerRef.GetAngleZ()), PlayerRef.GetHeight() - 35.0)
	_SD_spriggan_sprout2.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ() + 135.0), 120.0 * Math.Cos(PlayerRef.GetAngleZ() + 135.0), PlayerRef.GetHeight() - 35.0)
	_SD_spriggan_sprout3.MoveTo(PlayerRef, 120.0 * Math.Sin(PlayerRef.GetAngleZ() - 135.0), 120.0 * Math.Cos(PlayerRef.GetAngleZ() - 135.0), PlayerRef.GetHeight() - 35.0)

	_SD_spriggan_sprout1.Enable()
	_SD_spriggan_sprout2.Enable()
	_SD_spriggan_sprout3.Enable()

	Utility.Wait(1.0)


	; If  (SexLab.ValidateActor( PlayerRef ) > 0)
 
	;	SexLab.QuickStart(PlayerRef, AnimationTags = "Solo")
	; EndIf

	; If ( Self )
	; 	RegisterForSingleUpdate( 0.1 )
	; EndIf
EndEvent

Event OnEffectFinish(Actor akTarget, Actor akCaster)
	; Debug.Notification( "Host: Effect end" )
	; Game.EnablePlayerControls( abMovement = True )
	; Game.SetPlayerAIDriven( False )

	If ( kCaster.IsDead() )
		kCaster.DeleteWhenAble()
	Else

	_SD_spriggan_sprout1.Disable()
	_SD_spriggan_sprout2.Disable()
	_SD_spriggan_sprout3.Disable()

	_SD_spriggan_sprout1.MoveToMyEditorLocation()
	_SD_spriggan_sprout2.MoveToMyEditorLocation()
	_SD_spriggan_sprout3.MoveToMyEditorLocation()

	_SD_spriggan_sprout1.Enable()
	_SD_spriggan_sprout2.Enable()
	_SD_spriggan_sprout3.Enable()


	;     kCaster.MoveTo( _SDRAP_grovemarker.GetReference() )
	;     kCaster.SetAlpha(1.0)
	;     kCaster.SetRestrained()
	;     kCaster.Disable()

	EndIf
	funct.setRandomActorExpression( kTarget, -1 )
EndEvent

ObjectReference Property _SD_sprigganHusk  Auto  
ObjectReference Property _SD_spriggan_sprout1  Auto  
ObjectReference Property _SD_spriggan_sprout2  Auto  
ObjectReference Property _SD_spriggan_sprout3  Auto  
