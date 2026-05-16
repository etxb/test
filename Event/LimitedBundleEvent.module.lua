-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.Event.LimitedBundleEvent

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local RewardUtils = require(ReplicatedStorage.Util.RewardUtils)
return {
	StandardDisplay = "Limited Bundle - Sky Watcher",
	StandardDisplaySub = "Sky Watcher",
	STDisplay = "Limited Bundle - Sky Watcher [ST]",
	STDisplaySub = "Sky Watcher [ST]",
	Timeout = DateTime.fromUniversalTime(2026, 6, 1).UnixTimestamp,
	Standard = RewardUtils.all(RewardUtils.weapon("Exotic.Watcher_Sky.AWP"), RewardUtils.weapon("Exotic.Watcher_Sky.M82A1"), RewardUtils.weapon("Exotic.Watcher_Sky.Karambit"), RewardUtils.weapon("Exotic.Watcher_Sky.Glove")),
	ST = RewardUtils.all(RewardUtils.weapon("Exotic.Watcher_Sky.AWP"):setRewardData("StatTrak", true), RewardUtils.weapon("Exotic.Watcher_Sky.M82A1"):setRewardData("StatTrak", true), RewardUtils.weapon("Exotic.Watcher_Sky.Karambit"):setRewardData("StatTrak", true), RewardUtils.weapon("Exotic.Watcher_Sky.Glove"):setRewardData("StatTrak", true)),
	Product = {
		Standard = Constant.Product.LimitedBundle,
		ST = Constant.Product.LimitedBundle_ST,
		Gift_Standard = Constant.Product.Gift_LimitedBundle,
		Gift_ST = Constant.Product.Gift_LimitedBundle_ST
	},
	LimitedProduct = {
		Standard = "LBundle_Watcher",
		ST = "LBundle_Watcher_ST"
	}
}