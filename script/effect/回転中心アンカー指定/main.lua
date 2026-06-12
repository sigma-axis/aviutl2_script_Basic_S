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
--group:その他,false
---$value:PI
local PI = {}

local obj, tonumber = obj, tonumber;
local basic_s = require("Basic_S");

-- set anchors.
obj.setanchor("X,Y,Z", 0, "xyz", "line");

--#region PI

-- take parameters.
--[==[
	PI = {
		X, Y, Z:	number?,
	}
]==]
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
Z = tonumber(PI.Z) or Z;

--#endregion PI

-- apply.
basic_s.set_rotation_center(X, Y, Z, true);
