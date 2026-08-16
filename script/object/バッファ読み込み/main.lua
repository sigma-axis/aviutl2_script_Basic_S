--information:バッファ読み込み@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
---$script_tips:「仮想バッファ出力」や各種スクリプトの一時描画先などとして保存されている「仮想バッファ」や，一時保存先の「キャッシュバッファ」などを読み込みます．
--label:Basic_S
--require:${LEAST_AVIUTL_VERSION}
---$select:バッファ
---仮想バッファ = 0
---一時キャッシュ = 1
---フレームバッファ = 2
---直前オブジェクト = 3
local buffer_type = 0

---$tips:"cache:---" の "---" 部分．一時キャッシュ指定時のみ有効．
---$string:キャッシュ名
local cache_name = "my_cache"

--group:その他,false
---$nolang: name
---$tips:PI = {
---     :  buffer_type: string?,
---     :  cache_name: string?,
---     :}
---$value:PI
local PI = {}

local obj, type = obj, type;

--#region PI

-- take parameters.
if PI.buffer_type then
	local name2num = {
		["仮想バッファ"] = 0, ["一時キャッシュ"] = 1,
		["フレームバッファ"] = 2, ["直前オブジェクト"] = 3,
	};
	buffer_type = name2num[PI.buffer_type] or buffer_type;
end
if type(PI.cache_name) == "string" then cache_name = PI.cache_name end

--#endregion PI

-- determine the buffer name.
local buff_name =
	buffer_type == 0 and "tempbuffer" or
	buffer_type == 2 and "framebuffer" or
	buffer_type == 3 and "before" or
	("cache:"..cache_name);

-- load it.
if buffer_type == 1 then
	obj.copybuffer("object", buff_name);
else obj.load(buff_name) end
