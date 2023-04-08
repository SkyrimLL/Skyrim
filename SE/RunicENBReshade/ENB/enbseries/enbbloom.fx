//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ENBSeries Fallout 4 hlsl DX11 format, sample file of bloom
// visit http://enbdev.com for updates
// Author: Boris Vorontsov
// It's works with hdr input and output
// Bloom texture is always forced to 1024*1024 resolution
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

float Empty_Row1 <
  string UIName="-------------------DAY";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

float	fContrast_Day
<
	string UIName="Contrast_Day";
	string UIWidget="spinner";
	float UIMin=0.0;
	float UIMax=1000.0;
> = {1.0};

float	ECCInBlack_Day
<
	string UIName="CC: In black_Day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=5.0;
> = {0.0};

float	ECCInWhite_Day
<
	string UIName="CC: In white_Day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=5.0;
> = {1.0};

float	ECCOutBlack_Day
<
	string UIName="CC: Out black_Day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCOutWhite_Day
<
	string UIName="CC: Out white_Day";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float Empty_Row2 <
  string UIName="-------------------NIGHT";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

float	fContrast_Night
<
	string UIName="Contrast_Night";
	string UIWidget="spinner";
	float UIMin=0.0;
	float UIMax=1000.0;
> = {1.0};

float	ECCInBlack_Night
<
	string UIName="CC: In black_Night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=5.0;
> = {0.0};

float	ECCInWhite_Night
<
	string UIName="CC: In white_Night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=5.0;
> = {1.0};

float	ECCOutBlack_Night
<
	string UIName="CC: Out black_Night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCOutWhite_Night
<
	string UIName="CC: Out white_Night";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float Empty_Row3 <
  string UIName="-------------------INTERIORS";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

float	fContrast_Interior
<
	string UIName="Contrast_Interior";
	string UIWidget="spinner";
	float UIMin=0.0;
	float UIMax=1000.0;
> = {1.0};

float	ECCInBlack_Interior
<
	string UIName="CC: In black_Interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=5.0;
> = {0.0};

float	ECCInWhite_Interior
<
	string UIName="CC: In white_Interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=5.0;
> = {1.0};

float	ECCOutBlack_Interior
<
	string UIName="CC: Out black_Interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {0.0};

float	ECCOutWhite_Interior
<
	string UIName="CC: Out white_Interior";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=1.0;
> = {1.0};

float Empty_Row4 <
  string UIName="-------------------SATURATION";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};

float4	fSaturation
<
	string UIName="CC: Saturation";
	string UIWidget="Spinner";
	float UIMin=0.0;
	float UIMax=5.0;
> = {1.0, 1.0, 1.0, 1.0};

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
Texture2D			TextureDownsampled; //color R16B16G16A16 64 bit or R11G11B10 32 bit hdr format. 1024*1024 size
Texture2D			TextureColor; //color which is output of previous technique (except when drawed to temporary render target), R16B16G16A16 64 bit hdr format. 1024*1024 size

Texture2D			TextureOriginal; //color R16B16G16A16 64 bit or R11G11B10 32 bit hdr format, screen size. PLEASE AVOID USING IT BECAUSE OF ALIASING ARTIFACTS, UNLESS YOU FIX THEM
Texture2D			TextureDepth; //scene depth R32F 32 bit hdr format, screen size. PLEASE AVOID USING IT BECAUSE OF ALIASING ARTIFACTS, UNLESS YOU FIX THEM
Texture2D			TextureAperture; //this frame aperture 1*1 R32F hdr red channel only. computed in PS_Aperture of enbdepthoffield.fx

//temporary textures which can be set as render target for techniques via annotations like <string RenderTarget="RenderTargetRGBA32";>
Texture2D			RenderTarget1024; //R16B16G16A16F 64 bit hdr format, 1024*1024 size
Texture2D			RenderTarget512; //R16B16G16A16F 64 bit hdr format, 512*512 size
Texture2D			RenderTarget256; //R16B16G16A16F 64 bit hdr format, 256*256 size
Texture2D			RenderTarget128; //R16B16G16A16F 64 bit hdr format, 128*128 size
Texture2D			RenderTarget64; //R16B16G16A16F 64 bit hdr format, 64*64 size
Texture2D			RenderTarget32; //R16B16G16A16F 64 bit hdr format, 32*32 size
Texture2D			RenderTarget16; //R16B16G16A16F 64 bit hdr format, 16*16 size
Texture2D			RenderTargetRGBA32; //R8G8B8A8 32 bit ldr format, screen size
Texture2D			RenderTargetRGBA64F; //R16B16G16A16F 64 bit hdr format, screen size

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
VS_OUTPUT_POST	VS_Quad(VS_INPUT_POST IN)
{
	VS_OUTPUT_POST	OUT;
	float4	pos;
	pos.xyz=IN.pos.xyz;
	pos.w=1.0;
	OUT.pos=pos;
	OUT.txcoord0.xy=IN.txcoord.xy;
	return OUT;
}

	// Define AvgLuma
	float4 AvgLuma(float3 inColor)
{
	return float4(dot(inColor, float3(0.2125f, 0.7154f, 0.0721f)),                 /// Perform a weighted average
                max(inColor.r, max(inColor.g, inColor.b)),                       /// Take the maximum value of the incoming value
                max(max(inColor.x, inColor.y), inColor.z),                       /// Compute the luminance component as per the HSL colour space
                sqrt((inColor.x*inColor.x*0.2125f)+(inColor.y*inColor.y*0.7154f)+(inColor.z*inColor.z*0.0721f)));
}


