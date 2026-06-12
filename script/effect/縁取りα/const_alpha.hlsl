cbuffer constant0 : register(b0) {
	float alpha;
};
float4 const_alpha(float4 pos : SV_Position) : SV_Target
{
	return float4(0, 0, 0, alpha);
}
