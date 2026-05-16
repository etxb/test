-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Util.CharacterUtils

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Utils = require(ReplicatedStorage.Util.Utils)
local InstanceUtils = require(ReplicatedStorage.Util.InstanceUtils)
local t = {}
local function attachGripAndClip(p1, p2, p3) --[[ attachGripAndClip | Line: 8 ]]
	local v1 = script.Grip:Clone()
	if p3 then
		v1.Name = p3 .. v1.Name
	end
	v1:PivotTo(p2.WorldCFrame)
	v1.Grip.C0 = CFrame.new(p2.CFrame.Position)
	v1.Grip.Part0 = p1
	v1.Parent = p1
	p2.Changed:Connect(function(p1) --[[ Line: 18 | Upvalues: v1 (ref), p2 (copy) ]]
		if p1 == "CFrame" then
			v1.Grip.C0 = CFrame.new(p2.CFrame.Position)
		end
	end)
	local v2 = script.Clip:Clone()
	if p3 then
		v2.Name = p3 .. v2.Name
	end
	local v3 = v2
	v3:PivotTo(p2.WorldCFrame)
	v3.Clip.Part0 = v1
	v3.Parent = p1
	local v4 = script.Slide:Clone()
	local v5 = p3 or "Right"
	if v5 then
		v4.Name = v5 .. v4.Name
	end
	local v6 = v4
	v6:PivotTo(p2.WorldCFrame)
	v6.Slide.Part0 = v1
	v6.Parent = p1
end
local function attachFreePart(p1) --[[ attachFreePart | Line: 64 ]]
	local v1 = script.FreePart:Clone()
	v1.Parent = p1.Parent
	v1.Base.Free_LowerTorso.Motor6D.Part0 = p1
end
local function onCharacterChildAdded(p1, p2) --[[ onCharacterChildAdded | Line: 72 | Upvalues: InstanceUtils (copy), attachGripAndClip (copy) ]]
	if p2 and p2:IsA("BasePart") then
		if p2.Name == "LeftHand" or p2.Name == "RightHand" then
			local v1 = if p2.Name == "LeftHand" then "Left" else false
			local v3 = InstanceUtils.WaitFor(p2, if v1 then "LeftGripAttachment" else "RightGripAttachment")
			if v3 then
				attachGripAndClip(p2, v3, v1 and "Left")
			end
		else
			if p2.Name == "LowerTorso" then
				script.LowerTorsoAttachment.WaistLeftAttachment:Clone().Parent = p2
				script.LowerTorsoAttachment.WaistRightAttachment:Clone().Parent = p2
				return
			end
			if p2.Name ~= "HumanoidRootPart" then
				return
			end
			local v4 = script.FreePart:Clone()
			v4.Parent = p2.Parent
			v4.Base.Free_LowerTorso.Motor6D.Part0 = p2
		end
	end
end
function t.SetupCharacter(p1) --[[ SetupCharacter | Line: 97 | Upvalues: Utils (copy), onCharacterChildAdded (copy) ]]
	Utils.ConnectAndExecuteWiths(p1.ChildAdded, function(p12) --[[ Line: 98 | Upvalues: onCharacterChildAdded (ref), p1 (copy) ]]
		onCharacterChildAdded(p1, p12)
	end, p1:GetChildren())
end
return t