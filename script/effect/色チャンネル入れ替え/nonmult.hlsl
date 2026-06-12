Texture2D src : register(t0);
cbuffer constant0 : register(b0) {
	float4 v;
	float4x4 mat;
};
float4 nonmult(float4 pos : SV_Position) : SV_Target
{
	float4 c = src.Load(int3(pos.xy, 0));
	c.rgb = c.a > 0 ? c.rgb / c.a : 0;
	c = saturate(v + mul(mat, c));
	c.rgb *= c.a;
	return c;
}
