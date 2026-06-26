Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float intensity;
};
float4 mask(float4 pos : SV_Position) : SV_Target
{
	return float4(0, 0, 0,
		1 - intensity * (1 - src[pos.xy].a));
}
