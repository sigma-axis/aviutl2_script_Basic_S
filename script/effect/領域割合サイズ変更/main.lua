--information:領域割合サイズ変更@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\クリッピング
--require:${LEAST_AVIUTL_VERSION}
---$track:上%, min = -100, max = 100, step = 0.001
local T = 0

---$track:下%, min = -100, max = 100, step = 0.001
local B = 0

---$track:左%, min = -100, max = 100, step = 0.001
local L = 0

---$track:右%, min = -100, max = 100, step = 0.001
local R = 0

---$check:中心の位置を変更
local move_center = false

---$check:塗りつぶし
local fill_blank = false

--group:その他,false
---$value:PI
local PI = {}

local obj, math, tonumber = obj, math, tonumber;
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
T = math.min(math.max(T / 100, -1), 1);
B = math.min(math.max(B / 100, -1), 1);
L = math.min(math.max(L / 100, -1), 1);
R = math.min(math.max(R / 100, -1), 1);

--#endregion PI / normalize parameters.

-- further calculations.
L = math.floor(0.5 + obj.w * L);
R = math.ceil(-0.5 + obj.w * R);
T = math.floor(0.5 + obj.h * T);
B = math.ceil(-0.5 + obj.h * B);

-- apply effect.
basic_s.add_canvas_size(L, R, T, B, move_center, fill_blank);
