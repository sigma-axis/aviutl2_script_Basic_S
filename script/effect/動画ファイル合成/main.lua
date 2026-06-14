--information:動画ファイル合成@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\加工
--filter
--require:${LEAST_AVIUTL_VERSION}
---$file:動画ファイル
local file = ""

--group:再生設定,true
---$track:再生開始秒, min = 0, max = 36000, step = 0.001, scale = 0.0083333
local start = 0

---$track:再生速度, min = -2000, max = 2000, step = 0.001, scale = 0.4
local rate = 100

---$check:ループ再生
local loop = false
--group:描画,true
---$track:X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local X = 0

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
local fixed_size = false,false

--group:配置,false
---$checksection:補間なし
local no_smooth = false,false

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
---$select:追加のフィルタ効果
---なし = 0
---後続フィルタ = 1
---スクリプト実行 = 2
local extra_filter = 0

---$text:追加スクリプト
local extra_script = ""

--group:その他,false
---$value:PI
local PI = {}

local obj, math, type, tonumber = obj, math, type, tonumber;
local basic_s = require("Basic_S");

-- set anchors.
if #file >= 4 then
	obj.setanchor("X,Y", 0, "line");
end

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		file:			string?,
		start:			number?,
		rate:			number?,
		loop:			boolean|number|nil,
		X:				number?,
		Y:				number?,
		zoom:			number?,
		rotate:			number?,
		alpha:			number?,
		no_smooth:		boolean|number|nil,
		fixed_size:		boolean|number|nil,
		mode_tile:		string?,
		mode_draw:		string?,
		blend:			string?,
		extra_filter:	string?,
	}
]==]
file = type(PI.file) == "string" and PI.file or file;
start = tonumber(PI.start) or start;
rate = tonumber(PI.rate) or rate;
loop = basic_s.PI.as_bool(PI.loop, loop);
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
start = math.max(start, 0);
rate = rate / 100;
zoom = math.min(math.max(zoom / 100, 0), 50);
rotate = 2 * math.pi * ((rotate / 360) % 1);
alpha = math.min(math.max(1 - alpha / 100, 0), 1);
fixed_size = fixed_size or obj.getinfo("filter");

if #file < 4 then return end -- no valid file name.

--#endregion PI / normalize parameters.

-- try loading the video.
local w, h, obj_props = obj.w, obj.h, basic_s.save_obj_props();
local cache_name = "cache:basic_s/combine/obj#"..obj.effect_id;
obj.copybuffer(cache_name, "object");
local load_success, dcx, dcy = false, 0, 0;
local video_len = nil do
	local f, r, s = obj.load("movie.info", file);
	if f > 0 and r > 0 and s > 0 then
		video_len = f * s / r;
	end
end
if video_len then -- renders properly only when the video can be loaded propertly.
	local video_pos = start + rate * obj.time;
	if loop then video_pos = video_pos % video_len;
	else video_pos = math.min(math.max(video_pos, 0), video_len) end

	if obj.load("movie", file, math.max(video_pos, 0)) == 0 or
		obj.w <= 0 or obj.h <= 0 then video_len = nil;
	end
end
if video_len then
	-- apply effects if specified.
	if extra_filter == 1 then obj.effect();
	elseif extra_filter == 2 and extra_script:find("%S") then
		basic_s.execute_user_script(extra_script);
	end
	load_success = obj.w > 0 and obj.h > 0;
else extra_filter = 0 end

if load_success then
	-- reflect properties.
	rotate = rotate + 2 * math.pi * ((obj.rz / 360) % 1);
	local zoom_x, zoom_y, c, s = obj.sx * zoom, obj.sy * zoom, math.cos(rotate), math.sin(rotate);
	X, Y = X + obj.ox - (zoom_x * c * obj.cx - zoom_y * s * obj.cy), Y + obj.oy - (zoom_x * s * obj.cx + zoom_y * c * obj.cy);
	alpha = alpha * obj.alpha;

	-- combine.
	dcx, dcy = basic_s.composite_core(w, h, cache_name,
		X, Y, zoom_x, zoom_y, rotate, alpha,
		fixed_size, no_smooth, mode_tile, mode_draw, blend_name);
else obj.copybuffer("object", cache_name) end
basic_s.load_obj_props(obj_props);

-- adjust the center.
obj.cx, obj.cy = obj.cx + dcx, obj.cy + dcy;

-- draw immediately if subsequent filters are already applied.
if extra_filter == 1 then
	obj.setoption("drawtarget", "framebuffer");
	obj.draw();
end
