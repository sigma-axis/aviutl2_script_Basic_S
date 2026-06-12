Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float r_log2_base, r_scale;
};
static const float3x3 mat_yc2rgb = {
	1, 0, 1.402,
	1, -0.3441363, -0.7141363,
	1, 1.772, 0
};
float4 unweight_luma(float4 pos : SV_Position) : SV_Target
{
	float4 col = src.Load(int3(pos.xy, 0));
	col.x = r_log2_base * log2(1 + r_scale * (col.a > 0 ? col.x / col.a : 0)) * col.a;
	col.rgb = mul(mat_yc2rgb, col.xyz);
	return col;
}
