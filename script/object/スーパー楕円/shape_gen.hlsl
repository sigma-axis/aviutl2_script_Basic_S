cbuffer constant0 : register(b0) {
	float4 color_line, color_back;
	float2 size;
	float e, thick, stalk;
};
float2 choose_closest(float2 u1, float2 u2, float2 u3, float2 p)
{
	float q1 = dot(u1 - p, u1 - p), q2 = dot (u2 - p, u2 - p);
	if (q1 > q2) { u1 = u2; q1 = q2; }
	return q1 > dot (u3 - p, u3 - p) ? u3 : u1;
}
static const float2 radius = max(size - stalk, 1) / 2;
static const float inv_mean_radius = 1 / sqrt(radius.x * radius.y);
static const float2 inv_rr_e = pow(inv_mean_radius * radius, -e);
float2 eval_func(float2 u, float2 p, float2 irre)
{
	const float2
		q = p - u,
		v = irre * pow(inv_mean_radius * abs(u), e - 1),
		u1 = float2(1, -v.x / v.y),
		v1 = irre * inv_mean_radius * (e - 1) * pow(inv_mean_radius * abs(u), e - 2) * u1;
	return float2(
		dot(q, float2(-v.y, v.x)),
		dot(-u1, float2(-v.y, v.x)) + dot(q, float2(-v1.y, v1.x)));
}
float2 find_closest(float2 p, float2 r, float2 irre)
{
	float2 u = r * pow(0.5, 1 / e);
	if (e < 1) {
		float4 v;
		v.xy = max(p, 0.5);
		v.zw = r * pow(abs(1 - irre.yx * pow(inv_mean_radius * v.yx, e)), 1 / e);
		u = choose_closest(u, v.zy, v.xw, p);
	}
	for (int i = 0; i < 8; i++) {
		if (dot(p - u, p - u) < 0.25 / 65536) break;

		float2 w = eval_func(u, p, irre);
		if (w[1] == 0) break;
		if (w[1] < 0) w[1] *= -0.5;
		float dx = -w[0] / w[1];

		if (u.x + dx < 0) dx = -u.x / 2;
		else if (u.x + dx > r.x) dx = (r.x - u.x) / 2;
		u.x = clamp(u.x + dx, 0, r.x);
		u.y = r.y * pow(abs(1 - irre.x * pow(inv_mean_radius * u.x, e)), 1 / e);
		if (abs(dx) < 1.0 / 256) break;
	}
	return u;
}
float2 find_closest(float2 p)
{
	const bool do_flip = (dot(float2(1, -1), p / radius) > 0) == (e > 1);
	float2 r = radius, irre = inv_rr_e;
	if (do_flip) { p = p.yx; r = r.yx; irre = irre.yx; }
	float2 ret = find_closest(p, r, irre);
	if (do_flip) ret = ret.yx;
	return ret;
}
float4 shape_gen(float4 pos : SV_Position) : SV_Target
{
	const float2 p0 = abs(pos.xy - size / 2),
		p = max(p0 - stalk / 2, 0),
		u = find_closest(p);
	const float
		l0 = 0.75 * stalk - min(p0.x, p0.y),
		l1 = min(size.x / 2 - p0.x, size.y / 2 - p0.y),
		l2 = sign(1 - dot(inv_rr_e, pow(inv_mean_radius * p, e))) * length(u - p),
		l = min(max(l0, l2), l1);
	return saturate(l) * lerp(color_line, color_back, saturate(l - thick));
}
