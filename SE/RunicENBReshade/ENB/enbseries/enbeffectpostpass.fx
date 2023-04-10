//+++++++++++++++++++++++++++++++++++++++++++++++++++++//
//                ENBSeries effect file                //
//         visit http://enbdev.com for updates         //
//       Copyright (c) 2007-2016 Boris Vorontsov       //
//-----------------------CREDITS-----------------------//
// Boris: For ENBSeries and his knowledge and codes    //
// JawZ: Author and developer of this file             //
// Kingeric1992: SMAA implementation                   //
// Adyss: Additional SMAA HDR VIBRANCE implementation               //
// Effect file for Rudy ENB SE edited by Rudy102        //
//+++++++++++++++++++++++++++++++++++++++++++++++++++++//

// Weather Index for "/Modular Shaders/Vibrance.fxh"
// Weather ID's from "/enbseries/_weatherlist.ini" file [WEATHER###]

#define START_RAIN_WEATHER_ID    6
#define END_RAIN_WEATHER_ID     12

#define START_FOG_WEATHER_ID    13
#define END_FOG_WEATHER_ID     17

int INFO0 <string UIName="Activate effects with TECHNQIUE tab above";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
int INFO5 <string UIName=" "; string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};


//++++++++++++++++++++++++++++++++++++++++++++++++++++
// INTERNAL PARAMETERS BEGINS HERE, CAN BE MODIFIED
//++++++++++++++++++++++++++++++++++++++++++++++++++++

bool USE_Vibrance < string UIName = "----------------------------VIBRANCE"; > = {false};


float Vibrance_Day <
   string UIName="Vibrance_Day";
   string UIWidget="Spinner";
   float UIMin=-1.0;
   float UIMax=1.0;
> = {0.0};

float Vibrance_Night <
   string UIName="Vibrance_Night";
   string UIWidget="Spinner";
   float UIMin=-1.0;
   float UIMax=1.0;
> = {0.0};

float Vibrance_Interior <
   string UIName="Vibrance_Interior";
   string UIWidget="Spinner";
   float UIMin=-1.0;
   float UIMax=1.0;
> = {0.0};

float3 VibranceRGBBalance_Day <
   string UIName="Vibrance_RGBBalance_Day";
   string UIWidget="Color";
> = {1.0, 1.0, 1.0};

float3 VibranceRGBBalance_Night <
   string UIName="Vibrance_RGBBalance_Night";
   string UIWidget="Color";
> = {1.0, 1.0, 1.0};;

float3 VibranceRGBBalance_Interior <
   string UIName="Vibrance_RGBBalance_Interior";
   string UIWidget="Color";
> = {1.0, 1.0, 1.0};


//  RAIN DESATURATION  //

float	DesaturationFade <
	string UIName="Rain_Fog_Desaturation - Fade";
	string UIWidget="Spinner";
	float UIMin=1.0;
	float UIMax=10.0;
> = {5.0};	

float	Desaturation <
	string UIName="Rain_Fog_Desaturation";
	string UIWidget="Spinner";
	float UIMin=-1.0;
	float UIMax=0.0;
> = {-0.1};


bool USE_HDR < string UIName = "----------------------------FAKE HDR"; > = {false};


float HDRPower_Day <
   string UIName="HDR Power Day";
   string UIWidget="Spinner";
   float UIMin=0.0;
   float UIMax=8.0;
> = {1.3};

float radius1_Day <
   string UIName="Radius 1 Day";
   string UIWidget="Spinner";
   float UIMin=0.0;
   float UIMax=8.0;
> = {0.79};

float radius2_Day <
   string UIName="Radius 2 Day";
   string UIWidget="Spinner";
   float UIMin=0.0;
   float UIMax=8.0;
> = {0.87};

float HDRPower_Night <
   string UIName="HDR Power Night";
   string UIWidget="Spinner";
   float UIMin=0.0;
   float UIMax=8.0;
> = {1.3};

float radius1_Night <
   string UIName="Radius 1 Night";
   string UIWidget="Spinner";
   float UIMin=0.0;
   float UIMax=8.0;
