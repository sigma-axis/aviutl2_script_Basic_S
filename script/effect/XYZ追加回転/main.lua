--information:XYZ追加回転@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:常に画面を基準とした X, Y, Z 軸の回転をします．
--label:Basic_S\配置
--require:${LEAST_AVIUTL_VERSION}
---$nolang: name
---$track:X, min = -1440, max = 1440, step = 0.01, scale = 0.25
local X = 0

---$nolang: name
---$track:Y, min = -1440, max = 1440, step = 0.01, scale = 0.25
local Y = 0

---$nolang: name
---$track:Z, min = -1440, max = 1440, step = 0.01, scale = 0.25
local Z = 0

--trackgroup@X,Y,Z:rot
---$track:回転量, min = -400, max = 400, step = 0.01, scale = 0.25
local intensity = 100

--group:描画処理,false
---$tips:回転結果を射影して画像化します．
---$checksection:描画する
local draw = false

---$tips:描画するが ON の場合のみ有効．グループ制御下でのカメラ位置に合わせます．
---$checksection:グループ制御
local grouped = false

-- --hide@grouped:draw==0
--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  X, Y, Z: number?,
---     :  intensity: number?,
---     :  draw: boolean|number|nil,
---     :  grouped: boolean|number|nil,
---     :}
---$value:PI
local PI = {}

local math, tonumber = math, tonumber;
local basic_s = require("Basic_S");

--#region PI / normalize parameters.

-- take parameters.
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
