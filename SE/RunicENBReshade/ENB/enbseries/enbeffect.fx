//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ENBSeries TES Skyrim SE hlsl DX11 format, post process
// visit http://enbdev.com for updates
// Author: Boris Vorontsov
//-----------------------CREDITS-----------------------


// Post process file for Rudy ENB SE edited by Rudy102
// [HLSL CODE] 3D LUT by Kingeric1992
// Fade u/O-Deka-K and Kingeric1992
// Separation code Boris and Tapioks
// Integration of Night Eye code by Phinix - https://www.nexusmods.com/skyrimspecialedition/mods/9162


//Warning! In this version Weather index is not yet implemented




//========== GUI ==========================================

float Empty_Row0 <
  string UIName="---------NIGHT BRIGHTNESS LEVEL";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

float		fNightlevel 			
< 
string UIName="Nights: 0.5:Brighter 1.0:Normal 1.5:Darker"; 
string UIWidget="Spinner"; 	float UIMin=0.5;  float UIMax=1.5;  float UIStep=0.1;
> = {1.0};

float Empty_Row1 <
  string UIName="---------INTERIORS BRIGHTNESS LEVEL";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

float		fInteriorlevel 			
< 
string UIName="Interiors: 0.5:Brighter 1.0:Normal 2.0:Darker"; 
string UIWidget="Spinner"; 	float UIMin=0.5;  float UIMax=2.0;  float UIStep=0.1;
> = {1.0};

float Empty_Row2 <
  string UIName="-------------------BRIGHTNESS";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

float EBrightnessV2Dawn
<
string UIName="Brightness - Dawn";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {0.9};

float EBrightnessV2Sunrise
<
string UIName="Brightness - Sunrise";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {1.0};

float EBrightnessV2Day
<
string UIName="Brightness - Day";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {1.0};

float EBrightnessV2Sunset
<
string UIName="Brightness - Sunset";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {1.00};

float EBrightnessV2Dusk
<
string UIName="Brightness - Dusk";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {0.9};

float EBrightnessV2Night
<
string UIName="Brightness - Night";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {0.75};

float Empty_Row3 <
  string UIName="-------------------ADAPTATION MIN";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

float EAdaptationMinV2Dawn
<
string UIName="Adaptation Min - Dawn ";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.09};

float EAdaptationMinV2Sunrise
<
string UIName="Adaptation Min - Sunrise ";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.09};

float EAdaptationMinV2Day
<
string UIName="Adaptation Min - Day ";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.09};

float EAdaptationMinV2Sunset
<
string UIName="Adaptation Min - Sunset";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.05};

float EAdaptationMinV2Dusk
<
string UIName="Adaptation Min - Dusk";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.05};

float EAdaptationMinV2Night
<
string UIName="Adaptation Min - Night";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.05};

float Empty_Row4 <
  string UIName="-------------------ADAPTATION MAX";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};


float EAdaptationMaxV2Dawn
<
string UIName="Adaptation Max - Dawn";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.09};

float EAdaptationMaxV2Sunrise
<
string UIName="Adaptation Max - Sunrise";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.09};

float EAdaptationMaxV2Day
<
string UIName="Adaptation Max - Day";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.09};

float EAdaptationMaxV2Sunset
<
string UIName="Adaptation Max - Sunset";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.1};

float EAdaptationMaxV2Dusk
<
string UIName="Adaptation Max - Dusk";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.1};

float EAdaptationMaxV2Night
<
string UIName="Adaptation Max - Night";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.1};

float Empty_Row5 <
  string UIName="-------------------TONEMAPPING CURVE";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

float EToneMappingCurveV2Dawn
<
string UIName="ToneMapping Curve - Dawn";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {7.0};

float EToneMappingCurveV2Sunrise
<
string UIName="ToneMapping Curve - Sunrise";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {6.0};

float EToneMappingCurveV2Day
<
string UIName="ToneMapping Curve - Day";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {5.0};

float EToneMappingCurveV2Sunset
<
string UIName="ToneMapping Curve - Sunset";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {6.0};

float EToneMappingCurveV2Dusk
<
string UIName="ToneMapping Curve - Dusk";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {8.0};

float EToneMappingCurveV2Night
<
string UIName="ToneMapping Curve - Night";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {10.0};

float Empty_Row6 <
  string UIName="-------------------CONTRAST";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

