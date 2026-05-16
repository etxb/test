-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.SecurityService

-- https://lua.expert/
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local t = {}
local v1 = false
local t2 = {
	Invoke = function(p1, ...) --[[ Invoke | Line: 11 ]]
		return p1:InvokeServer(workspace:GetServerTimeNow(), ...)
	end,
	Request = function() --[[ Request | Line: 15 | Upvalues: v1 (ref), HttpService (copy), t (copy) ]]
		if v1 then
		else
			local v12 = HttpService:GenerateGUID(false)
			t[v12] = true
			return v12
		end
	end,
	Lockdown = function() --[[ Lockdown | Line: 24 | Upvalues: v1 (ref) ]]
		v1 = true
	end
}
return TableUtils.Protect(t2)