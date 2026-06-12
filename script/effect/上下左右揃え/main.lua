--information:上下左右揃え@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\配置
--require:${LEAST_AVIUTL_VERSION}
---$track:左右%, min= -100, max = 100, step = 0.001
local X = 0

---$track:上下%, min= -100, max = 100, step = 0.001
local Y = 0

--trackgroup@X,Y:pos
---$check:描画位置を固定
local fix_pos = false

--group:縦横無効化,false
---$check:左右有効
local x_enabled = true

---$check:上下有効
local y_enabled = true

local obj, basic_s = obj, require("Basic_S");
local cx, cy, cz = obj.getvalue("center");
if x_enabled then cx = (X / 100) * obj.w / 2 end
if y_enabled then cy = (Y / 100) * obj.h / 2 end
basic_s.set_rotation_center(cx, cy, cz, fix_pos);
