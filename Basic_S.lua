-- under development for v2.20, r3
--[[
MIT License
Copyright (c) 2025-2026 sigma-axis

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

https://mit-license.org/
]]

--
-- v2.10 (for beta43b)
--

local obj, print, type, tonumber, tostring, unpack, loadstring, pcall, setfenv, setmetatable, bit = obj, print, type, tonumber, tostring, unpack, loadstring, pcall, setfenv, setmetatable, require("bit");
local math_pi, math_tau, math_cos, math_sin, math_atan2, math_abs, math_min, math_max, math_floor, math_ceil, bit_band = math.pi, 2 * math.pi, math.cos, math.sin, math.atan2, math.abs, math.min, math.max, math.floor, math.ceil, bit.band;
local image_max_w, image_max_h = obj.getinfo("image_max");

if obj.getinfo("version") < 2004200 then
	error([[AviUtl ExEdit beta42 以降が必要です！]], 2);
end

--#region quaternion / rotation operations.

---1--4 次元のベクトルを正規化する．0 の場合は 0 を返す．
---@param x number 第 1 成分．
---@param y number? 第 2 成分 (2 次元以上).
---@param z number? 第 3 成分 (3 次元以上).
---@param w number? 第 4 成分 (4 次元).
---@return number x1, any ... 正規化したベクトル．
local function vector_normalize(x, y, z, w)
	if w then
		local l = (x ^ 2 + y ^ 2 + z ^ 2 + w ^ 2) ^ 0.5;
		if l > 0 then return x / l, y / l, z / l, w / l;
		else return 0, 0, 0, 0 end
	elseif z then
		local l = (x ^ 2 + y ^ 2 + z ^ 2) ^ 0.5;
		if l > 0 then return x / l, y / l, z / l;
		else return 0, 0, 0 end
	elseif y then
		local l = (x ^ 2 + y ^ 2) ^ 0.5;
		if l > 0 then return x / l, y / l;
		else return 0, 0 end
	else
		return x > 0 and 1 or x < 0 and -1 or 0;
	end
end

---2つの四元数を乗算する．
---@param qr1 number 左の四元数の実部．
---@param qi1 number 左の四元数の i-虚部．
---@param qj1 number 左の四元数の j-虚部．
---@param qk1 number 左の四元数の k-虚部．
---@param qr2 number 右の四元数の実部．
---@param qi2 number 右の四元数の i-虚部．
---@param qj2 number 右の四元数の j-虚部．
---@param qk2 number 右の四元数の k-虚部．
---@return number qr,number qi,number qj,number qk 計算結果のそれぞれ実部，i-虚部，j-虚部，k-虚部．
local function quat_mult(qr1, qi1, qj1, qk1, qr2, qi2, qj2, qk2)
	return
		qr1 * qr2 - qi1 * qi2 - qj1 * qj2 - qk1 * qk2,
		qr1 * qi2 + qi1 * qr2 + qj1 * qk2 - qk1 * qj2,
		qr1 * qj2 - qi1 * qk2 + qj1 * qr2 + qk1 * qi2,
		qr1 * qk2 + qi1 * qj2 - qj1 * qi2 + qk1 * qr2;
end
---四元数の回転を x 倍の角度にする．四元数は正規化されている必要はない．
---@param x number 角度に乗じる係数．
---@param qr number 四元数の実部．
---@param qi number 四元数の i-虚部．
---@param qj number 四元数の j-虚部．
---@param qk number 四元数の k-虚部．
---@return number qr,number qi,number qj,number qk 計算結果のそれぞれ実部，i-虚部，j-虚部，k-虚部．正規化済みで `qr >= 0`.
local function quat_power(x, qr, qi, qj, qk)
	local l = qi ^ 2 + qj ^ 2 + qk ^ 2;
	if l <= 0 then return 1, 0, 0, 0 end
	l = l ^ 0.5;
	local a = x * math_atan2(l, qr);
	local c, s = math_cos(a), math_sin(a);
	qr, qi, qj, qk = c, s * qi / l, s * qj / l, s * qk / l;

	if qr < 0 then qr, qi, qj, qk = -qr, -qi, -qj, -qk end
	return qr, qi, qj, qk;
end

---X, Y, Z 軸それぞれの回転の合成を四元数で表現する．回転は Z -> Y -> X の順に適用されるものとする．
---@param rx number X 軸回転角度，ラジアン単位．
---@param ry number Y 軸回転角度，ラジアン単位．
---@param rz number Z 軸回転角度，ラジアン単位．
---@return number qr,number qi,number qj,number qk 計算結果のそれぞれ実部，i-虚部，j-虚部，k-虚部．正規化済みで `qr >= 0`.
local function angle_euler_to_quat(rx, ry, rz)
	local cx, sx, cy, sy, cz, sz =
		math_cos(rx / 2), math_sin(rx / 2),
		math_cos(ry / 2), math_sin(ry / 2),
		math_cos(rz / 2), math_sin(rz / 2);
	local qr, qi, qj, qk = -- (cx + i sx) x (cy + j sy).
		cx * cy, sx * cy, cx * sy, sx * sy;
	qr, qi, qj, qk = -- x (cz + k sz).
		qr * cz - qk * sz,
		qi * cz + qj * sz,
		qj * cz - qi * sz,
		qk * cz + qr * sz;

	if qr < 0 then qr, qi, qj, qk = -qr, -qi, -qj, -qk end
	return qr, qi, qj, qk;
end
---指定軸による指定角度の回転を四元数で表現する．指定した回転軸は正規化されている必要はない．
---@param axis_x number 回転軸の X 成分．
---@param axis_y number 回転軸の Y 成分．
---@param axis_z number 回転軸の Z 成分．
---@param angle number 回転角度．ラジアン単位で指定．方向は，X 軸の回転だと Y > 0 の部分が Z > 0 に移動する方向に正．
---@return number qr,number qi,number qj,number qk 計算結果のそれぞれ実部，i-虚部，j-虚部，k-虚部．正規化済みで `qr >= 0`.
local function angle_axis_to_quat(axis_x, axis_y, axis_z, angle)
	local l = axis_x ^ 2 + axis_y ^ 2 + axis_z ^ 2;
	if l <= 0 then return 1, 0, 0, 0 end
	l = l ^ 0.5;
	local c, s = math_cos(angle / 2), math_sin(angle / 2);
	if c < 0 then c, s = -c, -s end
	return c, s * axis_x / l, s * axis_y / l, s * axis_z / l;
end
local angle_quat_to_euler do
	-- determine the euler angles.
	-- cf.) https://github.com/sigma-axis/sigma_aviutl_scripts/blob/79bce1098a69b1e8da7cb77811aa3356a411ee2d/sigma_rot_helper.lua#L80-L94
	local function calc_angle(x1, y1, x2, y2)
		if x1 ^ 2 + y1 ^ 2 < x2 ^ 2 + y2 ^ 2 then x1, y1 = x2, y2 end
		if x1 < 0 then x1, y1 = -x1, -y1 end
		return 2 * math_atan2(y1, x1);
	end
	---四元数による回転を X, Y, Z 軸回転の合成として表現する．四元数は正規化されている必要はない．
	---@param qr number 四元数の実部．
	---@param qi number 四元数の i-虚部．
	---@param qj number 四元数の j-虚部．
	---@param qk number 四元数の k-虚部．
	---@return number rx,number ry,number rz X, Y, Z 軸それぞれの回転角度，ラジアン単位．回転は Z -> Y -> X の順に適用されるものとする．
	function angle_quat_to_euler(qr, qi, qj, qk)
		local Rx = math_atan2(
			2 * (qr * qi - qj * qk),
			qr ^ 2 - qi ^ 2 - qj ^ 2 + qk ^ 2);
		local c, s = math_cos(Rx / 2), math_sin(Rx / 2);
		qr, qi, qj, qk = -- (c - i s) x q
			c * qr + s * qi,
			c * qi - s * qr,
			c * qj + s * qk,
			c * qk - s * qj;
		return Rx, calc_angle(qr, qj, qk, qi), calc_angle(qr, qk, qj, qi);
	end
end

---四元数が表す回転を表す行列を計算する．
---@param qr number 四元数の実部．
---@param qi number 四元数の i-虚部．
---@param qj number 四元数の j-虚部．
---@param qk number 四元数の k-虚部．
---@return number m11,number m12,number m13,number m21,number m22,number m23,number m31,number m32,number m33 計算結果の行列．X = m11 * x + m12 * y + m13 * z の形で変換する．
local function angle_quat_to_matrix(qr, qi, qj, qk)
	-- matrix that represents the transform:
	--   Xi + Yj + Zk = q (xi + yj + zk) q ^ -1.
	-- cf.) https://github.com/sigma-axis/sigma_aviutl_scripts/blob/79bce1098a69b1e8da7cb77811aa3356a411ee2d/sigma_rot_helper.lua#L107-L114
	local R, I, J, K = qr ^ 2, qi ^ 2, qj ^ 2, qk ^ 2;
	local ij, jk, ki = 2 * qi * qj, 2 * qj * qk, 2 * qk * qi;
	local ri, rj, rk = 2 * qr * qi, 2 * qr * qj, 2 * qr * qk;

	return
		R + I - J - K, ij - rk, ki + rj,
		ij + rk, R - I + J - K, jk - ri,
		ki - rj, jk + ri, R - I - J + K;
