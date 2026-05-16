-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.EntityService.Entity.HumanoidEntity

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
game:GetService("StarterPlayer")
local LocalPlayer = Players.LocalPlayer
local Utils = require(ReplicatedStorage.Util.Utils)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local CommonHumanoidEntity = require(ReplicatedStorage.Common.EntityService.CommonEntity.CommonHumanoidEntity)
local v1 = require(script.Parent)
local v2 = TableUtils.Bid({
	Front = 1,
	Left = 2,
	Back = 3,
	Right = 4
})
local v4 = setmetatable({
	MoveDirectionChanged = SimpleSignal.new(),
	HipHeightChanged = SimpleSignal.new(),
	Jumping = SimpleSignal.new(),
	InAirChanged = SimpleSignal.new()
}, v1.Event)
v4.__index = v4
local v5 = setmetatable({
	MoveDirectionChanged = SimpleSignal.new(),
	HipHeightChanged = SimpleSignal.new(),
	Jumping = SimpleSignal.new(),
	InAirChanged = SimpleSignal.new()
}, v1.FocusedEvent)
v5.__index = v5
local v6 = setmetatable({
	MoveDirectionChanged = SimpleSignal.new(),
	HipHeightChanged = SimpleSignal.new(),
	Jumping = SimpleSignal.new(),
	InAirChanged = SimpleSignal.new()
}, v1.LocalEvent)
v6.__index = v6
local v7 = setmetatable({
	HipHeight = 2,
	Humanoid = nil,
	Event = v4,
	FocusedEvent = v5,
	LocalEvent = v6,
	MoveDirection = v2,
	State = CommonHumanoidEntity.State
}, v1)
v7.__index = v7
function v7.__tostring(p1) --[[ Line: 69 ]]
	return ("HumanoidEntity[%s]"):format(p1.Instance.Name)
end
function v7.new(p1, p2) --[[ new | Line: 75 | Upvalues: RunService (copy), InstanceUtils (copy), v1 (copy) ]]
	if p2:IsA("Model") then
		if not p2.Parent then
			RunService.Heartbeat:Wait()
		end
		if not (InstanceUtils.WaitFor(p2, "Humanoid") and p2.Parent) then
			return
		end
	end
	return v1.new(p1, p2)
end
function v7.OnCreate(p1) --[[ OnCreate | Line: 90 | Upvalues: v1 (copy), v4 (copy), LocalPlayer (copy) ]]
	v1.OnCreate(p1)
	local v12 = p1.Instance
	p1.HipHeight = math.max(v12:GetAttribute("HipHeight") or 2, 0)
	p1.Connections:AddConnection("hipHeight", v12:GetAttributeChangedSignal("HipHeight"):Connect(function() --[[ Line: 97 | Upvalues: p1 (copy), v12 (copy), v4 (ref) ]]
		p1.HipHeight = math.max(v12:GetAttribute("HipHeight") or 2, 0)
		v4.HipHeightChanged:Fire(p1)
	end))
	p1.CurrentHipHeight = p1.HipHeight
	if v12 ~= LocalPlayer then
		p1.CurrentHipHeight = math.max(v12:GetAttribute("cHipHeight") or p1.HipHeight, 0)
		p1.Connections:AddConnection("cHipHeight", v12:GetAttributeChangedSignal("cHipHeight"):Connect(function() --[[ Line: 105 | Upvalues: p1 (copy), v12 (copy), v4 (ref) ]]
			p1.CurrentHipHeight = math.max(v12:GetAttribute("cHipHeight") or p1.HipHeight, 0)
			v4.HipHeightChanged:Fire(p1)
		end))
	end
end
function v7.OnCreated(p1) --[[ OnCreated | Line: 112 | Upvalues: v1 (copy) ]]
	v1.OnCreated(p1)
	if not p1.Instance:IsA("Player") then
		p1:SetupHumanoid()
	end
