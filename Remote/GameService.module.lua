-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameService

-- https://lua.expert/
game:GetService("CollectionService")
game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("RunService"):IsStudio()
local LocalPlayer = Players.LocalPlayer
require(ReplicatedStorage.Types)
local Constant = require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
require(ReplicatedStorage.Config.WeaponConfig)
local RoleConfig = require(ReplicatedStorage.Config.RoleConfig)
require(ReplicatedStorage.Util.Utils)
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
require(ReplicatedStorage.Util.GameUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local RoleService = require(ReplicatedStorage.Remote.RoleService)
local LocalEntity = require(ReplicatedStorage.Remote.EntityService).LocalEntity
local API = require(script.API)
local RoomManager = require(script.RoomManager)
local Room = require(script.RoomManager.Room)
local GameClient = require(script.GameClient)
local LocalGameClient = require(script.GameClient.LocalGameClient)
local t = {
	JoinLater = SimpleSignal.new(),
	GameJoined = GameClient.LocalEvent.Joined,
	GameLeft = GameClient.LocalEvent.Left,
	Paused = SimpleSignal.new(),
	Resumed = SimpleSignal.new(),
	SelectRole = SimpleSignal.new(),
	Respawning = SimpleSignal.new()
}
local t2 = {
	LocalEvent = t,
	API = API,
	RoomManager = RoomManager,
	Room = Room,
	GameClient = GameClient,
	LocalGameClient = LocalGameClient
}
API.GetRoom = Room.Get
function API.WrapRoomRemote(p1, p2) --[[ Line: 61 | Upvalues: Room (copy) ]]
	p1.OnClientEvent:Connect(function(p1, ...) --[[ Line: 62 | Upvalues: Room (ref), p2 (copy) ]]
		local v1 = Room.Get(p1)
		if v1 then
			p2(v1, ...)
		end
	end)
end
function t2.GetRole(p1) --[[ GetRole | Line: 70 | Upvalues: LocalPlayer (copy) ]]
	return (if p1 then p1 else LocalPlayer):GetAttribute("Role")
end
function t2.GetRoleTier(p1) --[[ GetRoleTier | Line: 74 | Upvalues: LocalPlayer (copy) ]]
	return (if p1 then p1 else LocalPlayer):GetAttribute("RoleTier") or 1
end
function t2.GetTeam(p1) --[[ GetTeam | Line: 78 | Upvalues: LocalPlayer (copy) ]]
	return (if p1 then p1 else LocalPlayer):GetAttribute("Team")
end
function t2.IsJoined(p1) --[[ IsJoined | Line: 82 | Upvalues: LocalPlayer (copy), GameClient (copy) ]]
	local v2 = GameClient.Get(if p1 then p1 else LocalPlayer)
	return if v2 then v2:IsJoined() else v2
end
function t2.IsGaming() --[[ IsGaming | Line: 88 | Upvalues: LocalGameClient (copy) ]]
	return LocalGameClient:IsJoined() and LocalGameClient.Room:IsGaming()
end
local v1 = false
function t2.Join(p1) --[[ Join | Line: 94 | Upvalues: t2 (copy), v1 (ref) ]]
	if not (t2.IsJoined() or v1) then
		script.Join:FireServer(p1)
	end
end
function t2.IsJoinLater() --[[ IsJoinLater | Line: 101 | Upvalues: v1 (ref) ]]
	return v1
end
function t2.SetJoinLater() --[[ SetJoinLater | Line: 105 ]] end
function t2.Leave() --[[ Leave | Line: 109 | Upvalues: v1 (ref), t2 (copy), t (copy) ]]
	local v12 = v1
	v1 = false
	if t2.IsJoined() then
		script.Leave:FireServer()
	elseif v12 then
		t.JoinLater:Fire()
	end
end
local t3 = {
	Selecting = false
}
function t3.SetSelecting(p1) --[[ SetSelecting | Line: 125 | Upvalues: t3 (copy), t (copy) ]]
	local v1 = p1 and true or false
	if v1 ~= t3.Selecting then
		t3.Selecting = v1
		t.SelectRole:Fire()
	end
end
function t2.RequestSelectRole() --[[ RequestSelectRole | Line: 134 ]]
	script.SelectRoleRequest:FireServer()
end
function t2.CanRequestSelectRole() --[[ CanRequestSelectRole | Line: 138 | Upvalues: LocalGameClient (copy), Constant (copy), LocalPlayer (copy) ]]
	local Room = LocalGameClient.Room
	if Room then
		return Room:IsModeSet(Constant.GameModeSet.Lobby) or LocalPlayer:GetAttribute("SelectRoleRequest")
	end
end
function t2.IsSelectingRole() --[[ IsSelectingRole | Line: 146 | Upvalues: t3 (copy) ]]
	return t3.Selecting
end
function t2.SelectRole(p1) --[[ SelectRole | Line: 150 | Upvalues: RoleConfig (copy), t3 (copy), RoomManager (copy), RoleService (copy), LocalGameClient (copy) ]]
	if p1 then
		local v1 = RoleConfig[p1]
		if t3.Selecting and (v1 and not v1.Disabled) then
			local v2 = RoomManager.GetFocusedRoom()
			if v2 and v2:CanSelectRole(p1) then
				if not (v2:CanSelectRoleBypass() or RoleService.HasRole(p1)) then
					return
				end
			else
				return
			end
		else
			return
		end
	else
		if (LocalGameClient.Role or "Human") == "Human" then
			return
		end
		t3.SetSelecting()
	end
	script.SelectRole:FireServer(p1)
end
LocalPlayer:GetAttributeChangedSignal("SelectRoleRequest"):Connect(function() --[[ Line: 178 | Upvalues: t (copy) ]]
	t.SelectRole:Fire()
end)
function t2.VoteMap(p1, ...) --[[ VoteMap | Line: 183 ]]
	script.RoomManager.Room.VoteMap:FireServer(p1, ...)
end
local v2 = nil
function t2.IsRespawning() --[[ IsRespawning | Line: 188 | Upvalues: v2 (ref) ]]
	return v2 and true
end
function t2.IsAutoRespawn() --[[ IsAutoRespawn | Line: 192 | Upvalues: v2 (ref) ]]
	return v2 and v2.Auto
end
function t2.IsFastRespawning() --[[ IsFastRespawning | Line: 196 | Upvalues: v2 (ref) ]]
	return v2 and v2.FastRespawning
end
function t2.CanFastRespawn() --[[ CanFastRespawn | Line: 200 | Upvalues: v2 (ref) ]]
	return v2 and v2.FastTime
end
function t2.WaitSpawnDelay() --[[ WaitSpawnDelay | Line: 204 | Upvalues: v2 (ref) ]]
	return v2 and (v2.FastTime and (v2.AtTime and workspace:GetServerTimeNow() >= v2.AtTime + 0.5))
end
function t2.FastRespawn(p1) --[[ FastRespawn | Line: 208 | Upvalues: t2 (copy), v2 (ref), t (copy) ]]
	if t2.CanFastRespawn() and not v2.FastRespawning then
		v2.FastRespawning = true
		if p1 then
			script.Revive:FireServer()
		else
			script.Respawn:FireServer()
		end
		t.Respawning:Fire(p1)
	end
end
function t2.GetRespawnTime() --[[ GetRespawnTime | Line: 224 | Upvalues: v2 (ref), LocalGameClient (copy) ]]
	if v2 then
		local v1 = 3
		local Room = LocalGameClient.Room
		if if Room then Room:GetGameConfig() else Room then
			v1 = v2.Time
			if v2.FastRespawning then
				v1 = v2.FastTime
			end
		end
		return v1 + v2.AtTime, v1
	end
end
function t2.IsClient(p1) --[[ IsClient | Line: 244 | Upvalues: Constant (copy) ]]
	if p1 then
		return p1:IsA("Player") or p1:HasTag(Constant.Tag.GameClient) and p1:IsA("Model")
	end
end
function t2.IsBot(p1) --[[ IsBot | Line: 251 | Upvalues: Constant (copy) ]]
	if p1 then
		return p1:HasTag(Constant.Tag.GameClient) and p1:IsA("Model")
	end
end
function t2.GetUserId(p1) --[[ GetUserId | Line: 258 ]]
	if p1 then
		if p1:IsA("Player") then
			return p1.UserId
		else
			return p1:GetAttribute("FakeUserId") or 0
		end
	else
		return 0
	end
end
function t2.GetDisplayName(p1) --[[ GetDisplayName | Line: 268 ]]
	if p1 then
		if p1:IsA("Player") then
			return p1.DisplayName
		else
			return p1.Name
		end
	else
		return ""
	end
end
local v3 = false
function t2.IsPaused() --[[ IsPaused | Line: 280 | Upvalues: v3 (ref) ]]
	return v3
end
function t2.Pause() --[[ Pause | Line: 284 | Upvalues: v3 (ref), t (copy) ]]
	if not v3 then
		v3 = true
		t.Paused:Fire()
	end
end
function t2.Resume() --[[ Resume | Line: 291 | Upvalues: v3 (ref), t (copy) ]]
	if v3 then
		v3 = false
		t.Resumed:Fire()
	end
end
function t2.GetOrCreateClient(p1) --[[ GetOrCreateClient | Line: 298 | Upvalues: LocalPlayer (copy), LocalGameClient (copy), GameClient (copy), InstanceUtils (copy) ]]
	if p1 and p1.Parent then
		if p1 == LocalPlayer then
			return LocalGameClient
		else
			local v1 = GameClient.Get(p1)
			if v1 then
				return v1
			elseif p1:IsA("Model") and not InstanceUtils.WaitFor(p1, "Humanoid") then
			else
				local v2 = GameClient:new(p1)
				GameClient.Event.Created:Fire(v2)
				return v2
			end
		end
	end
end
function t2.Start() --[[ Start | Line: 327 | Upvalues: InstanceUtils (copy), Constant (copy), t2 (copy), v1 (ref), t (copy), Room (copy), TableUtils (copy), v2 (ref), t3 (copy), LocalEntity (copy), LocalGameClient (copy) ]]
	local GameClient = require(script.GameClient)
	task.spawn(GameClient.onStart)
	local RoomManager = require(script.RoomManager)
	task.spawn(RoomManager.Start)
	InstanceUtils.OnTagged(Constant.Tag.GameClient, function(p1) --[[ Line: 334 | Upvalues: t2 (ref) ]]
		t2.GetOrCreateClient(p1)
	end, function(p1) --[[ Line: 336 | Upvalues: GameClient (copy) ]]
		local v1 = GameClient.Get(p1)
		if v1 then
			v1:Destroy()
		end
	end)
	script.JoinLater.OnClientEvent:Connect(function() --[[ Line: 343 | Upvalues: v1 (ref), t2 (ref), t (ref) ]]
		if not (v1 or t2.IsJoined()) then
			v1 = true
			t.JoinLater:Fire()
		end
	end)
	script.Respawn.OnClientEvent:Connect(function(p1, p2, p3) --[[ Line: 350 | Upvalues: Room (ref), TableUtils (ref), v2 (ref), t (ref) ]]
		if Room.Get(p1) then
			local v1 = if p3 then p3 else TableUtils.EMPTY
			v2 = {
				AtTime = p2,
				Auto = v1.Auto,
				Time = v1.Time,
				FastTime = v1.FastTime
			}
			t.Respawning:Fire(p2)
		end
	end)
	script.SelectRole.OnClientEvent:Connect(function(p1) --[[ Line: 367 | Upvalues: t3 (ref) ]]
		t3.SetSelecting(p1)
	end)
	LocalEntity.LocalEvent.Spawned:Connect(function() --[[ Line: 371 | Upvalues: v2 (ref) ]]
		v2 = nil
	end)
	GameClient.LocalEvent.Joined:ConnectEarly(function() --[[ Line: 375 | Upvalues: v1 (ref), v2 (ref), t3 (ref) ]]
		v1 = false
		v2 = nil
		t3.SetSelecting()
	end)
	GameClient.LocalEvent.Left:Connect(function() --[[ Line: 380 | Upvalues: t3 (ref), v2 (ref), t (ref) ]]
		t3.SetSelecting()
		v2 = nil
		t.SelectRole:Fire()
	end)
	RoomManager.Room.FocusedEvent.RoundEnded:Connect(function(p1) --[[ Line: 386 | Upvalues: LocalGameClient (ref), t3 (ref), t (ref) ]]
		if p1 == LocalGameClient.Room then
			t3.SetSelecting()
			t.SelectRole:Fire()
		end
	end)
end
return TableUtils.Protect(t2)