end
---X, Y, Z 軸回転の合成を行列で表現する．回転は Z -> Y -> X の順に適用されるものとする．
---@param rx number X 軸回転角度，ラジアン単位．
---@param ry number Y 軸回転角度，ラジアン単位．
---@param rz number Z 軸回転角度，ラジアン単位．
---@return number m11,number m12,number m13,number m21,number m22,number m23,number m31,number m32,number m33 計算結果の行列．X = m11 * x + m12 * y + m13 * z の形で変換する．
local function angle_euler_to_matrix(rx, ry, rz)
	local cx, sx, cy, sy, cz, sz =
		math_cos(rx), math_sin(rx),
		math_cos(ry), math_sin(ry),
		math_cos(rz), math_sin(rz);
	return
		cy * cz, -cy * sz, sy,
		sx * sy * cz + cx * sz, cx * cz - sx * sy * sz, -sx * cy,
		-cx * sy * cz + sx * sz, sx * cz + cx * sy * sz,  cx * cy;
end

---点 (x, y, z) に対して四元数による回転を適用する．
---@param x number 点の X 座標．
---@param y number 点の Y 座標．
---@param z number 点の Z 座標．
---@param qr number 四元数の実部．
---@param qi number 四元数の i-虚部．
---@param qj number 四元数の j-虚部．
---@param qk number 四元数の k-虚部．
---@return number x,number y,number z 計算結果の座標．
local function angle_quat_apply(x, y, z, qr, qi, qj, qk)
	-- local r;
	-- r, x, y, z = quat_mult(qr, qi, qj, qk, quat_mult(0, x, y, z, qr, -qi, -qj, -qk));
	-- return x, y, z;
	local m11, m12, m13, m21, m22, m23, m31, m32, m33 = angle_quat_to_matrix(qr, qi, qj, qk);
	return
		m11 * x + m12 * y + m13 * z,
		m21 * x + m22 * y + m23 * z,
		m31 * x + m32 * y + m33 * z;
end
---点 (x, y, z) に対してX, Y, Z 軸回転の合成を適用する．回転は Z -> Y -> X の順に適用されるものとする．
---@param x number 点の X 座標．
---@param y number 点の Y 座標．
---@param z number 点の Z 座標．
---@param rx number X 軸回転角度，ラジアン単位．
---@param ry number Y 軸回転角度，ラジアン単位．
---@param rz number Z 軸回転角度，ラジアン単位．
---@return number x,number y,number z 計算結果の座標．
local function angle_euler_apply(x, y, z, rx, ry, rz)
	local cx, sx, cy, sy, cz, sz =
		math_cos(rx), math_sin(rx),
		math_cos(ry), math_sin(ry),
		math_cos(rz), math_sin(rz);
	x, y = cz * x - sz * y, sz * x + cz * y;
	z, x = cy * z - sy * x, sy * z + cy * x;
	y, z = cx * y - sx * z, sx * y + cx * z;
	return x, y, z;
end
--#endregion quaternion / rotation operations.


--#region parameter helpers.

---PI で `boolean|number|nil` での指定を適用する．number の場合，0 を false 扱い，0 以外を true 扱いとする．
---@param pi_value any PI に渡ってきた値．
---@param gui_value boolean 実際にスクリプトのパラメタとして渡ってきた値．
---@return boolean
local function PI_as_bool(pi_value, gui_value)
	if type(pi_value) == "boolean" then return pi_value;
	elseif type(pi_value) == "number" then return pi_value ~= 0;
	else return gui_value end
end

local PI_choose_corner_shape, PI_choose_corner_radii, normalize_corner_shape, normalize_corner_radii do
	---@alias round_corners_indices
	---|`1` 左上
	---|`2` 右上
	---|`3` 右下
	---|`4` 左下

	---@alias round_corners_shape
	---|`0` 円
	---|`1` 円(凹)
	---|`2` 菱形
	---|`3` 四角形(凹)
	---|`4` 正8角形
	---|`5` 正8角形(凹)
	---|`6` 正8角形(凹斜)
	---|`7` 正12角形
	---|`8` 正12角形(凹)
	---|`9` 正12角形(凹斜)
	---|`10` スパイク
	---|`11` スパイク(凹)
	local shape_name2num = {
		["円"] = 0, ["円(凹)"] = 1, ["菱形"] = 2, ["四角形(凹)"] = 3,
		["正8角形"] = 4, ["正8角形(凹)"] = 5, ["正8角形(凹斜)"] = 6,
		["正12角形"] = 7, ["正12角形(凹)"] = 8, ["正12角形(凹斜)"] = 9,
		["スパイク"] = 10, ["スパイク(凹)"] = 11,
	};
	---@alias round_corners_shape_set { [round_corners_indices]: round_corners_shape }

	---四隅丸めの「形状」指定を正規化する．
	---@param shapes round_corners_shape_set
	---@return round_corners_shape_set
	function normalize_corner_shape(shapes)
		for i = 1, 4 do
			shapes[i] = math_min(math_max(math_floor(0.5 + shapes[i]), 0), 11);
		end
		return shapes;
	end

	---PI で四隅丸めの「形状」指定を適用する．
	---このパラメタは次の形式で指定されているものとする:
	---
	---`--select@shape:形状=0,円=0,円(凹)=1,菱形=2,四角形(凹)=3,正8角形=4,正8角形(凹)=5,正8角形(凹斜)=6,正12角形=7,正12角形(凹)=8,正12角形(凹斜)=9,スパイク=10,スパイク(凹)=11`
	---@param pi_value any PI に渡ってきた値．
	---@param gui_value round_corners_shape_set 実際にスクリプトのパラメタとして渡ってきた値．
	---@return round_corners_shape_set
	function PI_choose_corner_shape(pi_value, gui_value)
		if type(pi_value) == "string" then
			local n = shape_name2num[pi_value];
			if n then gui_value = { n, n, n, n } end
		elseif type(pi_value) == "table" then
			for i = 1, 4 do
				if type(pi_value[i]) == "string" then
					gui_value[i] = shape_name2num[pi_value[i]] or gui_value[i];
				end
			end
		end
		return normalize_corner_shape(gui_value);
	end

	local function as_pair(c)
		if type(c) == "number" then return c, c;
		elseif type(c) == "table" then
			local x, y = tonumber(c[1]), tonumber(c[2]);
			if x and y then return x, y end
		end
		return nil;
	end

	---四隅丸めの「半径」指定を正規化する．
	---@param radii round_corners_radii_set
	---@return round_corners_radii_set
	function normalize_corner_radii(radii)
		for i = 1, 4 do
			radii[i][1], radii[i][2] = math_max(radii[i][1], 0), math_max(radii[i][2], 0);
		end
		return radii;
	end

	---@alias round_corners_radii_set { [round_corners_indices]: { [1|2]: number } }
	---PI で四隅丸めの「半径」指定を適用する．
	---@param pi_value any PI に渡ってきた値．
	---@param gui_value round_corners_radii_set 実際にスクリプトのパラメタとして渡ってきた値．
	---@return round_corners_radii_set
	function PI_choose_corner_radii(pi_value, gui_value)
		if type(pi_value) == "number" then
			local r = pi_value;
			gui_value = { { r, r }, { r, r }, { r, r }, { r, r } };
		elseif type(pi_value) == "table" then
			if pi_value.uniform then
				local x, y = as_pair(pi_value.uniform);
				if x then gui_value = { { x, y }, { x, y }, { x, y }, { x, y } } end
			end
			for i = 1, 4 do
				local x, y = as_pair(pi_value[i]);
				if x then gui_value[i] = { x, y } end
			end
		end
		return normalize_corner_radii(gui_value);
	end
end

local PI_choose_cut_move_interpolate do
	---@alias cut_move_interpolate
	---|`0` 空白
	---|`1` 半透明
	---|`2` 補間
	---|`3` 引き伸ばし
	local name2num = { ["空白"] = 0, ["半透明"] = 1, ["補間"] = 2, ["引き伸ばし"] = 3, };

	---PI でカットずらしの「余白処理」「重複処理」指定を適用する．
	---このパラメタは次の形式で指定されているものとする:
	---
	---`--select@mode_padding:余白処理=0,空白=0,半透明=1,補間=2,引き伸ばし=3`
	---@param pi_value any PI に渡ってきた値．
	---@param gui_value cut_move_interpolate 実際にスクリプトのパラメタとして渡ってきた値．
	---@return cut_move_interpolate
	function PI_choose_cut_move_interpolate(pi_value, gui_value)
		if type(pi_value) == "string" then
			gui_value = name2num[pi_value] or gui_value;
		end
		return math_min(math_max(math_floor(0.5 + gui_value), 0), 3);
	end
end

