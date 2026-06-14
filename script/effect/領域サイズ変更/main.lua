--information:領域サイズ変更@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
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
local move_center = false,false

---$checksection:塗りつぶし
local fill_blank = false,false

--group:その他,false
---$value:PI
local PI = {}

local math, tonumber = math, tonumber;
local basic_s = require("Basic_S");

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		T:				number?,
		B:				number?,
		L:				number?,
		R:				number?,
		move_center:	boolean|number|nil,
		fill_blank:		boolean|number|nil,
	}
]==]
T = tonumber(PI.T) or T;
B = tonumber(PI.B) or B;
L = tonumber(PI.L) or L;
R = tonumber(PI.R) or R;
move_center = basic_s.PI.as_bool(PI.move_center, move_center);
fill_blank = basic_s.PI.as_bool(PI.fill_blank, fill_blank);

-- normalize parameters.
T = math.floor(0.5 + T);
B = math.floor(0.5 + B);
L = math.floor(0.5 + L);
R = math.floor(0.5 + R);

--#endregion PI / normalize parameters.

-- perform clipping and expanding.
basic_s.add_canvas_size(L, R, T, B, move_center, fill_blank);
