#ifndef _ENBSMAA_FX_
#define _ENBSMAA_FX_
/*===========================================================================================
 *                                 file descriptions
=============================================================================================
 * implemented to enbeffectpostpass.fx by kingeric1992 for Fallout 4 ENB mod 0.288+
 *                                                                      update.  Sep/29/2016
 *      for more detail, visit http://enbseries.enbdev.com/forum/viewtopic.php?f=7&t=4721
 *
 ** Only SMAA 1x is avaliable
 *
 * SMAA T2x requires moving camera in sub pixel jitters.
 * SMAA S2x requires MSAA 2x buffer
 * SMAA 4x  requires both of the above
 *
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * Usage:
 * add
 *              #define  SMAA_UINAME 0  // 1 == use smaa method independently
 *              #define  PASSNAME0   targetname
 *              #define  PASSNAME1   targetname1
 *              #define  PASSNAME2   targetname2
 *              #include "enbsmaa.fx"
 *                                          at the end of enbeffectpostpass.fx.
 * where the targetname(N) is follow up the technique chain and increment to one before, if
 * the last technique is called THISPASS4, then set targetname to THISPASS5 and the rest with
 * increasing index.  ( targetname index "0" is empty )
 *
 * If you wish to have SMAA as standalone effect that doesn't chain after other technique, set
 * SMAA_UINAME to 1 and have the pass index start from empty (which means "0").
 *
 * in addition, you can change internal rendertarget with :
 * (they will be cleard, so change to other texture if any of the default tex is in used to pass 
 * along data, otherwise, ignore this.)
 *
 *              #define  SMAA_EDGE_TEX      texture0name   // default is RenderTargetRGB32F (only require 2bit-RG channel)
 *              #define  SMAA_BLEND_TEX     texture1name   // default is RenderTargetRGBA64 (RGBA requred [0,1] )
 *
 *                                          prior to inclueing "enbsmaa.fx" 
 *
 * Loading multiple times with different PASSNAME is possible (under same name is not recommended).
 *
==============================================================================================
 *                              Settings
============================================================================================*/

#define SMAA_PRESET      5  // 0 == low, 1 == medium, 2 == high, 3 == ultra, 4 == custom preset, 5 == runtime UI tweak
#define SMAA_PREDICATION 1  // 0 == off, see descriptions below
#define SMAA_EDGE_MODE   0  // 0 == color(quality), 1 == luma, 2 == depth(performance)
#define SMAA_DEBUG       1  // 0 == off, enable additional options to display texture in each stage

/*============================================================================================
 *              SMAA_PRESET_4 : static custom preset
============================================================================================*/
// Under same settings, static custom preset will have better performance then SMAA_PRESET_5 UI tweak. 
// detail descriptions below.

#define SMAA_THRESHOLD              0.1
#define SMAA_MAX_SEARCH_STEPS       16
#define SMAA_MAX_SEARCH_STEPS_DIAG  0
#define SMAA_CORNER_ROUNDING        25

// Predicated thresholding \\
#define SMAA_PREDICATION_THRESHOLD  0.01
#define SMAA_PREDICATION_SCALE      2.0
#define SMAA_PREDICATION_STRENGTH   0.4