local PI_choose_inner_loop_size, PI_choose_inner_loop_mode do
	---@alias inner_loop_size
	---|`0` 回数
	---|`1` サイズ(近似)
	---|`2` サイズ(上限)
	---|`3` サイズ(下限)
	---|`4` サイズ(境界不連続)
	---|`5` サイズ(拡縮あり)
	---|`6` 全体サイズ(近似)
	---|`7` 全体サイズ(上限)
	---|`8` 全体サイズ(下限)
	---|`9` 全体サイズ(境界不連続)
	---|`10` 全体サイズ(拡縮あり)
	local size_name2num = { ["回数"] = 0, ["サイズ(近似)"] = 1, ["サイズ(上限)"] = 2, ["サイズ(下限)"] = 3, ["サイズ(境界不連続)"] = 4, ["サイズ(拡縮あり)"] = 5, ["全体サイズ(近似)"] = 6, ["全体サイズ(上限)"] = 7, ["全体サイズ(下限)"] = 8, ["全体サイズ(境界不連続)"] = 9, ["全体サイズ(拡縮あり)"] = 10, };
	---PI で画像中間ループの「幅指定」「高さ指定」指定を適用する．
	---このパラメタは次の形式で指定されているものとする:
	---
	---`--select@unit_x:幅指定=0,回数=0,サイズ(近似)=1,サイズ(上限)=2,サイズ(下限)=3,サイズ(境界不連続)=4,サイズ(拡縮あり)=5,全体サイズ(近似)=6,全体サイズ(上限)=7,全体サイズ(下限)=8,全体サイズ(境界不連続)=9,全体サイズ(拡縮あり)=10`
	---@param pi_value any PI に渡ってきた値．
	---@param gui_value inner_loop_size 実際にスクリプトのパラメタとして渡ってきた値．
	---@return inner_loop_size
	function PI_choose_inner_loop_size(pi_value, gui_value)
		if type(pi_value) == "string" then
			gui_value = size_name2num[pi_value] or gui_value;
		end
		return math_min(math_max(math_floor(0.5 + gui_value), 0), 10);
	end

	---@alias inner_loop_mode
	---|`0` ループ
	---|`1` ミラー
	---|`2` ミラー(半ピクセル端)
	---|`3` 引き伸ばし
	local mode_name2num = { ["ループ"] = 0, ["ミラー"] = 1, ["ミラー(半ピクセル端)"] = 2, ["引き伸ばし"] = 3, };
	---PI で画像中間ループの「ループX」「ループY」指定を適用する．
	---このパラメタは次の形式で指定されているものとする:
	---
	---`--select@loop_x:ループX=0,ループ=0,ミラー=1,ミラー(半ピクセル端)=2,引き伸ばし=3`
	---@param pi_value any PI に渡ってきた値．
	---@param gui_value inner_loop_mode 実際にスクリプトのパラメタとして渡ってきた値．
	---@return inner_loop_mode
	function PI_choose_inner_loop_mode(pi_value, gui_value)
		if type(pi_value) == "string" then
			gui_value = mode_name2num[pi_value] or gui_value;
		end
		return math_min(math_max(math_floor(0.5 + gui_value), 0), 3);
	end
end

local PI_choose_blend_mode do
	local name2num, num2code = {
		["通常"] = 0, ["加算"] = 1, ["減算"] = 2, ["乗算"] = 3, ["スクリーン"] = 4, ["オーバーレイ"] = 5,
		["比較(明)"] = 6, ["比較(暗)"] = 7, ["輝度"] = 8, ["色差"] = 9,
		["陰影"] = 10, ["明暗"] = 11, ["差分"] = 12,
		["alpha_add"] = 100, ["alpha_max"] = 101, ["alpha_sub"] = 102, ["alpha_add2"] = 103, ["rgba_add"] = 104,
	}, {
		[0] = "none", "add", "sub", "mul", "screen", "overlay",
		"light", "dark", "brightness", "chroma", "shadow", "light_dark", "diff",
		[100] = "alpha_add", [101] = "alpha_max", [102] = "alpha_sub", [103] = "alpha_add2", [104] = "rgba_add",
	};

	---PI で「合成モード」指定を適用して，`obj.setoption("blend", ...)` に渡せる文字列に変換する．
	---このパラメタは次の形式で指定されているものとする:
	---
	---`--select@blend:合成モード=0,通常=0,加算=1,減算=2,乗算=3,スクリーン=4,オーバーレイ=5,比較(明)=6,比較(暗)=7,輝度=8,色差=9,陰影=10,明暗=11,差分=12`
	---
	---この他にも `"alpha_add"` などの仮想バッファ専用合成モードも `pi_value` として有効．
	---@param pi_value any PI に渡ってきた値．
	---@param gui_value integer 実際にスクリプトのパラメタとして渡ってきた値．
	---@return string # 合成モードの名前．
	function PI_choose_blend_mode(pi_value, gui_value)
		if type(pi_value) == "string" then
			gui_value = name2num[pi_value] or gui_value;
		end
		return num2code[gui_value] or "none";
	end
end

local PI_choose_tile_mode, PI_choose_composite_mode, is_composite_fixed_size do
	---@alias mode_tile
	---|`0` なし
	---|`1` 横
	---|`2` 縦
	---|`3` 縦横

	local tile_name2num = {
		["なし"] = 0, ["横"] = 1, ["縦"] = 2, ["縦横"] = 3,
	};
	---PI で合成系のスクリプトの「画像ループ」指定を適用する．
	---このパラメタは次の形式で指定されているものとする:
	---
	---`--select@mode_tile:画像ループ=0,なし=0,横=1,縦=2,縦横=3`
	---@param pi_value any PI に渡ってきた値．
	---@param gui_value mode_tile 実際にスクリプトのパラメタとして渡ってきた値．
	---@return mode_tile # 「画像ループ」の数値．
	function PI_choose_tile_mode(pi_value, gui_value)
		if type(pi_value) == "string" then
			gui_value = tile_name2num[pi_value] or gui_value;
		end
		return math_min(math_max(math_floor(0.5 + gui_value), 0), 3);
	end

	---@alias mode_composite
	---|`0` 前方から合成
	---|`1` 前方から合成(クリッピング)
	---|`2` 後方から合成
	---|`3` 後方から合成(クリッピング)
	---|`4` アルファ値を乗算
	---|`5` 色情報を上書き
	---|`6` 輝度をアルファ値として上書き
	---|`7` 輝度をアルファ値として乗算

	local comp_name2num = {
		["前方から合成"] = 0, ["前方から合成(クリッピング)"] = 1,
		["後方から合成"] = 2, ["後方から合成(クリッピング)"] = 3,
		["アルファ値を乗算"] = 4, ["色情報を上書き"] = 5,
		["輝度をアルファ値として上書き"] = 6, ["輝度をアルファ値として乗算"] = 7,
	};
	---PI で合成系のスクリプトの「モード」指定を適用する．
	---このパラメタは次の形式で指定されているものとする:
	---
	---`--select@mode_draw:モード=0,前方から合成=0,前方から合成(クリッピング)=1,後方から合成=2,後方から合成(クリッピング)=3,アルファ値を乗算=4,色情報を上書き=5,輝度をアルファ値として上書き=6,輝度をアルファ値として乗算=7`
	---@param pi_value any PI に渡ってきた値．
	---@param gui_value mode_composite 実際にスクリプトのパラメタとして渡ってきた値．
	---@return mode_composite # 「モード」の数値．
	function PI_choose_composite_mode(pi_value, gui_value)
		if type(pi_value) == "string" then
			gui_value = comp_name2num[pi_value] or gui_value;
		end
		return math_min(math_max(math_floor(0.5 + gui_value), 0), 7);
	end

	---合成系スクリプトの「画像ループ」や「モード」の状況が，「サイズ固定」の必要があるかどうかを判定．
	---@param mode_tile mode_tile
	---@param mode_composite mode_composite
	---@return boolean # 固定サイズの必要があるかどうか．
	function is_composite_fixed_size(mode_tile, mode_composite)
		return mode_tile ~= 0 or (mode_composite == 1 or mode_composite >= 4);
	end
end

---サイズと縦横比から幅と高さを計算する．
---@param size number サイズ．
---@param aspect number 縦横比，正で縦長，負で横長，-1.0 -- 1.0.
---@return number width, number height 求める幅と高さ．
local function size_from_aspect(size, aspect)
	return math_min(1 - aspect, 1) * size, math_min(1 + aspect, 1) * size;
end

---`--color@...` 指定での色を RGBA に分解する．`nil` に対しては完全透明色として扱う．
---@param color integer? 色を `0xRRGGBB` の形で表す整数．
---@return number R, number G, number B, number A それぞれ色の R, G, B, A 成分．
local function rgba_color_opt(color)
	if color then
		return
			bit_band(color, 0xff0000) / 0xff0000,
			bit_band(color, 0x00ff00) / 0x00ff00,
			bit_band(color, 0x0000ff) / 0x0000ff, 1;
	else return 0, 0, 0, 0 end
end
--#endregion parameter helpers.


--#region helper functions.

---saves the fields of `obj` that are discarded when `obj.load()` is called.
---@return table # a table that contains properties. this can be reused in `load_obj_props()`.
local function save_obj_props()
	return { obj.ox, obj.oy, obj.oz, obj.cx, obj.cy, obj.cz, obj.rx, obj.ry, obj.rz, obj.sx, obj.sy, obj.sz, obj.alpha };
end
---restores fields of `obj` by the table returned from `save_obj_props()`.
---@param obj_props table the return value of `save_obj_props()` containing fields of `obj` that were possibly discarded.
local function load_obj_props(obj_props)
	obj.ox, obj.oy, obj.oz, obj.cx, obj.cy, obj.cz, obj.rx, obj.ry, obj.rz, obj.sx, obj.sy, obj.sz, obj.alpha = unpack(obj_props);
end

---画像サイズを変更するとき，最大画像サイズを超えないように頭打ちをかける．無駄に切り取らず，なるべく中央に配置，変化も連続になるように計算する．
---@param L number 画像の左端の座標．
---@param R number 画像の右端の座標．
---@param T number 画像の上端の座標．
---@param B number 画像の下端の座標．
---@return number L1,number R1,number T1,number B1 補正結果．
local function limit_image_extent(L, R, T, B)
	-- cap to the maximum size.
	if R - L > image_max_w then
		if L > -image_max_w / 2 then R = L + image_max_w;
		elseif R < image_max_w / 2 then L = R - image_max_w;
		else
			L = L + math_ceil((R - L - image_max_w) / 2);
			R = L + image_max_w;
		end
	end
	if B - T > image_max_h then
		if T > -image_max_h / 2 then B = T + image_max_h;
		elseif B < image_max_h / 2 then T = B - image_max_h;
		else
			T = T + math_ceil((B - T - image_max_h) / 2);
			B = T + image_max_h;
		end
	end
	return L, R, T, B;
end

