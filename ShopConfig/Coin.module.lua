-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.ShopConfig.Coin

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
local RewardUtils = require(ReplicatedStorage.Util.RewardUtils)
local t = {}
local function createCoinProduct(p1, p2, p3, p4) --[[ createCoinProduct | Line: 10 | Upvalues: Constant (copy), RunService (copy), t (copy), RewardUtils (copy) ]]
	local v1 = ("Coin_T%d"):format(p1)
	if Constant.Product[v1] then
		t[v1] = {
			Display = ("Credits - Tier %d"):format(p1),
			Reward = RewardUtils.coin(p2, {
				TransType = Enum.AnalyticsEconomyTransactionType.IAP,
				ItemSku = ("Coin_T%d"):format(p1)
			}),
			Price = {
				Eco = Constant.Robux,
				Value = p3
			},
			CoinExtra = p4
		}
	elseif RunService:IsServer() then
		warn("\228\186\167\229\147\129", v1, "\228\184\141\229\173\152\229\156\168")
	end
end
createCoinProduct(1, 1200, 40)
createCoinProduct(2, 6300, 200, 0.05)
createCoinProduct(3, 19800, 600, 0.1)
createCoinProduct(4, 34500, 1000, 0.15)
createCoinProduct(5, 72000, 2000, 0.2)
createCoinProduct(6, 150000, 4000, 0.25)
return t