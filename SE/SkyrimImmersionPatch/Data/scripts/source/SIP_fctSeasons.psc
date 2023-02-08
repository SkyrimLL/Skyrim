Scriptname SIP_fctSeasons extends Quest  

Import Utility
Import Math

Location Property TamrielRef  Auto  

; Spring - MA - Marsh
Weather Property SpringOvercast Auto 	; SkyrimCloudy
Weather Property SpringHeavyRain Auto 	; SkyrimStormRain
Weather Property SpringLightRain Auto 	; SkyrimOvercastRain
Weather Property SpringShowers Auto 	; SkyrimOvercastRainMA
Weather Property SpringFog Auto 		; SkyrimFogRE
Weather Property SpringCloudy Auto 		; SkyrimCloudyMA

; Summer - TU - Tundra
Weather Property SummerOvercast Auto 	; SkyrimCloudy
Weather Property SummerCloudy Auto 		; SkyrimCloudyTU
Weather Property SummerFog Auto 		; SkyrimClearTU
Weather Property SummerSun Auto 		; SkyrimFog
Weather Property SummerSunAurora Auto 	; SkyrimClearTU_A

; Fall - FF - Fall Forest
Weather Property FallOvercast Auto 		; SkyrimCloudy
Weather Property FallHeavyRain Auto 	; SkyrimStormRainFF
Weather Property FallLightRain Auto 	; SkyrimOvercastRainFF
Weather Property FallFog Auto 			; SkyrimFogFF
Weather Property FallHeavyFog Auto 		; SkyrimFogMA
Weather Property FallCloudy Auto 		; SkyrimCloudyFF

; Winter - SN -Snow
Weather Property WinterOvercast Auto 	; SkyrimCloudy
Weather Property WinterSnowStorm Auto 	; SkyrimStormSnow
Weather Property WinterSnowFall Auto 	; SkyrimOvercastSnow
Weather Property WinterFog Auto 		; RiftenOvercastFog
Weather Property WinterCloudy Auto 		; SkyrimOvercastSnow

; Seasonal image modifiers
ImageSpaceModifier Property SpringImod  Auto  ; 
ImageSpaceModifier Property SummerImod  Auto  ; Saturated
ImageSpaceModifier Property FallImod  	Auto  ; 
ImageSpaceModifier Property WinterImod  Auto  ; Desaturated

; Disabled for now - moon size cannot be changed in-game apparently
Bool bAlterMoons = False

;/
:: For each season, pick a preferred weather type and add a chance of transition to that weather with OnLocationChange
Spring -  LightRain / HeavyRain / Cloudy
Summer -  TundraSun
Fall - HeavyFog / LightRain / HeavyRain / Cloudy
Winter - SnowFall / SnowStorm / Fog
https://www.creationkit.com/index.php?search=weather&title=Special%3ASearch&fulltext=Search

Reference - https://girlplaysgame.com/2015/08/12/skyrim-ultimate-weather-guide-and-console-commands/
/;

