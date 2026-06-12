--information:傾斜@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\変形
--require:${LEAST_AVIUTL_VERSION}
---$track:角度, min = -80, max = 80, step = 0.001, scale = 0.9
local angle = 0

---$track:傾き%, min = -500, max = 500, step = 0.001, scale = 0.4
local slope = 0

--group:基準軸,true
---$track:基準軸X1, min = -4000, max = 4000, step = 0.01, scale = 0.25
local X1 = -100

---$track:基準軸Y1, min = -4000, max = 4000, step = 0.01, scale = 0.25
local Y1 = 0

--trackgroup@X1,Y1:baseline1
---$track:基準軸X2, min = -4000, max = 4000, step = 0.01, scale = 0.25
local X2 = 100

---$track:基準軸Y2, min = -4000, max = 4000, step = 0.01, scale = 0.25
local Y2 = 0

--trackgroup@X2,Y2:baseline2
--group:その他,false
---$value:PI
local PI = {}

--group:互換対応(将来削除予定),false
---$value:基準軸
local baseline = {}

local obj, math, tonumber = obj, math, tonumber;

-- set anchors.
obj.setanchor("X1,Y1", 0, "line", "rgba", 0x208020c0);
obj.setanchor("X2,Y2", 0, "line", "rgba", 0xf05050c0);
obj.setanchor({ X1, Y1, X2, Y2 }, 2, "line");

--#region PI / normalize parameters.

-- take parameters.
--[==[
	PI = {
		angle:	number?,
		slope:	number?,
		X1:		number?,
		Y1:		number?,
		X2:		number?,
		Y2:		number?,
	}
]==]
angle = tonumber(PI.angle) or angle;
slope = tonumber(PI.slope) or slope;
X1 = tonumber(baseline[1]) or tonumber(PI.X1) or X1;
Y1 = tonumber(baseline[2]) or tonumber(PI.Y1) or Y1;
X2 = tonumber(baseline[3]) or tonumber(PI.X2) or X2;
Y2 = tonumber(baseline[4]) or tonumber(PI.Y2) or Y2;

-- normalize parameters.
angle = math.pi / 180 * math.min(math.max(angle, -80), 80);
slope = math.min(math.max(slope / 100, -5), 5);
local dx, dy = X2 - X1, Y2 - Y1;
do local r = dx ^ 2 + dy ^ 2;
	if r > 0 then
		dx, dy = dx / r ^ 0.5, dy / r ^ 0.5;
	else dx, dy = 1, 0 end
end

--#endregion PI / normalize parameters.

-- further calculations.
slope = slope + math.tan(angle);
if slope == 0 then return end

-- measure the canvas.
local pts = {
	-obj.w / 2, -obj.h / 2, 0;
	 obj.w / 2, -obj.h / 2, 0;
	 obj.w / 2,  obj.h / 2, 0;
	-obj.w / 2,  obj.h / 2, 0;
};
local m11, m12, m21, m22 =
	1 + slope * dx * dy, -slope * dx ^ 2,
	slope * dy ^ 2, 1 - slope * dx * dy;
local L, R, T, B;
for i = 1, 4 do
	local x, y = pts[3 * i - 2] - X1, pts[3 * i - 1] - Y1;
	x, y =
		m11 * x + m12 * y + X1,
		m21 * x + m22 * y + Y1;
	pts[3 * i - 2], pts[3 * i - 1] = x, y;
	if i == 1 or L > x then L = x end
	if i == 1 or R < x then R = x end
	if i == 1 or T > y then T = y end
	if i == 1 or B < y then B = y end
end
local cx, cy = (L + R) / 2, (T + B) / 2;
L, R, T, B =
	math.floor(L - cx), math.ceil(R - cx),
	math.floor(T - cy), math.ceil(B - cy);
for i = 1, 4 do
	pts[3 * i - 2], pts[3 * i - 1] =
		pts[3 * i - 2] - cx, pts[3 * i - 1] - cy;
end

-- draw the skew image.
obj.setoption("drawtarget", "tempbuffer", R - L, B - T);
obj.drawpoly(unpack(pts));
obj.copybuffer("object", "tempbuffer");

-- adjust the center.
obj.cx, obj.cy = obj.cx - cx, obj.cy - cy;
