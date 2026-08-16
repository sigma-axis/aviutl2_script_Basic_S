--information:別レイヤー@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:別レイヤーと同じ画像を読み込みます．座標や拡大率などの情報もある程度は復元できます．
--label:Basic_S
--require:${LEAST_AVIUTL_VERSION}
---$select:レイヤー位置
---絶対指定 = 0
---相対指定 = 1
local index_base = 1

---$value:番号
local index = -1

--group:復元項目,true
---$checksection:フィルタ効果
local effect = true

---$checksection:位置の復元
local position = false

---$checksection:回転拡大の復元
local rotation = false

---$checksection:透明度の復元
local alpha = false

--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  index_base: string?,
---     :  index: number?,
---     :  effect: boolean|number|nil,
---     :  position: boolean|number|nil,
---     :  rotation: boolean|number|nil,
---     :  alpha: boolean|number|nil,
---     :}
---$value:PI
local PI = {}

local obj, tonumber = obj, tonumber;
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
effect = basic_s.PI.as_bool(PI.effect, effect);
position = basic_s.PI.as_bool(PI.position, position);
rotation = basic_s.PI.as_bool(PI.rotation, rotation);
alpha = basic_s.PI.as_bool(PI.alpha, alpha);

-- normalize parameters.
if index_base == 1 then index = obj.layer + index end
if index == obj.layer or index <= 0 then return end -- invalid layer index.

--#endregion PI / normalize parameters.

-- load the layer.
local gv, hdr = obj.getvalue, "layer"..index;
if not gv(hdr) then return end -- no object on the layer.
obj.load("layer", index, effect);
if obj.w <= 0 or obj.h <= 0 then return end -- failed to load the layer.

-- restore properties.
-- note that fields like `obj.ox` are initialized to default,
-- even if the object on the target layer had modified them.
if position then
	obj.ox, obj.oy, obj.oz = gv(hdr..".pos");
	obj.cx, obj.cy, obj.cz = gv(hdr..".center");
end
if rotation then
	-- apply the rotation (before the rotation of this object).
	local rx, ry, rz = gv(hdr..".angle");
	rx, ry, rz = math.pi / 180 * rx, math.pi / 180 * ry, math.pi / 180 * rz;
	local Rx, Ry, Rz = gv("angle");
	Rx, Ry, Rz = math.pi / 180 * Rx, math.pi / 180 * Ry, math.pi / 180 * Rz;
	local qr, qi, qj, qk = basic_s.quat.euler_to_quat(Rx, Ry, Rz);
	rx, ry, rz = basic_s.quat.quat_to_euler(basic_s.quat.mul(
		qr, qi, qj, qk,
		basic_s.quat.euler_to_quat(rx, ry, rz)));
	obj.rx, obj.ry, obj.rz =
		180 / math.pi * (rx - Rx),
		180 / math.pi * (ry - Ry),
		180 / math.pi * (rz - Rz);

	-- apply the scaling.
	obj.sx, obj.sy, obj.sz = gv(hdr..".scale");
end
if alpha then
	obj.alpha = gv(hdr..".alpha");
end
