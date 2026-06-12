--information:色調補正@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\色調整
--filter
--require:${LEAST_AVIUTL_VERSION}
---$track:明るさ, min = 0, max = 200, step = 0.01
local add_light = 100

---$track:コントラスト, min = 0, max = 200, step = 0.01
local contrast = 100

---$track:色相, min = -1440, max = 1440, step = 0.01, scale = 0.25
local angle = 0

---$track:輝度, min = 0, max = 200, step = 0.01
local mul_light = 100

---$checksection:輝度反転
local rev_light = false

---$track:彩度, min = 0, max = 200, step = 0.01
local mul_sat = 100
---$checksection:飽和する
local saturate = false

---$select:色空間
---XYZ(sRGB) = 0
---CIELAB = 1
---OKLCH = 2
---YUV(BT.601) = 3
---YUV(BT.709) = 4
---YUV(BT.2020) = 5
---HSV(円柱) = 6
---HSV(円錐) = 7
---HSL(円柱) = 8
---HSL(双円錐) = 9
local space = 6

--group:その他,false
---$value:PI
local PI = {}

--[[pixelshader@by_xyz:
---$include "by_xyz.hlsl"
]]
--[[pixelshader@by_cielab:
---$include "by_cielab.hlsl"
]]
--[[pixelshader@by_oklab:
---$include "by_oklab.hlsl"
]]
--[[pixelshader@by_yuv:
---$include "by_yuv.hlsl"
]]
--[[pixelshader@by_hsvl:
---$include "by_hsvl.hlsl"
]]
local obj, math, tonumber, type, unpack = obj, math, tonumber, type, unpack;
local basic_s = require("Basic_S");

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		add_light:	number?,
		contrast:	number?,
		angle:		number?,
		mul_light:	number?,
		rev_light:	boolean|number|nil,
		mul_sat:	number?,
		saturate:	boolean|number|nil,
		space:		string?,
	}
]==]
add_light = tonumber(PI.add_light) or add_light;
contrast = tonumber(PI.contrast) or contrast;
angle = tonumber(PI.angle) or angle;
mul_light = tonumber(PI.mul_light) or mul_light;
rev_light = basic_s.PI.as_bool(PI.rev_light, rev_light);
mul_sat = tonumber(PI.mul_sat) or mul_sat;
saturate = basic_s.PI.as_bool(PI.saturate, saturate);
if type(PI.space) == "string" then
	space = ({
		["XYZ(sRGB)"] = 0, ["CIELAB"] = 1, ["OKLCH"] = 2,
		["YUV(BT.601)"] = 3, ["YUV(BT.709)"] = 4, ["YUV(BT.2020)"] = 5,
		["HSV(円柱)"] = 6, ["HSV(円錐)"] = 7, ["HSL(円柱)"] = 8, ["HSL(双円錐)"] = 9,
	})[PI.space] or space;
end

-- normalize parameters.
add_light = add_light / 100 - 1;
contrast = math.max(contrast / 100, 0);
angle = angle % 360;
mul_light = math.max(mul_light / 100, 0);
mul_sat = math.max(mul_sat / 100, 0);
space = math.min(math.max(math.floor(0.5 + space), 0), 9);

--#endregion PI / normalize parameters.

-- further calculations.
if rev_light then add_light, mul_light = add_light + 1, -mul_light end
add_light, mul_light, mul_sat =
	(add_light - 0.5) * contrast + 0.5,
	mul_light * contrast, mul_sat * contrast; -- do not cap to x2.0.

-- early return for trivial cases.
if add_light == 0 and angle == 0 and mul_light == 1 and mul_sat == 1
	and not saturate then return end

