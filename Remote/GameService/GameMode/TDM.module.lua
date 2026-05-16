-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameService.GameMode.TDM

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
require(script.Parent.Parent.GameClient)
local LocalGameClient = require(script.Parent.Parent.GameClient.LocalGameClient)
local API = require(script.Parent.Parent.API)
local v1 = require(script.Parent)
local t = {
	ClientPointChanged = SimpleSignal.new(),
	TeamPointChanged = SimpleSignal.new(),
	Winner = SimpleSignal.new()
}
local v2 = setmetatable({
	Event = t,
	FocusedEvent = {
		ClientPointChanged = SimpleSignal.new(),
		TeamPointChanged = SimpleSignal.new(),
		Winner = SimpleSignal.new()
	},
	Teams = { Constant.Team.Team1, Constant.Team.Team2 }
}, v1)
v2.__index = v2
function v2.OnCreate(p1) --[[ OnCreate | Line: 34 | Upvalues: v1 (copy), t (copy) ]]
	v1.OnCreate(p1)
	p1.TeamPoints = {}
	for v12, v2 in p1.Teams do
		local v3 = p1.DataInstance:FindFirstChild(("%sPoint"):format(v2))
		if v3 then
			p1.TeamPoints[v2] = v3
			p1.Connections:AddConnection(v3.Name, v3.Changed:Connect(function() --[[ Line: 43 | Upvalues: t (ref), p1 (copy), v2 (copy) ]]
				t.TeamPointChanged:Fire(p1, v2)
			end))
		end
	end
end
function v2.GetTeamPoint(p1, p2) --[[ GetTeamPoint | Line: 50 ]]
	local v1 = p1.TeamPoints[p2]
	return if v1 then v1.Value or 0 else 0
end
function v2.GetFriendlyTeamPoint(p1) --[[ GetFriendlyTeamPoint | Line: 55 | Upvalues: LocalGameClient (copy) ]]
	if p1.Room == LocalGameClient.Room then
		return p1:GetTeamPoint(LocalGameClient:GetTeam())
	else
		return 0
	end
end
function v2.GetEnemyTeamPoint(p1) --[[ GetEnemyTeamPoint | Line: 62 | Upvalues: LocalGameClient (copy), Constant (copy) ]]
	if p1.Room == LocalGameClient.Room then
		if LocalGameClient:GetTeam() == Constant.Team.Team1 then
			return p1:GetTeamPoint(Constant.Team.Team2)
		else
			return p1:GetTeamPoint(Constant.Team.Team1)
		end
	else
		return 0
	end
end
function v2.GetEnemyTeam(p1) --[[ GetEnemyTeam | Line: 72 | Upvalues: LocalGameClient (copy), Constant (copy) ]]
	if p1.Room == LocalGameClient.Room then
		if LocalGameClient:GetTeam() == Constant.Team.Team1 then
			return Constant.Team.Team2
		else
			return Constant.Team.Team1
		end
	end
end
function v2.GetWinPoint(p1) --[[ GetWinPoint | Line: 82 ]]
	return p1.Config.Game.WinPoint
end
function v2.GetModeDisplay(p1) --[[ GetModeDisplay | Line: 87 ]]
	return ("TDM - First to %d"):format((p1:GetWinPoint()))
end
function v2.GetClientPoint(p1, p2) --[[ GetClientPoint | Line: 92 ]]
	return p2.Instance:GetAttribute("TDMPoint") or 0
end
function v2.OnClientJoined(p1, p2) --[[ OnClientJoined | Line: 96 | Upvalues: t (copy) ]]
	p2.GameConnections:AddConnection("tdmPoint", p2.Instance:GetAttributeChangedSignal("TDMPoint"):Connect(function() --[[ Line: 97 | Upvalues: t (ref), p1 (copy), p2 (copy) ]]
		t.ClientPointChanged:Fire(p1, p2)
	end))
end
function v2.OnClientLeft(p1, p2) --[[ OnClientLeft | Line: 102 ]]
	p2.GameConnections:Disconnect("tdmPoint")
end
function v2.onLoad(p1) --[[ onLoad | Line: 106 | Upvalues: API (copy), v2 (copy), t (copy) ]]
	API.WrapRoomRemote(script.Winner, function(p1, p2, p3) --[[ Line: 107 | Upvalues: v2 (ref), t (ref) ]]
		local v1 = v2:from(p1)
		if v1 then
			t.Winner:Fire(v1, p2, p3)
		end
	end)
end
return v2