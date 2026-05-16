-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.EntityService.Entity.HumanoidEntity.PlayerEntity.LocalEntity

-- https://lua.expert/
game:GetService("CollectionService")
game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterPlayer = game:GetService("StarterPlayer")
local LocalPlayer = Players.LocalPlayer
local Constant = require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local Utils = require(ReplicatedStorage.Util.Utils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
require(ReplicatedStorage.Util.TaskUtils)
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
require(ReplicatedStorage.Common.AsyncService.AsyncRaycast)
require(ReplicatedStorage.Util.DebugUtils)
local CurrentCamera = workspace.CurrentCamera
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
require(ReplicatedStorage.Shared.Squash)
require(ReplicatedStorage.Common.NetworkHelper)
local LocalAttrDataContainer = require(ReplicatedStorage.Remote.AttrService).LocalAttrDataContainer
local EntityService = ReplicatedStorage.Common.EntityService
local v1 = require(EntityService)
local CommonEntity = require(EntityService.CommonEntity)
local v2 = require(script.Parent)
local State = v2.State
local EntityService_2 = ReplicatedStorage.Remote.EntityService
local v3 = setmetatable({
	Teleporting = SimpleSignal.new()
}, v2.LocalEvent)
local v4 = setmetatable({
	LocalFlagValue = 0,
	LocalEvent = v3,
	LocalFlagValues = {}
}, v2)
v4.__index = v4
function v4.__tostring(p1) --[[ Line: 53 ]]
	return "LocalEntity"
end
function v4.new(p1, p2, ...) --[[ new | Line: 59 | Upvalues: LocalPlayer (copy), v2 (copy), StarterPlayer (copy), TableUtils (copy) ]]
	assert(if p2 == LocalPlayer then true else false, "LocalEntity only available for LocalPlayer")
	local v22 = v2.new(p1, p2, ...)
	v22._StateRequesting = {}
	v22.Uncollideable = {}
	local v3 = p2:GetAttribute("JumpHeight") or StarterPlayer.CharacterJumpHeight
	v22.JumpHeight = math.max(v3, 0)
	v22.Connections:AddConnection("jumpHeight", p2:GetAttributeChangedSignal("JumpHeight"):Connect(function() --[[ Line: 66 | Upvalues: v22 (copy), p2 (copy), StarterPlayer (ref) ]]
		v22.JumpHeight = math.max(p2:GetAttribute("JumpHeight") or StarterPlayer.CharacterJumpHeight, 0)
		v22:UpdateJumpHeight()
	end))
	v22.Connections:AddConnection("scale", p2:GetAttributeChangedSignal("Scale"):Connect(function() --[[ Line: 71 | Upvalues: v22 (copy) ]]
		v22:UpdateScale()
	end))
	v22.CurrentJumpHeight = v22.JumpHeight
	v22.LocalFlagValues = TableUtils.ZeroDefault()
	v22.LocalFlagsSource = TableUtils.AutoTable()
	v22.LocalFlags = {}
	return v22
end
function v4.UpdateJumpHeight(p1) --[[ UpdateJumpHeight | Line: 83 | Upvalues: LocalAttrDataContainer (copy), Constant (copy), CommonEntity (copy) ]]
	local v1 = p1.JumpHeight * p1.Scale * (1 + LocalAttrDataContainer:GetAttr(Constant.Attribute.JumpHeight))
	if not p1:CanMove() or p1:HasFlag(CommonEntity.Flag.Unjumpable) then
		v1 = 0
	end
	local v2 = math.max(v1, 0) * p1.Scale
	p1.CurrentJumpHeight = v2
	local v3 = p1:GetHumanoid()
	if v3 then
		v3.JumpHeight = v2
		v3.Jump = false
		if v2 == 0 then
			v3:SetStateEnabled(Enum.HumanoidStateType.Jumping, false)
			return
		end
		v3:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
	end
end
function v4.UpdateHipHeight(p1) --[[ UpdateHipHeight | Line: 108 | Upvalues: v2 (copy), Config (copy) ]]
	local HipHeight = p1.HipHeight
	if p1:InState(v2.State.Crouch) then
		HipHeight = HipHeight * Config.Movement.CrouchHeight
	elseif p1:InState(v2.State.Slide) then
		HipHeight = HipHeight * Config.Movement.SlideHeight
	end
	local v22 = math.max(HipHeight * (p1.Scale or 1), 0)
	p1.CurrentHipHeight = v22
	local v3 = p1:GetHumanoid()
	if v3 then
		v3.HipHeight = v22
	end
end
function v4.UpdateWalkSpeed(p1) --[[ UpdateWalkSpeed | Line: 142 | Upvalues: LocalAttrDataContainer (copy), Constant (copy), v2 (copy), Config (copy) ]]
	local sum = p1.WalkSpeed * (1 + LocalAttrDataContainer:GetAttr(Constant.Attribute.WalkSpeed))
	if p1:InState(v2.State.Sprint) then
		sum = sum * (Config.Movement.SprintSpeed or 1.2)
	elseif p1:InState(v2.State.Crouch) then
		sum = sum * (Config.Movement.CrouchSpeed or 0.5)
	elseif p1:InState(v2.State.Sneak) then
		sum = sum * (Config.Movement.SneakSpeed or 0.75)
	elseif p1:InState(v2.State.Slide) then
		sum = 0
	end
	if not p1:CanMove() then
		sum = 0
	end
	if sum > 0 then
		sum = sum + LocalAttrDataContainer:GetAttr(Constant.Attribute.WalkSpeedValue)
	end
	local v1 = math.max(sum, 0)
	p1.CurrentWalkSpeed = v1
	p1._updateWalkSpeed = true
	local v22 = p1:GetHumanoid()
	local v3
	if v22 then
		v3 = if v22:GetState() == Enum.HumanoidStateType.Climbing then v1 * 1.5 else v1
		v22.WalkSpeed = v3
	else
		v3 = v1
	end
	p1._HumanoidWalkSpeed = v3
	p1._updateWalkSpeed = nil
end
function v4.RefreshStatus(p1) --[[ RefreshStatus | Line: 181 ]]
	p1:UpdateWalkSpeed()
	p1:UpdateJumpHeight()
	p1:UpdateHipHeight()
end
local t2 = {
	State.Dash,
	State.Slide,
	State.Crouch,
	State.Sneak,
	State.Sprint
}
function v4.UpdateState(p1) --[[ UpdateState | Line: 195 | Upvalues: State (copy), t2 (copy) ]]
	local Stand = State.Stand
	if p1._State == State.Dead then
		Stand = State.Dead
	end
	if p1:IsActive() then
		Stand = State.Stand
		for v1, v2 in t2 do
			if p1._StateRequesting[v2] then
				Stand = v2
				break
			end
		end
	end
	p1:SetState(Stand)
	return p1:GetState()
end
function v4.RequestState(p1, p2, p3) --[[ RequestState | Line: 214 | Upvalues: Config (copy), State (copy) ]]
	if Config.Entity.StateEnabled[p2] == false then
	elseif p1:IsActive() then
		if p2 == State.Stand or p2 == State.Dead then
		else
			p1._StateRequesting[p2] = true
			local v1 = if p1:UpdateState() == p2 then true else false
			if not v1 and p3 then
				p1._StateRequesting[p2] = nil
			end
			return v1
		end
	end
end
function v4.ReleaseState(p1, p2) --[[ ReleaseState | Line: 232 ]]
	p1._StateRequesting[p2] = nil
	p1:UpdateState()
end
function v4.HasStateRequesting(p1, p2) --[[ HasStateRequesting | Line: 237 ]]
	return p1._StateRequesting[p2]
end
local t3 = {
	Vector3.new(1, 0, 0),
	Vector3.new(-1, -0, -0),
	Vector3.new(0, 0, 1),
	Vector3.new(-0, -0, -1)
}
local function safePosition(p1, p2) --[[ safePosition | Line: 248 | Upvalues: t3 (copy) ]]
	local v1 = RaycastParams.new()
	v1.CollisionGroup = "CanCollide"
	v1.RespectCanCollide = true
	local _, v2, _2 = p2:ToOrientation()
	local sum = CFrame.new(p2.Position) * CFrame.fromOrientation(0, v2, 0)
	local v3 = workspace:Raycast(sum.Position, Vector3.new(-0, -2, -0), v1)
	if v3 then
		sum = sum - Vector3.new(0, 1, 0) * v3.Distance
	end
	local v4 = not v3 and workspace:Blockcast(sum - Vector3.new(0, 0.5, 0), Vector3.new(2, 0.1, 0.8), Vector3.new(0, 3, 0), v1)
	if v4 then
		sum = sum - Vector3.new(0, 1, 0) * (5 - v4.Distance)
	end
	for v5, v6 in t3 do
		if workspace:Raycast(sum.Position - v6 * 0.1, v6 * 2, v1) and not workspace:Raycast(sum.Position + v6 * 0.1, -v6 * 2, v1) then
			sum = sum - v6
		end
	end
	return sum.Position
end
function v4.GetSafePosition(p1, p2) --[[ GetSafePosition | Line: 285 | Upvalues: safePosition (copy) ]]
	local v1 = if typeof(p2) == "Vector3" then CFrame.new(p2) else p2
	local v5 = CFrame.new(safePosition(p1, v1) or v1.Position)
	if v5 == v5 then
		if typeof(p2) == "Vector3" then
			return v5.Position
		else
			return v5
		end
	else
		return p2
	end
end
function v4.Teleport(p1, p2, p3) --[[ Teleport | Line: 300 | Upvalues: LocalPlayer (copy), CurrentCamera (copy), safePosition (copy), v3 (copy), v2 (copy) ]]
	local Character = LocalPlayer.Character
	if Character and p1:GetRootPart() then
		if typeof(p2) == "Vector3" then
			p2 = CFrame.new(p2) * CurrentCamera.CFrame.Rotation
		end
		local v1 = p1:GetPivotOffset()
		if p3 and p3.Safe then
			local v22 = CFrame.new
			p2 = v22(safePosition(p1, p2) or p2.Position) * p2.Rotation
			if p2 ~= p2 then
				return
			end
		end
		local _, v4, _2 = p2:ToOrientation()
		local v5 = CFrame.new(p2.Position) * CFrame.fromOrientation(0, v4, 0)
		if v5 == v5 then
			v3.Teleporting:Fire()
			Character:PivotTo(v5 * v1:Inverse())
			if not (p3 and p3.KeepVel) then
				p1:ClearVelocity()
			end
			v2.Event.Teleported:Fire(p1)
		end
	end
end
function v4.ClearVelocity(p1) --[[ ClearVelocity | Line: 334 | Upvalues: LocalPlayer (copy) ]]
	local Character = LocalPlayer.Character
	if Character and Character.PrimaryPart then
		for v1, v2 in Character.PrimaryPart:GetConnectedParts(true) do
			if v2:IsA("BasePart") then
				v2.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
				v2.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
			end
		end
		Character.PrimaryPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		Character.PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end
end
function v4.ApplyImpulse(p1, p2, p3, p4, p5) --[[ ApplyImpulse | Line: 348 ]]
	local v1 = p1:GetRootPart()
	if v1 then
		if p5 and (p5.Force and v1.AssemblyLinearVelocity:Dot(p3) < 0) then
			p1:ClearVelocity()
		end
		v1:ApplyImpulse(p3 * p4 * v1.AssemblyMass)
	end
end
function v4.SetAttr(p1, p2, p3, p4) --[[ SetAttr | Line: 361 ]] end
function v4.SetUncollideable(p1, p2, p3) --[[ SetUncollideable | Line: 365 ]]
	if p1.Team then
		local v1 = if next(p1.Uncollideable) then true else false
		p1.Uncollideable[p2] = p3 or nil
		if if next(p1.Uncollideable) then true else false ~= v1 then
			p1:UpdateCollision()
		end
	end
end
function v4.GetCurrentCollision(p1) --[[ GetCurrentCollision | Line: 382 | Upvalues: Constant (copy) ]]
	if p1:IsAlive() then
		local v1 = if next(p1.Uncollideable) then p1:GetCollision(Constant.Collision.AliveWithoutCollide) else nil
		return if v1 then v1 else p1:GetCollision(Constant.Collision.Alive)
	else
		return p1:GetCollision(Constant.Collision.Dead)
	end
end
local function filterIsBasePart(p1) --[[ filterIsBasePart | Line: 394 ]]
	return p1:IsA("BasePart")
end
function v4.UpdateCollision(p1) --[[ UpdateCollision | Line: 396 | Upvalues: InstanceUtils (copy), filterIsBasePart (copy) ]]
	local v1 = p1:GetCurrentCollision()
	if v1 then
		InstanceUtils.ForeachDescendants(p1:GetWorkspaceRoot(), function(p1) --[[ Line: 401 | Upvalues: v1 (copy) ]]
			p1.CollisionGroup = v1
		end, filterIsBasePart)
	end
end
function v4.SetFlag(p1, p2, p3, p4, p5) --[[ SetFlag | Line: 513 | Upvalues: CommonEntity (copy) ]]
	if CommonEntity.Flag[p2] then
		local v1 = if p4 then p1.LocalFlagsSource[p2] else rawget(p1.LocalFlagsSource, p2)
		if v1 then
			local v2 = nil
			local v3
			if p4 then
				if p5 and p5.Duration then
					v2 = p5.Duration
				end
				v3 = v2 and {
					Duration = v2
				} or true
			else
				v3 = nil
			end
			v1[p3] = v3
			p1:UpdateLocalFlag(p2)
			if v2 then
				p1.FlagsSourceTimeout[p2][p3] = {
					Timeout = workspace:GetServerTimeNow() + v2,
					Duration = v2
				}
			end
		end
	else
		warn("inavailable flag", p2)
	end
end
function v4.UpdateLocalFlag(p1, p2) --[[ UpdateLocalFlag | Line: 544 | Upvalues: CommonEntity (copy) ]]
	if CommonEntity.Flag[p2] then
		local v1 = rawget(p1.LocalFlagsSource, p2)
		local v2 = if v1 then next(v1) and true else v1
		local v3 = p1.LocalFlags[p2]
		if (v2 or v3) and not (v2 and v3) then
			p1.LocalFlags[p2] = v2 or nil
			local v4, v5 = CommonEntity.GetFlagGroupIdx(p2)
			local v7 = p1.LocalFlagValues[v4]
			local v8 = bit32.lshift(1, v5 - (v4 - 1) * CommonEntity.FlagBlockSize - 1)
			p1.LocalFlagValues[v4] = if v2 then bit32.bor(v7, v8) else bit32.bxor(v7, v8)
			p1:UpdateFlags(v4)
		end
	else
		warn("inavailable flag", p2)
	end
end
function v4.HasFlag(p1, ...) --[[ HasFlag | Line: 579 ]]
	for v1, v2 in { ... } do
		if p1.Flags[v2] or p1.LocalFlags[v2] then
			return true
		end
	end
end
function v4.SetScale(p1, p2) --[[ SetScale | Line: 587 | Upvalues: v2 (copy) ]]
	p1.Scale = p2
	p1:UpdateScale()
	v2.Event.ScaleChanged:Fire(p1)
end
function v4.UpdateScale(p1) --[[ UpdateScale | Line: 593 | Upvalues: LocalPlayer (copy) ]]
	if LocalPlayer.Character then
		p1:ClearVelocity()
		LocalPlayer.Character:ScaleTo(p1.Scale)
		p1:RefreshStatus()
	end
end
function v4.UpdateInAir(p1) --[[ UpdateInAir | Line: 601 | Upvalues: Utils (copy), EntityService_2 (copy), v2 (copy) ]]
	local Humanoid = p1.Humanoid
	if Humanoid then
		local v1 = if Humanoid:GetState() == Enum.HumanoidStateType.Freefall or Humanoid:GetState() == Enum.HumanoidStateType.Jumping then true else Humanoid.FloorMaterial == Enum.Material.Air
		if Utils.ToBool(v1) ~= Utils.ToBool(p1._InAir) then
			p1._InAir = v1
			EntityService_2.SetInAir:FireServer(v1)
			v2.Event.InAirChanged:Fire(p1)
		end
	end
end
function v4.SetupHumanoid(p1) --[[ SetupHumanoid | Line: 615 | Upvalues: v2 (copy), EntityService_2 (copy), RunService (copy), LocalPlayer (copy) ]]
	v2.SetupHumanoid(p1)
	local Humanoid = p1.Humanoid
	if Humanoid then
		p1.Connections:AddConnection("refreshStatus", Humanoid.StateChanged:Connect(function(p12, p2) --[[ Line: 621 | Upvalues: p1 (copy), EntityService_2 (ref) ]]
			task.defer(p1.RefreshStatus, p1)
			if p2 == Enum.HumanoidStateType.Jumping then
				EntityService_2.Jump:FireServer()
			end
		end))
		if not RunService:IsStudio() then
			local v1 = 0
			p1.Connections:AddConnection("refreshWalkSpeed", Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function() --[[ Line: 629 | Upvalues: p1 (copy), Humanoid (copy), v1 (ref), RunService (ref), LocalPlayer (ref) ]]
				if p1._updateWalkSpeed or not (Humanoid.WalkSpeed > p1._HumanoidWalkSpeed) then
					v1 = 0
				else
					if v1 % 10 == 0 and RunService:IsStudio() then
						warn("Humanoid.WalkSpeed \229\188\130\229\184\184\228\191\174\230\148\185")
					elseif v1 % 10 == 0 then
						warn("humanoid.WalkSpeed Illegal")
					end
					p1:UpdateWalkSpeed()
					v1 = v1 + 1
					if v1 >= 15 then
						LocalPlayer:Kick("Illegal Local Walk Speed")
					end
				end
			end))
		end
		p1:RefreshStatus()
	end
