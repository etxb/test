-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.WeaponConfig.AK47

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
local Anim = ReplicatedStorage.Assets.Anim
local t = {
	Display = "AK47",
	UseFreePart = true,
	Limited = true,
	Ammo = 30,
	AttackRate = 8,
	ReloadTime = 1.83,
	ReloadTimeEmpty = 2.33,
	DontRandom = true,
	SoundGroup = { script.Name },
	FakeArmAnims = Anim.FakeArm.Human.AK47.Default,
	CharacterAnims = Anim.Character.Human.AK47.Default,
	Sounds = {
		Switch = {
			Duration = 1,
			Frames = {
				{
					Time = 0.15,
					Name = "SlidePull"
				},
				{
					Time = 0.45,
					Name = "SlidePush"
				}
			}
		},
		Reload = {
			Duration = 1.83,
			Frames = {
				{
					Time = 0.33,
					Name = "ClipOut"
				},
				{
					Time = 1.1,
					Name = "ClipIn"
				}
			}
		},
		ReloadEmpty = {
			Duration = 2.33,
			Frames = {
				{
					Time = 0.18,
					Name = "SlidePull"
				},
				{
					Time = 0.52,
					Name = "ClipOut"
				},
				{
					Time = 1.3,
					Name = "ClipIn"
				},
				{
					Time = 1.9,
					Name = "SlidePush"
				}
			}
		}
	},
	Components = {
		Shootable = {
			Spread = {
				MinSpread = 1,
				MaxSpread = 3,
				ShotsToMax = 10,
				RecoveryTime = 0.3,
				StableShots = 4,
				StableRate = 0.2
			}
		}
	},
	AimFriction = {
		Size = 1,
		MinRate = 0,
		MaxRate = 0.4,
		Distance = 150,
		AimOnly = false
	}
}
require(ReplicatedStorage.Config.WeaponConfig.BaseGunRifle):extends(t)
return t