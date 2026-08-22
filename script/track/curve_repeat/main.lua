--information:時間制御繰り返し@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\繰り返し
--require:${LEAST_AVIUTL_VERSION}
--twopoint
---$nolang: option:Hz, option:BPM
--param:周期の単位/select/秒=0/フレーム=1/Hz=2/回数=3/BPM=4/BPMグリッド(拍数線)=5/BPMグリッド(小節線)=6,0
--param:周期,0.5
--param:周期(倍率),1
--param:周期(分母),1
--param:周期ずれ%,0
--param:周期の起点/select/始点=0/終点=1/始点近くのグリッド(BPMグリッド)=2/終点近くのグリッド(BPMグリッド)=3,0
--param:モード/select/通常=0/往復=1,0
--timecontrol
local track = require("Basic_S").track;
return track.curve_repeat(track.period.select(obj.getpoint("param")));
