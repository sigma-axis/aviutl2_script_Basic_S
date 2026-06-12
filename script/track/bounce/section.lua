--information:バウンス@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S
--require:${LEAST_AVIUTL_VERSION}
--speed:0,1
--param:反発係数,0.70710678
--param:回数,0
--timecontrol
local basic_s = require("Basic_S");
local i, t = basic_s.track.curve.section();
local v0, v1 = obj.getpoint(i), obj.getpoint(i + 1);
t, v0, v1 = basic_s.reduce_inout_ease(t, v0, v1, obj.getpoint("accelerate"), obj.getpoint("decelerate"));
return basic_s.track.bounce(t, v0, v1, obj.getpoint("param"));
