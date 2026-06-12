Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float3x3 mat;
	float add_light, sat;
};
float4 by_yuv(float4 pos : SV_Position) : SV_Target
{
	float4 c = src.Load(int3(pos.xy, 0));
	c.rgb = mul(mat, c.rgb) + add_light * c.a;
	if (sat > 0) {
		c.a = saturate(c.a);
		c.rgb = clamp(c.rgb, 0, c.a);
	}
	return c;
}