end
function v7.UpdateInAir(p1) --[[ UpdateInAir | Line: 119 | Upvalues: Utils (copy), v4 (copy) ]]
	local Humanoid = p1.Humanoid
	if Humanoid then
		local v1 = if Humanoid:GetState() == Enum.HumanoidStateType.Freefall then true else Humanoid:GetState() == Enum.HumanoidStateType.Jumping
		if Utils.ToBool(v1) ~= Utils.ToBool(p1._InAir) then
			p1._InAir = v1
			v4.InAirChanged:Fire(p1)
		end
	end
end
function v7.SetupHumanoid(p1) --[[ SetupHumanoid | Line: 132 | Upvalues: v4 (copy) ]]
	local v1 = p1:GetHumanoid()
	p1.Humanoid = v1
	if v1 then
		p1.Moving = nil
		p1.Connections:AddConnection("humanoidRunning", v1.Running:Connect(function(p12) --[[ Line: 140 | Upvalues: p1 (copy) ]]
			if p12 < 1 then
				p12 = 0
			end
			p1.Moving = p12
		end))
		p1.Connections:AddConnection("humanoidState", v1.StateChanged:Connect(function(p12, p2) --[[ Line: 146 | Upvalues: v4 (ref), p1 (copy) ]]
			if p2 == Enum.HumanoidStateType.Jumping then
				v4.Jumping:Fire(p1)
			end
			if p12 == Enum.HumanoidStateType.Freefall or (p12 == Enum.HumanoidStateType.Jumping or (p2 == Enum.HumanoidStateType.Freefall or (p2 == Enum.HumanoidStateType.Landed or p2 == Enum.HumanoidStateType.Running))) then
				p1:UpdateInAir()
			end
		end))
		p1:UpdateInAir()
	end
end
function v7.AddToCastParamsFilter(p1, p2) --[[ AddToCastParamsFilter | Line: 158 ]]
	local v1 = p1:GetWorkspaceRoot()
	if v1 then
		p2:AddToFilter(v1)
	end
end
function v7.GetWorkspaceRoot(p1) --[[ GetWorkspaceRoot | Line: 165 ]]
	return p1:GetModel()
end
function v7.GetModel(p1) --[[ GetModel | Line: 169 ]]
	return p1.Instance:IsA("Model") and p1.Instance
end
function v7.GetHumanoid(p1) --[[ GetHumanoid | Line: 173 ]]
	local v1 = p1:GetModel()
	return if v1 then v1:FindFirstChild("Humanoid") else v1
end
function v7.GetVelocity(p1) --[[ GetVelocity | Line: 178 ]]
	local v1 = p1:GetRootPart()
	return if v1 then v1.AssemblyLinearVelocity or Vector3.new(0, 0, 0) else Vector3.new(0, 0, 0)
end
function v7.GetRootPart(p1) --[[ GetRootPart | Line: 183 ]]
	local v1 = p1:GetModel()
	return if v1 then v1:FindFirstChild("HumanoidRootPart") else v1
end
function v7.GetBodyPart(p1) --[[ GetBodyPart | Line: 188 ]]
	local v1 = p1:GetModel()
	if v1 then
		local v2 = v1:FindFirstChild("Collider") or v1
		if v2 then
			return v2:FindFirstChild("BodyPart") or (v2:FindFirstChild("UpperTorso") or p1:GetRootPart())
		else
			return p1:GetRootPart()
		end
	end
end
function v7.GetClosestPointTo(p1, p2) --[[ GetClosestPointTo | Line: 200 | Upvalues: v1 (copy), Utils (copy) ]]
	if p1:GetBodyPart() then
		local v12 = p1:GetRootPart()
		local _, v2 = Utils.DistanceToBox(p2, v12.CFrame * CFrame.new(Vector3.new(-0, -0.5, -0)), Vector3.new(4, 4.5, 1.2), true)
		return v2
	else
		return v1.GetClosestPointTo(p1, p2)
	end
end
function v7.GetPivot(p1, p2) --[[ GetPivot | Line: 212 ]]
	local v1 = p1:GetModel()
	if v1 then
		local v2 = p1:GetRootPart()
		if v2 then
			if p2 then
				return v2.CFrame
			else
				return v2.CFrame * p1:GetPivotOffset()
			end
		else
			return v1:GetPivot()
		end
	end
