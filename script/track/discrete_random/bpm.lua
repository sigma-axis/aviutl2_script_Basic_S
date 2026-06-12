--information:コマ落ちランダム(BPM)@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\コマ落ち
--require:${LEAST_AVIUTL_VERSION}
--twopoint
--param:周期(BPM),120
--param:周期ずれ%,0
--param:乱数シード,2525
local track = require("Basic_S").track;
return track.discrete_random(track.period.bpm(obj.getpoint("param")));
