Scriptname SIP_SeasonControlAlias extends ReferenceAlias  

SIP_fctSeasons Property fctSeasons Auto

GlobalVariable Property GV_DaysInYear Auto

Int iGameDateLastCheck = -1
Int iHourLastCheck = -1
Int iDaysSinceLastCheck
Int iDaysPassed
Int iDaysCount  
Int iYearCycle 
Int iSeason

Event OnInit()

	GV_DaysInYear.SetValue(365)

	_maintenance()

EndEvent

Event OnPlayerLoadGame()

	_maintenance()

EndEvent

Function _maintenance()

	UnregisterForAllModEvents()
	Debug.Trace("SkyrimImmersionPatch Seasonal Weather: Reset events")
 
 	RegisterForModEvent("SIPSetDaysInYear",   "OnSetDaysInYearEvent")
 	RegisterForModEvent("SIPSetDaysCount",   "OnSetDaysCountEvent") 

	RegisterForSleep()

 	tryUpdateWeather(True) 
 
EndFunction


Event OnSetDaysInYearEvent(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
 
 	GV_DaysInYear.SetValue(_argc as Int)

 	Debug.Trace("[SIP] Received OnSetDaysInYearEvent - Set iDaysInYear to " + _argc as Int) 
endEvent

Event OnSetDaysCountEvent(String _eventName, String _args, Float _argc = 1.0, Form _sender)
 	Actor kActor = _sender as Actor
 
 	iDaysCount = _argc as Int

 	Debug.Trace("[SIP] Received OnSetDaysInYearEvent - Set iDaysCount to " + _argc as Int) 
endEvent 

Event OnSleepStart(float afSleepStartTime, float afDesiredSleepEndTime)
	Int iDaysInYear = GV_DaysInYear.GetValue() as Int
 
 	iDaysPassed = Game.QueryStat("Days Passed") 

 	; Initial values
 	if (iGameDateLastCheck == -1)
 		iGameDateLastCheck = iDaysPassed 
 		iDaysCount = 0 
 	endIf 
 
	iDaysSinceLastCheck = (iDaysPassed - iGameDateLastCheck ) as Int

	if (iDaysSinceLastCheck>0)
		; celebrate only once a day
		iDaysCount = iDaysCount + iDaysSinceLastCheck 
 
		iYearCycle = (iDaysCount % iDaysInYear)
	 
		if (iYearCycle == 0) 
	 		iDaysCount = 0 
 
		EndIf
	Endif

	iGameDateLastCheck = iDaysPassed  

	Debug.Trace("[SIP] iDaysCount = " + iDaysCount)
	Debug.Trace("[SIP] iDaysInYear = " + iDaysInYear) 
EndEvent

Event OnLocationChange(Location akOldLoc, Location akNewLoc)

 	tryUpdateWeather(False) 

endEvent

Function tryUpdateWeather(Bool bForceUpdate = False) 
	Actor PlayerActor = Game.GetPlayer() as Actor
	ObjectReference PlayerActorRef = Game.GetPlayer() as ObjectReference
	Int iDaysInSeason
	Int iDaysInSeasonTotal
	Int iPercentSeason
	Int iChanceWeatherOverride
	Int iDaysInYear = GV_DaysInYear.GetValue() as Int
	Int iThisHour = GetCurrentHourOfDay() 
	Weather wLocalWeather = Weather.FindWeather(0) 
	Weather wCurrentWeather = Weather.GetCurrentWeather()
	Form fCurrentWeather = wCurrentWeather as Form

	if (PlayerActorRef.IsInInterior())
		debug.trace("[SIP] Player is in Interior Cell - Aborting ")
		return
	endif
 
	iDaysInSeasonTotal = (iDaysInYear / 4)
	iSeason = iDaysCount / iDaysInSeasonTotal
	iDaysInSeason = ( iDaysCount % iDaysInSeasonTotal)

	iPercentSeason = ( iDaysInSeason * 100) /  iDaysInSeasonTotal 

	iChanceWeatherOverride = (100 - ( 2 * Math.abs(50 - iPercentSeason))) as Int

	; cap the chance of weather override to prevent changing weather at every cell location change
	; iChanceWeatherOverride = ( (iChanceWeatherOverride * 60) / 100 )
	if (iChanceWeatherOverride<10)
		iChanceWeatherOverride = 10
	endif

	; New system based on moon phases - fixed chance of weather override +/- 20 %
	iChanceWeatherOverride = 60 + 20 - utility.RandomInt(0,40) 
 
	;/ 		
	debug.notification("[SIP] iDaysInYear: " + iDaysInYear)
	debug.notification("[SIP] iSeason: " + iSeason)
	debug.notification("[SIP] iPercentSeason: " + iPercentSeason)
	debug.notification("[SIP] iChanceWeatherOverride: " + iChanceWeatherOverride)
	/;
	debug.trace("[SIP] iDaysInYear: " + iDaysInYear)
	debug.trace("[SIP] iSeason: " + iSeason)
	debug.trace("[SIP] iDaysInSeasonTotal: " + iDaysInSeasonTotal)
	debug.trace("[SIP] iDaysCount: " + iDaysCount)
	debug.trace("[SIP] iDaysInSeason: " + iDaysInSeason)
	debug.trace("[SIP] iPercentSeason: " + iPercentSeason)
	debug.trace("[SIP] iChanceWeatherOverride: " + iChanceWeatherOverride)
	debug.trace("[SIP] wLocalWeather: " + wLocalWeather)
	debug.trace("[SIP] wCurrentWeather: " + wCurrentWeather)
	debug.trace("[SIP] wCurrentWeather ID: " + fCurrentWeather.GetFormID())
	; debug.notification("[SIP] wCurrentWeather ID: " + fCurrentWeather.GetFormID())


	if (iHourLastCheck==-1)
		iHourLastCheck = iThisHour
	endif

	; enforce at least 1 hour between checks to prevent back to back weather changes
  	if (bForceUpdate) || ((Utility.RandomInt(0,100)<iChanceWeatherOverride)  && ((iThisHour - iHourLastCheck) >=1) )
  		fctSeasons.updateWeather(iSeason, iPercentSeason, bForceUpdate)
  		iHourLastCheck = iThisHour
  		debug.notification("There's a shift in the air ... " + StorageUtil.GetStringValue(none, "_FT_SeasonsWeather") )
  		; debug.notification("Moon phase: " + StorageUtil.GetStringValue(none, "_FT_SeasonsMoonPhase") )
  	else
  		if wCurrentWeather.GetClassification() == -1
		  	Debug.Notification(">> Missing weather detected - weather classification is -1")
  			wLocalWeather.SetActive(true)
  		else
  			; Debug.Notification(">> Current weather classification: " + wCurrentWeather.GetClassification())
		endIf
  	endif
EndFunction

Int Function GetCurrentHourOfDay() 
 
	float Time = Utility.GetCurrentGameTime()
	Time -= Math.Floor(Time) ; Remove "previous in-game days passed" bit
	Time *= 24 ; Convert from fraction of a day to number of hours
	Return (Time as Int)
 
EndFunction


float function fMin(float  a, float b)
	if (a<=b)
		return a
	else
		return b
	EndIf
EndFunction

float function fMax(float a, float b)
	if (a<b)
		return b
	else
		return a
	EndIf
EndFunction