end
function v7.GetPivotOffset(p1) --[[ GetPivotOffset | Line: 227 ]]
	local v1 = p1:GetRootPart()
	if p1:GetHumanoid() and v1 then
		return CFrame.new(0, -(v1.Size.Y / 2 + p1.HipHeight), 0)
	else
		return CFrame.identity
	end
end
function v7.GetHipHeight(p1) --[[ GetHipHeight | Line: 236 ]] end
function v7.InAir(p1) --[[ InAir | Line: 240 ]]
	return p1._InAir
end
function v7.GetMoveDirection(p1) --[[ GetMoveDirection | Line: 244 | Upvalues: v2 (copy) ]]
	if p1._moveDirectionUpdate then
		p1:UpdateMoveDirection()
	end
	return p1._MoveDirection or v2.Front
end
local v8 = table.freeze({ 1, 0, 0, 0 })
function v7.GetMoveDirectionRaw(p1) --[[ GetMoveDirectionRaw | Line: 258 | Upvalues: v8 (copy) ]]
	if p1._moveDirectionUpdate then
		p1:UpdateMoveDirection()
	end
	return p1._MoveDirectionRaw or v8
end
function v7.UpdateMoveDirection(p1) --[[ UpdateMoveDirection | Line: 265 | Upvalues: v2 (copy), v4 (copy) ]]
	p1._moveDirectionUpdate = nil
	local v1 = p1:GetHumanoid()
	if v1 and v1.RootPart then
		local v22 = v1.RootPart:GetPivot()
		local MoveDirection = v1.MoveDirection
		if MoveDirection.Magnitude == 0 then
			MoveDirection = v1.RootPart.AssemblyLinearVelocity
		end
		local v3 = p1:IsMoving()
		local t = { 1, 0, 0, 0 }
		if v3 and MoveDirection.Magnitude > 0.4 then
			local v42 = v22:PointToObjectSpace(v22.Position + MoveDirection.Unit) * Vector3.new(1, 0, 1)
			if v42.Magnitude > 0 then
				t[1] = 0
				local _, v5, _2 = CFrame.lookAt(Vector3.new(0, 0, 0), v42):ToOrientation()
				local v7 = math.round(math.deg(v5) * 10) / 10
				local v9 = 1 - math.abs(90 - math.abs(v7)) / 90
				local v10 = 1 - v9
				if math.abs(v7) > 91 then
					t[v2.Back] = v10
				else
					t[v2.Front] = v10
				end
				if v7 > 0 then
					t[v2.Left] = v9
				else
					t[v2.Right] = v9
				end
			end
		end
		local Front = v2.Front
		if t[v2.Back] > 0 then
			Front = v2.Back
		end
		if t[v2.Left] > 0.4 then
			Front = v2.Left
		elseif t[v2.Right] > 0.4 then
			Front = v2.Right
		end
		local v11 = p1:GetMoveDirection()
		local v12 = math.abs(Front - v11)
		if (v12 == 1 or v12 == 3) and v3 and (Front == v2.Front or Front == v2.Back) then
			if t[Front] < 0.605 then
				Front = v11
			end
		elseif (v12 == 1 or v12 == 3) and v3 and t[Front] < 0.405 then
			Front = v11
		end
		p1._MoveDirectionRaw = t
		p1._MoveDirection = Front
		if Front ~= v11 then
			v4.MoveDirectionChanged:Fire(p1, Front, v11)
		end
	end
end
function v7.IsActive(p1, ...) --[[ IsActive | Line: 330 | Upvalues: v1 (copy) ]]
	if p1.Humanoid then
		return v1.IsActive(p1, ...)
	end
end
function v7.IsReady(p1) --[[ IsReady | Line: 337 ]]
	local v1 = p1:GetModel()
	return if v1 then v1:FindFirstChild("HumanoidRootPart") else v1
end
function v7.onStart() --[[ onStart | Line: 343 ]] end
return v7