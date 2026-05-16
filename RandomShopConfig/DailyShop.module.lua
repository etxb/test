-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.RandomShopConfig.DailyShop

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
return {
	Slots = 6,
	VIPSlots = 1,
	Refresh = 5,
	VIPRefreshFree = 1,
	RefreshCost = { 50, 200, 500, 1000, 5000 },
	WeaponPriceRate = {
		[Constant.Rarity.UnCommon] = 10,
		[Constant.Rarity.Rare] = 10,
		[Constant.Rarity.Epic] = 8,
		[Constant.Rarity.Legendary] = 8.2,
		[Constant.Rarity.Mystic] = 7
	}
}