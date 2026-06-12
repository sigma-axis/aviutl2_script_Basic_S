Texture2D dst : register(t0);
Texture2D src : register(t1);
cbuffer constant0 : register(b0) {
	float intensity;
};
float4 luma_as_alpha(float4 pos : SV_Position) : SV_Target
{
	static const float3 luma_coeff = { 0.299, 0.587, 0.114 };
	const float4 c0 = dst.Load(int3(pos.xy, 0));
	const float a1 = max(dot(luma_coeff, src.Load(int3(pos.xy, 0)).rgb), 0);
	return c0 * (1 - intensity * (1 - (c0.a > a1 ? a1 / c0.a : 1)));
}
