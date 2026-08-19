--information:背景角丸矩形@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:オブジェクトの背景に角丸矩形を配置します．
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

---$track:角半径, min = 0, max = 2000, step = 0.01, scale = 0.25
local radius = 40

---$select:丸角形状
---円 = 0
---円(凹) = 1
---菱形 = 2
---四角形(凹) = 3
---正8角形 = 4
---正8角形(凹) = 5
---正8角形(凹斜) = 6
---正12角形 = 7
---正12角形(凹) = 8
---正12角形(凹斜) = 9
---スパイク = 10
---スパイク(凹) = 11
local shape = 0

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
--group:丸角設定,false
---$checksection:半径均一
local uniform = true

---$track:右上半径, min = 0, max = 2000, step = 0.01, scale = 0.25
local r_RT = 40

-- --hide@r_RT:uniform~=0
---$track:右下半径, min = 0, max = 2000, step = 0.01, scale = 0.25
local r_RB = 40

-- --hide@r_RB:uniform~=0
---$track:左下半径, min = 0, max = 2000, step = 0.01, scale = 0.25
local r_LB = 40

-- --hide@r_LB:uniform~=0
---$tips:正で縦長 / 負で横長
---$track:丸角縦横比, min = -100, max = 100, step = 0.001
local aspect = 0

---$tips:角半径に対してサイズが小さいときの自動調整で，丸角の縦横比を固定します．
---$checksection:丸角縦横比固定
local fixed_aspect = true

--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  pad_X: table|number|nil,
---     :  pad_Y: table|number|nil,
---     :  clip: string?,
---     :  line: number?,
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
---     :  radii: table|number|nil,
---     :  fixed_aspect: boolean|number|nil,
---     :  shapes: table|string|nil,
---     :}
---$value:PI
local PI = {}

--[[pixelshader@combine:
---$include "combine.hlsl"
]]
--[[pixelshader@combine_img:
---$include "combine_img.hlsl"
]]
local math, tonumber, type = math, tonumber, type;
local basic_s = require("Basic_S");

-- set anchors.
obj.setanchor("move_x,move_y", 0, "line");

-- take parameters.
aspect = math.min(math.max(aspect / 100, -1), 1);
local radii, shapes = {
	{ basic_s.size_from_aspect(radius, aspect) },
	{ basic_s.size_from_aspect(uniform and radius or r_RT, aspect) },
	{ basic_s.size_from_aspect(uniform and radius or r_RB, aspect) },
	{ basic_s.size_from_aspect(uniform and radius or r_LB, aspect) },
}, { shape, shape, shape, shape };

--#region PI / normalize parameters

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
if type(PI.clip) == "string" then
	clip = ({ ["なし"] = 0, ["あり"] = 1, ["ライン内"] = 2 })[PI.clip] or clip;
end
line = tonumber(PI.line) or line;
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
radii = basic_s.PI.corner_radii(PI.radii, radii);
fixed_aspect = basic_s.PI.as_bool(PI.fixed_aspect, fixed_aspect);
shapes = basic_s.PI.corner_shape(PI.shapes, shapes);

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

-- pass to core.
basic_s.effect.back_round_rect(pad_L, pad_R, pad_T, pad_B,
	line, clip, alpha_front,
	color, file_image, alpha, line_x, line_y,
	color_back, file_back, alpha_back, back_x, back_y,
	radii, shapes, fixed_aspect);
