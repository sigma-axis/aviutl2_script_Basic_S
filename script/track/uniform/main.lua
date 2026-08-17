--information:等速移動@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S
--require:${LEAST_AVIUTL_VERSION}
--twopoint
--param:単位/select/秒=0/フレーム=1,0
--param:単位時間,1
local fr, mode, T = obj.getpoint("framerate"), obj.getpoint("param");
local t, v0, v1 = obj.getpoint("time"), obj.getpoint(0), obj.getpoint(1);
if 1 / T < 0 then t, T, v0, v1 = obj.getpoint("time", 1) - t, -T, v1, v0 end
if T == 0 then T = 1 end
if mode == 1 then t = fr * t end
return v0 + (v1 - v0) * t / T;
