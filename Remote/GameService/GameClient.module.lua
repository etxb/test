-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.GameService.GameClient

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Constant = require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
require(ReplicatedStorage.Util.Utils)
local GameUtils = require(ReplicatedStorage.Util.GameUtils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
require(ReplicatedStorage.Util.InstanceUtils)
local TaskHolder = require(ReplicatedStorage.Util.TaskHolder)
local ConnectionHolder = require(ReplicatedStorage.Util.ConnectionHolder)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local EntityService = require(ReplicatedStorage.Remote.EntityService)
local Entity = require(ReplicatedStorage.Remote.EntityService.Entity)
local t = {
	Created = SimpleSignal.new(),
	Destroying = SimpleSignal.new(),
	Destroyed = SimpleSignal.new(),
	Joined = SimpleSignal.new(),
	Leaving = SimpleSignal.new(),
	Left = SimpleSignal.new(),
	Killed = SimpleSignal.new(),
	Assist = SimpleSignal.new(),
	RoleChanged = SimpleSignal.new(),
	RoleTierChanged = SimpleSignal.new(),
	TeamChanged = SimpleSignal.new()
}
local t2 = {
	Destroying = SimpleSignal.new(),
	Destroyed = SimpleSignal.new(),
	Joined = SimpleSignal.new(),
	Leaving = SimpleSignal.new(),
	Left = SimpleSignal.new(),
	Killed = SimpleSignal.new(),
	Assist = SimpleSignal.new(),
	RoleChanged = SimpleSignal.new(),
	RoleTierChanged = SimpleSignal.new(),
	TeamChanged = SimpleSignal.new()
}
local t3 = {
	Destroying = SimpleSignal.new(),
	Destroyed = SimpleSignal.new(),
	Joined = SimpleSignal.new(),
	Leaving = SimpleSignal.new(),
	Left = SimpleSignal.new(),
	Killed = SimpleSignal.new(),
	Assist = SimpleSignal.new(),
	RoleChanged = SimpleSignal.new(),
	RoleTierChanged = SimpleSignal.new(),
	TeamChanged = SimpleSignal.new()
}
GameUtils.ForwardLocal(t, t3, {
	LocalFilter = function(p1) --[[ LocalFilter | Line: 76 | Upvalues: LocalPlayer (copy) ]]
		return p1.Instance == LocalPlayer
	end
})
local t4 = {
	Instance = nil,
	Role = nil,
	Event = t,
	FocusedEvent = t2,
	LocalEvent = t3
}
t4.__index = t4
function t4.__tostring(p1) --[[ Line: 93 ]]
	return ("GameClient[%s]"):format(p1.Instance.Name)
end
local v1 = TableUtils.NewDict()
function t4.GetAll() --[[ GetAll | Line: 102 | Upvalues: v1 (copy) ]]
	return v1
end
function t4.Get(p1) --[[ Get | Line: 106 | Upvalues: v1 (copy) ]]
	return v1[p1]
end
function t4.new(p1, p2) --[[ new | Line: 110 | Upvalues: EntityService (copy), TaskHolder (copy), ConnectionHolder (copy), t (copy), v1 (copy) ]]
	local v12 = setmetatable({
		Instance = p2,
		Entity = EntityService.GetOrCreateEntity(p2),
		Tasks = TaskHolder:new(),
		Connections = ConnectionHolder:new(),
		GameConnections = ConnectionHolder:new()
	}, p1)
	if p2:IsA("Player") then
		v12.Player = p2
	else
		v12.Bot = p2
	end
	v12.Role = v12.Instance:GetAttribute("Role")
	v12.Connections:AddConnection("role", p2:GetAttributeChangedSignal("Role"):Connect(function() --[[ Line: 125 | Upvalues: v12 (copy), p2 (copy), t (ref) ]]
		local Role = v12.Role
		v12.Role = p2:GetAttribute("Role")
		t.RoleChanged:Fire(v12, v12.Role, Role)
	end))
	v12.Connections:AddConnection("roleTier", p2:GetAttributeChangedSignal("RoleTier"):Connect(function() --[[ Line: 130 | Upvalues: t (ref), v12 (copy) ]]
		t.RoleTierChanged:Fire(v12)
	end))
	if p2:IsA("Player") then
		v12.Connections:AddConnection("destroy", p2.AncestryChanged:Connect(function() --[[ Line: 135 | Upvalues: p2 (copy), v12 (copy) ]]
			if not p2.Parent then
				task.delay(3, function() --[[ Line: 137 | Upvalues: v12 (ref) ]]
					v12:Destroy()
				end)
			end
		end))
	end
	v12.Connections:AddConnection("destroy", p2.Destroying:Connect(function() --[[ Line: 143 | Upvalues: v12 (copy) ]]
		task.delay(3, function() --[[ Line: 144 | Upvalues: v12 (ref) ]]
			v12:Destroy()
		end)
	end))
	v1[p2] = v12
	return v12
end
function t4.GetEntity(p1) --[[ GetEntity | Line: 155 ]]
	return p1.Entity
end
function t4.IsFriendly(p1, p2) --[[ IsFriendly | Line: 159 ]]
	if p2 then
		if p2 == p1 then
			return true
		else
			local v1 = p2:GetEntity()
			local v2 = p1:GetEntity()
			if v2 then
				return v2:IsFriendly(v1)
			end
		end
	end
end
function t4.GetTeam(p1) --[[ GetTeam | Line: 174 | Upvalues: Constant (copy) ]]
	local v1 = p1:GetEntity()
	return p1:GetEntity() and v1.Team or Constant.Team.Default
end
function t4.IsJoined(p1) --[[ IsJoined | Line: 179 ]]
	return p1.Room and true
end
function t4.GetDisplayName(p1) --[[ GetDisplayName | Line: 184 ]]
	local v1 = p1:GetEntity()
	return if v1 then v1:GetDisplayName() or "#unnamed" else "#unnamed"
end
function t4.GetUserId(p1) --[[ GetUserId | Line: 189 ]]
	if p1.Instance:IsA("Player") then
		return p1.Instance.UserId
	else
		return p1.Instance:GetAttribute("FakeUserId") or 0
	end
end
function t4.Destroy(p1) --[[ Destroy | Line: 196 | Upvalues: t (copy), v1 (copy) ]]
	if not p1.Destroyed then
		t.Destroying:Fire(p1)
		if p1.Room then
			p1.Room:Leave(p1)
		end
		t.Destroying:Fire(p1)
		v1[p1.Instance] = nil
		p1.Entity:Destroy()
		p1.Tasks:Destroy()
		p1.Connections:Destroy()
		p1.Destroyed = true
		t.Destroyed:Fire(p1)
	end
end
function t4.onStart() --[[ onStart | Line: 217 | Upvalues: Entity (copy), t4 (copy), t (copy) ]]
	Entity.Event.TeamChanged:Connect(function(p1, p2, p3) --[[ Line: 218 | Upvalues: t4 (ref), t (ref) ]]
		local v1 = t4.Get(p1.Instance)
		if v1 then
			t.TeamChanged:Fire(v1, p2, p3)
		end
	end)
	script.RoleChanged.OnClientEvent:Connect(function() --[[ Line: 224 ]] end)
	script.RoleTierChanged.OnClientEvent:Connect(function() --[[ Line: 227 ]] end)
	script.RoleTierChanged.OnClientEvent:Connect(function() --[[ Line: 230 ]] end)
	script.Killed.OnClientEvent:Connect(function(p1, p2, p3, p4) --[[ Line: 233 | Upvalues: t4 (ref), t (ref) ]]
		local v1 = t4.Get(p1)
		local v2 = t4.Get(p2)
		if v1 and (v2 and (v1.Room and v1.Room == v2.Room)) and v2:GetEntity() then
			local v3 = t4.Get(p4.AssistDamager)
			p4.AssistDamager = v3
			t.Killed:Fire(v1, v2, p3, p4)
			if v3 then
				t.Assist:Fire(v3, v1, v2, p3, p4)
			end
		end
	end)
end
return t4