float3	FuncBlur(Texture2D inputtex, float2 uvsrc, float srcsize, float destsize)
{
	const float	scale=4.0; //blurring range, samples count (performance) is factor of scale*scale
	//const float	srcsize=1024.0; //in current example just blur input texture of 1024*1024 size
	//const float	destsize=1024.0; //for last stage render target must be always 1024*1024

	float2	invtargetsize=scale/srcsize;
	invtargetsize.y*=ScreenSize.z; //correct by aspect ratio

	float2	fstepcount;
	fstepcount=srcsize;

	fstepcount*=invtargetsize;
	fstepcount=min(fstepcount, 16.0);
	fstepcount=max(fstepcount, 2.0);

	int	stepcountX=(int)(fstepcount.x+0.4999);
	int	stepcountY=(int)(fstepcount.y+0.4999);

	fstepcount=1.0/fstepcount;
	float4	curr=0.0;
	curr.w=0.000001;
	float2	pos;
	float2	halfstep=0.5*fstepcount.xy;
	pos.x=-0.5+halfstep.x;
	invtargetsize *= 2.0;
	for (int x=0; x<stepcountX; x++)
	{
		pos.y=-0.5+halfstep.y;
		for (int y=0; y<stepcountY; y++)
		{
			float2	coord=pos.xy * invtargetsize + uvsrc.xy;
			float3	tempcurr=inputtex.Sample(Sampler1, coord.xy).xyz;
			float	tempweight;			
			float2	dpos=pos.xy*2.0;
			float	rangefactor=dot(dpos.xy, dpos.xy);
			//loosing many pixels here, don't program such unefficient cycle yourself!
			tempweight=saturate(1001.0 - 1000.0*rangefactor);//arithmetic version to cut circle from square
			tempweight*=saturate(1.0 - rangefactor); //softness, without it bloom looks like bokeh dof
			curr.xyz+=tempcurr.xyz * tempweight;
			curr.w+=tempweight;

			pos.y+=fstepcount.y;
		}
		pos.x+=fstepcount.x;
	}
	curr.xyz/=curr.w;

	//curr.xyz=inputtex.Sample(Sampler1, uvsrc.xy);

	return curr.xyz;
}



//example 1. draw in single pass directly to bloom texture of 1024*1024 size
float4	PS_ExampleBloom1(VS_OUTPUT_POST IN, float4 v0 : SV_Position0,
	uniform Texture2D inputtex, uniform float srcsize, uniform float destsize) : SV_Target
{
float fContrast =lerp( lerp(fContrast_Night, fContrast_Day, ENightDayFactor), fContrast_Interior, EInteriorFactor );
float ECCInBlack =lerp( lerp(ECCInBlack_Night, ECCInBlack_Day, ENightDayFactor), ECCInBlack_Interior, EInteriorFactor );
float ECCOutBlack =lerp( lerp(ECCOutBlack_Night, ECCOutBlack_Day, ENightDayFactor), ECCOutBlack_Interior, EInteriorFactor );
float ECCInWhite =lerp( lerp(ECCInWhite_Night, ECCInWhite_Day, ENightDayFactor), ECCInWhite_Interior, EInteriorFactor );
float ECCOutWhite =lerp( lerp(ECCOutWhite_Night, ECCOutWhite_Day, ENightDayFactor), ECCOutWhite_Interior, EInteriorFactor );

	float4	res;

	res.xyz=FuncBlur(inputtex, IN.txcoord0.xy, srcsize, destsize);
	
	res.xyz=max(res.xyz-ECCInBlack, 0.0) / max(ECCInWhite-ECCInBlack, 0.0001);
	if (fContrast!=1.0) res.xyz=pow(res.xyz, fContrast);
	res.xyz=res.xyz*(ECCOutWhite-ECCOutBlack) + ECCOutBlack;
	
	res=max(res, 0.0);
	res=min(res, 16384.0);

	res.w=1.0;
	return res;
}



