Texture2D src : register(t0);
Texture2D eff : register(t1);
cbuffer constant0 : register(b0) {
	float4 color;
	float2 size;
};
float4 carve(float4 pos : SV_Position) : SV_Target
{
	const float
		a = src.Load(int3(pos.xy - 0.5 - size, 0)).a,
		A = eff.Load(int3(pos.xy, 0)).a;
	return saturate(A - a) * color;
}
