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
	return int4(round((1 << 11) * v));
}
[numthreads(1, 64, 1)]
void convol_box(uint2 id : SV_DispatchThreadID)
{
	if (id.y >= dst_size.x) return;

	int4 sum = 0; float4 c0 = 0;
	for (uint x = 0; x < dst_size.y; x++) {
		const float4 c = src.Load(int3(x, id.y, 0)),
			c1 = src.Load(int3(x - 2 * span_i + 1, id.y, 0));
		dst[uint2(id.y, x)] = inv_span * (sum + span_f * (c + c0));
		sum += quantize(c) - quantize(c1);
		c0 = c1;
	}
}
