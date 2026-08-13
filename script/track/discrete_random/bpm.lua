--information:コマ落ちランダム(BPM)@Basic_S v2.71 by σ軸
--label:Basic_S\非推奨
--require:2005400
--twopoint
--param:周期(BPM),120
--param:周期ずれ%,0
--param:乱数シード,2525
local track = require("Basic_S").track;
return track.discrete_random(track.period.bpm(obj.getpoint("param")));