> = {0.79};

float radius2_Night <
   string UIName="Radius 2 Night";
   string UIWidget="Spinner";
   float UIMin=0.0;
   float UIMax=8.0;
> = {0.87};

float HDRPower_Interior <
   string UIName="HDR Power Interior";
   string UIWidget="Spinner";
   float UIMin=0.0;
   float UIMax=8.0;
> = {1.3};

float radius1_Interior <
   string UIName="Radius 1 Interior";
   string UIWidget="Spinner";
   float UIMin=0.0;
   float UIMax=8.0;
> = {0.79};

float radius2_Interior <
   string UIName="Radius 2 Interior";
   string UIWidget="Spinner";
   float UIMin=0.0;
   float UIMax=8.0;
> = {0.87};

int SharpBlur <string UIName="-----------------------SHARP & BLUR";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
  bool ENABLE_BLURRING <
    string UIName = "Enable Blurring";
  > = {false};
  bool ENABLE_SHARPENING <
    string UIName = "Enable Sharpening";
  > = {false};
  bool ENABLE_DEPTHSHARP <
    string UIName = "Enable Depth Sharpening";
  > = {false};
  bool ENABLE_LUMA <
    string UIName = "Enable Luma Sharpening";
  > = {false};
  bool VISUALIZE_SHARP <
    string UIName = "Visualize Sharpening";
  > = {false};

  float EBlurAmount <
    string UIName="Blur: amount";         string UIWidget="spinner";  float UIMin=0.0;  float UIMax=1.0;
  > = {1.0};
  float EBlurRange <
    string UIName="Blur: range";          string UIWidget="spinner";  float UIMin=0.0;  float UIMax=2.0;
  > = {1.0};
  float ESharpAmount <
    string UIName="Sharp: amount";        string UIWidget="spinner";  float UIMin=0.0;  float UIMax=4.0;
  > = {1.0};
  float ESharpRange <
    string UIName="Sharp: range";         string UIWidget="spinner";  float UIMin=0.0;  float UIMax=2.0;
  > = {1.0};
  int fSharpFDepth <
    string UIName="Sharp: From Depth";    string UIWidget="Spinner";  int UIMin=0.0;  int UIMax=100000.0;
  > = {300.0};

int Vignette <string UIName="--------------------------VIGNETTE";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
    bool ENABLE_VIGNETTE <
        string UIName = "Enable Vignette";
    > = {false};

    float EVignetteAmount <
        string UIName="Vignette: Amount";       string UIWidget="Spinner";    float UIMin=0.0;
    > = {1.0};
    float EVignetteCurve <
        string UIName="Vignette: Curve";        string UIWidget="Spinner";    float UIMin=0.0;
    > = {4.0};
    float EVignetteRadius <
        string UIName="Vignette: Radius";       string UIWidget="Spinner";    float UIMin=0.0;
    > = {1.4};
    float3 EVignetteColor <
        string UIName="Vignette: RGB Color";    string UIWidget="Color";
    > = {0.0, 0.0, 0.0};

int Grain <string UIName="----------------------------GRAIN";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
    bool ENABLE_GRAIN <
        string UIName = "Enable Grain";
    > = {false};
    bool VISUALIZE_GRAIN <
        string UIName = "Visualize Grain";
    > = {false};

    float fGrainIntensity <
        string UIName="Grain: Intensity";   string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=0.5;  float UIStep=0.001;
    > = {0.035};
    float fGrainSaturation <
        string UIName="Grain: Saturation";  string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=0.5;  float UIStep=0.001;
    > = {0.0};
    float fGrainMotion <
        string UIName="Grain: Motion";      string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=0.2;  float UIStep=0.001;
    > = {0.2};

int Letterbox <string UIName="------------------------LETTERBOX";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};
    bool ENABLE_LETTERBOX <
        string UIName = "Enable Letterbox Bars";
    > = {false};
    float fLetterboxBarHeight <
        string UIName="Letterbox: Height in %";   string UIWidget="Spinner";  float UIMin=0.0;  float UIMax=0.5;  float UIStep=0.001;
    > = {0.12};
	
