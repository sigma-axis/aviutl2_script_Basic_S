Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float alpha, buffer;
};
static const float least_a = 1.0 / 8192;
float4 apply(float4 pos : SV_Position) : SV_Target
{
	const float4 col = src.Load(int3(pos.xy, 0));
	const float a = (col.a - alpha - least_a) / (buffer - least_a);
	return float4((col.a > 0 ?  a / col.a : 0) * col.rgb, a);
}
