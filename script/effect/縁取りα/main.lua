--information:縁取りα@Basic_S ${PACKAGE_VERSION} by σ軸
--label:Basic_S\装飾
--require:2004200
--separator:このスクリプトは現在は非推奨です．
--separator:より高速で高機能な「縁取りσ」の利用を推奨します．
--separator:https://github.com/sigma-axis/aviutl2_Border_S
---$track:サイズ, min = -500, max = 500, step = 1
local size = 5

---$track:ぼかし, min = 0, max = 100, step = 1
local blur = 5

---$color:縁色
local color = 0xffffff

---$track:透明度, min = 0, max = 100, step = 0.01
local alpha = 0

---$track:前景透明度, min = 0, max = 100, step = 0.01
local alpha_front = 0

--group:パターン画像,false
---$file:パターン画像
local file_image = ""

---$track:画像X, min = -4000, max = 4000, step = 1, scale = 0.25
local X = 0

---$track:画像Y, min = -4000, max = 4000, step = 1, scale = 0.25
local Y = 0

--trackgroup@X,Y:pos
--group:その他,false
---$value:PI
local PI = {}

--[[pixelshader@carve:
---$include "carve.hlsl"
]]
--[[pixelshader@recolor:
---$include "recolor.hlsl"
]]
--[[pixelshader@blend:
---$include "blend.hlsl"
]]
--[[pixelshader@combine:
---$include "combine.hlsl"
]]
--[[pixelshader@const_alpha:
---$include "const_alpha.hlsl"
]]

-- 非推奨化に伴い，この部分は更新凍結．
local obj, math, bit, tonumber, type = obj, math, bit, tonumber, type;

--#region PI / normalize parameters.

-- set anchors.
if #file_image >= 4 then
	obj.setanchor("X,Y", 0, "line");
end

-- take parameters.
--[==[
	PI = {
		size:			number?,
		blur:			number?,
		alpha:			number?,
		color:			number?,
		file_image:		string?,
		X:				number?,
		Y:				number?,
		alpha_front:	number?,
	}
]==]
size = tonumber(PI.size) or size;
blur = tonumber(PI.blur) or blur;
alpha = tonumber(PI.alpha) or alpha;
color = tonumber(PI.color) or color;
file_image = type(PI.file_image) == "string" and PI.file_image or file_image;
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
alpha_front = tonumber(PI.alpha_front) or alpha_front;

-- normalize parameters.
size = math.min(math.max(math.floor(0.5 + size), -500), 500);
blur = math.min(math.max(math.floor(0.5 + blur), 0), 100);
alpha = math.min(math.max(1 - alpha / 100, 0), 1);
color = math.floor(0.5 + color) % 2 ^ 24;
alpha_front = math.min(math.max(1 - alpha_front / 100, 0), 1);
local has_image = #file_image >= 4;

--#endregion PI / normalize parameters.

-- early returns for trivial cases.
if size == 0 or alpha == 0 then
	if alpha_front < 1 then
		obj.pixelshader("const_alpha", "object", nil, { alpha_front }, "mask");
	end
	if size > 0 then
		obj.effect("領域拡張", "左", size, "右", size, "上", size, "下", size);
	end
	return;
elseif size > 0 and alpha == 1 and alpha_front == 1 and not has_image then
	-- ordinary border.
	obj.effect("縁取り", "サイズ", size, "ぼかし", blur, "縁色", color);
	return;
end

-- prepare border.
obj.copybuffer("tempbuffer", "object");
if size > 0 then
	-- outer (ordinary) border.
	obj.effect("縁取り", "サイズ", size, "ぼかし", blur, "縁色", color);
	obj.pixelshader("carve", "object", { "tempbuffer", "object" }, {
		bit.band(color, 0xff0000) / 0xff0000,
		bit.band(color, 0x00ff00) / 0x00ff00,
		bit.band(color, 0x0000ff) / 0x0000ff, 1;
		size, size;
	});
else
	-- inner border.
	local chrome_size = math.max(math.ceil(-size / 8), 4);
	obj.effect("領域拡張", "左", chrome_size, "右", chrome_size, "上", chrome_size, "下", chrome_size);
	obj.effect("反転", "透明度反転", 1);
	obj.effect("縁取り", "サイズ", -size, "ぼかし", blur, "縁色", color);
	chrome_size = chrome_size - size;
	obj.effect("クリッピング", "左", chrome_size, "右", chrome_size, "上", chrome_size, "下", chrome_size);
end

-- color by image when set.
if has_image then
	local obj_props = { obj.ox, obj.oy, obj.oz, obj.cx, obj.cy, obj.cz, obj.rx, obj.ry, obj.rz, obj.sx, obj.sy, obj.sz, obj.alpha };
	local w, h = obj.w, obj.h;
	local cache_name = "cache:basic_s/border_alpha/bdr";
	obj.copybuffer(cache_name, "object");

	obj.load("image", file_image);
	if obj.w > 0 or obj.h > 0 then
		obj.pixelshader("recolor", cache_name, { cache_name, "object" }, {
			math.floor((w - obj.w) / 2) + X, math.floor((h - obj.h) / 2) + Y;
			obj.w, obj.h;
		});
	else has_image = false end

	obj.copybuffer("object", cache_name);
	obj.ox, obj.oy, obj.oz, obj.cx, obj.cy, obj.cz, obj.rx, obj.ry, obj.rz, obj.sx, obj.sy, obj.sz, obj.alpha = unpack(obj_props);
end
if not has_image and size < 0 then
	-- color the chrome here.
	obj.effect("単色化", "輝度を保持する", 0, "色", color);
end

-- combine by shaders.
if size < 0 then
	obj.pixelshader("combine", "object", { "tempbuffer", "object" }, {
		alpha_front, alpha,
	});
elseif alpha_front > 0 then
	obj.pixelshader("blend", "object", { "tempbuffer", "object" }, {
		size, size; alpha_front, alpha,
	});
elseif alpha < 1 then
	obj.pixelshader("const_alpha", "object", nil, { alpha }, "mask");
end
