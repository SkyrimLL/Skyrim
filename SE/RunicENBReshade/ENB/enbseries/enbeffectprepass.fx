//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ENBSeries TES Skyrim SE hlsl DX11 format, sample file
// visit http://enbdev.com for updates
// Author: Boris Vorontsov
// It's similar to enbeffectpostpass.fx, but works with hdr input and output
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//basic example of using skinned objects mask to make edge detection


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

int	EOutlineType
<
	string UIName="OutlineType";
	string UIWidget="Spinner";
	int UIMin=0;
	int UIMax=2;
> = {0};

float	EOutlineThickness
<
	string UIName="OutlineThickness";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=2.0;
> = {1.0};

float	EOutlineFadeDistance
<
	string UIName="OutlineFadeDistance";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=3.0;
> = {1.0};

float	EOutlineTransparency
<
	string UIName="OutlineTransparency";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float3	EOutlineColor <
	string UIName="OutlineColor";
	string UIWidget="Color";
> = {0.0, 0.0, 0.0};

float	EOutlineModulateIntensity
<
	string UIName="OutlineModulateIntensity";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=10.0;
> = {1.0};

float3	EOutlineModulateColor <
	string UIName="OutlineModulateColor";
	string UIWidget="Color";
> = {0.0, 0.0, 0.0};


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
//mod parameters, do not modify
//+++++++++++++++++++++++++++++
Texture2D			TextureOriginal; //color R16B16G16A16 64 bit hdr format
Texture2D			TextureColor; //color which is output of previous technique (except when drawed to temporary render target), R16B16G16A16 64 bit hdr format
Texture2D			TextureDepth; //scene depth R32F 32 bit hdr format
Texture2D			TextureJitter; //blue noise
Texture2D			TextureMask; //alpha channel is mask for skinned objects (less than 1) and amount of sss

//temporary textures which can be set as render target for techniques via annotations like <string RenderTarget="RenderTargetRGBA32";>
Texture2D			RenderTargetRGBA32; //R8G8B8A8 32 bit ldr format
Texture2D			RenderTargetRGBA64; //R16B16G16A16 64 bit ldr format
Texture2D			RenderTargetRGBA64F; //R16B16G16A16F 64 bit hdr format
Texture2D			RenderTargetR16F; //R16F 16 bit hdr format with red channel only
Texture2D			RenderTargetR32F; //R32F 32 bit hdr format with red channel only
Texture2D			RenderTargetRGB32F; //32 bit hdr format without alpha

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



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
VS_OUTPUT_POST	VS_PostProcess(VS_INPUT_POST IN)
{
	VS_OUTPUT_POST	OUT;
	float4	pos;
	pos.xyz=IN.pos.xyz;
	pos.w=1.0;
	OUT.pos=pos;
	OUT.txcoord0.xy=IN.txcoord.xy;
	return OUT;
}


