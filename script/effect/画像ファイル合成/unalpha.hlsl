Texture2D src : register(t0);
float4 unalpha(float4 pos : SV_Position) : SV_Target
{
	float4 c = src[pos.xy];
	return float4(c.a > 0 ? c.rgb / c.a : 0, 1);
}
