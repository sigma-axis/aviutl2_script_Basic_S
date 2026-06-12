--information:時間制御繰り返し(BPMグリッド)@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\繰り返し
--require:${LEAST_AVIUTL_VERSION}
--twopoint
--param:周期(音符数),1
--param:基準のN分音符(0:小節),4
--param:グリッド1拍のN分音符,4
--param:周期ずれ%,0
--timecontrol
local track = require("Basic_S").track;
return track.curve_repeat(track.period.bpmgrid(obj.getpoint("param")));
