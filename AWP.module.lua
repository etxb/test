-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.WeaponConfig.AWP

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
local Anim = ReplicatedStorage.Assets.Anim
local t = {
	Display = "AWP",
	SoundGroup = { script.Name },
	FakeArmAnims = Anim.FakeArm.Human.AWP.Default,
	CharacterAnims = Anim.Character.Human.AWP.Default
}
require(ReplicatedStorage.Config.WeaponConfig.BaseGunSniper):extends(t)
return t