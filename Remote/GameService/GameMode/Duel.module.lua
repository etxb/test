-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameService.GameMode.Duel

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
require(script.Parent.Parent.GameClient)
local LocalGameClient = require(script.Parent.Parent.GameClient.LocalGameClient)
local API = require(script.Parent.Parent.API)
local v1 = require(script.Parent)
local t = {
	ClientPointChanged = SimpleSignal.new(),
	TeamPointChanged = SimpleSignal.new(),
	RoundResult = SimpleSignal.new(),
	Winner = SimpleSignal.new(),
	RematchChanged = SimpleSignal.new()
}
local v2 = setmetatable({
	Event = t,
	FocusedEvent = {
		ClientPointChanged = SimpleSignal.new(),
		TeamPointChanged = SimpleSignal.new(),
		RoundResult = SimpleSignal.new(),
		Winner = SimpleSignal.new(),
		RematchChanged = SimpleSignal.new()
	},
	Teams = { Constant.Team.Team1, Constant.Team.Team2 }
}, v1)
v2.__index = v2
function v2.OnCreate(p1) --[[ OnCreate | Line: 43 | Upvalues: v1 (copy), t (copy) ]]
	v1.OnCreate(p1)
	p1.TeamPoints = {}
	for v12, v2 in p1.Teams do
		local v3 = p1.DataInstance:FindFirstChild(("%sPoint"):format(v2))
		if v3 then
			p1.TeamPoints[v2] = v3
			p1.Connections:AddConnection(v3.Name, v3.Changed:Connect(function() --[[ Line: 52 | Upvalues: t (ref), p1 (copy), v2 (copy) ]]
				t.TeamPointChanged:Fire(p1, v2)
			end))
		end
	end
	p1.MatchmakingQueue = p1.DataInstance.MatchmakingQueue.Value
	p1.Connections:AddConnection("rematch", p1.DataInstance.RematchPlayers.Changed:Connect(function() --[[ Line: 59 | Upvalues: t (ref), p1 (copy) ]]
		t.RematchChanged:Fire(p1)
	end))
end
function v2.GetTeamPoint(p1, p2) --[[ GetTeamPoint | Line: 64 ]]
	local v1 = p1.TeamPoints[p2]
	return if v1 then v1.Value or 0 else 0
end
function v2.GetEnemyTeam(p1) --[[ GetEnemyTeam | Line: 69 | Upvalues: LocalGameClient (copy), Constant (copy) ]]
	if p1.Room == LocalGameClient.Room then
		if LocalGameClient:GetTeam() == Constant.Team.Team1 then
			return Constant.Team.Team2
		else
			return Constant.Team.Team1
		end
	end
end
function v2.Rematch(p1, p2) --[[ Rematch | Line: 79 | Upvalues: t (copy) ]]
	if p2 == nil then
		p2 = true
	end
	if p1.Rematched == nil then
		p1.Rematched = p2
		script.Rematch:FireServer(p2)
		t.RematchChanged:Fire(p1)
	end
end
function v2.GetRematched(p1) --[[ GetRematched | Line: 91 ]]
	return p1.DataInstance.RematchPlayers.Value
end
function v2.GetWinPoint(p1) --[[ GetWinPoint | Line: 95 ]]
	local TeamSize = p1.DataInstance.TeamSize.Value
	local WinPoint = p1.Config.Game.WinPoint
	if p1.Config.Game.WinPointByTeamSize then
		WinPoint = p1.Config.Game.WinPointByTeamSize[TeamSize] or WinPoint
	end
	return WinPoint
end
function v2.GetModeDisplay(p1) --[[ GetModeDisplay | Line: 104 | Upvalues: Config (copy) ]]
	local v1 = Config.Matchmaking.Queues[p1.MatchmakingQueue]
	local v2 = if v1 and v1.Ranked then "Ranked" else "Duel"
	local TeamSize = p1.DataInstance.TeamSize.Value
	return ("%s %dv%d - First to %d"):format(v2, TeamSize, TeamSize, (p1:GetWinPoint()))
end
function v2.GetClientPoint(p1, p2) --[[ GetClientPoint | Line: 115 ]]
	return p2.Instance:GetAttribute("DuelPoint") or 0
end
function v2.OnClientJoined(p1, p2) --[[ OnClientJoined | Line: 119 | Upvalues: t (copy) ]]
	p2.GameConnections:AddConnection("duelPoint", p2.Instance:GetAttributeChangedSignal("DuelPoint"):Connect(function() --[[ Line: 120 | Upvalues: t (ref), p1 (copy), p2 (copy) ]]
		t.ClientPointChanged:Fire(p1, p2)
	end))
end
function v2.OnClientLeft(p1, p2) --[[ OnClientLeft | Line: 125 ]]
	p2.GameConnections:Disconnect("duelPoint")
end
function v2.onLoad(p1) --[[ onLoad | Line: 129 | Upvalues: API (copy), v2 (copy), t (copy) ]]
	API.WrapRoomRemote(script.RoundResult, function(p1, p2, p3) --[[ Line: 130 | Upvalues: v2 (ref), t (ref) ]]
		local v1 = v2:from(p1)
		if v1 then
			t.RoundResult:Fire(v1, p2, p3)
		end
	end)
	API.WrapRoomRemote(script.Winner, function(p1, p2, p3) --[[ Line: 136 | Upvalues: v2 (ref), t (ref) ]]
		local v1 = v2:from(p1)
		if v1 then
			v1._Winner = p3
			t.Winner:Fire(v1, p2, p3)
		end
	end)
end
return v2