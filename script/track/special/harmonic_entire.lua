--information:逆数補間(全体時間制御)@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\特殊補間
--require:${LEAST_AVIUTL_VERSION}
--param:原点,0
--timecontrol
local track = require("Basic_S").track;
local i, t = track.curve.entire();
return track.harmonic(t, obj.getpoint(i), obj.getpoint(i + 1), obj.getpoint("param"));
