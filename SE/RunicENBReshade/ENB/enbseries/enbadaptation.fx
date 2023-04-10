//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
// ENBSeries Fallout 4 adaptation file, hlsl DX11                   //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//  Histogram based adaptation by kingeric1992                      //
//      based on the description here:                              //
//  https://docs.unrealengine.com/latest/INT/Engine/Rendering/PostProcessEffects/AutomaticExposure/
//                                                                  //
//  For more info, visit                                            //
//     http://enbseries.enbdev.com/forum/viewtopic.php?f=7&t=5321   //
//                                                                  //
//  update: Nov.23.2016                                             //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//


int   Title0        < string UIName="\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4\xA4"; float UIMin=0.0; float UIMax=0.0; > = { 0 };
int   Title1        < string UIName=" "; float UIMin=0.0; float UIMax=0.0; > = { 0 };
float Empty_Row1 <
  string UIName="-------------------DAY";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};
float Bias_Day      < string UIName="Auto Exposure Bias Day (log2 scale)"; > = {0.0};
float MaxBrightness_Day < string UIName="Adapt Max Brightness Day (log2 scale)"; float UIMin= -9.0; float UIMax=3.0; > = { 0.80 };
float MinBrightness_Day < string UIName="Adapt Min Brightness Day (log2 scale)"; float UIMin= -9.0; float UIMax=3.0; > = { 0.80 };
float Empty_Row2 <
  string UIName="-------------------NIGHT";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};
float Bias_Night    < string UIName="Auto Exposure Bias Night (log2 scale)"; > = {0.0};
float MaxBrightness_Night < string UIName="Adapt Max Brightness Night (log2 scale)"; float UIMin= -9.0; float UIMax=3.0; > = { 0.80 };
float MinBrightness_Night < string UIName="Adapt Min Brightness Night (log2 scale)"; float UIMin= -9.0; float UIMax=3.0; > = { 0.80 };
float Empty_Row3 <
  string UIName="-------------------INTERIORS";   string UIWidget="spinner";  float UIMin=0.0;  float UIMax=0.0;
> = {0.0};
float Bias_Interior  < string UIName="Auto Exposure Bias Interior (log2 scale)"; > = {0.0};
float MaxBrightness_Interior < string UIName="Adapt Max Brightness Interior (log2 scale)"; float UIMin= -9.0; float UIMax=3.0; > = { 0.80 };
float MinBrightness_Interior < string UIName="Adapt Min Brightness Interior (log2 scale)"; float UIMin= -9.0; float UIMax=3.0; > = { 0.80 };
float LowPercent    < string UIName="Adapt Low  Percent";                float UIMin=  0.5; float UIMax=1.0; > = { 0.80 };
float HighPercent   < string UIName="Adapt High Percent";                float UIMin=  0.5; float UIMax=1.0; > = { 0.95 };

//+++++++++++++++++++++++++++++
//external enb parameters, do not modify (shared)
//+++++++++++++++++++++++++++++
float4	Timer;           //x = generic timer in range 0..1, period of 16777216 ms (4.6 hours), y = average fps, w = frame time elapsed (in seconds)
float4	ScreenSize;      //x = Width, y = 1/Width, z = Width/Height, w = Height/Width
float	AdaptiveQuality; //changes in range 0..1, 0 means full quality, 1 lowest dynamic quality (0.33, 0.66 are limits for quality levels)
float4	Weather;         //x = current weather index, y = outgoing weather index, z = weather transition, w = time of the day in 24 standart hours.
float4	TimeOfDay1;      //x = dawn, y = sunrise, z = day, w = sunset. Interpolators range from 0..1
float4	TimeOfDay2;      //x = dusk, y = night. Interpolators range from 0..1
float	ENightDayFactor; //changes in range 0..1, 0 means that night time, 1 - day time
float	EInteriorFactor; //changes 0 or 1. 0 means that exterior, 1 - interior
//keyboard controlled temporary variables. Press and hold key 1,2,3...8 together with PageUp or PageDown to modify. By default all set to 1.0
float4	tempF1, tempF2, tempF3; //0,1,2,3,4,5,6,7,8,9
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
float4	tempInfo2; // xy = cursor position of previous left click, zw = cursor position of previous right click



//+++++++++++++++++++++++++++++
//game and mod parameters, do not modify
//+++++++++++++++++++++++++++++
float4				AdaptationParameters; //x = AdaptationMin, y = AdaptationMax, z = AdaptationSensitivity, w = AdaptationTime multiplied by time elapsed
Texture2D			TextureCurrent;
Texture2D			TexturePrevious;


SamplerState		Sampler0 {
	Filter = MIN_MAG_MIP_POINT;//MIN_MAG_MIP_LINEAR;
	AddressU = Clamp;	AddressV = Clamp;
};

