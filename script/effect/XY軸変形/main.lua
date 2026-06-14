--information:XY軸変形@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\変形
--require:${LEAST_AVIUTL_VERSION}
---$track:X軸移動先X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local xX = 100

---$track:X軸移動先Y, min = -4000, max = 4000, step = 0.01, scale = 0.25
local xY = 0

--trackgroup@xX,xY:axis_x
---$checksection:X長さ変更
local stretch_X = false,false

---$track:Y軸移動先X, min = -4000, max = 4000, step = 0.01, scale = 0.25
local yX = 0

---$track:Y軸移動先Y, min = -4000, max = 4000, step = 0.01, scale = 0.25
local yY = -100

--trackgroup@yX,yY:axis_y
---$checksection:Y長さ変更
local stretch_Y = false,false

--group:その他,false
---$value:PI
local PI = {}

--group:互換対応(将来削除予定),false
---$value:X軸
local axis_X = {}

---$value:Y軸
local axis_Y = {}

local obj, math, tonumber = obj, math, tonumber;
local basic_s = require("Basic_S");

-- set anchors.
obj.setanchor("xX,xY", 0, "line", "rgba", 0xf05050c0);
obj.setanchor("yX,yY", 0, "line", "rgba", 0x208020c0);
obj.setanchor({ xX, xY }, 1, "star", "color", 0xf05050);
obj.setanchor({ yX, yY }, 1, "star", "color", 0x208020);

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		xX:			number?,
		xY:			number?,
		stretch_X:	boolean|number|nil,
		yX:			number?,
		yY:			number?,
		stretch_Y:	boolean|number|nil,
	}
]==]
xX = tonumber(axis_X[1]) or tonumber(PI.xX) or xX;
xY = tonumber(axis_X[2]) or tonumber(PI.xY) or xY;
stretch_X = basic_s.PI.as_bool(PI.stretch_X, stretch_X);
yX = tonumber(axis_Y[1]) or tonumber(PI.yX) or yX;
yY = tonumber(axis_Y[2]) or tonumber(PI.yY) or yY;
stretch_Y = basic_s.PI.as_bool(PI.stretch_Y, stretch_Y);

-- normalize parameters.
if not stretch_X then
	local l = (xX ^ 2 + xY ^ 2) ^ 0.5;
	if l <= 0 then xX, xY, l = 1, 0, 1 end
	l = l ^ -1 * obj.w / 2;
	xX, xY = l * xX, l * xY;
end
if not stretch_Y then
	local l = (yX ^ 2 + yY ^ 2) ^ 0.5;
	if l <= 0 then yX, yY, l = 0, 1, 1 end
	l = l ^ -1 * obj.h / 2;
	yX, yY = l * yX, l * yY;
end

--#endregion PI / normalize parameters.

-- draw.
obj.setoption("drawtarget", "tempbuffer",
	2 * math.ceil(math.abs(xX) + math.abs(yX)),
	2 * math.ceil(math.abs(xY) + math.abs(yY)));
obj.drawpoly(
	-xX + yX, -xY + yY, 0,  xX + yX,  xY + yY, 0,
	 xX - yX,  xY - yY, 0, -xX - yX, -xY - yY, 0);
obj.copybuffer("object", "tempbuffer");
