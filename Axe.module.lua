-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.WeaponConfig.Axe

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
local Anim = ReplicatedStorage.Assets.Anim
local t = {
	Display = "Hatchet",
	SoundGroup = { script.Name, "Melee" },
	MeleeSeq = {
		[-1] = {
			Duration = 0.95,
			Damage = 100,
			Segments = {
				{
					HitSize = Vector3.new(2, 4, 4.5),
					Start = 0.23,
					Stop = 0.33
				}
			}
		},
		{
			Duration = 0.42,
			Segments = {
				{
					HitSize = Vector3.new(3, 3, 4.5),
					Start = 0.1,
					Stop = 0.2
				}
			}
		},
		{
			Duration = 0.42,
			Segments = {
				{
					HitSize = Vector3.new(3, 3, 4.5),
					Start = 0.1,
					Stop = 0.2
				}
			}
		}
	},
	FakeArmAnims = Anim.FakeArm.Human.Axe.Default,
	CharacterAnims = Anim.Character.Human.Axe.Default
}
require(ReplicatedStorage.Config.WeaponConfig.BaseMelee):extends(t)
return t