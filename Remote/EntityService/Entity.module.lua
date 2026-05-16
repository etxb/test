-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.EntityService.Entity

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Constant = require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local Utils = require(ReplicatedStorage.Util.Utils)
require(ReplicatedStorage.Util.InstanceUtils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local GameUtils = require(ReplicatedStorage.Util.GameUtils)
local ConnectionHolder = require(ReplicatedStorage.Util.ConnectionHolder)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local NetworkHelper = require(ReplicatedStorage.Common.NetworkHelper)
require(ReplicatedStorage.Remote.InstanceDataService)
local EntityService = ReplicatedStorage.Remote.EntityService
local CommonEntity = require(ReplicatedStorage.Common.EntityService.CommonEntity)
local t = {
	Created = SimpleSignal.new(),
	Destroying = SimpleSignal.new(),
	Destroyed = SimpleSignal.new(),
	CustomModelChanged = SimpleSignal.new(),
	Spawned = SimpleSignal.new(),
	Died = SimpleSignal.new(),
	Killed = SimpleSignal.new(),
	Assist = SimpleSignal.new(),
	ShieldChanged = SimpleSignal.new(),
	HealthChanged = SimpleSignal.new(),
	HealthRegen = SimpleSignal.new(),
	Damaged = SimpleSignal.new(),
	BeDamaged = SimpleSignal.new(),
	Teleported = SimpleSignal.new(),
	TeamChanged = SimpleSignal.new(),
	StateChanged = SimpleSignal.new(),
	FlagsChanged = SimpleSignal.new(),
	FlagsTimeChanged = SimpleSignal.new(),
	WalkSpeedChanged = SimpleSignal.new(),
	ScaleChanged = SimpleSignal.new()
}
t.__index = t
local t2 = {
	Destroying = SimpleSignal.new(),
	Destroyed = SimpleSignal.new(),
	CustomModelChanged = SimpleSignal.new(),
	Spawned = SimpleSignal.new(),
	Died = SimpleSignal.new(),
	Killed = SimpleSignal.new(),
	Assist = SimpleSignal.new(),
	ShieldChanged = SimpleSignal.new(),
	HealthChanged = SimpleSignal.new(),
	HealthRegen = SimpleSignal.new(),
	Damaged = SimpleSignal.new(),
	BeDamaged = SimpleSignal.new(),
	Teleported = SimpleSignal.new(),
	TeamChanged = SimpleSignal.new(),
	StateChanged = SimpleSignal.new(),
	FlagsChanged = SimpleSignal.new(),
	FlagsTimeChanged = SimpleSignal.new(),
	WalkSpeedChanged = SimpleSignal.new(),
	ScaleChanged = SimpleSignal.new()
}
t2.__index = t2
local t3 = {
	CustomModelChanged = SimpleSignal.new(),
	Spawned = SimpleSignal.new(),
	Died = SimpleSignal.new(),
	Killed = SimpleSignal.new(),
	Assist = SimpleSignal.new(),
	ShieldChanged = SimpleSignal.new(),
	HealthChanged = SimpleSignal.new(),
	HealthRegen = SimpleSignal.new(),
	Damaged = SimpleSignal.new(),
	BeDamaged = SimpleSignal.new(),
	Teleported = SimpleSignal.new(),
	TeamChanged = SimpleSignal.new(),
	StateChanged = SimpleSignal.new(),
	FlagsChanged = SimpleSignal.new(),
	FlagsTimeChanged = SimpleSignal.new(),
	WalkSpeedChanged = SimpleSignal.new(),
	ScaleChanged = SimpleSignal.new()
}
t3.__index = t3
local t4 = {
	FlagChanged = TableUtils.WrapGet({}, SimpleSignal.new),
	FlagTimeChanged = TableUtils.WrapGet({}, SimpleSignal.new)
}
local t5 = {
	FlagChanged = TableUtils.WrapGet({}, SimpleSignal.new),
	FlagTimeChanged = TableUtils.WrapGet({}, SimpleSignal.new)
}
local t6 = {
	Instance = nil,
	Shield = 0,
	TempShield = 0,
	Health = 100,
	MaxHealth = 100,
	Pitch = 0,
	Yaw = 0,
	Scale = 1,
	FlagsSourceTimeout = nil,
	Event = t,
	LocalEvent = t3,
	FocusedEvent = t2,
	Signal = t4,
	LocalSignal = {
		FlagChanged = TableUtils.WrapGet({}, SimpleSignal.new),
		FlagTimeChanged = TableUtils.WrapGet({}, SimpleSignal.new)
	},
	FocusedSignal = t5,
	State = CommonEntity.State,
	Flag = CommonEntity.Flag,
	Team = Constant.Team.Default,
	WalkSpeed = StarterPlayer.CharacterWalkSpeed
}
t6.__index = t6
function t6.__tostring(p1) --[[ Line: 169 ]]
	return ("Entity[%s]"):format(p1.Instance.Name)
end
t6.GetFlagChangedSignal = t4.FlagChanged.GetOrCreate
local v1 = TableUtils.NewDict()
local v2 = TableUtils.AutoTable({}, function() --[[ Line: 179 | Upvalues: TableUtils (copy) ]]
	return TableUtils.NewDict()
end)
function t6.GetAll() --[[ GetAll | Line: 181 | Upvalues: v1 (copy) ]]
	return v1
end
function t6.GetAllByType(p1) --[[ GetAllByType | Line: 185 | Upvalues: v2 (copy) ]]
	return v2[p1]
end
function t6.Get(p1) --[[ Get | Line: 189 | Upvalues: v1 (copy) ]]
	return v1[p1]
end
local function addEntity(p1) --[[ addEntity | Line: 193 | Upvalues: v1 (copy), GameUtils (copy), t6 (copy), v2 (copy) ]]
	v1[p1.Instance] = p1
	local v12 = p1
	repeat
		local v22 = GameUtils.GetParent(v12)
		if v22 and v22 ~= t6 then
			v2[v22][p1.Instance] = p1
		end
		v12 = v22
	until not v22 or v22 == t6
end
local function removeEntity(p1) --[[ removeEntity | Line: 204 | Upvalues: v1 (copy), GameUtils (copy), t6 (copy), v2 (copy) ]]
	v1[p1.Instance] = nil
	local v12 = p1
	repeat
		local v22 = GameUtils.GetParent(v12)
		if v22 and v22 ~= t6 then
			v2[v22][p1.Instance] = nil
		end
		v12 = v22
	until not v22 or v22 == t6
end
function t6.Create(p1, p2) --[[ Create | Line: 215 | Upvalues: t (copy) ]]
	local v1 = p1:new(p2)
	v1:OnCreated()
	t.Created:Fire(v1)
	return v1
end
function t6.new(p1, p2) --[[ new | Line: 224 | Upvalues: ConnectionHolder (copy), TableUtils (copy), CommonEntity (copy), addEntity (copy) ]]
	local v1 = setmetatable({
		Instance = p2,
		Connections = ConnectionHolder:new(),
		Flags = {},
		FlagsSourceTimeout = TableUtils.AutoTable(),
		TempShields = {},
		StateLastUpdated = {}
	}, p1)
	if p2:IsA("Player") then
		v1.Connections:AddConnection("destroy", p2.AncestryChanged:Connect(function() --[[ Line: 237 | Upvalues: p2 (copy), v1 (copy) ]]
			if not p2.Parent then
				v1:Destroy()
			end
		end))
	end
	v1.Connections:AddConnection("destroy", p2.Destroying:Connect(function() --[[ Line: 243 | Upvalues: v1 (copy) ]]
		v1:Destroy()
	end))
	for i = 1, CommonEntity.FlagBlockCount do
		v1.Connections:AddConnection("flags" .. i, p2:GetAttributeChangedSignal("Flags" .. i):Connect(function() --[[ Line: 248 | Upvalues: v1 (copy), i (copy) ]]
			v1:UpdateFlags(i)
		end))
		v1:UpdateFlags(i, true)
	end
	v1:OnCreate(v1)
	addEntity(v1)
	return v1
end
function t6.OnCreate(p1) --[[ OnCreate | Line: 259 | Upvalues: LocalPlayer (copy), CommonEntity (copy), t (copy), Constant (copy) ]]
	local v1 = p1.Instance
	if v1 == LocalPlayer then
		p1.WalkSpeed = math.max(v1:GetAttribute("WalkSpeed") or p1.WalkSpeed, 0)
		p1.CurrentWalkSpeed = p1.WalkSpeed
	end
	p1._State = v1:GetAttribute("State") or CommonEntity.State.Stand
	if v1 == LocalPlayer then
		p1.Connections:AddConnection("state", v1:GetAttributeChangedSignal("State"):Connect(function() --[[ Line: 276 | Upvalues: v1 (copy), CommonEntity (ref), p1 (copy) ]]
			local v12 = v1:GetAttribute("State")
			if v12 == CommonEntity.State.Dead or p1._State == CommonEntity.State.Dead and v12 == CommonEntity.State.Stand then
				p1:SetState(v12)
			end
		end))
	else
		p1.Connections:AddConnection("state", v1:GetAttributeChangedSignal("State"):Connect(function() --[[ Line: 291 | Upvalues: p1 (copy), v1 (copy) ]]
			p1:SetState(v1:GetAttribute("State"))
		end))
		p1.PitchTarget = {}
		p1.YawTarget = {}
		p1:UpdatePitchAndYaw()
		p1.Connections:AddConnection("pitch_yaw", v1:GetAttributeChangedSignal("PitchYaw"):Connect(function() --[[ Line: 297 | Upvalues: p1 (copy) ]]
			p1:UpdatePitchAndYaw()
		end))
		p1.Connections:AddConnection("scale", v1:GetAttributeChangedSignal("Scale"):Connect(function() --[[ Line: 300 | Upvalues: p1 (copy), v1 (copy), t (ref) ]]
			p1.Scale = v1:GetAttribute("Scale") or 1
			p1:UpdateScale()
			t.ScaleChanged:Fire(p1)
		end))
		p1.TempShield = math.max(v1:GetAttribute("TempShield") or 0, 0)
		p1.Connections:AddConnection("shieldTemp", v1:GetAttributeChangedSignal("TempShield"):Connect(function() --[[ Line: 320 | Upvalues: p1 (copy), v1 (copy), t (ref) ]]
			local TempShield = p1.TempShield
			p1.TempShield = math.max(v1:GetAttribute("TempShield") or 0, 0)
			t.ShieldChanged:Fire(p1)
		end))
	end
	p1.MaxHealth = math.max(v1:GetAttribute("MaxHealth") or 100, 1)
	p1.Health = math.max(v1:GetAttribute("Health") or p1.MaxHealth, 0)
	p1.Connections:AddConnection("health", v1:GetAttributeChangedSignal("Health"):Connect(function() --[[ Line: 331 | Upvalues: p1 (copy), v1 (copy), t (ref) ]]
		p1.Health = math.max(v1:GetAttribute("Health") or 0, 0)
		t.HealthChanged:Fire(p1, p1.Health, p1.Health)
	end))
	p1.Connections:AddConnection("maxHealth", v1:GetAttributeChangedSignal("MaxHealth"):Connect(function() --[[ Line: 336 | Upvalues: p1 (copy), v1 (copy), t (ref) ]]
		p1.MaxHealth = math.max(v1:GetAttribute("MaxHealth") or 100, 1)
		t.HealthChanged:Fire(p1, p1.Health, p1.Health)
	end))
	p1.Shield = math.max(v1:GetAttribute("Shield") or 0, 0)
	p1.Connections:AddConnection("shield", v1:GetAttributeChangedSignal("Shield"):Connect(function() --[[ Line: 342 | Upvalues: p1 (copy), v1 (copy), t (ref) ]]
		local Shield = p1.Shield
		p1.Shield = math.max(v1:GetAttribute("Shield") or 0, 0)
		t.ShieldChanged:Fire(p1)
	end))
	p1.Team = v1:GetAttribute("Team") or Constant.Team.Default
	p1.Connections:AddConnection("team", v1:GetAttributeChangedSignal("Team"):Connect(function() --[[ Line: 349 | Upvalues: p1 (copy), v1 (copy), Constant (ref), t (ref) ]]
		local Team = p1.Team
		local v12 = v1:GetAttribute("Team") or Constant.Team.Default
		if v12 ~= Team then
			p1.Team = v12
			t.TeamChanged:Fire(p1, v12, Team)
		end
	end))
	p1.CustomModelPath = v1:GetAttribute("_entityModel")
	p1.Connections:AddConnection("model", v1:GetAttributeChangedSignal("_entityModel"):Connect(function() --[[ Line: 368 | Upvalues: p1 (copy), v1 (copy), t (ref) ]]
		p1.CustomModelPath = v1:GetAttribute("_entityModel")
		t.CustomModelChanged:Fire(p1)
	end))
end
function t6.OnCreated(p1) --[[ OnCreated | Line: 374 ]] end
function t6.UpdateFlags(p1, p2, p3) --[[ UpdateFlags | Line: 378 | Upvalues: LocalPlayer (copy), CommonEntity (copy), t4 (copy), t (copy) ]]
	local v1 = if p3 then nil else {}
	local v2 = p1.Instance:GetAttribute("Flags" .. p2) or 0
	if p1.Instance == LocalPlayer then
		v2 = bit32.bor(v2, p1.LocalFlagValues[p2] or 0)
	end
	local v5 = (p2 - 1) * CommonEntity.FlagBlockSize
	for i = 1, CommonEntity.FlagBlockSize do
		local v6 = CommonEntity.Flag:ordered()[i + v5]
		if not v6 then
			break
		end
		if if bit32.band(v2, (bit32.lshift(1, i - 1))) == 0 then false else true then
			if v1 and not p1.Flags[v6] then
				v1[v6] = true
			end
			p1.Flags[v6] = true
		end
		if v1 and p1.Flags[v6] then
			v1[v6] = true
		end
		p1.Flags[v6] = nil
	end
	if v1 then
		for v9, v10 in v1 do
			local v11 = t4.FlagChanged[v9]
			if v11 then
				v11:Fire(p1, v9, v10, not v10)
			end
		end
		t.FlagsChanged:Fire(p1, v1)
	end
end
function t6.UpdatePitchAndYaw(p1) --[[ UpdatePitchAndYaw | Line: 422 | Upvalues: Utils (copy) ]]
	local v1 = Utils.IsNumber(p1.Instance:GetAttribute("PitchYaw")) or 0
	local sum = bit32.extract(v1, 0, 16) / 100
	if sum > 180 then
		sum = sum - 360
	end
	local v2 = math.rad(sum)
	if v2 ~= p1.Pitch then
		local PitchTarget = p1.PitchTarget
		PitchTarget.Start = CFrame.fromOrientation(p1.Pitch, 0, 0)
		PitchTarget.Target = CFrame.fromOrientation(v2, 0, 0)
		PitchTarget.Time = os.clock()
	end
	local sum_2 = bit32.rshift(v1, 16) / 100
	if sum_2 > 180 then
		sum_2 = sum_2 - 360
	end
	local v3 = math.rad(sum_2)
	if v3 ~= p1.Yaw then
		local YawTarget = p1.YawTarget
		YawTarget.Start = CFrame.fromOrientation(0, p1.Yaw, 0)
		YawTarget.Target = CFrame.fromOrientation(0, v3, 0)
		YawTarget.Time = os.clock()
	end
end
function t6.UpdateScale(p1) --[[ UpdateScale | Line: 451 ]] end
function t6.SetState(p1, p2) --[[ SetState | Line: 455 | Upvalues: CommonEntity (copy), LocalPlayer (copy), t (copy) ]]
	local v1 = p1._State or CommonEntity.State.Stand
	if not p1.State[p2] then
		p2 = CommonEntity.State.Stand
	end
	if p2 ~= v1 then
		p1.StateLastUpdated[v1] = workspace:GetServerTimeNow()
		p1._State = p2
		if p1.Instance == LocalPlayer then
			p1.Instance:SetAttribute("StateLocal", p2)
		end
		t.StateChanged:Fire(p1, p2, v1)
	end
end
function t6.GetState(p1) --[[ GetState | Line: 471 | Upvalues: CommonEntity (copy) ]]
	return p1._State or CommonEntity.State.Stand
end
function t6.InState(p1, ...) --[[ InState | Line: 475 ]]
	return table.find({ ... }, p1:GetState())
end
function t6.GetCurrentShield(p1) --[[ GetCurrentShield | Line: 479 ]]
	local v1 = false
	local sum = p1.Shield or 0
	if p1.TempShields then
		for v2, v3 in p1.TempShields do
			local v6 = v3.Value * math.clamp((v3.Timeout - workspace:GetServerTimeNow()) / v3.Duration, 0, 1) - v3.Consumed
			if v6 > 0 then
				sum = sum + v6
				v1 = true
			end
		end
	end
	if (p1.TempShield or 0) > 0 then
		sum = sum + p1.TempShield
		v1 = true
	end
	return sum, v1
end
function t6.IsActive(p1, p2) --[[ IsActive | Line: 500 ]]
	local v1 = p1:IsAlive() and not p1:IsStuned()
	if v1 and not p2 then
		return if v1 then not p1:IsFrozen() else v1
	else
		return v1
	end
end
function t6.CanAttack(p1) --[[ CanAttack | Line: 508 ]]
	return p1:IsActive()
end
function t6.CanMove(p1) --[[ CanMove | Line: 512 | Upvalues: CommonEntity (copy) ]]
	return p1:IsActive() and not p1.Flags[CommonEntity.Flag.Unmoveable]
end
function t6.IsStuned(p1) --[[ IsStuned | Line: 516 | Upvalues: CommonEntity (copy) ]]
	return p1.Flags[CommonEntity.Flag.Stuned]
end
function t6.IsFrozen(p1) --[[ IsFrozen | Line: 520 | Upvalues: CommonEntity (copy) ]]
	return p1.Flags[CommonEntity.Flag.Frozen]
end
function t6.HasFlag(p1, ...) --[[ HasFlag | Line: 524 ]]
	for v1, v2 in { ... } do
		if p1.Flags[v2] then
			return true
		end
	end
end
function t6.GetCollision(p1, p2) --[[ GetCollision | Line: 532 | Upvalues: Config (copy) ]]
	local v1 = Config.TeamCollision[p1.Team]
	return if v1 then v1[p2] else v1
end
function t6.GetCurrentCollision(p1) --[[ GetCurrentCollision | Line: 537 | Upvalues: Constant (copy) ]]
	local v1 = p1:GetRootPart()
	if v1 then
		return v1.CollisionGroup
	else
		return p1:GetCollision(p1:IsAlive() and Constant.Collision.Alive or Constant.Collision.Dead)
	end
end
function t6.IsFriendlyTeam(p1, p2) --[[ IsFriendlyTeam | Line: 545 ]]
	if p1.World then
		return p1.World:IsFriendlyTeam(p1.Team, p2)
	else
		return true
	end
end
function t6.IsFriendly(p1, p2) --[[ IsFriendly | Line: 552 ]]
	if p2 then
		if p1 == p2 then
			return true
		elseif p1.World == p2.World then
			if p1.World then
				return p1.World:IsFriendly(p1, p2)
			else
				return true
			end
		else
			return false
		end
	end
end
function t6.IsAlive(p1) --[[ IsAlive | Line: 568 | Upvalues: CommonEntity (copy) ]]
	return if p1.Health > 0 then not p1:InState(CommonEntity.State.Dead) else false
end
function t6.GetDisplayName(p1) --[[ GetDisplayName | Line: 572 ]]
	return p1.Instance.Name
end
function t6.AddToCastParamsFilter(p1, p2) --[[ AddToCastParamsFilter | Line: 576 ]]
	local v1 = p1:GetWorkspaceRoot()
	if v1 then
		p2:AddToFilter(v1)
	end
end
function t6.GetVelocity(p1) --[[ GetVelocity | Line: 583 ]]
	local v1 = p1:GetRootPart()
	return if v1 then v1.AssemblyLinearVelocity or Vector3.new(0, 0, 0) else Vector3.new(0, 0, 0)
end
function t6.GetRootPart(p1) --[[ GetRootPart | Line: 589 ]]
	error("not implement yet")
end
function t6.GetWorkspaceRoot(p1) --[[ GetWorkspaceRoot | Line: 593 ]]
	error("not implement yet")
end
function t6.GetPivot(p1, p2) --[[ GetPivot | Line: 597 ]]
	local v1 = p1:GetRootPart()
	if v1 then
		if p2 then
			return v1.CFrame
		else
			return v1:GetPivot()
		end
	end
end
function t6.GetPivotOffset(p1) --[[ GetPivotOffset | Line: 609 ]]
	return CFrame.identity
end
function t6.GetHeadAt(p1) --[[ GetHeadAt | Line: 613 ]]
	return p1:GetPivot(true) * CFrame.new(0, 1.5, 0)
end
function t6.GetHeadPart(p1) --[[ GetHeadPart | Line: 617 ]] end
function t6.GetOriginWithPitch(p1) --[[ GetOriginWithPitch | Line: 621 ]]
	local v1 = p1:GetPivot(true)
	if v1 then
		return v1 * CFrame.fromOrientation(p1.Pitch, 0, 0)
	end
end
function t6.GetClosestPointTo(p1, p2) --[[ GetClosestPointTo | Line: 630 ]]
	if p2 then
		local v1 = p1:GetPivot(true)
		if v1 then
			return v1.Position
		end
	end
end
function t6.ClosestDistanceTo(p1, p2) --[[ ClosestDistanceTo | Line: 641 ]]
	local v1 = p1:GetClosestPointTo(p2)
	if v1 then
		return (v1 - p2).Magnitude, v1
	end
end
function t6.ClosestDistanceBetween(p1, p2) --[[ ClosestDistanceBetween | Line: 649 ]]
	local v1 = p1:GetClosestPointTo(p2:GetPivot(true))
	if v1 then
		local v2 = p2:GetClosestPointTo(p1:GetPivot(true))
		if v2 then
			return (v1 - v2).Magnitude, v1, v2
		end
	end
end
function t6.IsReady(p1) --[[ IsReady | Line: 661 ]]
	return true
end
function t6.IsMoving(p1) --[[ IsMoving | Line: 665 ]]
	local v1 = p1:GetRootPart()
	return if v1 then (v1.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude > 3 else v1
end
function t6.InAir(p1) --[[ InAir | Line: 670 ]] end
function t6.AddRef(p1, p2) --[[ AddRef | Line: 674 ]] end
function t6.RemoveRef(p1, p2) --[[ RemoveRef | Line: 678 ]] end
function t6.Destroy(p1) --[[ Destroy | Line: 682 | Upvalues: t (copy), removeEntity (copy) ]]
	if not p1.Destroying then
		p1.Destroying = true
		p1.Connections:Destroy()
		t.Destroying:Fire(p1)
		removeEntity(p1)
		p1.Destroyed = true
		t.Destroyed:Fire(p1)
	end
end
function t6.wrapFn(p1, p2) --[[ wrapFn | Line: 694 | Upvalues: t6 (copy) ]]
	return function(p1, ...) --[[ Line: 695 | Upvalues: t6 (ref), p2 (copy) ]]
		local v1 = t6.Get(p1)
		if v1 then
			p2(v1, ...)
		end
	end
end
function t6.onStart() --[[ onStart | Line: 703 | Upvalues: t6 (copy), t (copy), EntityService (copy), NetworkHelper (copy), t4 (copy), RunService (copy), v1 (copy), TweenService (copy) ]]
	local v12 = t6:wrapFn(function(p1, p2, p3, p4) --[[ Line: 704 | Upvalues: t (ref) ]]
		t.Spawned:Fire(p1, p2, p3, p4)
	end)
	local function convertDamager(p1) --[[ convertDamager | Line: 708 | Upvalues: t6 (ref) ]]
		local v1 = if p1 then p1.Damager else p1
		if typeof(v1) == "Instance" then
			local v2 = t6.Get(v1)
			p1.Damager = v2
			v1 = v2
		end
		local v3 = if p1 then p1.AssistDamager else p1
		if typeof(v3) == "Instance" then
			p1.AssistDamager = t6.Get(v3)
		end
		return v1
	end
	local v2 = t6:wrapFn(function(p1, p2, p3) --[[ Line: 724 | Upvalues: t6 (ref), t (ref) ]]
		if not p3 and p1._LastBeDamaged then
			p3 = p1._LastBeDamaged.Args
		end
		local v1, v2
		if p3 then
			v1 = p3.Damager
			v2 = p3
		else
			v1 = p3
			v2 = p3
		end
		if typeof(v1) == "Instance" then
			local v3 = t6.Get(v1)
			v2.Damager = v3
			v1 = v3
		end
		local v4 = if v2 then v2.AssistDamager else v2
		if typeof(v4) == "Instance" then
			v2.AssistDamager = t6.Get(v4)
		end
		p3.Damager = v1
		t.Died:Fire(p1, p2, p3)
		if v1 then
			t.Killed:Fire(v1, p1, p2, p3)
			local v5 = if p3 then p3.AssistDamager else p3
			if not v5 then
				return
			end
			t.Assist:Fire(v5, v1, p1, p2, p3)
		end
	end)
	local v3 = t6:wrapFn(function(p1, p2, p3, p4) --[[ Line: 744 | Upvalues: t6 (ref), t (ref) ]]
		p1._LastBeDamaged = {
			TookDamage = p3,
			Args = p4
		}
		local v1 = if p4 then p4.Damager else p4
		if typeof(v1) == "Instance" then
			local v2 = t6.Get(v1)
			p4.Damager = v2
			v1 = v2
		end
		local v3 = if p4 then p4.AssistDamager else p4
		if typeof(v3) == "Instance" then
			p4.AssistDamager = t6.Get(v3)
		end
		t.BeDamaged:Fire(p1, p2, p3, p4)
		if v1 then
			t.Damaged:Fire(v1, p1, p2, p3, p4)
		end
		if p4 then
			local Died = p4.Died
		end
	end)
	EntityService.Spawned.OnClientEvent:Connect(v12)
	EntityService.Died.OnClientEvent:Connect(v2)
	EntityService.BeDamaged.OnClientEvent:Connect(v3)
	NetworkHelper.Packets.EntityService.Packets.packets.Spawned.listen(function(p1) --[[ Line: 764 | Upvalues: v12 (copy) ]]
		v12(p1.Instance, p1.AtTime, p1.At, p1.Args)
	end)
	NetworkHelper.Packets.EntityService.Packets.packets.Died.listen(function(p1) --[[ Line: 767 | Upvalues: v2 (copy) ]]
		v2(p1.Instance, p1.AtTime, p1.Args)
	end)
	NetworkHelper.Packets.EntityService.Packets.packets.BeDamaged.listen(function(p1) --[[ Line: 770 | Upvalues: v3 (copy) ]]
		v3(p1.Instance, p1.AtTime, p1.TookDamage, p1.Args)
	end)
	EntityService.Heal.OnClientEvent:Connect(t6:wrapFn(function(p1, p2, p3, p4) --[[ Line: 780 | Upvalues: t (ref) ]]
		t.HealthRegen:Fire(p1, p2, p3, p4)
	end))
	EntityService.Teleported.OnClientEvent:Connect(t6:wrapFn(function(p1, p2, p3, p4) --[[ Line: 788 | Upvalues: t (ref) ]]
		t.Teleported:Fire(p1, p2, p3, p4)
	end))
	local function updateFlagsTime(p1) --[[ updateFlagsTime | Line: 799 | Upvalues: t6 (ref), t4 (ref), t (ref) ]]
		debug.profilebegin("updateFlagsTime")
		local v1 = workspace:GetServerTimeNow()
		for v2, v3 in p1 do
			local v4 = t6.Get(v3.Instance)
			if v4 then
				local t2 = {}
				for v5, v6 in v3.Data do
					if v4:HasFlag(v5) then
						local t3 = {}
						for v7, v8 in v6 do
							if not (v8.Timeout < v1) then
								v4.FlagsSourceTimeout[v5][v7] = v8
								t3[v7] = true
							end
						end
						if next(t3) then
							t2[v5] = t3
						end
					end
				end
				if next(t2) then
					for v9, v10 in t2 do
						local v11 = t4.FlagTimeChanged[v9]
						if v11 then
							v11:Fire(v4, v9, v10)
						end
					end
					t.FlagsTimeChanged:Fire(v4, t2)
				end
			end
		end
		debug.profileend()
	end
	EntityService.FlagsTime.OnClientEvent:Connect(updateFlagsTime)
	EntityService.FlagsTimeUnreliable.OnClientEvent:Connect(updateFlagsTime)
	NetworkHelper.Packets.EntityService.Packets.packets.FlagsTime.listen(function(p1) --[[ Line: 841 | Upvalues: updateFlagsTime (copy) ]]
		updateFlagsTime(p1)
	end)
	NetworkHelper.Packets.EntityService.Packets.packets.TempShield.listen(function(p1) --[[ Line: 846 | Upvalues: t6 (ref), t (ref) ]]
		for v1, v2 in p1 do
			local v3 = t6.Get(v2.Instance)
			if v3 then
				for v4, v5 in v2.Data do
					if v5 and not (workspace:GetServerTimeNow() > v5.Timeout) then
						v3.TempShields[v4] = v5
					end
					v3.TempShields[v4] = nil
				end
				t.ShieldChanged:Fire(v3)
			end
		end
	end)
	NetworkHelper.Packets.EntityService.Packets.packets.TempShieldConsumed.listen(function(p1) --[[ Line: 863 | Upvalues: t6 (ref), t (ref) ]]
		for v1, v2 in p1 do
			local v3 = t6.Get(v2.Instance)
			if v3 then
				for v4, v5 in v2.Data do
					local v6 = v3.TempShields[v4]
					if v6 and v6.Value * math.clamp((v6.Timeout - workspace:GetServerTimeNow()) / v6.Duration, 0, 1) - v5 <= 0 then
						v3.TempShields[v4] = nil
					end
				end
				t.ShieldChanged:Fire(v3)
			end
		end
	end)
	RunService.PreSimulation:Connect(function(p1) --[[ Line: 886 | Upvalues: v1 (ref), TweenService (ref) ]]
		debug.profilebegin("lerpPitchAndYaw")
		for v12, v2 in v1 do
			if v2.PitchTarget then
				local PitchTarget = v2.PitchTarget
				if PitchTarget.Start and (PitchTarget.Target and PitchTarget.Target ~= v2.Pitch) then
					v2.Pitch = PitchTarget.Start:Lerp(PitchTarget.Target, TweenService:GetValue(math.clamp((os.clock() - (PitchTarget.Time or 0)) / 0.022222222222222223, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)):ToOrientation()
				end
			end
			if v2.YawTarget then
				local YawTarget = v2.YawTarget
				if YawTarget.Start and (YawTarget.Target and YawTarget.Target ~= v2.Yaw) then
					local _, v7 = YawTarget.Start:Lerp(YawTarget.Target, TweenService:GetValue(math.clamp((os.clock() - (YawTarget.Time or 0)) / 0.022222222222222223, 0, 1), Enum.EasingStyle.Quad, Enum.EasingDirection.Out)):ToOrientation()
					v2.Yaw = v7
				end
			end
		end
		debug.profileend()
	end)
end
function t6.is(p1, p2) --[[ is | Line: 908 | Upvalues: GameUtils (copy) ]]
	return GameUtils.HasSymbol(p1, p2)
end
return t6