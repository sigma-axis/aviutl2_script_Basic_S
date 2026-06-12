cbuffer constant0 : register(b0) {
	float4 color_line, color_back;
	float2 size;
	float e, thick, stalk;
};
float min_xy(float2 p)
{
	return min(p.x, p.y);
}
float4 shape_box(float4 pos : SV_Position) : SV_Target
{
	const float2 p = abs(pos.xy - size / 2);
	const float l = min_xy(size / 2 - p);
	return saturate(l) * lerp(color_line, color_back, saturate(l - thick));
}
