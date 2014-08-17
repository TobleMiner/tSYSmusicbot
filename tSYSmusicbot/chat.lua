Chat = {}
Chat.__index = Chat

setmetatable(Chat, {
  __call = function (class, ...)
    return class.new(...)
  end,
})

function Chat.new(ts3)
	local self = setmetatable({}, Chat)
	self.ts3 = ts3
	return self
end

function Chat:showMsg(msg)
	self.ts3.printMessageToCurrentTab(msg)
end

function Chat:sendMsgOwnChannel(conId, msg)
	local me = self.ts3.getClientID(conId)
	local ownChannel = self.ts3.getChannelOfClient(conId, me)
	self.ts3.requestSendChannelTextMsg(conId, msg, ownChannel)
end

function Chat:sendPrivateMsg(conId, msg, targetID)
	self.ts3.requestSendPrivateTextMsg(conId, msg, targetID)
end

function Chat:setOwnDescription(conId, description)
	local me = self.ts3.getClientID(conId)
	self.ts3.requestClientEditDescription(conId, me, description)
end