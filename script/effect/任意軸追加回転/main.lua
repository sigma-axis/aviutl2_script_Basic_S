--information:任意軸追加回転@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\配置
--require:${LEAST_AVIUTL_VERSION}
---$track:角度, min = -1440, max = 1440, step = 0.01, scale = 0.25
local angle = 0

---$track:回転軸X, min = -1024, max = 1024, step = 0.001, scale = 0.25
local X = 0

---$track:回転軸Y, min = -1024, max = 1024, step = 0.001, scale = 0.25
local Y = 0

---$track:回転軸Z, min = -1024, max = 1024, step = 0.001, scale = 0.25
local Z = 128

--trackgroup@X,Y,Z:axis
--group:描画処理,false
---$check:描画する
local draw = false

---$check:グループ制御
local grouped = false

--group:その他,false
---$value:PI
local PI = {}

local obj, tonumber = obj, tonumber;
local basic_s = require("Basic_S");

-- set anchors.
obj.setanchor("X,Y,Z", 0, "xyz");
local cx, cy, cz = obj.getvalue("center");
cx, cy, cz = obj.cx + cx, obj.cy + cy, obj.cz + cz;
obj.setanchor({
	cx, cy, cz;
	cx + X, cy + Y, cz + Z;
}, 2, "xyz", "line", "color", 0xc0ff80);
obj.setanchor({
	cx + X, cy + Y, cz + Z;
	X, Y, Z;
}, 2, "xyz", "line");

--#region PI

-- take parameters.
--[==[
	PI = {
		angle:		number?,
		X:			number?,
		Y:			number?,
		Z:			number?,
		draw:		boolean|number|nil,
		grouped:	boolean|number|nil,
		fix_axis:	boolean|number|nil,
	}
]==]
angle = tonumber(PI.angle) or angle;
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
Z = tonumber(PI.Z) or Z;
draw = basic_s.PI.as_bool(PI.draw, draw);
grouped = basic_s.PI.as_bool(PI.grouped, grouped);
local fix_axis = basic_s.PI.as_bool(PI.fix_axis, false);

--#endregion PI

-- pass to core.
basic_s.effect.rotate_any_axis(angle, X, Y, Z, draw, grouped, not fix_axis);
