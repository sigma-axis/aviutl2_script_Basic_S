--information:色チャンネル入れ替え@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\色調整
--filter
--require:${LEAST_AVIUTL_VERSION}
---$select:赤適用元
---0固定 = 0
---赤 = 1
---緑 = 2
---青 = 3
---アルファ = 4
---赤反転 = 5
---緑反転 = 6
---青反転 = 7
---アルファ反転 = 8
---1固定 = 9
local comp_R = 1

---$select:緑適用元
---0固定 = 0
---赤 = 1
---緑 = 2
---青 = 3
---アルファ = 4
---赤反転 = 5
---緑反転 = 6
---青反転 = 7
---アルファ反転 = 8
---1固定 = 9
local comp_G = 2

---$select:青適用元
---0固定 = 0
---赤 = 1
---緑 = 2
---青 = 3
---アルファ = 4
---赤反転 = 5
---緑反転 = 6
---青反転 = 7
---アルファ反転 = 8
---1固定 = 9
local comp_B = 3

---$select:アルファ適用元
---0固定 = 0
---赤 = 1
---緑 = 2
---青 = 3
---アルファ = 4
---赤反転 = 5
---緑反転 = 6
---青反転 = 7
---アルファ反転 = 8
---1固定 = 9
local comp_A = 4

--group:その他,false
---$checksection:乗算済みα
local premult = true,false

---$value:PI
local PI = {}

--[[pixelshader@premult:
---$include "premult.hlsl"
]]
--[[pixelshader@nonmult:
---$include "nonmult.hlsl"
]]
local obj, math, tonumber, type = obj, math, tonumber, type;
local basic_s = require("Basic_S");

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		comp_R:		string?,
		comp_G:		string?,
		comp_B:		string?,
		comp_A:		string?,
		premult:	boolean|number|nil,
	}
]==]
local name2num = {
	["0固定"] = 0,
	["赤"] = 1, ["緑"] = 2, ["青"] = 3, ["アルファ"] = 4,
	["赤反転"] = 5, ["緑反転"] = 6, ["青反転"] = 7, ["アルファ反転"] = 8,
	["1固定"] = 9,
};
if type(PI.comp_R) == "string" then
	comp_R = name2num[PI.comp_R] or comp_R;
end
if type(PI.comp_G) == "string" then
	comp_G = name2num[PI.comp_G] or comp_G;
end
if type(PI.comp_B) == "string" then
	comp_B = name2num[PI.comp_B] or comp_B;
end
if type(PI.comp_A) == "string" then
	comp_A = name2num[PI.comp_A] or comp_A;
end
premult = basic_s.PI.as_bool(PI.premult, premult);
if comp_R == 1 and comp_G == 2 and comp_B == 3 and comp_A ==4 then return end

-- normalize parameters.
comp_R = math.min(math.max(comp_R, 0), 9);
comp_G = math.min(math.max(comp_G, 0), 9);
comp_B = math.min(math.max(comp_B, 0), 9);
comp_A = math.min(math.max(comp_A, 0), 9);

--#endregion PI / normalize parameters.

-- further calculations.
local params = {
	0, 0, 0, 0; -- constant vector.
	0, 0, 0, 0, -- column-major matrix.
	0, 0, 0, 0,
	0, 0, 0, 0,
	0, 0, 0, 0;
};
for i, comp in ipairs{ comp_R, comp_G, comp_B, comp_A } do
	local inv = comp >= 5;
	if inv then
		params[i] = 1;
		comp = (comp + 1) % 5;
	end
	if comp > 0 then
		params[4 * comp + i] = inv and -1 or 1;
	end
end

-- apply shader.
obj.pixelshader(premult and "premult" or "nonmult", "object", "object", params);