//example 2. draw in several passes to different render targets
float4	PS_Resize(VS_OUTPUT_POST IN, float4 v0 : SV_Position0,
	uniform Texture2D inputtex, uniform float srcsize, uniform float destsize) : SV_Target
{

	float4	res;

	res.xyz=FuncBlur(inputtex, IN.txcoord0.xy, srcsize, destsize);

	
	res=max(res, 0.0);
	res=min(res, 16384.0);
	
	res.w=1.0;
	return res;
}

float4	PS_ResizeFirst(VS_OUTPUT_POST IN, float4 v0 : SV_Position0,
	uniform Texture2D inputtex, uniform float srcsize, uniform float destsize) : SV_Target
{
float fContrast =lerp( lerp(fContrast_Night, fContrast_Day, ENightDayFactor), fContrast_Interior, EInteriorFactor );
float ECCInBlack =lerp( lerp(ECCInBlack_Night, ECCInBlack_Day, ENightDayFactor), ECCInBlack_Interior, EInteriorFactor );
float ECCOutBlack =lerp( lerp(ECCOutBlack_Night, ECCOutBlack_Day, ENightDayFactor), ECCOutBlack_Interior, EInteriorFactor );
float ECCInWhite =lerp( lerp(ECCInWhite_Night, ECCInWhite_Day, ENightDayFactor), ECCInWhite_Interior, EInteriorFactor );
float ECCOutWhite =lerp( lerp(ECCOutWhite_Night, ECCOutWhite_Day, ENightDayFactor), ECCOutWhite_Interior, EInteriorFactor );

	float4	res;
		
	res.xyz=FuncBlur(inputtex, IN.txcoord0.xy, srcsize, destsize);
	
	res.xyz=max(res.xyz-ECCInBlack, 0.0) / max(ECCInWhite-ECCInBlack, 0.0001);
	if (fContrast!=1.0) res.xyz=pow(res.xyz, fContrast);
	res.xyz=res.xyz*(ECCOutWhite-ECCOutBlack) + ECCOutBlack;
	
	res=max(res, 0.0);
	res=min(res, 16384.0);
	
	res.w=1.0;
	return res;
}

float4	PS_BloomMix(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
	float4	res;

	res.xyz=RenderTarget1024.Sample(Sampler1, IN.txcoord0.xy)*1.0;
	res.xyz+=(RenderTarget512.Sample(Sampler1, IN.txcoord0.xy)*1.0);
	res.xyz+=(RenderTarget256.Sample(Sampler1, IN.txcoord0.xy)*1.0);
	res.xyz+=(RenderTarget128.Sample(Sampler1, IN.txcoord0.xy)*1.0);
	res.xyz+=(RenderTarget64.Sample(Sampler1, IN.txcoord0.xy)*1.0);
	res.xyz+=(RenderTarget32.Sample(Sampler1, IN.txcoord0.xy)*0.5);
	//res.xyz*=0.2;	
	
	float3 Temp = AvgLuma(res.xyz).w;
	res.xyz = lerp(Temp.xyz, res.xyz, fSaturation);
	
	res=max(res, 0.0);
	res=min(res, 16384.0);

	res.w=1.0;
	return res;
}



//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Techniques are drawn one after another and they use the result of
// the previous technique as input color to the next one.  The number
// of techniques is limited to 255.  If UIName is specified, then it
// is a base technique which may have extra techniques with indexing
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//bloom example 1, draw in single pass, very performance heavy and low blurring range
technique11 SinglePassBloom <string UIName="Single pass bloom";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_ExampleBloom1(TextureDownsampled, 2048.0, 2048.0)));
	}
}



//bloom example 2, draw using several techniques and several render targets
technique11 MultiPassBloom <string UIName="Multipass bloom"; string RenderTarget="RenderTarget1024";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_ResizeFirst(TextureDownsampled, 2048.0, 2048.0)));
	}
}

technique11 MultiPassBloom1 <string RenderTarget="RenderTarget512";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_ResizeFirst(TextureDownsampled, 1024.0, 512.0)));
	}
}

technique11 MultiPassBloom2 <string RenderTarget="RenderTarget256";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Resize(RenderTarget512, 512.0, 256.0)));
	}
}

technique11 MultiPassBloom3 <string RenderTarget="RenderTarget128";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Resize(RenderTarget256, 256.0, 128.0)));
	}
}

technique11 MultiPassBloom4 <string RenderTarget="RenderTarget64";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Resize(RenderTarget128, 128.0, 64.0)));
	}
}

technique11 MultiPassBloom5 <string RenderTarget="RenderTarget32";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Resize(RenderTarget64, 32.0, 32.0)));
	}
}
//in last pass output to bloom texture
technique11 MultiPassBloom6
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_BloomMix()));
	}
}