float EIntensityContrastV2Dawn
<
string UIName="Contrast - Dawn";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.5};

float EIntensityContrastV2Sunrise
<
string UIName="Contrast - Sunrise";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.5};

float EIntensityContrastV2Day
<
string UIName="Contrast - Day";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.5};

float EIntensityContrastV2Sunset
<
string UIName="Contrast - Sunset";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.35};

float EIntensityContrastV2Dusk
<
string UIName="Contrast - Dusk";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.35};

float EIntensityContrastV2Night
<
string UIName="Contrast - Night";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.35};

float Empty_Row7 <
  string UIName="-------------------SATURATION";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

float EColorSaturationV2Dawn
<
string UIName="Saturation - Dawn";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.5};

float EColorSaturationV2Sunrise
<
string UIName="Saturation - Sunrise";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.5};

float EColorSaturationV2Day
<
string UIName="Saturation - Day";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.5};

float EColorSaturationV2Sunset
<
string UIName="Saturation - Sunset";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {0.9};

float EColorSaturationV2Dusk
<
string UIName="Saturation - Dusk";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {0.9};

float EColorSaturationV2Night
<
string UIName="Saturation - Night";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {0.9};

float Empty_Row8 <
  string UIName="-------------------OVERBRIGHT DAMP";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};
		
float EToneMappingOversaturationV2Dawn
<
string UIName="Overbright Dampening - Dawn";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {60.0};

float EToneMappingOversaturationV2Sunrise
<
string UIName="Overbright Dampening - Sunrise";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {60.0};

float EToneMappingOversaturationV2Day
<
string UIName="Overbright Dampening - Day";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {60.0};

float EToneMappingOversaturationV2Sunset
<
string UIName="Overbright Dampening - Sunset";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {50.0};

float EToneMappingOversaturationV2Dusk
<
string UIName="Overbright Dampening - Dusk";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {50.0};

float EToneMappingOversaturationV2Night
<
string UIName="Overbright Dampening - Night";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {50.0};

float Empty_Row9 <
  string UIName="-------------------INTERIORS";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

float EBrightnessV2Interior
<
string UIName="Brightness - Interior";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=2.0;
> = {0.35};

float EAdaptationMinV2Interior
<
string UIName="Adaptation Min - Interior";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.025};

float EAdaptationMaxV2Interior
<
string UIName="Adaptation Max - Interior";
string UIWidget="Spinner";
float UIStep=0.001;
float UIMin=0.0;
float UIMax=1.0;
> = {0.3};

float EToneMappingCurveV2Interior
<
string UIName="ToneMapping Curve - Interior";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=100.0;
> = {0.95};

float EIntensityContrastV2Interior
<
string UIName="Contrast - Interior";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.1};

float EColorSaturationV2Interior
<
string UIName="Saturation - Interior";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=10.0;
> = {1.1};

float EToneMappingOversaturationV2Interior
<
string UIName="Overbright Dampening - Interior";
string UIWidget="Spinner";
float UIMin=0.0;
float UIMax=200.0;
> = {30.0};

float Empty_Row10 <
  string UIName="-------------------FADE";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

bool EnableFade
<
string UIName="Enable Fade Transition";
> = {true};