/*============================================================================================
 *                            setting descriptions
==============================================================================================
 * the following descriptions is provided in SMAA.h.
 *                                  for more detial on SMAA, visit http://www.iryoku.com/smaa/
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * SMAA_THRESHOLD specifies the threshold or sensitivity to edges.
 * Lowering this value you will be able to detect more edges at the expense of performance.
 *
 *      Range: [0, 0.5]
 *        0.1 is a reasonable value, and allows to catch most visible edges.
 *        0.05 is a rather overkill value, that allows to catch 'em all.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 *
 * SMAA_MAX_SEARCH_STEPS specifies the maximum steps performed in the horizontal/vertical
 * pattern searches, at each side of the pixel.
 *
 *      Range: [0, 98]
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 *
 * SMAA_MAX_SEARCH_STEPS_DIAG specifies the maximum steps performed in the diagonal pattern
 * searches, at each side of the pixel. In this case we jump one pixel at time, instead of two.
 *
 *      Range: [0, 20]; set it to 0 to disable diagonal processing.
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 *
 * SMAA_CORNER_ROUNDING specifies how much sharp corners will be rounded.
 *
 *      Range: [0, 100]; set it to 100 to disable corner detection.
 *
=============================================================================================
 *                          Predicated thresholding
=============================================================================================
 * Predicated thresholding allows to better preserve texture details and to improve performance,
 * by decreasing the number of detected edges using an additional buffer like the light
 * accumulation buffer, object ids or even the depth buffer (the depth buffer usage may be
 * limited to indoor or short range scenes).
 *
 * It locally decreases the luma or color threshold if an edge is found in an additional buffer
 * (so the global threshold can be higher).
 *
 * This method was developed by Playstation EDGE MLAA team, and used in
 * Killzone 3, by using the light accumulation buffer. More information here:
 *     http://iryoku.com/aacourse/downloads/06-MLAA-on-PS3.pptx
 *
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * SMAA_PREDICATION_THRESHOLD: Threshold to be used in the additional predication buffer.
 *
 *      Range: depends on the input, so you'll have to find the magic number that works for you.
 *
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * SMAA_PREDICATION_SCALE: How much to scale the global threshold used for luma or color
 * edgedetection when using predication.
 *
 *      Range: [1, 5]
 *
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 * SMAA_PREDICATION_STRENGTH:  How much to locally decrease the threshold.
 *
 *      Range: [0, 1]
 *
=============================================================================================
 *                             Copyright & Redistribution
=============================================================================================
 * Copyright (C) 2011 Jorge Jimenez (jorge@iryoku.com)
 * Copyright (C) 2011 Jose I. Echevarria (joseignacioechevarria@gmail.com)
 * Copyright (C) 2011 Belen Masia (bmasia@unizar.es)
 * Copyright (C) 2011 Fernando Navarro (fernandn@microsoft.com)
 * Copyright (C) 2011 Diego Gutierrez (diegog@unizar.es)
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification
 * are permitted provided that the following conditions are met:
 *
 *    1. Redistributions of source code must retain the above copyright notice,
 *       this list of conditions and the following disclaimer.
 *
 *    2. Redistributions in binary form must reproduce the following disclaimer
 *       in the documentation and/or other materials provided with the distribution:
 *
 *      "Uses SMAA. Copyright (C) 2011 by Jorge Jimenez, Jose I. Echevarria,
 *       Tiago Sousa, Belen Masia, Fernando Navarro and Diego Gutierrez."
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS ``AS IS'' AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY
 * OF SUCH DAMAGE.
 *
 * The views and conclusions contained in the software and documentation are
 * those of the authors and should not be interpreted as representing official
 * policies, either expressed or implied, of the copyright holders.
=============================================================================================
 * end of descriptions
===========================================================================================*/

//-------------------Internal resource & helpers-------------------------------------------------------------------------------
#if    SMAA_PRESET == 5
// quality 0 == low, 1 == mid, 2 == high, 3 == ultra, 4 == custom
float  smaa_quality              < string UIName="SMAA Presets";               float UIMin=0;   int UIMax=4;    float UIStep=1.0; > = {5};
float  smaa_threshold            < string UIName="SMAA Threshold";             float UIMin=0; float UIMax=0.5;                    > = {0.15};
float  smaa_maxSearchSteps       < string UIName="SMAA Search Steps";          float UIMin=0;   int UIMax=98;   float UIStep=1.0; > = {64};
float  smaa_maxSearchStepsDiag   < string UIName="SMAA Diagonal Search Steps"; float UIMin=0;   int UIMax=20;   float UIStep=1.0; > = {16};
float  smaa_cornerRounding       < string UIName="SMAA Corner Rounding";       float UIMin=0;   int UIMax=100;  float UIStep=1.0; > = {8};