---スクリプトのエラーメッセージを，AviUtl2 標準の書式を真似て出力．
---@param err_mes string エラーメッセージ．
---@param source string エラーを発したスクリプトコード．
local function print_script_error(err_mes, source)
	local n, err_desc = err_mes:match("%]:(%d+):%s(.-)$");
	n = tonumber(n);
	if n and err_desc then
		-- collect three lines containing the one that caused the error.
		n = math_max(n - 1, 1);
		local k = 0;
		for l in (source.."\n"):gmatch("(.-)\n") do
			k = k + 1;
			if k >= n then
				err_desc = err_desc.."\n> "..l;
				if k >= n + 2 then break end
			end
		end
	else err_desc = err_mes end
	print(err_desc); -- easy-to-read message.
	print("@warn", err_mes); -- raw message.
end

---ユーザー入力のスクリプトを実行する．エラーが起きた場合は相応の書式でログに出力する．
---@param source string ソースコード．
---@return boolean code エラーなく終了した場合は true, エラーが起きた場合は false.
local function execute_user_script(source)
	local f, c, e = nil, false, nil;
	f, e = loadstring(source);
	if f then c, e = pcall(f) end
	if not c then
		print_script_error(tostring(e), source);
		return false;
	end
	return true;
end

local execute_text_script do
	local subst_callback = nil;

	---ユーザー入力のテキスト内の `<?---?>` 形式のスクリプトを実行して，テキストを補間する．
	---@param text string ユーザー入力のテキスト．`<?---?>` 形式の部分は，そのスクリプト実行で置き換えられる．
	---@return string # 補間した結果のテキスト
	function execute_text_script(text)
		if not subst_callback then
			if not text:find("<%?.-%?>") then return text end

			-- prepare an environment for inner functions.
			local mes_data, inner_G, inner_obj = "", {}, {};
			local function inner_mes(s)
				if type(s) == "string" or type(s) == "number" then
					mes_data = mes_data..s;
				else
					error("bad argument #1 to 'mes' (string expected, got "..type(s)..")", 2);
				end
			end
			inner_G._G, inner_G.obj, inner_G.mes, inner_obj.mes = inner_G, inner_obj, inner_mes, inner_mes;
			setmetatable(inner_G, { __index = _G, __newindex = _G });
			setmetatable(inner_obj, { __index = obj, __newindex = obj });

			-- callback function for string.gsub().
			subst_callback = function(script)
				if script ~= "" then
					-- "<?=...?>" is converted to "<?mes(...)?>".
					if script:sub(1, 1) == "=" then
						script = "mes("..script:sub(2)..")";
					end

					local f, c, e;
					f, e = loadstring(script);
					if f then
						mes_data = "";
						c, e = pcall(setfenv(f, inner_G));
						if c then return mes_data end -- successful.
					end
					print_script_error(tostring(e), script); -- error.
				end
				return "";
			end
		end
		return (text:gsub("<%?(.-)%?>", subst_callback));
	end
end

---現在オブジェクトの画像を破棄．`return void_return()` で無効化して早期 return できる．
local function void_return() obj.load("text", "") end

---現在オブジェクト (または指定のバッファ) に対して，指定のアルファ値を乗算する．
---@param alpha number 乗算するアルファ値．
---@param target string? バッファ名 (`"tempbuffer"` など). 省略時は現在オブジェクト．
local function apply_alpha(alpha, target)
	if alpha == 0 then obj.clearbuffer(target or "object");
	elseif alpha ~= 1 then obj.pixelshader("const_alpha@透明度適用@Basic_S", target or "object", nil, { alpha }, "mask") end
end

---現在オブジェクト (または指定のバッファ) に対して，四隅丸めを適用する．値の型や範囲チェックは行われないので，事前に指定範囲内の保証をしておくこと．
---@param radii round_corners_radii_set 四隅の丸め半径を指定．
---@param shapes round_corners_shape_set 四隅の丸め形状を指定．
---@param line number ライン幅を指定．0 以上．
---@param fixed_aspect boolean サイズが小さい場合に合わせて半径を縮小するとき，縦横比を維持するかどうか．
---@param cache_name string? バッファ名 (`"tempbuffer"` など). 省略時は現在オブジェクト．
---@param width integer? バッファの幅を指定．`cache_name` 指定時は必須．
---@param height integer? バッファの高さを指定．`cache_name` 指定時は必須．
local function round_corners_buff(radii, shapes, line, fixed_aspect, cache_name, width, height)
	if not (cache_name and width and height) then
		cache_name, width, height = "object", obj.w, obj.h;
	end

	-- early return if not effective.
	if 2 * line + 1 >= math_min(width, height) and math_max(
		math_min(radii[1][1], radii[1][2]),
		math_min(radii[2][1], radii[2][2]),
		math_min(radii[3][1], radii[3][2]),
		math_min(radii[4][1], radii[4][2])) <= 0 then return end

	-- avoid corner sizes from being too large.
	local modified = {
		{ radii[1][1], radii[1][2] },
		{ radii[2][1], radii[2][2] },
		{ radii[3][1], radii[3][2] },
		{ radii[4][1], radii[4][2] },
	};
	for i = 1, 4 do
		local j, r1, r2, m = 2 - (i % 2),
			modified[i], modified[(i % 4) + 1],
			(i % 2) > 0 and width or height;
		if r1[j] + r2[j] >= m then
			local c1, c2 = r1[j], r2[j];
			if c1 <= m / 2 then c2 = m - c1;
			elseif c2 <= m / 2 then c1 = m - c2;
			else c1, c2 = m / 2, m / 2 end
			r1[j], r2[j] = c1, c2;
		end
	end

	-- adjust aspect ratios if specified to be fixed.
	if fixed_aspect then
		for i = 1, 4 do
			local r, r0 = modified[i], radii[i];
			local u, v = r[1] * r0[2], r[2] * r0[1];
			if u > v then r[1] = v / r0[2];
			elseif u < v then r[2] = u / r0[1] end
		end
	end

	-- apply shader.
	obj.pixelshader("carve@四隅丸め@Basic_S", cache_name, nil, {
		modified[1][1], modified[1][2], shapes[1], 0;
		modified[2][1], modified[2][2], shapes[2], 0;
		modified[3][1], modified[3][2], shapes[3], 0;
		modified[4][1], modified[4][2], shapes[4], 0;
		width, height; line;
	}, "mask");
end


---領域拡張やクリッピングを利用してサイズを変更する．4000 上限を配慮．
---@param add_L integer 左の拡大ピクセル数．正で領域拡張，負でクリッピング．
---@param add_R integer 右の拡大ピクセル数．正で領域拡張，負でクリッピング．
---@param add_T integer 上の拡大ピクセル数．正で領域拡張，負でクリッピング．
---@param add_B integer 下の拡大ピクセル数．正で領域拡張，負でクリッピング．
---@param move_center boolean? "中心の位置を変更" に相当．省略時は true.
---@param fill boolean? "塗りつぶし" に相当．省略時は false.
local function add_canvas_size(add_L, add_R, add_T, add_B, move_center, fill)
	if move_center == false then
		obj.cx, obj.cy = obj.cx + (add_L - add_R) / 2, obj.cy + (add_T - add_B) / 2;
	end

	local W, H = obj.w + add_L + add_R, obj.h + add_T + add_B;
	if W <= 0 or H <= 0 then
		-- empty while keeping properties such as `obj.ox`.
		obj.effect("リサイズ", "X", 0);
		return;
	elseif math_min(add_L, add_R) <= -obj.w or math_min(add_T, add_B) <= -obj.h then
		if fill ~= true then
			obj.clearbuffer("object", W, H);
			return;
		end
		local L, R, T, B =
			math_max(add_L, -(obj.w - 1)), math_max(add_R, -(obj.w - 1)),
			math_max(add_T, -(obj.h - 1)), math_max(add_B, -(obj.h - 1));
		add_L, add_R, add_T, add_B =
			add_R + L - R, add_L - L + R, add_B + T - B, add_T - T + B;
	end

	while add_L < 0 or add_R < 0 or add_T < 0 or add_B < 0 do
		local L, R, T, B =
			math_min(math_max(add_L, -4000), 0), math_min(math_max(add_R, -4000), 0),
			math_min(math_max(add_T, -4000), 0), math_min(math_max(add_B, -4000), 0);
		add_L, add_R, add_T, add_B = add_L - L, add_R - R, add_T - T, add_B - B;
		obj.effect("クリッピング", "左", -L, "右", -R, "上", -T, "下", -B, "中心の位置を変更", 1);
	end
	while add_L > 0 or add_R > 0 or add_T > 0 or add_B > 0 do
		local L, R, T, B =
			math_min(math_max(add_L, 0), 4000), math_min(math_max(add_R, 0), 4000),
			math_min(math_max(add_T, 0), 4000), math_min(math_max(add_B, 0), 4000);
		add_L, add_R, add_T, add_B = add_L - L, add_R - R, add_T - T, add_B - B;
		obj.effect("領域拡張", "左", L, "右", R, "上", T, "下", B, "塗りつぶし", fill == true and 1 or 0);
	end
end

---オブジェクトの回転中心を (`obj.getvalue("center")` なども加味して) 指定座標に設定する．オプションで `obj.ox` も操作してオブジェクトの位置を変更しないようにもできる．
---@param cx number 中心の X 座標．
---@param cy number 中心の Y 座標．
---@param cz number 中心の Z 座標．
---@param fix_pos boolean? オブジェクトの位置を固定するかどうかを指定．省略時は `false`.
local function set_rotation_center(cx, cy, cz, fix_pos)
	local cx0, cy0, cz0 = obj.getvalue("center");
	cx, cy, cz = cx - cx0, cy - cy0, cz - cz0;

	if fix_pos then
		local sx, sy, sz = obj.getvalue("scale");
		local rx, ry, rz = obj.getvalue("angle");
		sx, sy, sz, rx, ry, rz =
			obj.sx * sx, obj.sy * sy, obj.sz * sz,
			math_tau * (((obj.rx + rx) / 360) % 1),
			math_tau * (((obj.ry + ry) / 360) % 1),
			math_tau * (((obj.rz + rz) / 360) % 1);
		local c_x, s_x, c_y, s_y, c_z, s_z =
			math_cos(rx), math_sin(rx), math_cos(ry), math_sin(ry), math_cos(rz), math_sin(rz);
		local dx, dy, dz = cx - obj.cx, cy - obj.cy, cz - obj.cz;
		dx, dy, dz = sx * dx, sy * dy, sz * dz;
		dx, dy = c_z * dx - s_z * dy, s_z * dx + c_z * dy;
		dz, dx = c_y * dz - s_y * dx, s_y * dz + c_y * dx;
		dy, dz = c_x * dy - s_x * dz, s_x * dy + c_x * dz;

		-- apply.
		obj.ox,	obj.oy,	obj.oz = obj.ox + dx, obj.oy + dy, obj.oz + dz;
	end
	obj.cx,obj.cy,obj.cz = cx, cy, cz;