///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Khajiit Nighteye Adjustment
int		KNEA 				< string UIName="-------------------NIGHTEYE ADJUSTMENT"; string UIWidget="spinner"; int UIMin=0; int UIMax=0;> = {0.0};
bool	KNEnable		<string UIName = "Use Nighteye Fix";>																		= {false};
		float	KNDetect1		<string UIName="Params01[5].w > VALUE*0.1";string UIWidget="Spinner";float UIMin=0.0;float UIMax=6.0;>		= {0.97};
		float	KNDetect2		<string UIName="Params01[5].w < VALUE*0.1";string UIWidget="Spinner";float UIMin=0.0;float UIMax=11.0;>		= {0.99};
		float	KNDetect3		<string UIName="Params01[4].w > VALUE";string UIWidget="Spinner";float UIMin=0.0;float UIMax=1.0;>			= {0.3};
		float	KNDetect4		<string UIName="Params01[4].w < VALUE";string UIWidget="Spinner";float UIMin=0.0;float UIMax=1.0;>			= {0.8};
		float3	KNBalance		<string UIName="Nighteye Balance";string UIWidget="Color";>													= {0.537, 0.647, 1};
		float	KNSaturationInterior	<string UIName="Nighteye SaturationInterior";string UIWidget="Spinner";float UIMin=0.0;float UIMax=10.0;>			= {1.0};
		float	KNSaturationExterior	<string UIName="Nighteye SaturationExterior";string UIWidget="Spinner";float UIMin=0.0;float UIMax=10.0;>			= {1.0};
		float	KNBrightnessInterior	<string UIName="Nighteye BrightnessInterior";string UIWidget="Spinner";float UIMin=-5.0;float UIMax=5.0;>			= {0.0};
        float	KNBrightnessExterior	<string UIName="Nighteye BrightnessExterior";string UIWidget="Spinner";float UIMin=-5.0;float UIMax=5.0;>			= {0.0};
		float	KNContrastInterior		<string UIName="Nighteye ContrastInterior";string UIWidget="Spinner";float UIMin=0.0;float UIMax=5.0;>				= {0.99};
		float	KNContrastExterior		<string UIName="Nighteye ContrastExterior";string UIWidget="Spinner";float UIMin=0.0;float UIMax=5.0;>				= {0.99};
		float	KNInBlackInterior		<string UIName="Nighteye Low ClipInterior";string UIWidget="Spinner";float UIMin=0.0;float UIMax=1.0;>				= {0.0};
		float	KNInBlackExterior		<string UIName="Nighteye Low ClipExterior";string UIWidget="Spinner";float UIMin=0.0;float UIMax=1.0;>				= {0.0};
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////



#ifdef E_CC_PROCEDURAL
//parameters for ldr color correction
float	ECCGamma
<
	string UIName="CC: Gamma";
	string UIWidget="Spinner";
	float UIMin=0.2;//not zero!!!
	float UIMax=5.0;
> = {1.5};

float	ECCInBlack
<
	string UIName="CC: In black";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCInWhite
<
	string UIName="CC: In white";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float	ECCOutBlack
<
	string UIName="CC: Out black";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCOutWhite
<
	string UIName="CC: Out white";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float	ECCBrightness
<
	string UIName="CC: Brightness";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {1.0};

float	ECCContrastGrayLevel
<
	string UIName="CC: Contrast gray level";
	string UIWidget="Spinner";
	float UIMin=0.01;
	float UIMax=0.99;
> = {0.5};

float	ECCContrast
<
	string UIName="CC: Contrast";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {1.0};

float	ECCSaturation
<
	string UIName="CC: Saturation";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {1.0};

float	ECCDesaturateShadows
<
	string UIName="CC: Desaturate shadows";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float3	ECCColorBalanceShadows <
	string UIName="CC: Color balance shadows";
	string UIWidget="Color";
> = {0.5, 0.5, 0.5};

float3	ECCColorBalanceHighlights <
	string UIName="CC: Color balance highlights";
	string UIWidget="Color";
> = {0.5, 0.5, 0.5};

float3	ECCChannelMixerR <
	string UIName="CC: Channel mixer R";
	string UIWidget="Color";
> = {1.0, 0.0, 0.0};

float3	ECCChannelMixerG <
	string UIName="CC: Channel mixer G";
	string UIWidget="Color";
> = {0.0, 1.0, 0.0};

float3	ECCChannelMixerB <
	string UIName="CC: Channel mixer B";
	string UIWidget="Color";
> = {0.0, 0.0, 1.0};
#endif //E_CC_PROCEDURAL	

//bool 	enablelut <	string UIName="Enable LUT";	> = {true};

/*
//example parameters with annotations for in-game editor
float	ExampleScalar
<
	string UIName="Example scalar";
	string UIWidget="spinner";
	float UIMin=0.0;
	float UIMax=1000.0;
> = {1.0};

float3	ExampleColor
<
	string UIName = "Example color";
	string UIWidget = "color";
> = {0.0, 1.0, 0.0};

float4	ExampleVector
<
	string UIName="Example vector";
	string UIWidget="vector";
> = {0.0, 1.0, 0.0, 0.0};

int	ExampleQuality
<
	string UIName="Example quality";
	string UIWidget="quality";
	int UIMin=0;
	int UIMax=3;
> = {1};

Texture2D ExampleTexture
<
	string UIName = "Example texture";
	string ResourceName = "test.bmp";
>;
SamplerState ExampleSampler
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Clamp;
	AddressV = Clamp;
};
*/






