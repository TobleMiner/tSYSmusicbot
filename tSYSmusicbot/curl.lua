--(c) by Tobias Schramm 2014

Curl = {}
Curl.__index = Curl

setmetatable(Curl, {
  __call = function (class, ...)
    return class.new(...)
  end,
})

function Curl.new(curlbin, json, exec, chat, apikey)
	local self = setmetatable({}, Curl)
	self.curlbin = curlbin
	self.json = json
	self.exec = exec
	self.chat = chat
	self.apikey = apikey
	return self
end

local curlbin = curlbinpath

function Curl:url_encode(str)
	if (str) then
		str = string.gsub (str, "\n", "\r\n")
		str = string.gsub (str, "([^%w %-%_%.%~])",
			function (c) return string.format ("%%%02X", string.byte(c)) end)
		str = string.gsub (str, " ", "+")
	end
	return str
end

function Curl:requestPOST(data, url)
	reqstr = ""
	local cnt = 0
	for k, v in pairs(data) do
		reqstr = reqstr..k.."="..self:url_encode(v).."&"
		cnt = cnt + 1
	end
	if(cnt > 0) then
		reqstr = reqstr:sub(0, #reqstr - 1)
	end
	return self.exec:hack(self.curlbin.." --data \""..reqstr.."\" "..url)
end

function Curl:available()
	return os.execute(self.curlbin.." --version > exec.tmp") == 0;
end

function Curl:parseResponse(response, conID, clientID)
	local respobj = self.json.decode(response)
	local msg = respobj.userFriendly
	local cnt = 0;
	while cnt < #msg do
		partlen = math.min(1023, #msg - cnt)
		msgpart = "\n"..msg:sub(cnt + 1, cnt + partlen)
		self.chat:sendPrivateMsg(conID, msgpart, clientID)
		cnt = cnt + partlen
	end
end

function Curl:updateDescription(apiuri, conID)
	obj = {}
	obj.uid = self.apikey
	obj.reqstr = "gettitle"
	reqobj = {}
	reqobj["data"] = json.encode(obj)
	reqobj["jsonapi"] = "true"
	self.chat:setOwnDescription(conID, self.json.decode(self:requestPOST(reqobj, apiuri)).userFriendly)
end