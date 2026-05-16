-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameService.GameMode.Lobby

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local v1 = require(script.Parent)
local t = {}
t.__index = t
setmetatable(t, v1)
function t.GetEnemyTeam(p1) --[[ GetEnemyTeam | Line: 11 | Upvalues: Constant (copy) ]]
	return Constant.Team.Team2
end
return t