//+++++++++++++++++++++++++++++
//external enb parameters, do not modify
//+++++++++++++++++++++++++++++
//x = generic timer in range 0..1, period of 16777216 ms (4.6 hours), y = average fps, w = frame time elapsed (in seconds)
float4	Timer;
//x = Width, y = 1/Width, z = aspect, w = 1/aspect, aspect is Width/Height
float4	ScreenSize;
//changes in range 0..1, 0 means full quality, 1 lowest dynamic quality (0.33, 0.66 are limits for quality levels)
float	AdaptiveQuality;
//x = current weather index, y = outgoing weather index, z = weather transition, w = time of the day in 24 standart hours. Weather index is value from weather ini file, for example WEATHER002 means index==2, but index==0 means that weather not captured.
float4	Weather;
//x = dawn, y = sunrise, z = day, w = sunset. Interpolators range from 0..1
float4	TimeOfDay1;
//x = dusk, y = night. Interpolators range from 0..1
float4	TimeOfDay2;
//changes in range 0..1, 0 means that night time, 1 - day time
float	ENightDayFactor;
//changes 0 or 1. 0 means that exterior, 1 - interior
float	EInteriorFactor;

//+++++++++++++++++++++++++++++
//external enb debugging parameters for shader programmers, do not modify
//+++++++++++++++++++++++++++++
//keyboard controlled temporary variables. Press and hold key 1,2,3...8 together with PageUp or PageDown to modify. By default all set to 1.0
float4	tempF1; //0,1,2,3
float4	tempF2; //5,6,7,8
float4	tempF3; //9,0
// xy = cursor position in range 0..1 of screen;
// z = is shader editor window active;
// w = mouse buttons with values 0..7 as follows:
//    0 = none
//    1 = left
//    2 = right
//    3 = left+right
//    4 = middle
//    5 = left+middle
//    6 = right+middle
//    7 = left+right+middle (or rather cat is sitting on your mouse)
float4	tempInfo1;
// xy = cursor position of previous left mouse button click
// zw = cursor position of previous right mouse button click
float4	tempInfo2;



//+++++++++++++++++++++++++++++
//game and mod parameters, do not modify
//+++++++++++++++++++++++++++++
float4				Params01[7]; //skyrimse parameters
//x - bloom amount; y - lens amount
float4				ENBParams01; //enb parameters

float3				LumCoeff = float3(0.2125, 0.7154, 0.0721);

Texture2D			TextureColor; //hdr color
Texture2D			TextureBloom; //vanilla or enb bloom
Texture2D			TextureLens; //enb lens fx
Texture2D			TextureDepth; //scene depth
Texture2D			TextureAdaptation; //vanilla or enb adaptation
Texture2D			TextureAperture; //this frame aperture 1*1 R32F hdr red channel only. computed in depth of field shader file

SamplerState		Sampler0
{
	Filter = MIN_MAG_MIP_POINT;//MIN_MAG_MIP_LINEAR;
	AddressU = Clamp;
	AddressV = Clamp;
};
SamplerState		Sampler1
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Clamp;
	AddressV = Clamp;
};



