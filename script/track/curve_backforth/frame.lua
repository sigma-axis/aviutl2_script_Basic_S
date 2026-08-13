-- 非推奨化に伴い，このファイルは更新凍結 / information も固定．

--information:時間制御繰り返し往復(フレーム)@Basic_S v2.71 by σ軸
--label:Basic_S\非推奨
--require:2005400
--twopoint
--param:周期(フレーム),30
--param:周期ずれ%,0
--timecontrol
local track = require("Basic_S").track;
return track.curve_backforth(track.period.frame(obj.getpoint("param")));
