Texture2D src : register(t0);
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
float4 promote(float4 pos : SV_Position) : SV_Target
{
	return encode(src[pos.xy].a);
}
