//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// ENBSeries Skyrim SE dx11 sm5 effect file
// visit facebook.com/MartyMcModding for news/updates
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Advanced Depth of Field 3.0.1
// Copyright (c) 2008-2019 Marty McFly / Pascal Gilcher
// CC BY-NC-ND 3.0 licensed.
// redistribute AS IS, no changes to the file without permission
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

/*******************************************************************
//Non-UI vars. Some could be made changeable in realtime, at the cost
//of performance.
//Use APPLY EFFECTS in enbseries.ini window if changes do not apply.
*******************************************************************/

//------------------------------------------------------------------
//Enables partial occlusion of bokeh disc at screen corners
#define ADOF_OPTICAL_VIGNETTE_ENABLE	           0	  //[0 or 1]
//------------------------------------------------------------------
//Enables chromatic aberration at bokeh shape borders.
#define ADOF_CHROMATIC_ABERRATION_ENABLE           1	  //[0 or 1]

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//UI vars, nothing to edit for standard users below this point
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

bool    bADOF_AutofocusEnable 		< string UIName="DOF: Enable Autofocus";																									> = {true};
float2	fADOF_AutofocusCenter 		< string UIName="DOF: Autofocus sample center"; 	string UIWidget="Spinner"; 	float UIStep=0.01; 	float UIMin=0.00; 	float UIMax=1.00;	> = {0.5,0.5};
float	fADOF_AutofocusRadius		< string UIName="DOF: Autofocus sample radius";		string UIWidget="Spinner";	float UIStep=0.01;	float UIMin=0.01;	float UIMax=1.00;	> = {0.05};
float	fADOF_ManualfocusDepth		< string UIName="DOF: Manual focus depth";			string UIWidget="Spinner";	float UIStep=0.0001;float UIMin=0.00;	float UIMax=1.0;	> = {0.05};
float	fADOF_NearBlurCurve			< string UIName="DOF: Near blur curve";				string UIWidget="Spinner";	float UIStep=0.01;	float UIMin=0.01;	float UIMax=20.0;	> = {1.0};
float	fADOF_FarBlurCurve			< string UIName="DOF: Far blur curve";				string UIWidget="Spinner";	float UIStep=0.01;	float UIMin=0.01;	float UIMax=20.0;	> = {1.4};
float	fADOF_HyperFocus			< string UIName="DOF: Hyperfocal depth distance";	string UIWidget="Spinner";	float UIStep=0.001;	float UIMin=0.00;	float UIMax=1.0;	> = {0.015};
float	fADOF_RenderResolutionMult	< string UIName="DOF: Blur render res mult";		string UIWidget="Spinner";	float UIStep=0.01;	float UIMin=0.50;	float UIMax=1.0;	> = {0.5};
float	fADOF_BokehIntensity		< string UIName="DOF: Bokeh Intensity";				string UIWidget="Spinner";	float UIStep=0.01;	float UIMin=0.0;	float UIMax=1.0;	> = {0.5};
float	fADOF_ShapeRadius			< string UIName="DOF: Bokeh shape max size";		string UIWidget="Spinner";	float UIStep=0.1;	float UIMin=0.0;	float UIMax=100.0;	> = {15.0};
int		iADOF_ShapeVertices			< string UIName="DOF: Bokeh shape vertices";		string UIWidget="spinner";						int UIMin=3;		int UIMax=9;		> = {6};
int		iADOF_ShapeQuality			< string UIName="DOF: Bokeh shape quality";			string UIWidget="spinner";						int UIMin=2;		int UIMax=25;		> = {5};
float	fADOF_ShapeCurvatureAmount	< string UIName="DOF: Bokeh shape roundness";		string UIWidget="Spinner";	float UIStep=0.01;	float UIMin=-1.0;	float UIMax=1.0;	> = {1.0};
float	fADOF_ShapeRotation			< string UIName="DOF: Bokeh shape rotation (\xB0)";	string UIWidget="Spinner";	float UIStep=1;		float UIMin=0;		float UIMax=360;	> = {15};
float	fADOF_ShapeAnamorphRatio	< string UIName="DOF: Bokeh shape aspect ratio";	string UIWidget="Spinner";	float UIStep=0.01;	float UIMin=0.0;	float UIMax=1.0;	> = {1.0};
float	fADOF_SmootheningAmount		< string UIName="DOF: Gaussian postblur width";		string UIWidget="Spinner";	float UIStep=1.0;	float UIMin=0.0;	float UIMax=20.0;	> = {4.0};
#if (ADOF_OPTICAL_VIGNETTE_ENABLE != 0)
 float	fADOF_ShapeVignetteCurve	< string UIName="DOF: Bokeh shape vignette curve";	string UIWidget="Spinner";	float UIStep=0.01;	float UIMin=0.5;	float UIMax=2.5;	> = {0.75};
 float	fADOF_ShapeVignetteAmount	< string UIName="DOF: Bokeh shape vignette amount";	string UIWidget="Spinner";	float UIStep=0.01;	float UIMin=0.0;	float UIMax=2.0;	> = {1.0};
