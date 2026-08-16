--information:別レイヤー同期@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:別レイヤーの座標や回転角度，拡大率や透明度を読み取って反映します．
--label:Basic_S\配置
--require:${LEAST_AVIUTL_VERSION}
---$select:レイヤー位置
---絶対指定 = 0
---相対指定 = 1
local index_base = 1

---$value:番号
local index = -1

--group:座標,true
---$track:X同期%, min = -200, max = 200, step = 0.001, scale = 0.5
local sync_ox = 100

---$track:Y同期%, min = -200, max = 200, step = 0.001, scale = 0.5
local sync_oy = 100

---$track:Z同期%, min = -200, max = 200, step = 0.001, scale = 0.5
local sync_oz = 100

--group:回転中心,true
---$track:中心X同期%, min = -200, max = 200, step = 0.001, scale = 0.5
local sync_cx = 100

---$track:中心Y同期%, min = -200, max = 200, step = 0.001, scale = 0.5
local sync_cy = 100

---$track:中心Z同期%, min = -200, max = 200, step = 0.001, scale = 0.5
local sync_cz = 100

--group:回転,true
---$track:回転同期%, min = -200, max = 200, step = 0.001, scale = 0.5
local sync_rot = 100

--group:拡大率,true
---$track:拡大X同期%, min = -200, max = 200, step = 0.001, scale = 0.5
local sync_sx = 100

---$track:拡大Y同期%, min = -200, max = 200, step = 0.001, scale = 0.5
local sync_sy = 100

---$track:拡大Z同期%, min = -200, max = 200, step = 0.001, scale = 0.5
local sync_sz = 100

--group:透明度,true
---$track:透明度同期%, min = -200, max = 200, step = 0.001, scale = 0.5
local sync_alpha = 100

--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  index_base: string?,
---     :  index: number?,
---     :  sync_ox: number?,
---     :  sync_oy: number?,
---     :  sync_oz: number?,
---     :  sync_cx: number?,
---     :  sync_cy: number?,
---     :  sync_cz: number?,
---     :  sync_rot: number?,
---     :  sync_sx: number?,
---     :  sync_sy: number?,
---     :  sync_sz: number?,
---     :  sync_alpha: number?,
---     :}
---$value:PI
local PI = {}

local obj, math, tonumber = obj, math, tonumber;
local basic_s = require("Basic_S");

--#region PI / normalize parameters.

-- take parameters.
if PI.index_base then
	local name2num = {
		["絶対指定"] = 0, ["相対指定"] = 1,
	};
	index_base = name2num[PI.index_base] or index_base;
end
index = tonumber(PI.index) or tonumber(index) or -1;
sync_ox = tonumber(PI.sync_ox) or sync_ox;
sync_oy = tonumber(PI.sync_oy) or sync_oy;
sync_oz = tonumber(PI.sync_oz) or sync_oz;
sync_cx = tonumber(PI.sync_cx) or sync_cx;
sync_cy = tonumber(PI.sync_cy) or sync_cy;
sync_cz = tonumber(PI.sync_cz) or sync_cz;
sync_rot = tonumber(PI.sync_rot) or sync_rot;
sync_sx = tonumber(PI.sync_sx) or sync_sx;
sync_sy = tonumber(PI.sync_sy) or sync_sy;
sync_sz = tonumber(PI.sync_sz) or sync_sz;
sync_alpha = tonumber(PI.sync_alpha) or sync_alpha;

-- normalize parameters.
if index_base == 1 then index = obj.layer + index end
if index == obj.layer or index <= 0 then return end -- invalid layer index.
sync_ox = sync_ox / 100;
sync_oy = sync_oy / 100;
sync_oz = sync_oz / 100;
sync_cx = sync_cx / 100;
sync_cy = sync_cy / 100;
sync_cz = sync_cz / 100;
sync_rot = sync_rot / 100;
sync_sx = sync_sx / 100;
sync_sy = sync_sy / 100;
sync_sz = sync_sz / 100;
sync_alpha = sync_alpha / 100;

--#endregion PI / normalize parameters.

-- check if the layer exists.
local gv, hdr = obj.getvalue, "layer"..index;
if not gv(hdr) then return end -- no object on the layer.

-- load the properties.
if sync_ox ~= 0 or sync_oy ~= 0 or sync_oz ~= 0 then
	local ox, oy, oz = gv(hdr..".pos");
	obj.ox = obj.ox + ox * sync_ox;
	obj.oy = obj.oy + oy * sync_oy;
	obj.oz = obj.oz + oz * sync_oz;
end
if sync_cx ~= 0 or sync_cy ~= 0 or sync_cz ~= 0 then
	local cx, cy, cz = gv(hdr..".center");
	obj.cx = obj.cx + cx * sync_cx;
	obj.cy = obj.cy + cy * sync_cy;
	obj.cz = obj.cz + cz * sync_cz;
end
if sync_sx ~= 0 or sync_sy ~= 0 or sync_sz ~= 0 then
	local sx, sy, sz = gv(hdr..".scale");
	obj.sx = obj.sx * sx ^ sync_sx;
	obj.sy = obj.sy * sy ^ sync_sy;
	obj.sz = obj.sz * sz ^ sync_sz;
end
if sync_rot ~= 0 then
	local rx, ry, rz = gv(hdr..".angle");
	local qr, qi, qj, qk = basic_s.quat.pow(sync_rot, basic_s.quat.euler_to_quat(
		math.pi / 180 * rx, math.pi / 180 * ry, math.pi / 180 * rz));
	local Rx, Ry, Rz = gv("angle");
	rx, ry, rz = basic_s.quat.quat_to_euler(basic_s.quat.mul(
		qr, qi, qj, qk,
		basic_s.quat.euler_to_quat(
			math.pi / 180 * (obj.rx + Rx),
			math.pi / 180 * (obj.ry + Ry),
			math.pi / 180 * (obj.rz + Rz))));
	obj.rx, obj.ry, obj.rz =
		180 / math.pi * rx - Rx,
		180 / math.pi * ry - Ry,
		180 / math.pi * rz - Rz;
end
if sync_alpha ~= 0 then
	obj.alpha = math.min(math.max(
		obj.alpha * gv(hdr..".alpha") ^ sync_alpha, 0), 1);
end
