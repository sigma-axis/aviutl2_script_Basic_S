--information:区間ごとに時間制御(回転)@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S
--require:${LEAST_AVIUTL_VERSION}
--param:1周角度,360
--timecontrol
local track = require("Basic_S").track;
local i, t = track.curve.section();
return track.linear_rotation(i, t, obj.getpoint("param"));
