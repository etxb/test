-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.EntityService.WorldManager.World

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
local ConnectionHolder = require(ReplicatedStorage.Util.ConnectionHolder)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local Entity = require(ReplicatedStorage.Remote.EntityService.Entity)
local t = {
	Created = SimpleSignal.new(),
	EntityAdded = SimpleSignal.new(),
	EntityRemoved = SimpleSignal.new(),
	Deploy = SimpleSignal.new(),
	Undeploy = SimpleSignal.new(),
	Destroying = SimpleSignal.new(),
	Destroyed = SimpleSignal.new()
}
local t2 = {
	Instance = nil,
	Entities = nil,
	EntitiesByTeam = nil,
	TaggedEntities = nil,
	Event = t,
	FocusedEvent = {
		EntityAdded = SimpleSignal.new(),
		EntityRemoved = SimpleSignal.new(),
		Destroying = SimpleSignal.new(),
		Destroyed = SimpleSignal.new()
	}
}
t2.__index = t2
function t2.__tostring(p1) --[[ Line: 45 ]]
	return ("World[%s]"):format(p1.Instance.Name)
end
local t3 = {}
local t4 = {}
local t5 = {}
function t2.Get(p1) --[[ Get | Line: 55 | Upvalues: t3 (copy), Constant (copy), t2 (copy) ]]
	local v1 = t3[p1]
	if not v1 and (p1.Parent and p1:HasTag(Constant.Tag.EntityWorld)) then
		v1 = t2:new(p1)
	end
	return v1
end
function t2.GetByName(p1) --[[ GetByName | Line: 63 | Upvalues: t4 (copy) ]]
	return t4[p1]
end
function t2.GetById(p1) --[[ GetById | Line: 67 | Upvalues: t5 (copy) ]]
	return t5[p1]
end
function t2.new(p1, p2) --[[ new | Line: 71 | Upvalues: TableUtils (copy), ConnectionHolder (copy), t3 (copy), t5 (copy), t4 (copy), t (copy) ]]
	local v1 = setmetatable({
		Instance = p2,
		Id = p2:GetAttribute("Id"),
		Name = p2.Name,
		Entities = TableUtils.NewDict(),
		EntitiesByTeam = TableUtils.AutoTable({}, TableUtils.NewDict),
		TaggedEntities = TableUtils.AutoTable({}, TableUtils.NewDict),
		Connections = ConnectionHolder:new()
	}, p1)
	v1.Connections:AddConnection("destroy", p2.Destroying:Connect(function() --[[ Line: 84 | Upvalues: v1 (copy) ]]
		v1:Destroy()
	end))
	t3[p2] = v1
	t5[v1.Id] = v1
	t4[v1.Name] = v1
	t.Created:Fire(v1)
	return v1
end
function t2._UpdateEntityTeam(p1, p2, p3, p4) --[[ _UpdateEntityTeam | Line: 99 ]]
	if p4 then
		p1.EntitiesByTeam[p4][p2.Instance] = nil
	end
	if p3 then
		p1.EntitiesByTeam[p3][p2.Instance] = p2
	end
end
function t2.AddEntity(p1, p2) --[[ AddEntity | Line: 108 | Upvalues: t (copy) ]]
	if p2.World ~= p1 then
		if p2.World then
			p2.World:RemoveEntity(p2)
		end
		p2.World = p1
		p1.Entities[p2.Instance] = p2
		p1:_UpdateEntityTeam(p2, p2.Team)
		t.EntityAdded:Fire(p1, p2)
	end
end
function t2.RemoveEntity(p1, p2) --[[ RemoveEntity | Line: 125 | Upvalues: t (copy) ]]
	if p2.World == p1 then
		p2.World = nil
		p1.Entities[p2.Instance] = nil
		p1:_UpdateEntityTeam(p2, nil, p2.Team)
		t.EntityRemoved:Fire(p1, p2)
	end
end
function t2.GetEntitiesByTeam(p1, p2) --[[ GetEntitiesByTeam | Line: 140 | Upvalues: TableUtils (copy) ]]
	return rawget(p1.EntitiesByTeam, p2) or TableUtils.EMPTY
end
function t2.ForeachEnemies(p1, p2, p3) --[[ ForeachEnemies | Line: 144 ]]
	local v1 = false
	for v2, v3 in p1.EntitiesByTeam do
		if not p2:IsFriendlyTeam(v2) then
			for v4, v5 in v3 do
				if not v5:IsFriendly(p2) and p3(v5) then
					v1 = true
					break
				end
			end
			if v1 then
				break
			end
		end
	end