//generate edges
float4	PS_DrawEdge1(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
	float4	res;
	float4	coord;
	coord.zw=0.0;
	coord.xy=IN.txcoord0.xy;

	float2	invscreensize=ScreenSize.y;
	invscreensize.y*=ScreenSize.z;

	float4	mask=TextureMask.Sample(Sampler1, coord.xy);
	//if (mask.w==1.0) mask=0.0; else mask=1.0;
//	mask=(mask.w == 1.0) ? 0.0 : 1.0;
	//reduce bugs of alpha test objects
	mask.w=1.0-mask.w;
	mask.w*=mask.w;
	mask.w*=mask.w;

	//clip((254.0/255.0) - mask.w); //works properly only with one pass to increase speed, otherwise make one more pass

	float	depth=TextureDepth.Sample(Sampler1, coord.xy).x;
	float	origdepth=depth;

	depth=1.0/(1.0-depth);

	float	fadefact=saturate(1.0-depth*0.005*EOutlineFadeDistance);

	invscreensize*=fadefact;
	invscreensize*=EOutlineThickness;

	float2 offset[16]=
	{
	 float2(1.0, 1.0),
	 float2(-1.0, -1.0),
	 float2(-1.0, 1.0),
	 float2(1.0, -1.0),

	 float2(1.0, 0.0),
	 float2(-1.0, 0.0),
	 float2(0.0, 1.0),
	 float2(0.0, -1.0),

	 float2(1.41, 0.0),
	 float2(-1.41, 0.0),
	 float2(0.0, 1.41),
	 float2(0.0, -1.41),

	 float2(1.41, 1.41),
	 float2(-1.41, -1.41),
	 float2(-1.41, 1.41),
	 float2(1.41, -1.41)
	};

	float	weight=1.0;
	float	edges=0.0;
	float	averagedepth=depth;
	for (int i=0; i<16; i++)
	{
		float	tempdepth;
		coord.xy=IN.txcoord0.xy + offset[i].xy*invscreensize;
		tempdepth=TextureDepth.SampleLevel(Sampler1, coord, 0.0).x;

		tempdepth=1.0/(1.0-tempdepth);
		float	depthdiff=depth-tempdepth;

		float4	tempmask=TextureMask.SampleLevel(Sampler1, coord, 0.0);
//		tempmask=(tempmask.w == 1.0) ? 0.0 : 1.0;
		//reduce bugs of alpha test objects
		tempmask.w=1.0-tempmask.w;
		tempmask.w*=tempmask.w;
		tempmask.w*=tempmask.w;

		//if (depthdiff<0.0) tempmask.w=0.0; //remove from overlayed objects
		tempmask.w*=saturate(1.0+depthdiff*5.0); //remove from overlayed objects
		mask.w=max(tempmask.w, mask.w);
		//mask.x=min(tempmask.w, mask.x);

		//float	tempweight=1.0;
		//not works because of linear textures filtering for mask and depth
		//tempweight=((depthdiff>0.3) && (tempmask.x==0.0)) ? 0.0 : 1.0; //remove from overlayed objects

		//edges+=saturate( depthdiff*4.0 );
		edges+=saturate( abs(depthdiff*4.0) );
		averagedepth+=tempdepth;
	//	float	tempweight;
	//	tempweight=saturate( -(depthdiff) );
	//	averagedepth+=tempdepth * tempweight;
	//	weight+=tempweight;
	}
	edges=max(edges-2.0, 0.0); //skip 2 pixels to reduce bugs
	edges=saturate(edges);
	averagedepth*=1.0/17.0;
	//averagedepth/=weight;

	float	diff=(depth-averagedepth)*8.0;
	diff/=max(EOutlineThickness, 0.1); //correction for high scaling
	//edges*=saturate( diff ); //outer edges
	//edges*=saturate( -diff ); //inner edges
	//edges*=saturate( abs(diff) ); //both edges
	if (EOutlineType==1) diff=-diff;
	if (EOutlineType==2) diff=abs(diff);
	edges=saturate( diff );

	edges=lerp(0.0, edges, fadefact);
	res.w=saturate(edges);

	res.xyz=mask.w;
//	res.y=saturate(mask.w-mask.x);

	return res;
}


//blur previously generated edges and mix with colors
float4	PS_DrawEdge2(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
	float4	res;
	float4	coord;
	coord.zw=0.0;
	coord.xy=IN.txcoord0.xy;

	float2	invscreensize=ScreenSize.y;
	invscreensize.y*=ScreenSize.z;

	invscreensize*=0.5;

	float4	origcolor=TextureOriginal.Sample(Sampler0, coord.xy);
	float4	color=TextureColor.Sample(Sampler0, coord.xy);

	float2 offset[16]=
	{
	 float2(1.0, 1.0),
	 float2(-1.0, -1.0),
	 float2(-1.0, 1.0),
	 float2(1.0, -1.0),

	 float2(1.0, 0.0),
	 float2(-1.0, 0.0),
	 float2(0.0, 1.0),
	 float2(0.0, -1.0),

	 float2(1.41, 0.0),
	 float2(-1.41, 0.0),
	 float2(0.0, 1.41),
	 float2(0.0, -1.41),

	 float2(1.41, 1.41),
	 float2(-1.41, -1.41),
	 float2(-1.41, 1.41),
	 float2(1.41, -1.41)
	};

	for (int i=0; i<8; i++)
	{
		float4	tempcolor;
		coord.xy=IN.txcoord0.xy + offset[i].xy*invscreensize;
		tempcolor=TextureColor.SampleLevel(Sampler0, coord, 0.0);

		color+=tempcolor;
	}
	color*=1.0/9.0;

	color.w*=color.x;
	color.w=saturate(1.0-color.w);

	res.xyz=lerp(EOutlineColor.xyz, origcolor.xyz, saturate(color.w+EOutlineTransparency));
	color.xyz=lerp(EOutlineModulateColor, 0.0, color.w);
	res.xyz+=color * origcolor * EOutlineModulateIntensity;

	res.w=1.0;
	return res;
}



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Techniques are drawn one after another and they use the result of
// the previous technique as input color to the next one.  The number
// of techniques is limited to 255.  If UIName is specified, then it
// is a base technique which may have extra techniques with indexing
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
technique11 DrawEdge <string UIName="DrawEdge";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
		SetPixelShader(CompileShader(ps_5_0, PS_DrawEdge1()));
	}
}



technique11 DrawEdge1
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
		SetPixelShader(CompileShader(ps_5_0, PS_DrawEdge2()));
	}
}