end

---合成系スクリプトの中核関数．2つのバッファを指定の位置や合成モードなどで合成する．
---
---- 現在オブジェクトには合成元 (外から取り入れた画像)，一時キャッシュの `dest_name` には合成先 (元画像) が格納されているものとする．
---- 以下のバッファの内容は変更される可能性がある: `"object"`, `"tempbuffer"`, `dest_name`.
---- 合成結果は `"object"` に格納される．
---@param dest_w integer 合成先 (元画像) のピクセル幅．
---@param dest_h integer 合成先 (元画像) のピクセル高さ．
---@param dest_name string 合成先 (元画像) を保存している一時キャッシュの名前 (`"cache:..."` の形式).
---@param move_x number X 移動量．
---@param move_y number Y 移動量．
---@param zoom_x number X 方向の拡大率．
---@param zoom_y number Y 方向の拡大率．
---@param rotate number 回転角度，ラジアン単位．
---@param intensity number 合成時のアルファ値 (強さ).
---@param fixed_size boolean 固定サイズかどうか．一部の合成手順等の条件では true 扱いで処理される．
---@param no_smooth boolean 合成時に補間処理をするかどうかを指定．
---@param mode_tile mode_tile 繰り返しモード．
---@param mode_composite mode_composite 合成手順．
---@param mode_blend string 合成モード (`"add"` など).
---@return number dcx, number dcy 領域拡張に伴う回転中心座標の移動量．
local function composite_core(dest_w, dest_h, dest_name, move_x, move_y, zoom_x, zoom_y, rotate, intensity, fixed_size, no_smooth, mode_tile, mode_composite, mode_blend)
	local src_w, src_h, dcx, dcy = obj.w, obj.h, 0, 0;

	-- determine the canvas size.
	local c, s = math_cos(rotate), math_sin(rotate);
	local L, R, T, B = -dest_w / 2, dest_w / 2, -dest_h / 2, dest_h / 2;
	fixed_size = fixed_size or is_composite_fixed_size(mode_tile, mode_composite);
	if not fixed_size then
		L, T = zoom_x * math_abs(c) * src_w + zoom_y * math_abs(s) * src_h, zoom_x * math_abs(s) * src_w + zoom_y * math_abs(c) * src_h;
		L, R, T, B = move_x - L / 2, move_x + L / 2, move_y - T / 2, move_y + T / 2;
		L, R = math_floor(math_min(L + dest_w / 2, 0)) - dest_w / 2, math_ceil(math_max(R + dest_w / 2, dest_w)) - dest_w / 2;
		T, B = math_floor(math_min(T + dest_h / 2, 0)) - dest_h / 2, math_ceil(math_max(B + dest_h / 2, dest_h)) - dest_h / 2;
		dcx, dcy = -(L + R) / 2, -(T + B) / 2;
	end

	-- process rotate / zoom / tile.
	if intensity > 0 then
		obj.clearbuffer("tempbuffer", R - L, B - T);
		if zoom_x > 0 and zoom_y > 0 and src_w > 0 and src_h > 0 then
			obj.pixelshader("tile@画像ファイル合成@Basic_S", "tempbuffer", "object", {
				src_w, src_h;
				(c * (L - move_x) + s * (T - move_y)) / zoom_x + src_w / 2,
				(-s * (L - move_x) + c * (T - move_y)) / zoom_y + src_h / 2;
				c / zoom_x, -s / zoom_y, 0, 0,
				s / zoom_x, c / zoom_y;
				mode_tile % 2, math_floor(mode_tile / 2);
				no_smooth and 1 or 0;
			});
		end
	end

	if intensity > 0 then
		if mode_composite < 2 then
			-- 前方から合成 or 前方から合成(クリッピング)
			obj.setoption("drawtarget", "tempbuffer");
			if L < -dest_w / 2 or R > dest_w / 2 or T < -dest_h / 2 or B > dest_h / 2 then
				obj.copybuffer("object", dest_name);
				add_canvas_size(-L - dest_w / 2, R - dest_w / 2, -T - dest_h / 2, B - dest_h / 2);
				obj.copybuffer(dest_name, "object");
			end
			obj.copybuffer("object", "tempbuffer");
			obj.copybuffer("tempbuffer", dest_name);

			if mode_composite > 0 then
				-- unalpha
				obj.pixelshader("unalpha@画像ファイル合成@Basic_S", "tempbuffer", dest_name);
			end

			obj.setoption("blend", mode_blend);
			obj.draw(0, 0, 0, 1, intensity);
			obj.setoption("blend");
			obj.copybuffer("object", "tempbuffer");

			if mode_composite > 0 then
				-- re-alpha
				obj.pixelshader("mask@画像ファイル合成@Basic_S", "object", dest_name, { 1 }, "mask");
			end
		elseif mode_composite < 4 then
			-- 後方から合成 or 後方から合成(クリッピング)
			obj.setoption("drawtarget", "tempbuffer");
			apply_alpha(intensity, "tempbuffer");
			obj.copybuffer("object", dest_name);

			if mode_composite > 2 then
				-- unalpha
				obj.copybuffer(dest_name, "tempbuffer");
				obj.pixelshader("unalpha@画像ファイル合成@Basic_S", "tempbuffer", dest_name);
			end

			obj.setoption("blend", mode_blend);
			obj.draw(dcx, dcy);
			obj.setoption("blend");
			obj.copybuffer("object", "tempbuffer");

			if mode_composite > 2 then
				-- re-alpha
				obj.pixelshader("mask@画像ファイル合成@Basic_S", "object", dest_name, { 1 }, "mask");
			end
		else
			obj.copybuffer("object", dest_name);
			if mode_composite == 4 then
				-- アルファ値を乗算
				obj.pixelshader("mask@画像ファイル合成@Basic_S", "object", "tempbuffer", { intensity }, "mask");
			elseif mode_composite == 5 then
				-- 色情報を上書き
				obj.pixelshader("replace_col@画像ファイル合成@Basic_S", "object", { dest_name, "tempbuffer" }, { intensity });
			elseif mode_composite == 6 then
				-- 輝度をアルファ値として上書き
				obj.pixelshader("luma_as_alpha@画像ファイル合成@Basic_S", "object", { dest_name, "tempbuffer" }, { intensity });
			elseif mode_composite >= 7 then
				-- 輝度をアルファ値として乗算
				obj.pixelshader("mask_by_luma@画像ファイル合成@Basic_S", "object", "tempbuffer", { intensity }, "mask");
			end
		end
	else -- alpha <= 0
		if mode_composite < 2 then
			-- 前方から合成 or 前方から合成(クリッピング)
			obj.copybuffer("object", dest_name);
			add_canvas_size(-L - dest_w / 2, R - dest_w / 2, -T - dest_h / 2, B - dest_h / 2);
		elseif mode_composite == 2 then
			-- 後方から合成
			obj.setoption("drawtarget", "tempbuffer", R - L, B - T);
			obj.copybuffer("object", dest_name);
			obj.setoption("blend", mode_blend);
			obj.draw(dcx, dcy);
			obj.setoption("blend");
			obj.copybuffer("object", "tempbuffer");
		elseif mode_composite == 3 then
			-- 後方から合成(クリッピング)
			obj.clearbuffer("object", R - L, B - T);
		elseif mode_composite == 4 then
			-- アルファ値を乗算
			obj.clearbuffer("object", dest_w, dest_h);
		else
			-- 色情報を上書き, 輝度をアルファ値として上書き or 輝度をアルファ値として乗算
			obj.copybuffer("object", dest_name);
		end
	end

	return dcx, dcy;
end
--#endregion helper functions.


--#region actual processes for filters.
local
	round_corners, -- 四隅丸め
	back_round_rect, -- 背景角丸矩形
	rotate_any_axis, -- 任意軸追加回転
	cut_move, -- カットずらし
	inner_loop, -- 画像中間ループ
	prec_blur, -- 小数ぼかし
	_;

---四隅丸めの実体関数．値の型や範囲チェックは行われないので，事前に指定範囲内の保証をしておくこと．
---@param radii round_corners_radii_set 四隅の丸め半径を指定．
---@param shapes round_corners_shape_set 四隅の丸め形状を指定．
---@param line number ライン幅を指定．0 以上．
---@param fixed_aspect boolean サイズが小さい場合に合わせて半径を縮小するとき，縦横比を維持するかどうか．
function round_corners(radii, shapes, line, fixed_aspect)
	-- TODO: add a parameter "inner alpha", so the area inside the line can be semi-transparent.
	round_corners_buff(radii, shapes, line, fixed_aspect, "object", obj.w, obj.h)
end

