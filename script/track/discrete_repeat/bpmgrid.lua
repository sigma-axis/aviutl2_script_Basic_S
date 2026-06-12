--information:コマ落ち反復(BPMグリッド)@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\コマ落ち
--require:${LEAST_AVIUTL_VERSION}
--twopoint
--param:周期(音符数),1
--param:基準のN分音符(0:小節),4
--param:グリッド1拍のN分音符,4
--param:周期ずれ%,0
--param:デューティ比%,50
local track = require("Basic_S").track;
return track.discrete_repeat(track.period.bpmgrid(obj.getpoint("param")));
