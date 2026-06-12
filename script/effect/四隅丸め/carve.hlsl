cbuffer constant0 : register(b0) {
	float3 size_shape[4];
	float2 size;
	float line_width, alpha_hole;
};

float2 ellipse_eval_func(float2 u, float2 p, float2 r2yx)
{
	const float2
		q = p - u,
		v = r2yx * u,
		u1 = float2(1, -v.x / v.y),
		v1 = r2yx * u1;
	return float2(
		dot(q, float2(-v.y, v.x)),
		dot(-u1, float2(-v.y, v.x)) + dot(q, float2(-v1.y, v1.x)));
}
float ellipse_dist(float2 pt, float2 sz)
{
	const bool do_flip = dot(float2(1, -1), pt / sz) > 0;
	if (do_flip) { pt = pt.yx; sz = sz.yx; }

	const float2 sz2 = sz * sz;
	float2 u = sqrt(0.5) * sz;
	for (int i = 0; i < 8; i++) {
		if (dot(pt - u, pt - u) < 0.25 / 65536) break;

		float2 w = ellipse_eval_func(u, pt, sz2.yx);
		if (w[1] == 0) break;
		if (w[1] < 0) w[1] *= -0.5;
		float dx = -w[0] / w[1];

		if (u.x + dx < 0) dx = -u.x / 2;
		else if (u.x + dx > sz.x) dx = (sz.x - u.x) / 2;
		u.x = clamp(u.x + dx, 0, sz.x);
		u.y = sz.y * sqrt(abs(1 - u.x * u.x / sz2.x));
		if (abs(dx) < 1.0 / 256) break;
	}

	int s = -1;
	if (all(pt > 0)) s = sign(dot(1, pow(pt / sz, 2)) - 1);
	return s * length(u - pt);
}
float circle_dist(float2 pt, float r)
{
	if (any(pt <= 0)) return max(pt.x, pt.y) - r;
	return length(pt) - r;
}

float shape_circle(float2 pt, float2 sz)
{
	[branch] if (sz.x == sz.y) return circle_dist(pt, sz.x);
	else return ellipse_dist(pt, sz);
}
float shape_rhombus(float2 pt, float2 sz)
{
	static const float3 L = { 1, 1, -1 }; // 45deg-line.
	const float3 pt1 = { pt, 1 }, sza = { sz, sz.x * sz.y };
	return dot(pt1, sza.yxz * L) / length(sza.yx * L.xy);
}
float shape_octagon_S(float2 pt, float2 sz)
{
	static const float3 L = { 0.9238795, 0.38268343, -0.9238795 };
	const float3 pt1 = { pt, 1 }, sza = { sz, sz.x * sz.y };
	return max(
		dot(pt1, sza.yxz * L) / length(sza.yx * L.xy),
		dot(pt1.yxz, sza * L) / length(sza.xy * L.xy));
}
float shape_octagon_R(float2 pt, float2 sz)
{
	static const float3 L0 = { 1, 0, -1 },
		L1 = { 0.70710677, 0.70710677, -1 }; // 45deg-line.
	const float3 pt1 = { pt, 1 }, sza = { sz, sz.x * sz.y };
	return max(max(
		dot(pt1, sza.yxz * L0) / length(sza.yx * L0.xy),
		dot(pt1.yxz, sza * L0) / length(sza.xy * L0.xy)),
		dot(pt1, sza.yxz * L1) / length(sza.yx * L1.xy));
}
float shape_dodecagon_S(float2 pt, float2 sz)
{
	static const float3
		L1 = { 0.9659258, 0.25881904, -0.9659258 }, // 15deg-line.
		L2 = { 0.70710677, 0.70710677, -0.9659258 }; // 45deg-line.
	const float3 pt1 = { pt, 1 }, sza = { sz, sz.x * sz.y };
	return max(max(
		dot(pt1, sza.yxz * L1) / length(sza.yx * L1.xy),
		dot(pt1.yxz, sza * L1) / length(sza.xy * L1.xy)),
		dot(pt1, sza.yxz * L2) / length(sza.yx * L2.xy));
}
float shape_dodecagon_R(float2 pt, float2 sz)
{
	static const float3 L0 = { 1, 0, -1 },
		L1 = { 0.8660254, 0.5, -1 }; // 30deg-line.
	const float3 pt1 = { pt, 1 }, sza = { sz, sz.x * sz.y };
	return max(max(
		dot(pt1, sza.yxz * L0) / length(sza.yx * L0.xy),
		dot(pt1.yxz, sza * L0) / length(sza.xy * L0.xy)), max(
		dot(pt1, sza.yxz * L1) / length(sza.yx * L1.xy),
		dot(pt1.yxz, sza * L1) / length(sza.xy * L1.xy)));
}
float shape_spike(float2 pt, float2 sz)
{
	static const float3
		L1 = { 0.9659258, 0.25881904, -0.9659258 }, // 15deg-line.
		L2 = { -0.5, 0.8660254, 0 }; // 120deg-line.
	const float3 pt1 = { pt, 1 }, sza = { sz, sz.x * sz.y };
	return max(max(
		dot(pt1, sza.yxz * L1) / length(sza.yx * L1.xy),
		dot(pt1.yxz, sza * L1) / length(sza.xy * L1.xy)), min(
		dot(pt1, sza.yxz * L2) / length(sza.yx * L2.xy),
		dot(pt1.yxz, sza * L2) / length(sza.xy * L2.xy)));
}

float carve_shape(float2 pt, float2 sz, int shape)
{
	[branch] if (any(sz <= 0)) return min(pt.x, pt.y);
	else {
		[branch] switch (shape) {
		case 0: default: return -shape_circle(sz - pt, sz);
		case 1: return shape_circle(pt, sz);
		case 2: return -shape_rhombus(sz - pt, sz);
		case 3: return -min(sz.x - pt.x, sz.y - pt.y);
		case 4: return -shape_octagon_S(sz - pt, sz);
		case 5: return shape_octagon_R(pt, sz);
		case 6: return shape_octagon_S(pt, sz);
		case 7: return -shape_dodecagon_S(sz - pt, sz);
		case 8: return shape_dodecagon_R(pt, sz);
		case 9: return shape_dodecagon_S(pt, sz);
		case 10: return shape_spike(pt, sz);
		case 11: return -shape_spike(sz - pt, sz);
		}
	}
}
float4 carve(float4 pos : SV_Position) : SV_Target
{
	float dist = min(min(pos.x, size.x - pos.x), min(pos.y, size.y - pos.y));

	static const int2 corners[4] = { { 0, 0 }, { 1, 0 }, { 1, 1 }, { 0, 1 } };
	for (int c = 0; c < 4; c++) {
		const float3 szs = size_shape[c];
		dist = min(dist, carve_shape(
			abs(pos.xy - corners[c] * size), szs.xy, int(szs.z)));
	}
	const float2 alpha = saturate(0.5 + dist - float2(0, line_width));
	return float4(0, 0, 0, alpha[0] * (1 - alpha_hole * alpha[1]));
}