#endif
#if (ADOF_CHROMATIC_ABERRATION_ENABLE != 0)
 float	fADOF_ShapeChromaAmount		< string UIName="DOF: Shape chromatic aberration amount";string UIWidget="Spinner";float UIStep=0.01;float UIMin=-1.00;	float UIMax=1.00;	> = {-1.0};
 int	iADOF_ShapeChromaMode		< string UIName="DOF: Shape chromatic aberration type";	string UIWidget="spinner";					int UIMin=0;		int UIMax=2;		> = {2};
#endif

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//external enb parameters, do not modify
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4	Timer; 			//x = generic timer in range 0..1, period of 16777216 ms (4.6 hours), y = average fps, w = frame time elapsed (in seconds)
float4	ScreenSize; 		//x = Width, y = 1/Width, z = aspect, w = 1/aspect, aspect is Width/Height
float	AdaptiveQuality;	//changes in range 0..1, 0 means full quality, 1 lowest dynamic quality (0.33, 0.66 are limits for quality levels)
float4	Weather;		//x = current weather index, y = outgoing weather index, z = weather transition, w = time of the day in 24 standart hours. Weather index is value from weather ini file, for example WEATHER002 means index==2, but index==0 means that weather not captured.
float4	TimeOfDay1;		//x = dawn, y = sunrise, z = day, w = sunset. Interpolators range from 0..1
float4	TimeOfDay2;		//x = dusk, y = night. Interpolators range from 0..1
float	ENightDayFactor;	//changes in range 0..1, 0 means that night time, 1 - day time
float	EInteriorFactor;	//changes 0 or 1. 0 means that exterior, 1 - interior

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//Semi-hardcoded parameters, DO NOT MODIFY unless you know what you do.
//But what am I saying, you're gonna do it anyways.
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#define DISCRADIUS_RESOLUTION_BOUNDARY_LOWER 	0.25//1.0		//used for blending blurred scene.
#define DISCRADIUS_RESOLUTION_BOUNDARY_UPPER 	1.0//6.0		//used for blending blurred scene.
#define DISCRADIUS_RESOLUTION_BOUNDARY_CURVE    0.5		//used for blending blurred scene.
#define FPS_HAND_BLUR_CUTOFF_DIST		0.3353		//fps hand depth (x10.000), change if you perceive blurred fps weapons.
#define FPS_HAND_BLUR_CUTOFF_CHECK		0		//blur = max if depth > hand depth, else 0, useful for tweaking above param
#define GAUSSIAN_BUILDUP_MULT			4.0		//value of x -> gaussian reaches max radius at |CoC| == 1/x

static const float2 PixelSize 			= float2(ScreenSize.y,ScreenSize.y*ScreenSize.z);

