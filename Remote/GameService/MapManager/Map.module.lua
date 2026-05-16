-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameService.MapManager.Map

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Shared.SimpleSignal)
local t = {}
t.__index = t
function t.new(p1) --[[ new | Line: 12 ]]
	return setmetatable({}, p1)
end
function t.Destroy(p1) --[[ Destroy | Line: 19 ]] end
return t