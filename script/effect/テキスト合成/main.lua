--information:テキスト合成@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:オブジェクトにテキストを重ね打ちするなど，様々な方法で合成します．
--label:Basic_S\加工
--filter
--require:${LEAST_AVIUTL_VERSION}
---$text:テキスト
local text = ""

--group:フォント設定,true
---$track:サイズ, min = 1, max = 1000, step = 0.01, scale = 0.256
local font_size = 40

---$font:フォント
local font_name = "Yu Gothic UI"

---$color:文字色
local color_main = 0xffffff

---$color:影・縁色
local color_sub = 0x000000

---$select:文字装飾
---標準文字 = 0
---影付き文字 = 1
---影付き文字(薄) = 2
---縁取り文字 = 3
---縁取り文字(細) = 4
---縁取り文字(太) = 5
---縁取り文字(角) = 6
local type_char = 0

---$checksection:太字
local is_bold = false

---$checksection:斜体
local is_italic = false

--group:書式設定,true
---$track:字間, min = -500, max = 500, step = 0.01, scale = 0.1
local space_char = 0

---$track:行間, min = -500, max = 500, step = 0.01, scale = 0.1
local space_line = 0

---$track:表示速度, min = 0, max = 100, step = 0.01, zero_label=---
local text_speed = 0

---$select:文字揃え
---左寄せ[上] = 0
---中央揃え[上] = 1
---右寄せ[上] = 2
---左寄せ[中] = 3
---中央揃え[中] = 4
---右寄せ[中] = 5
---左寄せ[下] = 6
---中央揃え[下] = 7
---右寄せ[下] = 8
---縦書 上寄[右] = 9
---縦書 中央[右] = 10
---縦書 下寄[右] = 11
---縦書 上寄[中] = 12
---縦書 中央[中] = 13
---縦書 下寄[中] = 14
---縦書 上寄[左] = 15
---縦書 中央[左] = 16
---縦書 下寄[左] = 17
local text_align = 0

--group:描画,true
---$nolang: name
---$track:X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local X = 0

---$nolang: name
---$track:Y, min = -4000, max = 4000, step = 0.01, scale = 0.25
local Y = 0

--trackgroup@X,Y:pos
---$track:拡大率, min = 0, max = 5000, step = 0.001, scale = 0.16
local zoom = 100

---$track:回転, min = -1440, max = 1440, step = 0.01, scale = 0.25
local rotate = 0

---$track:透明度, min = 0, max = 100, step = 0.01
local alpha = 0

---$checksection:サイズ固定
local fixed_size = false

--group:配置,false
---$checksection:補間なし
local no_smooth = false

---$select:画像ループ
---なし = 0
---横 = 1
---縦 = 2
---縦横 = 3
local mode_tile = 0

--group:合成,false
---$select:モード
---前方から合成 = 0
---前方から合成(クリッピング) = 1
---後方から合成 = 2
---後方から合成(クリッピング) = 3
---アルファ値を乗算 = 4
---色情報を上書き = 5
---輝度をアルファ値として上書き = 6
---輝度をアルファ値として乗算 = 7
local mode_draw = 0

--hide@fixed_size:mode_tile~=0
--hide@fixed_size:mode_draw==1
--hide@fixed_size:mode_draw>3
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

--group:追加効果,false
---$tips:合成前に，ロードした画像にフィルタ効果を適用できます．
---$select:追加のフィルタ効果
---なし = 0
---後続フィルタ = 1
---スクリプト実行 = 2
local extra_filter = 0

---$text:追加スクリプト
local extra_script = ""

--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  text: string?,
---     :  font_size: number?,
---     :  font_name: string?,
---     :  color_main: number?,
---     :  color_sub: number?,
---     :  type_char: string?,
---     :  is_bold: boolean|number|nil,
---     :  is_italic: boolean|number|nil,
---     :  space_char: number?,
---     :  space_line: number?,
---     :  text_speed: number?,
---     :  text_align: string?,
---     :  X, Y: number?,
---     :  zoom: number?,
---     :  rotate: number?,
---     :  alpha: number?,
---     :  fixed_size: boolean|number|nil,
---     :  no_smooth: boolean|number|nil,
---     :  mode_tile: string?,
---     :  mode_draw: string?,
---     :  blend: string?,
---     :  extra_filter: string?,
---     :}
---$value:PI
local PI = {}

local obj, math, type, tonumber = obj, math, type, tonumber;
local basic_s = require("Basic_S");

-- set anchors.
if #text > 0 then
	obj.setanchor("X,Y", 0, "line");
end

-- take parameters.
if type(PI.text) == "string" then text = PI.text end
font_size = tonumber(PI.font_size) or font_size;
if type(PI.font_name) == "string" then font_name = PI.font_name end
color_main = tonumber(PI.color_main) or color_main;
color_sub = tonumber(PI.color_sub) or color_sub;
if type(PI.type_char) == "string" then
	local name2num = {
		["標準文字"] = 0, ["影付き文字"] = 1, ["影付き文字(薄)"] = 2,
		["縁取り文字"] = 3, ["縁取り文字(細)"] = 4, ["縁取り文字(太)"] = 5, ["縁取り文字(角)"] = 6,
	};
	type_char = name2num[PI.type_char] or type_char;
