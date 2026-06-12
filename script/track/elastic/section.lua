--information:バネ振動@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S
--require:${LEAST_AVIUTL_VERSION}
--speed:0,1
--param:振動回数,3
--param:減衰率,0.3
--timecontrol
local basic_s = require("Basic_S");
local i, t = basic_s.track.curve.section();
local v0, v1 = obj.getpoint(i), obj.getpoint(i + 1);
t, v0, v1 = basic_s.reduce_inout_ease(t, v0, v1, obj.getpoint("accelerate"), obj.getpoint("decelerate"));
return basic_s.track.elastic(t, v0, v1, obj.getpoint("param"));
