Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float3x3 mat;
	float add_light, sat;
};
float3 to_lin(float3 c)
{
	static const float4 K = { 0.055, 1 / 1.055, 1 / 12.92, 0.04045 };
	return abs(c) <= K.w ? K.z * c : sign(c) * pow((abs(c) + K.x) * K.y, 2.4);
}
float3 from_lin(float3 c)
{
	static const float4 K = { 0.055, 1.055, 12.92, 0.0031308 };
	return abs(c) <= K.w ? K.z * c : sign(c) * (K.y * pow(abs(c), 1 / 2.4) - K.x);
}
float4 by_xyz(float4 pos : SV_Position) : SV_Target
{
	float4 c = src[pos.xy];
	c.rgb = to_lin(c.a > 0 ? c.rgb / c.a : 0);
	c.rgb = mul(mat, c.rgb) + add_light;
	c.rgb = c.a * from_lin(c.rgb);
	if (sat > 0) {
		c.a = saturate(c.a);
		c.rgb = clamp(c.rgb, 0, c.a);
	}
	return c;
}
