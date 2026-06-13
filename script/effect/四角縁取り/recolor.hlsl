Texture2D mask : register(t0);
Texture2D img : register(t1);
SamplerState smp : register(s0);
cbuffer constant0 : register(b0) {
	float2 scale_cos_sin, offset, size;
	float no_smooth_f;
};
static const float2x2 mat = {
	scale_cos_sin.x, -scale_cos_sin.y,
	scale_cos_sin.y, scale_cos_sin.x,
};
float4 recolor(float4 pos : SV_Position) : SV_Target
{
	float2 pt = mul(mat, pos.xy) + offset;
	if (no_smooth_f > 0) pt = floor(pt) + 0.5;
	return mask[pos.xy].a * img.Sample(smp, pt / size);
}
