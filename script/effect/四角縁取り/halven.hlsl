Texture2D src : register(t0);
Texture2D eff : register(t1);
cbuffer constant0 : register(b0) {
	float3 color;
	float alpha_src, invert, rate;
	float2 offset;
};
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
float4 halven(float4 pos : SV_Position) : SV_Target
{
	const float
		a = src.Load(int3(floor(pos.xy - offset), 0)).a,
		A = decode(eff.Load(int3(pos.xy, 0))),
		alpha = saturate(alpha_src * a
			+ saturate(rate * ((1 - 2 * invert) * A + invert)));
	return float4(alpha * color, alpha);
}
