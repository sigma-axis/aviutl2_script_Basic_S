--information:指数関数@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\基本緩急
--require:${LEAST_AVIUTL_VERSION}
--speed:0,1
--param:減衰率,2
local t, v0, v1 = require("Basic_S").track.ease_inout_core();

local a = math.max(obj.getpoint("param"), 0);
local rho = a > 0 and (math.exp(a * t) - 1) / (math.exp(a) - 1) or t;

return v0 + (v1 - v0) * rho;
