--information:コマ落ちランダム(秒)@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\コマ落ち
--require:${LEAST_AVIUTL_VERSION}
--twopoint
--param:周期(秒),0.5
--param:周期ずれ%,0
local track = require("Basic_S").track;
return track.discrete_random(track.period.sec(obj.getpoint("param")));
