-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.PlayerMarketService.LocalPlayerMarketStore

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.SimpleSignal)
local CommonPlayerMarketStore = require(ReplicatedStorage.Common.PlayerMarketService.CommonPlayerMarketStore)
local v1 = script.Parent
local v2 = setmetatable({}, CommonPlayerMarketStore)
v2.__index = v2
function v2.RemoveListing(p1, p2, p3) --[[ RemoveListing | Line: 12 | Upvalues: CommonPlayerMarketStore (copy), v1 (copy) ]]
	if p3 and p3.Remote then
		return CommonPlayerMarketStore.RemoveListing(p1, p2, p3)
	elseif CommonPlayerMarketStore.RemoveListing(p1, p2, {
		Test = true
	}) then
		local v12, v2 = pcall(function() --[[ Line: 19 | Upvalues: v1 (ref), p2 (copy) ]]
			return v1.RemoveListing:InvokeServer(p2)
		end)
		if v12 and v2 then
			return CommonPlayerMarketStore.RemoveListing(p1, p2)
		end
	end
end
return v2