---背景角丸矩形の実体関数．値の型や範囲チェックは行われないので，事前に指定範囲内の保証をしておくこと．
---@param pad_L integer 左の余白サイズ，範囲指定なし．
---@param pad_R integer 右の余白サイズ，範囲指定なし．
---@param pad_T integer 上の余白サイズ，範囲指定なし．
---@param pad_B integer 下の余白サイズ，範囲指定なし．
---@param line number ライン幅を指定．0 以上．
---@param clip `0`|`1`|`2` クリッピング．0 -> なし，1 -> あり，2 -> ライン内．
---@param alpha_fore number 前景の不透明度，0.0 -- 1.0.
---@param color_line number ライン部分の色．`image_line` が読めなかったときにも使われる．
---@param image_line string ライン部分の画像ファイルのパス．
---@param alpha_line number number ライン部分の不透明度，0.0 -- 1.0.
---@param pos_image_line_x integer ライン部分の画像の X 方向位置ずれ．範囲指定なし．
---@param pos_image_line_y integer ライン部分の画像の Y 方向位置ずれ．範囲指定なし．
---@param color_back number ライン内側の色．`image_back` が読めなかったときにも使われる．
---@param image_back string ライン内側の画像ファイルのパス．
---@param alpha_back number ライン内側の不透明度，0.0 -- 1.0.
---@param pos_image_back_x integer ライン内側の画像の X 方向位置ずれ．範囲指定なし．
---@param pos_image_back_y integer ライン内側の画像の Y 方向位置ずれ．範囲指定なし．
---@param radii round_corners_radii_set 四隅の丸め半径を指定．
---@param shapes round_corners_shape_set 四隅の丸め形状を指定．
---@param fixed_aspect boolean サイズが小さい場合に合わせて半径を縮小するとき，縦横比を維持するかどうか．
function back_round_rect(pad_L, pad_R, pad_T, pad_B, line, clip, alpha_fore,
	color_line, image_line, alpha_line, pos_image_line_x, pos_image_line_y,
	color_back, image_back, alpha_back, pos_image_back_x, pos_image_back_y,
	radii, shapes, fixed_aspect)

	if line < 0 then
		line, pad_L, pad_R, pad_T, pad_B =
			-line, pad_L - line, pad_R - line, pad_T - line, pad_B - line;
	end
	local w, h = obj.w, obj.h;
	local W, H = pad_L + w + pad_R, pad_T + h + pad_B;
	if (W <= 0 or H <= 0) and clip == 0 then return apply_alpha(alpha_fore) end
	local L, R, T, B if clip == 0 then
		L, R, T, B =
			math_max(pad_L, 0), math_max(pad_R, 0),
			math_max(pad_T, 0), math_max(pad_B, 0);
	else L, R, T, B = pad_L, pad_R, pad_T, pad_B end
	if L + w + R <= 0 or T + h + B <= 0 then return void_return() end

	local big_radius = math_max(W, H) + 1;
	if line <= 0 then
		-- eliminate the case where line is empty.
		line, alpha_line, color_line, image_line, pos_image_line_x, pos_image_line_y =
			big_radius, alpha_back, color_back, image_back, pos_image_back_x, pos_image_back_y;
		if clip == 2 then clip = 1 end
	end

	local do_fill = 2 * line - 1 >= math_min(W, H);
	if clip == 0 and alpha_line <= 0 and (do_fill or alpha_back <= 0) then
		-- nothing is drawn but only the canvas extends.
		add_canvas_size(math_max(L, 0), math_max(R, 0), math_max(T, 0), math_max(B, 0), false);
		return;
	end

	-- make effect.
	local cache_src, cache_back, cache_line, cache_back_image, cache_line_image =
		"cache:basic_s/backrect/obj", "cache:basic_s/backrect/bkg", "cache:basic_s/backrect/lin",
		"cache:basic_s/backrect/bkg_i", "cache:basic_s/backrect/lin_i";
	local size_image_line_x, size_image_line_y, size_image_back_x, size_image_back_y, has_image_line, has_image_back =
		1, 1, 1, 1, #image_line >= 4 and alpha_line > 0, #image_back >= 4 and not do_fill and alpha_back > 0;

	-- backup the current object.
	obj.copybuffer(cache_src, "object");

	-- try to loading the images if specified.
	if has_image_line or has_image_back then
		local obj_props = save_obj_props();

		-- line image.
		if has_image_line and obj.load("image", image_line) then
			obj.copybuffer(cache_line_image, "object");
			size_image_line_x, size_image_line_y = obj.w, obj.h;
		else
			obj.clearbuffer(cache_line_image, 1, 1, color_line);
			has_image_line = false;
		end

		-- back image.
		if has_image_back and image_back == image_line then
			-- reuse the one that is already loaded.
			cache_back_image, has_image_back, size_image_back_x, size_image_back_y =
				cache_line_image, has_image_line, size_image_line_x, size_image_line_y;
		elseif has_image_back and obj.load("image", image_back) then
			obj.copybuffer(cache_back_image, "object");
			size_image_back_x, size_image_back_y = obj.w, obj.h;
			obj.load("image", image_back);
		else
			obj.clearbuffer(cache_back_image, 1, 1, color_back);
			has_image_back = false;
		end

		load_obj_props(obj_props);
	end

	if clip ~= 2 and alpha_line == alpha_back then
		-- suppress unnecessary background.
		local no_chrome = color_line == color_back;
		if has_image_line or has_image_back then
			no_chrome = image_line == image_back and pos_image_line_x == pos_image_back_x and pos_image_line_y == pos_image_back_y;
		end
		if no_chrome then line, do_fill = big_radius, true end
	end

	-- render the "line" part.
	obj.clearbuffer(cache_line, W, H, 0x000000);
	round_corners_buff(radii, shapes, line, fixed_aspect, cache_line, W, H);

	-- render the "background" part if necessary.
	if not do_fill then
		obj.clearbuffer(cache_back, W, H, 0x000000);
		round_corners_buff(radii, shapes, big_radius, fixed_aspect, cache_back, W, H);
	else cache_back = cache_line end

	-- combine them by shader.
	obj.clearbuffer("object", L + w + R, T + h + B);
	if has_image_line or has_image_back then
		obj.pixelshader("combine_img@背景角丸矩形@Basic_S", "object",
			{ cache_src, cache_line, cache_back, cache_line_image, cache_back_image }, {
			L, T; L - pad_L, T - pad_T;
			alpha_fore; alpha_line; alpha_back;
			clip;

			size_image_line_x, size_image_line_y; size_image_back_x, size_image_back_y;
			math_floor(W / 2) + pos_image_line_x, math_floor(H / 2) + pos_image_line_y;
			math_floor(W / 2) + pos_image_back_x, math_floor(H / 2) + pos_image_back_y;
		});
	else
		local r_line, g_line, b_line, a_line = rgba_color_opt(color_line);
		local r_back, g_back, b_back, a_back = rgba_color_opt(color_back);
		obj.pixelshader("combine@背景角丸矩形@Basic_S", "object",
			{ cache_src, cache_line, cache_back }, {
			L, T; L - pad_L, T - pad_T;
			alpha_fore; alpha_line; alpha_back;
			clip;

			r_line, g_line, b_line, a_line;
			r_back, g_back, b_back, a_back;
		});
	end

	-- adjust the center.
	obj.cx, obj.cy = obj.cx + (L - R) / 2, obj.cy + (T - B) / 2;
end

