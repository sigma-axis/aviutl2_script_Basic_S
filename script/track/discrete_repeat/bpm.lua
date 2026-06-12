--information:コマ落ち反復(BPM)@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\コマ落ち
--require:${LEAST_AVIUTL_VERSION}
--twopoint
--param:周期(BPM),120
--param:周期ずれ%,0
--param:デューティ比%,50
local track = require("Basic_S").track;
return track.discrete_repeat(track.period.bpm(obj.getpoint("param")));
