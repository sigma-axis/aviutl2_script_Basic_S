--information:N次式@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\基本緩急
--require:${LEAST_AVIUTL_VERSION}
--speed:0,1
--param:次数N,5
local t, v0, v1 = require("Basic_S").track.ease_inout_core();

local N = math.max(obj.getpoint("param"), 0);
local rho = (N > 0 or t > 0) and t ^ N or 0;

return v0 + (v1 - v0) * rho;
