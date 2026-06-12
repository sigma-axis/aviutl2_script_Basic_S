Texture2D lin : register(t0);
Texture2D bkg : register(t1);
cbuffer constant0 : register(b0) {
	float4 color_line, color_back;
};
float4 combine(float4 pos : SV_Position) : SV_Target
{
	float a_lin = lin[pos.xy].a, a_bkg = bkg[pos.xy].a;
	return a_lin * color_line + (a_bkg - a_lin) * color_back;
}
