--information:四角縁取り@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\装飾
--require:${LEAST_AVIUTL_VERSION}
---$track:サイズ, min = -500, max = 500, step = 0.01
local size = 5

---$track:縦横比, min = -100, max = 100, step = 0.001
local aspect = 0

---$track:ぼかし, min = 0, max = 100, step = 0.01
local blur = 0

---$color:縁色
local color = 0xffffff

---$track:透明度, min = 0, max = 100, step = 0.01
local alpha = 0

---$track:前景透明度, min = 0, max = 100, step = 0.01
local alpha_front = 0

--group:パターン画像,false
---$file:パターン画像
local file_image = ""

---$track:画像X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local X = 0

---$track:画像Y, min = -4000, max = 4000, step = 0.01, scale = 0.25
local Y = 0

--trackgroup@X,Y:pos
---$track:拡大率, min = 0.001, max = 5000, step = 0.001, scale = 0.16
local zoom = 100

---$track:回転, min = -1440, max = 1440, step = 0.01, scale = 0.25
local rotate = 0

---$checksection:補間なし
local no_smooth = true

--group:その他,false
---$value:PI
local PI = {}
--[[pixelshader@promote:
---$include "promote.hlsl"
]]
--[[computeshader@convol:
---$include "convol.hlsl"
]]
--[[pixelshader@transpose:
---$include "transpose.hlsl"
]]
--[[pixelshader@halven:
---$include "halven.hlsl"
]]
--[[pixelshader@recolor:
---$include "recolor.hlsl"
]]
--[[pixelshader@blend:
---$include "blend.hlsl"
]]
--[[pixelshader@combine:
---$include "combine.hlsl"
]]
local obj, math, tonumber, type = obj, math, tonumber, type;
local basic_s = require("Basic_S");

if #file_image >= 4 then
	obj.setanchor("X,Y", 0, "line");
end

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		size:			number?,
		aspect:			number?,
		blur:			number?,
		alpha:			number?,
		color:			number?,
		file_image:		string?,
		X:				number?,
		Y:				number?,
		zoom:			number?,
		rotate:			number?,
		no_smooth:		boolean|number|nil,
		alpha_front:	number?,
	}
]==]
size = tonumber(PI.size) or size;
aspect = tonumber(PI.aspect) or aspect;
blur = tonumber(PI.blur) or blur;
alpha = tonumber(PI.alpha) or alpha;
color = tonumber(PI.color) or color;
file_image = type(PI.file_image) == "string" and PI.file_image or file_image;
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
zoom = tonumber(PI.zoom) or zoom;
rotate = tonumber(PI.rotate) or rotate;
no_smooth = basic_s.PI.as_bool(PI.no_smooth, no_smooth);
alpha_front = tonumber(PI.alpha_front) or alpha_front;

-- normalize parameters.
size = math.min(math.max(size, -500), 500);
aspect = math.min(math.max(aspect / 100, -1), 1);
blur = math.min(math.max(blur / 100, 0), 1);
alpha = math.min(math.max(1 - alpha / 100, 0), 1);
color = math.floor(0.5 + color) % 2 ^ 24;
zoom = math.max(zoom / 100, 0.00001);
rotate = 2 * math.pi * ((rotate / 360) % 1);
alpha_front = math.min(math.max(1 - alpha_front / 100, 0), 1);

--#endregion PI / normalize parameters.

-- pass to core.
local size_x, size_y = basic_s.size_from_aspect(size, aspect);
basic_s.effect.rect_border(size_x, size_y, blur,
	color, file_image, X, Y, zoom, rotate, no_smooth, alpha, alpha_front);