if space < 6 then
	local mat_conv = space == 0 and {{
	-- (scaled (YZX minus white) <- sRGB, sRGB <- scaled (YZX minus white))-pair.
	-- minus white is to move the white point onto the line Z = X = 0.
	-- scaling is to fit ZX within the box [-0.5, +0.5] ^ 2.
		0.2126, 0.7152, 0.0722;
		-0.12170414034502, -0.37829585965498, 0.5;
		0.32638930271361, -0.5, 0.17361069728639;
	}, {
		1, -0.86948282117431,   2.0882435025828;
		1,  0.072396115773113, -0.62437430170414;
		1,  1.8431349831126,    0.035899334206509;
	}} or space == 1 and {{ -- CIELAB.
		0,  1.16, 0;
		5, -5,    0;
		0,  2,   -2;
	}, {
		1 / 1.16, 0.2, 0;
		1 / 1.16, 0,   0;
		1 / 1.16, 0,  -0.5;
	}} or space == 2 and {{ -- OKLAB.
		0.2104542553,  0.7936177850, -0.0040720468;
		1.9779984951, -2.4285922050,  0.4505937099;
		0.0259040371,  0.7827717662, -0.8086757660;
	}, {
		0.99999999845052, 0.39633779217377, 0.21580375806076;
		1.0000000088818, -0.10556134232366, -0.063854174771706;
		1.0000000546724, -0.089484182094966, -1.2914855378641;
	}} or space == 3 and {{ -- BT.601.
	-- (YUV <- RGB, RGB <- YUV)-pairs.
		0.299, 0.587, 0.114;
		-0.16873589164786, -0.33126410835214, 0.5;
		0.5, -0.41868758915835, -0.081312410841655;
	}, {
		1, 0, 1.402;
		1, -0.34413628620102, -0.71413628620102;
		1, 1.772, 0;
	}} or space == 4 and {{ -- BT.709.
		0.2126, 0.7152, 0.0722;
		-0.11457210605734, -0.38542789394266, 0.5;
		0.5, -0.45415290830582, -0.045847091694183;
	}, {
		1, 0, 1.5748;
		1, -0.18732427293065, -0.46812427293065;
		1, 1.8556, 0;
	}} or {{ -- BT.2020. (same as BT.2100.)
		0.2627, 0.678, 0.0593;
		-0.13963006271925, -0.36036993728075, 0.5;
		0.5, -0.45978570459786, -0.040214295402143;
	}, {
		1, 0, 1.4746;
		1, -0.16455312684366, -0.57135312684366;
		1, 1.8814, 0;
	}};

	-- prepare matrices.
	local c, s = math.cos(math.pi / 180 * angle), math.sin(math.pi / 180 * angle);
	local matrices = {
		mat_conv[2], {
			-- core part of this effect.
				mul_light, 0, 0;
				0, mul_sat * c, -mul_sat * s;
				0, mul_sat * s,  mul_sat * c;
		},
		mat_conv[1]
	};

	-- make product.
	local M = matrices[1];
	for n = 2, 3 do
		local T = matrices[n];
		for I = 0, 6, 3 do
			M[I + 1], M[I + 2], M[I + 3] =
				M[I + 1] * T[1] + M[I + 2] * T[4] + M[I + 3] * T[7],
				M[I + 1] * T[2] + M[I + 2] * T[5] + M[I + 3] * T[8],
				M[I + 1] * T[3] + M[I + 2] * T[6] + M[I + 3] * T[9];
		end
	end

	-- apply shader.
	obj.pixelshader(
		space == 0 and "by_xyz" or
		space == 1 and "by_cielab" or
		space == 2 and "by_oklab" or
		"by_yuv",
		"object", "object", {
			M[1], M[4], M[7], 0;
			M[2], M[5], M[8], 0;
			M[3], M[6], M[9];
			add_light;
			saturate and 1 or 0;
		});
else
	-- apply shader.
	obj.pixelshader("by_hsvl", "object", "object", {
		1, mul_sat, mul_light, 0;
		angle / 360, 0, add_light;
		space - 6;
		saturate and 1 or 0;
	});
end
