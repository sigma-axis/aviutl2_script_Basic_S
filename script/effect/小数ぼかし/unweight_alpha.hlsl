cbuffer constant0 : register(b0) {
	float2 size_f, span_i_f, span_f, wt;
};
int2 sum_steps(int2 i)
{
	return i * (i + 1) >> 1;
}
float4 unweight_alpha(float4 pos : SV_Position) : SV_Target
{
	static const int2 size = int2(size_f), span_i = int2(span_i_f);
	const int2 p = int2(pos.xy);

	float2 sum = wt;
	sum -= max(span_i - p, 0) * span_f + sum_steps(max(span_i - p - 1, 0));
	sum -= max(span_i - size + p + 1, 0) * span_f + sum_steps(max(span_i - size + p, 0));

	return float4(0, 0, 0, (wt.x * wt.y) / (sum.x * sum.y));
}
