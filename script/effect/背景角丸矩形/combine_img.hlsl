Texture2D obj : register(t0);
Texture2D lin : register(t1);
Texture2D bkg : register(t2);
Texture2D lin_tex : register(t3);
Texture2D bkg_tex : register(t4);
cbuffer constant0 : register(b0) {
	float2 ofs_obj, ofs_bkg;
	float alpha_object, alpha_line, alpha_back, clip_f;

	float2 size_tex_lin_f, size_tex_bkg_f,
		ofs_tex_lin, ofs_tex_bkg;
};
static const int clip = int(clip_f);
static const uint2
	size_tex_lin = uint2(size_tex_lin_f),
	size_tex_bkg = uint2(size_tex_bkg_f);
int2 loop_pos(int2 center, uint2 size)
{
	const int2 pt = center + (size >> 1);
	return pt >= 0 ?
		uint2(pt) % size :
		size - 1 - int2(uint2(-1 - pt) % size);
}
float4 combine_img(float4 pos : SV_Position) : SV_Target
{
	const float4
		c_obj = obj.Load(int3(floor(pos.xy - ofs_obj), 0)),
		c_lin = lin_tex.Load(int3(loop_pos(floor(pos.xy - ofs_bkg - ofs_tex_lin), size_tex_lin), 0)),
		c_bkg = bkg_tex.Load(int3(loop_pos(floor(pos.xy - ofs_bkg - ofs_tex_bkg), size_tex_bkg), 0));
	const float
		a_obj = alpha_object * c_obj.a,
		a_lin = lin.Load(int3(floor(pos.xy - ofs_bkg), 0)).a,
		a_bkg = bkg.Load(int3(floor(pos.xy - ofs_bkg), 0)).a;

	const float
		clip_obj = clip == 0 ? 1 : clip < 2 ? a_bkg : a_bkg - a_lin,
		clip_lin = clip < 2 ? 1 - a_obj : 1,
		clip_bkg = (1 - a_obj) * (a_bkg - a_lin);

	return clip_obj * alpha_object * c_obj
		+ clip_lin * alpha_line * a_lin * c_lin
		+ clip_bkg * alpha_back * a_bkg * c_bkg;
}
