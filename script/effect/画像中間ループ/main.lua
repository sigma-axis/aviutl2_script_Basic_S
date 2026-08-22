--information:画像中間ループ@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:上下左右から指定した距離だけ内側の部分のみに画像ループを適用します．
--label:Basic_S\配置
--require:${LEAST_AVIUTL_VERSION}
---$tips:「幅指定」で単位が変わります．
---$track:幅, min = 0, max = 4000, step = 1, scale = 0.25
local width = 1

---$tips:「高さ指定」で単位が変わります．
---$track:高さ, min = 0, max = 4000, step = 1, scale = 0.25
local height = 1

--group:余白設定,true
---$track:上余白, min = 0, max = 2000, step = 1, scale = 0.25
local margin_u = 0

---$track:下余白, min = 0, max = 2000, step = 1, scale = 0.25
local margin_d = 0

---$track:左余白, min = 0, max = 2000, step = 1, scale = 0.25
local margin_l = 0

---$track:右余白, min = 0, max = 2000, step = 1, scale = 0.25
local margin_r = 0

--group:オフセット,false
---$track:オフセットX, min = -4000, max = 4000, step = 0.01, scale = 0.25
local offset_x = 0

---$track:オフセットY, min = -4000, max = 4000, step = 0.01, scale = 0.25
local offset_y = 0

--trackgroup@offset_x,offset_y:offset
--group:整列,false
---$tips:-100: 右揃え / 0: 中央揃え / +100: 左揃え
---$track:水平揃え, min = -100, max = 100, step = 0.001
local align_x = 0

---$tips:-100: 下揃え / 0: 中央揃え / +100: 上揃え
---$track:垂直揃え, min = -100, max = 100, step = 0.001
local align_y = 0

---$tips:-100: 右揃え / 0: 中央揃え / +100: 左揃え
---$track:ループ水平揃え, min = -100, max = 100, step = 0.001
local pivot_x = 0

---$tips:-100: 下揃え / 0: 中央揃え / +100: 上揃え
---$track:ループ垂直揃え, min = -100, max = 100, step = 0.001
local pivot_y = 0

--group:ループ設定,false
---$select:幅指定
---回数 = 0
---サイズ(近似) = 1
---サイズ(上限) = 2
---サイズ(下限) = 3
---サイズ(境界不連続) = 4
---サイズ(拡縮あり) = 5
---全体サイズ(近似) = 6
---全体サイズ(上限) = 7
---全体サイズ(下限) = 8
---全体サイズ(境界不連続) = 9
---全体サイズ(拡縮あり) = 10
local unit_x = 0

-- --hide@pivot_x:unit_x<4 or (unit_x>4 and unit_x<9) or unit_x>9
---$select:高さ指定
---回数 = 0
---サイズ(近似) = 1
---サイズ(上限) = 2
---サイズ(下限) = 3
---サイズ(境界不連続) = 4
---サイズ(拡縮あり) = 5
---全体サイズ(近似) = 6
---全体サイズ(上限) = 7
---全体サイズ(下限) = 8
---全体サイズ(境界不連続) = 9
---全体サイズ(拡縮あり) = 10
local unit_y = 0

-- --hide@pivot_y:unit_y<4 or (unit_y>4 and unit_y<9) or unit_y>9
---$select:ループX
---ループ = 0
---ミラー = 1
---ミラー(半ピクセル端) = 2
---引き伸ばし = 3
local loop_x = 0

--hide@offset_x:loop_x~=3
---$select:ループY
---ループ = 0
---ミラー = 1
---ミラー(半ピクセル端) = 2
---引き伸ばし = 3
local loop_y = 0

--hide@offset_y:loop_y~=3
--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  width: number?,
---     :  height: number?,
---     :  margin_u: number?,
---     :  margin_d: number?,
---     :  margin_l: number?,
---     :  margin_r: number?,
---     :  offset_x: number?,
---     :  offset_y: number?,
---     :  align_x: number?,
---     :  align_y: number?,
---     :  pivot_x: number?,
---     :  pivot_y: number?,
---     :  unit_x: string?,
---     :  unit_y: string?,
---     :  loop_x: string?,
---     :  loop_y: string?,
---     :}
---$value:PI
local PI = {}

--[[pixelshader@mid_loop:
---$include "mid_loop.hlsl"
]]
local obj, math, tonumber = obj, math, tonumber;
local basic_s = require("Basic_S");

-- set anchors.
if loop_x ~= 3 or loop_y ~= 3 then
	obj.setanchor("offset_x,offset_y", 0, "line");
end

--#region PI / normalize parameters.

-- take parameters.
width = tonumber(PI.width) or width;
height = tonumber(PI.height) or height;
margin_u = tonumber(PI.margin_u) or margin_u;
margin_d = tonumber(PI.margin_d) or margin_d;
margin_l = tonumber(PI.margin_l) or margin_l;
margin_r = tonumber(PI.margin_r) or margin_r;
offset_x = tonumber(PI.offset_x) or offset_x;
offset_y = tonumber(PI.offset_y) or offset_y;
align_x = tonumber(PI.align_x) or align_x;
align_y = tonumber(PI.align_y) or align_y;
pivot_x = tonumber(PI.pivot_x) or pivot_x;
pivot_y = tonumber(PI.pivot_y) or pivot_y;
unit_x = basic_s.PI.inner_loop_size(PI.unit_x, unit_x);
unit_y = basic_s.PI.inner_loop_size(PI.unit_y, unit_y);
loop_x = basic_s.PI.inner_loop_mode(PI.loop_x, loop_x);
loop_y = basic_s.PI.inner_loop_mode(PI.loop_y, loop_y);

-- normalize parameters.
width = math.max(math.floor(0.5 + width), 0);
height = math.max(math.floor(0.5 + height), 0);
margin_u = math.max(math.floor(0.5 + margin_u), 0);
margin_d = math.max(math.floor(0.5 + margin_d), 0);
margin_l = math.max(math.floor(0.5 + margin_l), 0);
margin_r = math.max(math.floor(0.5 + margin_r), 0);
align_x = math.min(math.max(align_x / 100, -1), 1);
align_y = math.min(math.max(align_y / 100, -1), 1);
pivot_x = math.min(math.max(pivot_x / 100, -1), 1);
pivot_y = math.min(math.max(pivot_y / 100, -1), 1);

--#endregion PI / normalize parameters.

-- pass to core.
basic_s.effect.inner_loop(width, height,
	margin_u, margin_d, margin_l, margin_r, offset_x, offset_y,
	align_x, align_y, pivot_x, pivot_y, unit_x, unit_y, loop_x, loop_y);
