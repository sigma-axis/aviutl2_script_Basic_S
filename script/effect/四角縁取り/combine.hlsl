Texture2D src_i : register(t0);
Texture2D src_o : register(t1);
cbuffer constant0 : register(b0) {
	float a_i, a_o;
};
float4 combine(float4 pos : SV_Position) : SV_Target
{
	const float4
		col_i = src_i.Load(int3(pos.xy, 0)),
		col_o = src_o.Load(int3(pos.xy, 0)) * a_o;
	return col_i.a * col_o + a_i * (1 - col_o.a) * col_i;
}
