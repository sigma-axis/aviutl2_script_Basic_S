Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float2 size, move;
	float2x2 rot;
	float2 tile_f;
	float no_smooth;
};
float2 wrap(float2 p)
{
	p /= size;
	return size * (tile_f > 0 ? p - floor(p) : p);
}
int2 wrap_i(int2 p)
{
	return tile_f > 0 ? min(uint2(p) - uint2(size), uint2(p)) : p;
}
float4 tile(float4 pos : SV_Position) : SV_Target
{
	float2 fr = wrap(mul(rot, pos.xy) + move - 0.5);
	const int2 p00 = floor(fr),
		p10 = wrap_i(p00 + int2(1, 0)),
		p01 = wrap_i(p00 + int2(0, 1)),
		p11 = wrap_i(p00 + int2(1, 1));
	fr -= p00;
	if (no_smooth > 0) fr = floor(fr + 0.5);

	return lerp(
		lerp(src.Load(int3(p00, 0)), src.Load(int3(p10, 0)), fr.x),
		lerp(src.Load(int3(p01, 0)), src.Load(int3(p11, 0)), fr.x), fr.y);
}
