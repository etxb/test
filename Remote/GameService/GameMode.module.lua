-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameService.GameMode

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("RunService"):IsStudio()
local LocalPlayer = Players.LocalPlayer
local Constant = require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local RoleConfig = require(ReplicatedStorage.Config.RoleConfig)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local GameUtils = require(ReplicatedStorage.Util.GameUtils)
local ConnectionHolder = require(ReplicatedStorage.Util.ConnectionHolder)
require(ReplicatedStorage.Shared.SimpleSignal)
local Server = require(ReplicatedStorage.Remote.Server)
require(script.Parent.API)
require(script.Parent.GameClient)
local t = {}
t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 27 | Upvalues: Config (copy), ConnectionHolder (copy), GameUtils (copy), ReplicatedStorage (copy) ]]
	local v1 = setmetatable({
		Room = p2,
		Mode = p3,
		ModeSet = Config.GameModeSetReverse[p3],
		Connections = ConnectionHolder:new()
	}, p1)
	v1.Config = GameUtils.FindModule(ReplicatedStorage.Config.GameConfig, v1.Mode, v1.ModeSet, "\233\133\141\231\189\174\230\150\135\228\187\182")
	local ModeDataRef = p2.DataInstance.ModeDataRef
	if not ModeDataRef.Value then
		ModeDataRef.Changed:Wait()
	end
	v1.DataInstance = ModeDataRef.Value
	v1:OnCreate()
	return v1
end
function t.OnCreate(p1) --[[ OnCreate | Line: 49 ]] end
function t.IsFriendlyTeam(p1, p2, p3) --[[ IsFriendlyTeam | Line: 53 ]]
	return p2 == p3
end
function t.IsFriendly(p1, p2, p3) --[[ IsFriendly | Line: 57 ]]
	if p2 == p3 then
		return true
	else
		return p1:IsFriendlyTeam(p2.Team, p3.Team)
	end
end
function t.GetTeams(p1) --[[ GetTeams | Line: 64 | Upvalues: TableUtils (copy) ]]
	return p1.Teams or TableUtils.EMPTY
end
function t.GetEnemyTeams(p1) --[[ GetEnemyTeams | Line: 68 | Upvalues: TableUtils (copy) ]]
	local v1 = p1:GetEnemyTeam()
	if v1 then
		return { v1 }
	else
		return TableUtils.EMPTY
	end
end
function t.GetEnemyTeam(p1) --[[ GetEnemyTeam | Line: 76 ]] end
function t.CanSelectRole(p1, p2) --[[ CanSelectRole | Line: 80 | Upvalues: RoleConfig (copy) ]]
	local v1 = RoleConfig[p2]
	if v1 and not v1.Disabled then
		return true
	end
end
function t.CanSelectRoleBypass(p1) --[[ CanSelectRoleBypass | Line: 88 | Upvalues: Constant (copy) ]]
	return p1.ModeSet == Constant.GameModeSet.Lobby
end
function t.OnClientJoined(p1, p2) --[[ OnClientJoined | Line: 92 ]] end
function t.OnClientLeft(p1, p2) --[[ OnClientLeft | Line: 96 ]] end
function t.GetModeDisplay(p1) --[[ GetModeDisplay | Line: 100 | Upvalues: Constant (copy), Server (copy) ]]
	if p1.ModeSet == Constant.GameModeSet.FFA and Server.IsMatchmaking() then
		return "Waiting for other players"
	elseif p1.ModeSet == Constant.GameModeSet.FFA and Server.GetRawMode() == Constant.ServerMode.FFA_Ranked then
		return "Ranked FFA"
	else
		return Constant.GameModeName[p1.Mode] or p1.Mode
	end
end
function t.Destroy(p1) --[[ Destroy | Line: 110 ]]
	p1.Connections:Destroy()
end
function t.from(p1, p2) --[[ from | Line: 114 ]]
	return p1:is(p2.ModeHandler)
end
function t.is(p1, p2) --[[ is | Line: 118 ]]
	if typeof(p2) == "table" then
		return if getmetatable(p2) == p1 then p2 else false
	end
end
return t