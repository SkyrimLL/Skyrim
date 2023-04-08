//=======================//
// Fake HDR by Ceejay.dk //
// ENB port by Adyss     //
//=======================//
float3 HDR(float3 color, float2 coord)
{	
	if (USE_HDR==true)
	{
	
	float2 pixelsize=ScreenSize.y;
	pixelsize.y*=ScreenSize.z;
	
	float HDRPower  =lerp( lerp(HDRPower_Night,  HDRPower_Day,  ENightDayFactor), HDRPower_Interior,  EInteriorFactor );
    float radius1   =lerp( lerp(radius1_Night,   radius1_Day,   ENightDayFactor), radius1_Interior,   EInteriorFactor );
    float radius2   =lerp( lerp(radius2_Night,   radius2_Day,   ENightDayFactor), radius2_Interior,   EInteriorFactor );

	float3 bloom_sum1 = TextureColor.Sample(Sampler0, coord + float2(1.5, -1.5) * radius1 * pixelsize);
	bloom_sum1 += TextureColor.Sample(Sampler0, coord + float2(-1.5, -1.5) * radius1 * pixelsize);
	bloom_sum1 += TextureColor.Sample(Sampler0, coord + float2( 1.5,  1.5) * radius1 * pixelsize);
	bloom_sum1 += TextureColor.Sample(Sampler0, coord + float2(-1.5,  1.5) * radius1 * pixelsize);
	bloom_sum1 += TextureColor.Sample(Sampler0, coord + float2( 0.0, -2.5) * radius1 * pixelsize);
	bloom_sum1 += TextureColor.Sample(Sampler0, coord + float2( 0.0,  2.5) * radius1 * pixelsize);
	bloom_sum1 += TextureColor.Sample(Sampler0, coord + float2(-2.5,  0.0) * radius1 * pixelsize);
	bloom_sum1 += TextureColor.Sample(Sampler0, coord + float2( 2.5,  0.0) * radius1 * pixelsize);

	bloom_sum1 *= 0.005;

	float3 bloom_sum2 = TextureColor.Sample(Sampler0, coord + float2(1.5, -1.5) * radius2 * pixelsize);
	bloom_sum2 += TextureColor.Sample(Sampler0, coord + float2(-1.5, -1.5) * radius2 * pixelsize);
	bloom_sum2 += TextureColor.Sample(Sampler0, coord + float2( 1.5,  1.5) * radius2 * pixelsize);
	bloom_sum2 += TextureColor.Sample(Sampler0, coord + float2(-1.5,  1.5) * radius2 * pixelsize);
	bloom_sum2 += TextureColor.Sample(Sampler0, coord + float2( 0.0, -2.5) * radius2 * pixelsize);	
	bloom_sum2 += TextureColor.Sample(Sampler0, coord + float2( 0.0,  2.5) * radius2 * pixelsize);
	bloom_sum2 += TextureColor.Sample(Sampler0, coord + float2(-2.5,  0.0) * radius2 * pixelsize);
	bloom_sum2 += TextureColor.Sample(Sampler0, coord + float2( 2.5,  0.0) * radius2 * pixelsize);

	bloom_sum2 *= 0.010;

	float dist = radius2 - radius1;
	float3 HDR = (color + (bloom_sum2 - bloom_sum1)) * dist;
	float3 blend = HDR + color;
	color = pow(abs(blend), abs(HDRPower)) + HDR; // pow - don't use fractions for HDRpower
	
	return saturate(color);
	}
	else
	return color;
}