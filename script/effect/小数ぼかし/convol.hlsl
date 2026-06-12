RWTexture2D<half4> dst : register(u0);
Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float2 dst_size_f;
	float span_i_f, span_f, inv_span;
};
static const uint2 dst_size = uint2(dst_size_f);
static const uint span_i = uint(span_i_f);
int4 quantize(float4 v)
{
	return int4(round((1 << 12) * v));
}
[numthreads(1, 64, 1)]
void convol(uint2 id : SV_DispatchThreadID)
{
	if (id.y >= dst_size.x) return;
	uint dst_x = dst_size.x - 1 - id.y;

	int4 sum = 0;
	for (uint x = 0; x < dst_size.y; x++) {
		const float4 c = src.Load(int3(x, id.y, 0)),
			c0 = src.Load(int3(x - span_i, id.y, 0));
		dst[uint2(dst_x, x)] = inv_span * (sum + span_f * c);
		sum += quantize(c) - quantize(c0);
	}
}
