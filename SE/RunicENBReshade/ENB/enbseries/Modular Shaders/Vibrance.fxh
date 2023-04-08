//=======================//
// Vibrance by Ceejay.dk //
//=======================//

float3 Vibrance(float3 color)
{

	if (USE_Vibrance==true)
	{
	float2 VibranceDayRain; //Desaturation for rainy or foggy weather.
	
	if((Weather.x > (START_RAIN_WEATHER_ID - 0.1) && Weather.x < (END_RAIN_WEATHER_ID + 0.1))||(Weather.x > (START_FOG_WEATHER_ID - 0.1) && Weather.x < (END_FOG_WEATHER_ID + 0.1)))
	VibranceDayRain.x = Vibrance_Day / DesaturationFade + Desaturation;
	else
	VibranceDayRain.x = Vibrance_Day;

	if((Weather.y > (START_RAIN_WEATHER_ID - 0.1) && Weather.y < (END_RAIN_WEATHER_ID + 0.1))||(Weather.y > (START_FOG_WEATHER_ID - 0.1) && Weather.y < (END_FOG_WEATHER_ID + 0.1)))
	VibranceDayRain.y = Vibrance_Day / DesaturationFade + Desaturation;
	else
	VibranceDayRain.y = Vibrance_Day;
	
    float Vibrance              =lerp( lerp(Vibrance_Night,             lerp(VibranceDayRain.y,VibranceDayRain.x,Weather.z),             ENightDayFactor), Vibrance_Interior,             EInteriorFactor );
    float3 VibranceRGBBalance   =lerp( lerp(VibranceRGBBalance_Night,   VibranceRGBBalance_Day,   ENightDayFactor), VibranceRGBBalance_Interior,   EInteriorFactor );
  
	const float3 coefLuma = float3(0.212656, 0.715158, 0.072186);
	float luma = dot(coefLuma, color);

	float max_color = max(color.r, max(color.g, color.b)); // Find the strongest color
	float min_color = min(color.r, min(color.g, color.b)); // Find the weakest color

	float color_saturation = max_color - min_color; // The difference between the two is the saturation

	// Extrapolate between luma and original by 1 + (1-saturation) - current
	float3 coeffVibrance = float3(VibranceRGBBalance * Vibrance);
	color = lerp(luma, color, 1.0 + (coeffVibrance * (1.0 - (sign(coeffVibrance) * color_saturation))));
    }
	return color;
}
