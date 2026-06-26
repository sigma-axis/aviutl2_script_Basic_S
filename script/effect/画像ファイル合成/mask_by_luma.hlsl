Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float intensity;
};
float4 mask_by_luma(float4 pos : SV_Position) : SV_Target
{
	static const float3 luma_coeff = { 0.299, 0.587, 0.114 };
	return float4(0, 0, 0,
		1 - intensity * (1 - dot(luma_coeff, src[pos.xy].rgb)));
}
