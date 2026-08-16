--information:中抜きクリッピング@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:オブジェクトの端ではなく中間部分で領域拡張やクリッピングします．
--label:Basic_S\クリッピング
--require:${LEAST_AVIUTL_VERSION}
---$nolang: name
---$track:X, min = -4000, max = 4000, step = 0.1, scale = 0.25
local X = 0

---$nolang: name
---$track:Y, min = -4000, max = 4000, step = 0.1, scale = 0.25
local Y = 0

--trackgroup@X,Y:pos
---$tips:「X」基準で「水平揃え」で指定した範囲をクリッピングや領域拡張します．
---$track:幅, min = -4000, max = 4000, step = 1, scale = 0.25
local width = 0

---$track:余白幅, min = -4000, max = 4000, step = 1, scale = 0.25
local gap_x = 0

---$tips:「Y」基準で「垂直揃え」で指定した範囲をクリッピングや領域拡張します．
---$track:高さ, min = -4000, max = 4000, step = 1, scale = 0.25
local height = 0

---$track:余白高さ, min = -4000, max = 4000, step = 1, scale = 0.25
local gap_y = 0

---$checksection:中心の位置を変更
local move_center = false

--group:整列,false
---$tips:-100: 右揃え / 0: 中央揃え / +100: 左揃え
---$track:水平揃え, min = -100, max = 100, step = 0.001
local align_x = 0

---$tips:-100: 下揃え / 0: 中央揃え / +100: 上揃え
---$track:垂直揃え, min = -100, max = 100, step = 0.001
local align_y = 0

---$checksection:回転中心を基準
local center_based = false

--group:余白/重複処理,false
---$select:余白処理
---空白 = 0
---半透明 = 1
---補間 = 2
---引き伸ばし = 3
local mode_padding = 0

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
---     :  width: number?,
---     :  align_x: number?,
---     :  gap_x: number?,
---     :  height: number?,
---     :  align_y: number?,
---     :  gap_y: number?,
---     :  mode_padding: string?,
---     :  mode_overlap: string?,
---     :  move_center: boolean|number|nil,
---     :  center_based: boolean|number|nil,
---     :}
---$value:PI
local PI = {}

local obj, math, tonumber = obj, math, tonumber;
local basic_s = require("Basic_S");

-- set anchors
if not move_center and obj.getoption("gui") then
	local cx, cy = 0, 0;
	if center_based then
		cx, cy = obj.getvalue("center");
		cx, cy = cx + obj.cx, cy + obj.cy;
	end
	obj.setanchor("X,Y", 0, "line", "offset", cx, cy);
end

--#region PI / normalize parameters.

-- take parameters.
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
width = tonumber(PI.width) or width;
align_x = tonumber(PI.align_x) or align_x;
gap_x = tonumber(PI.gap_x) or gap_x;
height = tonumber(PI.height) or height;
align_y = tonumber(PI.align_y) or align_y;
gap_y = tonumber(PI.gap_y) or gap_y;
mode_padding = basic_s.PI.cut_move_interpolate(PI.mode_padding, mode_padding);
mode_overlap = basic_s.PI.cut_move_interpolate(PI.mode_overlap, mode_overlap);
move_center = basic_s.PI.as_bool(PI.move_center, move_center);
center_based = basic_s.PI.as_bool(PI.center_based, center_based);

-- normalize parameters.
if center_based then
	local cx, cy, _ = obj.getvalue("center");
	cx, cy = cx + obj.cx, cy + obj.cy;
	X, Y = X + cx, Y + cy;
end
width = math.floor(0.5 + width);
align_x = math.min(math.max(align_x / 100, -1), 1);
gap_x = math.floor(0.5 + gap_x);
height = math.floor(0.5 + height);
align_y = math.min(math.max(align_y / 100, -1), 1);
gap_y = math.floor(0.5 + gap_y);

--#endregion PI / normalize parameters.

-- further calculations.
local w, h = obj.w, obj.h;
local l, t =
	math.floor(0.5 + X - width * (1 - align_x) / 2 + w / 2),
	math.floor(0.5 + Y - height * (1 - align_y) / 2 + h / 2);

-- apply effect.
if width ~= 0 or gap_x ~= 0 then
	basic_s.effect.cut_move(gap_x - width, 0,
		l - w / 2, 0, 0, 1, width,
		false, mode_padding, mode_overlap);
	if not (obj.w > 0 and obj.h > 0) then return end -- entirely cropped.
end
if height ~= 0 or gap_y ~= 0 then
	basic_s.effect.cut_move(0, gap_y - height,
		0, t - h / 2, -1, 0, height,
		false, mode_padding, mode_overlap);
	if not (obj.w > 0 and obj.h > 0) then return end -- entirely cropped.
end

-- adjust center.
if move_center then
	obj.cx, obj.cy = obj.cx + (gap_x - width) / 2, obj.cy + (gap_y - height) / 2;
else
	obj.cx, obj.cy =
		obj.cx + math.floor(0.5 + (gap_x - width) * (1 - align_x) / 2),
		obj.cy + math.floor(0.5 + (gap_y - height) * (1 - align_y) / 2);
end
