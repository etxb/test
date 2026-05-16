-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.ShopConfig.Weapon

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
local WeaponConfig = require(ReplicatedStorage.Config.WeaponConfig)
local RewardUtils = require(ReplicatedStorage.Util.RewardUtils)
local t = {}
local function createWeaponProduct(p1, p2, p3) --[[ createWeaponProduct | Line: 13 | Upvalues: WeaponConfig (copy), RunService (copy), RewardUtils (copy), Constant (copy), t (copy) ]]
	local v1 = WeaponConfig[p1]
	if v1 then
		if RunService:IsStudio() and v1.Limited then
			warn("\230\173\166\229\153\168\229\173\152\229\156\168\233\153\144\229\136\182\230\160\135\232\175\134, \230\179\168\230\132\143\230\163\128\230\159\165\229\149\134\229\147\129\229\143\130\230\149\176")
		end
		local t2 = {
			Display = v1.Display or p1,
			Reward = RewardUtils.weapon(p1),
			Condition = {
				ConditionType = "Weapon",
				Condition = {
					Unowned = true,
					Weapon = p1
				}
			}
		}
		local t3 = {}
		t3.Eco = if p3 then p3 else Constant.Status.Eco_Coin
		t3.Value = p2
		t2.Price = t3
		t2.Message = Constant.Message.Weapon.UnlockSuccess:format(v1.Display)
		t[p1] = t2
	elseif RunService:IsStudio() then
		warn("\230\173\166\229\153\168\228\184\141\229\173\152\229\156\168", p1)
	end
end
createWeaponProduct("AWP", 5000)
createWeaponProduct("M82A1", 30000)
createWeaponProduct("M200", 50000)
createWeaponProduct("Kar98k", 75000)
createWeaponProduct("WA2000", 100000)
createWeaponProduct("NTW20", 125000)
createWeaponProduct("DSR1", 150000)
return t