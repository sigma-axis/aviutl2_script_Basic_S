Texture2D mask : register(t0);
Texture2D img : register(t1);
cbuffer constant0 : register(b0) {
	float2 offset, size_f;
};
static const uint2 size = size_f;
float4 recol_img(float4 pos : SV_Position) : SV_Target
{
	int2 pt = floor(pos.xy - 0.5 - offset);
	pt = pt >= 0 ? uint2(pt) % size : size - 1 - int2(uint2(-1 - pt) % size);
	const float4 col = mask[pos.xy];
	return (1 - col.a) * img.Load(int3(pt, 0));
}