int empty_SMAA <string UIName="----------------------------SMAA";  string UIWidget="spinner";  int UIMin=0;  int UIMax=0;> = {0};


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// EXTERNAL PARAMETERS BEGINS HERE, SHOULD NOT BE MODIFIED UNLESS YOU KNOW WHAT YOU ARE DOING
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4 Timer;            /// x = generic timer in range 0..1, period of 16777216 ms (4.6 hours), y = average fps, w = frame time elapsed (in seconds)
float4 ScreenSize;       /// x = Width, y = 1/Width, z = aspect, w = 1/aspect, aspect is Width/Height
float4 Weather;          /// x = current weather index, y = outgoing weather index, z = weather transition, w = time of the day in 24 standart hours. Weather index is value from weather ini file, for example WEATHER002 means index==2, but index==0 means that weather not captured.
float4 TimeOfDay1;       /// x = dawn, y = sunrise, z = day, w = sunset. Interpolators range from 0..1
float4 TimeOfDay2;       /// x = dusk, y = night. Interpolators range from 0..1
float  ENightDayFactor;  /// Changes in range 0..1, 0 means that night time, 1 - day time
float  EInteriorFactor;  /// Changes 0 or 1. 0 means that exterior, 1 - interior

// External ENB debugging paramaters
float4 tempF1;     /// 0,1,2,3  // Keyboard controlled temporary variables.
float4 tempF2;     /// 5,6,7,8  // Press and hold key 1,2,3...8 together with PageUp or PageDown to modify.
float4 tempF3;     /// 9,0
float4 tempInfo1;  /// xy = cursor position in range 0..1 of screen, z = is shader editor window active, w = mouse buttons with values 0..7
/// tempInfo1 assigned mouse button values
///    0 = none
///    1 = left
///    2 = right
///    3 = left+right
///    4 = middle
///    5 = left+middle
///    6 = right+middle
///    7 = left+right+middle (or rather cat is sitting on your mouse)
float4 tempInfo2;
/// xy = cursor position of previous left mouse button click
/// zw = cursor position of previous right mouse button click


// TEXTURES
Texture2D TextureOriginal;  /// LDR color
Texture2D TextureColor;     /// LDR color which is output of previous technique
Texture2D TextureDepth;     /// scene depth

/// Temporary textures which can be set as render target for techniques via annotations like <string RenderTarget="RenderTargetRGBA32";>
Texture2D RenderTargetRGBA32;   /// R8G8B8A8 32 bit ldr format
Texture2D RenderTargetRGBA64;   /// R16B16G16A16 64 bit ldr format
Texture2D RenderTargetRGBA64F;  /// R16B16G16A16F 64 bit hdr format
Texture2D RenderTargetR16F;     /// R16F 16 bit hdr format with red channel only
Texture2D RenderTargetR32F;     /// R32F 32 bit hdr format with red channel only
Texture2D RenderTargetRGB32F;   /// 32 bit hdr format without alpha


// SAMPLERS
SamplerState Sampler0
{
  Filter=MIN_MAG_MIP_POINT;  AddressU=Clamp;  AddressV=Clamp;  /// MIN_MAG_MIP_LINEAR;
};
SamplerState Sampler1
{
  Filter=MIN_MAG_MIP_LINEAR;  AddressU=Clamp;  AddressV=Clamp;
};


// DATA STRUCTURE
struct VS_INPUT_POST
{
  float3 pos     : POSITION;
  float2 txcoord : TEXCOORD0;
};
struct VS_OUTPUT_POST
{
  float4 pos      : SV_POSITION;
  float2 txcoord0 : TEXCOORD0;
};


// HELPER FUNCTIONS
/// Include the additional shader files containing all helper functions and constants
   #include "/Modular Shaders/msHelpers.fxh"
   #include "/Modular Shaders/fakeHDR.fxh"
   #include "/Modular Shaders/Vibrance.fxh"
   #include "enbsmaa.fx" 
   
