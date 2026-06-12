Texture2D mask : register(t0);
Texture2D img : register(t1);
cbuffer constant0 : register(b0) {
	float2 offset, size_f;
};
float4 recolor(float4 pos : SV_Position) : SV_Target
{
	static const uint2 size = size_f;
	int2 pt = floor(pos.xy - 0.5 - offset);
	pt = pt >= 0 ? uint2(pt) % size : size - 1 - int2(uint2(-1 - pt) % size);
	return mask.Load(int3(pos.xy, 0)).a * img.Load(int3(pt, 0));
}
