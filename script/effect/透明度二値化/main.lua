--information:透明度二値化@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\加工
--filter
--require:${LEAST_AVIUTL_VERSION}
---$track:基準透明度, min = 0, max = 100, step = 0.01
local alpha = 50

---$track:ぼかし幅, min = 0, max = 100, step = 0.01
local buffer = 8

--group:その他,false
---$value:PI
local PI = {}

--[[pixelshader@apply:
---$include "apply.hlsl"
]]
local obj, math, tonumber = obj, math, tonumber;

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		alpha:	number?,
		buffer:	number?,
	}
]==]
alpha = tonumber(PI.alpha) or alpha;
buffer = tonumber(PI.buffer) or buffer;

-- normalize parameters.
local least_a = 2 ^ -12;
alpha = math.min(math.max(1 - alpha / 100, 0), 1 - least_a);
buffer = math.min(math.max(buffer / 100, least_a), 1);

--#endregion PI / normalize parameters.

-- apply.
if alpha > 0 or buffer < 1 then
	obj.pixelshader("apply", "object", "object", { alpha, buffer });
end