float4 enbBlur(float4 inColor, float2 inCoord)
{
if (ENABLE_BLURRING==false) return float4(TextureColor.Sample(Sampler0, inCoord.xy));

  float4 color;
  float4 centercolor;
  float2 pixeloffset = ScreenSize.y;
  pixeloffset.y     *= ScreenSize.z;

    centercolor = TextureColor.Sample(Sampler0, inCoord.xy);
    color       = 0.0;
    float2 offsets[4]=
    {
      float2(-1.0,-1.0),
      float2(-1.0, 1.0),
      float2( 1.0,-1.0),
      float2( 1.0, 1.0),
    };
    for (int i=0; i<4; i++)
    {
      float2 coord = offsets[i].xy * pixeloffset.xy * EBlurRange + inCoord.xy;
      color.xyz += TextureColor.Sample(Sampler1, coord.xy);
    }
    color.xyz += centercolor.xyz;
    color.xyz *= 0.2;

    inColor.xyz = lerp(centercolor.xyz, color.xyz, EBlurAmount);

  return inColor;
}

float4 enbSharpen(float4 inColor, float2 inCoord)
{
if (ENABLE_SHARPENING==false) return float4(TextureColor.Sample(Sampler0, inCoord.xy));

  float4 color;
  float4 centercolor;
  float2 pixeloffset = ScreenSize.y;
  pixeloffset.y     *= ScreenSize.z;

/// Simple depth implementation
  float Depth = TextureDepth.Sample(Sampler0, inCoord.xy ).x;
  float linDepthFromS = linearDepth(Depth, 0.5f, fSharpFDepth);

    centercolor = TextureColor.Sample(Sampler0, inCoord.xy);
    color       = 0.0;
    float2 offsets[4]=
    {
      float2(-1.0,-1.0),
      float2(-1.0, 1.0),
      float2( 1.0,-1.0),
      float2( 1.0, 1.0),
    };
    for (int i=0; i<4; i++)
    {
      float2 coord = offsets[i].xy * pixeloffset.xy * ESharpRange + inCoord.xy;
      color.xyz   += TextureColor.Sample(Sampler1, coord.xy);
    }
    color.xyz *= 0.25;

    float diffgray = dot((centercolor.xyz - color.xyz), 0.3333);

/// Apply depth based sharpening
    if (ENABLE_DEPTHSHARP==true)  diffgray = diffgray * (1.0f - linDepthFromS);

/// Simply does not blend the pre-sharpening scene with the post-sharpening scene together,
/// not true conversion to and from and Luma sharpening.
	if (ENABLE_LUMA==false) {
		inColor.xyz = ESharpAmount * centercolor.xyz * diffgray + centercolor.xyz;
	} else {
        inColor.xyz = ESharpAmount * diffgray + centercolor.xyz;
    }

	if (VISUALIZE_SHARP==true && ENABLE_LUMA==false) {
		inColor.rgb = ESharpAmount * centercolor.xyz * diffgray;
	} else if (VISUALIZE_SHARP==true && ENABLE_LUMA==true) {
        inColor.rgb = ESharpAmount * diffgray;
    }

  return inColor;
}

float4 msVignette(float4 inColor, float2 inTexCoords)
{
  if (ENABLE_VIGNETTE==true)
  {
    float3 origcolor = inColor;

      float2 uv      = (inTexCoords.xy - 0.5f) * EVignetteRadius;
      float vignette = saturate(dot(uv.xy, uv.xy));
      vignette       = pow(vignette, EVignetteCurve);
      inColor.xyz    = lerp(origcolor.xyz, EVignetteColor, vignette * EVignetteAmount);
  }

  return inColor;
}