#if    SMAA_PREDICATION == 1
float  smaa_predicationthreshold < string UIName="SMAA Predication Threshold"; float UIMin=0; float UIMax=1; > = {0.01};
float  smaa_predicationstrength  < string UIName="SMAA Predication Strength";  float UIMin=1; float UIMax=5; > = {2};
float  smaa_predicationscale     < string UIName="SMAA Predication Scale";     float UIMin=0; float UIMax=1; > = {0.4};
#define SMAA_PREDICATION_THRESHOLD      smaa_predicationthreshold
#define SMAA_PREDICATION_STRENGTH       smaa_predicationstrength
#define SMAA_PREDICATION_SCALE          smaa_predicationscale
#endif
#if    SMAA_DEBUG == 1          // tex 0 == input tex, 1 == edge, 2 == weighted edge, 3 == outcome
float  smaa_showstagetex         < string UIName="SMAA Show Stage Tex";        float UIMin=0; float UIMax=3; float UIStep=1.0; > = {3};
#endif

static float4 smaa_presets[5] =
{
    float4(0.15,  4,  0, 100),  // low
    float4(0.1,   8,  0, 100),  // min
    float4(0.1,  16,  8,  25),  // high
    float4(0.05, 32, 16,  25),  // ultra
    float4(smaa_threshold,  smaa_maxSearchSteps,  smaa_maxSearchStepsDiag, smaa_cornerRounding)
};

//bypass to trick over preprocessor
static float bypass_maxSearchStepsDiag = smaa_presets[smaa_quality].z;
static float bypass_cornerRounding     = smaa_presets[smaa_quality].w;

#define SMAA_FORCE_DIAGONAL_DETECTION   1
#define SMAA_FORCE_CORNER_DETECTION     1

#define SMAA_THRESHOLD                  smaa_presets[smaa_quality].x
#define SMAA_MAX_SEARCH_STEPS           smaa_presets[smaa_quality].y
#define SMAA_MAX_SEARCH_STEPS_DIAG      bypass_maxSearchStepsDiag
#define SMAA_CORNER_ROUNDING            bypass_cornerRounding

#elif SMAA_PRESET == 4    
    #define SMAA_DEBUG 0
#elif SMAA_PRESET == 3
    #define SMAA_PRESET_ULTRA 1
    #define SMAA_DEBUG 0
#elif SMAA_PRESET == 2
    #define SMAA_PRESET_HIGH 1
    #define SMAA_DEBUG 0
#elif SMAA_PRESET == 1
    #define SMAA_PRESET_MEDIUM 1
    #define SMAA_DEBUG 0
#elif SMAA_PRESET == 0
    #define SMAA_PRESET_LOW 1
    #define SMAA_DEBUG 0
#endif

#define SMAA_HLSL_4_1 1 // actually using 5.0 here, SMAA header use 4.1 profile
#define SMAA_PIXEL_SIZE float2( ScreenSize.y, ScreenSize.y * ScreenSize.z)
#include "SMAA.h"

#define SMAA_STRING(a) #a
#ifndef SMAA_EDGE_TEX
#define SMAA_EDGE_TEX   RenderTargetRGB32F 
#endif
#ifndef SMAA_BLEND_TEX
#define SMAA_BLEND_TEX  RenderTargetRGBA64
#endif


Texture2D SMAA_AreaTex   < string UIName = "SMAA Area Tex";   string ResourceName = "SMAA_AreaTex.dds";   >;
Texture2D SMAA_SearchTex < string UIName = "SMAA Search Tex"; string ResourceName = "SMAA_SearchTex.dds"; >;

struct VS_INPUT_SMAA
{
	float3 pos   : POSITION;
	float2 coord : TEXCOORD0;
};

struct VS_OUTPUT_SMAA
{
    float4 svPosition : SV_POSITION;
    float2 texcoord   : TEXCOORD0;
    float4 offset[3]  : TEXCOORD1;
};

