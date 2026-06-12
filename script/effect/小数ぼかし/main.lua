--information:小数ぼかし@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\ぼかし
--filter
--require:${LEAST_AVIUTL_VERSION}
---$track:範囲, min = 0, max = 1000, step = 0.01, scale = 0.3
local range = 5

---$track:縦横比, min = -100, max = 100, step = 0.001
local aspect = 0

---$track:光の強さ, min = 0, max = 60, step = 0.1
local luma_weight = 0

---$check:サイズ固定
local fixed_size = false

--group:その他,false
---$value:PI
local PI = {}

--[[computeshader@convol:
---$include "convol.hlsl"
]]
--[[pixelshader@unweight_alpha:
---$include "unweight_alpha.hlsl"
]]
--[[pixelshader@weight_luma:
---$include "weight_luma.hlsl"
]]
--[[pixelshader@unweight_luma:
---$include "unweight_luma.hlsl"
]]
local obj, math, tonumber = obj, math, tonumber;
local basic_s = require("Basic_S");

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		range:			number?,
		aspect:			number?,
		luma_weight:	number?,
		fixed_size:		boolean|number|nil,
	}
]==]
range = tonumber(PI.range) or range;
aspect = tonumber(PI.aspect) or aspect;
luma_weight = tonumber(PI.luma_weight) or luma_weight;
fixed_size = basic_s.PI.as_bool(PI.fixed_size, fixed_size);

-- normalize parameters.
range = math.min(math.max(range, 0), 1000);
aspect = math.min(math.max(aspect / 100, -1), 1);
luma_weight = math.min(math.max(luma_weight, 0), 60);
if range == 0 then return end
fixed_size = fixed_size or obj.getinfo("filter");

--#endregion PI / normalize parameters.

-- pass to core.
local range_x, range_y = basic_s.size_from_aspect(range, -aspect); -- intentionally negated.
basic_s.effect.prec_blur(range_x, range_y, luma_weight, fixed_size);