#define linearstep(a,b,x) saturate((x-a)/(b-a))
#define LinearizeDepth(x) x *= rcp(mad(x,-2999.0,3000.0))

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//external enb debugging parameters for shader programmers, do not modify
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4	tempF1; 		//0,1,2,3
float4  tempF2;                 //5,6,7,8
float4	tempF3; 		//9,0
float4	tempInfo1; 		//float4(cursorpos.xy 0~1,isshaderwindowopen, mouse buttons)
float4	tempInfo2;		//float4(cursorpos.xy prev left mouse button click, cursorpos.xy prev right mouse button click)

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//mod parameters, do not modify
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4			DofParameters;		//z = ApertureTime multiplied by time elapsed, w = FocusingTime multiplied by time elapsed
Texture2D		TextureCurrent; 	//current frame focus depth or aperture. unused in dof computation
Texture2D		TexturePrevious; 	//previous frame focus depth or aperture. unused in dof computation
Texture2D		TextureOriginal; 	//color R16B16G16A16 64 bit hdr format
Texture2D		TextureColor; 		//color which is output of previous technique (except when drawed to temporary render target), R16B16G16A16 64 bit hdr format
Texture2D		TextureDepth; 		//scene depth R32F 32 bit hdr format
Texture2D		TextureFocus; 		//this frame focus 1*1 R32F hdr red channel only. computed in PS_Focus
Texture2D		TextureAperture; 	//this frame aperture 1*1 R32F hdr red channel only. computed in PS_Aperture
Texture2D		TextureAdaptation;	//previous frame vanilla or enb adaptation 1*1 R32F hdr red channel only. adaptation computed after depth of field and it's kinda "average" brightness of screen!!!
//temporary textures which can be set as render target for techniques via annotations like <string RenderTarget="RenderTargetRGBA32";>
Texture2D		RenderTargetRGBA32; 	//R8G8B8A8 32 bit ldr format
Texture2D		RenderTargetRGBA64; 	//R16B16G16A16 64 bit ldr format
Texture2D		RenderTargetRGBA64F; 	//R16B16G16A16F 64 bit hdr format
Texture2D		RenderTargetR16F; 	//R16F 16 bit hdr format with red channel only
Texture2D		RenderTargetR32F; 	//R32F 32 bit hdr format with red channel only
Texture2D		RenderTargetRGB32F; 	//32 bit hdr format without alpha

SamplerState		SamplerPoint
{
	Filter = MIN_MAG_MIP_POINT;
	AddressU = Clamp;
	AddressV = Clamp;
};

SamplerState		SamplerLinear
{
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Clamp;
	AddressV = Clamp;
};

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Vertex Shader
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

struct VS_INPUT_POST
{
	float3 pos		: POSITION;
	float2 txcoord		: TEXCOORD0;
};
struct VS_OUTPUT_DOF
{
	float4 pos		: SV_POSITION;
	float2 txcoord		: TEXCOORD0;
	float2 vertices[10] 	: TEXCOORD1;
};

struct VS_OUTPUT_POST
{
	float4 pos		: SV_POSITION;
	float2 txcoord		: TEXCOORD0;
};

VS_OUTPUT_DOF	VS_DoF(VS_INPUT_POST IN, uniform float scale)
{
	VS_OUTPUT_DOF	OUT;
	OUT.pos 	= float4(IN.pos.xyz, 1.0);
	OUT.txcoord.xy 	= IN.txcoord.xy / scale;

	[unroll]
	for(int i=0; i<10; i++)
		sincos(i * 6.2831853 / iADOF_ShapeVertices + radians(fADOF_ShapeRotation),OUT.vertices[i].y,OUT.vertices[i].x);

	return OUT;
}

