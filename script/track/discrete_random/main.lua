--information:コマ落ちランダム@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\コマ落ち
--require:${LEAST_AVIUTL_VERSION}
--twopoint
--param:周期の単位/select/秒=0/フレーム=1/Hz=2/回数=3/BPM=4/BPMグリッド(拍数線)=5/BPMグリッド(小節線)=6,0
--param:周期,0.5
--param:周期(分母),1
--param:周期ずれ%,0
--param:周期の起点/select/始点=0/終点=1/始点近くのグリッド(BPMグリッド)=2/終点近くのグリッド(BPMグリッド)=3,0
--param:乱数シード,2525
local track = require("Basic_S").track;
return track.discrete_random(track.period.select(obj.getpoint("param")));
