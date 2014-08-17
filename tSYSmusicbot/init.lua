--(c) by Tobias Schramm 2014

local MODULE_NAME = "tsysmusicbot"

local apiuri = "http://domain.api:80/api.php"
local curlbin = "curl"
local apikey = "putRandomKeyHere"

local events =
{
	onTextMessageEvent = onMessage,
	onTalkStatusChangeEvent = onTalkStatusChange
}

require("ts3init")
local oldPackPath = package.path
package.path = package.path:gsub("?.lua", "tSYSmusicbot/?.lua")
require("curl")
require("eventHandler")
require("chat")
require("exec")
local json = require("json")
package.path = oldPackPath

local exec = Exec()
chat = Chat(ts3)
local curl = Curl(curlbin, json, exec, chat, apikey)
evHandler = EventHandler(curl, apiuri)
if(curl:available()) then
	local events =
	{
		onTextMessageEvent = onMsg
	}
	ts3RegisterModule(MODULE_NAME, events)
else
	error("cURL not found. Please adopt the variable 'curlbinpath' to the location of your curl binary.")
end

function onMsg(serverConnectionHandlerID, targetMode, toID, fromID, fromName, fromUniqueIdentifier, message, ffIgnored)
	return evHandler:onTextMessage(serverConnectionHandlerID, targetMode, toID, fromID, fromName, fromUniqueIdentifier, message, ffIgnored)
end

function onTalkStatusChange(serverConnectionHandlerID, status, isReceivedWhisper, clientID)
	return evHandler:onTalkStatusChange(serverConnectionHandlerID, status, isReceivedWhisper, clientID)
end