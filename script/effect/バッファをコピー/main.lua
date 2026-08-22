--information:バッファをコピー@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:現在オブジェクトや「仮想バッファ」，一時キャッシュの「キャッシュバッファ」などのバッファ間でコピーを実行します．
--label:Basic_S
--filter
--require:${LEAST_AVIUTL_VERSION}
---$select:コピー元
---仮想バッファ = 0
---一時キャッシュ = 1
---フレームバッファ = 2
---このオブジェクト = 3
local buff_src = 3

---$tips:"cache:---" の "---" 部分．一時キャッシュ指定時のみ有効．
---$string:src::キャッシュ名
local cache_src = "my_cache"

--hide@cache_src:buff_src~=1
---$tips:フレームバッファの場合は，コピー元がシーンのサイズと一致している必要があります．
---$select:コピー先
---仮想バッファ = 0
---一時キャッシュ = 1
---フレームバッファ = 2
---このオブジェクト = 3
local buff_dst = 0

---$tips:"cache:---" の "---" 部分．一時キャッシュ指定時のみ有効．
---$string:dst::キャッシュ名
local cache_dst = "my_cache"

--hide@cache_dst:buff_dst~=1
---$checksection:描画しない
local suppress_draw = true

--group:その他,false
---$nolang: name
---$tips:PI = {
---     : buff_src: string?,
---     : cache_src: string?,
---     : buff_dst: string?,
---     : cache_dst: string?,
---     : suppress_draw: boolean|number|nil,
---     :}
---$value:PI
local PI = {}

local obj, type = obj, type;
local basic_s = require("Basic_S");

--#region PI

-- take parameters.
do  local name2num = { ["仮想バッファ"] = 0, ["一時キャッシュ"] = 1, ["フレームバッファ"] = 2, ["このオブジェクト"] = 3, };
	if type(PI.buff_src) == "string" then buff_src = name2num[PI.buff_src] or buff_src end
	if type(PI.buff_dst) == "string" then buff_dst = name2num[PI.buff_dst] or buff_dst end
end
if type(PI.cache_src) == "string" then cache_src = PI.cache_src end
if type(PI.cache_dst) == "string" then cache_dst = PI.cache_dst end
suppress_draw = basic_s.PI.as_bool(PI.suppress_draw, suppress_draw);

--#endregion PI

-- perform copy.
if buff_src ~= buff_dst or (buff_src == 1 and cache_src ~= cache_dst) then
	-- determine the names of buffers.
	local src_name =
		buff_src == 0 and "tempbuffer" or
		buff_src == 2 and "framebuffer" or
		buff_src == 3 and "object" or
		("cache:"..cache_src);
	local dst_name =
		buff_dst == 0 and "tempbuffer" or
		buff_dst == 2 and "framebuffer" or
		buff_dst == 3 and "object" or
		("cache:"..cache_dst);

	-- in case of failure (like cache being expired) use pcall().
	local c, msg = pcall(obj.copybuffer, dst_name, src_name);
	if not c then
		print("@warn", "Failed to perform copy with error message: "..tostring(msg));
	elseif buff_dst == 3 and obj.getinfo("filter") then
		-- adjust the size to fit the screen.
		local math, w, h, W, H = math, obj.w, obj.h, obj.screen_w, obj.screen_h;
		basic_s.add_canvas_size(
			math.floor((W - w) / 2), math.ceil((W - w) / 2),
			math.floor((H - h) / 2), math.ceil((H - h) / 2), false);
	end
end

-- suppress further drawing if specified.
if suppress_draw then basic_s.void_return() end
