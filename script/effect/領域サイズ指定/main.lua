--information:領域サイズ指定@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\クリッピング
--require:${LEAST_AVIUTL_VERSION}
---$track:X, min = -4000, max = 4000, step = 0.1, scale = 0.25
local X = 0

---$track:Y, min = -4000, max = 4000, step = 0.1, scale = 0.25
local Y = 0

--trackgroup@X,Y:pos
---$track:幅, min = 1, max = 4000, step = 1, scale = 0.25
local width = 256

---$track:高さ, min = 1, max = 4000, step = 1, scale = 0.25
local height = 256

---$checksection:中心の位置を変更
local move_center = false

---$checksection:塗りつぶし
local fill_blank = false

--group:整列,false
---$track:水平揃え, min = -100, max = 100, step = 0.001
local align_x = 0

---$track:垂直揃え, min = -100, max = 100, step = 0.001
local align_y = 0

--group:縦横無効化,false
---$checksection:幅指定有効
local x_enabled = true

---$checksection:高さ指定有効
local y_enabled = true

--group:その他,false
---$checksection:反転マスク
local inverted_mask = false

---$value:PI
local PI = {}

--[[pixelshader@inv_mask:
---$include "inv_mask.hlsl"
]]
local obj, math, tonumber = obj, math, tonumber;
local basic_s = require("Basic_S");

-- set anchors.
if not move_center then obj.setanchor("X,Y", 0, "line") end

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		X:				number?,
		Y:				number?,
		width:			number?,
		align_x:		number?,
		x_enabled:		boolean|number|nil,
		height:			number?,
		align_y:		number?,
		y_enabled:		boolean|number|nil,
		move_center:	boolean|number|nil,
		fill_blank:		boolean|number|nil,
		inverted_mask:	boolean|number|nil,
	}
]==]
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
width = tonumber(PI.width) or width;
align_x = tonumber(PI.align_x) or align_x;
x_enabled = basic_s.PI.as_bool(PI.x_enabled, x_enabled);
height = tonumber(PI.height) or height;
align_y = tonumber(PI.align_y) or align_y;
y_enabled = basic_s.PI.as_bool(PI.y_enabled, y_enabled);
move_center = basic_s.PI.as_bool(PI.move_center, move_center);
fill_blank = basic_s.PI.as_bool(PI.fill_blank, fill_blank);
inverted_mask = basic_s.PI.as_bool(PI.inverted_mask, inverted_mask);

-- normalize parameters.
width = math.max(math.floor(0.5 + width), 1);
height = math.max(math.floor(0.5 + height), 1);
align_x = math.min(math.max(align_x / 100, -1), 1);
align_y = math.min(math.max(align_y / 100, -1), 1);

--#endregion PI / normalize parameters.

-- further calculations.
local L, T =
	math.floor(0.5 + X - width * (1 - align_x) / 2 + obj.w / 2),
	math.floor(0.5 + Y - height * (1 - align_y) / 2 + obj.h / 2);
local R, B = L + width, T + height;
L, R, T, B = -L, R - obj.w, -T, B - obj.h;
if not x_enabled then L, R = 0, 0 end
if not y_enabled then T, B = 0, 0 end

-- apply effect.
if inverted_mask then
	obj.pixelshader("inv_mask@領域サイズ指定@Basic_S", "object", nil, {
		-L, -T, obj.w + R, obj.h + B
	}, "mask");

	-- adjust the center.
	if move_center then
		obj.cx, obj.cy = obj.cx + (R - L) / 2, obj.cy + (B - T) / 2;
	end
else basic_s.add_canvas_size(L, R, T, B, move_center, fill_blank) end