end
is_bold = basic_s.PI.as_bool(PI.is_bold, is_bold);
is_italic = basic_s.PI.as_bool(PI.is_italic, is_italic);
space_char = tonumber(PI.space_char) or space_char;
space_line = tonumber(PI.space_line) or space_line;
text_speed = tonumber(PI.text_speed) or text_speed;
if type(PI.text_align) == "string" then
	local name2num = {
		["左寄せ[上]"] = 0, ["中央揃え[上]"] = 1, ["右寄せ[上]"] = 2,
		["左寄せ[中]"] = 3, ["中央揃え[中]"] = 4, ["右寄せ[中]"] = 5,
		["左寄せ[下]"] = 6, ["中央揃え[下]"] = 7, ["右寄せ[下]"] = 8,

		["縦書 上寄[右]"] =  9, ["縦書 中央[右]"] = 10, ["縦書 下寄[右]"] = 11,
		["縦書 上寄[中]"] = 12, ["縦書 中央[中]"] = 13, ["縦書 下寄[中]"] = 14,
		["縦書 上寄[左]"] = 15, ["縦書 中央[左]"] = 16, ["縦書 下寄[左]"] = 17,
	};
	text_align = name2num[PI.text_align] or text_align;
end
X = tonumber(PI.X) or X;
Y = tonumber(PI.Y) or Y;
zoom = tonumber(PI.zoom) or zoom;
rotate = tonumber(PI.rotate) or rotate;
alpha = tonumber(PI.alpha) or alpha;
fixed_size = basic_s.PI.as_bool(PI.fixed_size, fixed_size);
no_smooth = basic_s.PI.as_bool(PI.no_smooth, no_smooth);
mode_tile = basic_s.PI.tile_mode(PI.mode_tile, mode_tile);
mode_draw = basic_s.PI.composite_mode(PI.mode_draw, mode_draw);
local blend_name = basic_s.PI.blend_mode(PI.blend, blend);
if type(PI.extra_filter) == "string" then
	local name2num = { ["追加のフィルタ効果"] = 0, ["なし"] = 0, ["後続フィルタ"] = 1, ["スクリプト実行"] = 2, };
	extra_filter = name2num[PI.extra_filter] or extra_filter;
end

-- normalize parameters.
font_size = math.min(math.max(font_size, 1), 1000);
color_main = math.floor(0.5 + color_main) % 2 ^ 24;
color_sub = math.floor(0.5 + color_sub) % 2 ^ 24;
type_char = math.min(math.max(math.floor(0.5 + type_char), 0), 6);
space_char = math.min(math.max(space_char, -500), 500);
space_line = math.min(math.max(space_line, -500), 500);
text_speed = math.min(math.max(text_speed, 0), 100);
text_align = math.min(math.max(math.floor(0.5 + text_align), 0), 17);
zoom = math.min(math.max(zoom / 100, 0), 50);
rotate = 2 * math.pi * ((rotate / 360) % 1);
alpha = math.min(math.max(1 - alpha / 100, 0), 1);
fixed_size = fixed_size or obj.getinfo("filter");

-- try loading the text.
local w, h = obj.w, obj.h;
local cache_name = "cache:basic_s/combine/obj#"..obj.effect_id;
obj.copybuffer(cache_name, "object");
local prev_font = { obj.getfont() };
obj.setfont(font_name, font_size, type_char, color_main, color_sub,
	is_bold, is_italic, space_char, space_line);
text = basic_s.execute_text_script(text);
local obj_props = basic_s.save_obj_props(); -- backup properties here so the embedded scripts can affect to them.

local load_success, dcx, dcy = false, 0, 0;
if zoom > 0 and obj.load("text", text, text_speed, obj.time, text_align) then
	if extra_filter == 1 then obj.effect();
	elseif extra_filter == 2 and extra_script:find("%S") then
		basic_s.execute_user_script(extra_script);
	end
	load_success = obj.w > 0 and obj.h > 0;
end
obj.setfont(unpack(prev_font));
do -- renders properly even if the text is empty.
	-- reflect properties.
	local zoom_x, zoom_y, c, s = zoom, zoom, 1, 0;
	if load_success then
		rotate = rotate + 2 * math.pi * ((obj.rz / 360) % 1);
		zoom_x, zoom_y, c, s = obj.sx * zoom, obj.sy * zoom, math.cos(rotate), math.sin(rotate);
		X, Y = X + obj.ox - (zoom_x * c * obj.cx - zoom_y * s * obj.cy), Y + obj.oy - (zoom_x * s * obj.cx + zoom_y * c * obj.cy);
		alpha = alpha * obj.alpha;
	end

	-- combine.
	dcx, dcy = basic_s.composite_core(w, h, cache_name,
		X, Y, zoom_x, zoom_y, rotate, alpha,
		fixed_size, no_smooth, mode_tile, mode_draw, blend_name);
end
basic_s.load_obj_props(obj_props);

-- adjust the center.
obj.cx, obj.cy = obj.cx + dcx, obj.cy + dcy;

-- draw immediately if subsequent filters are already applied.
if extra_filter == 1 then
	obj.setoption("drawtarget", "framebuffer");
	obj.draw();
end
