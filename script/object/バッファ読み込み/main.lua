--information:バッファ読み込み@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S
--require:${LEAST_AVIUTL_VERSION}
---$select:バッファ
---仮想バッファ = 0
---一時キャッシュ = 1
---フレームバッファ = 2
---直前オブジェクト = 3
local buffer_type = 0

---$string:キャッシュ名
local cache_name = "my_cache"

--group:その他,false
---$value:PI
local PI = {}

local obj, type = obj, type;

--#region PI

-- take parameters.
--[==[
	PI = {
		buffer_type:	string?,
		cache_name:		string?,
	}
]==]
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
