-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Remote.EntityService.Entity.HumanoidEntity.PlayerEntity

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Config = require(ReplicatedStorage.Config.Config)
local Utils = require(ReplicatedStorage.Util.Utils)
require(ReplicatedStorage.Util.InstanceUtils)
local SimpleSignal = require(ReplicatedStorage.Shared.SimpleSignal)
local CommonPlayerEntity = require(ReplicatedStorage.Common.EntityService.CommonEntity.CommonHumanoidEntity.CommonPlayerEntity)
local ReplicateService = require(ReplicatedStorage.Remote.ReplicateService)
local v1 = require(script.Parent)
local v3 = setmetatable({
	CharacterAdded = SimpleSignal.new(),
	CharacterRemoving = SimpleSignal.new()
}, v1.Event)
local v4 = setmetatable({
	CharacterAdded = SimpleSignal.new(),
	CharacterRemoving = SimpleSignal.new()
}, v1.FocusedEvent)
local v5 = setmetatable({
	CharacterAdded = SimpleSignal.new(),
	CharacterRemoving = SimpleSignal.new()
}, v1.LocalEvent)
v5.__index = v5
local v6 = setmetatable({
	Event = v3,
	FocusedEvent = v4,
	LocalEvent = v5,
	ActiveState = CommonPlayerEntity.ActiveState
}, v1)
v6.__index = v6
function v6.__tostring(p1) --[[ Line: 46 ]]
	return ("PlayerEntity[%s]"):format(p1.Instance.Name)
end
function v6.OnCreated(p1) --[[ OnCreated | Line: 52 | Upvalues: v1 (copy), Utils (copy), v3 (copy), LocalPlayer (copy) ]]
	v1.OnCreated(p1)
	p1.Player = p1.Instance
	local v12 = p1.Instance
	p1.Connections:AddConnection("characterAdded", Utils.OnCharacterAdded(p1.Player, function(p12, p2, p3) --[[ Line: 57 | Upvalues: v12 (copy), p1 (copy), v3 (ref) ]]
		p12:WaitForChild("HumanoidRootPart")
		p12:WaitForChild("Humanoid"):WaitForChild("Animator")
		if p12 == v12.Character then
			p1:SetupHumanoid()
			v3.CharacterAdded:Fire(p1, p12)
			p12.ChildRemoved:Connect(function(p13) --[[ Line: 67 | Upvalues: p12 (copy), v12 (ref), p1 (ref) ]]
				if p12 == v12.Character and p13:IsA("Humanoid") then
					p1:SetupHumanoid()
				end
			end)
		end
	end))
	p1.Connections:AddConnection("characterRemoving", p1.Player.CharacterRemoving:Connect(function(p12) --[[ Line: 74 | Upvalues: v3 (ref), p1 (copy) ]]
		v3.CharacterRemoving:Fire(p1, p12)
	end))
	if v12 ~= LocalPlayer then
		p1.Connections:AddConnection("inAir", p1.Player:GetAttributeChangedSignal("InAir"):Connect(function() --[[ Line: 78 | Upvalues: p1 (copy) ]]
			p1:UpdateInAir()
		end))
		p1.Connections:AddConnection("jump", p1.Player:GetAttributeChangedSignal("Jump"):Connect(function() --[[ Line: 81 | Upvalues: v1 (ref), p1 (copy) ]]
			v1.Event.Jumping:Fire(p1)
		end))
	end
end
function v6.IsReady(p1) --[[ IsReady | Line: 87 ]]
	local v1 = p1.Player.Character and (p1.Player.Character:FindFirstChild("HumanoidRootPart") and p1.Player.Character:FindFirstChild("Humanoid"))
	return if v1 then v1:FindFirstChild("Animator") and true else v1
end
function v6.UpdateInAir(p1) --[[ UpdateInAir | Line: 92 | Upvalues: Utils (copy), v3 (copy) ]]
	local v1 = p1.Player:GetAttribute("InAir")
	if Utils.ToBool(v1) ~= Utils.ToBool(p1._InAir) then
		p1._InAir = v1
		v3.InAirChanged:Fire(p1)
	end
end
function v6.GetDisplayName(p1) --[[ GetDisplayName | Line: 101 ]]
	if p1.Player then
		return p1.Player.DisplayName
	end
end
function v6.GetModel(p1) --[[ GetModel | Line: 108 ]]
	if p1.Player then
		return p1.Player.Character
	end
end
function v6.GetHeadAt(p1) --[[ GetHeadAt | Line: 115 ]]
	local v1 = p1:GetHeadPart()
	return if v1 then v1.CFrame else v1
end
function v6.GetHeadPart(p1) --[[ GetHeadPart | Line: 120 ]]
	local v1 = p1:GetModel()
	if v1 then
		return v1:FindFirstChild("Head")
	end
end
if Config.Feature.ReplicateSystem then
	function v6.UpdateScale(p1) --[[ UpdateScale | Line: 130 ]]
		local v1 = p1:GetModel()
		if v1 then
			v1:ScaleTo(p1.Scale)
		end
	end
	require(ReplicatedStorage.Shared.chrono)
	function v6.GetVelocity(p1) --[[ GetVelocity | Line: 139 | Upvalues: LocalPlayer (copy), ReplicateService (copy) ]]
		local v1 = p1:GetRootPart()
		if v1 then
			if p1.Player == LocalPlayer then
				return v1.AssemblyLinearVelocity
			else
				return ReplicateService.GetVelocity(p1.Player)
			end
		else
			return Vector3.new(0, 0, 0)
		end
	end
	function v6.InAir(p1) --[[ InAir | Line: 150 | Upvalues: LocalPlayer (copy), v1 (copy) ]]
		if p1.Player == LocalPlayer then
			return v1.InAir(p1)
		else
			return p1.Player:GetAttribute("InAir")
		end
	end
end
return v6