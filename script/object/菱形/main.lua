--information:菱形@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\図形
--require:${LEAST_AVIUTL_VERSION}
---$track:幅, min = 0, max = 4000, step = 1, scale = 0.25
local width = 100

---$track:高さ, min = 0, max = 4000, step = 1, scale = 0.25
local height = 100

---$track:ライン幅, min = 0, max = 4000, step = 0.01, scale = 0.25
local line = 4000

---$color:色
local color = 0xffffff

---$color:背景色
local color_back = 0xffffff

---$track:背景透明度, min = 0, max = 100, step = 0.01
local alpha_back = 100

---$checksection:正方形
local square = false

--group:配置,false
---$track:水平揃え, min = -100, max = 100, step = 0.001
local align_x = 0

---$track:垂直揃え, min = -100, max = 100, step = 0.001
local align_y = 0

--group:その他,false
---$value:PI
local PI = {}

local obj, math, tonumber = obj, math, tonumber;
local basic_s = require("Basic_S");

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		width:		number?,
		height:		number?,
		line:		number?,
		color:		number?,
		color_back:	number?,
		alpha_back:	number?,
		square:		boolean|number|nil,
		align_x:	number?,
		align_y:	number?,
	}
]==]
width = tonumber(PI.width) or width;
height = tonumber(PI.height) or height;
line = tonumber(PI.line) or line;
color = tonumber(PI.color) or color;
color_back = tonumber(PI.color_back) or color_back;
alpha_back = tonumber(PI.alpha_back) or alpha_back;
square = basic_s.PI.as_bool(PI.square, square);
align_x = tonumber(PI.align_x) or align_x;
align_y = tonumber(PI.align_y) or align_y;

-- normalize parameters.
width = math.max(math.floor(0.5 + width), 0);
height = math.max(math.floor(0.5 + height), 0);
line = math.max(line, 0);
color = math.floor(0.5 + color) % 2 ^ 24;
color_back = math.floor(0.5 + color_back) % 2 ^ 24;
alpha_back = math.min(math.max(1 - alpha_back / 100, 0), 1);
align_x = math.min(math.max(align_x / 100, -1), 1);
align_y = math.min(math.max(align_y / 100, -1), 1);

if square then height = width end

--#region PI / normalize parameters.

-- pass to core.
local big_radius = math.max(width, height) + 1;
local r =  { big_radius, big_radius };
basic_s.object.round_rect(width, height, line,
	color, color_back, alpha_back,
	{ r, r, r, r }, { 2, 2, 2, 2 }, false);

-- alignment.
obj.cx, obj.cy = -width * align_x / 2, -height * align_y / 2;
