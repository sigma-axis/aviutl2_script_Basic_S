--information:時間制御繰り返し(フレーム)@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\繰り返し
--require:${LEAST_AVIUTL_VERSION}
--twopoint
--param:周期(フレーム),30
--param:周期ずれ%,0
--timecontrol
local track = require("Basic_S").track;
return track.curve_repeat(track.period.frame(obj.getpoint("param")));