end
local v5 = v4:Create(LocalPlayer)
function v4.onStart() --[[ onStart | Line: 654 | Upvalues: EntityService_2 (copy), v5 (copy), StarterPlayer (copy), v2 (copy), State (copy), v1 (copy), LocalAttrDataContainer (copy), Constant (copy) ]]
	EntityService_2.ApplyImpulse.OnClientEvent:Connect(function(p1, p2, p3, p4) --[[ Line: 655 | Upvalues: v5 (ref) ]]
		v5:ApplyImpulse(p1, p2, p3, p4)
	end)
	EntityService_2.WalkSpeed.OnClientEvent:Connect(function(p1) --[[ Line: 659 | Upvalues: v5 (ref), StarterPlayer (ref), v2 (ref) ]]
		v5.WalkSpeed = math.max(if p1 then p1 else v5.WalkSpeed or StarterPlayer.CharacterWalkSpeed, 0)
		v2.Event.WalkSpeedChanged:Fire(v5)
	end)
	v2.LocalEvent.CharacterAdded:Connect(function() --[[ Line: 664 | Upvalues: v5 (ref) ]]
		v5.GravityVector = nil
		v5.GravityResistance = nil
	end)
	v2.LocalEvent.Died:ConnectEarly(function() --[[ Line: 669 | Upvalues: v5 (ref), State (ref) ]]
		table.clear(v5._StateRequesting)
		v5:SetState(State.Dead)
	end)
	v2.LocalEvent.Spawned:ConnectEarly(function() --[[ Line: 673 | Upvalues: v5 (ref) ]]
		table.clear(v5._StateRequesting)
		v5:RefreshStatus()
	end)
	v2.LocalEvent.StateChanged:Connect(function(p1) --[[ Line: 678 | Upvalues: v5 (ref), v2 (ref), v1 (ref) ]]
		if v5:IsAlive() and v2.ActiveState[p1] then
			v1.Network.Packets.packets.SetState.send(p1)
		end
		v5:RefreshStatus()
	end)
	v2.LocalEvent.FlagsChanged:Connect(function() --[[ Line: 688 | Upvalues: v5 (ref) ]]
		v5:RefreshStatus()
	end)
	v2.LocalEvent.HipHeightChanged:ConnectEarly(function() --[[ Line: 692 | Upvalues: v5 (ref) ]]
		v5:UpdateHipHeight()
	end)
	v2.LocalEvent.WalkSpeedChanged:ConnectEarly(function() --[[ Line: 696 | Upvalues: v5 (ref) ]]
		v5:UpdateWalkSpeed()
	end)
	LocalAttrDataContainer:GetAttrUpdatedSignal(Constant.Attribute.WalkSpeed):Connect(function(p1, p2, p3, p4) --[[ Line: 700 | Upvalues: v5 (ref) ]]
		v5:UpdateWalkSpeed()
	end)
	LocalAttrDataContainer:GetAttrUpdatedSignal(Constant.Attribute.WalkSpeedValue):Connect(function(p1, p2, p3, p4) --[[ Line: 703 | Upvalues: v5 (ref) ]]
		v5:UpdateWalkSpeed()
	end)
	LocalAttrDataContainer:GetAttrUpdatedSignal(Constant.Attribute.JumpHeight):Connect(function(p1, p2, p3, p4) --[[ Line: 706 | Upvalues: v5 (ref) ]]
		v5:UpdateJumpHeight()
	end)
end
return v5