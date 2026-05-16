-- Ximmy's Sexy Script Decompiler
-- Original: ReplicatedStorage.Config.ShopConfig.LimitedBundle

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Constant = require(ReplicatedStorage.Constant)
local t = {}
(function(p1) --[[ loadLimitedBundle | Line: 7 | Upvalues: t (copy), Constant (copy) ]]
	if p1 then
		local v1 = require(p1)
		local v2 = v1.StartTime or 0
		local Timeout = v1.Timeout
		t[v1.Product.Standard] = {
			Display = v1.StandardDisplay,
			LimitedProduct = v1.LimitedProduct.Standard,
			Reward = v1.Standard,
			Render = {
				RewardType = "LimitedBundle",
				Reward = {
					Config = p1
				}
			},
			Price = {
				Eco = Constant.Robux
			},
			StartTime = v2,
			Timeout = Timeout
		}
		t[("%s_TradeToken"):format(v1.Product.Standard)] = {
			Display = v1.StandardDisplay,
			LimitedProduct = v1.LimitedProduct.Standard,
			Reward = v1.Standard,
			Render = {
				RewardType = "LimitedBundle",
				Reward = {
					Config = p1
				}
			},
			Price = {
				Value = 7490,
				Eco = Constant.Status.Eco_TradeToken
			},
			StartTime = v2,
			Timeout = Timeout
		}
		t[v1.Product.ST] = {
			Display = v1.STDisplay,
			LimitedProduct = v1.LimitedProduct.ST,
			Reward = v1.ST,
			Render = {
				RewardType = "LimitedBundle",
				Reward = {
					ST = true,
					Config = p1
				}
			},
			Price = {
				Eco = Constant.Robux
			},
			StartTime = v2,
			Timeout = Timeout
		}
		t[("%s_TradeToken"):format(v1.Product.ST)] = {
			Display = v1.STDisplay,
			LimitedProduct = v1.LimitedProduct.ST,
			Reward = v1.ST,
			Render = {
				RewardType = "LimitedBundle",
				Reward = {
					ST = true,
					Config = p1
				}
			},
			Price = {
				Value = 12990,
				Eco = Constant.Status.Eco_TradeToken
			},
			StartTime = v2,
			Timeout = Timeout
		}
	end
end)(ReplicatedStorage.Config.Event:FindFirstChild("LimitedBundleEvent"))
return t