float3 msGrain(float3 inColor, float2 inTexCoords)
{
  if (ENABLE_GRAIN==true)
  {
    float  GrainTimerSeed    = Timer.x * fGrainMotion;
    float2 GrainTexCoordSeed = inTexCoords.xy * 1.0f;

    float2 GrainSeed1  = GrainTexCoordSeed + float2( 0.0f, GrainTimerSeed );
    float2 GrainSeed2  = GrainTexCoordSeed + float2( GrainTimerSeed, 0.0f );
    float2 GrainSeed3  = GrainTexCoordSeed + float2( GrainTimerSeed, GrainTimerSeed );
    float  GrainNoise1 = random( GrainSeed1 );
    float  GrainNoise2 = random( GrainSeed2 );
    float  GrainNoise3 = random( GrainSeed3 );
    float  GrainNoise4 = ( GrainNoise1 + GrainNoise2 + GrainNoise3 ) * 0.333333333f;
    float3 GrainNoise  = float3( GrainNoise4, GrainNoise4, GrainNoise4 );
    float3 GrainColor  = float3( GrainNoise1, GrainNoise2, GrainNoise3 );

    inColor += ( lerp( GrainNoise, GrainColor, fGrainSaturation ) * fGrainIntensity ) - ( fGrainIntensity * 0.5f);

	if (VISUALIZE_GRAIN==true) inColor.rgb = (lerp(GrainNoise, GrainColor, fGrainSaturation) * fGrainIntensity) - (fGrainIntensity * 0.5f);
  }

  return inColor;
}

float4 msLetterbox(float4 inColor, float2 inTexCoords)
{
  if (ENABLE_LETTERBOX==true)
  {
    if (inTexCoords.y > 1.0f - fLetterboxBarHeight || inTexCoords.y  < fLetterboxBarHeight) inColor = float4(0.0f, 0.0f, 0.0f, 0.0f);
  }

  return inColor;
}

/***List of available fetches**********************************************
 * - PI // value of PI                                                    *
 * - TODE1(TODfactors(), Var_ESr, Var_ED, Var_ESs, Var_EN)                *
 * - TODE3(TODfactors(), Var_ESr, Var_ED, Var_ESs, Var_EN)                *
 * - AvgLuma(color.rgb).x  // or .y or .z or .w, never ever .xyzw!        *
 * - RGBtoXYZ(color.rgb)                                                  *
 * - XYZtoYxy(XYZ.xyz)                                                    *
 * - YxytoXYZ(XYZ.xyz, Yxy.rgb)                                           *
 * - XYZtoRGB(XYZ.xyz)                                                    *
 * - RGBtoYxy(color.rgb)                                                  *
 * - YxytoRGB(Yxy.rgb)                                                    *
 * - RGBToHSL(color.rgb)                                                  *
 * - HSLToRGB(hsl.rgb)                                                    *
 * - RGBtoHSV(color.rgb)                                                  *
 * - HSVtoRGB(hsv.rgb)                                                    *
 * - BlendLuma(hslbase.rgb, hslblend.rgb)                                 *
 * - random(uv.xy)                                                        *
 * - InterleavedGradientNoise(uv.xy)                                      *
 * - linearDepth(Depth, fFromFarDepth, fFromNearDepth)                    *
 * - FuncBlur(inputtex, IN.txcoord0.xy, srcsize, destsize)                *
 * - SplitScreen(_s0, color, IN.txcoord0.xy, fSplitscreenPos)             *
 * - ClipMode(color.rgb)                                                  *
 * - ShowDepth(color.rgb, IN.txcoord0.xy, fFromFarDepth, fFromNearDepth   *
 **************************************************************************/


// VERTEX SHADER
VS_OUTPUT_POST VS_PostProcess(VS_INPUT_POST IN)
{
  VS_OUTPUT_POST OUT;

    float4 pos;
    pos.xyz = IN.pos.xyz;
    pos.w = 1.0;
    OUT.pos = pos;
    OUT.txcoord0.xy = IN.txcoord.xy;

  return OUT;
}


// PIXEL SHADERS
float4 PS_Blur(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
  float4 res;

    res = enbBlur(res, IN.txcoord0.xy);

  res.w = 1.0;
  return res;
}

