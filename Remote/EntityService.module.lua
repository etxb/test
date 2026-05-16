-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.EntityService

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Constant = require(ReplicatedStorage.Constant)
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
require(ReplicatedStorage.Util.TableUtils)
local GameUtils = require(ReplicatedStorage.Util.GameUtils)
require(ReplicatedStorage.Shared.SimpleSignal)
require(ReplicatedStorage.Remote.InstanceDataService)
local WorldManager = require(script.WorldManager)
local v1 = require(ReplicatedStorage.Common.EntityService)
local function isLocalEntity(p1) --[[ isLocalEntity | Line: 29 | Upvalues: LocalPlayer (copy) ]]
	return p1.Instance == LocalPlayer
end
local Entity = require(script.Entity)
local v2 = InstanceUtils.LoadModuleScripts(script.Entity, {
	Filter = function(p1) --[[ Filter | Line: 33 ]]
		return p1 ~= script.Entity.HumanoidEntity.PlayerEntity.LocalEntity
	end,
	OnLoad = function(p1, p2) --[[ OnLoad | Line: 36 | Upvalues: GameUtils (copy), isLocalEntity (copy) ]]
		GameUtils.CreateSymbol(p2, p1.Name)
		local v1 = rawget(p2, "Event")
		local v2 = rawget(p2, "LocalEvent")
		if v2 and v1 then
			GameUtils.ForwardLocal(v1, v2, {
				LocalFilter = isLocalEntity
			})
		end
		local v3 = rawget(p2, "Signal")
		local v4 = rawget(p2, "LocalSignal")
		if v4 and v3 then
			GameUtils.ForwardLocal(v3, v4, {
				LocalFilter = isLocalEntity
			})
		end
	end
})
GameUtils.CreateSymbol(Entity)
GameUtils.ForwardLocal(Entity.Event, Entity.LocalEvent, {
	LocalFilter = isLocalEntity
})
GameUtils.ForwardLocal(Entity.Signal, Entity.LocalSignal, {
	LocalFilter = isLocalEntity
})
local t = {}
local t2 = {}
local t3 = {
	Event = {},
	Common = v1,
	Entity = Entity,
	WorldManager = WorldManager,
	World = WorldManager.World,
	GetTeam = function(p1) --[[ GetTeam | Line: 85 | Upvalues: Entity (copy), LocalPlayer (copy) ]]
		local v2 = Entity.Get(if p1 then p1 else LocalPlayer)
		return if v2 then v2.Team else v2
	end,
	GetMaxHealth = function(p1) --[[ GetMaxHealth | Line: 90 | Upvalues: Entity (copy), LocalPlayer (copy) ]]
		local v2 = Entity.Get(if p1 then p1 else LocalPlayer)
		return if v2 then v2.MaxHealth else v2
	end,
	GetHealth = function(p1) --[[ GetHealth | Line: 95 | Upvalues: Entity (copy), LocalPlayer (copy) ]]
		local v2 = Entity.Get(if p1 then p1 else LocalPlayer)
		return if v2 then v2.Health else v2
	end,
	IsAlive = function(p1) --[[ IsAlive | Line: 100 | Upvalues: Entity (copy), LocalPlayer (copy) ]]
		local v2 = Entity.Get(if p1 then p1 else LocalPlayer)
		return if v2 then v2:IsAlive() else v2
	end,
	GetCollision = function(p1, p2) --[[ GetCollision | Line: 105 | Upvalues: Entity (copy), LocalPlayer (copy) ]]
		local v2 = Entity.Get(if p1 then p1 else LocalPlayer)
		return if v2 then v2:GetCollision(p2) else v2
	end,
	IsFriendly = function(p1, p2) --[[ IsFriendly | Line: 110 | Upvalues: Entity (copy), LocalPlayer (copy) ]]
		if p1 then
			local v1 = Entity.Get(p1)
			local v3 = Entity.Get(if p2 then p2 else LocalPlayer)
			return if v3 == v1 then true else v3:IsFriendly(v1)
		else
			return not p2
		end
	end,
	IsLocalEntity = isLocalEntity,
	SetEntityRef = function(p1, p2) --[[ SetEntityRef | Line: 123 | Upvalues: Entity (copy), t (copy), t2 (copy), Constant (copy) ]]
		if Entity:is(p1) then
			local v1 = t[p2]
			if v1 and v1 ~= p1 then
				t2[v1.Instance] = nil
			end
			local v2 = t2[p1.Instance]
			if v2 and v2 ~= p2 then
				v2:RemoveTag(Constant.Tag.EntityRef)
				t[v2] = nil
			end
			if p2 then
				p2:AddTag(Constant.Tag.EntityRef)
				t[p2] = p1
			end
			t2[p1.Instance] = p2
		else
			warn("\"entity\" is not a Entity")
		end
	end,
	RemoveRef = function(p1) --[[ RemoveRef | Line: 148 | Upvalues: t (copy), t2 (copy) ]]
		local v1 = t[p1]
		if v1 then
			t[p1] = nil
			if t2[v1.Instance] == p1 then
				t2[v1.Instance] = nil
			end
		end
	end,
	GetEntity = function(p1) --[[ GetEntity | Line: 159 | Upvalues: t (copy), Entity (copy) ]]
		return t[p1] or Entity.Get(p1)
	end
}
Entity.Event.Destroying:Connect(function(p1) --[[ Line: 163 | Upvalues: t2 (copy), t (copy) ]]
	local v1 = t2[p1.Instance]
	if v1 then
		t2[p1.Instance] = nil
		if t[v1] == p1 then
			t[v1] = nil
		end
	end
end)
function t3.FetchEntity(p1) --[[ FetchEntity | Line: 174 | Upvalues: Constant (copy), t3 (copy), Players (copy) ]]
	local v1 = if p1:IsA("Model") and p1 then p1 else p1.Parent
	if v1 and (v1:IsA("Folder") or (v1.Name == "Collider" or v1:IsA("Accessory"))) then
		v1 = v1.Parent
	end
	if v1 and v1:HasTag(Constant.Tag.EntityCollider) then
		v1 = v1.Parent
	end
	if v1 and v1:IsA("Model") then
		if v1:HasTag(Constant.Tag.Entity) then
			return t3.GetEntity(v1)
		else
			return t3.GetEntity(Players:GetPlayerFromCharacter(v1) or v1)
		end
	end
