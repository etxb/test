-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.QuestConfig.Daily

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
local RewardUtils = require(ReplicatedStorage.Util.RewardUtils)
local t = {
	ItemSku = "DailyQuest",
	TransType = Enum.AnalyticsEconomyTransactionType.Gameplay
}
local count = 0
local function genOrder() --[[ genOrder | Line: 11 | Upvalues: count (ref) ]]
	count = count + 1
	return count
end
local t2 = {}
local t3 = {
	Display = "Daily Task"
}
local t4 = {}
local t5 = {
	Type = "Kill",
	Value = 50,
	Display = "Eliminations"
}
count = count + 1
t5.Order = count
t5.Reward = RewardUtils.coin(500, t)
t5.VIPReward = RewardUtils.coin(500 * (1 + Config.VIP.NonGameCoin), t)
t4.Kill20 = t5
local t6 = {
	Type = "KillStreak3",
	Value = 5,
	Display = "Get 3 Streak"
}
count = count + 1
t6.Order = count
t6.Reward = RewardUtils.coin(500, t)
t6.VIPReward = RewardUtils.coin(500 * (1 + Config.VIP.NonGameCoin), t)
t4.KillStreak3 = t6
local t7 = {
	Type = "FinishGame",
	Value = 3,
	Display = "Play 3 Rounds"
}
count = count + 1
t7.Order = count
t7.Reward = RewardUtils.coin(500, t)
t7.VIPReward = RewardUtils.coin(500 * (1 + Config.VIP.NonGameCoin), t)
t4.Play2 = t7
t3.Quests = t4
t3.ManualReset = {
	Value = 99,
	Eco = Constant.Status.Eco_TradeToken
}
t3.WeeklyRaffleTicket = {
	Value = 1,
	Max = 3
}
t2.Daily = t3
return t2