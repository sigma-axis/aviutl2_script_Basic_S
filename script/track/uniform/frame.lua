-- 非推奨化に伴い，このファイルは更新凍結 / information も固定．

--information:等速移動(フレーム)@Basic_S v2.71 by σ軸
--label:Basic_S\非推奨
--require:2005400
--twopoint
--param:単位時間(フレーム),60
local fr = obj.getpoint("framerate");
local f, F, v0, v1 = fr * obj.getpoint("time"), obj.getpoint("param"), obj.getpoint(0), obj.getpoint(1);
if 1 / F < 0 then f, F, v0, v1 = fr * obj.getpoint("time", 1) - f, -F, v1, v0 end
if F == 0 then F = 1 end
return v0 + (v1 - v0) * f / F;