//+++++++++++++++++++++++++++++
//
//+++++++++++++++++++++++++++++
struct VS_INPUT_POST
{
	float3 pos		: POSITION;
	float2 txcoord	: TEXCOORD0;
};
struct VS_OUTPUT_POST
{
	float4 pos		: SV_POSITION;
	float2 txcoord0	: TEXCOORD0;
};

	#include "/Modular Shaders/enbeffect_AdaptTool.fxh"

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
VS_OUTPUT_POST	VS_Draw(VS_INPUT_POST IN)
{
	VS_OUTPUT_POST	OUT;
	float4	pos;
	pos.xyz=IN.pos.xyz;
	pos.w=1.0;
	OUT.pos=pos;
	OUT.txcoord0.xy=IN.txcoord.xy;
	return OUT;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// BEGIN PIXEL SHADER
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4  PS_Draw(VS_OUTPUT_POST IN, float4 v0 : SV_Position0, uniform Texture2D LUTtex, uniform bool enablelut) : SV_Target
{
	float4	res;
	float4	color;

	color=TextureColor.Sample(Sampler0, IN.txcoord0.xy); //hdr scene color
	


	float3	lens;
	lens.xyz=TextureLens.Sample(Sampler1, IN.txcoord0.xy).xyz;
	color.xyz+=lens.xyz * ENBParams01.y; //lens amount

	float3	bloom=TextureBloom.Sample(Sampler1, IN.txcoord0.xy);

	bloom.xyz=bloom-color;
	bloom.xyz=max(bloom, 0.0);
	color.xyz+=bloom*ENBParams01.x; //bloom amount

	float hnd = ENightDayFactor;
	float pi = (1-EInteriorFactor);

	float	grayadaptation=TextureAdaptation.Sample(Sampler0, IN.txcoord0.xy).x;

if (EnableFade && Params01[4].w<KNDetect3)
{
    float3 fade        = Params01[5].xyz; // fade current scene to specified color, mostly used in special effects
    float  fade_weight = Params01[5].w;   // 0 == no fade
   
    color.rgb = lerp(color.rgb, fade, fade_weight);
}


//========== Tapioks Separation =================================


float   timeweight;
float   timevalue;

//FIRST
timeweight=0.000001;
timevalue=0.0;

timevalue+=TimeOfDay1.x * EBrightnessV2Dawn;
timevalue+=TimeOfDay1.y * EBrightnessV2Sunrise;
timevalue+=TimeOfDay1.z * EBrightnessV2Day;
timevalue+=TimeOfDay1.w * EBrightnessV2Sunset;
timevalue+=TimeOfDay2.x * EBrightnessV2Dusk;
timevalue+=TimeOfDay2.y * EBrightnessV2Night;

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;

	float newEBrightnessV2;
	newEBrightnessV2=lerp((timevalue / timeweight), EBrightnessV2Interior, EInteriorFactor );

//SECOND
timeweight=0.000001;
timevalue=0.0;

	
timevalue+=TimeOfDay1.x * EColorSaturationV2Dawn;
timevalue+=TimeOfDay1.y * EColorSaturationV2Sunrise;
timevalue+=TimeOfDay1.z * EColorSaturationV2Day;
timevalue+=TimeOfDay1.w * EColorSaturationV2Sunset;
timevalue+=TimeOfDay2.x * EColorSaturationV2Dusk;
timevalue+=TimeOfDay2.y * EColorSaturationV2Night;

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;

	float newEColorSaturationV2;
	newEColorSaturationV2=lerp((timevalue / timeweight), EColorSaturationV2Interior, EInteriorFactor );
	
//Third
timeweight=0.000001;
timevalue=0.0;
	
timevalue+=TimeOfDay1.x * EAdaptationMaxV2Dawn;
timevalue+=TimeOfDay1.y * EAdaptationMaxV2Sunrise;
timevalue+=TimeOfDay1.z * EAdaptationMaxV2Day;
timevalue+=TimeOfDay1.w * EAdaptationMaxV2Sunset;
timevalue+=TimeOfDay2.x * EAdaptationMaxV2Dusk;
timevalue+=TimeOfDay2.y * EAdaptationMaxV2Night;

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;

	float newEAdaptationMax;
	newEAdaptationMax=lerp((timevalue / timeweight), EAdaptationMaxV2Interior, EInteriorFactor );

//Fourth
timeweight=0.000001;
timevalue=0.0;
	
timevalue+=TimeOfDay1.x * EAdaptationMinV2Dawn;
timevalue+=TimeOfDay1.y * EAdaptationMinV2Sunrise;
timevalue+=TimeOfDay1.z * EAdaptationMinV2Day;
timevalue+=TimeOfDay1.w * EAdaptationMinV2Sunset;
timevalue+=TimeOfDay2.x * EAdaptationMinV2Dusk;
timevalue+=TimeOfDay2.y * EAdaptationMinV2Night;

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;
 
	float newEAdaptationMin;
	newEAdaptationMin=lerp( (timevalue / timeweight), EAdaptationMinV2Interior, EInteriorFactor );

//Fourth
timeweight=0.000001;
timevalue=0.0;
	
timevalue+=TimeOfDay1.x * EToneMappingCurveV2Dawn;
timevalue+=TimeOfDay1.y * EToneMappingCurveV2Sunrise;
timevalue+=TimeOfDay1.z * EToneMappingCurveV2Day;
timevalue+=TimeOfDay1.w * EToneMappingCurveV2Sunset;
timevalue+=TimeOfDay2.x * EToneMappingCurveV2Dusk;
timevalue+=TimeOfDay2.y * (EToneMappingCurveV2Night*fNightlevel);

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;

	float newEToneMappingCurve;
	newEToneMappingCurve=lerp( (timevalue / timeweight), EToneMappingCurveV2Interior*fInteriorlevel, EInteriorFactor );

//Fifth
timeweight=0.000001;
timevalue=0.0;
	
timevalue+=TimeOfDay1.x * EIntensityContrastV2Dawn;
timevalue+=TimeOfDay1.y * EIntensityContrastV2Sunrise;
timevalue+=TimeOfDay1.z * EIntensityContrastV2Day;
timevalue+=TimeOfDay1.w * EIntensityContrastV2Sunset;
timevalue+=TimeOfDay2.x * EIntensityContrastV2Dusk;
timevalue+=TimeOfDay2.y * EIntensityContrastV2Night;

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;
	
	float newEIntensityContrastV2;
	newEIntensityContrastV2=lerp( (timevalue / timeweight), EIntensityContrastV2Interior, EInteriorFactor );

//Sixth
timeweight=0.000001;
timevalue=0.0;
	
timevalue+=TimeOfDay1.x * EToneMappingOversaturationV2Dawn;
timevalue+=TimeOfDay1.y * EToneMappingOversaturationV2Sunrise;
timevalue+=TimeOfDay1.z * EToneMappingOversaturationV2Day;
timevalue+=TimeOfDay1.w * EToneMappingOversaturationV2Sunset;
timevalue+=TimeOfDay2.x * EToneMappingOversaturationV2Dusk;
timevalue+=TimeOfDay2.y * EToneMappingOversaturationV2Night;

timeweight+=TimeOfDay1.x;
timeweight+=TimeOfDay1.y;
timeweight+=TimeOfDay1.z;
timeweight+=TimeOfDay1.w;
timeweight+=TimeOfDay2.x;
timeweight+=TimeOfDay2.y;

	float newEToneMappingOversaturationV2;
	newEToneMappingOversaturationV2=lerp( (timevalue / timeweight), EToneMappingOversaturationV2Interior, EInteriorFactor );
	

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////		
	
        float KNSaturation = lerp( KNSaturationExterior, KNSaturationInterior, EInteriorFactor );
		float KNBrightness = lerp( KNBrightnessExterior, KNBrightnessInterior, EInteriorFactor );
		float KNContrast = lerp( KNContrastExterior, KNContrastInterior, EInteriorFactor );
		float KNInBlack = lerp( KNInBlackExterior, KNInBlackInterior, EInteriorFactor );
		//Khajiit Nighteye Correction by Phinix
			float4 kncolor = color;
		// color balance	
			float3 knsat = KNBalance;
			float3 knoldcol=kncolor.xyz;
			kncolor.xyz *= knsat;
			float3 kngrey = float3(0.333,0.333,0.333);
			kncolor.xyz += (knoldcol.x-(knoldcol.x*knsat.x)) * kngrey.x;
			kncolor.xyz += (knoldcol.y-(knoldcol.y*knsat.y)) * kngrey.y;
			kncolor.xyz += (knoldcol.z-(knoldcol.z*knsat.z)) * kngrey.z;
		// saturation
			float3 intensity = dot(kncolor.rgb, LumCoeff);
			kncolor.rgb = lerp(intensity, kncolor.rgb, KNSaturation);
			kncolor.rgb /= kncolor.a;
		// contrast
			kncolor.rgb = ((kncolor.rgb - 0.5) * max(KNContrast, 0)) + 0.5;
		// brightness
			kncolor.rgb += (KNBrightness*0.1);
			kncolor.rgb *= kncolor.a;
		// low clip
			kncolor=max(kncolor-(KNInBlack*0.1), 0.0) / max(1.0-(KNInBlack*0.1), 0.0001);
		// bool for output - check whitefactor (Params01[2].y) as well as fade weight (Params01[5].w)
		//
		// to avoid activating for wrong image space (may need tweaking)
			bool knactive = ((Params01[5].w>KNDetect1*0.1)*(Params01[5].w<KNDetect2*0.1)*(Params01[4].w>KNDetect3)*(Params01[4].w<KNDetect4));
			
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////

		//return color;
		color = lerp(color,kncolor,(knactive)*(KNEnable));

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////					
	
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
			
//MIXING
	grayadaptation=max(grayadaptation, 0.0);
	grayadaptation=min(grayadaptation, 50.0);
	color.xyz=color.xyz/(grayadaptation*newEAdaptationMax+newEAdaptationMin);//*tempF1.x

	color.xyz*=(newEBrightnessV2);
	color.xyz+=0.000001;
	float3 xncol=normalize(color.xyz);
	float3 scl=color.xyz/xncol.xyz;
	scl=pow(scl, newEIntensityContrastV2);
	xncol.xyz=pow(xncol.xyz, newEColorSaturationV2);
	color.xyz=scl*xncol.xyz;

	float	lumamax=newEToneMappingOversaturationV2;
	color.xyz=(color.xyz * (1.0 + color.xyz/lumamax))/(color.xyz + newEToneMappingCurve);
	


#ifdef E_CC_PROCEDURAL
	//activated by UseProceduralCorrection=true
	float	tempgray;
	float4	tempvar;
	float3	tempcolor;

	//+++ levels like in photoshop, including gamma, lightness, additive brightness
	color=max(color-ECCInBlack, 0.0) / max(ECCInWhite-ECCInBlack, 0.0001);
	if (ECCGamma!=1.0) color=pow(color, ECCGamma);
	color=color*(ECCOutWhite-ECCOutBlack) + ECCOutBlack;

	//+++ brightness
	color=color*ECCBrightness;

	//+++ contrast
	color=(color-ECCContrastGrayLevel) * ECCContrast + ECCContrastGrayLevel;

	//+++ saturation
	tempgray=dot(color, 0.3333);
	color=lerp(tempgray, color, ECCSaturation);

	//+++ desaturate shadows
	tempgray=dot(color, 0.3333);
	tempvar.x=saturate(1.0-tempgray);
	tempvar.x*=tempvar.x;
	tempvar.x*=tempvar.x;
	color=lerp(color, tempgray, ECCDesaturateShadows*tempvar.x);

	//+++ color balance
	color=saturate(color);
	tempgray=dot(color, 0.3333);
	float2	shadow_highlight=float2(1.0-tempgray, tempgray);
	shadow_highlight*=shadow_highlight;
	color.rgb+=(ECCColorBalanceHighlights*2.0-1.0)*color * shadow_highlight.x;
	color.rgb+=(ECCColorBalanceShadows*2.0-1.0)*(1.0-color) * shadow_highlight.y;

	//+++ channel mixer
	tempcolor=color;
	color.r=dot(tempcolor, ECCChannelMixerR);
	color.g=dot(tempcolor, ECCChannelMixerG);
	color.b=dot(tempcolor, ECCChannelMixerB);
#endif //E_CC_PROCEDURAL








//========== LUT =================================

//if(enablelut)
{
    float2 CLut_pSize =  1 / float2(1024, 32);
    color.rgb  = saturate(color.rgb) * 31;
    float4 CLut_UV;
    CLut_UV.w  = floor(color.b);
    CLut_UV.xy = (color.rg + 0.5) * CLut_pSize;
    CLut_UV.x += CLut_UV.w * CLut_pSize.y;
    CLut_UV.z  = CLut_UV.x + CLut_pSize.y;
    color.rgb  = lerp(LUTtex.SampleLevel(Sampler1, CLut_UV.xy, 0).rgb, LUTtex.SampleLevel(Sampler1, CLut_UV.zy, 0).rgb, color.b - CLut_UV.w);
}

	res.xyz=saturate(color);
	res.w=1.0;
	return res;
}



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Vanilla post process. Do not modify
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
float4	PS_DrawOriginal(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
	float4	res;
	float4	color;

	float2	scaleduv=Params01[6].xy*IN.txcoord0.xy;
	scaleduv=max(scaleduv, 0.0);
	scaleduv=min(scaleduv, Params01[6].zy);

	color=TextureColor.Sample(Sampler0, IN.txcoord0.xy); //hdr scene color

	float4	r0, r1, r2, r3;
	r1.xy=scaleduv;
	r0.xyz = color.xyz;
	if (0.5<=Params01[0].x) r1.xy=IN.txcoord0.xy;
	r1.xyz = TextureBloom.Sample(Sampler1, r1.xy).xyz;
	r2.xy = TextureAdaptation.Sample(Sampler1, IN.txcoord0.xy).xy; //in skyrimse it two component

	r0.w=dot(float3(2.125000e-001, 7.154000e-001, 7.210000e-002), r0.xyz);
	r0.w=max(r0.w, 1.000000e-005);
	r1.w=r2.y/r2.x;
	r2.y=r0.w * r1.w;
	if (0.5<Params01[2].z) r2.z=0xffffffff; else r2.z=0;
	r3.xy=r1.w * r0.w + float2(-4.000000e-003, 1.000000e+000);
	r1.w=max(r3.x, 0.0);
	r3.xz=r1.w * 6.2 + float2(5.000000e-001, 1.700000e+000);
	r2.w=r1.w * r3.x;
	r1.w=r1.w * r3.z + 6.000000e-002;
	r1.w=r2.w / r1.w;
	r1.w=pow(r1.w, 2.2);
	r1.w=r1.w * Params01[2].y;
	r2.w=r2.y * Params01[2].y + 1.0;
	r2.y=r2.w * r2.y;
	r2.y=r2.y / r3.y;
	if (r2.z==0) r1.w=r2.y; else r1.w=r1.w;
	r0.w=r1.w / r0.w;
	r1.w=saturate(Params01[2].x - r1.w);
	r1.xyz=r1 * r1.w;
	r0.xyz=r0 * r0.w + r1;
	r1.x=dot(r0.xyz, float3(2.125000e-001, 7.154000e-001, 7.210000e-002));
	r0.w=1.0;
	r0=r0 - r1.x;
	r0=Params01[3].x * r0 + r1.x;
	r1=Params01[4] * r1.x - r0;
	r0=Params01[4].w * r1 + r0;
	r0=Params01[3].w * r0 - r2.x;
	r0=Params01[3].z * r0 + r2.x;
	r0.xyz=saturate(r0);
	r1.xyz=pow(r1.xyz, Params01[6].w);
	//active only in certain modes, like khajiit vision, otherwise Params01[5].w=0
	r1=Params01[5] - r0;
	res=Params01[5].w * r1 + r0;

//	res.xyz = color.xyz;
//	res.w=1.0;
	return res;
}



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//techniques
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Texture2D          LUT_DEFAULT < string UIName = "3DLut0";  string ResourceName = "LUT_DEFAULT.png"; >; // default Lut
technique11 Draw <string UIName="CW RUDY DEFAULT";>
{
   pass p0
   {
      SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
      SetPixelShader(CompileShader(ps_5_0, PS_Draw(LUT_DEFAULT, true)));
   }
   pass ADAPT_TOOL_PASS
}

Texture2D          LUT_Preset1 < string UIName = "3DLut1";  string ResourceName = "LUT_Preset1.png"; >; // Preset1 Lut
technique11 Preset1 <string UIName="CW VARIANT 1";>
{
   pass p0
   {
      SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
      SetPixelShader(CompileShader(ps_5_0, PS_Draw(LUT_Preset1, true)));
   }
}

Texture2D          LUT_Preset2 < string UIName = "3DLut1";  string ResourceName = "LUT_Preset2.png"; >; // Preset2 Lut
technique11 Preset2 <string UIName="CW VARIANT 2";>
{
   pass p0
   {
      SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
      SetPixelShader(CompileShader(ps_5_0, PS_Draw(LUT_Preset2, true)));
   }
}

Texture2D          LUT_Preset3 < string UIName = "3DLut1";  string ResourceName = "LUT_Preset3.png"; >; // Preset3 Lut
technique11 Preset3 <string UIName="CW VARIANT 3";>
{
   pass p0
   {
      SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
      SetPixelShader(CompileShader(ps_5_0, PS_Draw(LUT_Preset3, true)));
   }
}

Texture2D          LUT_BW < string UIName = "3DLut1";  string ResourceName = "LUT_BW.png"; >; // BW Lut
technique11 BW <string UIName="BW";>
{
   pass p0
   {
      SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
      SetPixelShader(CompileShader(ps_5_0, PS_Draw(LUT_BW, true)));
   }
}

Texture2D          LUT_NEUTRAL < string UIName = "3DLut1";  string ResourceName = "LUT_NEUTRAL.png"; >; // Neutral Lut
technique11 NEUTRAL <string UIName="NEUTRAL";>
{
   pass p0
   {
      SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
      SetPixelShader(CompileShader(ps_5_0, PS_Draw(LUT_NEUTRAL, true)));
   }
}




technique11 ORIGINALPOSTPROCESS <string UIName="Vanilla";> //do not modify this technique
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Draw()));
		SetPixelShader(CompileShader(ps_5_0, PS_DrawOriginal()));
	}
}


