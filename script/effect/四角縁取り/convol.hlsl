RWTexture2D<half4> dst : register(u0);
Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float2 dst_size_f;
	float size_i_f, size_f;
	float rate, crop_f;
};
static const uint2 dst_size = uint2(dst_size_f);
static const uint size_i = uint(size_i_f), crop = uint(crop_f);
half4 encode(float a)
{
	const uint v = asuint(a);
	return half4((v >> 0) & 0xff, (v >> 8) & 0xff, (v >> 16) & 0xff, (v >> 24) & 0xff);
}
float decode(half4 p)
{
	const uint4 v4 = round(p);
	const uint v = v4[0] | (v4[1] << 8) | (v4[2] << 16) | (v4[3] << 24);
	return asfloat(v);
}
int quantize(float v)
{
	return int(round((1 << 16) * v));
}
[numthreads(1, 64, 1)]
void convol(uint2 id : SV_DispatchThreadID)
{
	if (id.y >= dst_size.x) return;

	int sum = 0; float a0 = 0;
	for (uint x = 0; x < dst_size.y + crop; x++) {
		const float a = decode(src.Load(int3(x, id.y, 0))),
			a1 = decode(src.Load(int3(x - 2 * size_i - 1, id.y, 0)));
		if (x >= crop)
			dst[uint2(id.y, x - crop)] = encode((sum + size_f * (a + a0)) * rate);
		sum += quantize(a) - quantize(a1);
		a0 = a1;
	}
}
