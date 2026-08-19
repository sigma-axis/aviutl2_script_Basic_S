Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float3x3 mat;
	float add_light, sat, gamma;
};
static const float3x3 m1_rgb = {
	0.41222146, 0.53633255, 0.051445995,
	0.2119035, 0.6806995, 0.10739696,
	0.08830246, 0.28171885, 0.6299787
}, m1_rgb_i = {
	4.0767417, -3.3077116, 0.23096994,
	-1.268438, 2.6097574, -0.34131938,
	-0.0041960864, -0.7034186, 1.7076147
};
float3 to_lms_gamma(float3 c)
{
	static const float4 K = { 0.055, 1 / 1.055, 1 / 12.92, 0.04045 };
	c = mul(m1_rgb, abs(c) <= K.w ? K.z * c : sign(c) * pow((abs(c) + K.x) * K.y, 2.4));
	return sign(c) * pow(abs(c), 1 / 3.0);
}
float3 from_lms_gamma(float3 c, float g)
{
	c = mul(m1_rgb_i, c * c * c);
	static const float4 K = { 0.055, 1.055, 12.92, 0.0031308 };
	c = sign(c) * pow(abs(c), g);
	return abs(c) <= K.w ? K.z * c : sign(c) * (K.y * pow(abs(c), 1 / 2.4) - K.x);
}
float4 by_oklab(float4 pos : SV_Position) : SV_Target
{
	float4 c = src[pos.xy];
	c.rgb = to_lms_gamma(c.a > 0 ? c.rgb / c.a : 0);
	c.rgb = mul(mat, c.rgb) + add_light;
	c.rgb = c.a * from_lms_gamma(c.rgb, gamma);
	if (sat > 0) {
		c.a = saturate(c.a);
		c.rgb = clamp(c.rgb, 0, c.a);
	}
	return c;
}
