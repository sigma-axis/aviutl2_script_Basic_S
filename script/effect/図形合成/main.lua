--information:図形合成@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:オブジェクトに図形や SVG ファイルを様々な方法で合成します．
--label:Basic_S\加工
--filter
--require:${LEAST_AVIUTL_VERSION}
---$tips:ボタンクリックで SVG ファイルも選択できます．
---$figure:図形の種類
local figure = "円"

---$track:サイズ, min = 0, max = 4000, step = 1, scale = 0.125
local size = 100

---$tips:正で縦長 / 負で横長
---$track:縦横比, min = -100, max = 100, step = 0.001
local aspect = 0

---$track:ライン幅, min = 0, max = 4000, step = 1, scale = 0.125
local line = 4000

---$color:色
local color = 0xffffff

---$checksection:角を丸くする
local round = false

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
---     :  figure: string?,
---     :  size: number?,
---     :  aspect: number?,
---     :  line: number?,
---     :  color: number?,
---     :  round: boolean|number|nil,
---     :  X, Y: number?,
---     :  zoom: number?,
---     :  rotate: number?,
---     :  alpha: number?,
---     :  no_smooth: boolean|number|nil,
---     :  fixed_size: boolean|number|nil,
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
obj.setanchor("X,Y", 0, "line");

--#region PI / normalize parameters.

-- take parameters.
if type(PI.figure) == "string" then figure = PI.figure end
size = tonumber(PI.size) or size;
aspect = tonumber(PI.aspect) or aspect;
line = tonumber(PI.line) or line;
color = tonumber(PI.color) or color;
round = basic_s.PI.as_bool(PI.round, round);
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
size = math.min(math.max(math.floor(0.5 + size), 0), 4000);
aspect = math.min(math.max(aspect / 100, -1), 1);
line = math.min(math.max(math.floor(0.5 + line), 0), 4000);
color = math.floor(0.5 + color) % 2 ^ 24;
zoom = math.min(math.max(zoom / 100, 0), 50);
rotate = 2 * math.pi * ((rotate / 360) % 1);
alpha = math.min(math.max(1 - alpha / 100, 0), 1);
fixed_size = fixed_size or obj.getinfo("filter");

--#endregion PI / normalize parameters.

-- try loading the image.
local w, h, obj_props = obj.w, obj.h, basic_s.save_obj_props();
local cache_name_obj = "cache:basic_s/combine/obj#"..obj.effect_id;
obj.copybuffer(cache_name_obj, "object");
local load_success, dcx, dcy = false, 0, 0;
if obj.load("figure", figure, color, size, line, round, aspect) then
	-- reset the object properties.
	if extra_filter == 1 then obj.effect();
	elseif extra_filter == 2 and extra_script:find("%S") then
		basic_s.execute_user_script(extra_script);
	end
	load_success = obj.w > 0 and obj.h > 0;
else extra_filter = 0 end

if load_success then -- renders properly only when the image is loaded propertly.
	-- reflect properties.
	rotate = rotate + 2 * math.pi * ((obj.rz / 360) % 1);
	local zoom_x, zoom_y, c, s = obj.sx * zoom, obj.sy * zoom, math.cos(rotate), math.sin(rotate);
	X, Y = X + obj.ox - (zoom_x * c * obj.cx - zoom_y * s * obj.cy), Y + obj.oy - (zoom_x * s * obj.cx + zoom_y * c * obj.cy);
	alpha = alpha * obj.alpha;

	-- combine.
	dcx, dcy = basic_s.composite_core(w, h, cache_name_obj,
		X, Y, zoom_x, zoom_y, rotate, alpha,
		fixed_size, no_smooth, mode_tile, mode_draw, blend_name);
else obj.copybuffer("object", cache_name_obj) end
basic_s.load_obj_props(obj_props);

-- adjust the center.
obj.cx, obj.cy = obj.cx + dcx, obj.cy + dcy;

-- draw immediately if subsequent filters are already applied.
if extra_filter == 1 then
	obj.setoption("drawtarget", "framebuffer");
	obj.draw();
end