end
local LocalEntity = require(script.Entity.HumanoidEntity.PlayerEntity.LocalEntity)
function t3.GetOrCreateEntity(p1) --[[ GetOrCreateEntity | Line: 194 | Upvalues: LocalPlayer (copy), LocalEntity (copy), Entity (copy), Constant (copy), GameUtils (copy), v2 (copy) ]]
	if p1 and p1.Parent then
		if p1 == LocalPlayer then
			return LocalEntity
		else
			local v1 = Entity.Get(p1)
			if v1 then
				return v1
			elseif p1:HasTag(Constant.Tag.Entity) then
				local v22 = p1:GetAttribute("_entity")
				if v22 then
					local v3 = v22 == "." and Entity or (GameUtils.FindModuleTree(v2, v22) or v22)
					local v4
					if typeof(v3) == "string" then
						warn("[Entity] unknown entity module", v3)
						v4 = Entity
					else
						v4 = v3
					end
					return v4:Create(p1)
				end
			end
		end
	end
end
InstanceUtils.OnTagged(Constant.Tag.Entity, function(p1) --[[ Line: 222 | Upvalues: LocalPlayer (copy), t3 (copy) ]]
	if p1 ~= LocalPlayer then
		t3.GetOrCreateEntity(p1)
	end
end, function(p1) --[[ Line: 227 | Upvalues: Entity (copy) ]]
	local v1 = Entity.Get(p1)
	if v1 then
		v1:Destroy()
	end
end)
function t3.GetLocalEntity() --[[ GetLocalEntity | Line: 234 | Upvalues: LocalEntity (copy) ]]
	return LocalEntity
end
t3.LocalEntity = LocalEntity
function t3.Start() --[[ Start | Line: 240 | Upvalues: Entity (copy), v2 (copy), LocalEntity (copy), WorldManager (copy), GameUtils (copy), RunService (copy), LocalPlayer (copy) ]]
	Entity.onStart()
	for v1, v22 in v2 do
		local v3 = rawget(v22, "onStart")
		if v3 then
			v3()
		end
	end
	LocalEntity.onStart()
	WorldManager.Start()
	GameUtils.CacheParentForeach(v2)
	local HumanoidEntity = require(script.Entity.HumanoidEntity)
	RunService.PreSimulation:Connect(function(p1) --[[ Line: 256 | Upvalues: Entity (ref), HumanoidEntity (copy), LocalPlayer (ref), WorldManager (ref) ]]
		for v1, v2 in Entity.GetAllByType(HumanoidEntity) do
			if (v2.Instance == LocalPlayer or not (os.clock() - (v2._moveDirectionUpdateTime or 0) < 0.16666666666666666)) and WorldManager.IsFocusedEntity(v2) then
				v2._moveDirectionUpdateTime = os.clock()
				v2:UpdateMoveDirection()
			end
		end
	end)
	task.spawn(function() --[[ Line: 270 | Upvalues: WorldManager (ref) ]]
		while task.wait(0.1) do
			debug.profilebegin("flagsTimeout")
			local v1 = workspace:GetServerTimeNow()
			local v2 = WorldManager.GetFocusedWorld()
			if v2 then
				for v3, v4 in v2.Entities do
					local FlagsSourceTimeout = v4.FlagsSourceTimeout
					for v5, v6 in FlagsSourceTimeout do
						if v4:HasFlag(v5) then
							for v7, v8 in v6 do
								if v8.Timeout < v1 then
									v6[v7] = nil
								end
							end
							if not next(v6) then
								FlagsSourceTimeout[v5] = nil
							end
							continue
						end
						FlagsSourceTimeout[v5] = nil
					end
				end
			end
			debug.profileend()
		end
	end)
end
return t3