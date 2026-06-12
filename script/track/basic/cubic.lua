--information:3次式@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\基本緩急
--require:${LEAST_AVIUTL_VERSION}
--speed:0,1
local t, v0, v1 = require("Basic_S").track.ease_inout_core();
local rho = t ^ 3;
return v0 + (v1 - v0) * rho;
