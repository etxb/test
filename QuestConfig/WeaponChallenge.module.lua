-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.QuestConfig.WeaponChallenge

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local Config = require(ReplicatedStorage.Config.Config)
require(ReplicatedStorage.Config.GachaConfig)
local WeaponConfig = require(ReplicatedStorage.Config.WeaponConfig)
require(ReplicatedStorage.Util.TableUtils)
local RewardUtils = require(ReplicatedStorage.Util.RewardUtils)
local t = {
	ItemSku = "WeaponChallenge",
	TransType = Enum.AnalyticsEconomyTransactionType.Gameplay
}
local t2 = {}
local t3 = {
	{
		{ 200, 2000 },
		{ "KillStreak2", "Double Kill", 30, 2000 }
	},
	{
		{ 400, 4000 },
		{ "KillStreak3", "Triple Kill", 30, 4000 }
	},
	{
		{ 800, 6000 },
		{ "KillStreak4", "Quadra Kill", 30, 6000 }
	},
	{
		{ 1500, 8000 },
		{ "KillStreak5", "Penta Kill", 30, 8000 }
	},
	{
		{ 3000, 10000 },
		{ "KillStreak6+", "Hexa Kill or above", 30, 10000 }
	}
}
local v1 = #t3
local t4 = {}
local function createWeaponChallenge(p1) --[[ createWeaponChallenge | Line: 28 | Upvalues: WeaponConfig (copy), Constant (copy), t3 (copy), t2 (copy), v1 (copy), RewardUtils (copy), t (copy), t4 (copy) ]]
	local v12 = WeaponConfig[p1]
	if v12 and v12.WeaponType == Constant.WeaponType.Sniper then
		local t5 = {}
		local v2 = nil
		local t6 = {}
		local v3 = nil
		for v4, v5 in t3 do
			local v6 = ("C_K_%s_%d"):format(p1, v4)
			t2[v6] = {
				Challenge = true,
				RewardDisplay = "Credits",
				ManualReward = true,
				ChallengeWeapon = p1,
				DependFinishedQuests = { v3 },
				Display = ("Kills Challenge (%d/%d)"):format(v4, v1),
				ChallengeIndex = v4,
				Quests = {
					_Quest = {
						Type = ("Kill_%s"):format(p1),
						Value = v5[1][1],
						Display = ("Kill %d Players"):format(v5[1][1])
					}
				},
				Reward = RewardUtils.coin(v5[1][2], t)
			}
			table.insert(t5, v6)
			local v7 = ("C_KS_%s_%d"):format(p1, v4)
			t2[v7] = {
				Challenge = true,
				RewardDisplay = "Credits",
				ManualReward = true,
				ChallengeWeapon = p1,
				DependFinishedQuests = { v2 },
				Display = ("Kill Streak Challenge (%d/%d)"):format(v4, v1),
				ChallengeIndex = v4,
				Quests = {
					_Quest = {
						Type = ("%s_%s"):format(v5[2][1], p1),
						Value = v5[2][3],
						Display = ("Achieve %d %s"):format(v5[2][3], v5[2][2])
					}
				},
				Reward = RewardUtils.coin(v5[2][4], t)
			}
			table.insert(t6, v7)
			t4[p1] = {
				Kill = t5,
				KillStreak = t6
			}
			v2, v3 = v7, v6
		end
	end
end
for v2, v3 in Config.Weapon.BaseWeaponOrder do
	createWeaponChallenge(v2)
end
return setmetatable(t2, {
	__index = {
		WeaponChallenges = t4
	}
})