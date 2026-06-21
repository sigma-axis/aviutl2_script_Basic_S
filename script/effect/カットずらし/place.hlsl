Texture2D src : register(t0);
SamplerState smp : register(s0);
cbuffer constant0 : register(b0) {
	float2 size, offset, line_n, move;
	float c1, crop, gap, mode_f;
};

float4 place(float4 pos : SV_Position) : SV_Target
{
	const float4
		col1 = src.Load(int3(floor(pos.xy - offset), 0)),
		col2 = src.Load(int3(floor(pos.xy - offset - move), 0));

	float phase = dot(line_n, pos.xy) - c1;
	phase = gap > 0 ? phase / gap : step(0, phase);

	float4 col3;
	switch(int(mode_f)) {
	case 0: default: col3 = 0; break;
	case 1: col3 = (col1 + col2) / 2; break;
	case 2: col3 = lerp(col1, col2, saturate(phase)); break;
	case 3: col3 = src.Sample(smp, (pos.xy - offset - phase * move) / size); break;
	}

	return lerp(col1, lerp(col3, col2,
		gap > 0 ? saturate(0.5 + (phase - 1) * gap) : 1),
		gap > 0 ? saturate(0.5 + phase * gap) : phase);
}
