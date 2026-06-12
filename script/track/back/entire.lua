--information:バック(全体時間制御)@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S
--require:${LEAST_AVIUTL_VERSION}
--speed:0,1
--param:勢い,0.8
--timecontrol
local basic_s = require("Basic_S");
local i, t = basic_s.track.curve.entire();
local v0, v1 = obj.getpoint(i), obj.getpoint(i + 1);
t, v0, v1 = basic_s.reduce_inout_ease(t, v0, v1, obj.getpoint("accelerate"), obj.getpoint("decelerate"));
return basic_s.track.back(t, v0, v1, obj.getpoint("param"));