VS_OUTPUT_POST	VS_Quad(VS_INPUT_POST IN)
{
	VS_OUTPUT_POST	OUT;
	OUT.pos 	= float4(IN.pos.xyz, 1.0);
	OUT.txcoord.xy 	= IN.txcoord.xy;
	return OUT;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Functions
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float GetLinearDepth(float2 texcoord)
{
	float depth = TextureDepth.SampleLevel(SamplerLinear, texcoord.xy,0).x;
	LinearizeDepth(depth);
	return depth;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float CircleOfConfusion(float2 texcoord, bool aggressiveLeakReduction)
{
	float2 depthdata; //x - linear scene depth, y - linear scene focus
	float scenecoc;   //blur value, signed by position relative to focus plane

	[branch]
	if(aggressiveLeakReduction)
	{
		float4 depthsGather[2] = {TextureDepth.Gather(SamplerPoint, texcoord.xy - PixelSize.xy * 0.5  ),
					  TextureDepth.Gather(SamplerPoint, texcoord.xy - PixelSize.xy * 0.5, 1)};

		LinearizeDepth(depthsGather[0]);
		LinearizeDepth(depthsGather[1]);

		depthdata.x = min(min(min(depthsGather[0].x,depthsGather[0].z),min(depthsGather[1].x,depthsGather[1].z)),depthsGather[0].y);
		depthdata.x = lerp(depthdata.x, depthsGather[0].y, 0.001);
	}
	else
	{
		depthdata.x = TextureDepth.Sample(SamplerPoint,texcoord.xy).x;
		LinearizeDepth(depthdata.x);
	}

	depthdata.y = TextureFocus.Sample(SamplerPoint, texcoord.xy).x;
	float handdepth = depthdata.x;

	depthdata.xy = saturate(depthdata.xy / fADOF_HyperFocus); //hyperfocal distance

	[branch]
	if(depthdata.x < depthdata.y)
	{
		scenecoc = depthdata.x / depthdata.y - 1.0;
		scenecoc = ldexp(scenecoc, -0.5*fADOF_NearBlurCurve*fADOF_NearBlurCurve);
	}
	else
	{
		scenecoc = (depthdata.x - depthdata.y)/(ldexp(depthdata.y, fADOF_FarBlurCurve*fADOF_FarBlurCurve) - depthdata.y);
	        scenecoc = saturate(scenecoc);
	}

#if(FPS_HAND_BLUR_CUTOFF_CHECK != 0)
	scenecoc = (handdepth < FPS_HAND_BLUR_CUTOFF_DIST * 1e-4) ? 0.0 : 1.0;
#else //FPS_HAND_BLUR_CUTOFF_CHECK
	scenecoc = (handdepth < FPS_HAND_BLUR_CUTOFF_DIST * 1e-4) ? 0.0 : scenecoc;
#endif //FPS_HAND_BLUR_CUTOFF_CHECK

	return scenecoc;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Pixel Shaders
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//fullres -> 16x16 R32F
float4	PS_ReadFocus(VS_OUTPUT_POST IN) : SV_Target
{
	float scenefocus = 0.0;

        [branch]
	if(bADOF_AutofocusEnable == true)
	{
		float samples = 10.0;
		float weightsum = 1e-6;

		for(float xcoord = 0.0; xcoord < samples; xcoord++)
		for(float ycoord = 0.0; ycoord < samples; ycoord++)
		{
			float2 sampleOffset = (float2(xcoord,ycoord) + 0.5) / samples;
			sampleOffset = sampleOffset * 2.0 - 1.0;
			sampleOffset *= fADOF_AutofocusRadius;
			sampleOffset += (fADOF_AutofocusCenter - 0.5);

			float sampleWeight = saturate(1.2 * exp2(-dot(sampleOffset,sampleOffset)*4.0));

			float tempfocus = GetLinearDepth(sampleOffset * 0.5 + 0.5);
			sampleWeight *= rcp(tempfocus + 0.001);

			sampleWeight *= saturate(tempfocus > FPS_HAND_BLUR_CUTOFF_DIST * 1e-4); //remove fps hands from focus calculations

			scenefocus += tempfocus * sampleWeight;
			weightsum += sampleWeight;
		}
		scenefocus /= weightsum;
	}
	else
	{
		scenefocus = fADOF_ManualfocusDepth;
	}

	return scenefocus;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//16x16 -> 1x1 R32F
float4	PS_Focus(VS_OUTPUT_POST IN) : SV_Target
{
        float prevFocus = 0.0;
	float currFocus = 0.0;

	for(float x=0.0; x<16.0; x++)
	for(float y=0.0; y<16.0; y++)
	{
		prevFocus += TexturePrevious.SampleLevel(SamplerPoint, float2(x,y) / 16.0, 0).x;
		currFocus +=  TextureCurrent.SampleLevel(SamplerPoint, float2(x,y) / 16.0, 0).x;
	}

	return (bADOF_AutofocusEnable) ? 0.00390625 * lerp(prevFocus,currFocus,DofParameters.w) : currFocus * 0.00390625;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4	PS_CoC(VS_OUTPUT_POST IN) : SV_Target
{
	float4 color = TextureColor.Sample(SamplerLinear, IN.txcoord.xy);

	static const float2 sampleOffsets[4] = {float2( 1.5, 0.5) * PixelSize.xy,
		                                float2( 0.5,-1.5) * PixelSize.xy,
				                float2(-1.5,-0.5) * PixelSize.xy,
				                float2(-0.5, 1.5) * PixelSize.xy};

	float4 compColor = 0.0;
	float centerDepth = TextureDepth.Sample(SamplerLinear, IN.txcoord.xy).x;
	LinearizeDepth(centerDepth);

	[loop]
	for(int i=0; i<4; i++)
	{
		float2 sampleCoord = IN.txcoord.xy + sampleOffsets[i];

		float3 sampleColor = TextureColor.Sample(SamplerLinear, sampleCoord).rgb;
		float4 sampleDepths = TextureDepth.Gather(SamplerLinear, sampleCoord);

		sampleColor /= 1.0 + max(max(sampleColor.r, sampleColor.g), sampleColor.b);

		float sampleDepthMin = min(min(sampleDepths.x,sampleDepths.y),min(sampleDepths.z,sampleDepths.w));
		LinearizeDepth(sampleDepthMin);

		float sampleWeight = saturate(sampleDepthMin * rcp(centerDepth) + 1e-3);
		compColor += float4(sampleColor.rgb * sampleWeight, sampleWeight);
	}

	compColor.rgb /= compColor.a;
	compColor.rgb /= 1.0 - max(compColor.r, max(compColor.g, compColor.b));

	color.rgb = lerp(color.rgb, compColor.rgb, saturate(compColor.w * 8.0));
	color.w = CircleOfConfusion(IN.txcoord.xy, 1);

	return color;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

void ShapeRoundness(inout float2 sampleOffset, in float roundness)
{
	sampleOffset *= (1.0-roundness) + rsqrt(dot(sampleOffset,sampleOffset))*roundness;
}

void OpticalVignette(in float2 sampleOffset, in float2 centerVec, inout float sampleWeight)
{
	sampleOffset -= centerVec; //scaled by vignette intensity
	sampleWeight *= saturate(3.33 - dot(sampleOffset,sampleOffset) * 1.666); //notsosmoothstep to avoid aliasing
}

float2 CoC2BlurRadius(float CoC)
{
	return float2(fADOF_ShapeAnamorphRatio,ScreenSize.z) * CoC * fADOF_ShapeRadius * 6e-4;
}

float4	PS_DoF_Main(VS_OUTPUT_DOF IN, float4 vPos : SV_POSITION) : SV_Target
{
	clip(1.01-max(IN.txcoord.x,IN.txcoord.y));

	float4 BokehSum, BokehMax;
	BokehMax = BokehSum	= TextureColor.Sample(SamplerLinear, IN.txcoord.xy);
	float weightSum = 1.0;
	float CoC = abs(BokehSum.w);
	float2 bokehRadiusScaled = CoC2BlurRadius(CoC);
	float nRings = lerp(1.0,iADOF_ShapeQuality,saturate(CoC)) + fmod(dot(vPos.xy,1),2)*0.5;

	if(bokehRadiusScaled.x < DISCRADIUS_RESOLUTION_BOUNDARY_LOWER * ScreenSize.y) return BokehSum;

	bokehRadiusScaled /= nRings;
	CoC /= nRings;

#if (ADOF_OPTICAL_VIGNETTE_ENABLE != 0)
	float2 centerVec = IN.txcoord.xy - 0.5;
	float centerDist = sqrt(dot(centerVec,centerVec));
	float vignette = pow(centerDist, fADOF_ShapeVignetteCurve) * fADOF_ShapeVignetteAmount;
	centerVec = centerVec / centerDist * vignette;
	weightSum *= saturate(3.33 - vignette * 2.0);
	BokehSum *= weightSum;
	BokehMax *= weightSum;
#endif

	[loop]for (int iVertices = 0; iVertices < iADOF_ShapeVertices; iVertices++)
	[loop]for(float iRings = 1; iRings <= nRings; iRings++)
	[loop]for(float iSamplesPerRing = 0; iSamplesPerRing < iRings; iSamplesPerRing++)
	{
		float2 sampleOffset = lerp(IN.vertices[iVertices],IN.vertices[iVertices+1],iSamplesPerRing/iRings);
		ShapeRoundness(sampleOffset,fADOF_ShapeCurvatureAmount);

		float4 sampleBokeh 	= TextureColor.SampleLevel(SamplerLinear, IN.txcoord.xy + sampleOffset.xy * (bokehRadiusScaled * iRings),0);
		float sampleWeight	= saturate(1e6 * (abs(sampleBokeh.a) - CoC * (float)iRings) + 1.0);
		//float sampleWeight = saturate((abs(sampleBokeh.a) + CoC * (2.0 - iRings + abs(sampleBokeh.a)))/(4.0*CoC)); //mcfly '17 v2, smooth transition between quality steps

#if (ADOF_OPTICAL_VIGNETTE_ENABLE != 0)
		OpticalVignette(sampleOffset.xy * iRings/nRings, centerVec, sampleWeight);
#endif
		sampleBokeh.rgb 	*= sampleWeight;
		weightSum 		+= sampleWeight;
		BokehSum 		+= sampleBokeh;
		BokehMax 		= max(BokehMax,sampleBokeh);
	}

	return lerp(BokehSum / weightSum, BokehMax, fADOF_BokehIntensity * saturate(CoC * nRings * 4.0));
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4	PS_DoF_Combine(VS_OUTPUT_POST IN) : SV_Target
{
	float4 blurredColor   = TextureColor.Sample(SamplerLinear,  IN.txcoord.xy * fADOF_RenderResolutionMult); //Median3x3Upscale(TextureColor, IN.txcoord.xy, fADOF_RenderResolutionMult);
	float4 originalColor  = TextureOriginal.Sample(SamplerPoint,  IN.txcoord.xy);

	float CoC 			= CircleOfConfusion(IN.txcoord.xy, 0);
	float CoCblurred	= blurredColor.a;

	float bokehRadiusPixels = abs(CoC2BlurRadius(CoC).x * ScreenSize.x);

	float blendWeight = linearstep(DISCRADIUS_RESOLUTION_BOUNDARY_LOWER, DISCRADIUS_RESOLUTION_BOUNDARY_UPPER, bokehRadiusPixels);
	      blendWeight = pow(blendWeight,DISCRADIUS_RESOLUTION_BOUNDARY_CURVE);

	float4 BokehSum;
	BokehSum.rgb 	= lerp(originalColor.rgb, blurredColor.rgb, blendWeight);
	BokehSum.a      = saturate(abs(lerp(CoC,CoCblurred,blendWeight*0)) * GAUSSIAN_BUILDUP_MULT);

	return BokehSum;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4	PS_DoF_Gauss(uniform float2 axis, uniform bool overrideAlpha, VS_OUTPUT_POST IN) : SV_Target
{
	float4 centerTap = TextureColor.Sample(SamplerLinear, IN.txcoord.xy);

	float nSteps 		= centerTap.a * (fADOF_SmootheningAmount + 1.0);
	float expCoeff 		= -2.0 * rcp(nSteps * nSteps + 1e-3); //sigma adjusted for blur width
	float2 blurAxisScaled 	= axis * PixelSize.xy;

	float4 gaussianSum = 0.0;
	float  gaussianSumWeight = 1e-3;

	nSteps = floor(nSteps); //doing this after computing the sigma makes the additional steps fade in smoothly

	for(float iStep = -nSteps; iStep <= nSteps; iStep++)
	{
		float currentWeight = exp(iStep * iStep * expCoeff);
		float currentOffset = 2.0 * iStep - 0.5; //Sample between texels to double blur width at no cost

		float4 currentTap = TextureColor.SampleLevel(SamplerLinear, IN.txcoord.xy + blurAxisScaled.xy * currentOffset, 0);

		currentWeight *= saturate(currentTap.a - centerTap.a * 0.25);

		gaussianSum += currentTap * currentWeight;
		gaussianSumWeight += currentWeight;
	}

	gaussianSum /= gaussianSumWeight;

	float4 BokehSum = lerp(centerTap, gaussianSum, saturate(gaussianSumWeight));
#if (ADOF_CHROMATIC_ABERRATION_ENABLE != 0)
	if(overrideAlpha) BokehSum.a = CircleOfConfusion(IN.txcoord.xy, 0);
#else
	//fix potential bugs in enbeffect if that code erroneously takes alpha into account
	//old ENB vanilla procedural CC did this, dot(color.rgba, 0.3333) != dot(color.rgb, 0.333)
    if(overrideAlpha) BokehSum.a = 1;    
#endif
	return BokehSum;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#if (ADOF_CHROMATIC_ABERRATION_ENABLE != 0)
float4	PS_DoF_ChromaticAberration(VS_OUTPUT_POST IN, float4 vPos : SV_POSITION) : SV_Target
{
	float4 colorVals[5];

	colorVals[0] = TextureColor.Load(int3(vPos.x, vPos.y, 0));
	colorVals[1] = TextureColor.Load(int3(vPos.x - 1, vPos.y, 0)); //L
	colorVals[2] = TextureColor.Load(int3(vPos.x, vPos.y - 1, 0)); //T
	colorVals[3] = TextureColor.Load(int3(vPos.x + 1, vPos.y, 0)); //R
	colorVals[4] = TextureColor.Load(int3(vPos.x, vPos.y + 1, 0)); //B

	float CoC 			= abs(colorVals[0].a);
	float2 bokehRadiusScaled	= CoC2BlurRadius(CoC);

	float4 vGradTwosided = float4(dot(colorVals[0].rgb - colorVals[1].rgb, 1),	 //C - L
	                              dot(colorVals[0].rgb - colorVals[2].rgb, 1),	 //C - T
				      			  dot(colorVals[3].rgb - colorVals[0].rgb, 1),	 //R - C
				      			  dot(colorVals[4].rgb - colorVals[0].rgb, 1)); 	 //B - C

	float2 vGrad = min(vGradTwosided.xy, vGradTwosided.zw);

	float vGradLen = sqrt(dot(vGrad,vGrad)) + 1e-6;
	vGrad = vGrad / vGradLen * saturate(vGradLen * 32.0) * bokehRadiusScaled * 0.125 * fADOF_ShapeChromaAmount;

	float4 chromaVals[3];

	chromaVals[0] = colorVals[0];
	chromaVals[1] = TextureColor.Sample(SamplerLinear, IN.txcoord.xy + vGrad);
	chromaVals[2] = TextureColor.Sample(SamplerLinear, IN.txcoord.xy - vGrad);

	chromaVals[1].rgb = lerp(chromaVals[0].rgb, chromaVals[1].rgb, saturate(4.0 * abs(chromaVals[1].w)));
	chromaVals[2].rgb = lerp(chromaVals[0].rgb, chromaVals[2].rgb, saturate(4.0 * abs(chromaVals[2].w)));

	uint3 chromaMode = (uint3(0,1,2) + iADOF_ShapeChromaMode.xxx) % 3;

	float4 BokehSum;
	BokehSum.rgb = float3(	chromaVals[chromaMode.x].r,
		              		chromaVals[chromaMode.y].g,
			      			chromaVals[chromaMode.z].b);
	BokehSum.a = 1.0;

	return BokehSum;
}
#endif
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Techniques
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

//I just HATE messy technique sections..

#define TECH11(NAME, VERTEXSHADER, PIXELSHADER)\
technique11 NAME { pass p0 { SetVertexShader(CompileShader(vs_5_0, VERTEXSHADER)); SetPixelShader(CompileShader(ps_5_0, PIXELSHADER)); }}

TECH11(ReadFocus, 					VS_Quad(), 				PS_ReadFocus())
TECH11(Focus, 						VS_Quad(), 				PS_Focus())
TECH11(DOF <string UIName="Marty McFly's ADOF";>, 	VS_Quad(), 				PS_CoC())
TECH11(DOF1, 						VS_DoF(fADOF_RenderResolutionMult), 	PS_DoF_Main())
TECH11(DOF2, 						VS_Quad(), 				PS_DoF_Combine())
TECH11(DOF3, 						VS_Quad(), 				PS_DoF_Gauss(float2(0,1),0))
TECH11(DOF4, 						VS_Quad(), 				PS_DoF_Gauss(float2(1,0),1))
#if (ADOF_CHROMATIC_ABERRATION_ENABLE != 0)
TECH11(DOF5, 						VS_Quad(), 				PS_DoF_ChromaticAberration())
#endif
