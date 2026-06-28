Texture2D src : register(t0);
SamplerState smp : register(s0);
cbuffer constant0 : register(b0) {
	float2 dst_size_f;
	float span_i_f, min_pixel_wt;
	float4 rates;
};
static const uint span_i = uint(span_i_f);
static const uint2
	dst_size = uint2(dst_size_f),
	src_size = dst_size.yx - uint2(2 * span_i, 0);
static const float2 inv_size_src = 1.0 / src_size;
float4 pick(float2 pos, out float wt)
{
	wt = clamp(0.5 + min(pos.x, float(src_size.x) - pos.x), min_pixel_wt, 1);
	return src.SampleLevel(smp, pos * inv_size_src, 0);
}
float4 convol_gauss(float4 pos : SV_Position) : SV_Target
{
	const float2 pos_src = pos.yx - float2(span_i, 0);
	float4 sum = src.Load(int3(floor(pos_src), 0));
	float sum_wt = 1,
		dwt0 = 1, wt0 = rates[0], dwt01 = rates[1];
	for (uint x = 1; x <= span_i; x += 2, dwt0 *= rates[3], wt0 *= dwt0, dwt01 *= rates[2]) {
		const float wt1 = wt0 * dwt01, med = saturate(1 - rcp(1 + dwt01)), x_med = x + med;
		float wt_add_l, wt_add_r;
		sum += (wt0 + wt1) * (
			pick(pos_src - float2(x_med, 0), wt_add_l) +
			pick(pos_src + float2(x_med, 0), wt_add_r));
		sum_wt += (wt0 + wt1) * (wt_add_l + wt_add_r);
	}

	return sum / sum_wt;
}
