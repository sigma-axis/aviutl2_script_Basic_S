Texture2D src : register(t0);
float4 transpose(float4 pos : SV_Position) : SV_Target
{
	return src[pos.yx];
}
