-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.PlayerConfigService

-- https://lua.expert/
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
local v1 = nil
local function getConfigRoot(p1) --[[ getConfigRoot | Line: 11 | Upvalues: v1 (ref), InstanceUtils (copy), LocalPlayer (copy) ]]
	if not v1 then
		v1 = InstanceUtils.FindFirst(LocalPlayer, "PlayerGui.PlayerConfig")
		if v1 or p1 then
			return v1
		end
		v1 = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PlayerConfig")
	end
	return v1
end
return {
	WaitValue = function(p1) --[[ WaitValue | Line: 24 | Upvalues: v1 (ref), InstanceUtils (copy), LocalPlayer (copy), HttpService (copy) ]]
		if not v1 then
			v1 = InstanceUtils.FindFirst(LocalPlayer, "PlayerGui.PlayerConfig") or LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("PlayerConfig")
		end
		local v12 = v1:WaitForChild(p1)
		local v2 = v12.Value
		if typeof(v2) == "string" and v12:GetAttribute("JSON") then
			v2 = HttpService:JSONDecode(v2)
		end
		return v2
	end,
	LazyGet = function(p1, p2) --[[ LazyGet | Line: 34 | Upvalues: v1 (ref), InstanceUtils (copy), LocalPlayer (copy), HttpService (copy) ]]
		if not v1 then
			v1 = InstanceUtils.FindFirst(LocalPlayer, "PlayerGui.PlayerConfig")
		end
		local v12 = v1
		if v12 then
			local v2 = v12:FindFirstChild(p1)
			if v2 then
				local v3 = v2.Value
				if typeof(v3) == "string" and v2:GetAttribute("JSON") then
					v3 = HttpService:JSONDecode(v3)
				end
				return v3
			else
				return p2
			end
		else
			return p2
		end
	end
}