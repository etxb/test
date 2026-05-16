-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.GameConfig.FFA.FFA_GunGame

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local WeaponConfig = require(ReplicatedStorage.Config.WeaponConfig)
local TableUtils = require(ReplicatedStorage.Util.TableUtils)
local v1 = require(script.Parent)
local t = {
	FinalWeapon = "Exotic.TT_S1.BeamSaber",
	KillsForFinal = 29,
	RandomWeapons = (function() --[[ buildGunGameWeapons | Line: 11 | Upvalues: WeaponConfig (copy), Constant (copy) ]]
		local t = {}
		for v1, v2 in WeaponConfig.GetKeysByRarity(Constant.Rarity.Exotic) do
			local v3 = WeaponConfig[v2]
			if v3 and (not v3.Limited and (v3.WeaponType == Constant.WeaponType.Sniper and v3.SecondaryRarity == Constant.Rarity.Exotic)) then
				table.insert(t, v3.Name)
			end
		end
		return t
	end)()
}
TableUtils.Extends(t, v1)
return t