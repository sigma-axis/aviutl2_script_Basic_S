--information:領域サイズ変更@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:正の指定値で領域拡張，負の指定値でクリッピングになる複合フィルタ．
--label:Basic_S\クリッピング
--require:${LEAST_AVIUTL_VERSION}
---$track:上, min = -4000, max = 4000, step = 1, scale = 0.25
local T = 0

---$track:下, min = -4000, max = 4000, step = 1, scale = 0.25
local B = 0

---$track:左, min = -4000, max = 4000, step = 1, scale = 0.25
local L = 0

---$track:右, min = -4000, max = 4000, step = 1, scale = 0.25
local R = 0

---$checksection:中心の位置を変更
local move_center = false

---$checksection:塗りつぶし
local fill_blank = false

--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  L, R, T, B: number?,
---     :  move_center: boolean|number|nil,
---     :  fill_blank: boolean|number|nil,
---     :}
---$value:PI
local PI = {}

local math, tonumber = math, tonumber;
local basic_s = require("Basic_S");

--#region PI / normalize parameters.

-- take parameters.
L = tonumber(PI.L) or L;
R = tonumber(PI.R) or R;
T = tonumber(PI.T) or T;
B = tonumber(PI.B) or B;
move_center = basic_s.PI.as_bool(PI.move_center, move_center);
fill_blank = basic_s.PI.as_bool(PI.fill_blank, fill_blank);

-- normalize parameters.
L = math.floor(0.5 + L);
R = math.ceil(-0.5 + R);
T = math.floor(0.5 + T);
B = math.ceil(-0.5 + B);

--#endregion PI / normalize parameters.

-- perform clipping and expanding.
basic_s.add_canvas_size(L, R, T, B, move_center, fill_blank);