end
function t2.SetFriendlyHook(p1, p2) --[[ SetFriendlyHook | Line: 165 ]]
	if typeof(p2) == "function" then
		p2 = {
			Team = p2
		}
	end
	if p2 and not p2.Entity then
		function p2.Entity(p1, p22) --[[ Line: 172 | Upvalues: p2 (ref) ]]
			return p2.Team(p1.Team, p22.Team)
		end
	end
	p1._FriendlyHook = p2
end
function t2.IsFriendlyTeam(p1, p2, p3) --[[ IsFriendlyTeam | Line: 179 ]]
	local _FriendlyHook = p1._FriendlyHook
	if _FriendlyHook then
		return _FriendlyHook.Team(p2, p3)
	else
		return p2 == p3
	end
end
function t2.IsFriendly(p1, p2, p3) --[[ IsFriendly | Line: 187 ]]
	local _FriendlyHook = p1._FriendlyHook
	if _FriendlyHook then
		return _FriendlyHook.Entity(p2, p3)
	else
		return if p2 == p3 then true else p1:IsFriendlyTeam(p2.Team, p3.Team)
	end
end
function t2.Deploy(p1) --[[ Deploy | Line: 195 | Upvalues: t (copy) ]]
	if not p1.Deployed then
		p1.Deployed = true
		p1.Instance.Parent = workspace.World
		t.Deploy:Fire(p1)
	end
end
function t2.Undeploy(p1) --[[ Undeploy | Line: 204 | Upvalues: ReplicatedStorage (copy), t (copy) ]]
	if p1.Deployed then
		p1.Deployed = nil
		if p1.Instance.Parent then
			p1.Instance.Parent = ReplicatedStorage.Assets.Temp
		end
		t.Undeploy:Fire(p1)
	end
end
function t2.Destroy(p1) --[[ Destroy | Line: 215 | Upvalues: t (copy), t3 (copy), t5 (copy), t4 (copy) ]]
	p1.Connections:Destroy()
	t.Destroying:Fire(p1)
	t3[p1.Instance] = nil
	t5[p1.Id] = nil
	t4[p1.Name] = nil
	t.Destroyed:Fire(p1)
end
function t2.onStart() --[[ onStart | Line: 229 | Upvalues: InstanceUtils (copy), Constant (copy), t3 (copy), t2 (copy), TableUtils (copy), Entity (copy) ]]
	InstanceUtils.OnTagged(Constant.Tag.EntityWorld, function(p1) --[[ Line: 230 | Upvalues: t3 (ref), t2 (ref) ]]
		if not t3[p1] then
			t2:new(p1)
		end
	end)
	local v1 = TableUtils.AutoTable()
	t2.Event.Created:Connect(function(p1) --[[ Line: 237 | Upvalues: v1 (copy), Entity (ref) ]]
		local v3 = rawget(v1, p1.Name)
		v1[p1.Name] = nil
		if v3 then
			for v4, v5 in v3 do
				local v6 = Entity.Get(v4)
				if v6 then
					p1:AddEntity(v6)
				end
			end
		end
	end)
	local function listenEntityWorld(p1) --[[ listenEntityWorld | Line: 250 | Upvalues: t2 (ref), v1 (copy) ]]
		local v12 = nil
		local function updateJoinWorld() --[[ updateJoinWorld | Line: 253 | Upvalues: p1 (copy), v12 (ref), t2 (ref), v1 (ref) ]]
			if p1.World then
				p1.World:RemoveEntity(p1)
			end
			if v12 then
				v12[p1.Instance] = nil
			end
			v12 = nil
			local v13 = p1.Instance:GetAttribute("World")
			local v2 = t2.GetByName(v13)
			if v2 then
				v2:AddEntity(p1)
			elseif v13 then
				v12 = v1[v13]
				v12[p1.Instance] = true
			end
		end
		p1.Connections:AddConnection("world", p1.Instance:GetAttributeChangedSignal("World"):Connect(updateJoinWorld))
		updateJoinWorld()
	end
	Entity.Event.Created:Connect(listenEntityWorld)
	for v2, v3 in Entity.GetAll() do
		task.spawn(listenEntityWorld, v3)
	end
	Entity.Event.Destroying:Connect(function(p1) --[[ Line: 285 ]]
		if p1.World then
			p1.World:RemoveEntity(p1)
		end
	end)
	Entity.Event.TeamChanged:Connect(function(p1, p2, p3) --[[ Line: 290 ]]
		local World = p1.World
		if World then
			World:_UpdateEntityTeam(p1, p2, p3)
		end
	end)
end
return t2