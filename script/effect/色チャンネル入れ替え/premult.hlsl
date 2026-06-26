Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float4 v;
	float4x4 mat;
};
float4 premult(float4 pos : SV_Position) : SV_Target
{
	float4 c = src[pos.xy];
	c = v + mul(mat, c);
	c.a = saturate(c.a);
	c.rgb = clamp(c.rgb, 0, c.a);
	return c;
}
