Texture2D obj : register(t0);
Texture2D lin : register(t1);
Texture2D bkg : register(t2);
cbuffer constant0 : register(b0) {
	float2 ofs_obj, ofs_bkg;
	float alpha_object, clip_f;
	float4 color_line, color_back;
};
static const int clip = int(clip_f);
float4 combine(float4 pos : SV_Position) : SV_Target
{
	const float4
		c_obj = obj.Load(int3(floor(pos.xy - ofs_obj), 0));
	const float
		a_obj = alpha_object * c_obj.a,
		a_lin = lin.Load(int3(floor(pos.xy - ofs_bkg), 0)).a,
		a_bkg = bkg.Load(int3(floor(pos.xy - ofs_bkg), 0)).a;

	const float
		clip_obj = clip == 0 ? 1 : clip < 2 ? a_bkg : a_bkg - a_lin,
		clip_lin = clip < 2 ? 1 - a_obj : 1,
		clip_bkg = (1 - a_obj) * (a_bkg - a_lin);

	return clip_obj * alpha_object * c_obj
		+ clip_lin * a_lin * color_line
		+ clip_bkg * a_bkg * color_back;
}