SamplerState		Sampler1 {
	Filter = MIN_MAG_MIP_LINEAR;
	AddressU = Clamp;	AddressV = Clamp;
};

void VS_Quad( inout float4 pos : SV_POSITION, inout float2 txcoord0 : TEXCOORD0)
{
    pos.w     = 1.0;
    txcoord0 -= 7.0 / 256.0;
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//output size is 16*16
//TextureCurrent size is 256*256, it's internally downscaled from full screen
//input texture is R16G16B16A16 or R11G11B10 float format (alpha ignored)
//output texture is R32 float format (red channel only)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

float4	PS_Downsample( float4 pos : SV_POSITION, float2 txcoord0 : TEXCOORD0) : SV_Target
{
	float  res = 0.0;
    float4 coord = { txcoord0.xyy, 1.0 / 128.0 };

	for (int x=0; x<8; x++)
	{
		coord.y = coord.z;
		for (int y=0; y<8; y++)
		{
			float4 color = TextureCurrent.Sample(Sampler1, coord.xy);
			res     += max( color.r, max(color.g, color.b));
			coord.y += coord.w;
		}
		coord.x += coord.w;
	}

	return log2(res) - 6.0; //log2( res / 64.0)
}

//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//output size is 1*1
//TexturePrevious size is 1*1
//TextureCurrent size is 16*16
//output and input textures are R32 float format (red channel only)
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++


float4	PS_Histogram() : SV_Target
{
    float4 coord = { 1.0 / 32.0, 1.0 / 32.0, 1.0 / 32.0, 1.0 / 16.0};
    float4 bin[16];

    for(int k=0; k<16; k++)
    {
        bin[k]=float4(0.0, 0.0, 0.0, 0.0);
    }

    [loop]
    for(int i=0; i < 16.0; i++)
    {
        coord.y  = coord.z;
        [loop]
        for(int j=0; j<16.0; j++)
        {
            float  color   = TextureCurrent.SampleLevel(Sampler0, coord.xy, 0.0).r;
            float  level   = saturate(( color + 9.0 ) / 12) * 63; // [-9, 3]
            bin[ level * 0.25 ] += float4(0.0, 1.0, 2.0, 3.0) == float4(trunc(level % 4).xxxx); //bitwise ?
            coord.y  += coord.w;
        }
        coord.x += coord.w;
    }

    float2 adaptAnchor = 0.5; //.x = high, .y = low
    float2 accumulate  = float2( HighPercent - 1.0, LowPercent - 1.0) * 256.0;

    [loop]
    for(int l=15; l>0; l--)
    {
        accumulate += bin[l].w;
        adaptAnchor = (accumulate.xy < bin[l].ww)? l * 4.0 + accumulate.xy / bin[l].ww + 3.0: adaptAnchor;

        accumulate += bin[l].z;
        adaptAnchor = (accumulate.xy < bin[l].zz)? l * 4.0 + accumulate.xy / bin[l].zz + 2.0: adaptAnchor;

        accumulate += bin[l].y;
        adaptAnchor = (accumulate.xy < bin[l].yy)? l * 4.0 + accumulate.xy / bin[l].yy + 1.0: adaptAnchor;

        accumulate += bin[l].x;
        adaptAnchor = (accumulate.xy < bin[l].xx)? l * 4.0 + accumulate.xy / bin[l].xx + 0.0: adaptAnchor;
    }


float Bias =lerp( lerp(Bias_Night, Bias_Day, ENightDayFactor), Bias_Interior, EInteriorFactor );
float MaxBrightness =lerp( lerp(MaxBrightness_Night, MaxBrightness_Day, ENightDayFactor), MaxBrightness_Interior, EInteriorFactor );
float MinBrightness =lerp( lerp(MinBrightness_Night, MinBrightness_Day, ENightDayFactor), MinBrightness_Interior, EInteriorFactor );

    float adapt = (adaptAnchor.x + adaptAnchor.y) * 0.5 / 63.0  * 12.0 - 9.0;
          adapt =  pow(2.0, clamp( adapt, MinBrightness, MaxBrightness) + Bias);  // min max on log2 scale

   	return lerp(TexturePrevious.Sample(Sampler0, 0.5).x, adapt, AdaptationParameters.w);
}


//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//techniques
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

technique11 Downsample
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Downsample()));
	}
}

technique11 Draw  <string UIName=" _(:3 \xB8/)_";>
{
	pass p0
	{
		SetVertexShader(CompileShader(vs_5_0, VS_Quad()));
		SetPixelShader(CompileShader(ps_5_0, PS_Histogram()));
	}
}
