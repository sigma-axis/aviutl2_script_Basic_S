--information:XYZ追加回転@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\配置
--require:${LEAST_AVIUTL_VERSION}
---$track:X, min = -1440, max = 1440, step = 0.01, scale = 0.25
local X = 0

---$track:Y, min = -1440, max = 1440, step = 0.01, scale = 0.25
local Y = 0

---$track:Z, min = -1440, max = 1440, step = 0.01, scale = 0.25
local Z = 0

--trackgroup@X,Y,Z:rot
---$track:回転量, min = -400, max = 400, step = 0.01, scale = 0.25
local intensity = 100

--group:描画処理,false
---$checksection:描画する
local draw = false

---$checksection:グループ制御
local grouped = false

--group:その他,false
---$value:PI
local PI = {}

local math, tonumber = math, tonumber;
local basic_s = require("Basic_S");

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		X:			number?,
		Y:			number?,
		Z:			number?,
		intensity:	number?,
		draw:		boolean|number|nil,
		grouped:	boolean|number|nil,
	}
]==]
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
Z = tonumber(PI.Z) or Z;
intensity = tonumber(PI.intensity) or intensity;
draw = basic_s.PI.as_bool(PI.draw, draw);
grouped = basic_s.PI.as_bool(PI.grouped, grouped);

-- normalize parameters.
X = 2 * math.pi * ((X / 360) % 1);
Y = 2 * math.pi * ((Y / 360) % 1);
Z = 2 * math.pi * ((Z / 360) % 1);
intensity = intensity / 100;

--#endregion PI / normalize parameters.

if (intensity == 0 or (X == 0 and Y == 0 and Z == 0)) and not draw then return end

-- determine the quaternion that represents this rotation.
local qr, qi, qj, qk = basic_s.quat.euler_to_quat(X, Y, Z);
local angle = 2 * math.atan2((qi ^ 2 + qj ^ 2 + qk ^ 2) ^ 0.5, qr);
angle = angle * intensity;

if angle ~= 0 or draw then
	-- pass to core.
	basic_s.effect.rotate_any_axis(angle, qi, qj, qk, draw, grouped, false);
end
