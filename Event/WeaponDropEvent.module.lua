-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.Event.WeaponDropEvent

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
local GachaConfig = require(ReplicatedStorage.Config.GachaConfig)
local t = {
	Chance = 0.05,
	HeadshotChance = 0.01,
	KillStreakChance = 0.005,
	DayDropLimit = 8,
	Pity = 20,
	DropGacha = { "StrikeCase", "ReleaseCase" },
	RarityWeight = {
		[Constant.Rarity.UnCommon] = 250,
		[Constant.Rarity.Rare] = 678,
		[Constant.Rarity.Epic] = 60,
		[Constant.Rarity.Legendary] = 10,
		[Constant.Rarity.Mystic] = 2
	},
	Timeout = DateTime.fromUniversalTime(2099, 3, 30).UnixTimestamp
}
local t2 = {}
local t3 = {}
for v1, v2 in t.RarityWeight do
	local t4 = {
		RewardType = "Random",
		Reward = {
			Random = true
		},
		Weight = v2,
		_Rarity = v1
	}
	t2[v1] = t4.Reward
	table.insert(t3, t4)
end
table.sort(t3, function(p1, p2) --[[ Line: 32 | Upvalues: Constant (copy) ]]
	return Constant.RarityOrder[p1._Rarity] < Constant.RarityOrder[p2._Rarity]
end)
for v3, v4 in t.DropGacha do
	local v5 = GachaConfig[v4]
	if v5 and v5.RewardsByRarity then
		for v6, v7 in t2 do
			local v8 = v5.RewardsByRarity[v6]
			if v8 and #v8 ~= 0 then
				table.move(v8, 1, #v8, #v7 + 1, v7)
			end
		end
	end
end
t.RollingRewards = t3
if RunService:IsStudio() then
	t.Chance = 0.5
end
return t