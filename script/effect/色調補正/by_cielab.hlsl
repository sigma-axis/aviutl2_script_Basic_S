Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float3x3 mat;
	float add_light, sat;
};
static const float3x3 m_srgb = {
	0.4338769, 0.37622303, 0.18990006,
	0.2126, 0.7152, 0.0722,
	0.017722681, 0.109458216, 0.8728191
}, m_srgb_i = {
	3.0802145, -1.537208, -0.54300654,
	-0.92096865, 1.875756, 0.04521258,
	0.05295247, -0.20402105, 1.1510686
};
static const float4 delta = {
	2 / 14.5,
	12.5 / 14.5,
	27 / (14.5 * 14.5),
	27 / (14.5 * 14.5 * 14.5)
};
float3 cbrt_func(float3 t)
{
	return t > delta[3] ?
		sign(t) * pow(abs(t), 1 / 3.0) - delta[0] :
		t / delta[2];
}
float3 cbrt_func_i(float3 t)
{
	return t > delta[0] / 2 ?
		(t + delta[0]) * (t + delta[0]) * (t + delta[0]) :
		t * delta[2];
}
float3 to_lab(float3 c)
{
	static const float4 K = { 0.055, 1 / 1.055, 1 / 12.92, 0.04045 };
	c = abs(c) <= K.w ? K.z * c : sign(c) * pow((abs(c) + K.x) * K.y, 2.4);
	return cbrt_func(mul(m_srgb, c));
}
float3 from_lab(float3 c)
{
	c = mul(m_srgb_i, cbrt_func_i(c));
	static const float4 K = { 0.055, 1.055, 12.92, 0.0031308 };
	return abs(c) <= K.w ? K.z * c : sign(c) * (K.y * pow(abs(c), 1 / 2.4) - K.x);
}
float4 by_cielab(float4 pos : SV_Position) : SV_Target
{
	float4 c = src.Load(int3(pos.xy, 0));
	c.rgb = to_lab(c.a > 0 ? c.rgb / c.a : 0);
	c.rgb = mul(mat, c.rgb) + delta[1] * add_light;
	c.rgb = c.a * from_lab(c.rgb);
	if (sat > 0) {
		c.a = saturate(c.a);
		c.rgb = clamp(c.rgb, 0, c.a);
	}
	return c;
}
