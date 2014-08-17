EventHandler = {}
EventHandler.__index = EventHandler

setmetatable(EventHandler, {
  __call = function (class, ...)
    return class.new(...)
  end,
})

function EventHandler.new(curl, apiuri)
	local self = setmetatable({}, EventHandler)
	self.curl = curl
	self.apiuri = apiuri
	self.lastUpdate = 0
	return self
end

function EventHandler:onTextMessage(serverConnectionHandlerID, targetMode, toID, fromID, fromName, fromUniqueIdentifier, message, ffIgnored)
	local me = ts3.getClientID(serverConnectionHandlerID)
	if(fromID ~= me and targetMode == 1 and toID == me) then
		obj = {}
		obj.uid = fromUniqueIdentifier
		obj.reqstr = message:gsub("%[URL%]", ""):gsub("%[/URL%]", ""):gsub("https", "http")
		reqobj = {}
		reqobj["data"] = json.encode(obj)
		reqobj["jsonapi"] = "true"
		self.curl:parseResponse(self.curl:requestPOST(reqobj, self.apiuri), serverConnectionHandlerID, fromID)
		ctime = os.time()
		if(ctime - self.lastUpdate > 5) then
			self.lastUpdate = ctime
			self:updateDescription(serverConnectionHandlerID)
		end
	end
	return 1
end

function EventHandler:onTalkStatusChange(serverConnectionHandlerID, status, isReceivedWhisper, clientID)
	ctime = os.time()
	if(ctime - self.lastUpdate > 5) then
		self.lastUpdate = ctime
		self:updateDescription(serverConnectionHandlerID)
	end
	return 0
end

function EventHandler:updateDescription(conID)
	self.curl:updateDescription(self.apiuri, conID)
end