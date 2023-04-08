//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ENBSeries TES Skyrim SE hlsl DX11 format, sample file of sun sprites
// visit http://enbdev.com for updates
// Author: Boris Vorontsov
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++



//+++++++++++++++++++++++++++++
//internal parameters, modify or add new
//+++++++++++++++++++++++++++++
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

Texture2D	TextureSprite
<
	string UIName = "Sprite texture";
	string ResourceName = "enbsunsprite.bmp";
>;

float	ELenzIntensity
<
	string UIName="Lenz flare intensity";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=100.0;
> = {0.25};



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
//xy=sun position on screen, w=visibility
float4	LightParameters;


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
//mod parameters, do not modify
//+++++++++++++++++++++++++++++
Texture2D			TextureMask; //mask of sun as visibility factor

SamplerState		Sampler0
{
	Filter = MIN_MAG_MIP_POINT;
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



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
VS_OUTPUT_POST	VS_Draw(VS_INPUT_POST IN, uniform float offset, uniform float scale)
{
	VS_OUTPUT_POST	OUT;
	float4	pos;
	pos.xyz=IN.pos.xyz;
	pos.w=1.0;
	pos.y*=ScreenSize.z;

	//create own parameters instead of this, including uv offsets
	float2 shift=LightParameters.xy * offset;
	pos.xy=pos.xy * scale - shift;

	OUT.pos=pos;
	OUT.txcoord0.xy=IN.txcoord.xy;
	return OUT;
}



float4	PS_Draw(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
	float4 res;
	float2 coord=IN.txcoord0.xy;

	//read sun visibility as amount of effect
	float sunmask=TextureMask.Sample(Sampler0, float2(0.5, 0.5)).x;
	sunmask=sunmask*sunmask*sunmask;//more contrast to clouds
	sunmask*=ELenzIntensity;
	clip(sunmask-0.008);//early exit if too low

	float4 origcolor=TextureSprite.Sample(Sampler1, coord.xy);
	sunmask*=LightParameters.w;
	res.xyz=origcolor * sunmask;

	float clipper=dot(res.xyz, 0.333);
	clip(clipper-0.0003);//skip draw if black

	res.w=1.0;
	return res;
}



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// In this shader all techniques have additive blending mode
// (srcblend=one, destblend=one). No temporary render targets used.
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
technique11 Draw <string UIName="Draw";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Draw(-0.5, 0.07))); //offset, scale
		SetPixelShader(CompileShader(ps_5_0, PS_Draw()));
	}
	pass p1
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Draw(0.3, 0.15)));
		SetPixelShader(CompileShader(ps_5_0, PS_Draw()));
	}
	pass p2
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Draw(1.4, 0.1)));
		SetPixelShader(CompileShader(ps_5_0, PS_Draw()));
	}
	pass p3
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Draw(2.0, 0.3)));
		SetPixelShader(CompileShader(ps_5_0, PS_Draw()));
	}
}


