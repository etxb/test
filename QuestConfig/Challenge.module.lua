-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.QuestConfig.Challenge

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
require(ReplicatedStorage.Constant)
require(ReplicatedStorage.Config.Config)
require(ReplicatedStorage.Util.RewardUtils);
({
	ItemSku = "WeaponChallenge"
}).TransType = Enum.AnalyticsEconomyTransactionType.Gameplay
local v1 = 0
local function genOrder() --[[ genOrder | Line: 11 | Upvalues: v1 (ref) ]]
	v1 = v1 + 1
	return v1
end
return {}