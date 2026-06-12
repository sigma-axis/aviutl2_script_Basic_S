Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float log2_base, scale;
};
static const float3x3 mat_rgb2yc = {
	0.299, 0.587, 0.114,
	-0.16873589, -0.3312641, 0.5,
	0.5, -0.41868758, -0.08131241
};
float4 weight_luma(float4 pos : SV_Position) : SV_Target
{
	float4 col = src.Load(int3(pos.xy, 0));
	col.xyz = mul(mat_rgb2yc, col.rgb);
	col.x = scale * (exp2(log2_base * (col.a > 0 ? col.x / col.a : 0)) - 1) * col.a;
	return col;
}
