-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.ShopConfig.TradeToken

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Constant = require(ReplicatedStorage.Constant)
local RewardUtils = require(ReplicatedStorage.Util.RewardUtils)
local t = {}
local function createCoinProduct(p1, p2, p3) --[[ createCoinProduct | Line: 10 | Upvalues: Constant (copy), RunService (copy), RewardUtils (copy), t (copy) ]]
	local v1 = ("TradeToken_T%d"):format(p1)
	if Constant.Product[v1] then
		local t2 = {
			Display = ("Cash - Tier %d"):format(p1),
			Reward = {
				RewardType = "All",
				Reward = {
					RewardUtils.status(Constant.Status.Eco_TradeToken, p2, {
						TransType = Enum.AnalyticsEconomyTransactionType.IAP,
						ItemSku = ("TradeToken_T%d"):format(p1)
					}),
					{
						RewardType = "RobuxSpent_TradeToken",
						Reward = {
							Value = p2 / 10
						}
					}
				}
			},
			Price = {
				Eco = Constant.Robux
			}
		}
		if p3 then
			t2.Reward = {
				RewardType = "All",
				Reward = { t2.Reward, p3 }
			}
		end
		t[v1] = t2
	elseif RunService:IsServer() then
		warn("\228\186\167\229\147\129", v1, "\228\184\141\229\173\152\229\156\168")
	end
end
createCoinProduct(1, 1000)
createCoinProduct(2, 2000)
createCoinProduct(3, 10000)
createCoinProduct(4, 50000)
createCoinProduct(5, 250000)
return t