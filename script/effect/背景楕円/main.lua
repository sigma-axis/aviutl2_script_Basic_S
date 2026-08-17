--information:背景楕円@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:オブジェクトの背景に楕円を配置します．
--label:Basic_S\装飾
--require:${LEAST_AVIUTL_VERSION}
---$track:余白X, min = -1000, max = 1000, step = 1, scale = 0.5
local pad_X = 10

---$track:余白Y, min = -1000, max = 1000, step = 1, scale = 0.5
local pad_Y = 10

---$tips:背景の図形からはみ出した部分の表示方法
---$select:クリッピング
---なし = 0
---あり = 1
---ライン内 = 2
local clip = 0

---$track:ライン幅, min = -500, max = 4000, step = 0.01, scale = 0.25
local line = 4000

---$tips:元オブジェクトが背景の図形の内部に収まるように調整します．
---$checksection:包含
local inclusive = true

---$tips:幅と高さを一致させます．
---$checksection:真円
local circle = false

--group:色/パターン画像,false
---$color:色
local color = 0xc0c0c0

---$file:パターン画像
local file_image = ""

---$track:画像X, min = -4000, max = 4000, step = 1, scale = 0.125
local line_x = 0

---$track:画像Y, min = -4000, max = 4000, step = 1, scale = 0.125
local line_y = 0

--trackgroup@line_x,line_y:line_image_pos
---$tips:ライン幅が小さいときの内部色
---$color:背景色
local color_back = 0xc0c0c0

---$tips:ライン幅が小さいときの内部のパターン画像
---$file:背景パターン画像
local file_back = ""

---$track:back::画像X, min = -4000, max = 4000, step = 1, scale = 0.125
local back_x = 0

---$track:back::画像Y, min = -4000, max = 4000, step = 1, scale = 0.125
local back_y = 0

--trackgroup@back_x,back_y:back_image_pos
--group:透明度設定,false
---$track:透明度, min = 0, max = 100, step = 0.01
local alpha = 0

---$tips:ライン幅が小さいときの内部の透明度
---$track:背景透明度, min = 0, max = 100, step = 0.01
local alpha_back = 100

---$track:前景透明度, min = 0, max = 100, step = 0.01
local alpha_front = 0

--group:位置設定,false
---$track:移動X, min = -4000, max = 4000, step = 1, scale = 0.125
local move_x = 0

---$track:移動Y, min = -4000, max = 4000, step = 1, scale = 0.125
local move_y = 0

--trackgroup@move_x,move_y:move_pos
--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  pad_X: number?,
---     :  pad_Y: number?,
---     :  clip: string?,
---     :  line: number?,
---     :  inclusive: boolean|number|nil,
---     :  circle: boolean|number|nil,
---     :  color: number?,
---     :  file_image: string?,
---     :  line_x: number?,
---     :  line_y: number?,
---     :  alpha: number?,
---     :  color_back: number?,
---     :  file_back: string?,
---     :  back_x: number?,
---     :  back_y: number?,
---     :  alpha_back: number?,
---     :  alpha_front: number?,
---     :  move_x: number?,
---     :  move_y: number?,
---     :}
---$value:PI
local PI = {}

local obj, math, tonumber, type = obj, math, tonumber, type;
local basic_s = require("Basic_S");

-- set anchors.
obj.setanchor("move_x,move_y", 0, "line");

--#region PI / normalize parameters

-- take parameters.
local function as_pair(c, v)
	if type(c) == "number" then return c, c;
	elseif type(c) == "table" then
		local x, y = tonumber(c[1]), tonumber(c[2]);
		if x and y then return x, y end
	end
	return v, v;
end
local pad_L, pad_R = as_pair(PI.pad_X, pad_X);
local pad_T, pad_B = as_pair(PI.pad_Y, pad_Y);
clip = math.min(math.max(math.floor(0.5 + clip), 0), 2);
if type(PI.clip) == "string" then
	clip = ({ ["なし"] = 0, ["あり"] = 1, ["ライン内"] = 2 })[PI.clip] or clip;
end
line = tonumber(PI.line) or line;
inclusive = basic_s.PI.as_bool(PI.inclusive, inclusive);
circle = basic_s.PI.as_bool(PI.circle, circle);
color = tonumber(PI.color) or color;
file_image = type(PI.file_image) == "string" and PI.file_image or file_image;
line_x, line_y = tonumber(PI.line_x) or line_x, tonumber(PI.line_y) or line_y;
alpha = tonumber(PI.alpha) or alpha;
color_back = tonumber(PI.color_back) or color_back;
file_back = type(PI.file_back) == "string" and PI.file_back or file_back;
back_x, back_y = tonumber(PI.back_x) or back_x, tonumber(PI.back_y) or back_y;
alpha_back = tonumber(PI.alpha_back) or alpha_back;
alpha_front = tonumber(PI.alpha_front) or alpha_front;
move_x, move_y = tonumber(PI.move_x) or move_x, tonumber(PI.move_y) or move_y;

-- normalize parameters.
pad_L = math.floor(0.5 + pad_L);
pad_R = math.floor(0.5 + pad_R);
pad_T = math.floor(0.5 + pad_T);
pad_B = math.floor(0.5 + pad_B);
clip = math.min(math.max(math.floor(0.5 + clip), 0), 2);
line = math.max(line, -500);
color = math.floor(0.5 + color) % 2 ^ 24;
line_x, line_y = math.floor(0.5 + line_x), math.floor(0.5 + line_y);
alpha = math.min(math.max(1 - alpha / 100, 0), 1);
color_back = math.floor(0.5 + color_back) % 2 ^ 24;
back_x, back_y = math.floor(0.5 + back_x), math.floor(0.5 + back_y);
alpha_back = math.min(math.max(1 - alpha_back / 100, 0), 1);
alpha_front = math.min(math.max(1 - alpha_front / 100, 0), 1);
move_x, move_y = math.floor(0.5 + move_x), math.floor(0.5 + move_y);

pad_L, pad_R = pad_L - move_x, pad_R + move_x;
pad_T, pad_B = pad_T - move_y, pad_B + move_y;

--#endregion PI / normalize parameters

-- further calculations.
local dx, dy = 0, 0 do
	local W, H = pad_L + obj.w + pad_R, pad_T + obj.h + pad_B;
	if inclusive then
		if circle then
			local radius = (W ^ 2 + H ^ 2) ^ 0.5 / 2;
			dx, dy = math.ceil(radius - W / 2), math.ceil(radius - H / 2);
		else
			local t = (2 ^ 0.5 - 1) / 2;
			dx, dy = math.ceil(t * W), math.ceil(t * H);
		end
	elseif circle then
		if W < H then dx = math.ceil((H - W) / 2);
		else dy = math.ceil((W - H) / 2) end
	end
end
pad_L, pad_R = dx + pad_L, dx + pad_R;
pad_T, pad_B = dy + pad_T, dy + pad_B;
local big_radius = math.max(
	math.max(pad_L, 0) + obj.w + math.max(pad_R, 0),
	math.max(pad_T, 0) + obj.h + math.max(pad_B, 0)) + 1;
local radii =  { big_radius, big_radius };
radii = { radii, radii, radii, radii };

-- pass to core.
basic_s.effect.back_round_rect(pad_L, pad_R, pad_T, pad_B,
	line, clip, alpha_front,
	color, file_image, alpha, line_x, line_y,
	color_back, file_back, alpha_back, back_x, back_y,
	radii, { 0, 0, 0, 0 }, false);
