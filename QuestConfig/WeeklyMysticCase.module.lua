-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.QuestConfig.WeeklyMysticCase

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local RewardUtils = require(ReplicatedStorage.Util.RewardUtils)
local count = 1
local function genOrder() --[[ genOrder | Line: 8 | Upvalues: count (ref) ]]
	count = count + 1
	return count
end
local t = {}
local t2 = {
	Display = "Thursday Free Mystic Case Task",
	ManualReward = true
}
local t3 = {}
local t4 = {
	Type = "MeleeKill",
	Value = 20,
	Display = "Melee Kill"
}
count = count + 1
t4.Order = count
t3.MeleeKill = t4
local t5 = {
	Type = "Headshot",
	Value = 20,
	Display = "Headshot Kill"
}
count = count + 1
t5.Order = count
t3.Headshot = t5
t2.Quests = t3
t2.Reward = {
	RewardType = "WeeklyMysticCase",
	Reward = {
		Gacha = { RewardUtils.gacha("ReleaseCase_Mystic"):setRewardData("Untradeable", true), RewardUtils.gacha("StrikeCase_Mystic"):setRewardData("Untradeable", true) },
		Status = { RewardUtils.status(Constant.Status.WeeklyRaffleTicket, 30) }
	}
}
t.WeeklyMysticCase = t2
return t