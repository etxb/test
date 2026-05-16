-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.QuestConfig.NewWeapon2Event

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
local GachaConfig = require(ReplicatedStorage.Config.GachaConfig)
local WeaponConfig = require(ReplicatedStorage.Config.WeaponConfig)
local NewWeapon2Event = require(ReplicatedStorage.Config.Event.NewWeapon2Event)
require(ReplicatedStorage.Util.RewardUtils)
local count = 1
local function genOrder() --[[ genOrder | Line: 12 | Upvalues: count (ref) ]]
	count = count + 1
	return count
end
local Display = WeaponConfig[NewWeapon2Event.Weapon].Display
local t = {}
local t2 = {
	ManualReward = true,
	Display = ("Random Mystic %s [1]"):format(Display),
	Timeout = NewWeapon2Event.Timeout
}
local t3 = {}
local t4 = {
	Value = 150
}
count = count + 1
t4.Order = count
t4.Type = ("Kill_%s"):format(NewWeapon2Event.Weapon)
t4.Display = ("Get kills with [%s]"):format(Display)
t3.Q1 = t4
local t5 = {
	Value = 50
}
count = count + 1
t5.Order = count
t5.Type = ("Headshot_%s"):format(NewWeapon2Event.Weapon)
t5.Display = ("Get headshots with [%s]"):format(Display)
t3.Q2 = t5
local t6 = {
	Value = 5
}
count = count + 1
t6.Order = count
t6.Type = ("KillStreak5_%s"):format(NewWeapon2Event.Weapon)
t6.Display = ("Get 5 Streak with [%s]"):format(Display)
t3.Q3 = t6
t2.Quests = t3
t2.Reward = {
	RewardType = "Weapon",
	Reward = {
		Random = true,
		Untradeable = true,
		Weapons = GachaConfig.GetGainableWeaponsByRarityOf(Constant.Rarity.Mystic, NewWeapon2Event.Weapon),
		RandomWeaponRarity = { NewWeapon2Event.Weapon, Constant.Rarity.Mystic, "Random Mystic" }
	}
}
t2.RewardDisplay = ("Random Mystic [%s]"):format(Display)
t[NewWeapon2Event.Quest] = t2
local t7 = {
	QuestToFinish = 1,
	ManualReward = true,
	Display = ("Random Mystic %s [2]"):format(Display),
	Timeout = NewWeapon2Event.Timeout
}
local t8 = {}
local t9 = {
	Type = "Spent_Eco_Coin",
	Display = "Spend of Credits"
}
count = count + 1
t9.Order = count
t9.Value = NewWeapon2Event.Quest2Spent.Coin
t8.Q1 = t9
local t10 = {
	Type = "Spent_Eco_TradeToken",
	Display = "Spend of Cash"
}
count = count + 1
t10.Order = count
t10.Value = NewWeapon2Event.Quest2Spent.TradeToken
t8.Q2 = t10
t7.Quests = t8
t7.Reward = {
	RewardType = "Weapon",
	Reward = {
		Random = true,
		Untradeable = true,
		Weapons = GachaConfig.GetGainableWeaponsByRarityOf(Constant.Rarity.Mystic, NewWeapon2Event.Weapon),
		RandomWeaponRarity = { NewWeapon2Event.Weapon, Constant.Rarity.Mystic, "Random Mystic" }
	}
}
t7.RewardDisplay = ("Random Mystic [%s]"):format(Display)
t[NewWeapon2Event.Quest2] = t7
local t11 = {
	Display = "Free Shovel",
	RewardDisplay = "Cord Knife",
	ManualReward = true,
	Timeout = NewWeapon2Event.Timeout
}
local t12 = {}
local t13 = {
	Type = "RobuxSpent",
	Display = "Spend of Robux"
}
count = count + 1
t13.Order = count
t13.Value = NewWeapon2Event.Quest3Spent.Robux
t12.Q1 = t13
t11.Quests = t12
t11.Reward = {
	RewardType = "Weapon",
	Reward = {
		Weapon = "Shovel"
	}
}
t[NewWeapon2Event.Quest3] = t11
return t