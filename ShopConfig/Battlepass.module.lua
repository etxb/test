-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.ShopConfig.Battlepass

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.WeaponConfig)
require(ReplicatedStorage.Config.GachaConfig)
require(ReplicatedStorage.Util.RewardUtils)
local t = {}
local function createProduct(p1, p2, p3, p4) --[[ createProduct | Line: 52 | Upvalues: Constant (copy), t (copy) ]]
	local t2 = {}
	local t3 = {
		Reward = p2,
		Condition = p3,
		Price = {
			Eco = Constant.Robux
		}
	}
	t[p1] = t3
	table.insert(t2, t3)
	local t4 = {
		Reward = p2,
		Condition = p3,
		Price = {
			Eco = Constant.Status.Eco_TradeToken,
			Value = p4 * 10
		}
	}
	t[("%s_TradeToken"):format(p1)] = t4
	table.insert(t2, t4)
	t[("%s_Prompt"):format(p1)] = {
		ProductGroup = true,
		Reward = p2,
		List = t2
	}
end
createProduct(Constant.Product.Battlepass_Premium, {
	RewardType = "Battlepass",
	Reward = {
		Premium = true
	}
}, {
	ConditionType = "Battlepass",
	Not = true,
	Condition = {
		Premium = true
	}
}, 699)
createProduct(Constant.Product.Battlepass_Lv1, {
	RewardType = "Battlepass",
	Reward = {
		Level = 1
	}
}, {
	ConditionType = "Battlepass",
	Not = true,
	Condition = {
		MaxLevel = true
	}
}, 49)
createProduct(Constant.Product.Battlepass_Lv10, {
	RewardType = "Battlepass",
	Reward = {
		Level = 10
	}
}, {
	ConditionType = "Battlepass",
	Not = true,
	Condition = {
		MaxLevel = true
	}
}, 449)
return t