//----------------------------------------------------------------------------------------------------------------------------
//full screen quad
void VS_SMAAClear( VS_INPUT_SMAA i, out float4 svPosition : SV_POSITION, out float2 texcoord : TEXCOORD0) {
	svPosition = float4(i.pos, 1.0);
    texcoord   = i.coord;
}

//clear up buffer
float4 PS_SMAAClear( float4 position : SV_POSITION, float2 texcoord : TEXCOORD0) : SV_Target {
    return 0;
}

//original tex for bypass texture
float4 PS_SMAAOriginal( float4 position : SV_POSITION, float2 texcoord : TEXCOORD0) : SV_Target {
    return TextureColor.Sample(LinearSampler, texcoord);
}

//----------------------------------------------------------------------------------------------------------------------------
void VS_SMAAEdgeDetection( VS_INPUT_SMAA i, out VS_OUTPUT_SMAA o) {
    o.texcoord = i.coord;
    SMAAEdgeDetectionVS(float4(i.pos, 1.0), o.svPosition, o.texcoord, o.offset);
}

float4 PS_SMAAEdgeDetection( VS_OUTPUT_SMAA i) : SV_Target {
#if SMAA_EDGE_MODE == 1
    return float4(SMAALumaEdgeDetectionPS( i.texcoord, i.offset, TextureColor
    #if SMAA_PREDICATION == 1
        , TextureDepth
    #endif
        ).xyz, 1.0);
#elif SMAA_EDGE_MODE == 2
    return float4(SMAADepthEdgeDetectionPS( i.texcoord, i.offset, TextureDepth).xyz, 1.0);
#else
    return float4(SMAAColorEdgeDetectionPS( i.texcoord, i.offset, TextureColor
    #if SMAA_PREDICATION == 1
        , TextureDepth
    #endif
        ).xyz, 1.0);
#endif
}

//----------------------------------------------------------------------------------------------------------------------------
void VS_SMAABlendingWeightCalculation( VS_INPUT_SMAA i, out VS_OUTPUT_SMAA o) {
    float2 null;
    o.texcoord = i.coord;
    SMAABlendingWeightCalculationVS(float4(i.pos, 1.0), o.svPosition, o.texcoord, null, o.offset);
}

float4 PS_SMAABlendingWeightCalculation( VS_OUTPUT_SMAA i) : SV_Target {
    if(SMAA_EDGE_TEX.Sample(LinearSampler, i.texcoord).a < 0.5) discard;
    return SMAABlendingWeightCalculationPS( i.texcoord, i.svPosition.xy, i.offset, SMAA_EDGE_TEX, SMAA_AreaTex, SMAA_SearchTex, 0);
}

//----------------------------------------------------------------------------------------------------------------------------
void VS_SMAANeighborhoodBlending( VS_INPUT_SMAA i, out VS_OUTPUT_SMAA o) {
    float4 offset[2];
    o.texcoord   = i.coord;
    SMAANeighborhoodBlendingVS(float4(i.pos, 1.0), o.svPosition, o.texcoord, offset);
    o.offset[0] = offset[0];
    o.offset[1] = offset[1];
    o.offset[2] = float4(0.0, 0.0, 0.0, 0.0);
}

float4 PS_SMAANeighborhoodBlending( VS_OUTPUT_SMAA i) : SV_Target {
#if SMAA_DEBUG == 1
    if     (smaa_showstagetex < 0.5) return TextureColor.Sample(LinearSampler, i.texcoord);
    else if(smaa_showstagetex < 1.5) return SMAA_EDGE_TEX.Sample(LinearSampler, i.texcoord);
    else if(smaa_showstagetex < 2.5) return SMAA_BLEND_TEX.Sample(LinearSampler, i.texcoord);
#endif
    float4 offset[2] = {i.offset[0], i.offset[1]};
    return SMAANeighborhoodBlendingPS( i.texcoord, offset, TextureColor, SMAA_BLEND_TEX);
}
#endif  // end of header.

//----------------techniques--------------------------------------------------------------------------------------------------