---任意軸追加回転の実体関数．値の型や範囲チェックは行われないので，事前に指定範囲内の保証をしておくこと．
---@param angle number 角度，nan, infty 以外．
---@param X number 回転軸X，0 ベクトル以外．
---@param Y number 回転軸Y，0 ベクトル以外．
---@param Z number 回転軸Z，0 ベクトル以外．
---@param draw boolean 描画する．
---@param group_control boolean グループ制御．
---@param is_axis_local boolean `X`, `Y`, `Z` による軸の座標が，オブジェクトの局所座標での指定かどうか (`not PI.fix_axis` に相当).
function rotate_any_axis(angle, X, Y, Z, draw, group_control, is_axis_local)
	local cx, cy, cz = obj.getvalue("center");
	local rx, ry, rz = obj.getvalue("angle");
	cx, cy, cz, rx, ry, rz =
		obj.cx + cx, obj.cy + cy, obj.cz + cz,
		math_tau * (((obj.rx + rx) / 360) % 1),
		math_tau * (((obj.ry + ry) / 360) % 1),
		math_tau * (((obj.rz + rz) / 360) % 1);

	-- rotate the axis.
	if is_axis_local then
		local sx, sy, sz = obj.getvalue("scale");
		X, Y, Z = angle_euler_apply(
			obj.sx * sx * X, obj.sy * sy * Y, obj.sz * sz * Z, rx, ry, rz);
	end
	if X == 0 and Y == 0 and Z == 0 then X, Y, Z = 0, 0, 1 end -- defaults Z-axis.

	-- determine the quaternion that represents the rotation.
	local qr, qi, qj, qk = angle_axis_to_quat(X, Y, Z, angle);
	qr, qi, qj, qk = quat_mult(qr, qi, qj, qk, angle_euler_to_quat(rx, ry, rz));

	if draw then
		-- transform vertices.
		local sx, sy, sz = obj.getvalue("scale");
		sx, sy, sz, obj.sx, obj.sy, obj.sz =
			obj.sx * sx, obj.sy * sy, obj.sz * sz,
			1 / sx, 1 / sy, 1 / sz;
		local ox, oy, oz = obj.getvalue("pos");
		ox, oy, oz = obj.ox + ox, obj.oy + oy, obj.oz + oz;
		local gx, gy, gz = 0, 0, oz; if group_control then gx, gy, gz = ox, oy, oz + obj.z end
		local pts = {
			-obj.w / 2, -obj.h / 2, 0,
			 obj.w / 2, -obj.h / 2, 0,
			 obj.w / 2,  obj.h / 2, 0,
			-obj.w / 2,  obj.h / 2, 0,
		};
		local mat = { angle_quat_to_matrix(qr, qi, qj, qk) };
		local L, R, T, B;
		for i = 1, 4 do
			-- transform.
			local x, y, z =
				sx * (pts[3 * i - 2] - cx),
				sy * (pts[3 * i - 1] - cy),
				sz * (pts[3 * i    ] - cz);
			x, y, z =
				mat[1] * x + mat[2] * y + mat[3] * z + gx,
				mat[4] * x + mat[5] * y + mat[6] * z + gy,
				mat[7] * x + mat[8] * y + mat[9] * z + gz;
			pts[3 * i - 2], pts[3 * i - 1], pts[3 * i] = x, y, z;

			-- find the position on the canvas.
			local zx, zy, zz =
				(ox - gx) + obj.screen_w / 2,
				(oy - gy) + obj.screen_h / 2,
				1 + z / 1024;
			if zz > 0 then zx, zy = zx + x / zz, zy + y / zz;
			else
				zx, zy =
					(x > 0 and 1 or x < 0 and -1 or 0) * image_max_w + ox + obj.screen_w / 2,
					(y > 0 and 1 or y < 0 and -1 or 0) * image_max_h + oy + obj.screen_h / 2;
			end
			if i == 1 or L > zx then L = zx end
			if i == 1 or R < zx then R = zx end
			if i == 1 or T > zy then T = zy end
			if i == 1 or B < zy then B = zy end
		end
		-- canvas position is determined.
		L, R, T, B =
			math_floor(L) - ox - obj.screen_w / 2,
			math_ceil(R) - ox - obj.screen_w / 2,
			math_floor(T) - oy - obj.screen_h / 2,
			math_ceil(B) - oy - obj.screen_h / 2;

		-- cap to the maximum size.
		L, R, T, B = limit_image_extent(L, R, T, B);

		-- adjust the destination points.
		local Cx, Cy = -(L + R) / 2, -(T + B) / 2;
		for i = 1, 4 do
			local zz = 1 + pts[3 * i] / 1024;
			pts[3 * i - 2], pts[3 * i - 1] =
				pts[3 * i - 2] + zz * (Cx - gx),
				pts[3 * i - 1] + zz * (Cy - gy);
		end

		-- draw to tempbuffer.
		obj.setoption("drawtarget", "tempbuffer", R - L, B - T);
		obj.drawpoly(unpack(pts));
		obj.copybuffer("object", "tempbuffer");

		-- flatten transforms.
		obj.oz = obj.oz - gz;
		obj.cx, obj.cy, obj.cz =
			obj.cx + (Cx - cx),
			obj.cy + (Cy - cy),
			obj.cz - cz;
		obj.rx, obj.ry, obj.rz =
			obj.rx - 180 / math_pi * rx,
			obj.ry - 180 / math_pi * ry,
			obj.rz - 180 / math_pi * rz;
	else
		local Rx, Ry, Rz = angle_quat_to_euler(qr, qi, qj, qk);

		-- apply the rotation.
		obj.rx, obj.ry, obj.rz =
			obj.rx + 180 / math_pi * (Rx - rx),
			obj.ry + 180 / math_pi * (Ry - ry),
			obj.rz + 180 / math_pi * (Rz - rz);
	end
end

---カットずらしの実体関数．値の型や範囲チェックは行われないので，事前に指定範囲内の保証をしておくこと．
---@param X integer ずれX，範囲指定なし．
---@param Y integer ずれY，範囲指定なし．
---@param crack_x number 切り取り線上の 1 点の X 座標，nan, infty 以外．
---@param crack_y number 切り取り線上の 1 点の Y 座標，nan, infty 以外．
---@param crack_dx number 切り取り線の方向ベクトルの X 座標，正規化済み．
---@param crack_dy number 切り取り線の方向ベクトルの Y 座標，正規化済み．
---@param crop number 切り取り幅，nan, infty 以外．
---@param move_center boolean 中心の位置を変更．
---@param mode_padding cut_move_interpolate 余白処理．
---@param mode_overlap cut_move_interpolate 重複処理．
function cut_move(X, Y, crack_x, crack_y, crack_dx, crack_dy, crop, move_center, mode_padding, mode_overlap)
	local gap, c, mode = crop + (X * crack_dy - Y * crack_dx),
		crack_x * crack_dy - crack_y * crack_dx, mode_padding;
	if gap < 0 then
		gap, c, crop, mode = -gap, c + gap, crop - 2 * gap, mode_overlap;
	end

	-- find the canvas size.
	local L, R, T, B do
		-- determine the lines dividing the image.
		local c1, c2 = c, c + crop;
		if mode == 1 or mode == 2 then c1, c2 = c2, c1 end

		-- check for each corner.
		for i = 1, 4 do
			local x, y =
				obj.w / 2 * ((i % 2 ~= 0) and -1 or 1),
				obj.h / 2 * ((i > 2) and -1 or 1);
			local u = x * crack_dy - y * crack_dx;
			if u <= c1 then
				L, R, T, B =
					math_min(L or x, x), math_max(R or x, x),
					math_min(T or y, y), math_max(B or y, y);
			end
			if u >= c2 then
				L, R, T, B =
					math_min(L or x + X, x + X), math_max(R or x + X, x + X),
					math_min(T or y + Y, y + Y), math_max(B or y + Y, y + Y);
			end
			if mode == 3 and crop ~= 0 then
				-- include corners within the cropped band if stretching.
				local phase = (u - c1) / crop;
				if 0 <= phase and phase <= 1 then
					x, y = x + phase * X, y + phase * Y;
					L, R, T, B =
						math_min(L or x, x), math_max(R or x, x),
						math_min(T or y, y), math_max(B or y, y);
				end
			end
		end

		-- check for left and right crossing points.
		if crack_dx ~= 0 then
			local y = ((-obj.w / 2) * crack_dy - c1) / crack_dx;
			if -obj.h / 2 <= y and y <= obj.h / 2 then
				T, B = math_min(T or y, y), math_max(B or y, y);
			end
			y = ((obj.w / 2) * crack_dy - c1) / crack_dx;
			if -obj.h / 2 <= y and y <= obj.h / 2 then
				T, B = math_min(T or y, y), math_max(B or y, y);
			end
			y = ((-obj.w / 2) * crack_dy - c2) / crack_dx;
			if -obj.h / 2 <= y and y <= obj.h / 2 then
				T, B = math_min(T or y + Y, y + Y), math_max(B or y + Y, y + Y);
			end
			y = ((obj.w / 2) * crack_dy - c2) / crack_dx;
			if -obj.h / 2 <= y and y <= obj.h / 2 then
				T, B = math_min(T or y + Y, y + Y), math_max(B or y + Y, y + Y);
			end
		end

		-- check for top and bottom crossing points.
		if crack_dy ~= 0 then
			local x = ((-obj.h / 2) * crack_dx + c1) / crack_dy;
			if -obj.w / 2 <= x and x <= obj.w / 2 then
				L, R = math_min(L or x, x), math_max(R or x, x);
			end
			x = ((obj.h / 2) * crack_dx + c1) / crack_dy;
			if -obj.w / 2 <= x and x <= obj.w / 2 then
				L, R = math_min(L or x, x), math_max(R or x, x);
			end
			x = ((-obj.h / 2) * crack_dx + c2) / crack_dy;
			if -obj.w / 2 <= x and x <= obj.w / 2 then
				L, R = math_min(L or x + X, x + X), math_max(R or x + X, x + X);
			end
			x = ((obj.h / 2) * crack_dx + c2) / crack_dy;
			if -obj.w / 2 <= x and x <= obj.w / 2 then
				L, R = math_min(L or x + X, x + X), math_max(R or x + X, x + X);
			end
		end
	end
	if not (L and R and T and B) or (L >= R or T >= B) then
		-- the entire image is cropped out.
		return void_return();
	end

	-- canvas size determined.
	L, R, T, B =
		math_floor(L + obj.w / 2) - obj.w / 2,
		math_ceil(R + obj.w / 2) - obj.w / 2,
		math_floor(T + obj.h / 2) - obj.h / 2,
		math_ceil(B + obj.h / 2) - obj.h / 2;

	-- draw by shader.
	obj.clearbuffer("tempbuffer", R - L, B - T);
	obj.pixelshader("place@カットずらし@Basic_S", "tempbuffer", "object", {
		obj.w, obj.h; -L - obj.w / 2, -T - obj.h / 2 ; crack_dy, -crack_dx; X, Y;
		c - (L * crack_dy - T * crack_dx); crop; gap; mode;
	}, "copy", "clip");
	obj.copybuffer("object", "tempbuffer");

	-- adjust center.
	if not move_center then
		obj.cx, obj.cy = obj.cx - (L + R) / 2, obj.cy - (T + B) / 2;
	end
end

