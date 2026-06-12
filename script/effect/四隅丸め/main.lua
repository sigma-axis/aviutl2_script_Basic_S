--information:四隅丸め@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\クリッピング
--filter
--require:${LEAST_AVIUTL_VERSION}
---$track:半径, min = 0, max = 2000, step = 0.01, scale = 0.25
local radius = 40

---$select:形状
---円 = 0
---円(凹) = 1
---菱形 = 2
---四角形(凹) = 3
---正8角形 = 4
---正8角形(凹) = 5
---正8角形(凹斜) = 6
---正12角形 = 7
---正12角形(凹) = 8
---正12角形(凹斜) = 9
---スパイク = 10
---スパイク(凹) = 11
local shape = 0

--group:丸角設定,false
---$check:半径均一
local uniform = true

---$track:右上半径, min = 0, max = 2000, step = 0.01, scale = 0.25
local r_RT = 40

---$track:右下半径, min = 0, max = 2000, step = 0.01, scale = 0.25
---scale = 0.25
local r_RB = 40

---$track:左下半径, min = 0, max = 2000, step = 0.01, scale = 0.25
local r_LB = 40

---$track:縦横比, min = -100, max = 100, step = 0.001
local aspect = 0

---$check:縦横比固定
local fixed_aspect = true

--group:その他,false
---$track:ライン幅, min = 0, max = 4000, step = 0.01, scale = 0.25
local line = 0

---$track:内側透明度, min = 0, max = 100, step = 0.01
local alpha_inner = 100

---$value:PI
local PI = {}

--[[pixelshader@carve:
---$include "carve.hlsl"
]]
local math, tonumber = math, tonumber;
local basic_s = require("Basic_S");

-- take parameters.
aspect = math.min(math.max(aspect / 100, -1), 1);
local radii, shapes = {
	{ basic_s.size_from_aspect(radius, aspect) },
	{ basic_s.size_from_aspect(uniform and radius or r_RT, aspect) },
	{ basic_s.size_from_aspect(uniform and radius or r_RB, aspect) },
	{ basic_s.size_from_aspect(uniform and radius or r_LB, aspect) },
}, { shape, shape, shape, shape };

--#region PI / normalize parameters

--[==[
	PI = {
		radii:			table|number|nil,
		fixed_aspect:	boolean|number|nil,
		shapes:			table|string|nil,
		line:			number?,
		alpha_inner:		number?,
	}
]==]
radii = basic_s.PI.corner_radii(PI.radii, radii);
fixed_aspect = basic_s.PI.as_bool(PI.fixed_aspect, fixed_aspect);
shapes = basic_s.PI.corner_shape(PI.shapes, shapes);
line = tonumber(PI.line) or line;
alpha_inner = tonumber(PI.alpha_inner) or alpha_inner;

-- normalize parameters.
line = math.max(line, 0);
alpha_inner = math.min(math.max(1 - alpha_inner / 100, 0), 1);

--#endregion PI / normalize parameters

-- pass to core.
basic_s.effect.round_corners(radii, shapes, line, alpha_inner, fixed_aspect);
