Texture2D img1 : register(t0);
Texture2D img2 : register(t1);
cbuffer constant0 : register(b0) {
	float2 size;
	float a1, a2;
};
float4 blend(float4 pos : SV_Position) : SV_Target
{
	const float4
		col1 = img1.Load(int3(pos.xy - 0.5 - size, 0)),
		col2 = img2.Load(int3(pos.xy, 0));
	return a1 * col1 + a2 * col2;
}
