Scriptname LoversComfortBrawlScr extends ReferenceAlias 

LoversComfortUtilScr Property lcUtil Auto

Event OnEnterBleedout()
	lcUtil.UpdateSpouseLoverRank(GetActorReference(), -10)
EndEvent