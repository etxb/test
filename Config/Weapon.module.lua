-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.Config.Weapon

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
return {
	DefaultWeapon = "SSG",
	InventorySize = 12000,
	Starter = {
		[Constant.EquipmentSlot.Primary] = "SSG",
		[Constant.EquipmentSlot.Secondary] = "ClassKnife"
	},
	KilledUnlock = {
		AWP = 200,
		M82A1 = 1000,
		M200 = 2000,
		Kar98k = 3000,
		WA2000 = 4000,
		NTW20 = 5000,
		DSR1 = 6000
	},
	BaseWeaponOrder = (function() --[[ Line: 24 | Upvalues: RunService (copy), TableUtils (copy) ]]
		local t = {
			"SSG",
			"AWP",
			"M82A1",
			"M200",
			"Kar98k",
			"WA2000",
			"NTW20",
			"DSR1",
			"Glove",
			"Charm",
			"ClassKnife",
			"FlipKnife",
			"Bayonet",
			"ShadowDaggers",
			"Karambit",
			"Bayonet_M9",
			"GutKnife",
			"ButterflyKnife",
			"TacticalKnife",
			"Stiletto",
			"Skeleton",
			"Falchion",
			"Bowie",
			"Kukri",
			"Axe",
			"CordKnife",
			"Shovel",
			"Wakizashi"
		}
		if RunService:IsStudio() then
			table.insert(t, "CrookSword")
			table.insert(t, "AK47")
		end
		return TableUtils.SwapKV(t)
	end)(),
	WearFactor = (function() --[[ Line: 64 ]]
		local t = {
			WeightSum = 0,
			Range = {
				{
					Display = "Factory New",
					ShortDisplay = "FN",
					Key = "FN",
					Value = 0.0001,
					Weight = 1,
					LightWeight = 0,
					HeavyWeight = 0,
					TextColor = Color3.fromRGB(255, 255, 0)
				},
				{
					Display = "Mint Condition",
					ShortDisplay = "MC",
					Key = "MC",
					Value = 0.15,
					Weight = 149,
					LightWeight = 0.75,
					HeavyWeight = 0,
					TextColor = Color3.fromRGB(0, 255, 255)
				},
				{
					Display = "Standard Issue",
					ShortDisplay = "SI",
					Key = "SI",
					Value = 0.3,
					Weight = 300,
					LightWeight = 1,
					HeavyWeight = 0.75,
					TextColor = Color3.fromRGB(0, 255, 0)
				},
				{
					Display = "Well-Worn",
					ShortDisplay = "WW",
					Key = "WW",
					Value = 1,
					Weight = 550,
					LightWeight = 1,
					HeavyWeight = 1,
					TextColor = Color3.fromRGB(255, 255, 255)
				}
			}
		}
		for v1, v2 in t.Range do
			t.WeightSum = t.WeightSum + v2.Weight
		end
		function t.FetchRange(p1) --[[ FetchRange | Line: 123 | Upvalues: t (copy) ]]
			if p1 then
				for v1, v2 in t.Range do
					if not (v2.Value < p1 and v1 < #t.Range) then
						return v2
					end
				end
			end
		end
		function t.GetDisplay(p1, p2) --[[ GetDisplay | Line: 135 | Upvalues: t (copy) ]]
			local v1 = t.FetchRange(p1)
			if p2 then
				return v1.ShortDisplay
			else
				return v1.Display
			end
		end
		return t
	end)()
}