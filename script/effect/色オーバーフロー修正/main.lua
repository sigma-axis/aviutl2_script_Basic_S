--information:色オーバーフロー修正@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:色成分を 0% ～ 100% の範囲内に (必要なら) 矯正します．
--label:Basic_S\色調整
--filter
--require:${LEAST_AVIUTL_VERSION}
---$select:色成分
---足切り頭打ち = 0
---色差縮小(標準) = 1
---色差縮小(改) = 2
local c_mode = 0

---$select:アルファ値
---頭打ち = 0
---超過分縮小 = 1
---最大保証+頭打ち = 2
---最大保証+超過分縮小 = 3
local a_mode = 2

--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  c_mode: string?,
---     :  a_mode: string?,
---     :}
---$value:PI
local PI = {}

--[[pixelshader@clip_color:
---$include "clip_color.hlsl"
]]
local obj, math, type = obj, math, type;

--#region PI / normalize parameters.

-- take parameters.
if type(PI.c_mode) == "string" then
	local name2num = { ["足切り頭打ち"] = 0, ["色差縮小(標準)"] = 1, ["色差縮小(改)"] = 2, };
	c_mode = name2num[PI.c_mode] or c_mode;
end
if type(PI.a_mode) == "string" then
	local name2num = { ["頭打ち"] = 0, ["超過分縮小"] = 1, ["最大保証+頭打ち"] = 2, ["最大保証+超過分縮小"] = 3, };
	a_mode = name2num[PI.a_mode] or a_mode;
end

-- normalize parameters.
c_mode = math.min(math.max(math.floor(0.5 + c_mode), 0), 2);
a_mode = math.min(math.max(math.floor(0.5 + a_mode), 0), 3);

--#endregion PI / normalize parameters.

-- apply shader.
obj.pixelshader("clip_color", "object", "object", {
	a_mode < 2 and 0 or 1,
	a_mode % 2 == 0 and 0 or 1,
	c_mode,
});
