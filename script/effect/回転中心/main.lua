--information:回転中心@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\配置
--require:${LEAST_AVIUTL_VERSION}
---$track:X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local X = 0

---$track:Y, min = -4000, max = 4000, step = 0.01, scale = 0.25
local Y = 0

---$track:Z, min = -4000, max = 4000, step = 0.01, scale = 0.25
local Z = 0

--trackgroup@X,Y,Z:pos
obj.cx = obj.cx + X;
obj.cy = obj.cy + Y;
obj.cz = obj.cz + Z;
