--information:透明度適用@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\加工
--filter
--require:${LEAST_AVIUTL_VERSION}
---$track:透明度, min = -100, max = 100, step = 0.01
local alpha = 0

---$checksection:累積分も適用
local apply_former = false,false

--[[pixelshader@const_alpha:
---$include "const_alpha.hlsl"
]]
local basic_s = require("Basic_S");
alpha = math.min(math.max(1 - alpha / 100, 0), 2);
if apply_former then obj.alpha, alpha = 1, alpha * obj.alpha end
basic_s.apply_alpha(alpha);
