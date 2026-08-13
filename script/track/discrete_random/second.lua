--information:コマ落ちランダム(秒)@Basic_S v2.71 by σ軸
--label:Basic_S\非推奨
--require:2005400
--twopoint
--param:周期(秒),0.5
--param:周期ずれ%,0
--param:乱数シード,2525
local track = require("Basic_S").track;
return track.discrete_random(track.period.sec(obj.getpoint("param")));
