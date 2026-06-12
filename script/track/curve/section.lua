--information:区間ごとに時間制御@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S
--require:${LEAST_AVIUTL_VERSION}
--timecontrol
local i, t = require("Basic_S").track.curve.section();
local v0, v1 = obj.getpoint(i), obj.getpoint(i + 1)
return v0 + (v1 - v0) * t;
