Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float maximize, rescale, clip_f;
};
float3 by_clamp(float4 c)
{
	return clamp(c.rgb, 0, c.a);
}
// modified from: https://github.com/korarei/AviUtl2_ColorLUT_K_Plugin/blob/c758529f5c82526fb882997cf3b5f6712afe1db2/src/filter/intern/shaders/blend.hlsli#L50-L54
float3 by_clip(float4 c, bool modified)
{
	static const float3 luma_coeff = { 0.30, 0.59, 0.11 };
	const float L = dot(luma_coeff, c.rgb);
	if (L <= 0.0) return 0.0;
	if (L >= c.a) return c.a;

	const float
		n = min(min(c.r, c.g), min(c.b, 0.0)),
		x = max(max(c.r, c.g), max(c.b, c.a)),
		sn = (L - 0.0) / (L - n), sx = (c.a - L) / (x - L);
	return L + (c.rgb - L) *
		(modified ? min(sn, sx) : sn * sx);
}
float4 clip_color(float4 pos : SV_Position) : SV_Target
{
	float4 c = src[pos.xy];
	c.a = max(c.a, 0);
	if (maximize > 0) c.a = max(max(c.r, c.g), max(c.b, c.a));
	if (rescale > 0) c /= max(c.a, 1); else c.a = min(c.a, 1);

	static const int clip_func = int(clip_f);
	switch(clip_func) {
	case 0: default:
		c.rgb = by_clamp(c); break;
	case 1: case 2:
		c.rgb = by_clip(c, clip_func == 2); break;
	}
	return c;
}
