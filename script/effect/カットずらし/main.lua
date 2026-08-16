--information:カットずらし@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:アンカーで指定したラインでオブジェクトを切り取って，ずらして配置します．
--label:Basic_S\クリッピング
--require:${LEAST_AVIUTL_VERSION}
---$track:ずれX, min = -4000, max = 4000, step = 1, scale = 0.25
local X = 40

---$track:ずれY, min = -4000, max = 4000, step = 1, scale = 0.25
local Y = 0

--trackgroup@X,Y:pos
--group:切り取り線,true
---$track:切り取り線X1, min = -4000, max = 4000, step = 0.01, scale = 0.25
local crack_X1 = 0

---$track:切り取り線Y1, min = -4000, max = 4000, step = 0.01, scale = 0.25
local crack_Y1 = -100

--trackgroup@crack_X1,crack_Y1:crack1
---$track:切り取り線X2, min = -4000, max = 4000, step = 0.01, scale = 0.25
local crack_X2 = 0

---$track:切り取り線Y2, min = -4000, max = 4000, step = 0.01, scale = 0.25
local crack_Y2 = 100

--trackgroup@crack_X2,crack_Y2:crack2
--group
---$tips:余白/重複処理の範囲を調整します．
---$track:切り取り幅, min = -4000, max = 4000, step = 0.01, scale = 0.25
local crop = 0

---$checksection:中心の位置を変更
local move_center= false

---$checksection:回転中心を基準
local center_based = false

--group:余白/重複処理,false
---$tips:ずらしてできた余白部分の埋め方を指定します．
---$select:余白処理
---空白 = 0
---半透明 = 1
---補間 = 2
---引き伸ばし = 3
local mode_padding = 0

---$tips:ずらしてできた重複部分の埋め方を指定します．
---$select:重複処理
---空白 = 0
---半透明 = 1
---補間 = 2
---引き伸ばし = 3
local mode_overlap = 0

--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  X, Y: number?,
---     :  crack_X1: number?,
---     :  crack_Y1: number?,
---     :  crack_X2: number?,
---     :  crack_Y2: number?,
---     :  crop: number?,
---     :  mode_padding: string?,
---     :  mode_overlap: string?,
---     :  move_center: boolean|number|nil,
---     :  center_based: boolean|number|nil,
---     :
---     :  crack: table?,
---     :}
---$value:PI
local PI = {}

--group:互換対応(将来削除予定),false
---$value:切り取り線
local crack = {}

--[[pixelshader@place:
---$include "place.hlsl"
]]
local obj, math, tonumber, type = obj, math, tonumber, type;
local basic_s = require("Basic_S");

-- set anchors.
if not move_center and obj.getoption("gui") then
	local cx, cy = 0, 0;
	if center_based then
		cx, cy = obj.getvalue("center");
		cx, cy = cx + obj.cx, cy + obj.cy;
	end
	obj.setanchor("X,Y", 0, "line", "offset", cx + (crack_X1 + crack_X2) / 2, cy + (crack_Y1 + crack_Y2) / 2);
	obj.setanchor({ 0, 0, X, Y }, 2, "line", "offset", cx + (crack_X1 + crack_X2) / 2, cy + (crack_Y1 + crack_Y2) / 2);
	obj.setanchor("crack_X1,crack_Y1", 0, "line", "rgba", 0x208020c0, "offset", cx, cy);
	obj.setanchor("crack_X2,crack_Y2", 0, "line", "rgba", 0xf05050c0, "offset", cx, cy);
	obj.setanchor({ crack_X1, crack_Y1, crack_X2, crack_Y2 }, 2, "line", "color", 0x4040ff, "offset", cx, cy);
end

--#region PI / normalize parameters.

-- take parameters.
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
if type(PI.crack) == "table" then
	local x1, y1, x2, y2 =
		tonumber(PI.crack[1]), tonumber(PI.crack[2]),
		tonumber(PI.crack[3]), tonumber(PI.crack[4]);
	if x1 and y1 and x2 and y2 then
		crack = { x1, y1, x2, y2 };
	end
end
crack_X1 = tonumber(crack[1]) or tonumber(PI.crack_X1) or crack_X1;
crack_Y1 = tonumber(crack[2]) or tonumber(PI.crack_Y1) or crack_Y1;
crack_X2 = tonumber(crack[3]) or tonumber(PI.crack_X2) or crack_X2;
crack_Y2 = tonumber(crack[4]) or tonumber(PI.crack_Y2) or crack_Y2;
crop = tonumber(PI.crop) or crop;
mode_padding = basic_s.PI.cut_move_interpolate(PI.mode_padding, mode_padding);
mode_overlap = basic_s.PI.cut_move_interpolate(PI.mode_overlap, mode_overlap);
move_center = basic_s.PI.as_bool(PI.move_center, move_center);
center_based = basic_s.PI.as_bool(PI.center_based, center_based);

-- normalize parameters.
if center_based then
	local cx, cy, _ = obj.getvalue("center");
	cx, cy = cx + obj.cx, cy + obj.cy;
	crack_X1, crack_Y1 = crack_X1 + cx, crack_Y1 + cy;
	crack_X2, crack_Y2 = crack_X2 + cx, crack_Y2 + cy;
end
X = math.floor(0.5 + X);
Y = math.floor(0.5 + Y);
local dx, dy = basic_s.quat.normalize(crack_X2 - crack_X1, crack_Y2 - crack_Y1);
if dx == 0 and dy == 0 then dx, dy = 0, 1 end

--#endregion PI / normalize parameters.

-- pass to core.
basic_s.effect.cut_move(X, Y,
	crack_X1, crack_Y1, dx, dy,
	crop, move_center, mode_padding, mode_overlap);
