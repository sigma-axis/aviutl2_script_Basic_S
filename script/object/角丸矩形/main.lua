--information:角丸矩形@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\図形
--require:${LEAST_AVIUTL_VERSION}
---$track:幅, min = 0, max = 4000, step = 1, scale = 0.25
local width = 100

---$track:高さ, min = 0, max = 4000, step = 1, scale = 0.25
local height = 100

---$track:ライン幅, min = 0, max = 4000, step = 0.01, scale = 0.25
local line = 4000

---$color:色
local color = 0xffffff

---$color:背景色
local color_back = 0xffffff

---$track:背景透明度, min = 0, max = 100, step = 0.01
local alpha_back = 100

---$track:角半径, min = 0, max = 2000, step = 0.01, scale = 0.25
local radius = 40

---$select:丸角形状
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

--group:配置,false
---$track:水平揃え, min = -100, max = 100, step = 0.001
local align_x = 0

---$track:垂直揃え, min = -100, max = 100, step = 0.001
local align_y = 0

--group:丸角設定,false
---$checksection:半径均一
local uniform = true

---$track:右上半径, min = 0, max = 2000, step = 0.01, scale = 0.25
local r_RT = 40

---$track:右下半径, min = 0, max = 2000, step = 0.01, scale = 0.25
local r_RB = 40

---$track:左下半径, min = 0, max = 2000, step = 0.01, scale = 0.25
local r_LB = 40

---$track:丸角縦横比, min = -100, max = 100, step = 0.001
local aspect = 0

---$checksection:丸角縦横比固定
local fixed_aspect = true

--group:その他,false
---$value:PI
local PI = {}

--[[pixelshader@combine:
---$include "combine.hlsl"
]]
local obj, math, tonumber = obj, math, tonumber;
local basic_s = require("Basic_S");

-- take parameters.
aspect = math.min(math.max(aspect / 100, -1), 1);
local radii, shapes = {
	{ basic_s.size_from_aspect(radius, aspect) },
	{ basic_s.size_from_aspect(uniform and radius or r_RT, aspect) },
	{ basic_s.size_from_aspect(uniform and radius or r_RB, aspect) },
	{ basic_s.size_from_aspect(uniform and radius or r_LB, aspect) },
}, { shape, shape, shape, shape };

--#region PI / normalize parameters.

--[==[
	PI = {
		width:			number?,
		height:			number?,
		align_x:		number?,
		align_y:		number?,
		line:			number?,
		color:			number?,
		color_back:		number?,
		alpha_back:		number?,
		radii:			table|number|nil,
		fixed_aspect:	boolean|number|nil,
		shapes:			table|string|nil,
	}
]==]
width = tonumber(PI.width) or width;
height = tonumber(PI.height) or height;
align_x = tonumber(PI.align_x) or align_x;
align_y = tonumber(PI.align_y) or align_y;
line = tonumber(PI.line) or line;
color = tonumber(PI.color) or color;
color_back = tonumber(PI.color_back) or color_back;
alpha_back = tonumber(PI.alpha_back) or alpha_back;
radii = basic_s.PI.corner_radii(PI.radii, radii);
fixed_aspect = basic_s.PI.as_bool(PI.fixed_aspect, fixed_aspect);
shapes = basic_s.PI.corner_shape(PI.shapes, shapes);

-- normalize parameters.
width = math.max(math.floor(0.5 + width), 0);
height = math.max(math.floor(0.5 + height), 0);
align_x = math.min(math.max(align_x / 100, -1), 1);
align_y = math.min(math.max(align_y / 100, -1), 1);
line = math.max(line, 0);
color = math.floor(0.5 + color) % 2 ^ 24;
color_back = math.floor(0.5 + color_back) % 2 ^ 24;
alpha_back = math.min(math.max(1 - alpha_back / 100, 0), 1);

--#endregion PI / normalize parameters.

-- pass to core.
basic_s.object.round_rect(width, height, line,
	color, color_back, alpha_back,
	radii, shapes, fixed_aspect);

-- alignment.
obj.cx, obj.cy = -width * align_x / 2, -height * align_y / 2;
