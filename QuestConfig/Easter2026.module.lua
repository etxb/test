-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.QuestConfig.Easter2026

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
require(ReplicatedStorage.Config.GachaConfig)
require(ReplicatedStorage.Config.WeaponConfig)
local Easter2026Event = require(ReplicatedStorage.Config.Event.Easter2026Event)
require(ReplicatedStorage.Util.RewardUtils)
local count = 1
local function genOrder() --[[ genOrder | Line: 12 | Upvalues: count (ref) ]]
	count = count + 1
	return count
end
local t = {}
local t2 = {
	Display = "Easter Task [1]",
	RewardDisplay = "Limited Case x2",
	ManualReward = true,
	Timeout = Easter2026Event.Timeout
}
local t3 = {}
local t4 = {
	Type = "Kill",
	Value = 125,
	Display = "Get kills"
}
count = count + 1
t4.Order = count
t3.Q1 = t4
local t5 = {
	Type = "Headshot",
	Value = 20,
	Display = "Headshot Kill"
}
count = count + 1
t5.Order = count
t3.Q2 = t5
local t6 = {
	Type = "KillStreak5",
	Value = 3,
	Display = "Get 5 Streak"
}
count = count + 1
t6.Order = count
t3.Q3 = t6
t2.Quests = t3
t2.Reward = {
	RewardType = "Gacha",
	Reward = {
		Count = 2,
		Gacha = ("%s_Untradeable"):format(Easter2026Event.Gacha)
	}
}
t[Easter2026Event.Quests[1]] = t2
local t7 = {
	Display = "Easter Task [2]",
	RewardDisplay = "Limited Case x2",
	ManualReward = true,
	Timeout = Easter2026Event.Timeout,
	DependFinishedQuests = { Easter2026Event.Quests[1] }
}
local t8 = {}
local t9 = {
	Type = "Noscope",
	Value = 50,
	Display = "No-scope kill"
}
count = count + 1
t9.Order = count
t8.Q1 = t9
t7.Quests = t8
t7.Reward = {
	RewardType = "Gacha",
	Reward = {
		Count = 2,
		Gacha = ("%s_Untradeable"):format(Easter2026Event.Gacha)
	}
}
t[Easter2026Event.Quests[2]] = t7
local t10 = {
	Display = "Easter Task [3]",
	RewardDisplay = "Limited Case x2 & Random Knife",
	ManualReward = true,
	Timeout = Easter2026Event.Timeout,
	DependFinishedQuests = { Easter2026Event.Quests[2] }
}
local t11 = {}
local t12 = {
	Type = "QuickscopeHeadshot",
	Value = 20,
	Display = "Quick-scope headshot"
}
count = count + 1
t12.Order = count
t11.Q1 = t12
t10.Quests = t11
t10.Reward = {
	RewardType = "All",
	Reward = {
		{
			RewardType = "Gacha",
			Reward = {
				Count = 2,
				Gacha = ("%s_Untradeable"):format(Easter2026Event.Gacha)
			}
		},
		{
			RewardType = "Weapon",
			Reward = {
				RandomMelee = true,
				Untradeable = true
			}
		}
	}
}
t[Easter2026Event.Quests[3]] = t10
return t