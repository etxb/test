-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameService.GameMode.FFA

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
require(script.Parent.Parent.GameClient)
require(script.Parent.Parent.GameClient.LocalGameClient)
require(script.Parent.Parent.API)
local v1 = require(script.Parent)
local t = {
	TeamPointChanged = SimpleSignal.new(),
	ClientPointChanged = SimpleSignal.new()
}
local v2 = setmetatable({
	Event = t,
	FocusedEvent = {
		TeamPointChanged = SimpleSignal.new(),
		ClientPointChanged = SimpleSignal.new()
	},
	Teams = { Constant.Team.Team3 }
}, v1)
v2.__index = v2
function v2.OnCreate(p1) --[[ OnCreate | Line: 32 | Upvalues: v1 (copy) ]]
	v1.OnCreate(p1)
end
function v2.GetEnemyTeam(p1) --[[ GetEnemyTeam | Line: 36 | Upvalues: Constant (copy) ]]
	return Constant.Team.Team3
end
function v2.GetClientPoint(p1, p2) --[[ GetClientPoint | Line: 40 ]]
	return p2.Instance:GetAttribute("FFAPoint") or 0
end
function v2.OnClientJoined(p1, p2) --[[ OnClientJoined | Line: 44 | Upvalues: t (copy) ]]
	p2.GameConnections:AddConnection("ffaPoint", p2.Instance:GetAttributeChangedSignal("FFAPoint"):Connect(function() --[[ Line: 45 | Upvalues: t (ref), p1 (copy), p2 (copy) ]]
		t.ClientPointChanged:Fire(p1, p2)
	end))
end
function v2.OnClientLeft(p1, p2) --[[ OnClientLeft | Line: 50 ]]
	p2.GameConnections:Disconnect("ffaPoint")
end
function v2.IsFriendlyTeam(p1, p2, p3) --[[ IsFriendlyTeam | Line: 54 ]]
	return false
end
return v2