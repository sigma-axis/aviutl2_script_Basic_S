-- 非推奨化に伴い，このファイルは更新凍結 / information も固定．

--information:コマ落ちランダム(BPMグリッド)@Basic_S v2.71 by σ軸
--label:Basic_S\非推奨
--require:2005400
--twopoint
--param:周期(音符数),1
--param:基準のN分音符(0:小節),4
--param:グリッド1拍のN分音符,4
--param:周期ずれ%,0
--param:乱数シード,2525
local track = require("Basic_S").track;
return track.discrete_random(track.period.bpmgrid(obj.getpoint("param")));
