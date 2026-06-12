Texture2D src : register(t0);
float4 unalpha(float4 pos : SV_Position) : SV_Target
{
	float4 c = src.Load(int3(pos.xy, 0));
	return float4(c.a > 0 ? c.rgb / c.a : 0, 1);
}
