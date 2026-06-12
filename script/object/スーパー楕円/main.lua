--information:スーパー楕円@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\図形
--require:${LEAST_AVIUTL_VERSION}
---$track:膨らみ, min = -300, max = 300, step = 0.001
local exponent = -60

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

---$check:縦横一致
local symmetric = false

--group:配置,false
---$track:水平揃え, min = -100, max = 100, step = 0.001
local align_x = 0

---$track:垂直揃え, min = -100, max = 100, step = 0.001
local align_y = 0

--group:その他,false
---$value:PI
local PI = {}

--[[pixelshader@shape_L1:
---$include "shape_L1.hlsl"
]]
--[[pixelshader@shape_box:
---$include "shape_box.hlsl"
]]
--[[pixelshader@shape_cross:
---$include "shape_cross.hlsl"
]]
--[[pixelshader@shape_circle:
---$include "shape_circle.hlsl"
]]
--[[pixelshader@shape_gen:
---$include "shape_gen.hlsl"
]]
local obj, math, tonumber = obj, math, tonumber;
local basic_s = require("Basic_S");

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		exponent:	number?,
		width:		number?,
		height:		number?,
		align_x:	number?,
		align_y:	number?,
		line:		number?,
		color:		number?,
		color_back:	number?,
		alpha_back:	number?,
		symmetric:	boolean|number|nil,
	}
]==]
exponent = tonumber(PI.exponent) or exponent;
width = tonumber(PI.width) or width;
height = tonumber(PI.height) or height;
align_x = tonumber(PI.align_x) or align_x;
align_y = tonumber(PI.align_y) or align_y;
line = tonumber(PI.line) or line;
color = tonumber(PI.color) or color;
color_back = tonumber(PI.color_back) or color_back;
alpha_back = tonumber(PI.alpha_back) or alpha_back;
symmetric = basic_s.PI.as_bool(PI.symmetric, symmetric);

-- normalize parameters.
exponent = math.min(math.max(exponent / 100, -3), 3);
width = math.max(math.floor(0.5 + width), 0);
height = math.max(math.floor(0.5 + height), 0);
align_x = math.min(math.max(align_x / 100, -1), 1);
align_y = math.min(math.max(align_y / 100, -1), 1);
line = math.max(line, 0);
color = math.floor(0.5 + color) % 2 ^ 24;
color_back = math.floor(0.5 + color_back) % 2 ^ 24;
alpha_back = math.min(math.max(1 - alpha_back / 100, 0), 1);

--#endregion PI / normalize parameters.

-- further calculations.
if symmetric then height = width end
-- e = (3 + e')/(3 - e'), astroid at e' = -3/5.
-- e = 0 is replaced by some E < log(2)/log((w/2) / 0.5),
-- e = oo can be replaced by some E > -log(2)/log(1-0.5/w);
-- where w is the maximum possible length.
local e = (3 + exponent) / (3 - exponent);

-- pass to core.
basic_s.object.superellipse(width, height, line, color, color_back, alpha_back, e);

-- alignment.
obj.cx, obj.cy = -width * align_x / 2, -height * align_y / 2;
