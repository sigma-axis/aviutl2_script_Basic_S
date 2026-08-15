--information:コマ落ち時間制御@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\コマ落ち
--require:${LEAST_AVIUTL_VERSION}
--param:周期の単位/select/秒=0/フレーム=1/Hz=2/回数=3/BPM=4/BPMグリッド(拍数線)=5/BPMグリッド(小節線)=6,0
--param:周期,0.5
--param:周期(分母),1
--param:周期ずれ%,0
--param:終点を基準/check,0
--param:モード/select/区間ごとに時間制御=0/全体で時間制御=1/区間ごとに時間制御(回転)=2/全体で時間制御(回転)=3,0
--param:1周角度,360
--param:サンプル位置%,0
--timecontrol
local track = require("Basic_S").track;
return track.curve.discrete(obj.getpoint("param"));
