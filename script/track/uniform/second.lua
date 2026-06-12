--information:等速移動(秒)@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S
--require:${LEAST_AVIUTL_VERSION}
--twopoint
--param:単位時間(秒),1
local t, T, v0, v1 = obj.getpoint("time"), obj.getpoint("param"), obj.getpoint(0), obj.getpoint(1);
if 1 / T < 0 then t, T, v0, v1 = obj.getpoint("time", 1) - t, -T, v1, v0 end
if T == 0 then T = 1 end
return v0 + (v1 - v0) * t / T;
