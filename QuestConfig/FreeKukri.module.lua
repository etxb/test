-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.QuestConfig.FreeKukri

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
local RewardUtils = require(ReplicatedStorage.Util.RewardUtils);
({
	ItemSku = "DailyQuest"
}).TransType = Enum.AnalyticsEconomyTransactionType.Gameplay
local count = 0
local function genOrder() --[[ genOrder | Line: 11 | Upvalues: count (ref) ]]
	count = count + 1
	return count
end
local t = {}
local t2 = {
	Display = "Free Kukri",
	RewardDisplay = "Kukri",
	ManualReward = true
}
local t3 = {}
local t4 = {
	Type = "Headshot",
	Value = 10,
	Display = "Headshot Kill"
}
count = count + 1
t4.Order = count
t3.Q1 = t4
local t5 = {
	Type = "Quickscope",
	Value = 10,
	Display = "Quickscope Kill"
}
count = count + 1
t5.Order = count
t5.DependFinishedQuests = { "Q1" }
t3.Q2 = t5
local t6 = {
	Type = "KillStreak5",
	Value = 2,
	Display = "Penta Kill"
}
count = count + 1
t6.Order = count
t6.DependFinishedQuests = { "Q2" }
t3.Q3 = t6
t2.Quests = t3
t2.Reward = RewardUtils.weapon("Kukri"):setRewardData("Untradeable", true)
t.FreeKukri = t2
return t