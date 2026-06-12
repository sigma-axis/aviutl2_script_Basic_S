Texture2D dst : register(t0);
Texture2D src : register(t1);
cbuffer constant0 : register(b0) {
	float intensity;
};
float4 replace_col(float4 pos : SV_Position) : SV_Target
{
	const float4 c0 = dst.Load(int3(pos.xy, 0)), c1 = src.Load(int3(pos.xy, 0));
	const float a0 = max(c0.a, 0);
	return lerp(c0, c1 * (a0 < c1.a ? a0 / c1.a : 1), intensity);
}