Function updateWeather(Int iSeason, Int iPercentSeason, Bool bForceUpdate)
	Int iRandomNum = utility.RandomInt(0,100)
	Int iThisHour = GetCurrentHourOfDay() 
	Int iSkyMode = Weather.GetSkyMode()
 	Float fImod = ((2 * Math.abs(50 - iPercentSeason)) as Float) / 100.0
 	Weather wLocalWeather = Weather.FindWeather(0) 
	Int iMoonPhase = GetCurrentMoonphase()

 	debug.trace("> Sky mode: " + iSkyMode)
 	debug.trace("> wLocalWeather: " + wLocalWeather)

	; Weather currentWeather = Weather.GetCurrentWeather()


	if (bForceUpdate)
		; Force with local weather for region - potentially useful for Apocrypha or Soul Cairn
		if (wLocalWeather != None)
			wLocalWeather.SetActive(true)
		else
			SpringCloudy.SetActive(true)
		endif

	else

		if (iSkyMode == 3) ; override for full sky only - likely in Tamriel

			if (iMoonPhase==5) || (iMoonPhase==6) ; (iSeason == 0)
				; Spring  
				if (iRandomNum>70) && ( (iThisHour<=6) || (iThisHour>=8))
					SummerSunAurora.SetActive(true)

				elseif (iRandomNum>50) && ( (iThisHour>=7) || (iThisHour<=8))
					SpringFog.SetActive(true)

				elseif (iRandomNum>60) && ( (iPercentSeason<=25) || (iPercentSeason>=75))
					; debug.notification("(Spring Overcast)")
					SpringOvercast.SetActive(true)
				elseif (iRandomNum>80)
					; debug.notification("(Spring Heavy Rain)")
					SpringHeavyRain.SetActive(true)
				elseif (iRandomNum>60)
					; debug.notification("(Spring Light Rain)")
					SpringLightRain.SetActive(true)
				elseif (iRandomNum>40)
					; debug.notification("(Spring Showers)")
					SpringShowers.SetActive(true)
				else
					; debug.notification("(Spring Cloudy)")
					SpringCloudy.SetActive(true)
				endif

				; SpringImod.Apply( fImod )
				if (bAlterMoons)
					Game.SetGameSettingInt("iMasserSize", 30)  	; default 90
					Game.SetGameSettingInt("iSecundaSize", 20) 	; default 40
					Game.SetGameSettingFloat("fSecundaZOffset", 50.0) ; default 50.0
					Game.SetGameSettingFloat("fMasserZOffset", 35.0) ; default 35.0
				endif
				Game.SetGameSettingFloat("fPrecipWindMult", 700.0) ; default 500
 				StorageUtil.SetStringValue(none, "_FT_SeasonsMoonPhase", "Rising moon (spring)")

			elseif (iMoonPhase==7) || (iMoonPhase==0) ; (iSeason == 1)
				; Summer  
				if (iRandomNum>40) && ( (iThisHour<=6) || (iThisHour>=8))
					SummerSunAurora.SetActive(true)

				elseif (iRandomNum>80) && ( (iThisHour>=7) || (iThisHour<=8))
					SummerFog.SetActive(true)

				elseif (iRandomNum>60) && ( (iPercentSeason<=25) || (iPercentSeason>=75))
					; debug.notification("(Summer Overcast)")
					SummerOvercast.SetActive(true)
				elseif (iRandomNum>70)
					; debug.notification("(Summer Cloudy)")
					SummerCloudy.SetActive(true)
				elseif (iRandomNum>10)
					; debug.notification("(Summer Sunny)")
					SummerSunAurora.SetActive(true)
				else
					; debug.notification("(Summer Sunny)")
					SummerSun.SetActive(true)
				endif

				; SummerImod.Apply( fImod )

				if (bAlterMoons)
					Game.SetGameSettingInt("iMasserSize", 90)  	; default 90
					Game.SetGameSettingInt("iSecundaSize", 80) 	; default 40
					Game.SetGameSettingFloat("fSecundaZOffset", 80.0) ; default 50.0
					Game.SetGameSettingFloat("fMasserZOffset", 65.0) ; default 35.0
				endif
				Game.SetGameSettingFloat("fPrecipWindMult", 500.0) ; default 500
 				StorageUtil.SetStringValue(none, "_FT_SeasonsMoonPhase", "Full moon (summer)")

			elseif (iMoonPhase==1) || (iMoonPhase==2) || (iMoonPhase==3)  ; (iSeason == 2)
				; Fall  
				if (iRandomNum>80) && ( (iThisHour<=6) || (iThisHour>=8))
					SummerSunAurora.SetActive(true)

				elseif (iRandomNum>50) && ( (iThisHour>=7) || (iThisHour<=8))
					FallFog.SetActive(true)

				elseif (iRandomNum>60) && ( (iPercentSeason<=25) || (iPercentSeason>=75))
					; debug.notification("(Fall Overcast)")
					FallOvercast.SetActive(true)
				elseif (iRandomNum>80)
					; debug.notification("(Fall Heavy Rain)")
					FallHeavyRain.SetActive(true)
				elseif (iRandomNum>60)
					; debug.notification("(Fall Light Rain)")
					FallLightRain.SetActive(true)
				elseif (iRandomNum>40)
					; debug.notification("(Fall Heavy Fog)")
					FallHeavyFog.SetActive(true)
				else
					; debug.notification("(Fall Cloudy)")
					FallCloudy.SetActive(true)
				endif

				; FallImod.Apply( fImod )
				if (bAlterMoons)
					Game.SetGameSettingInt("iMasserSize", 20)  	; default 90
					Game.SetGameSettingInt("iSecundaSize", 30) 	; default 40
					Game.SetGameSettingFloat("fSecundaZOffset", 35.0) ; default 50.0
					Game.SetGameSettingFloat("fMasserZOffset", 50.0) ; default 35.0
				endif
				Game.SetGameSettingFloat("fPrecipWindMult", 600.0) ; default 500
 				StorageUtil.SetStringValue(none, "_FT_SeasonsMoonPhase", "Waning moon (fall)")

			elseif (iMoonPhase==4) ; (iSeason == 3)
				; Winter 
				if (iRandomNum>60) && ( (iThisHour<=6) || (iThisHour>=8))
					SummerSunAurora.SetActive(true)

				elseif (iRandomNum>70) && ( (iThisHour>=7) || (iThisHour<=8))
					WinterFog.SetActive(true)

				elseif (iRandomNum>60) && ( (iPercentSeason<=25) || (iPercentSeason>=75))
					; debug.notification("(Winter Overcast)")
					WinterOvercast.SetActive(true)
				elseif (iRandomNum>80)
					; debug.notification("(Winter Snow Storm)")
					WinterSnowStorm.SetActive(true)
				elseif (iRandomNum>20)
					; debug.notification("(Winter Snow Fall)")
					WinterSnowFall.SetActive(true)
				elseif (iRandomNum>10)
					; debug.notification("(Winter Fog)")
					WinterFog.SetActive(true)
				else
					; debug.notification("(Winter Cloudy)")
					WinterCloudy.SetActive(true)
				endif
 				StorageUtil.SetStringValue(none, "_FT_SeasonsMoonPhase", "New moon (winter)")

			endif

			; WinterImod.Apply( fImod )
			if (bAlterMoons)
				Game.SetGameSettingInt("iMasserSize", 20)  	; 20 - default 90
				Game.SetGameSettingInt("iSecundaSize", 10) 	; 90 - default 40
				Game.SetGameSettingFloat("fSecundaZOffset", 20.0) ; default 50.0
				Game.SetGameSettingFloat("fMasserZOffset", 15.0) ; default 35.0
			endif
			Game.SetGameSettingFloat("fPrecipWindMult", 800.0) ; default 500
		endif

	endif
	; BadWeather.SetActive(true)

