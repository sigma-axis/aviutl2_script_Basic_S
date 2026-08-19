--information:任意軸追加回転@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:アンカーで指定したラインに沿った軸でオブジェクトを立体回転させます．
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
---     :  angle: number?,
---     :  X, Y, Z: number?,
---     :  draw: boolean|number|nil,
---     :  grouped: boolean|number|nil,
---     :  fix_axis: boolean|number|nil,
---     :}
---$value:PI
local PI = {}

local obj, tonumber = obj, tonumber;
local basic_s = require("Basic_S");

-- set anchors.
local cx, cy, cz = obj.getvalue("center");
cx, cy, cz = obj.cx + cx, obj.cy + cy, obj.cz + cz;
obj.setanchor("X,Y,Z", 0, "xyz", "offset.xyz", cx, cy, cz, "line");
obj.setanchor({ 0, 0, 0; X, Y, Z }, 2, "xyz", "offset.xyz", cx, cy, cz, "line", "color", 0xc0ff80);

--#region PI / normalize parameters.

-- take parameters.
angle = tonumber(PI.angle) or angle;
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
Z = tonumber(PI.Z) or Z;
draw = basic_s.PI.as_bool(PI.draw, draw);
grouped = basic_s.PI.as_bool(PI.grouped, grouped);
local fix_axis = basic_s.PI.as_bool(PI.fix_axis, false);

-- normalize parameters.
angle = 2 * math.pi * ((angle / 360) % 1);

--#endregion PI / normalize parameters.

-- pass to core.
basic_s.effect.rotate_any_axis(angle, X, Y, Z, draw, grouped, not fix_axis);
