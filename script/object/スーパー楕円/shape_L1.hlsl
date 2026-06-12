cbuffer constant0 : register(b0) {
	float4 color_line, color_back;
	float2 size;
	float e, thick, stalk;
};
static const float2 n_slope = normalize(size.yx);
static const float L = size.x * n_slope.x / 2;
float4 shape_L1(float4 pos : SV_Position) : SV_Target
{
	const float2 p = abs(pos.xy - size / 2);
	const float l = L - dot(n_slope, p);
	return saturate(l) * lerp(color_line, color_back, saturate(l - thick));
}