float4 PS_Sharp(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
  float4 res;

    res = enbSharpen(res, IN.txcoord0.xy);

  res.w = 1.0;
  return res;
}

float4	PS_ColorFX(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
	float2 coord = IN.txcoord0;
	float4 color = TextureColor.Sample(Sampler0, coord.xy);
	
	color.rgb = Vibrance(color.rgb);         // Vibrance

	color.rgb = HDR(color, coord.xy);        // Fake HDR

    return color;
}


/// Post Effects
float4 PS_PostFX(VS_OUTPUT_POST IN, float4 v0 : SV_Position0) : SV_Target
{
  float4 res;

    res     = TextureColor.Sample(Sampler0, IN.txcoord0.xy);
    res     = msVignette(res, IN.txcoord0.xy);
    res.rgb = msGrain(res.rgb, IN.txcoord0.xy);
    res     = msLetterbox(res, IN.txcoord0.xy);

  res.w = 1.0;
  return res;
}


// TECHNIQUES
///+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///
/// Techniques are drawn one after another and they use the result of   ///
/// the previous technique as input color to the next one.  The number  ///
/// of techniques is limited to 255.  If UIName is specified, then it   ///
/// is a base technique which may have extra techniques with indexing   ///
///+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++///

technique11 BlurSharp <string UIName="Rudy_PP+SMAA";>  /// First  Blur Pass
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_Blur()));
  }
}

technique11 BlurSharp1  /// Second Blur Pass
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_Blur()));
  }
}

technique11 BlurSharp2  /// First Sharpening Pass
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_Sharp()));
  }
}

technique11 BlurSharp3 <string RenderTarget= SMAA_STRING(SMAA_EDGE_TEX);>
{
    pass Clear
    {
        SetVertexShader(CompileShader(vs_5_0, VS_SMAAClear()));
        SetPixelShader(CompileShader(ps_5_0, PS_SMAAClear()));
    }

    pass EdgeDetection
    {
        SetVertexShader(CompileShader(vs_5_0, VS_SMAAEdgeDetection()));
        SetPixelShader(CompileShader(ps_5_0, PS_SMAAEdgeDetection()));
    }
}

technique11 BlurSharp4 <string RenderTarget=SMAA_STRING(SMAA_BLEND_TEX);>
{
    pass Clear
    {
        SetVertexShader(CompileShader(vs_5_0, VS_SMAAClear()));
        SetPixelShader(CompileShader(ps_5_0, PS_SMAAClear()));
    }
    
    pass BlendingWeightCalculation
    {
        SetVertexShader(CompileShader(vs_5_0, VS_SMAABlendingWeightCalculation()));
        SetPixelShader(CompileShader(ps_5_0, PS_SMAABlendingWeightCalculation()));
    }
}

technique11 BlurSharp5
{
    pass NeighborhoodBlending
    {
        SetVertexShader(CompileShader(vs_5_0, VS_SMAANeighborhoodBlending()));
        SetPixelShader(CompileShader(ps_5_0, PS_SMAANeighborhoodBlending()));
    }
}

technique11 BlurSharp6  /// Color FX
{
  pass p0
    {
       SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
       SetPixelShader (CompileShader(ps_5_0, PS_ColorFX()));
    }
}

technique11 BlurSharp7  /// Post effects
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_PostFX()));
  }
}


technique11 rudy <string UIName="Rudy_PP-No SMAA";>  /// First  Blur Pass
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_Blur()));
  }
}

technique11 rudy1  /// Second Blur Pass
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_Blur()));
  }
}

technique11 rudy2  /// First Sharpening Pass
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_Sharp()));
  }
}

technique11 rudy3  /// Color FX
{
  pass p0
    {
       SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
       SetPixelShader (CompileShader(ps_5_0, PS_ColorFX()));
    }
}

technique11 rudy4  /// Post effects
{
  pass p0
  {
    SetVertexShader(CompileShader(vs_5_0, VS_PostProcess()));
    SetPixelShader(CompileShader(ps_5_0, PS_PostFX()));
  }
}