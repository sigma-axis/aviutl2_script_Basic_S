Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float4 color;
};
float4 recol_one(float4 pos : SV_Position) : SV_Target
{
	const float4 col = src[pos.xy];
	return (1 - col.a) * color;
}
