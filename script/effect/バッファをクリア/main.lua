--information:バッファをクリア@Basic_S ${PACKAGE_VERSION} by ${AUTHOR}
--label:Basic_S
--filter
--require:${LEAST_AVIUTL_VERSION}
---$select:バッファ
---仮想バッファ = 0
---一時キャッシュ = 1
---フレームバッファ = 2
---このオブジェクト = 3
local buffer = 3

---$string:キャッシュ名
local cache_name = "my_cache"

---$color:色
local color = nil

--group:その他,false
---$value:PI
local PI = {}

local obj, tonumber, type = obj, tonumber, type;

--#region PI normalize parameters.

-- take parameters.
--[==[
	PI = {
		buffer:		string?,
		cache_name:	string?,
		color:		number|false|nil,
	}
]==]
if type(PI.buff_src) == "string" then
	local name2num = { ["仮想バッファ"] = 0, ["一時キャッシュ"] = 1, ["フレームバッファ"] = 2, ["このオブジェクト"] = 3, };
	buffer = name2num[PI.buffer] or buffer;
end
if type(PI.cache_src) == "string" then cache_name = PI.cache_name end
if PI.color == false then color = nil;
else color = tonumber(PI.color) or color end

-- normalize parameters.
if color then color = math.floor(0.5 + color) % 2 ^ 24 end

--#endregion PI normalize parameters.

-- determine the name of buffer.
local buffer_name =
	buffer == 0 and "tempbuffer" or
	buffer == 2 and "framebuffer" or
	buffer == 3 and "object" or
	("cache:"..cache_name);

-- then clear.
if color then obj.clearbuffer(buffer_name, color);
else obj.clearbuffer(buffer_name) end
