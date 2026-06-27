cbuffer constant0 : register(b0) {
	float2 size_f, span_i_f, span_f, wt;
};
static const int2 size = int2(size_f), span_i = int2(span_i_f);
float4 unweight_alpha_box(float4 pos : SV_Position) : SV_Target
{
	const int2 p = int2(pos.xy);

	float2 sum = wt;
	sum -= (span_i > p ? span_f : 0) + max(span_i - p - 1, 0);
	sum -= (span_i > size - p - 1 ? span_f : 0) + max(span_i - size + p, 0);

	return float4(0, 0, 0, (wt.x * wt.y) / (sum.x * sum.y));
}
