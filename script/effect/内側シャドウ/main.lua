--information:内側シャドウ@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:オブジェクト自身に外側から影が落ちているような効果を描画します．
--label:Basic_S\装飾
--filter
--require:${LEAST_AVIUTL_VERSION}
---$nolang: name
---$track:X, min = -1000, max = 1000, step = 0.01, scale = 0.2
local X = -40

---$nolang: name
---$track:Y, min = -1000, max = 1000, step = 0.01, scale = 0.2
local Y = 24

--trackgroup@X,Y:pos
---$track:濃さ, min = 0, max = 100, step = 0.01
local alpha = 40

---$track:拡散, min = 0, max = 500, step = 0.01, scale = 0.1
local blur = 10

---$color:影色
local color = 0x000000

---$select:合成モード
---通常 = 0
---加算 = 1
---減算 = 2
---乗算 = 3
---スクリーン = 4
---オーバーレイ = 5
---比較(明) = 6
---比較(暗) = 7
---輝度 = 8
---色差 = 9
---陰影 = 10
---明暗 = 11
---差分 = 12
local blend = 0

--group:パターン画像,false
---$file:パターン画像
local file_image = ""

---$track:画像X, min = -4000, max = 4000, step = 1, scale = 0.25
local img_X = 0

---$track:画像Y, min = -4000, max = 4000, step = 1, scale = 0.25
local img_Y = 0

--trackgroup@img_X,img_Y:img_pos
--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  X, Y: number?,
---     :  alpha: number?,
---     :  blur: number?,
---     :  color: number?,
---     :  file_image: string?,
---     :  img_X: number?,
---     :  img_Y: number?,
---     :  blend: string?,
---     :}
---$value:PI
local PI = {}

--[[pixelshader@recol_img:
---$include "recol_img.hlsl"
]]
--[[pixelshader@recol_one:
---$include "recol_one.hlsl"
]]
local obj,math,tonumber,type=obj,math,tonumber,type;
local basic_s = require("Basic_S");

-- set anchors.
if #file_image >= 4 then obj.setanchor("img_X,img_Y", 0, "line") end

--#region PI / normalize parameters.

-- take parameters.
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
alpha = tonumber(PI.alpha) or alpha;
blur = tonumber(PI.blur) or blur;
color = tonumber(PI.color) or color;
file_image = type(PI.file_image) == "string" and PI.file_image or file_image;
img_X = tonumber(PI.img_X) or img_X;
img_Y = tonumber(PI.img_Y) or img_Y;
local blend_name = basic_s.PI.blend_mode(PI.blend, blend);

-- normalize parameters.
alpha = math.min(math.max(alpha / 100, 0), 1);
blur = math.max(blur, 0);
color = math.floor(0.5 + color) % 2 ^ 24;
img_X = math.floor(0.5 + img_X);
img_Y = math.floor(0.5 + img_Y);
local has_image = #file_image >= 4;

--#endregion PI / normalize parameters.

-- prepare for blending.
local cache_name, w, h = "cache:basic_s/inner_shadow/obj", obj.w, obj.h;
obj.copybuffer(cache_name, "object");
if blur > 0 then basic_s.effect.prec_blur(blur, blur, 0, false, 1) end
if X ~= 0 or Y ~= 0 or blur > 0 then
	obj.setoption("drawtarget", "tempbuffer", w, h);
	obj.draw(X, Y);
	if not has_image then
		obj.copybuffer("object", "tempbuffer");
	end
else obj.copybuffer("tempbuffer", "object") end

-- color the blurred shape.
if has_image then
	local obj_props = basic_s.save_obj_props();
	if obj.load("image", file_image) then
		obj.pixelshader("recol_img", "tempbuffer", { "tempbuffer", "object" }, {
			math.floor((w - obj.w) / 2) + img_X + X, math.floor((h - obj.h) / 2) + img_Y + Y;
			obj.w, obj.h;
		});
	else has_image = false end

	obj.copybuffer("object", "tempbuffer");
	basic_s.load_obj_props(obj_props);
end
if not has_image then
	local r, g, b, a = basic_s.rgba_color_opt(color);
	obj.pixelshader("recol_one", "object", "tempbuffer", { r, g, b, a });
end

-- prepare the target to draw.
obj.pixelshader("unalpha@画像ファイル合成@Basic_S", "tempbuffer", cache_name);

-- draw using the selected blend mode.
obj.setoption("drawtarget", "tempbuffer");
local prev_blend = obj.getoption("blend");
obj.setoption("blend", blend_name);
obj.draw(0, 0, 0, 1, alpha);
obj.setoption("blend", prev_blend);

-- carve the image.
obj.pixelshader("mask@画像ファイル合成@Basic_S", "tempbuffer", cache_name, { 1 }, "mask");
obj.copybuffer("object", "tempbuffer");