EndFunction



Int Function GetCurrentHourOfDay() 
 
	float Time = Utility.GetCurrentGameTime()
	Time -= Math.Floor(Time) ; Remove "previous in-game days passed" bit
	Time *= 24 ; Convert from fraction of a day to number of hours
	Return (Time as Int)
 
EndFunction


; From: https://www.creationkit.com/index.php?title=Complete_Example_Scripts#A_helper_script_with_functions_to_get_the_current_moonphase.2C_sync_between_the_two_moons_and_day_of_the_week

;/++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+
+	GetPassedGameDays() returns the number of fully passed ingame days
+	as int.
+
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/;
 
Int Function GetPassedGameDays() Global
	Float GameDaysPassed
 
	GameDaysPassed = GetCurrentGameTime()
	Return GameDaysPassed As Int
EndFunction
 
;/++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+
+	GetPassedGameHours() returns the number of passed ingame hours of
+	the current day as int.
+
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/;
 
Int Function GetPassedGameHours() Global
	Float GameTime
	Float GameHoursPassed
 
	GameTime = GetCurrentGameTime()
	GameHoursPassed = ((GameTime - (GameTime As Int)) * 24)
	Return GameHoursPassed As Int
EndFunction

;/++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+
+	GetDayOfWeek() returns the current ingame day of the week as int.
+	
+	Returncodes:
+		0 - Sundas
+		1 - Morndas
+		2 - Tirdas
+		3 - Middas
+		4 - Turdas
+		5 - Fredas
+		6 - Loredas
+
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/;
 
Int Function GetDayOfWeek() Global
	Int GameDaysPassed
 
	GameDaysPassed = GetPassedGameDays()
	return GameDaysPassed % 7
EndFunction

;/++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+
+	GetCurrentMoonPhase() returns an integer representing the current
+	phase of the moons Masser and Secunda based on "SkyrimClimate".
+	Between 12:00 AM and 11:59 AM the phase during the night from last
+	day to this day is returned. Between 12:00 PM and 11:59 PM the
+	phase for the night from this day to next day is returned. Thus
+	a call to the function at night (between 8:00 PM and 6:00 AM) all-
+	ways returns the currently visible phase.
+
+	The returncodes are as follows:
+		0 - Full Moon
+		1 - Decreasing Moon 3/4
+		2 - Decreasing Moon 1/2
+		3 - Decreasing Moon 1/4
+		4 - New Moon
+		5 - Increasing Moon 1/4
+		6 - Increasing Moon 1/2
+		7 - Increasing Moon 3/4
+
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++/;
 
Int Function GetCurrentMoonphase() Global
	Int GameDaysPassed
	Int GameHoursPassed
	Int PhaseTest
	GameDaysPassed = GetPassedGameDays()
	GameHoursPassed = GetPassedGameHours()
 
	If (GameHoursPassed >= 12.0)
		GameDaysPassed += 1
	EndIf
 
	PhaseTest = GameDaysPassed % 24 ;A full cycle through the moon phases lasts 24 days
	If PhaseTest >= 22 || PhaseTest == 0
		Return 7
	ElseIf PhaseTest < 4
		Return 0
	ElseIf PhaseTest < 7
		Return 1
	ElseIf PhaseTest < 10
		Return 2
	ElseIF PhaseTest < 13
		Return 3
	ElseIf PhaseTest < 16
		Return 4
	ElseIf PhaseTest < 19
		Return 5
	ElseIf PhaseTest < 22
		Return 6
	EndIf
 
EndFunction