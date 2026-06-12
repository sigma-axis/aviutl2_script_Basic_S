cbuffer constant0 : register(b0) {
	float4 bound;
};
float4 inv_mask(float4 pos : SV_Position) : SV_Target
{
	return float4(0, 0, 0,
		all(bound.xy <= pos.xy && pos.xy < bound.zw)? 0 : 1);
}
