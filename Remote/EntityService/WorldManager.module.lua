-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.EntityService.WorldManager

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Util.Utils)
local GameUtils = require(ReplicatedStorage.Util.GameUtils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
require(ReplicatedStorage.Util.InstanceUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local Entity = require(ReplicatedStorage.Remote.EntityService.Entity)
local LocalEntity = require(ReplicatedStorage.Remote.EntityService.Entity.HumanoidEntity.PlayerEntity.LocalEntity)
local World = require(script.World)
local t = {
	FocusedWorldChanged = SimpleSignal.new(),
	EntityFocus = SimpleSignal.new(),
	EntityUnfocus = SimpleSignal.new()
}
local t2 = {
	Event = t,
	World = World
}
local v1 = nil
function t2.GetFocusedWorld() --[[ GetFocusedWorld | Line: 30 | Upvalues: v1 (ref), LocalEntity (copy) ]]
	return v1 or LocalEntity.World
end
function t2.SetFocusedWorld(p1) --[[ SetFocusedWorld | Line: 34 | Upvalues: v1 (ref), t2 (copy), t (copy) ]]
	local v12 = p1 or nil
	if v1 ~= v12 then
		local v2 = t2.GetFocusedWorld()
		v1 = v12
		t.FocusedWorldChanged:Fire(t2.GetFocusedWorld(), v2)
	end
end
function t2.IsFocusedEntity(p1) --[[ IsFocusedEntity | Line: 44 | Upvalues: v1 (ref), LocalEntity (copy) ]]
	return p1 and p1.World == (v1 or LocalEntity.World)
end
function t2.GetFocusedEntities() --[[ GetFocusedEntities | Line: 48 | Upvalues: t2 (copy), TableUtils (copy) ]]
	local v1 = t2.GetFocusedWorld()
	if v1 then
		return v1.Entities
	else
		return TableUtils.EMPTY
	end
end
function t2.Start() --[[ Start | Line: 56 | Upvalues: World (copy), GameUtils (copy), t2 (copy), Entity (copy), ReplicatedStorage (copy), LocalEntity (copy), t (copy), v1 (ref) ]]
	task.spawn(World.onStart)
	GameUtils.Forward(World.Event, World.FocusedEvent, function(p1) --[[ Line: 59 | Upvalues: t2 (ref) ]]
		return p1 == t2.GetFocusedWorld()
	end)
	local function forwardEntityEvent(p1) --[[ forwardEntityEvent | Line: 63 | Upvalues: GameUtils (ref), t2 (ref) ]]
		local v1 = rawget(p1, "Event")
		local v2 = rawget(p1, "FocusedEvent")
		if v1 and v2 then
			GameUtils.Forward(v1, v2, t2.IsFocusedEntity)
		end
		local v3 = rawget(p1, "Signal")
		local v4 = rawget(p1, "FocusedSignal")
		if v3 and v4 then
			GameUtils.Forward(v3, v4, t2.IsFocusedEntity)
		end
	end
	local v12 = Entity
	local v2 = rawget(v12, "Event")
	local v3 = rawget(v12, "FocusedEvent")
	if v2 and v3 then
		GameUtils.Forward(v2, v3, t2.IsFocusedEntity)
	end
	local v4 = rawget(v12, "Signal")
	local v5 = rawget(v12, "FocusedSignal")
	if v4 and v5 then
		GameUtils.Forward(v4, v5, t2.IsFocusedEntity)
	end
	for v6, v7 in ReplicatedStorage.Remote.EntityService.Entity:GetDescendants() do
		if v7:IsA("ModuleScript") then
			local v8 = require(v7)
			if v8 ~= LocalEntity then
				local v9 = rawget(v8, "Event")
				local v10 = rawget(v8, "FocusedEvent")
				if v9 and v10 then
					GameUtils.Forward(v9, v10, t2.IsFocusedEntity)
				end
				local v11 = rawget(v8, "Signal")
				local v122 = rawget(v8, "FocusedSignal")
				if v11 and v122 then
					GameUtils.Forward(v11, v122, t2.IsFocusedEntity)
				end
			end
		end
	end
	local v13 = nil
	local v14 = nil
	World.Event.EntityAdded:Connect(function(p1, p2) --[[ Line: 90 | Upvalues: LocalEntity (ref), v13 (ref), t2 (ref), v14 (ref), t (ref) ]]
		if p2 == LocalEntity then
			if v13 then
				v13:Undeploy()
			end
			p1:Deploy()
			local v1 = t2.GetFocusedWorld()
			if v1 ~= v14 then
				t.FocusedWorldChanged:Fire(v1, v14)
			end
			v13 = nil
			v14 = nil
		elseif t2.IsFocusedEntity(p2) then
			t.EntityFocus:Fire(p2)
		end
	end)
	World.Event.EntityRemoved:Connect(function(p1, p2) --[[ Line: 106 | Upvalues: LocalEntity (ref), v13 (ref), v14 (ref), v1 (ref), t2 (ref), t (ref) ]]
		if p2 == LocalEntity then
			v13 = p1
			v14 = v1 or p1
		elseif p1 == t2.GetFocusedWorld() then
			t.EntityUnfocus:Fire(p2)
		end
	end)
	t.FocusedWorldChanged:Connect(function(p1, p2) --[[ Line: 120 | Upvalues: t (ref), LocalEntity (ref) ]]
		if p2 then
			for v1, v2 in p2.Entities do
				t.EntityUnfocus:Fire(v2)
			end
			if p2 ~= LocalEntity.World then
				p2:Undeploy()
			end
		end
		if p1 then
			p1:Deploy()
			for v3, v4 in p1.Entities do
				t.EntityFocus:Fire(v4)
			end
		end
	end)
end
return t2