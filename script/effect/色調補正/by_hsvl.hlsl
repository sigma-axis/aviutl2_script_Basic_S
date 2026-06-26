Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float3 mul_col, add_col;
	float col_space_f, sat;
};
// modified from: https://gist.github.com/983/e170a24ae8eba2cd174f
float3 rgb2hsvl(float3 c, uint col_space)
{
    static const float4 K = { 0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0 };
    const float4
		p = c.b > c.g ? float4(c.bg, K.wz) : float4(c.gb, K.xy),
    	q = p.x > c.r ? float4(p.xyw, c.r) : float4(c.r, p.yzx);
    const float d = q.x - min(q.w, q.y);
	float3 ret = { abs(q.z + (d > 0 ? (q.w - q.y) / (6 * d) : 0)), d, q.x };

	if (col_space >= 2) {
		ret.z -= ret.y / 2;
		if (col_space == 2) {
			const float u = 2 * min(ret.z, 1 - ret.z);
			ret.y = u != 0 ? ret.y / u : 0;
		}
	}
	else if (col_space == 0)
		ret.y = ret.z != 0 ? ret.y / ret.z : 0;
	return ret;
}
float3 hsvl2rgb(float3 c, uint col_space)
{
	if (col_space >= 2) {
		if (col_space == 2)
			c.y *= 2 * min(c.z, 1 - c.z);
		c.z += c.y / 2;
	}
	else if (col_space == 0) c.y *= c.z;

    static const float3 K = { 1.0, 2.0 / 3.0, 1.0 / 3.0 };
    const float3 p = 6 * abs(frac(c.x + K) - 0.5);
    return c.z - c.y * saturate(2 - p);
}

float4 by_hsvl(float4 pos : SV_Position) : SV_Target
{
	float4 c = src[pos.xy];
	c.xyz = rgb2hsvl(c.a != 0 ? c.rgb / c.a : 0, col_space_f);

	c.xyz *= mul_col;
	c.xyz += add_col;

	c.rgb = hsvl2rgb(c.xyz, col_space_f) * c.a;
	if (sat > 0) {
		c.a = saturate(c.a);
		c.rgb = clamp(c.rgb, 0, c.a);
	}
	return c;
}
