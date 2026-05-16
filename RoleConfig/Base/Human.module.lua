-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.RoleConfig.Base.Human

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local t = {
	FakeArm = "Human",
	FakeArmAdapter = "Human",
	InheritClothing = true,
	Health = { 100 },
	WalkSpeed = { 18.8 },
	JumpHeight = { 4 }
}
require(script.Parent.Base):extends(t)
t:AddTag(Constant.RoleTag.Human)
return t