-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.QuestConfig.Weekly

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local RewardUtils = require(ReplicatedStorage.Util.RewardUtils)
local t = {
	ItemSku = "WeeklyQuest",
	TransType = Enum.AnalyticsEconomyTransactionType.Gameplay
}
local count = 0
local function genOrder() --[[ genOrder | Line: 11 | Upvalues: count (ref) ]]
	count = count + 1
	return count
end
local t2 = {}
local t3 = {
	Display = "Weekly Task"
}
local t4 = {}
local t5 = {
	Type = "Kill",
	Value = 400,
	Display = "Kill 400"
}
count = count + 1
t5.Order = count
t5.Reward = RewardUtils.coin(2000, t)
t5.VIPReward = RewardUtils.coin(2000 * (1 + Config.VIP.NonGameCoin), t)
t4.Kill400 = t5
local t6 = {
	Type = "FinishGame",
	Value = 20,
	Display = "Play 20 Rounds"
}
count = count + 1
t6.Order = count
t6.Reward = RewardUtils.coin(2000, t)
t6.VIPReward = RewardUtils.coin(2000 * (1 + Config.VIP.NonGameCoin), t)
t4.Play20 = t6
local t7 = {
	Type = "Headshot",
	Value = 100,
	Display = "Headshot Kill"
}
count = count + 1
t7.Order = count
t7.Reward = RewardUtils.coin(2000, t)
t7.VIPReward = RewardUtils.coin(2000 * (1 + Config.VIP.NonGameCoin), t)
t4.Headshot100 = t7
t3.Quests = t4
t3.WeeklyRaffleTicket = {
	Value = 7,
	Max = 21
}
t2.Weekly = t3
return t2