do -- inner_loop
	local function adjust_margin(m1, m2, sz, len, unit, loop, piv)
		if loop >= 2 then
			-- for the cases mirror (half edge) and streth,
			-- align to half pixel.
			m1, m2 = m1 + 0.5, m2 + 0.5;
		end
		-- cap margins.
		local SZ = sz + (loop == 3 and 1 or 0);
		if m1 + m2 >= SZ then
			local d = m1 + m2 - SZ;
			m1 = m1 - math_floor((d + 2) / 2);
			m2 = m2 - math_floor((d + 1) / 2);
		end

		-- adjust the mirror case, merging the final pattern to the second margin.
		local mid, pad, p0, p1 = sz - m1 - m2, 0, m1, 1;
		if loop == 1 or loop == 2 then
			pad, mid = mid, 2 * mid;
		end

		-- adjust the length.
		if unit > 0 then
			-- len is given as a bare length.
			local loc, rnd = unit < 6, (unit - 1) % 5;
			local L = math_max(len - (loc and 0 or (m1 + m2)) - (rnd < 3 and pad or 0), 0);
			if mid > 0 and rnd < 3 and loop ~= 3 then -- if not stretching.
				L = L / mid;
				L = rnd == 0 and math_floor(0.5 + L) or
					rnd == 1 and math_floor(L) or math_ceil(L);
				L = L * mid;
			end
			len = L + (rnd < 3 and pad or 0);
			if rnd >= 3 and mid > 0 and len > 0 and loop ~= 3 then
				if rnd == 3 then
					p0 = p0 + ((1 - piv) / 2) * (len - (mid - pad));
					p0 = m1 - ((m1 - p0) % mid); -- make sure p0 <= m1.
				else
					p1 = len / mid;
					local f, c = p1, pad > 0 and 0.5 or 0;
					f, c = math_floor(f - c) + c, math_ceil(f - c) + c;
					p1 = p1 * p1 < f * c and f or c; -- i.e. p1 / f < c / p1.
					p1 = p1 * mid / len;
				end
			end
		else
			-- len is given as a loop count.
			if pad > 0 then
				-- when mirroring, only odd count is accepted.
				len = math_floor((len - 1) / 2);
			end
			len = len * mid + pad;
		end

		return m1, m2, mid, p0, p1, sz - m1 - m2, len;
	end

	---画像中間ループの実体関数．値の型や範囲チェックは行われないので，事前に指定範囲内の保証をしておくこと．
	---@param width integer 幅，0 以上．
	---@param height integer 高さ，0 以上．
	---@param margin_u integer 上余白，0 以上．
	---@param margin_d integer 下余白，0 以上．
	---@param margin_l integer 左余白，0 以上．
	---@param margin_r integer 右余白，0 以上．
	---@param offset_x number オフセットX，nan, infty 以外．
	---@param offset_y number オフセットY，nan, infty 以外．
	---@param align_x number 水平揃え，-1.0 -- 1.0.
	---@param align_y number 垂直揃え，-1.0 -- 1.0.
	---@param pivot_x number ループ水平揃え，-1.0 -- 1.0.
	---@param pivot_y number ループ垂直揃え，-1.0 -- 1.0.
	---@param unit_x inner_loop_size 幅指定．
	---@param unit_y inner_loop_size 高さ指定．
	---@param loop_x inner_loop_mode ループX．
	---@param loop_y inner_loop_mode ループY．
	function inner_loop(width, height,
		margin_u, margin_d, margin_l, margin_r, offset_x, offset_y,
		align_x, align_y, pivot_x, pivot_y,
		unit_x, unit_y, loop_x, loop_y)

		if loop_x == 3 then offset_x = 0 end
		if loop_y == 3 then offset_y = 0 end
		local w, h = obj.w, obj.h;
		local mid_x, mid_y, piv0_x, piv0_y, piv1_x, piv1_y, len0_x, len0_y, len1_x, len1_y;
		margin_l, margin_r, mid_x, piv0_x, piv1_x, len0_x, len1_x = adjust_margin(margin_l, margin_r, w, width, unit_x, loop_x, pivot_x);
		margin_u, margin_d, mid_y, piv0_y, piv1_y, len0_y, len1_y = adjust_margin(margin_u, margin_d, h, height, unit_y, loop_y, pivot_y);

		-- handle the zero-sized case.
		local W, H = margin_l + len1_x + margin_r, margin_u + len1_y + margin_d;
		if W == 0 or H == 0 then
			obj.setoption("draw_state", true);
			return;
		end

		-- invoke shader.
		obj.copybuffer("tempbuffer", "object");
		obj.clearbuffer("object", W, H);
		obj.pixelshader("mid_loop@画像中間ループ@Basic_S", "object", "tempbuffer", {
			margin_l, margin_u, len1_x + margin_l, len1_y + margin_u;
			piv0_x - ((-offset_x) % (mid_x / piv1_x)), piv1_x, piv0_y - ((-offset_y) % (mid_y / piv1_y)), piv1_y;
			1 / w, 1 / h;
			mid_x, mid_y; len1_x - len0_x, len1_y - len0_y; loop_x, loop_y;
		}, "copy", "clip");

		-- adjust the center.
		obj.cx, obj.cy =
			obj.cx - (len1_x - len0_x) * align_x / 2,
			obj.cy - (len1_y - len0_y) * align_y / 2;

	end
end

---小数ぼかしの実体関数．値の型や範囲チェックは行われないので，事前に指定範囲内の保証をしておくこと．
---@param span_x number 横方向のぼかし範囲，0 -- 500.
---@param span_y number 縦方向のぼかし範囲，0 -- 500.
---@param luma_weight number 光の強さ，0 -- 60.
---@param fixed_size boolean サイズ固定．
function prec_blur(span_x, span_y, luma_weight, fixed_size)
	span_x, span_y = span_x + 1, span_y + 1;
	local span_x_i, span_y_i = math_ceil(span_x) - 1, math_ceil(span_y) - 1;
	local span_x_f, span_y_f = span_x - span_x_i, span_y - span_y_i;

	-- weight to luma.
	local log_base = 256 * math.log(1 + luma_weight / 1000, 2);
	local luma_scale = 2 ^ (9 - log_base); -- for float16 not to overflow.
	if luma_weight > 0 then
		obj.pixelshader("weight_luma@小数ぼかし@Basic_S", "object", "object", { log_base, luma_scale });
	end

	-- apply the blur by shaders.
	local w, h = obj.w, obj.h;
	obj.clearbuffer("tempbuffer", h + 2 * span_y_i, w + 2 * span_x_i);
	obj.computeshader(w > span_x_i and "convol1@小数ぼかし@Basic_S" or "convol2@小数ぼかし@Basic_S", "tempbuffer", "object", {
		h, w + span_x_i;
		span_x_i, 2 ^ 12 * span_x_f, 2 ^ -12 / span_x,
	}, 1, math_ceil(h / 64), 1);
	obj.clearbuffer("object", w + 2 * span_x_i, h + 2 * span_y_i);
	obj.computeshader(h > span_y_i and "convol1@小数ぼかし@Basic_S" or "convol2@小数ぼかし@Basic_S", "object", "tempbuffer", {
		w + span_x_i, h + span_y_i;
		span_y_i, 2 ^ 12 * span_y_f, 2 ^ -12 / span_y,
	}, 1, math_ceil((w + span_x_i) / 64), 1);
	obj.computeshader("convol1@小数ぼかし@Basic_S", "tempbuffer", "object", {
		h + span_y_i, w + 2 * span_x_i;
		span_x_i, 2 ^ 12 * span_x_f, 2 ^ -12 / span_x,
	}, 1, math_ceil((h + span_y_i) / 64), 1);
	obj.computeshader("convol1@小数ぼかし@Basic_S", "object", "tempbuffer", {
		w + 2 * span_x_i, h + 2 * span_y_i;
		span_y_i, 2 ^ 12 * span_y_f, 2 ^ -12 / span_y,
	}, 1, math_ceil((w + 2 * span_x_i) / 64), 1);

	-- normalize the sum on the edges.
	if fixed_size then
		add_canvas_size(-span_x_i, -span_x_i, -span_y_i, -span_y_i);
		obj.pixelshader("unweight_alpha@小数ぼかし@Basic_S", "object", nil, {
			w, h; span_x_i, span_y_i; span_x_f, span_y_f;
			span_x ^ 2, span_y ^ 2;
		}, "mask");
	end

	-- remove the weight of luma.
	if luma_weight > 0 then
		obj.pixelshader("unweight_luma@小数ぼかし@Basic_S", "object", "object", { 1 / log_base, 1 / luma_scale });
	end
end
--#endregion actual processes for filters.


return {
	quat = {
		mul = quat_mult,
		pow = quat_power,

		normalize = vector_normalize,

		euler_to_quat = angle_euler_to_quat,
		axis_to_quat = angle_axis_to_quat,
		quat_to_euler = angle_quat_to_euler,

		quat_apply = angle_quat_apply,
		euler_apply = angle_euler_apply,

		quat_to_matrix = angle_quat_to_matrix,
		euler_to_matrix = angle_euler_to_matrix,
	},

	PI = {
		as_bool = PI_as_bool,
		corner_shape = PI_choose_corner_shape,
		corner_radii = PI_choose_corner_radii,
		cut_move_interpolate = PI_choose_cut_move_interpolate,
		inner_loop_size = PI_choose_inner_loop_size,
		inner_loop_mode = PI_choose_inner_loop_mode,
		blend_mode = PI_choose_blend_mode,
		tile_mode = PI_choose_tile_mode,
		composite_mode = PI_choose_composite_mode,
	},

	save_obj_props = save_obj_props,
	load_obj_props = load_obj_props,
	normalize_corner_shape = normalize_corner_shape,
	normalize_corner_radii = normalize_corner_radii,
	is_composite_fixed_size = is_composite_fixed_size,
	limit_image_extent = limit_image_extent,
	size_from_aspect = size_from_aspect,
	rgba_color_opt = rgba_color_opt,

	print_script_error = print_script_error,
	execute_user_script = execute_user_script,
	execute_text_script = execute_text_script,

	void_return = void_return,
	apply_alpha = apply_alpha,
	round_corners = round_corners_buff,
	add_canvas_size = add_canvas_size,
	set_rotation_center = set_rotation_center,

	composite_core = composite_core,

	effect = {
		["四隅丸め"] = round_corners, round_corners = round_corners,
		["背景角丸矩形"] = back_round_rect, back_round_rect = back_round_rect,
		["任意軸追加回転"] = rotate_any_axis, rotate_any_axis = rotate_any_axis,
		["カットずらし"] = cut_move, cut_move = cut_move,
		["画像中間ループ"] = inner_loop, inner_loop = inner_loop,
		["小数ぼかし"] = prec_blur, prec_blur = prec_blur,
	};
};
