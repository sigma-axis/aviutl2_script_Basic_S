--information:回転中心アンカー指定@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\配置
--require:${LEAST_AVIUTL_VERSION}
---$track:X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local X = 0

---$track:Y, min = -4000, max = 4000, step = 0.01, scale = 0.25
local Y = 0

---$track:Z, min = -4000, max = 4000, step = 0.01, scale = 0.25
local Z = 0

--trackgroup@X,Y,Z:pos
---$checksection:相対指定
local relative = false

--group:その他,false
---$value:PI
local PI = {}

local obj, tonumber = obj, tonumber;
local basic_s = require("Basic_S");

-- set anchors.
if obj.getoption("gui") then
	local cx, cy, cz = 0, 0, 0;
	if relative then
		cx, cy, cz = obj.getvalue("center");
		cx, cy, cz = cx + obj.cx, cy + obj.cy, cz + obj.cz;
	end
	obj.setanchor("X,Y,Z", 0, "xyz", "line", "offset.xyz", cx, cy, cz);
end

--#region PI / normalize parameters

-- take parameters.
--[==[
	PI = {
		X, Y, Z:	number?,
		relative:	boolean|number|nil,
	}
]==]
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
Z = tonumber(PI.Z) or Z;
relative = basic_s.PI.as_bool(PI.relative, relative);

-- normalize parameters.
if relative then
	local cx, cy, cz = obj.getvalue("center");
	cx, cy, cz = cx + obj.cx, cy + obj.cy, cz + obj.cz;
	X, Y, Z = X + cx, Y + cy, Z + cz;
end

--#endregion PI / normalize parameters

-- apply.
basic_s.set_rotation_center(X, Y, Z, true);
