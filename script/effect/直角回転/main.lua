--information:直角回転@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S\配置
--require:${LEAST_AVIUTL_VERSION}
---$select:方向
---なし = 0
---90°時計回り = 1
---180°反転 = 2
---90°反時計回り = 3
---左右反転 = 4
---上下反転 = 5
---右上軸反転 = 6
---左上軸反転 = 7
local rot = 0

---$checksection:中心の位置を変更
local move_center = false

local obj, math = obj, math;

rot = math.min(math.max(math.floor(0.5 + rot), 0), 7);
if rot == 0 then return end

local w, h, cx0, cy0 = obj.w, obj.h, obj.getvalue("center");
cx0, cy0 = obj.cx + cx0, obj.cy + cy0;
local cx, cy = cx0, cy0;
local flip_hv = rot ~= 2 and rot ~= 4 and rot ~= 5;
obj.setoption("drawtarget", "tempbuffer",
	flip_hv and h or w, flip_hv and w or h);
if rot < 4 then
	cx, cy =
		rot == 2 and -cx or (rot - 2) * cy,
		rot == 2 and -cy or (2 - rot) * cx;
	obj.draw(0, 0, 0, 1, 1, 0, 0, 90 * rot);
else
	local pts = {
		-w / 2, -h / 2, 0;  w / 2, -h / 2, 0;
		 w / 2,  h / 2, 0; -w / 2,  h / 2, 0;
	};
	if rot == 4 then
		pts[ 1], pts[ 2], pts[ 4], pts[ 5] = pts[ 4], pts[ 5], pts[ 1], pts[ 2];
		pts[ 7], pts[ 8], pts[10], pts[11] = pts[10], pts[11], pts[ 7], pts[ 8];
		cx = -cx;
	elseif rot == 5 then
		pts[ 1], pts[ 2], pts[10], pts[11] = pts[10], pts[11], pts[ 1], pts[ 2];
		pts[ 4], pts[ 5], pts[ 7], pts[ 8] = pts[ 7], pts[ 8], pts[ 4], pts[ 5];
		cy = -cy;
	elseif rot == 6 then
		pts[ 1], pts[ 2], pts[ 7], pts[ 8] = pts[ 8], pts[ 7], pts[ 2], pts[ 1];
		pts[ 4], pts[ 5], pts[10], pts[11] = pts[11], pts[10], pts[ 5], pts[ 4];
		cx, cy = -cy, -cx;
	else
		pts[ 1], pts[ 2], pts[ 7], pts[ 8] = pts[ 2], pts[ 1], pts[ 8], pts[ 7];
		pts[ 4], pts[ 5], pts[10], pts[11] = pts[ 5], pts[ 4], pts[11], pts[10];
		cx, cy = cy, cx;
	end
	obj.drawpoly(unpack(pts));
end
obj.copybuffer("object", "tempbuffer");
if not move_center then obj.cx, obj.cy = obj.cx + (cx - cx0), obj.cy + (cy - cy0) end
