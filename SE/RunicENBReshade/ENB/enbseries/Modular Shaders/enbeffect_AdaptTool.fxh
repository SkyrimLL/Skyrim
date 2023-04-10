//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
// ENBSeries Fallout 4 adaptation file, hlsl DX11                   //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//
//  Adaptation Level Visualizer by kingeric1992                     //
//                                                                  //
//  Usage: Include this file in enbeffect.fx, then add              //
//                                                                  //
//          pass ADAPT_TOOL_PASS                                    //
//                                                                  //
//  after other passes in a technique.                              //
//                                                                  //
//  For more info, visit                                            //
//     http://enbseries.enbdev.com/forum/viewtopic.php?f=7&t=5321   //
//                                                                  //
//  update: Nov.29.2016                                             //
//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++//

int   AdaptToolTitle0 < string UIName="\xA4\xA4\xA4\xA4\xA4\xA4\xA4 AdaptationTool \xA4\xA4\xA4\xA4\xA4"; float UIMin=0.0; float UIMax=0.0; > = { 0 };
int   AdaptToolTitle1 < string UIName=" "; float UIMin=0.0; float UIMax=0.0; > = { 0 };
bool  AdaptToolEnabled< string UIName="Adapt Tool Enabled"; > = { false };
float AdaptToolMax    < string UIName="Adapt Max Brightness (log2 scale)"; float UIMin= -9.0; float UIMax=3.0; > = {  1.00 };
float AdaptToolMin    < string UIName="Adapt Min Brightness (log2 scale)"; float UIMin= -9.0; float UIMax=3.0; > = { -4.00 };

void VS_AdaptTool( inout float4 pos : SV_POSITION, inout float2 txcoord0 : TEXCOORD0)
{
    pos = float4( pos.xy / 16.0 + float2(15.0 / 16.0, -15.0 / 16.0) , pos.z, 1.0);
}  

float4 PS_AdaptTool(float4 pos : SV_POSITION,  float2 txcoord0 : TEXCOORD0) : SV_Target
{
    clip(AdaptToolEnabled? 1.0:-1.0);
    float  adapt = saturate((log2(TextureAdaptation.Sample(Sampler0, 0.5).x) + 9.0) / 12.0);
           adapt = step(txcoord0.x, adapt + ScreenSize.y * 16.0) * step(adapt - ScreenSize.y * 16.0, txcoord0.x);    
    return adapt + float4( 0.0, step(txcoord0.x, (AdaptToolMax + 9.0) / 12.0) * step((AdaptToolMin + 9.0) / 12.0, txcoord0.x) * 0.5, 0.0, 0.0);
}

#define ADAPT_TOOL_PASS  AdaptToolPass \
    { SetVertexShader(CompileShader(vs_5_0, VS_AdaptTool())); \
      SetPixelShader(CompileShader(ps_5_0, PS_AdaptTool())); }