--information:コマ落ちランダム@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\コマ落ち
--require:${LEAST_AVIUTL_VERSION}
--twopoint
--param:周期の単位/select/秒=0/フレーム=1/Hz=2/回数=3/BPM=4,0
--param:周期,0.5
--param:周期ずれ%,0
--param:終点を基準/check,0
--param:乱数シード,2525
local track = require("Basic_S").track;
return track.discrete_random(track.period.select(obj.getpoint("param")));
