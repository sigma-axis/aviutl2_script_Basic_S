Texture2D src : register(t0);
SamplerState smp : register(s0);
cbuffer constant0 : register(b0) {
	float4 margin;
	float4 pivot;
	float2 inv_size;
	float2 mid, dlen, mode_f;
};
float calc_coord(uint mode, float x, float2 mgn, float m, float2 p, float l)
{
	float x2 = p[1] * (x - p[0]);
	switch (mode) {
	case 0:
	{
		x2 = fmod(x2, m);
		x2 = clamp(x2, 0.5, m - 0.5);
		break;
	}
	case 1: case 2:
	{
		x2 = fmod(x2, m);
		x2 = min(x2, m - x2);
		if (mode == 1) x2 = clamp(x2, 0.5, m / 2 - 0.5);
		break;
	}
	case 3: default:
	{
		x2 = x2 * m / (l + m);
		break;
	}
	}
	return x <= mgn[0] ? x :
		x < mgn[1] ? x2 + mgn[0] :
		x - l;
}
float4 mid_loop(float4 pos : SV_Position) : SV_Target
{
	static const uint2 mode = uint2(mode_f);
	return src.Sample(smp, inv_size * float2(
		calc_coord(mode.x, pos.x, margin.xz, mid.x, pivot.xy, dlen.x),
		calc_coord(mode.y, pos.y, margin.yw, mid.y, pivot.zw, dlen.y)));
}
